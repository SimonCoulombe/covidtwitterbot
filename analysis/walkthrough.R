#This script creates all the figures used by the bot.
library(ggplot2)
library(dplyr)
library(covidtwitterbot)

Sys.setlocale("LC_TIME", "fr_CA.UTF8")
## demo some data functions, not necessary here

message("Get INSPQ data")
hist <- get_inspq_covid19_hist()

message("graph hosts, test")
graph_deces_hospit_tests()
myggsave(filename = "~/git/adhoc_prive/covid19_PNG/quebec_deces_si.png")


message("graph quebec cases by pop, test")
graph_quebec_cas_par_region()
myggsave(filename = "~/git/adhoc_prive/covid19_PNG/quebec_cases_by_pop.png")

graph_quebec_cas_par_age()
myggsave(filename = "~/git/adhoc_prive/covid19_PNG/quebec_age.png" )

graph_quebec_cas_par_age_heatmap()
myggsave(filename = "~/git/adhoc_prive/covid19_PNG/heatmap_age.png" , width = 14, height =6)


# créer la carte des cas par RLS de la semaine passée
message("graph rls")
rls_data <- get_rls_data()

graph_quebec_cas_par_rls_heatmap(rls_data = rls_data)
myggsave(filename = "~/git/adhoc_prive/covid19_PNG/heatmap_rls.png" , width = 16, height =22)

carte <- carte_rls(rls_data = rls_data)
myggsave(filename = "~/git/adhoc_prive/covid19_PNG/carte_rls_cases.png" , width = 12, height =10)

carte <- carte_rls_zoom_montreal(rls_data = rls_data)
myggsave(filename = "~/git/adhoc_prive/covid19_PNG/carte_rls_cases_zoom_montreal.png" , width = 12, height =10)

message("graph css")
css_last_week <- get_css_last_week(rls_data)

carte_css(css_last_week)
myggsave(filename = "~/git/adhoc_prive/covid19_PNG/carte_css_cases.png" , width = 14, height =14)

graph_css_bars(css_last_week)
myggsave(filename = "~/git/adhoc_prive/covid19_PNG/css_cases_bars.png" , width = 14, height =14)

### un paquet de graphs à convertir en fonction un jour.. genre utiliser make_plot() ?----

message("type_pop_anything_quebec")
temp <- type_par_pop_anything_quebec(type = region, variable = hos_quo_tot_n  )%>%
  filter(date_report >= lubridate::ymd("2020-03-15"))


last_value_label_data <-
  temp %>%
  filter(!is.na(avg_hos_quo_tot_n_last7_per_1M)) %>%
  group_by(groupe) %>%
  filter(date_report == max(date_report)) %>%
  ungroup() %>%
  select(date_report, avg_hos_quo_tot_n_last7_per_1M, groupe) %>%
  mutate(label = sprintf("%.1f",round(avg_hos_quo_tot_n_last7_per_1M,1)))



p1 <- ggplot()+
  geom_line(data = temp,aes(x= date_report, y = avg_hos_quo_tot_n_last7_per_1M),  color = palette_OkabeIto["blue"], size =1, alpha=0.8) +
  facet_wrap(~groupe) +
  theme_simon() +

  labs(
    title = "Nouvelles hospitalisations par million d'habitant par région ",
    subtitle = paste0("Moyenne mobile 7 jours, dernière mise à jour le ", format(max(temp$date_report, na.rm= TRUE), format = format_francais)),
    caption = "gossé par @coulsim",
    y = "Hospitalisations",
    x = "Date"
  ) +
  scale_y_continuous(expand = c(0, 0))+
  ggrepel::geom_text_repel(data = last_value_label_data  ,
                           aes(x = date_report, y=avg_hos_quo_tot_n_last7_per_1M,  label = label),
                           size = 4, # changer la taille texte geom_text
                           force =4,
                           color ="black",
                           nudge_y = c(0.5))



ggp <- ggplot_build(p1)
my.ggp.yrange <- ggp$layout$panel_scales_y[[1]]$range$range  # data range!
my.ggp.xrange <- ggp$layout$panel_scales_x[[1]]$range$range  # data range!


