
#' graph_quebec_cas_par_rls_heatmap
#'
#' @return
#' @export
#' @importFrom stringr str_pad
#' @importFrom lubridate year month day hms isoweek
#' @importFrom ggplot2 geom_tile scale_fill_gradientn geom_text
#' @examples
graph_quebec_cas_par_rls_heatmap <- function(rls_data = NULL){
  if(is.null(rls_data)) rls_data <- get_rls_data()

  rls_cases <- prep_data(rls_data, shortname_rls, variable = cases)
  heatmap_cas(rls_cases, RLS_petit_nom, "RLS")
}




#' carte_rls
#'
#' @return
#' @export
#' @importFrom ggplot2 geom_sf coord_sf scale_fill_manual alpha
#' @importFrom sf st_transform st_drop_geometry st_coordinates
#' @importFrom purrr map_dbl
#' @importFrom ggrepel geom_text_repel
#' @importFrom sf st_transform
#' @examples
carte_rls <- function(rls_data = NULL){
  if(is.null(rls_data)) rls_data <- get_rls_data()

  rls_last_week <- shp_rls %>%
    left_join(rls_data %>%
                group_by(RLS_code) %>%
                filter(date_report ==max(date_report)) %>%
                ungroup() %>%
                select(date_report, RLS_code, cases_last_7_days_per_100k, cumulative_cases, cases_last_7_days, previous_cases_last_7_days, Population, last_cases_per_1M,color_per_pop)) %>%
    mutate(dailycases_per_1M_avg_7_days = round(last_cases_per_1M,1))




  g <- ggplot()+
    geom_sf(data = rls_last_week  , aes(fill=color_per_pop))+
    scale_fill_manual(drop = TRUE,
                      limits = names(mes4couleurs), ## les limits  c'est nécessaire pour que toutes les valeurs apparaissent dans la légende même quand pas utilisée.
                      values = alpha(mes4couleurs, 1.0)
    ) +
    labs(title = paste0("Nouveaux cas de covid par million d'habitants par réseau local de service"),
         fill = "Cas par 1M habitants",
         subtitle = paste0("en date du " , format(max(rls_last_week$date_report), format=format_francais),". (moyenne mobile sur 7 jours)"),
         caption = paste0("gossé par @coulsim")
    )+
    cowplot::theme_map()+
    theme(text = element_text(size=12), # tous les textes... sauf geom_text
          strip.text.x = element_text(size = 12, angle = 0, hjust = 0), # change la  taille et angle du texte facet
          plot.title = element_text(size=14),
          plot.subtitle = element_text(size=12),
          plot.caption = element_text(size=12),
          legend.text = element_text(size=12)
    ) +
    ggrepel::geom_text_repel(data = villes %>%
                               st_transform(crs = quebec_lambert) %>%
                               mutate(
                                 lon= map_dbl( geometry, ~st_coordinates(.x)[1]),
                                 lat= map_dbl( geometry, ~st_coordinates(.x)[2])
                               ) %>% st_drop_geometry(),
                             aes(x = lon, y = lat, label = cities),  #
                             fontface = "bold",
                             nudge_x = c(0   , 0    , 2e5    , 3e5, 0      , 0   , 2e5   , 3e5),
                             nudge_y = c(-1e5, -1e5 , -0.5e5 ,-1e5,-0.25e5 , 0e5 , -0.8e5,-0.5e5)
    ) +
    theme(legend.position= c(0.7,0.9))  +
    coord_sf(crs = quebec_lambert)
  g
}


#' Title
#'
#' @param rls_data
#'
#' @return
#' @export
#'
#' @examples
carte_rls_zoom_montreal <- function(rls_data = NULL){
  if(is.null(rls_data)) rls_data <- get_rls_data()

  rls_last_week <- shp_rls %>%
    left_join(rls_data %>%
                group_by(RLS_code) %>%
                filter(date_report ==max(date_report)) %>%
                ungroup() %>%
                select(date_report, RLS_code, cases_last_7_days_per_100k, cumulative_cases, cases_last_7_days, previous_cases_last_7_days, Population, last_cases_per_1M,color_per_pop)) %>%
    mutate(dailycases_per_1M_avg_7_days = round(last_cases_per_1M,1))




  g <- ggplot()+
    geom_sf(data = rls_last_week  , aes(fill=color_per_pop))+
    scale_fill_manual(drop = TRUE,
                      limits = names(mes4couleurs), ## les limits  c'est nécessaire pour que toutes les valeurs apparaissent dans la légende même quand pas utilisée.
                      values = alpha(mes4couleurs, 1.0)
    ) +
    labs(title = paste0("Nouveaux cas de covid par million d'habitants par réseau local de service"),
         fill = "Cas par 1M habitants",
         subtitle = paste0("en date du " , format(max(rls_last_week$date_report), format=format_francais),". (moyenne mobile sur 7 jours)"),
         caption = paste0("gossé par @coulsim")
    )+
    cowplot::theme_map()+
    theme(text = element_text(size=12), # tous les textes... sauf geom_text
          strip.text.x = element_text(size = 12, angle = 0, hjust = 0), # change la  taille et angle du texte facet
          plot.title = element_text(size=14),
          plot.subtitle = element_text(size=12),
          plot.caption = element_text(size=12),
          legend.text = element_text(size=12)
    ) +
    theme(legend.position= "right")  +

    ggrepel::geom_label_repel(
      data =rls_last_week %>% filter(RSS_code %in% c("06", "13")|
                           RLS_code %in% c("1515", "1517", "1412", "1621", "1611","1634", "1516", "1631")),

      aes(label = RLS_nom, geometry = geometry),
      stat = "sf_coordinates",
      min.segment.length = 0) +
    coord_sf(crs = quebec_lambert) +
    coord_sf(xlim = c(-73.99, -73.41), ylim = c(45.39, 45.72), expand = FALSE)

  g
}
