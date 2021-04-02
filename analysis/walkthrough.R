# This script creates all the figures used by the bot.
tictoc::tic()
library(ggplot2)
library(dplyr)
library(covidtwitterbot)
library(rmapzen)
library(sf)
library(viridis)
options(nextzen_API_key = Sys.getenv("nextzen_api_key"))
mz_set_tile_host_nextzen(key = getOption("nextzen_API_key"))

library(patchwork)
Sys.setlocale("LC_TIME", "fr_CA.UTF8")
## demo some data functions, not necessary here

message("Get INSPQ data")
hist <- get_inspq_covid19_hist()

message("graph hosts, test")
graph_deces_hospit_tests()
myggsave(filename = "~/git/adhoc_prive/covid19_PNG/quebec_deces_si.png")


message("graph quebec cases by pop, test")
# graph_quebec_cas_par_region()  # j 'aime pu ça.

cases2_par_pop_region_quebec <- cases_par_pop_region_quebec()
simple_make_plot(data = cases2_par_pop_region_quebec, group_var = health_region_short, type = "maximumviridis")

myggsave(filename = "~/git/adhoc_prive/covid19_PNG/quebec_cases_by_pop.png")
# graph_quebec_cas_par_age()
cases2_par_pop_age_quebec <- cases_par_pop_age_quebec()
simple_make_plot(data = cases2_par_pop_age_quebec, group_var = groupe_age, type = "maximumviridis", reorder = FALSE)
myggsave(filename = "~/git/adhoc_prive/covid19_PNG/quebec_age.png")

graph_quebec_cas_par_age_heatmap()
myggsave(filename = "~/git/adhoc_prive/covid19_PNG/heatmap_age.png", width = 18, height = 6)


# créer la carte des cas par RLS de la semaine passée
message("graph rls")
rls_data <- get_rls_data()
readr::write_csv(rls_data, "~/git/adhoc_prive/covid19_PNG/rls_data.csv")

graph_quebec_cas_par_rls_heatmap(rls_data = rls_data)
myggsave(filename = "~/git/adhoc_prive/covid19_PNG/heatmap_rls.png", width = 18, height = 22)

carte <- carte_rls(rls_data = rls_data)

ggsave("~/git/adhoc_prive/covid19_PNG/carte_rls_cases.png", carte, width = 10, height = 10, units = "in", dpi = 250)
# myggsave(filename = "~/git/adhoc_prive/covid19_PNG/carte_rls_cases.png" , width = 10, height =10) # marche pas avec patchwork inset..

carte <- carte_rls_zoom_montreal(rls_data = rls_data)
myggsave(filename = "~/git/adhoc_prive/covid19_PNG/carte_rls_cases_zoom_montreal.png", width = 12, height = 10)

message("graph css")
css_last_week <- get_css_last_week(rls_data)

carte_css(css_last_week)
myggsave(filename = "~/git/adhoc_prive/covid19_PNG/carte_css_cases.png", width = 14, height = 14)

graph_css_bars(css_last_week)
myggsave(filename = "~/git/adhoc_prive/covid19_PNG/css_cases_bars.png", width = 14, height = 14)

## canada -----

prov_data <- get_prov_data()
heatmap_cas(prov_data, province, "province")
myggsave(filename = "~/git/adhoc_prive/covid19_PNG/heatmap_prov.png", width = 18, height = 8)

simple_make_plot(data = prov_data, group_var = province, type = "maximumviridis")
myggsave(filename = "~/git/adhoc_prive/covid19_PNG/canada_cases_by_pop.png")


pr_region_data <- get_pr_region_data()
heatmap_cas(pr_region_data, pr_region, " région sanitaire")
myggsave(filename = "~/git/adhoc_prive/covid19_PNG/heatmap_pr_region.png", width = 18, height = 22)


worst16 <- pr_region_data %>%
  filter(date_report == max(date_report)) %>%
  arrange(desc(total_per_1M)) %>%
  head(16) %>%
  select(pr_region)

simple_make_plot(data = pr_region_data %>% inner_join(worst16), group_var = pr_region)
myggsave(filename = "~/git/adhoc_prive/covid19_PNG/canada_cases_by_worst16.png", height = 11)

