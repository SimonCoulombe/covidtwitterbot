

#' cases_par_pop_region_quebec
#' -exécute prep data pour avoir la moyenne sur 7 jours, ainsi que le pire 7 jours et le dernier 7 jour et le ratio dernier/pire,
#' - left_join la population et calcule
#'  - cases_per_1M  , soit avg_cases_last7 / 1000000 * pop
#'  - last_cases_per_1M, soit le cases_per_1M final, qui nous donne la couleur
#'  -color_per_pop , la couleur qui dépend de last_cases_per_1M
#'
#' @return
#' @export
#'
#' @examples
cases_par_pop_region_quebec <- function() {
  cases_pl_date <- prep_data(
    get_inspq_covid19_hist() %>%
      select(date_report = date, cumulative_cases = cas_totaux_cumul, cases = cas_totaux_quotidien, groupe, type) %>%
      filter(type %in% c("region"), groupe != "Hors Québec", groupe != "Inconnue", !is.na(date_report)),
    groupe,
    variable = cases
  ) %>%
    left_join(table_correspondances_health_region_quebec %>% select(groupe, health_region, health_region_short)) %>%
    mutate(
      province = "Quebec",
      pr_region = paste0(province, "-", health_region)
    )

  cases2 <- cases_pl_date %>%
    left_join(populations %>% select(pr_region, pop)) %>%
    mutate(health_region = fct_reorder(health_region, total, .desc = TRUE)) %>%
    mutate(total_per_1M = total * 1e6 / pop) %>%
    mutate(cases_per_1M = avg_cases_last7 * 1000000 / pop) %>%
    group_by(health_region) %>%
    arrange(date_report) %>%
    mutate(
      last_cases_per_1M = max(cases_per_1M * (date_report == max(date_report)), na.rm = TRUE),
      previous_cases_per_1M = max(cases_per_1M * (date_report == max(date_report) - 7), na.rm = TRUE),
      color_per_pop = factor(
        case_when(
          last_cases_per_1M < 20 ~ "moins de 20 cas par million",
          last_cases_per_1M < 60 ~ "entre 20 et 60 cas par million",
          last_cases_per_1M < 100 ~ "entre 60 et 100 cas par million",
          last_cases_per_1M >= 100 ~ "plus de 100 cas par million"
        ),
        levels = c("moins de 20 cas par million", "entre 20 et 60 cas par million", "entre 60 et 100 cas par million", "plus de 100 cas par million")
      )
    ) %>%
    ungroup() %>%
    mutate(rang = as.integer(health_region)) %>%
    select(-pop) # %>%split(.$health_region)

  cases2
}


#' graph quebec cas pasr région
#'
#' @return
#' @export
#' @importFrom forcats fct_reorder
#' @importFrom dplyr left_join
#' @importFrom purrr map map2 pmap map_int
#' @importFrom dplyr pull
#' @importFrom ggplot2 coord_cartesian
#' @examples
graph_quebec_cas_par_region <- function() {
  cases2 <- cases_par_pop_region_quebec()

  graph_pops <- map_int(
    levels(cases2$health_region),
    ~ populations %>%
      filter(health_region == .x) %>%
      pull(pop) %>%
      as.integer()
  )

  cases_split <- cases2 %>%
    mutate(var_titre = health_region) %>%
    split(.$var_titre)


  mylocale <- Sys.getlocale()
  Sys.setlocale("LC_TIME", "fr_CA.UTF8")
  lastdate <- max(cases2$date_report)
  make_plot(cases_split[[1]], 1e5, FALSE, TRUE, FALSE, FALSE, TRUE, TRUE)


  mesregions <- purrr::pmap(
    list(
      d = cases_split,
      pop = graph_pops,
      left_axis_title = c(
        FALSE, FALSE, FALSE, FALSE, FALSE,
        TRUE, FALSE, FALSE, FALSE, FALSE,
        FALSE, FALSE, FALSE, FALSE, FALSE,
        FALSE, FALSE, FALSE, FALSE
      ),
      left_axis_text = c(
        TRUE, FALSE, FALSE, FALSE, FALSE,
        TRUE, FALSE, FALSE, FALSE, FALSE,
        TRUE, FALSE, FALSE, FALSE, FALSE,
        TRUE, FALSE, FALSE, FALSE
      ),
      right_axis_label = c(
        FALSE, FALSE, FALSE, FALSE, FALSE,
        FALSE, FALSE, FALSE, FALSE, TRUE,
        FALSE, FALSE, FALSE, FALSE, FALSE,
        FALSE, FALSE, FALSE, FALSE
      ),
      bottom_axis_label = c(
        FALSE, FALSE, FALSE, FALSE, FALSE,
        FALSE, FALSE, FALSE, FALSE, FALSE,
        FALSE, FALSE, FALSE, FALSE, TRUE,
        TRUE, TRUE, TRUE, TRUE
      ),
      bottom_axis_title = c(
        FALSE, FALSE, FALSE, FALSE, FALSE,
        FALSE, FALSE, FALSE, FALSE, FALSE,
        FALSE, FALSE, FALSE, FALSE, FALSE,
        FALSE, FALSE, TRUE, FALSE
      ),
      bigaxis = c(
        FALSE, FALSE, FALSE, FALSE, FALSE,
        FALSE, FALSE, FALSE, FALSE, FALSE,
        FALSE, FALSE, FALSE, FALSE, FALSE,
        FALSE, FALSE, FALSE, FALSE
      ),
      bigaxis_value = 700, smallaxis_value = 700
    ),
    make_plot
  )


  combined <- c(mesregions) %>% # , list(p1, p2 )
    patchwork::wrap_plots(guides = "collect", ncol = 5) +
    patchwork::plot_annotation( # add title above patchwork
      title = "Nouveaux cas de covid19 par région sociosanitaire par million d'habitants",
      subtitle = paste0("Moyenne mobile sur 7 jours, dernière mise à jour le ", format(lastdate, format = format_francais)),
      caption = "Les panneaux avec un fond coloré n'ont pas le même axe des Y que les autres. \n
    source de données différente que pour les graphiques qui comparent aux autres province \n
    (ici = meilleur car directement de INSPQ avec journées précédentes révisées) par @coulsim"
    ) &
    theme(legend.position = "bottom") & # a single shared legend for all plots (+ guides = "collect")
    theme(plot.margin = unit(c(0, 0, 0, 0), "cm")) +
      theme(legend.key.width = unit(4, "line"))

  # Sys.setlocale("LC_TIME", "mylocale")

  combined
}
