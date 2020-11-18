library(tidyverse)

# on commence par domper un paquet de tableau-rls.csv dans data-raw/tableau-rls, sans commiter car il y a des doublons.
delete_duplicate_tableau_rls <- function(mypath = "data-raw/tableau-rls"){

  pouet <- list.files(
    path =mypath,
    pattern = ".csv$",
    full.names = TRUE)

  csvs <- purrr::map(pouet, ~readr::read_csv(.x))

  mydelete <- rep(FALSE, length(csvs))
  for (i in seq(from=2, to = length(csvs))){

    if ( isTRUE(dplyr::all_equal(csvs[[i]],csvs[[i-1]]))){
      mydelete[i]= TRUE
    }
  }
  deleteme <- pouet[mydelete]
  purrr::map(deleteme, ~file.remove(.x))
}
# on efface les doublons
delete_duplicate_tableau_rls()

# une fois ce code roulé on importe tout ça et on sauvegarde un beau .rda



tableau_rls <- prepare_cronjob_data_nobindrows(mypath = "data-raw/tableau-rls") %>%
  bind_rows() %>%
  rename(cumulative_cases = Cas) %>%
  filter(!is.na(NoRLS), RLS != "Total") %>%
  mutate(
    cumulative_cases = if_else(cumulative_cases != "n.d.", cumulative_cases, NA_character_),
    cumulative_cases = as.numeric(str_replace_all(cumulative_cases, "\\s+", "")),
    Taux = if_else(Taux != "n.d.", Taux, NA_character_)
  ) %>%
  select(-No, -NoRLS, -Population, -Taux, -download_datetime) %>%
  filter(!is.na(cumulative_cases))


usethis::use_data(tableau_rls)