### un paquet de graphs laids convertis en fonction----

# graph rouph par pop retourne la moyenne moibile par 1M d'habitant
graph_rough_par_pop <- function(type, variable, titre = NULL,  y_lab = NULL,hist_data = NULL){
  if(is.null(hist_data)) hist_data <- get_inspq_covid19_hist()
  type_column = enquo(type)
  type_column_name = quo_name(type_column)
  variable_column = enquo(variable)
  variable_column_name = quo_name(variable_column)
  avg_column_name = paste0("avg_", variable_column_name, "_last7_per_1M")
  avg_column = rlang::sym(avg_column_name)

  temp <- type_par_pop_anything_quebec(type = {{type_column}}, variable = {{variable_column}}, hist_data = hist_data) %>%
    filter(date_report >= lubridate::ymd("2020-03-15"))

  last_value_label_data <-
    temp %>%
    filter(!is.na({{avg_column  }})) %>%
    group_by(groupe) %>%
    filter(date_report == max(date_report)) %>%
    ungroup() %>%
    select(date_report, {{avg_column}}, groupe) %>%
    mutate(label = sprintf("%.1f", round( {{avg_column}}, 1)))




  p1 <- ggplot() +
    geom_line(data = temp, aes(x = date_report, y = {{avg_column}}), color = palette_OkabeIto["blue"], size = 1, alpha = 0.8) +
    facet_wrap(~groupe) +
    theme_simon() +
    labs(
      subtitle = paste0("Moyenne mobile 7 jours, dernière mise à jour le ", format(max(temp$date_report, na.rm = TRUE), format = format_francais)),
      caption = "gossé par @coulsim",
      x = "Date"
    ) +
     {if(!is.null(titre)){  labs(title = titre)}}+
   {if(!is.null(y_lab)){  labs(y = y_lab)}} +
    scale_y_continuous(expand = c(0, 0))

  ggp <- ggplot_build(p1)
  my.ggp.yrange <- ggp$layout$panel_scales_y[[1]]$range$range # data range!
  my.ggp.xrange <- ggp$layout$panel_scales_x[[1]]$range$range # data range!


  p1 +
    geom_col(
      data = temp %>% mutate(daily_per_1M = {{variable_column}} / pop * 1000000),
      aes(x = date_report, y = daily_per_1M),
      color = "gray60",
      width = 1,
      alpha = 0.3
    ) +
    ylim(my.ggp.yrange[1], my.ggp.yrange[2]) +
    ggrepel::geom_text_repel(
      data = last_value_label_data,
      aes(x = date_report, y = {{avg_column}}, label = label),
      size = 4, # changer la taille texte geom_text
      force = 10,
      color = "black",
      nudge_y = c(0.5)
    ) +
    geom_line(data = temp, aes(x = date_report, y = {{avg_column}}), color = palette_OkabeIto["blue"], size = 1, alpha = 0.8)+
    theme(axis.text.x = element_text(angle = 30, vjust = 0.5, hjust=1))
}

