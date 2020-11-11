#' cases_par_pop_age_quebec
#'
#' @return
#' @export
#' @importFrom dplyr rename
#' @examples
cases_par_pop_age_quebec <- function(){
  cases_pl_date_age <- prep_data(
    load_inspq_covid19_hist() %>%
      select(date_report= date, cumulative_cases = cas_totaux_cumul, cases = cas_totaux_quotidien, groupe, type) %>%
      filter(type %in% c("groupe_age"),!is.na(date_report), groupe != "Âge inconnu"),
    groupe, type = cases )

  cases2 <- cases_pl_date_age %>% rename(groupe_age = groupe) %>%
    left_join(populations_age ) %>%
    mutate(groupe_age = factor(groupe_age))  %>%
    mutate(cases_per_1M = avg_cases_last7 * 1000000 / pop) %>%
    group_by( groupe_age ) %>%
    arrange(date_report) %>%
    mutate(last_cases_per_1M = max(cases_per_1M * (date_report == max(date_report)), na.rm = TRUE),
           previous_cases_per_1M = max(cases_per_1M * (date_report == max(date_report)-7), na.rm = TRUE),
           color_per_pop = factor(
             case_when(
               last_cases_per_1M < 20 ~ "moins de 20 cas par million",
               last_cases_per_1M < 60  ~ "entre 20 et 60 cas par million",
               last_cases_per_1M < 100 ~  "entre 60 et 100 cas par million",
               last_cases_per_1M >= 100  ~ "plus de 100 cas par million"
               #last_cases_per_1M >= 50 & last_cases_per_1M < 0.9 *previous_cases_per_1M ~ "Plus de 50 et décroissant",
               #last_cases_per_1M >= 50  ~ "Plus de 50 et stable ou croissante"
             ),
             levels = c("moins de 20 cas par million", "entre 20 et 60 cas par million", "entre 60 et 100 cas par million", "plus de 100 cas par million"))
    ) %>%
    ungroup() %>%
    mutate(rang =as.integer(groupe_age))

  cases2
}


graph_quebec_cas_par_age <- function(){

  cases2 <- cases_par_pop_age_quebec()

  graph_pops <- map_int(levels(cases2$groupe_age),
                        ~populations_age %>%   filter(groupe_age == .x) %>% pull(pop) %>% as.integer())


  cases_split <- cases2 %>%
    mutate(var_titre = groupe_age) %>%
    split(.$var_titre)

  mylocale <- Sys.getlocale()
  Sys.setlocale("LC_TIME", "fr_CA.UTF8")
  lastdate <- max(cases2$date_report)

  mesages <- purrr::pmap(
    list(d = cases_split,
         pop = graph_pops,
         left_axis_title =  c(
           FALSE,FALSE,FALSE,FALSE,
           TRUE,FALSE,FALSE,FALSE,
           FALSE,FALSE, FALSE),
         left_axis_text =  c(
           TRUE,FALSE,FALSE,FALSE,
           TRUE,FALSE,FALSE,FALSE,
           TRUE,FALSE, FALSE),
         right_axis_label = c(
           FALSE,FALSE,FALSE,  FALSE,
           FALSE,FALSE,FALSE, TRUE,
           FALSE,FALSE, FALSE),
         bottom_axis_label = c(
           FALSE, FALSE, FALSE, FALSE,
           FALSE, FALSE, FALSE, TRUE,
           TRUE, TRUE, TRUE
         ),
         bottom_axis_title = c(
           FALSE, FALSE, FALSE, FALSE,
           FALSE, FALSE, FALSE, FALSE,
           FALSE, TRUE, FALSE
         ),
         bigaxis = c(
           FALSE, FALSE, FALSE, FALSE,
           FALSE, FALSE, FALSE, FALSE,
           TRUE, TRUE, FALSE
         ),
         bigaxis_value = c(
           500, 500, 500 , 500 ,
           500, 500, 500 , 500 ,
           1500, 1500, 1500       )
    ),
    make_plot)



  combined <- c(mesages) %>% # , list(p1, p2 )
    patchwork::wrap_plots(guides = "collect", ncol=4) +
    patchwork::plot_annotation(# add title above patchwork
      title = "Nouveaux cas de covid19 par groupe d'âge par million d'habitants",
      subtitle = paste0("Moyenne mobile sur 7 jours, dernière mise à jour le " , format(lastdate, format=format_francais) ),
      caption = "Les panneaux avec un fond coloré n'ont pas le même axe des Y que les autres. par @coulsim"
    )&
    theme(plot.margin =  unit(c(0, 0, 0, 0), "cm"))
  #Sys.setlocale("LC_TIME", "mylocale")
  combined

}




