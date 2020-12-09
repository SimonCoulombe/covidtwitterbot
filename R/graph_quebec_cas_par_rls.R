
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
#' @importFrom sf st_transform st_bbox st_buffer st_transform st_intersection
#' @importFrom units set_units
#' @importFrom patchwork inset_element
#' @examples
carte_rls <- function(rls_data = NULL, type = "maximum500"){
  if(is.null(rls_data)) rls_data <- get_rls_data()

  rls_last_week <- shp_rls %>%
    left_join(rls_data %>%
                group_by(RLS_code) %>%
                filter(date_report ==max(date_report)) %>%
                ungroup() %>%
                select(date_report, RLS_code, cases_last_7_days_per_100k, cumulative_cases, cases_last_7_days, previous_cases_last_7_days, Population, cases_per_1M, last_cases_per_1M,color_per_pop)) %>%
    mutate(dailycases_per_1M_avg_7_days = round(last_cases_per_1M,1))




g <- ggplot(data = rls_last_week)+
    #geom_sf(data= water, fill = bleu_eau, color = bleu_eau, alpha = 1 )+
    {
      if (type == "paliers"){
        geom_sf( aes(fill=color_per_pop), color = "white")
      }
    } +
    {
      if(type == "paliers"){
        scale_fill_manual(drop = TRUE,
                          limits = names(mes4couleurs), ## les limits  c'est nécessaire pour que toutes les valeurs apparaissent dans la légende même quand pas utilisée.
                          values = alpha(mes4couleurs, 1.0)
        )
      }
    } +
    {
      if (type == "maximum"){
        geom_sf( aes(fill=cases_per_1M), color = "white")
      }
    } +
    {
      if(type == "maximum"){
        scale_fill_gradientn(colours = c(palette_OkabeIto["bluishgreen"] , palette_OkabeIto["yellow"], palette_OkabeIto["orange"], palette_OkabeIto["vermillion"], "black"),
                             values = c(0, 20, 60, 100, max(rls_last_week$cases_per_1M)) / max(rls_last_week$cases_per_1M), limits = c(0,max(rls_last_week$cases_per_1M)),
                             name = "Cas par million")
      }
    }+
    {
      if (type == "maximum500"){
        geom_sf(aes(fill=cases_per_1M), color = "white")
      }
    } +
    {
      if(type == "maximum500"){
        scale_fill_gradientn(colours = c(palette_OkabeIto["bluishgreen"] , palette_OkabeIto["yellow"], palette_OkabeIto["orange"], palette_OkabeIto["vermillion"], "black"),
                             values = c(0, 20, 60, 100, pmax(500,max(rls_last_week$cases_per_1M))) / pmax(500,max(rls_last_week$cases_per_1M)), limits = c(0,pmax(500,max(rls_last_week$cases_per_1M))),
                             name = "Cas par million")
      }
    }+
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
    # ggrepel::geom_text_repel(data = villes %>%
    #                            st_transform(crs = quebec_lambert) %>%
    #                            mutate(
    #                              lon= map_dbl( geometry, ~st_coordinates(.x)[1]),
    #                              lat= map_dbl( geometry, ~st_coordinates(.x)[2])
    #                            ) %>% st_drop_geometry(),
    #                          aes(x = lon, y = lat, label = cities),  #
    #                          fontface = "bold",
    #                          nudge_x = c(0   , 0    , 2e5    , 3e5, 0      , 0   , 2e5   , 3e5),
    #                          nudge_y = c(-1e5, -1e5 , -0.5e5 ,-1e5,-0.25e5 , 0e5 , -0.8e5,-0.5e5)
    # ) +
    theme(legend.position= c(0.05,0.8))  +
    coord_sf(crs = quebec_lambert) #+
    #theme(legend.box.background = element_rect(color="black", size=0.5))+ # rectangle autour de la légende
    #theme(legend.margin=margin(t = 3, r = 3, b = 3, l = 3, unit='mm')) # buffer entre rectangle et légende
  g


  # ok on fait un rond pour montréal ----
  circ_buffer_large <- st_buffer(villes %>% filter(cities =="Montréal")  %>% st_transform(32618), dist = units::set_units(40,km))
  stuff_dans_le_rond <- rls_last_week %>% st_transform(32618) %>% st_intersection(circ_buffer_large)

    mtl_graph <- ggplot(data = stuff_dans_le_rond)+
    #geom_sf(data= water, fill = bleu_eau, color = bleu_eau, alpha = 1 )+
    {
      if (type == "paliers"){
        geom_sf( aes(fill=color_per_pop), color = "white")
      }
    } +
    {
      if(type == "paliers"){
        scale_fill_manual(drop = TRUE,
                          limits = names(mes4couleurs), ## les limits  c'est nécessaire pour que toutes les valeurs apparaissent dans la légende même quand pas utilisée.
                          values = alpha(mes4couleurs, 1.0)
        )
      }
    } +
    {
      if (type == "maximum"){
        geom_sf( aes(fill=cases_per_1M), color = "white")
      }
    } +
    {
      if(type == "maximum"){
        scale_fill_gradientn(colours = c(palette_OkabeIto["bluishgreen"] , palette_OkabeIto["yellow"], palette_OkabeIto["orange"], palette_OkabeIto["vermillion"], "black"),
                             values = c(0, 20, 60, 100, max(rls_last_week$cases_per_1M)) / max(rls_last_week$cases_per_1M), limits = c(0,max(rls_last_week$cases_per_1M)),
                             name = "Cas par million")
      }
    }+
    {
      if (type == "maximum500"){
        geom_sf(aes(fill=cases_per_1M), color = "white")
      }
    } +
    {
      if(type == "maximum500"){
        scale_fill_gradientn(colours = c(palette_OkabeIto["bluishgreen"] , palette_OkabeIto["yellow"], palette_OkabeIto["orange"], palette_OkabeIto["vermillion"], "black"),
                             values = c(0, 20, 60, 100, pmax(500,max(rls_last_week$cases_per_1M))) / pmax(500,max(rls_last_week$cases_per_1M)), limits = c(0,pmax(500,max(rls_last_week$cases_per_1M))),
                             name = "Cas par million")
      }
    }+
    cowplot::theme_map()+
    theme(text = element_text(size=12), # tous les textes... sauf geom_text
          strip.text.x = element_text(size = 12, angle = 0, hjust = 0), # change la  taille et angle du texte facet
          plot.title = element_text(size=14),
          plot.subtitle = element_text(size=12),
          plot.caption = element_text(size=12),
          legend.text = element_text(size=12)
    ) +
      theme(legend.position = "none")



    # ok on fait un rond pour québec ----
    circ_buffer_large <- st_buffer(villes %>% filter(cities =="Quebec city")  %>% st_transform(32619), dist = units::set_units(60,km))
    stuff_dans_le_rond <- rls_last_week %>% st_transform(32619) %>% st_intersection(circ_buffer_large)

    qc_graph <- ggplot(data = stuff_dans_le_rond)+
      #geom_sf(data= water, fill = bleu_eau, color = bleu_eau, alpha = 1 )+
      {
        if (type == "paliers"){
          geom_sf( aes(fill=color_per_pop), color = "white")
        }
      } +
      {
        if(type == "paliers"){
          scale_fill_manual(drop = TRUE,
                            limits = names(mes4couleurs), ## les limits  c'est nécessaire pour que toutes les valeurs apparaissent dans la légende même quand pas utilisée.
                            values = alpha(mes4couleurs, 1.0)
          )
        }
      } +
      {
        if (type == "maximum"){
          geom_sf( aes(fill=cases_per_1M), color = "white")
        }
      } +
      {
        if(type == "maximum"){
          scale_fill_gradientn(colours = c(palette_OkabeIto["bluishgreen"] , palette_OkabeIto["yellow"], palette_OkabeIto["orange"], palette_OkabeIto["vermillion"], "black"),
                               values = c(0, 20, 60, 100, max(rls_last_week$cases_per_1M)) / max(rls_last_week$cases_per_1M), limits = c(0,max(rls_last_week$cases_per_1M)),
                               name = "Cas par million")
        }
      }+
      {
        if (type == "maximum500"){
          geom_sf(aes(fill=cases_per_1M), color = "white")
        }
      } +
      {
        if(type == "maximum500"){
          scale_fill_gradientn(colours = c(palette_OkabeIto["bluishgreen"] , palette_OkabeIto["yellow"], palette_OkabeIto["orange"], palette_OkabeIto["vermillion"], "black"),
                               values = c(0, 20, 60, 100, pmax(500,max(rls_last_week$cases_per_1M))) / pmax(500,max(rls_last_week$cases_per_1M)), limits = c(0,pmax(500,max(rls_last_week$cases_per_1M))),
                               name = "Cas par million")
        }
      }+
      cowplot::theme_map()+
      theme(text = element_text(size=12), # tous les textes... sauf geom_text
            strip.text.x = element_text(size = 12, angle = 0, hjust = 0), # change la  taille et angle du texte facet
            plot.title = element_text(size=14),
            plot.subtitle = element_text(size=12),
            plot.caption = element_text(size=12),
            legend.text = element_text(size=12)
      ) +
      theme(legend.position = "none")


# patchwork that shit
fail <-     g +
      inset_element(mtl_graph, bottom = 0.64, left = 0.62, top = 0.97, right = 0.95) +
  inset_element(qc_graph, bottom= 0.01, left = 0.67, top = 0.26, right = 0.95)
fail$patches$layout$widths  <- 1
fail$patches$layout$heights <- 1

fail
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

    # ggrepel::geom_label_repel(
    #   data =rls_last_week %>% filter(RSS_code %in% c("06", "13")|
    #                        RLS_code %in% c("1515", "1517", "1412", "1621", "1611","1634", "1516", "1631")),
    #
    #   aes(label = RLS_nom, geometry = geometry),
    #   stat = "sf_coordinates",
    #   min.segment.length = 0) +
    coord_sf(crs = quebec_lambert) +
    coord_sf(xlim = c(-73.99, -73.41), ylim = c(45.39, 45.72), expand = FALSE)

  g
}