# graph rough absolu retourne la moyenne mobile 7 jours
graph_rough_absolu <- function(type, variable, titre = NULL,  y_lab = NULL,hist_data = NULL,  drop_total = FALSE, total_value = NULL){
  if(is.null(hist_data)) hist_data <- get_inspq_covid19_hist()
  type_column = enquo(type)
  type_column_name = quo_name(type_column)
  variable_column = enquo(variable)
  variable_column_name = quo_name(variable_column)
  avg_column_name = paste0("avg_", variable_column_name, "_last7")
  avg_column = rlang::sym(avg_column_name)

  temp <- type_par_pop_anything_quebec(type = {{type_column}}, variable = {{variable_column}}, hist_data = hist_data) %>%
    filter(date_report >= lubridate::ymd("2020-03-15")) %>%
    {if(drop_total & !is.null(total_value)) {

      filter(., groupe  != total_value)
    } else {identity(.)}
    }

  last_value_label_data <-
    temp %>%
    filter(!is.na({{avg_column  }})) %>%
    group_by(groupe) %>%
    filter(date_report == max(date_report)) %>%
    ungroup() %>%
    select(date_report, {{avg_column}}, groupe) %>%
    mutate(label = sprintf("%.1f", round( {{avg_column}}, 1)))

  p1 <- ggplot() +
    geom_line(data = temp, aes(x = date_report, y = {{avg_column}}), color = palette_OkabeIto["blue"], size = 1, alpha = 0.8) +
    facet_wrap(~groupe) +
    theme_simon() +
    labs(
      subtitle = paste0("Moyenne mobile 7 jours, dernière mise à jour le ", format(max(temp$date_report, na.rm = TRUE), format = format_francais)),
      caption = "gossé par @coulsim",
      x = "Date"
    ) +
    {if(!is.null(titre)){  labs(title = titre)}}+
    {if(!is.null(y_lab)){  labs(y = y_lab)}} +
    scale_y_continuous(expand = c(0, 0))

  ggp <- ggplot_build(p1)
  my.ggp.yrange <- ggp$layout$panel_scales_y[[1]]$range$range # data range!
  my.ggp.xrange <- ggp$layout$panel_scales_x[[1]]$range$range # data range!


  p1 +
    geom_col(
      data = temp,
      aes(x = date_report, y = {{variable_column}} ),
      color = "gray60",
      width = 1,
      alpha = 0.3
    ) +
    ylim(my.ggp.yrange[1], my.ggp.yrange[2]) +
    ggrepel::geom_text_repel(
      data = last_value_label_data,
      aes(x = date_report, y = {{avg_column}}, label = label),
      size = 4, # changer la taille texte geom_text
      force = 10,
      color = "black",
      nudge_y = c(0.5)
    ) +
    geom_line(data = temp, aes(x = date_report, y = {{avg_column}}), color = palette_OkabeIto["blue"], size = 1, alpha = 0.8)+
    theme(axis.text.x = element_text(angle = 30, vjust = 0.5, hjust=1))
}



# graph rough identity retourne la valeur absolue sans faire de moyenne ni diviser par la pop
graph_rough_identity <- function(type, variable, titre = NULL,  y_lab = NULL, hist_data = NULL, drop_total = FALSE, total_value = NULL){
  if(is.null(hist_data)) hist_data <- get_inspq_covid19_hist()
  type_column = enquo(type)
  type_column_name = quo_name(type_column)
  variable_column = enquo(variable)
  variable_column_name = quo_name(variable_column)

  temp <- type_par_pop_anything_quebec(type = {{type_column}}, variable = {{variable_column}}, hist_data = hist_data) %>%
    filter(date_report >= lubridate::ymd("2020-03-15")) %>%
    {if(drop_total & !is.null(total_value)) {
     filter(., groupe  != total_value)
        } else {identity(.)}
    }

last_value_label_data <-
  temp %>%
  filter(!is.na({{variable_column  }})) %>%
  group_by(groupe) %>%
  filter(date_report == max(date_report)) %>%
  ungroup() %>%
  select(date_report, {{variable_column}}, groupe) %>%
  #mutate(label = sprintf("%.1f", round( {{variable_column}}, 1)))
  mutate(label = format_chiffre({{variable_column}}, accuracy =0.1))


  p1 <- ggplot() +
    geom_line(data = temp, aes(x = date_report, y = {{variable_column}}), color = palette_OkabeIto["blue"], size = 1, alpha = 0.8) +
    facet_wrap(~groupe) +
    theme_simon() +
    labs(
      subtitle = paste0("Moyenne mobile 7 jours, dernière mise à jour le ", format(max(temp$date_report, na.rm = TRUE), format = format_francais)),
      caption = "gossé par @coulsim",
      x = "Date"
    ) +
    {if(!is.null(titre)){  labs(title = titre)}}+
    {if(!is.null(y_lab)){  labs(y = y_lab)}} +
    scale_y_continuous(expand = c(0, 0))+
    ggrepel::geom_text_repel(
      data = last_value_label_data,
      aes(x = date_report, y = {{variable_column}}, label = label),
      size = 4, # changer la taille texte geom_text
      force = 10,
      color = "black",
      nudge_y = c(0.5)
    ) +
    theme(axis.text.x = element_text(angle = 30, vjust = 0.5, hjust=1))
  p1
}




