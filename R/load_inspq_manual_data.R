

#' Importer le dernier fichier manual_data de inspq et le nettoyer
#'
#' @return data frame
#' @export
#'
#' @examples load_inspq_manual_data()
load_inspq_manual_data <- function(){
  latest_combine <- readr::read_csv("https://inspq.qc.ca/sites/default/files/covid/donnees/manual-data.csv", skip =23) %>%
    janitor::clean_names() %>%
    dplyr::mutate(date = lubridate::dmy(date)) %>%
    dplyr::select(date, hospits, hospits_ancien, si, volumetrie)
}


