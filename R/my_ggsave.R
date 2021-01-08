#' myggsave sauvegarde les ggplot avec une hauteur et largeur par défaut..
#'
#' @param filename
#' @param plot
#' @param height
#' @param width
#' @param dpi
#' @param ...
#'
#' @return
#' @export
#' @importFrom ggplot2 ggsave last_plot
#'
#' @examples
myggsave <- function(filename = default_name(plot), plot = last_plot(),
                     height = 9, width = 12, dpi = 250, ...) {
  ggsave(filename = filename, plot, height = height, width = width, dpi = dpi, ...)
}