#' graph_quebec_cas_par_age_heatmap
#'
#' @return
#' @export
#' @importFrom stringr str_pad
#' @importFrom lubridate year month day hms isoweek
#' @importFrom ggplot2 geom_tile scale_fill_gradientn geom_text
#' @examples
graph_quebec_cas_par_age_heatmap <- function(){


  cases2 <- cases_par_pop_age_quebec()


  zz <- cases2 %>% mutate(week = lubridate::isoweek(date_report)) %>%
    group_by(groupe_age, week) %>%
    mutate(pouet = paste0(str_pad(month(min(date_report)), 2, pad ="0"), "-", str_pad(day(min(date_report)), 2, pad = "0"),
                          "\n"  ,
                          str_pad(month(max(date_report)), 2, pad ="0"), "-", str_pad(day(max(date_report)), 2, pad = "0")
    )
    )%>%
    mutate(cases_per_1M_week = mean(cases *  1000000 / pop, na.rm = TRUE)) %>%
    filter(date_report == max(date_report)) %>%   # dernière journée de la semaine
    ungroup()

  last_date <- max(zz$date_report)

  mylocale <- Sys.getlocale()
  Sys.setlocale("LC_TIME", "fr_CA.UTF8")

  mygraph <- zz %>%
    ggplot(aes(x= as.factor(pouet), y = groupe_age, )) +
    geom_tile(aes(fill = pmin(cases_per_1M_week, 200)), color = "white", size = 1 )+
    scale_fill_gradientn(colours = c(palette_OkabeIto["bluishgreen"] , palette_OkabeIto["yellow"], palette_OkabeIto["orange"], palette_OkabeIto["vermillion"], "black"),
                         values = c(0, 20, 60, 100, 200) / 200, limits = c(0,200),
                         name = "Cas par million") +
    geom_text(aes(label= round(cases_per_1M_week)), color = "white", size =3) +

    #cowplot::theme_cowplot() +
    theme_simon(font_size=10) +
    #cowplot::background_grid(major ="x") +
    #colorblindr::scale_color_OkabeIto( ) +
    labs(
      title = "Nombre quotidien de nouveaux cas de covid par million d'habitants par groupe d'âge et semaine",
      subtitle = paste0("Dernière mise à jour le ", format(last_date, format=format_francais) ),
      caption = "(la dernière semaine peut être incomplète et appelée à changer) \n
    gossé par @coulsim",
      x = "Semaine ",
      y= "Groupe d'âge"
    ) +
    theme(
      #text = element_text(size=10),
      axis.line.y = element_blank(), # enelever ligne axes y
      axis.line.x = element_blank(), # enelever ligne axes y
      axis.ticks.y = element_blank(), # enlever ticks axes y
      axis.title.y = element_text(angle = 0, vjust= 1),
      axis.text.x = element_text(size=7),
      #axis.text.y = element_text(size=10),
      #axis.title = element_text(size=10),
      legend.key.height = unit(3, "line"), # legende toute la hauteur
      legend.key.width = unit(4, "line")
    )

  #Sys.setlocale(mylocale)
  mygraph


}
