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
    theme(axis.line = element_line(color = "gray90"),
          axis.ticks =  element_line(colour  = "gray90", size = 0.5),# lignes et ticks des axes gris
          strip.background = element_blank(),  # enlever le gris des facettes
          axis.text.y = element_text(color="gray50"),
          axis.title.x = element_text(color="gray50"),
          axis.title.y = element_text(color="gray50"),text = element_text(size=10), # tous les textes... sauf geom_text
          strip.text.x = element_text(size = 10, angle = 0, hjust = 0), # change la  taille et angle du texte facet
          plot.title = element_text(size=10,  margin=margin(5,0,0,0)),
          plot.subtitle = element_text(size=10,  margin=margin(0,0,0,0)),
          plot.caption = element_text(size=10),
          axis.title =  element_text(size=10),
          axis.text =element_text(size=10),
          legend.text = element_text(size=10)
    )


}