graph_rough_par_pop(region,  hos_quo_tot_n, "Nouvelles hospitalisations par million d'habitant par région", "Nouvelles hospitalisations par million", hist_data = hist)
myggsave(filename = "~/git/adhoc_prive/covid19_PNG/quebec_new_hospit_par_region.png")

graph_rough_par_pop(groupe_age,  hos_quo_tot_n, "Nouvelles hospitalisations par million d'habitant par groupe d'âge", "Nouvelles hospitalisations par million", hist_data = hist)
myggsave(filename = "~/git/adhoc_prive/covid19_PNG/quebec_new_hospit_par_age.png")


graph_rough_par_pop(region,  dec_quo_tot_n, "Décès par million d'habitant par région", "Décès par million", hist_data = hist)
myggsave(filename = "~/git/adhoc_prive/covid19_PNG/quebec_deces_par_region.png")

graph_rough_par_pop(groupe_age,  dec_quo_tot_n, "Décès par million d'habitant par groupe d'âge", "Décès par million", hist_data = hist)
myggsave(filename = "~/git/adhoc_prive/covid19_PNG/quebec_deces_par_age.png")


graph_rough_par_pop(region,  psi_quo_tes_n, "Tests par million d'habitant par région", "Tests par million", hist_data = hist)
myggsave(filename = "~/git/adhoc_prive/covid19_PNG/quebec_tests_par_region.png")

graph_rough_par_pop(groupe_age,  psi_quo_tes_n, "Tests par million d'habitant par groupe d'âge", "Tests par million", hist_data = hist)
myggsave(filename = "~/git/adhoc_prive/covid19_PNG/quebec_tests_par_age.png")
# graph rough identity
graph_rough_identity(region,  psi_quo_pos_t, "Taux de positivité par région", "Taux de positivité", hist_data = hist)
myggsave(filename = "~/git/adhoc_prive/covid19_PNG/quebec_positivite_par_region.png")

graph_rough_identity(groupe_age,  psi_quo_pos_t, "Taux de positivité par groupe d'âge", "Taux de positivité", hist_data = hist)
myggsave(filename = "~/git/adhoc_prive/covid19_PNG/quebec_positivite_par_age.png")


graph_rough_absolu(groupe_age,  dec_quo_tot_n, "Décès par âge (nombre absolu)", "Décès", hist_data = hist, drop_total = TRUE, total_value = "Total")
myggsave(filename = "~/git/adhoc_prive/covid19_PNG/quebec_deces_par_age_absolu.png")

graph_rough_absolu(groupe_age,  hos_quo_tot_n, "Nouvelles hospitalisations par âge (nombre absolu)", "Nouvelles hospitalisations", hist_data = hist, drop_total = TRUE, total_value = "Total")
myggsave(filename = "~/git/adhoc_prive/covid19_PNG/quebec_new_hospit_par_age_absolu.png")



graph_rough_absolu(groupe_age,  psi_quo_tes_n, "Tests par âge (nombre absolu)", "Tests", hist_data = hist, drop_total = TRUE, total_value = "Total")
myggsave(filename = "~/git/adhoc_prive/covid19_PNG/quebec_tests_par_age_absolu.png")

graph_rough_absolu(groupe_age,  cas_totaux_quotidien, "Cas par âge (nombre absolu)", "Tests", hist_data = hist, drop_total = TRUE, total_value = "Total")
myggsave(filename = "~/git/adhoc_prive/covid19_PNG/quebec_cas_par_age_absolu.png")



## graphiques vaccins ----
raw_vaccin <- get_raw_vaccination_data()

# https://community.rstudio.com/t/how-to-filter-programmatically/54185/11


ggplot(data = raw_vaccin %>% filter(regroupement == "Région", !(nom %in% c("Hors Québec", "Inconnue"))),
       aes(x= date_report, y = cvac_cum_tot_1_p/100))+
  geom_col(width = 1) +
  facet_wrap(~ nom)+
  theme_bw() +
  labs(title= "Pourcentage  cumulatif de personnes vaccinées  selon la région") +
  theme_simon() +
