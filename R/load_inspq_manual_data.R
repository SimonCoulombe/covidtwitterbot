

#' Importer le dernier fichier manual_data de inspq et le nettoyer
#'
#' @param path string
#'
#' @return data frame
#' @export
#'
#' @examples
load_inspq_manual_data <- function(path = "~/cronjob/inspq-manual-data/"){
  pouet <- list.files(
    path = path,
    pattern = ".csv$",
    full.names = TRUE)

  csvs <- purrr::map(pouet, readr::read_csv, skip =23)

  datetimes <- lubridate::ymd_hms(
    paste0(
      pouet %>% str_sub(
        start=-19, end = -12),pouet %>%
        str_sub(start=-10, end = -5) ))

  latest_combine <- csvs[which.max(datetimes)] %>% .[[1]] %>% janitor::clean_names() %>% mutate(date = lubridate::dmy(date))
}


