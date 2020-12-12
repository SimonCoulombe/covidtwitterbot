
#' get_jeanpaulrsoucy_tableau_rls_new
#'
#' @return
#' @importFrom httr GET stop_for_status content
#' @importFrom furrr future_map
#' @importFrom future plan availableCores
#' @importFrom dplyr glimpse
#' @examples
get_jeanpaulrsoucy_tableau_rls_new <- function(){
  #https://stackoverflow.com/questions/25485216/how-to-get-list-files-from-a-github-repository-folder-using-r
  req <- GET("https://api.github.com/repos/jeanpaulrsoucy/covid-19-canada-gov-data-montreal/git/trees/master?recursive=1")
  stop_for_status(req)
  filelist <- unlist(lapply(content(req)$tree, "[", "path"), use.names = F)
  liste_tableau_rls_new <- grep("cases-by-rss-and-rls/tableau-rls-new_", filelist, value = TRUE, fixed = TRUE)
  plan("multisession", workers = availableCores()-1)

  suppressWarnings(
    csvs <-
      furrr::future_map(
        liste_tableau_rls_new,
        ~readr::read_csv(
          paste0("https://raw.githubusercontent.com/jeanpaulrsoucy/covid-19-canada-gov-data-montreal/master/", .x),
          col_types= readr::cols(
            No = readr::col_character(),
            RSS = readr::col_character() ,
            NoRLS = readr::col_character(),
            RLS= readr::col_character(),
            .default = readr::col_number()
          )
        )
      )
  )
  years =  stringr::str_sub(liste_tableau_rls_new, -20,-17)
  months = stringr::str_sub(liste_tableau_rls_new,-15,-14)
  days = stringr::str_sub(liste_tableau_rls_new,-12,-11)
  hours = stringr::str_sub(liste_tableau_rls_new,-9, -8)
  minutes = stringr::str_sub(liste_tableau_rls_new,-6, -5)
  datetimes <- lubridate::ymd_hm(paste(years, months, days, hours, minutes))

  # add current csv from inspq

  current_csv <- readr::read_csv("https://inspq.qc.ca/sites/default/files/covid/donnees/tableau-rls-new.csv",
                           col_types= readr::cols(
                             No = readr::col_character(),
                             RSS = readr::col_character() ,
                             NoRLS = readr::col_character(),
                             RLS= readr::col_character(),
                             .default = readr::col_number()
                           ))
  current_datetime <- lubridate::ymd_hms(Sys.time())


  csvs <- c(csvs, list(current_csv))
  datetimes  <- c(datetimes, current_datetime)
  # drop duplicates
  keep <- rep(TRUE, length(csvs))
  for (i in seq(from=2, to = length(csvs))){

    if ( isTRUE(dplyr::all_equal(csvs[[i]],csvs[[i-1]]))){
      keep[i]= FALSE
    }
  }

  return(list(datetimes = datetimes[keep], csvs = csvs[keep]))
}

#' get_historical_tableau_rls_new_from_github
#'
#' @return
#'
#' @examples
get_historical_tableau_rls_new_from_github <- function(){
  z <- get_jeanpaulrsoucy_tableau_rls_new()
  pouet <- create_date_report_from_datetimes(z$datetimes, z$csvs) %>% bind_rows()
  tableau_rls_new <- pouet %>%
    rename(cumulative_cases = Cas) %>%
    filter(!is.na(NoRLS), RLS != "Total") %>%
    mutate(
      RSS = case_when(
        RSS == "01 - Bas-Saint-Laurent" ~  "01 - Bas-St-Laurent",
        RSS == "02 - Saguenay–Lac-Saint-Jean" ~ "02 - Saguenay – Lac-St-Jean",
        RSS == "04 - Mauricie et Centre-du-Québec" ~ "04 - Mauricie-et-Centre-du-Québec",
        TRUE ~ RSS
      )

    ) %>%
    select(RSS, RLS, cumulative_cases, date_report) %>%
    filter(!is.na(cumulative_cases))

  tableau_rls_new
}