scale_y_continuous(labels = scales::label_percent())
myggsave(filename = "~/git/adhoc_prive/covid19_PNG/quebec_vaccin_region_pourcent_cumulatif.png")



ggplot(data = raw_vaccin %>% filter(regroupement == "Groupe d'âge 1") %>%
         mutate(nom = factor(nom, levels = c("Moins de 16 ans", "16 à 59 ans", "60 à 69 ans", "70 à 79 ans", "80 ans et plus", "Total"))),
       aes(x= date_report, y = cvac_cum_tot_1_p / 100))+
  geom_col(width = 1) +
  facet_wrap(~ nom) +
  theme_bw() +
  labs(title= "Pourcentage  cumulatif de personnes vaccinées  selon le groupe d'âge") +
  scale_y_continuous(labels = scales::label_percent())+
  theme_simon()
myggsave(filename = "~/git/adhoc_prive/covid19_PNG/quebec_vaccin_age_pourcent_cumulatif.png")

ggplot(data = raw_vaccin %>% filter(regroupement == "Groupe prioritaire", !(nom %in% c("Total"))),
       aes(x= date_report, y = vac_cum_tot_n))+
  geom_col(width = 1) +
  facet_wrap(~ nom)+
  theme_bw() +
  labs(title= "Nombre  cumulatif de personnes vaccinées  selon le groupe priotaire") +
  scale_y_continuous(labels = scales::label_number())+
  theme_simon()
myggsave(filename = "~/git/adhoc_prive/covid19_PNG/quebec_vaccin_groupe_prioritaire_cumulatif_absolu.png")

ggplot(data = raw_vaccin %>% filter(regroupement == "Sexe", !(nom %in% c("Total", "Inconnu"))),
       aes(x= date_report, y = vac_cum_tot_n))+
  geom_col(width = 1) +
  facet_wrap(~ nom)+
  theme_bw() +
  labs(title= "Nombre  cumulatif de personnes vaccinées  selon le sexe") +
  scale_y_continuous(labels = scales::label_number())+
  theme_simon()
myggsave(filename = "~/git/adhoc_prive/covid19_PNG/quebec_vaccin_sexe_cumulatif_absolu.png")

# graphique variants ----

variants <- get_variant_data()

ggplot(data = variants %>% filter(!(region_sociosanitaire %in% c("Hors Québec", "Inconnu") )),
       aes(x = date_report, y = quotidien_criblage_par_1M))+
  geom_col(width = 1) +
  facet_wrap(~ region_sociosanitaire)+
  theme_simon() +
  labs(title = "Nombre quotidients de cas de variants confirmés par criblage par région sociosanitaire par million d'habitant")
myggsave(filename = "~/git/adhoc_prive/covid19_PNG/quebec_variants_region_quotidien_pop.png")

ggplot(data = variants %>% filter(!(region_sociosanitaire %in% c("Hors Québec", "Inconnu") )),
       aes(x = date_report, y = quotidien_criblage))+
  geom_col(width = 1) +
  facet_wrap(~ region_sociosanitaire)+
  theme_simon() +
  labs(title = "Nombre quotidients de cas de variants confirmés par criblage par région sociosanitaire")
myggsave(filename = "~/git/adhoc_prive/covid19_PNG/quebec_variants_region_quotidien_absolu.png")
# mtl ----



message("graph mtl")
raw_mtl_data <- get_raw_mtl_data()
mtl_data <- fill_missing_dates_and_create_daily_counts_for_mtl_data(raw_mtl_data)
# heatmap mtl
graph_quebec_cas_par_mtl_heatmap(mtl_data = mtl_data)
myggsave(filename = "~/git/adhoc_prive/covid19_PNG/heatmap_mtl.png", width = 18, height = 22)

# carte mtl derniere journée
mtl_graph_data <- shp_mtl %>% inner_join(mtl_data %>% filter(date_report == max(date_report)))


get_vector_tiles <- function(bbox) {
  mz_box <- mz_rect(bbox$xmin, bbox$ymin, bbox$xmax, bbox$ymax)
  mz_vector_tiles(mz_box)
}


bbox <- st_bbox(mtl_graph_data)
bbox_quebec_lambert <- st_bbox(st_transform(mtl_graph_data, crs = quebec_lambert))
vector_tiles <- get_vector_tiles(bbox)
water <- as_sf(vector_tiles$water)
roads <- as_sf(vector_tiles$roads)

