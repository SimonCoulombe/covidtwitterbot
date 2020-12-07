#' cases_par_pop_age_quebec
#' -exécute prep data pour avoir la moyenne sur 7 jours, ainsi que le pire 7 jours et le dernier 7 jour et le ratio dernier/pire,
#' - left_join la population et calcule
#'  - cases_per_1M  , soit avg_cases_last7 / 1000000 * pop
#'  - last_cases_per_1M, soit le cases_per_1M final, qui nous donne la couleur
#'  -color_per_pop , la couleur qui dépend de last_cases_per_1M
#'
#' @return
#' @export
#' @importFrom dplyr rename
#' @examples
cases_par_pop_age_quebec <- function(){
  #prep_data ajoute 7 colonnes :
  #'  avg_XXX_last7
  #'  total
  #'  worst7
  #'  last7
  #'  ratio
  #'  winning.
  #'  group <--- qui est la même que le type (genre health_region ou groupe_age, mais réordonné en fonction du total de cas..)
  cases_pl_date_age <- prep_data(
    get_inspq_covid19_hist() %>%
      select(date_report= date, cumulative_cases = cas_totaux_cumul, cases = cas_totaux_quotidien, groupe, type) %>%
      filter(type %in% c("groupe_age"),!is.na(date_report), groupe != "Âge inconnu"),
    groupe,
    variable = cases )

  # une fois qu'on a avg_xxx
  cases2 <- cases_pl_date_age %>%
    rename(groupe_age = groupe) %>%
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
             ),
             levels = c("moins de 20 cas par million", "entre 20 et 60 cas par million", "entre 60 et 100 cas par million", "plus de 100 cas par million"))
    ) %>%
    ungroup() %>%
    mutate(rang =as.integer(groupe_age))

  cases2
}



#' Title
#'
#' @param groupe défini par la fonction type... genre "groupe_age" ou "region"
#' @param variable  genre "cas_totaux_quotidien" ou
#'
#' @return
#' @export
#'
#' @examples type_par_pop_anything_quebec(type = region, variable = hos_quo_tot_m  ) %>% ggplot(aes(x= date_report, y = avg_hos_quo_tot_m_last7_per_1M))+ geom_line() + facet_wrap(~groupe)
type_par_pop_anything_quebec <- function(type, variable){
  variable_column <- enquo(variable)   ## this has to be !!
  variable_name <- quo_name(variable_column) ## its a string, dont !!

  type_column <- enquo(type)   ## this has to be !!
  type_name <- quo_name(type_column) ## its a string, dont !!
  #prep_data ajoute 7 colonnes :
  #'  avg_XXX_last7
  #'  total
  #'  worst7
  #'  last7
  #'  ratio
  #'  winning.
  #'  group <--- qui est la même que le type (genre health_region ou groupe_age, mais réordonné en fonction du total de cas.... TODO: on ditche tu ça?
  data_avec_moy7jours <-
    get_inspq_covid19_hist() %>%
    select(date_report= date, {{variable}}, groupe, type,pop) %>%
    filter(type ==  type_name ,!is.na(date_report), !is.na(pop), !is.na({{variable}})) %>%
    prep_data(data = .,
              group = groupe,
              variable = {{variable}}
    ) %>%
    mutate(groupe = factor(groupe),
           rang = as.integer(groupe))

  mean_name = paste0("avg_", variable_name, "_last7") ## this is a string, dont !!
  mean_column <- sym(mean_name) ## this is a column, it has to be !!

  mean_per_1M_name = paste0("avg_", variable_name, "_last7_per_1M")
  mean_per_1M_column = sym(mean_per_1M_name)

  last_mean_per_1M_name = paste0("last_avg_", variable_name, "_last7_per_1M")

  variable_par_million <-
    data_avec_moy7jours %>%
    mutate(!!mean_per_1M_name := !!mean_column * 1000000/pop)

  dernier_niveau_variable_par_million <-
    variable_par_million %>%
    group_by(groupe) %>%
    arrange(date_report) %>%
    mutate(!!last_mean_per_1M_name := max(!!mean_per_1M_column * (date_report==max(date_report)), na.rm = TRUE) ) %>%
    ungroup()


}


#' Title
#'
#' @return
#' @export
#'
#' @examples graph_quebec_cas_par_age()
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
         bigaxis_value = c(1500  ),
         smallaxis_value = 250
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


  heatmap_cas(cases_par_pop_age_quebec(), groupe_age, "groupe d'âge")
}




#' heatmap_cas
#'
#' @return
#' @export
#' @importFrom stringr str_pad
#' @importFrom lubridate year month day hms isoweek
#' @importFrom ggplot2 geom_tile scale_fill_gradientn geom_text
#' @examples
heatmap_cas <- function(prepped_data, variable, variable_title){

  cases2 <- prepped_data %>%
    filter(date_report >= lubridate::ymd("20200302"))


  zz <- cases2 %>% mutate(week = lubridate::isoweek(date_report)) %>%
    group_by(week) %>%
    mutate(
      pouet = paste0(str_pad(month(min(date_report)), 2, pad ="0"), "-", str_pad(day(min(date_report)), 2, pad = "0"),
                     "\n"  ,
                     str_pad(month(max(date_report)), 2, pad ="0"), "-", str_pad(day(max(date_report)), 2, pad = "0")
      )
    )%>%
    ungroup() %>%
    group_by({{variable}}, week) %>%
    mutate(cases_per_1M_week = mean(cases *  1000000 / pop, na.rm = TRUE)) %>%
    filter(date_report == max(date_report)) %>%   # dernière journée de la semaine
    ungroup()

  last_date <- max(zz$date_report)

  mylocale <- Sys.getlocale()
  Sys.setlocale("LC_TIME", "fr_CA.UTF8")

  mygraph <- zz %>%
    ggplot(aes(x= as.factor(pouet), y = {{variable}}, )) +
    geom_tile(aes(fill = pmin(cases_per_1M_week, 200)), color = "white", size = 1 )+
    scale_fill_gradientn(colours = c(palette_OkabeIto["bluishgreen"] , palette_OkabeIto["yellow"], palette_OkabeIto["orange"], palette_OkabeIto["vermillion"], "black"),
                         values = c(0, 20, 60, 100, 200) / 200, limits = c(0,200),
                         name = "Cas par million") +
    geom_text(aes(label= round(cases_per_1M_week)), color = "white", size =3) +

    theme_simon(font_size=10) +
    nogrid()+

    labs(
      title = paste0("Nombre quotidien de nouveaux cas de covid par million d'habitants par ", variable_title, " et semaine"),
      subtitle = paste0("Dernière mise à jour le ", format(last_date, format=format_francais) ),
      caption = "(la dernière semaine peut compter moins de 7 jours) \n
    gossé par @coulsim",
      x = "Semaine ",
      y= variable_title
    ) +
    theme(
      axis.line.y = element_blank(), # enelever ligne axes y
      axis.line.x = element_blank(), # enelever ligne axes y
      axis.ticks.y = element_blank(), # enlever ticks axes y
      axis.title.y = element_text(angle = 0, vjust= 1),
      axis.text.x = element_text(size=7),
      legend.key.height = unit(3, "line"), # legende toute la hauteur
      legend.key.width = unit(4, "line")
    )

  mygraph
}

