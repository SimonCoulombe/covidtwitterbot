


#' get_raw_vaccination_data downloads vaccination data from inspq
#'
#' @return
#' @export
#'
#' @examples
  get_raw_vaccination_data <- function() {

    current_csv <- readr::read_csv("https://www.inspq.qc.ca/sites/default/files/covid/donnees/vaccination.csv",
                                   col_types = readr::cols(
                                     Date = readr::col_date(),
                                     Regroupement = readr::col_character(),
                                     Croisement = readr::col_character(),
                                     Nom = readr::col_character(),
                                     .default = readr::col_number()
                                   )
    ) %>%
      janitor::clean_names() %>%
      rename(date_report = date)  %>%
      mutate(quo_pct_vaccin =  if_else(vac_cum_tot_n >0, cvac_cum_tot_1_p * vac_quo_tot_n /vac_cum_tot_n ,0, 0))




    return(current_csv)
  }

