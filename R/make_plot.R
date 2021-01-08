
#' make_plot fait les graphiques qui vont être combinés et permet de forcer des axes différents selon la province.. hard to maintain
#'
#' @param d
#' @param pop
#' @param left_axis_title
#' @param left_axis_text
#' @param right_axis_label
#' @param bottom_axis_label
#' @param bottom_axis_title
#' @param bigaxis
#' @param bigaxis_value
#' @param smallaxis_value
#'
#' @return
#' @export
#' @importFrom ggplot2 element_rect scale_colour_manual expand_limits unit
#' @examples
make_plot <- function(d, pop, left_axis_title, left_axis_text, right_axis_label, bottom_axis_label, bottom_axis_title, bigaxis,
                      bigaxis_value = 250, smallaxis_value = 200, type = "maximum500") {
  format_francais <- "%d %B %Y"
  # left_labs <- if (right_axis_label) labs(y = NULL)
  # left_name <- if (left_axis_title){ "Nouveaux cas"  } else {""}
  left_name <- if (left_axis_title) {
    "Cas par million"
  } else {
    ""
  }
  left_text <- if (!left_axis_text) {
    theme(axis.text.y = element_blank())
  }

  right_labs <- if (right_axis_label) labs(y = NULL)
  right_name <- if (right_axis_label) "Nouveaux cas"

  bottom_labs <- if (!bottom_axis_label) {
    theme(axis.text.x = element_blank())
  }
  bottom_name <- if (bottom_axis_title) "date"

  myyaxis <- if (bigaxis) {
    coord_cartesian(ylim = c(0, bigaxis_value))
  } else {
    coord_cartesian(ylim = c(0, smallaxis_value))
  }
  mybackground <- if (bigaxis) {
    theme(panel.background = element_rect(fill = "#e8f4f8", colour = "#e8f4f8", size = 0.5, linetype = "solid"))
  } else {}

  d <- d %>% filter(!is.na(cases_per_1M))
  data <- d

  mindate <- min(data$date_report)

  labels <- data %>%
    filter(date_report == max(date_report)) %>%
    # filter( {{ filter_exp }} ) %>%
    # group_by( {{ geo }} )%>%
    summarise(
      label = paste0(
        "total: ",
        # format(sum( !!type_column ),
        format(cumulative_cases,
          digits = 9,
          decimal.mark = ",",
          big.mark = " ",
          small.mark = ".",
          small.interval = 3
        ),
        ", semaine: ",
        round(7 * avg_cases_last7),
        " cas"
      ),
      # value =  0.9 *  max(!!mean_column, na.rm = TRUE)
      value = 0.9 * max(avg_cases_last7, na.rm = TRUE)
    ) %>%
    mutate(
      # key=!!mean_name,
      # key  = "avg_cases_last7",
      avg_cases_last7 = value,
      date_report = lubridate::ymd(mindate) + 1
    )

  # labels

  last_value_label_data <-
    data %>%
    # filter( {{ filter_exp }} ) %>%
    # group_by( {{ geo }} )%>%
    filter(date_report == max(date_report)) %>%
    mutate(
      # key=!!mean_name,
      key = "cases_per_1M",
      label = paste0(round(cases_per_1M)),
      value = cases_per_1M
    ) %>%
    ungroup()


  # ggplot(d, aes(x = date_report, y = avg_cases_last7)) +
  ggplot(d, aes(x = date_report, y = cases_per_1M)) +
    {
      if (type == "paliers") {
        geom_line(aes(color = color_per_pop), size = 1, na.rm = TRUE)
      }
    } +

    #    scale_y_continuous(breaks = scales::pretty_breaks(n =5),
    # sec.axis = sec_axis(trans = ~ . / pop * 1e6, name = right_name)) + #cas par million
    # sec.axis = sec_axis(trans = ~ . /1e6 * pop, name = right_name)) + ## cas
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
      if (type == "maximum500") {
        geom_line(aes(color = last_cases_per_1M), size = 1, na.rm = TRUE)
      }
    } +
    {
      if (type == "maximum500") {
        scale_color_gradientn(
          colours = c(palette_OkabeIto["bluishgreen"], palette_OkabeIto["yellow"], palette_OkabeIto["orange"], palette_OkabeIto["vermillion"], "black"),
          values = c(0, 20, 60, 100, pmax(500, max(d$last_cases_per_1M))) / pmax(500, max(d$last_cases_per_1M)), limits = c(0, pmax(500, max(d$last_cases_per_1M))),
          name = "Cas par million"
        )
      }
    } +
    # facet_wrap(~ health_region,  scales = "free") +
    ggrepel::geom_text_repel(
      data = last_value_label_data,
      aes(label = label),
      size = 4, # changer la taille texte geom_text
      force = 4,
      color = "black",
      nudge_y = c(1)
    ) +
    # geom_text(
    #   data= labels ,
    #   aes(label = label),
    #   hjust = "left" , size = 4,
    #   color="gray50")+
    labs(
      title = last_value_label_data %>% pull(var_titre),
      subtitle = labels %>% pull(label),
      x = bottom_name,
      y = left_name,
      color = "Nombre de cas par million"
    ) +
    right_labs +
    expand_limits(y = 0) +
    # dviz.supp::theme_dviz_grid()+
    theme_simon(font_size = 10) +
    theme(axis.text.x = element_text(angle = 30, hjust = 1, vjust = 1, color = "gray50")) +
    bottom_labs +
    left_text +
    myyaxis +
    mybackground
}
