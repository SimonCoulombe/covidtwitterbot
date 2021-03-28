#' get_inspq_covid19_hist
#'
#' @return
#' @export
#' @importFrom readr cols col_character col_double
#' @importFrom dplyr mutate_at vars
#' @importFrom tidyselect starts_with
#'
#' @examples
#' get_inspq_covid19_hist()
get_inspq_covid19_hist <- function() {
  attempt <- 0
  pouet <- NULL
  while (is.null(pouet) && attempt <= 100) {
    attempt <- attempt + 1
    message("attempt: ", attempt)
    Sys.sleep(3)
    try(
      pouet <- readr::read_csv("https://inspq.qc.ca/sites/default/files/covid/donnees/covid19-hist.csv",
        col_types = cols(
          Date = col_character(),
          Regroupement = col_character(),
          Croisement = col_character(),
          Nom = col_character(),
          .default = col_double()
        )
      )
    )
  }

  pouet2 <- pouet %>%
    dplyr::filter(Date != "Date inconnue") %>%
    dplyr::mutate(date = lubridate::ymd(Date)) %>%
    dplyr::left_join(
      tibble::tribble(
        ~Regroupement, ~Nom, ~type, ~groupe,
        "Groupe d'âge", "0-9 ans", "groupe_age", "0 à 9 ans",
        "Groupe d'âge", "10-19 ans", "groupe_age", "10 à 19 ans",
        "Groupe d'âge", "20-29 ans", "groupe_age", "20 à 29 ans",
        "Groupe d'âge", "30-39 ans", "groupe_age", "30 à 39 ans",
        "Groupe d'âge", "40-49 ans", "groupe_age", "40 à 49 ans",
        "Groupe d'âge", "50-59 ans", "groupe_age", "50 à 59 ans",
        "Groupe d'âge", "60-69 ans", "groupe_age", "60 à 69 ans",
        "Groupe d'âge", "70-79 ans", "groupe_age", "70 à 79 ans",
        "Groupe d'âge", "80-89 ans", "groupe_age", "80 à 89 ans",
        "Groupe d'âge", "90 ans et plus", "groupe_age", "90 ans et +",
        "Groupe d'âge", "Inconnu", "groupe_age", "Âge inconnu",
        "Groupe d'âge", "Total", "groupe_age", "Total",
        "Groupe de région", "Autres régions", "region_montreal", "Autres régions",
        "Groupe de région", "Ceinture de Montréal", "region_montreal", "Ceinture de Montréal",
        "Groupe de région", "Hors Québec", "region_montreal", "Hors Québec",
        "Groupe de région", "Inconnu", "region_montreal", "Inconnue",
        "Groupe de région", "Montréal et Laval", "region_montreal", "Montréal et Laval",
        "Région", "08 - Abitibi-Témiscamingue", "region", "08 Abitibi-Témiscamingue",
        "Région", "01 - Bas-Saint-Laurent", "region", "01 Bas-Saint-Laurent",
        "Région", "03 - Capitale-Nationale", "region", "03 Capitale-Nationale",
        "Région", "12 - Chaudière-Appalaches", "region", "12 Chaudière-Appalaches",
        "Région", "09 - Côte-Nord", "region", "09 Côte-Nord",
        "Région", "Ensemble du Québec", "region", "Ensemble du Québec",
        "Région", "05 - Estrie", "region", "05 Estrie",
        "Région", "11 - Gaspésie-Îles-de-la-Madeleine", "region", "11 Gaspésie-Îles-de-la-Madeleine",
        "Région", "Hors Québec", "region", "Hors Québec",
        "Région", "Inconnu", "region", "Inconnue",
        "Région", "14 - Lanaudière", "region", "14 Lanaudière",
        "Région", "15 - Laurentides", "region", "15 Laurentides",
        "Région", "13 - Laval", "region", "13 Laval",
        "Région", "04 - Mauricie et Centre-du-Québec", "region", "04 Mauricie et Centre-du-Québec",
        "Région", "16 - Montérégie", "region", "16 Montérégie",
        "Région", "06 - Montréal", "region", "06 Montréal",
        "Région", "10 - Nord-du-Québec", "region", "10 Nord-du-Québec",
        "Région", "17 - Nunavik", "region", "17 Nunavik",
        "Région", "07 - Outaouais", "region", "07 Outaouais",
        "Région", "02 - Saguenay-Lac-Saint-Jean", "region", "02 Saguenay-Lac-Saint-Jean",
        "Région", "18 - Terres-Cries-de-la-Baie-James", "region", "18 Terres-Cries-de-la-Baie-James",
        "Sexe", "Féminin", "sexe", "Féminin",
        "Sexe", "Inconnu", "sexe", "Sexe inconnu",
        "Sexe", "Masculin", "sexe", "Masculin",
        "Sexe", "Total", "sexe", "Total"
      )
    )


  pouet3 <- pouet2 %>%
    dplyr::mutate(
      cas_totaux_cumul = cas_cum_tot_n, # ces trois noms de variables sont requis par prep_data
      cas_totaux_quotidien = cas_quo_tot_n,
      deces_totaux_quotidien = dec_quo_tot_n
    )
  pouet3

  # tant qu'à faire on va greffer les populations, ça va être fait..


  populations_combine <-
    bind_rows(
      populations_age %>% rename(groupe = groupe_age) %>% mutate(Regroupement = "Groupe d'âge"), # groupe <-> pop quand c'estun groupe d'âge
      table_correspondances_health_region_quebec %>%
        select(groupe, health_region, health_region_short) %>%
        mutate(
          province = "Quebec",
          pr_region = paste0(province, "-", health_region)
        ) %>%
        left_join(populations %>% select(pr_region, pop)) %>%
        select(groupe, pop) %>%
        mutate(Regroupement = "Région") ## groupe <-> pop quand c'est une région
    )
  ## todo:  group <--> pop quand c'est un gender ou une grande région

  pouet4 <- pouet3 %>%
    left_join(populations_combine)

  ## les hospitalisations cumulatif + quotidien  de la dernière journée sont pas mises à jour, ainsi que les prélèvements (psi) quotidien pour la dernière journée.. je vais remplacer ces 0 (psi) et chiffres identiques à la veilleu (pour les hos) par des NA.

  pouet5 <- pouet4 %>%
    mutate_at(vars(starts_with("hos")), ~ if_else(date == max(date), NA_real_, ., NA_real_)) %>%
    mutate_at(vars(starts_with("psi_quo")), ~ if_else(date == max(date), NA_real_, ., NA_real_))

  pouet5
}
