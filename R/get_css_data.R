#' Title
#'
#' @return
#' @export
#' @importFrom tongfen proportional_reaggregate
#' @examples
get_css_last_week <- function(rls_data = NULL){
  if(is.null(rls_data)) rls_data <- get_clean_rls_data()
  rls_last_week <- shp_rls %>%
    left_join(rls_data %>%
                group_by(RLS_code) %>%
                filter(date_report ==max(date_report)) %>%
                ungroup() %>%
                select(date_report, RLS_code, cases_last_7_days_per_100k, cumulative_cases, cases_last_7_days, previous_cases_last_7_days, Population, last_cases_per_1M,color_per_pop)) %>%
    mutate(dailycases_per_1M_avg_7_days = round(last_cases_per_1M,1))

  cases_intersections_last_week <- tongfen::proportional_reaggregate(
    data = intersections_populations_rls_css,
    parent_data = rls_last_week ,
    geo_match = c("RLS_code" = "RLS_code"),
    categories = c("cases_last_7_days", "previous_cases_last_7_days"),
    base = "Population"
  ) %>%
    mutate(date_report = max(rls_last_week$date_report))

  cases_css_last_week <- cases_intersections_last_week %>%
    group_by(CD_CS, NOM_CS, date_report) %>%
    summarise(
      cases_last_7_days = sum(cases_last_7_days, na.rm = TRUE),
      previous_cases_last_7_days = sum(previous_cases_last_7_days, na.rm = TRUE),
      Population = sum(Population, na.rm = TRUE)
    ) %>%
    ungroup() %>%
    mutate(
      dailycases_per_1M_avg_7_days = round(cases_last_7_days * 1e6 /7 / Population,1),
      previous_dailycases_per_1M_avg_7_days = round(previous_cases_last_7_days * 1e6 /7 / Population,1),
      color_per_pop = factor(
        case_when(
          is.na(dailycases_per_1M_avg_7_days) ~ "moins de 20 cas par million",
          dailycases_per_1M_avg_7_days < 20 ~ "moins de 20 cas par million",
          dailycases_per_1M_avg_7_days < 60  ~ "entre 20 et 60 cas par million",
          dailycases_per_1M_avg_7_days < 100 ~  "entre 60 et 100 cas par million",
          dailycases_per_1M_avg_7_days >= 100  ~ "plus de 100 cas par million"
        ),
        levels = c("moins de 20 cas par million", "entre 20 et 60 cas par million", "entre 60 et 100 cas par million", "plus de 100 cas par million")),
      cases_last_7_days_per_100k = round(cases_last_7_days * 100000 / Population,1),
      cases_last_7_days = round(cases_last_7_days),
      Population = round(Population)
    )   %>%
    mutate(
      NOM_CS_petit_nom = str_replace(NOM_CS, "CSS des |CSS de la |CSS du |CSS de l' |CSS de |CSS ", "")
    )

  zz <- shp_css %>%
    left_join(cases_css_last_week %>% st_drop_geometry)

  css_last_week <- zz
  css_last_week

}