g <- ggplot() +
  geom_sf(data = water, fill = "#56B4E950", color = "#56B4E950", alpha = 1) +
  geom_sf(data = mtl_graph_data, aes(fill = cases_per_1M), color = "white") +
  # geom_sf(data = mtl_graph_data  , aes(fill=pmin(cases_per_1M, 1000)), color= "white")+

  scale_fill_gradientn(
    colours = c(palette_OkabeIto["bluishgreen"], palette_OkabeIto["yellow"], palette_OkabeIto["orange"], palette_OkabeIto["vermillion"], "black"),
    values = c(0, 20, 60, 100, pmax(500, max(mtl_graph_data$cases_per_1M))) / pmax(500, max(mtl_graph_data$cases_per_1M)), limits = c(0, pmax(500, max(mtl_graph_data$cases_per_1M))),
    name = "Cas par million"
  ) +
  # geom_sf(data = mtl_graph_data  , aes(fill=color_per_pop), color= "white")+
  # scale_fill_viridis_c() +
  #   scale_fill_manual(drop = TRUE,
  #                     limits = names(mes4couleurs), ## les limits  c'est nécessaire pour que toutes les valeurs apparaissent dans la légende même quand pas utilisée.
  #                     values = alpha(mes4couleurs, 1.0)
  #   ) +
  # #
  #   scale_fill_gradientn(colours = c(palette_OkabeIto["bluishgreen"] , palette_OkabeIto["yellow"], palette_OkabeIto["orange"], palette_OkabeIto["vermillion"], "black"),
  #                        values = c(0, 20, 60, 100, max(mtl_graph_data$cases_per_1M)) / max(mtl_graph_data$cases_per_1M), limits = c(0,max(mtl_graph_data$cases_per_1M)),
  #                        name = "Cas par million") +
  #
# scale_fill_gradientn(colours = c(palette_OkabeIto["bluishgreen"] , palette_OkabeIto["yellow"], palette_OkabeIto["orange"], palette_OkabeIto["vermillion"], "black"),
#                      values = c(0, 20, 60, 100, 1000) / 1000, limits = c(0,1000),
#                      name = "Cas par million") +
# scale_fill_gradientn(colours = c("white", palette_OkabeIto["vermillion"]),
#                      values = c(0,1), limits = c(0,1000),
#                      name = "Cas par million") +
labs(
  title = paste0("Nouveaux cas de covid par million d'habitants par arrondissement de Montréal"),
  fill = "Cas par 1M habitants",
  subtitle = paste0("en date du ", format(max(mtl_graph_data$date_report), format = format_francais), ". (moyenne mobile sur 7 jours)"),
  caption = paste0("gossé par @coulsim")
) +
  cowplot::theme_map() +
  theme(
    text = element_text(size = 12), # tous les textes... sauf geom_text
    strip.text.x = element_text(size = 12, angle = 0, hjust = 0), # change la  taille et angle du texte facet
    plot.title = element_text(size = 14),
    plot.subtitle = element_text(size = 12),
    plot.caption = element_text(size = 12),
    legend.text = element_text(size = 12)
  ) +
  theme(legend.position = c(0.9, 0.4)) +
  geom_sf(data = roads %>% filter(kind == "highway"), colour = "grey10") +
  coord_sf(
    crs = quebec_lambert,
    xlim = c(bbox_quebec_lambert["xmin"], bbox_quebec_lambert["xmax"]),
    ylim = c(bbox_quebec_lambert["ymin"], bbox_quebec_lambert["ymax"])
  )
g
myggsave(filename = "~/git/adhoc_prive/covid19_PNG/carte_mtl.png", width = 15, height = 10)
# version animée? ----

