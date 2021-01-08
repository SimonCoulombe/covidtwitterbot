
#' get_jeanpaulrsoucy_municipal
#'
#' @return
#' @importFrom httr GET stop_for_status content
#' @importFrom furrr future_map
#' @importFrom future plan availableCores
#' @importFrom dplyr glimpse
#' @importFrom readr read_delim locale
#' @examples
get_jeanpaulrsoucy_municipal <- function() {
  # https://stackoverflow.com/questions/25485216/how-to-get-list-files-from-a-github-repository-folder-using-r
  req <- GET("https://api.github.com/repos/jeanpaulrsoucy/covid-19-canada-gov-data-montreal/git/trees/master?recursive=1")
  stop_for_status(req)
  filelist <- unlist(lapply(content(req)$tree, "[", "path"), use.names = F)
  liste_municipal <- grep("montreal-cases-by-area/municipal", filelist, value = TRUE, fixed = TRUE)
  plan("multisession", workers = availableCores() - 1)



  suppressWarnings(
    csvs <-
      furrr::future_map(
        liste_municipal,
        ~ read_delim(
          paste0("https://raw.githubusercontent.com/jeanpaulrsoucy/covid-19-canada-gov-data-montreal/master/", .x),
          delim = ";",
          locale = locale(encoding = "Windows-1252"),
          col_types = readr::cols(.default = readr::col_character())
        )
      )
  )
  years <- stringr::str_sub(liste_municipal, -20, -17)
  months <- stringr::str_sub(liste_municipal, -15, -14)
  days <- stringr::str_sub(liste_municipal, -12, -11)
  hours <- stringr::str_sub(liste_municipal, -9, -8)
  minutes <- stringr::str_sub(liste_municipal, -6, -5)
  datetimes <- lubridate::ymd_hm(paste(years, months, days, hours, minutes))


  ## get current csv from montreal and append to github files ----
  current_csv <- read_delim(
    paste0("https://santemontreal.qc.ca/fileadmin/fichiers/Campagnes/coronavirus/situation-montreal/municipal.csv"),
    delim = ";",
    locale = locale(encoding = "Windows-1252"),
    col_types = readr::cols(.default = readr::col_character())
  )
  current_datetime <- lubridate::ymd_hms(Sys.time())
  csvs <- c(csvs, list(current_csv))
  datetimes <- c(datetimes, current_datetime)


  # drop duplicates
  keep <- rep(TRUE, length(csvs))
  for (i in seq(from = 2, to = length(csvs))) {
    if (isTRUE(dplyr::all_equal(csvs[[i]], csvs[[i - 1]]))) {
      keep[i] <- FALSE
    }
  }

  return(list(datetimes = datetimes[keep], csvs = csvs[keep]))
}

#' get_historical_municipal_from_github
#'
#' @return
#' @importFrom stringr str_replace_all
#' @examples
get_historical_municipal_from_github <- function() {
  z <- get_jeanpaulrsoucy_municipal()
  pouet <- create_date_report_from_datetimes(z$datetimes, z$csvs) %>% bind_rows()
  pouet %>%
    rename(arrondissement = "Arrondissement ou ville liée") %>%
    mutate(
      cumulative_cases = dplyr::coalesce(`Nombre de cas confirmés`, `Nombre de cas cumulatif, depuis le début de la pandémie`),
      cumulative_deaths = dplyr::coalesce(`Nombre de décès`, `Nombre de décès cumulatif, depuis le début de la pandémie`)
    ) %>%
    select(arrondissement, date_report, cumulative_cases, cumulative_deaths) %>%
    mutate_at(
      vars(starts_with("cumulative_")),
      ~ str_replace_all(., ",", ".") %>%
        str_replace_all(., "\\*", "") %>%
        str_replace_all(., "< 5", "0") %>%
        str_replace_all(., "n.p.", "") %>%
        as.numeric()
    ) %>%
    filter(!is.na(cumulative_cases))
}




#' get_raw_rls_data - combine RLS data from 3 sources to get the best possible historical data
#'
#' @return
#' @export
#'
#' @examples
get_raw_mtl_data <- function() {
  historical_municipal <- get_historical_municipal_from_github()

  all_rls_tables <- bind_rows(
    mtl_claude %>%
      mutate(source = "bouchecl") %>%
      filter(!(date_report %in% unique(c(historical_municipal$date_report)))) %>%
      select(arrondissement, date_report, cumulative_cases),

    historical_municipal %>%
      mutate(source = "github")
  )
}


#' Title
#'
#' @param rls_data
#'
#' @return
#' @export
#'
#' @examples
fill_missing_dates_and_create_daily_counts_for_mtl_data <- function(mtl_data) {
  mtl <- mtl_data %>%
    select(-cumulative_deaths) %>%
    group_by(arrondissement) %>%
    arrange(arrondissement, desc(date_report)) %>% ## descending date to fix cumulative
    mutate(fix_cummin = cummin(tidyr::replace_na(cumulative_cases, Inf))) %>%
    mutate(cumulative_cases = if_else(cumulative_cases > fix_cummin, fix_cummin, cumulative_cases, cumulative_cases)) %>% ## cumulative can't be bigger than next day.. if so reduce to next day level.
    arrange(arrondissement, date_report) %>%
    mutate(slope = (lead(cumulative_cases) - cumulative_cases) / as.numeric(lead(date_report) - date_report)) %>%
    tidyr::complete(date_report = seq.Date(min(date_report), max(date_report), by = "day")) %>%
    tidyr::fill(slope, .direction = "down") %>%
    mutate(cumulative_cases = if_else(!is.na(cumulative_cases), cumulative_cases, floor(first(cumulative_cases) + cumsum(slope) - slope))) %>%
    select(-slope) %>%
    mutate(cases = cumulative_cases - lag(cumulative_cases)) %>%
    ungroup() %>%
    filter(!is.na(cases)) %>%
    left_join(mtl_population) %>%
    group_by(arrondissement) %>%
    arrange(date_report) %>%
    mutate(
      cases_per_100k = cases * 1e5 / Population,
      cases_last_7_days = (cumulative_cases - lag(cumulative_cases, 7)),
      previous_cases_last_7_days = lag(cases_last_7_days, 7),
      cases_last_7_days_per_100k = cases_last_7_days * 1e5 / Population,
      cases_per_1M = ifelse(!is.na(cases_last_7_days), cases_last_7_days / 7 * 1000000 / Population, 0),
      last_cases_per_1M = max(cases_per_1M * (date_report == max(date_report)), na.rm = TRUE),
      previous_cases_per_1M = max(cases_per_1M * (date_report == max(date_report) - 7), na.rm = TRUE),
      color_per_pop = factor(
        case_when(
          is.na(last_cases_per_1M) ~ "moins de 20 cas par million",
          last_cases_per_1M < 20 ~ "moins de 20 cas par million",
          last_cases_per_1M < 60 ~ "entre 20 et 60 cas par million",
          last_cases_per_1M < 100 ~ "entre 60 et 100 cas par million",
          last_cases_per_1M >= 100 ~ "plus de 100 cas par million"
        ),
        levels = c("moins de 20 cas par million", "entre 20 et 60 cas par million", "entre 60 et 100 cas par million", "plus de 100 cas par million")
      )
    ) %>%
    ungroup() %>%
    mutate(pop = Population)

  mtl
}


#' get_mtl_data
#'
#' @return
#' @export
#'
#' @examples
get_mtl_data <- function() {
  get_raw_mtl_data() %>%
    fill_missing_dates_and_create_daily_counts_for_mtl_data()
}
