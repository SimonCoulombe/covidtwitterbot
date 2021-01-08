#' carte_css
#'
#' @return
#' @export
#'
#' @examples
carte_css <- function(css_last_week = NULL, type = "maximum"){

  if (is.null(css_last_week)) css_last_week <- get_css_last_week()

  g <- ggplot(data = css_last_week)+
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
                             values = c(0, 20, 60, 100, max(css_last_week$cases_per_1M)) / max(css_last_week$cases_per_1M), limits = c(0,max(css_last_week$cases_per_1M)),
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
                             values = c(0, 20, 60, 100, pmax(500,max(css_last_week$cases_per_1M))) / pmax(500,max(css_last_week$cases_per_1M)), limits = c(0,pmax(500,max(css_last_week$cases_per_1M))),
                             name = "Cas par million")
      }
    }+
    {
      if (type == "maximum500rouge"){
        geom_sf(aes(fill=cases_per_1M), color = "grey50")
      }
    } +
    {
      if(type == "maximum500rouge"){
        scale_fill_gradientn(colours = c("white", palette_OkabeIto["vermillion"]),
                             values = c(0,1), limits = c(0,pmax(500, max(css_last_week$cases_per_1M))),
                             name = "Cas par million")
      }
    }+
    labs(title = paste0("Nouveaux cas de covid par million d'habitants par centre de services scolaires"),
         fill = "Cas par 1M habitants",
         subtitle = paste0("en date du " , format(max(css_last_week$date_report), format=format_francais),". (moyenne mobile sur 7 jours)"),
         caption = paste0("Les données sont publiées au niveau des réseaux locaux de service (RLS) et distribuées aux centres de services scolaires (CS)",
                          "\n proportionnellement à la population lorsque le RLS couvre plus d'un CSS",
                          "\n gossé par @coulsim")
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
                               st_transform(quebec_lambert) %>%
                               mutate(
                                 lon= map_dbl( geometry, ~st_coordinates(.x)[1]),
                                 lat= map_dbl( geometry, ~st_coordinates(.x)[2])
                               ) %>% st_drop_geometry(),
                             aes(x = lon, y = lat, label = cities),  #
                             fontface = "bold",
                             nudge_x = c(0   , 0    , 2e5    , 3e5, 0      , 0   , 2e5   , 3e5),
                             nudge_y = c(-1e5, -1e5 , -0.5e5 ,-1e5,-0.25e5 , 0e5 , -0.8e5,-0.5e5)
    ) +
    theme(legend.position= c(0.75,0.9))  +
    coord_sf(crs = quebec_lambert)
  g
}


#' Title
#'
#' @param css_last_week OPTIONAL: if you provide a dataframe created by css_last_week then you don't need to redownload everything again.
#'
#' @return
#' @export
#' @importFrom ggplot2 geom_hline coord_flip
#' @examples
graph_css_bars <- function(css_last_week = NULL){

  if (is.null(css_last_week)) css_last_week <- get_css_last_week()

g <- css_last_week %>%
  arrange(-dailycases_per_1M_avg_7_days)  %>%
  mutate(NOM_CS_petit_nom = as.factor(NOM_CS_petit_nom) )%>%
  ggplot(aes(x= fct_reorder(NOM_CS_petit_nom, dailycases_per_1M_avg_7_days), y= dailycases_per_1M_avg_7_days )) +
  scale_y_continuous(expand = c(0, 0), limits = c(0, NA), position = "right")+
  geom_col(aes(fill = color_per_pop), width=  0.8) +
  scale_fill_manual(drop = TRUE,
                    limits = names(mes4couleurs), ## les limits (+myColors?) c'est nécessaire pour que toutes les valeurs apparaissent dans la légende même quand pas utilisée.
                    values = mes4couleurs)+
  geom_hline(yintercept = 20, color = "black", size =1 ) +
  geom_hline(yintercept = 60, color = "black", size =1 ) +
  geom_hline(yintercept = 100, color = "black", size =1 ) +
  coord_flip() +
  theme_simon() +
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank()) + # remove grids
  scale_color_OkabeIto() +
  labs(
    title = "Nombre de nouveaux cas de covid par million d'habitants dans les centres de services scolaires",
    subtitle = paste0("moyenne mobile sur 7 jours, dernière mise à jour le " , format(max(css_last_week$date_report), format=format_francais) ),
    caption = paste0("Les données sont publiées au niveau des RLS (réseau local de service) et distribuées aux CSS proportionnellement à la population lorsque le RLS couvre plus d'une CSS"),
    x = "Centres de services scolaires",
    y= "Nombre de cas par million d'habitants",
    fill = "Nombre de cas par million d'habitants"
  ) +
  theme(legend.position = c(0.7, 0.2))#+
#theme(axis.title.y = element_text(angle = 0, hjust = 0, vjust= 1.03))

g
}