p1 +
  geom_point(
    data = temp %>% mutate(hos_per_1M = hos_quo_tot_n / pop * 1000000),
    aes(x = date_report, y = hos_per_1M),
    color = "gray50",
    alpha =0.1
  )+
  ylim(my.ggp.yrange[1],my.ggp.yrange[2])
#
# The returned values are atomic, numeric vectors. I assume the [[1]] index is for multiple panels (facets).
#
# UPDATE: I noticed the above are for the untrained, unextended ranges.
# From the link at the top, we have:
#
#   ggp$layout$panel_params[[1]]$x.range
# ggp$layout$panel_params[[1]]$y.range

myggsave(filename = "~/git/adhoc_prive/covid19_PNG/quebec_hospit_by_pop.png" )


message("type_pop_anything_quebec2")
temp <- type_par_pop_anything_quebec(type = region, variable = dec_quo_tot_n  )%>%
  filter(date_report >= lubridate::ymd("2020-03-15"))



last_value_label_data <-
  temp %>%
  filter(!is.na(avg_dec_quo_tot_n_last7_per_1M)) %>%
  group_by(groupe) %>%
  filter(date_report == max(date_report)) %>%
  ungroup() %>%
  select(date_report, avg_dec_quo_tot_n_last7_per_1M, groupe) %>%
  mutate(label = sprintf("%.1f",round(avg_dec_quo_tot_n_last7_per_1M,1)))


ggplot()+
  geom_line(data = temp,aes(x= date_report, y = avg_dec_quo_tot_n_last7_per_1M),  color = palette_OkabeIto["blue"], size =1, alpha=0.8) +
  facet_wrap(~groupe) +
  theme_simon() +
  labs(
    title = "Décès par million d'habitant par région ",
    subtitle = paste0("Moyenne mobile 7 jours, dernière mise à jour le ", format(max(temp$date_report, na.rm= TRUE), format = format_francais)),
    caption = "gossé par @coulsim",
    y = "Décès",
    x = "Date"
  ) +
  scale_y_continuous(expand = c(0, 0))+
  ggrepel::geom_text_repel(data = last_value_label_data  ,
                           aes(x = date_report, y=avg_dec_quo_tot_n_last7_per_1M,  label = label),
                           size = 4, # changer la taille texte geom_text
                           force =4,
                           color ="black",
                           nudge_y = c(0.5))

myggsave(filename = "~/git/adhoc_prive/covid19_PNG/quebec_deces_by_pop.png" )


message("type_pop_anything_quebec3")

temp <- type_par_pop_anything_quebec(type = region, variable = psi_quo_tes_n  ) %>%
  filter(date_report >= lubridate::ymd("2020-03-15"))


last_value_label_data <-
  temp %>%
  filter(!is.na(avg_psi_quo_tes_n_last7_per_1M)) %>%
  group_by(groupe) %>%
  filter(date_report == max(date_report)) %>%
  ungroup() %>%
  select(date_report, avg_psi_quo_tes_n_last7_per_1M, groupe) %>%
  mutate(label = sprintf("%.0f",round(avg_psi_quo_tes_n_last7_per_1M,1)))



ggplot()+
  geom_line(data = temp,aes(x= date_report, y = avg_psi_quo_tes_n_last7_per_1M),  color = palette_OkabeIto["blue"], size =1, alpha=0.8) +
  facet_wrap(~groupe) +
  theme_simon() +
  labs(
    title = "Tests par million d'habitant par région ",
    subtitle = paste0("Moyenne mobile 7 jours, dernière mise à jour le ", format(max(temp$date_report, na.rm= TRUE), format = format_francais)),
    caption = "gossé par @coulsim",
    y = "Tests",
    x = "Date"
  ) +
  scale_y_continuous(expand = c(0, 0))+
  ggrepel::geom_text_repel(data = last_value_label_data  ,
                           aes(x = date_report, y=avg_psi_quo_tes_n_last7_per_1M,  label = label),
                           size = 4, # changer la taille texte geom_text
                           force =4,
                           color ="black",
                           nudge_y = c(0.5))

myggsave(filename = "~/git/adhoc_prive/covid19_PNG/quebec_tests_by_pop.png" )


# Pourcentage de positivité québec

message("pourcentage de positivité québec")

