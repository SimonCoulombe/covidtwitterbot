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
  cowplot::theme_cowplot(font_size = font_size, font_family = font_family) %+replace%
    theme(
      # make horizontal grid lines
      panel.grid.major   = element_line(colour = color,
                                        size = line_size),

      # adjust axis tickmarks
      axis.ticks        = element_line(colour = color, size = line_size),

      # no x or y axis lines
      axis.line.x       = element_blank(),
      axis.line.y       = element_blank()
    )
}
