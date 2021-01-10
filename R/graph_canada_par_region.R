#' Title
#'
#' @param data
#' @param group_var
#' @param type
#'
#' @return
#' @export
#'
#' @examples
simple_make_plot <- function(data, group_var, type = "maximum", reorder = TRUE) {
  group_var_column <- enquo(group_var) ## this has to be !!
  group_var_string <- quo_name(group_var_column) ## its a string, dont !!

  ## I should just use "create_graph" form covid19PNG.R...
  data <- data %>%
    select({{ group_var }}, date_report, cumulative_cases, avg_cases_last7, cases_per_1M, last_cases_per_1M, color_per_pop, total_per_1M) %>%
    filter(!is.na(cases_per_1M)) %>%
    filter(date_report >= lubridate::ymd("20200315"))

  if (reorder) {
    data <- data %>%
      mutate({{ group_var }} := fct_reorder({{ group_var }}, total_per_1M, .desc = TRUE))
  }
  mindate <- min(data$date_report)

  summary_labels <- data %>%
    mutate(y_axis = 0.95 * max(cases_per_1M, na.rm = TRUE)) %>%
    filter(date_report == max(date_report)) %>%
    mutate(
      label = paste0(
        format(round(total_per_1M),
          digits = 9,
          decimal.mark = ",",
          big.mark = " ",
          small.mark = ".",
          small.interval = 3
        ),
        " cas total/M\n",
        format(cumulative_cases,
          digits = 9,
          decimal.mark = ",",
          big.mark = " ",
          small.mark = ".",
          small.interval = 3
        ),
        " cas total\n ",
        format(round(7 * avg_cases_last7),
          digits = 9,
          decimal.mark = ",",
          big.mark = " ",
          small.mark = ".",
          small.interval = 3
        ),
        " cas semaine"
      ),
      cases_per_1M = y_axis,
      date_report = mindate + 1
    ) %>%
    select({{ group_var }}, label, cases_per_1M, date_report)



  last_value_label_data <-
    data %>%
    filter(date_report == max(date_report)) %>%
    mutate(
      key = "cases_per_1M",
      label = paste0(round(cases_per_1M)),
      value = cases_per_1M
    ) %>%
    ungroup()

  ggplot(data, aes(x = date_report, y = cases_per_1M)) +
    facet_wrap(vars({{ group_var }})) +
    {
      if (type == "paliers") {
        geom_line(aes(color = color_per_pop), size = 1, na.rm = TRUE, alpha = 0.9)
      }
    } +
    {
      if (type == "paliers") {
        scale_colour_manual(
          drop = TRUE,
          limits = names(mes4couleurs), ## les limits (+myColors?) c'est nécessaire pour que toutes les valeurs apparaissent dans la légende même quand pas utilisée.
          values = mes4couleurs
        )
      }
    } +
    {
      if (type %in% c("maximum", "maximum500", "maximumviridis")) {
        geom_line(aes(color = last_cases_per_1M), size = 1, na.rm = TRUE, alpha = 0.9)
      }
    } +
    {
      if (type == "maximum500") {
        scale_color_gradientn(
          colours = c(palette_OkabeIto["bluishgreen"], palette_OkabeIto["yellow"], palette_OkabeIto["orange"], palette_OkabeIto["vermillion"], "black"),
          values = c(0, 20, 60, 100, max(500, max(data$last_cases_per_1M))) / max(500, max(data$last_cases_per_1M)), limits = c(0, max(500, max(data$last_cases_per_1M))),
          name = "Cas par million"
        )
      }
    } +
    {
      if (type == "maximum") {
        scale_color_gradientn(
          colours = c(palette_OkabeIto["bluishgreen"], palette_OkabeIto["yellow"], palette_OkabeIto["orange"], palette_OkabeIto["vermillion"], "black"),
          values = c(0, 20, 60, 100, max(data$cases_per_1M)) / max(data$cases_per_1M), limits = c(0, max(data$cases_per_1M)),
          name = "Cas par million"
        )
      }
    } +
    {
      if (type == "maximumviridis") {
        scale_color_viridis(name = "Cas par million", direction = -1)
      }
    } +
    ggrepel::geom_text_repel(
      data = last_value_label_data,
      aes(label = label),
      size = 3, # changer la taille texte geom_text
      force = 4,
      color = "black",
      nudge_y = c(10)
    ) +
    labs(
      title = paste0("Nouveaux cas quotidiens par million d'habitant par ", group_var_string),
      subtitle = "moyenne mobile 7 jours",
      x = "date",
      y = "Cas par million",
      color = "Nombre de cas par million"
    ) +
    geom_text(
      data = summary_labels,
      aes(label = label),
      hjust = "left", vjust = "top", size = 3
    ) +
    expand_limits(y = 0) +
    theme_simon(font_size = 12) +
    theme(axis.text.x = element_text(angle = 30, hjust = 1, vjust = 1, color = "gray50"))
}



#' Title
#'
#' @return
#' @export
#'
#' @examples
get_prov_data <- function() {
  attempt <- 0
  cases_prov <- NULL
  while (is.null(cases_prov) && attempt <= 100) {
    attempt <- attempt + 1
    message("attempt: ", attempt)
    Sys.sleep(3)
    try(
      cases_prov <- readr::read_csv("https://raw.githubusercontent.com/ishaberry/Covid19Canada/master/timeseries_prov/cases_timeseries_prov.csv") %>%
        mutate(date_report = lubridate::dmy(date_report))
    )
  }






  prov_pop <- populations %>%
    filter(!is.na(HR_UID)) %>%
    group_by(province) %>%
    summarise(pop = sum(pop))


  cases2 <- prep_data(cases_prov, province, variable = cases) %>%
    filter(province != "Repatriated") %>%
    left_join(prov_pop) %>%
    mutate(total_per_1M = total * 1e6 / pop) %>%
    mutate(cases_per_1M = avg_cases_last7 * 1000000 / pop) %>%
    group_by(province) %>%
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
    ungroup()


  cases2
}


#' Title
#'
#' @return
#' @export
#'
#' @examples
get_pr_region_data <- function() {
  attempt <- 0
  cases_timeseries_hr <- NULL
  while (is.null(cases_timeseries_hr) && attempt <= 100) {
    attempt <- attempt + 1
    message("attempt: ", attempt)
    Sys.sleep(3)
    try(
      cases_timeseries_hr <- read_csv("https://raw.githubusercontent.com/ishaberry/Covid19Canada/master/timeseries_hr/cases_timeseries_hr.csv") %>%
        mutate(date_report = lubridate::dmy(date_report)) %>%
        filter(health_region != "Not Reported") %>%
        mutate(health_region_bak = health_region) %>%
        mutate(pr_region = paste0(province, "-", health_region))
    )
  }

  cases2 <- prep_data(cases_timeseries_hr, pr_region, variable = cases) %>%
    filter(province != "Repatriated") %>%
    left_join(populations) %>%
    mutate(total_per_1M = total * 1e6 / pop) %>%
    mutate(cases_per_1M = avg_cases_last7 * 1000000 / pop) %>%
    group_by(province) %>%
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
    ungroup()


  cases2
}

# simple_make_plot(data = pr_region_data, group_var = pr_region)
#
