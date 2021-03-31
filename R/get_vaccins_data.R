


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
      rename(date_report = date)

    return(current_csv)
  }

  raw_vaccin <- get_raw_vaccination_data()


  fill_missing_dates_and_create_daily_counts_for_vaccin_data <- function(raw_vaccin_data) {
    vaccin_data <- raw_vaccin_data %>%
      group_by(regroupement, croisement, nom) %>%
      arrange(regroupement, croisement, nom, desc(date)) %>% ## descending date to fix cumulative
      mutate(fix_cummin = cummin(tidyr::replace_na(cumulative_cases, Inf))) %>%
      mutate(cumulative_cases = if_else(cumulative_cases > fix_cummin, fix_cummin, cumulative_cases, cumulative_cases)) %>% ## cumulative can't be bigger than next day.. if so reduce to next day level.
      arrange(regroupement, croisement, nom, date) %>%
      mutate(slope = (lead(cumulative_cases) - cumulative_cases) / as.numeric(lead(date) - date)) %>%
      tidyr::complete(date = seq.date(min(date), max(date), by = "day")) %>%
      tidyr::fill(slope, .direction = "down") %>%
      mutate(cumulative_cases = if_else(!is.na(cumulative_cases), cumulative_cases, floor(first(cumulative_cases) + cumsum(slope) - slope))) %>%
      select(-slope) %>%
      mutate(cases = cumulative_cases - lag(cumulative_cases)) %>%
      ungroup() %>%
      filter(!is.na(cases)) %>%
      mutate(shortname_rls = str_replace(str_extract(str_replace(RLS, "RLS de ", "RLS "), "RLS.+"), "RLS ", "")) %>%
      left_join(rls_population) %>%
      group_by(RSS, RLS) %>%
      arrange(date) %>%
      mutate(
        cases_per_100k = cases * 1e5 / Population,
        cases_last_7_days = (cumulative_cases - lag(cumulative_cases, 7)),
        previous_cases_last_7_days = lag(cases_last_7_days, 7),
        cases_last_7_days_per_100k = cases_last_7_days * 1e5 / Population,
        RLS_code = str_extract(RLS, "^\\d+"),
        cases_per_1M = ifelse(!is.na(cases_last_7_days), cases_last_7_days / 7 * 1000000 / Population, 0),
        last_cases_per_1M = max(cases_per_1M * (date == max(date)), na.rm = TRUE),
        previous_cases_per_1M = max(cases_per_1M * (date == max(date) - 7), na.rm = TRUE),
        color_per_pop = factor(
          case_when(
            is.na(last_cases_per_1M) ~ "moins de 20 cas par million",
            last_cases_per_1M < 20 ~ "moins de 20 cas par million",
            last_cases_per_1M < 60 ~ "entre 20 et 60 cas par million",
            last_cases_per_1M < 100 ~ "entre 60 et 100 cas par million",
            last_cases_per_1M >= 100 ~ "plus de 100 cas par million"
          ),
          levels = c("moins de 20 cas par million", "entre 20 et 60 cas par million", "entre 60 et 100 cas par million", "plus de 100 cas par million")
        )
      ) %>%
      ungroup() %>%
      mutate(
        pop = Population,
        RLS_petit_nom = str_replace(RLS, "RLS des |RLS de la |RLS du |RLS de l' |RLS de |RLS ", "")
      )

    rls
  }
