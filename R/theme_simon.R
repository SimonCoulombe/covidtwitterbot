#' Appliquer mon theme..
#'
#' @param font_size
#' @param font_family
#'
#' @return
#' @export
#'
#' @examples
theme_simon <- function(font_size = 14, font_family = "") {
  color = "grey90"
  line_size = 0.5

  # Starts with theme_cowplot and then modify some parts
  cowplot::theme_cowplot(font_size = font_size, font_family = font_family) +
    cowplot::background_grid() +
    theme(axis.line = element_line(color = color),
          axis.ticks =  element_line(colour  = color, size = line_size),# lignes et ticks des axes gris
          strip.background = element_blank(),  # enlever le gris des facettes
          axis.text.y = element_text(color="gray50"),
          axis.title.x = element_text(color="gray50"),
          axis.title.y = element_text(color="gray50"),
          text = element_text(size=font_size), # tous les textes... sauf geom_text
          strip.text.x = element_text(#size = font_size,
                                      angle = 0,
                                      hjust = 0), # change la  taille et angle du texte facet
          plot.title = element_text(#size=font_size,
                                    margin=margin(5,0,0,0)
                                    ),
          plot.subtitle = element_text(  margin=margin(0,0,0,0),
                                         #size=font_size
                                         )#,
          #plot.caption = element_text(size=font_size),
          #axis.title =  element_text(size=font_size),
          #axis.text =element_text(size=font_size),
          #legend.text = element_text(size=font_size)
    )


}
