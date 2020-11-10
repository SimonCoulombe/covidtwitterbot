#' load_inspq_covid19_hist
#'
#' @return
#' @export
#'
#' @examples load_inspq_covid19_hist()
load_inspq_covid19_hist <- function() {

  pouet <- readr::read_csv("https://inspq.qc.ca/sites/default/files/covid/donnees/covid19-hist.csv")

  pouet2 <- pouet %>%
    dplyr::filter(Date != "Date inconnue") %>% dplyr::mutate(date = lubridate::ymd(Date)) %>%
    dplyr::left_join(
      tibble::tribble(
        ~Regroupement,                            ~Nom,                     ~type,                            ~groupe,
        "Groupe d'âge",                       "0-9 ans",                    "groupe_age",                        "0 à 9 ans",
        "Groupe d'âge",                     "10-19 ans",                    "groupe_age",                      "10 à 19 ans",
        "Groupe d'âge",                     "20-29 ans",                    "groupe_age",                      "20 à 29 ans",
        "Groupe d'âge",                     "30-39 ans",                    "groupe_age",                      "30 à 39 ans",
        "Groupe d'âge",                     "40-49 ans",                    "groupe_age",                      "40 à 49 ans",
        "Groupe d'âge",                     "50-59 ans",                    "groupe_age",                      "50 à 59 ans",
        "Groupe d'âge",                     "60-69 ans",                    "groupe_age",                      "60 à 69 ans",
        "Groupe d'âge",                     "70-79 ans",                    "groupe_age",                      "70 à 79 ans",
        "Groupe d'âge",                     "80-89 ans",                    "groupe_age",                      "80 à 89 ans",
        "Groupe d'âge",                "90 ans et plus",                    "groupe_age",                      "90 ans et +",
        "Groupe d'âge",                       "Inconnu",                    "groupe_age",                      "Âge inconnu",
        "Groupe d'âge",                         "Total",                    "groupe_age",                      "Total",
        "Groupe de région",                "Autres régions",               "region_montreal",                   "Autres régions",
        "Groupe de région",          "Ceinture de Montréal",               "region_montreal",             "Ceinture de Montréal",
        "Groupe de région",                   "Hors Québec",               "region_montreal",             "Hors Québec",
        "Groupe de région",                       "Inconnu",               "region_montreal",             "Inconnue",
        "Groupe de région",             "Montréal et Laval",              "region_montreal",                "Montréal et Laval",
        "Région",         "Abitibi-Témiscamingue",             "region",         "08 Abitibi-Témiscamingue",
        "Région",             "Bas-Saint-Laurent",             "region",             "01 Bas-Saint-Laurent",
        "Région",            "Capitale-Nationale",             "region",            "03 Capitale-Nationale",
        "Région",          "Chaudière-Appalaches",             "region",          "12 Chaudière-Appalaches",
        "Région",                     "Côte-Nord",             "region",                     "09 Côte-Nord",
        "Région",            "Ensemble du Québec",             "region",                     "Ensemble du Québec",
        "Région",                        "Estrie",             "region",                        "05 Estrie",
        "Région", "Gaspésie–Îles-de-la-Madeleine",            "region", "11 Gaspésie-Îles-de-la-Madeleine",
        "Région",                   "Hors Québec",            "region",                      "Hors Québec",
        "Région",                       "Inconnu",            "region",                         "Inconnue",
        "Région",                    "Lanaudière",            "region",                    "14 Lanaudière",
        "Région",                   "Laurentides",            "region",                   "15 Laurentides",
        "Région",                         "Laval",            "region",                         "13 Laval",
        "Région",  "Mauricie et Centre-du-Québec",            "region",  "04 Mauricie et Centre-du-Québec",
        "Région",                    "Montérégie",            "region",                    "16 Montérégie",
        "Région",                      "Montréal",            "region",                      "06 Montréal",
        "Région",                "Nord-du-Québec",             "region",                "10 Nord-du-Québec",
        "Région",                       "Nunavik",             "region",  "17 Nunavik",
        "Région",                     "Outaouais",               "region",                     "07 Outaouais",
        "Région",       "Saguenay–Lac-Saint-Jean",             "region",       "02 Saguenay-Lac-Saint-Jean",
        "Région", "Terres-Cries-de-la-Baie-James",              "region", "18 Terres-Cries-de-la-Baie-James",
        "Sexe",                       "Féminin",                      "sexe",                          "Féminin",
        "Sexe",                       "Inconnu",                      "sexe",                     "Sexe inconnu",
        "Sexe",                      "Masculin",                      "sexe",                         "Masculin",
        "Sexe",                       "Total",                         "sexe",                         "Total"
      )

    )


  pouet3 <- pouet2 %>%
    dplyr::mutate(
      cas_totaux_cumul = cas_cum_tot_n ,
      cas_totaux_quotidien = cas_quo_tot_n,
      deces_totaux_quotidien = dec_quo_tot_n)
  pouet3
}
