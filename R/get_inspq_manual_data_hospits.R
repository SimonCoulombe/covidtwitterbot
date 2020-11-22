

#' Importer le dernier fichier manual_data de inspq et le nettoyer
#'
#' @return data frame
#' @export
#'
#' @examples get_inspq_manual_data_hospits()
get_inspq_manual_data_hospits <- function(){
  suppressWarnings(
    latest_combine <- readr::read_csv("https://inspq.qc.ca/sites/default/files/covid/donnees/manual-data.csv", skip =23) %>%
      janitor::clean_names() %>%
      dplyr::mutate(date = lubridate::dmy(date)) %>%
      dplyr::select(date, hospits, hospits_ancien, si, volumetrie)
  )
  latest_combine
}


#' get_inspq_manual_data_tableau_accueil
#'
#' @return
#' @export
#'
#' @examples get_inspq_manual_data_tableau_accueil()
get_inspq_manual_data_tableau_accueil <- function(){
  suppressWarnings(
    tableau_accueil <- readr::read_csv("https://inspq.qc.ca/sites/default/files/covid/donnees/manual-data.csv", skip =1, n_max = 2) %>%
      select(cas, deces, hospit, soins, gueris, analyses) %>%
      ungroup() %>%
      dplyr::mutate_if(
        is.character, ~ as.numeric(stringr::str_replace_all(., " ", ""))
      ) %>%
      mutate(type = c("cumulatif", "quotidien"))
  )
  tableau_accueil
}