temp <- type_par_pop_anything_quebec(type = region, variable = psi_quo_pos_t  )%>%
  filter(date_report >= lubridate::ymd("2020-03-15"))

last_value_label_data <-
  temp %>%
  filter(!is.na(psi_quo_pos_t)) %>%
  group_by(groupe) %>%
  filter(date_report == max(date_report)) %>%
  ungroup() %>%
  select(date_report, psi_quo_pos_t, groupe) %>%
  mutate(label = sprintf("%.1f",round(psi_quo_pos_t,1)))

temp  %>%
  filter(groupe == "Ensemble du Québec") %>%
  ggplot()+
  geom_line(aes(x=date_report, y = psi_quo_pos_t),  color = palette_OkabeIto["blue"], size =1, alpha=0.8) +
  theme_simon()+
  labs(
    title = "Pourcentage de positivité (Ensemble du Québec",
    subtitle = paste0("dernière mise à jour le ", format(max(temp$date_report, na.rm= TRUE), format = format_francais)),
    x = "Date de résultat du test",
    y = "Pourcentage de positivité",
    caption = "gossé par @coulsim"
  ) +
  scale_y_continuous(expand = c(0, 0))+
  ggrepel::geom_text_repel(data = last_value_label_data  %>%filter(groupe == "Ensemble du Québec"),
                           aes(x = date_report, y=psi_quo_pos_t,  label = label),
                           size = 4, # changer la taille texte geom_text
                           force =4,
                           color ="black",
                           nudge_y = c(0.5))

myggsave(filename = "~/git/adhoc_prive/covid19_PNG/quebec_positivite.png" )
message("pourcentage de positivité québec par région")


temp  %>%
  ggplot()+
  geom_line(aes(x=date_report, y = psi_quo_pos_t),  color = palette_OkabeIto["blue"], size =1, alpha=0.8) +
  theme_simon()+
  labs(
    title = "Pourcentage de positivité par région",
    subtitle = paste0("dernière mise à jour le ", format(max(temp$date_report, na.rm= TRUE), format = format_francais)),
    x = "Date de résultat du test",
    y = "Pourcentage de positivité",
    caption = "gossé par @coulsim"
  ) +
  facet_wrap(~ groupe) +
  scale_y_continuous(expand = c(0, 0))+
  ggrepel::geom_text_repel(data = last_value_label_data  ,
                           aes(x = date_report, y=psi_quo_pos_t,  label = label),
                           size = 4, # changer la taille texte geom_text
                           force =4,
                           color ="black",
                           nudge_y = c(0.5))


myggsave(filename = "~/git/adhoc_prive/covid19_PNG/quebec_positivite_par_region.png" )


message("pourcentage de positivité québec par âge")
temp <- type_par_pop_anything_quebec(type = groupe_age, variable = psi_quo_pos_t  ) %>%
  filter(date_report >= lubridate::ymd("2020-03-15"))

last_value_label_data <-
  temp %>%
  filter(!is.na(psi_quo_pos_t)) %>%
  group_by(groupe) %>%
  filter(date_report == max(date_report)) %>%
  ungroup() %>%
  select(date_report, psi_quo_pos_t, groupe) %>%
  mutate(label = sprintf("%.1f",round(psi_quo_pos_t,1)))



temp  %>%
  ggplot()+
  geom_line(aes(x=date_report, y = psi_quo_pos_t),  color = palette_OkabeIto["blue"], size =1, alpha=0.8) +
  theme_simon()+
  labs(
    title = "Pourcentage de positivité par groupe d'âge",
    subtitle = paste0("dernière mise à jour le ", format(max(temp$date_report, na.rm= TRUE), format = format_francais)),
    x = "Date de résultat du test",
    y = "Pourcentage de positivité",
    caption = "gossé par @coulsim"
  ) +
  facet_wrap(~ groupe) +
  scale_y_continuous(expand = c(0, 0))+
  ggrepel::geom_text_repel(data = last_value_label_data  ,
                           aes(x = date_report, y=psi_quo_pos_t,  label = label),
                           size = 4, # changer la taille texte geom_text
                           force =4,
                           color ="black",
                           nudge_y = c(0.5))



myggsave(filename = "~/git/adhoc_prive/covid19_PNG/quebec_positivite_par_age.png" )