if (FALSE) {
  library(gganimate)
  mtl_animated_graph <- mtl_data %>%
    inner_join(shp_mtl) %>%
    st_as_sf() # %>% filter(date_report >= lubridate::ymd("202001"))

  bbox <- st_bbox(mtl_animated_graph)
  bbox_quebec_lambert <- st_bbox(st_transform(mtl_animated_graph, crs = quebec_lambert))
  vector_tiles <- get_vector_tiles(bbox)
  water <- as_sf(vector_tiles$water)
  roads <- as_sf(vector_tiles$roads)

  plot1 <- ggplot() +
    geom_sf(data = water, fill = "#56B4E950", color = "#56B4E950", alpha = 1) +
    geom_sf(data = mtl_graph_data, aes(fill = cases_per_1M), color = "white") +
    scale_fill_gradientn(
      colours = c(palette_OkabeIto["bluishgreen"], palette_OkabeIto["yellow"], palette_OkabeIto["orange"], palette_OkabeIto["vermillion"], "black"),
      values = c(0, 20, 60, 100, pmax(500, max(mtl_graph_data$cases_per_1M))) / pmax(500, max(mtl_graph_data$cases_per_1M)), limits = c(0, pmax(500, max(mtl_graph_data$cases_per_1M))),
      name = "Cas par million"
    ) +
    labs(
      title = paste0("Nouveaux cas de covid par million d'habitants par arrondissement de Montréal"),
      fill = "Cas par 1M habitants",
      subtitle =
        "{paste('au  ',
               lubridate::month(frame_time, label = TRUE, abbr = FALSE),
               lubridate::day(frame_time),
               ',',
               lubridate::year(frame_time)
               )
           }",

      caption = paste0("gossé par @coulsim")
    ) +
    cowplot::theme_map() +
    theme(
      text = element_text(size = 12), # tous les textes... sauf geom_text
      strip.text.x = element_text(size = 12, angle = 0, hjust = 0), # change la  taille et angle du texte facet
      plot.title = element_text(size = 14),
      plot.subtitle = element_text(size = 12),
      plot.caption = element_text(size = 12),
      legend.text = element_text(size = 12)
    ) +
    theme(legend.position = c(0.9, 0.4)) +
    geom_sf(data = roads %>% filter(kind == "highway"), colour = "grey10") +
    coord_sf(
      crs = quebec_lambert,
      xlim = c(bbox_quebec_lambert["xmin"], bbox_quebec_lambert["xmax"]),
      ylim = c(bbox_quebec_lambert["ymin"], bbox_quebec_lambert["ymax"])
    ) +
    transition_time(date_report) +
    ease_aes("linear")
  # plot1

  my_end_pause <- 6
  my_frames <- 1 * (as.numeric(max(mtl_animated_graph$date_report) - min(mtl_animated_graph$date_report)) + 1) + my_end_pause
  my_fps <- 3

  animated_gif1 <- animate(plot1, nframes = my_frames, fps = my_fps, end_pause = my_end_pause, width = 775, height = 650)
  anim_save("mtl.gif", animated_gif1)
}

## leaflet des caps par million ----

if (FALSE) {
  library(mapview)

  library(RColorBrewer)
  rls_last_week <- shp_rls %>%
    left_join(rls_data %>% filter(date_report == max(date_report))) %>%
    filter(!is.na(cases_per_1M))
  mymap <- mapview::mapview(rls_last_week,
                            zcol = "cases_per_1M",
                            layer.name = paste0("Nombre moyen quotidien de cas de covid19 <br>par million d'habitant <br> pour la semaine se terminant le ", max(rls_last_week$date_report, na.rm = TRUE)),
                            col.regions = brewer.pal(3, "YlOrRd"),
                            popup = leafpop::popupTable(rls_last_week,
                                                        zcol = c("RLS_nom", "cumulative_cases", "cases", "cases_per_1M", "Population")
                            ) # ,
                            # label = makeLabels(rls_last_week,
                            #                  zcol = c("RLS_nom","cumulative_cases", "cases", "cases_per_1M", "Population" ))
  )


  mapview::mapshot(
    mymap,
    url = "~/git/adhoc_prive/covid19_PNG/leaflet_cas_rls.html",
    vwidth = 1080, vheight = 1080,
    selfcontained = TRUE
  )
}


source("/home/simon/git/covidtwitterbot/analysis/save_on_amazon_bucket.R")
source("/home/simon/git/covidtwitterbot/analysis/tweet_du_midi.R")
tictoc::toc()
