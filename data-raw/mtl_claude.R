library(tidyverse)
library(googlesheets4)


url_mtl_arrondissement <- "https://docs.google.com/spreadsheets/d/1mOyyeCHwfI_F_T3pAalIdMBxhhfTbM7m5RvbciXIvPM/"
gs4_deauth()

attempt <- 0
prout <- NULL
while( is.null(prout) && attempt <= 100 ) {
  attempt <- attempt + 1
  message(attempt)
  Sys.sleep(3)
  try(
    prout <- read_sheet(url_mtl_arrondissement)
  )
}



colnames(prout) <- c("arrondissement" , as.character(seq(lubridate::ymd("20200329"), lubridate::ymd("20200329")+  ncol(prout)-2, by = 1)))
mtl_claude  <- prout[1:which(prout$arrondissement == "Westmount"), ] %>%
  gather(key=date_report, value=cumulative_cases, -arrondissement) %>%
  mutate(date_report = lubridate::ymd(date_report)) %>%
  mutate(cumulative_cases = map_int(cumulative_cases, ~ as.integer(str_replace_all(.x, " ", "")))) %>% # remove spaces from numbers
  group_by(arrondissement) %>%
  arrange(arrondissement, desc(date_report)) %>% ## descending date to fix cumulative
  mutate(cumulative_cases = if_else(cumulative_cases > lag(cumulative_cases), lag(cumulative_cases), cumulative_cases, cumulative_cases)) %>% ## cumulative can't be bigger than next day.. if so reduce to next day level.
  arrange(arrondissement, date_report) %>% ## ascending date
  mutate(cases = cumulative_cases - lag(cumulative_cases)) %>%
  ungroup() %>%
  filter(!is.na(cases)) %>%
  mutate(
    arrondissement =
      case_when(
        arrondissement ==  "Ahuntsic-Cartierville" ~ "Ahuntsic–Cartierville",
        arrondissement ==  "Baie-D'Urfé" ~ "Baie D'urfé",
        arrondissement ==  "Côte-des-Neiges–Notre-Dame-de-Grâace" ~ "Côte-des-Neiges–Notre-Dame-de-Grâce",
        arrondissement ==  "Mercier–Hochelaga–Maisonneuve" ~ "Mercier–Hochelaga-Maisonneuve",
        arrondissement ==  "Montréal-Est" ~ "Montréal Est",
        arrondissement ==  "Villeray–Saint-Michel–Parc Extension" ~ "Villeray–Saint-Michel–Parc-Extension",
        TRUE ~ arrondissement

      )
  )

write_csv(mtl_claude, "data-raw/mtl_claude.csv")
usethis::use_data(mtl_claude)



# mtl_claude %>% dplyr::count(arrondissement) %>% dplyr::anti_join(get_current_municipal())
# <chr>                                <int>
#   1 Ahuntsic-Cartierville                  150
# 2 Baie-D'Urfé                            150
# 3 Côte-des-Neiges–Notre-Dame-de-Grâace   150
# 4 Mercier–Hochelaga–Maisonneuve          150
# 5 Montréal-Est                           150
# 6 Villeray–Saint-Michel–Parc Extension   150

#
# > get_current_municipal() %>% dplyr::count(arrondissement) %>% dplyr::anti_join(mtl_claude)
# Joining, by = "arrondissement"
# # A tibble: 8 x 2
# arrondissement                           n
# <chr>                                <int>
#   1 Ahuntsic–Cartierville                    1
# 2 Baie D'urfé                              1
# 3 Côte-des-Neiges–Notre-Dame-de-Grâce      1
# 4 Mercier–Hochelaga-Maisonneuve            1
# 5 Montréal Est                             1
# 6 Territoire à confirmer                   1
# 7 Total à Montréal                         1
# 8 Villeray–Saint-Michel–Parc-Extension     1

attempt <- 0
prout <- NULL
while( is.null(prout) && attempt <= 100 ) {
  attempt <- attempt + 1
  message(attempt)
  Sys.sleep(3)
  try(
    prout <- read_sheet(url_mtl_arrondissement, sheet = "Population")
  )
}

mtl_population <- prout %>% janitor::clean_names()
mtl_population$population <- mtl_population$population %>% unlist()
mtl_population <- mtl_population %>%
  mutate(population =  as.integer(str_replace_all(population, " ", ""))
  ) %>%
  rename(Population = population)  %>%
  mutate(
    arrondissement =
      case_when(
        arrondissement ==  "Ahuntsic-Cartierville" ~ "Ahuntsic–Cartierville",
        arrondissement ==  "Baie-D'Urfé" ~ "Baie D'urfé",
        arrondissement ==  "Côte-des-Neiges–Notre-Dame-de-Grâace" ~ "Côte-des-Neiges–Notre-Dame-de-Grâce",
        arrondissement ==  "Mercier–Hochelaga–Maisonneuve" ~ "Mercier–Hochelaga-Maisonneuve",
        arrondissement ==  "Montréal-Est" ~ "Montréal Est",
        arrondissement ==  "Villeray–Saint-Michel–Parc Extension" ~ "Villeray–Saint-Michel–Parc-Extension",
        TRUE ~ arrondissement

      )
  )

total_pop <- tibble(
  arrondissement = "Total à Montréal",
  Population = sum(mtl_population$Population)
)

mtl_population <- bind_rows(mtl_population, total_pop)
write_csv(mtl_population, "data-raw/mtl_population.csv")
usethis::use_data(mtl_population)
