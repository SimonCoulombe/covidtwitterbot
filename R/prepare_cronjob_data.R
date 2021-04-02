
import_unique_csvs_from_cronjob <- function(mypath = "~/cronjob/tableau-rls/",
                                            skip = 0,
                                            n_max = Inf,
                                            locale = default_locale(),
                                            csv_date_start = -19,
                                            csv_date_end = -12,
                                            delim = ",") {
  pouet <- list.files(
    path = mypath,
    pattern = ".csv$",
    full.names = TRUE
  )

  if (mypath == "~/cronjob/inspq-tableau-rls-new/") {
    csvs <- purrr::map(
      pouet, read_delim,
      skip = skip, n_max = n_max, locale = locale, delim = delim,
      col_types = cols(
        No = col_character(),
        RSS = col_character(),
        NoRLS = col_character(),
        RLS = col_character(),
        .default = col_number()
      )
    )
  } else {
    csvs <- purrr::map(pouet, read_delim, skip = skip, n_max = n_max, locale = locale, delim = delim)
  }

  keep <- rep(TRUE, length(csvs))
  for (i in seq(from = 2, to = length(csvs))) {
    if (isTRUE(dplyr::all_equal(csvs[[i]], csvs[[i - 1]]))) {
      keep[i] <- FALSE
    }
  }
  dates <- lubridate::ymd(pouet %>% str_sub(start = csv_date_start, end = csv_date_end))
  datetimes <- lubridate::ymd_hms(
    paste0(
      pouet %>% str_sub(
        start = -19, end = -12
      ), pouet %>%
        str_sub(start = -10, end = -5)
    )
  )

  return(list(datetimes = datetimes[keep], csvs = csvs[keep]))
}

#' Title
#'
#' @param datetimes
#' @param csvs
#'
#' @return
#' @export
#'
#' @examples
create_date_report_from_datetimes <- function(datetimes, csvs) {
  dates_fixed <- tibble::tibble(download_datetime = datetimes) %>%
    mutate(
      download_hour = lubridate::hour(download_datetime),
      download_date = lubridate::date(download_datetime),
      report_date = dplyr::if_else(download_hour >= 8, download_date, download_date - 1) # au milieu de la nuit tu es le rapport d'hier
    ) %>%
    arrange(desc(download_datetime)) %>%
    mutate(
      report_date_lag = lag(report_date),
      # si j'ai deux rapports différents dans la même journée, le premier est celui de la veille
      report_date_fixed = dplyr::if_else(report_date == report_date_lag, report_date - 1, report_date, report_date)
    ) %>%
    arrange(download_datetime)

  gaa <- purrr::map2(
    csvs, datetimes,
    ~ .x %>% mutate(download_datetime = .y)
  )
  gaaa <- purrr::map2(
    gaa, dates_fixed$report_date_fixed,
    ~ .x %>% mutate(date_report = .y)
  )

  rls_data <- gaaa
}


#' prepare_cronjob_data_nobindrows
#'
#' @param mypath
#' @param skip
#' @param n_max
#' @param locale
#' @param csv_date_start
#' @param csv_date_end
#' @param delim
#'
#' @return
#' @export
#'
#' @examples
prepare_cronjob_data_nobindrows <- function(mypath = "~/cronjob/tableau-rls/",
                                            skip = 0,
                                            n_max = Inf,
                                            locale = default_locale(),
                                            csv_date_start = -19,
                                            csv_date_end = -12,
                                            delim = ",") {
  z <- import_unique_csvs_from_cronjob(
    mypath = mypath,
    skip = skip,
    n_max = n_max,
    locale = locale,
    csv_date_start = csv_date_start,
    csv_date_end = csv_date_end,
    delim = delim
  )

  create_date_report_from_datetimes(z$datetimes, z$csvs)
}