#' get_raw_rls_data - combine RLS data from 3 sources to get the best possible historical data
#'
#' @return
#' @export
#'
#' @examples
get_raw_rls_data <- function(){

  historical_tableau_rls_new <- get_historical_tableau_rls_new_from_github()
  #current_tableau_rls_new <- get_current_tableau_rls_new_from_inspq()

  all_rls_tables <- bind_rows(
    rls_claude %>%
      mutate(source = "bouchecl") %>%
      filter(!(date_report %in% unique(tableau_rls$date_report))) ,
    tableau_rls %>%
      mutate(source = "cronjob"),
    historical_tableau_rls_new %>%
      mutate(source= "cronjob_new") #%>%
      #filter(!date_report %in% unique(current_tableau_rls_new$date_report)),
    #current_tableau_rls_new %>%
      #mutate(source = "current")
  )
}


#' fill_missing_dates_and_create_daily_counts_for_rls_data
#'
#' @param rls_data
#'
#' @return
#' @importFrom tidyr fill complete replace_na
#' @importFrom dplyr if_else first
#' @importFrom stringr str_replace str_extract
#'
#' @examples
fill_missing_dates_and_create_daily_counts_for_rls_data <- function(rls_data){

  rls <- rls_data %>%
    group_by(RSS,RLS) %>%
    arrange( RSS,RLS, desc(date_report)) %>% ## descending date to fix cumulative
    mutate(fix_cummin = cummin(tidyr::replace_na(cumulative_cases, Inf))) %>%
    mutate(cumulative_cases = if_else(cumulative_cases > fix_cummin, fix_cummin, cumulative_cases, cumulative_cases)) %>% ## cumulative can't be bigger than next day.. if so reduce to next day level.
    arrange( RSS,RLS, date_report) %>%
    mutate(slope = (lead(cumulative_cases)- cumulative_cases) / as.numeric(lead(date_report) - date_report))  %>%
    tidyr::complete(date_report = seq.Date(min(date_report), max(date_report), by = "day")) %>%
    tidyr::fill(slope, .direction= "down") %>%
    mutate(cumulative_cases = if_else(!is.na(cumulative_cases), cumulative_cases, floor(first(cumulative_cases) + cumsum(slope) - slope))    ) %>%
    select(-slope) %>%
    mutate(cases = cumulative_cases - lag(cumulative_cases)) %>%
    ungroup() %>%
    filter(!is.na(cases))%>%
    mutate(shortname_rls = str_replace(str_extract(str_replace(RLS, "RLS de ","RLS " ),"RLS.+"),"RLS ", "")) %>%
    left_join(rls_population) %>%
    group_by(RSS, RLS) %>%
    arrange(date_report) %>%
    mutate(cases_per_100k = cases * 1e5 / Population,
           cases_last_7_days = (cumulative_cases - lag(cumulative_cases,7)),
           previous_cases_last_7_days = lag(cases_last_7_days, 7),
           cases_last_7_days_per_100k = cases_last_7_days * 1e5 / Population,
           RLS_code = str_extract(RLS, "^\\d+"),
           cases_per_1M = ifelse(!is.na(cases_last_7_days),cases_last_7_days / 7  * 1000000 / Population, 0),
           last_cases_per_1M = max(cases_per_1M * (date_report == max(date_report)), na.rm = TRUE),
           previous_cases_per_1M = max(cases_per_1M * (date_report == max(date_report)-7), na.rm = TRUE),
           color_per_pop = factor(
             case_when(
               is.na(last_cases_per_1M) ~ "moins de 20 cas par million",
               last_cases_per_1M < 20 ~ "moins de 20 cas par million",
               last_cases_per_1M < 60  ~ "entre 20 et 60 cas par million",
               last_cases_per_1M < 100 ~  "entre 60 et 100 cas par million",
               last_cases_per_1M >= 100  ~ "plus de 100 cas par million"
             ),
             levels = c("moins de 20 cas par million", "entre 20 et 60 cas par million", "entre 60 et 100 cas par million", "plus de 100 cas par million"))
    )%>%
    ungroup() %>%
    mutate(pop = Population,
           RLS_petit_nom = str_replace(RLS, "RLS des |RLS de la |RLS du |RLS de l' |RLS de |RLS ", "")
    )

  rls
}


#' get_rls_data
#'
#' @return
#' @export
#'
#' @examples
get_rls_data <- function(){

  get_raw_rls_data() %>%
    fill_missing_dates_and_create_daily_counts_for_rls_data()
}


