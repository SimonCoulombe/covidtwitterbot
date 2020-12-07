# test <- function(){
#
#   mtl <- get_mtl_data()
#   mtl_cases  <- prep_data(mtl, arrondissement, variable = cases) %>%
#     filter(arrondissement != "Territoire à confirmer")
#   heatmap_cas(mtl_cases, arrondissement, "Arrondissement")
# }
#
#
#

#' graph_quebec_cas_par_mtl_heatmap
#'
#' @return
#' @export
#' @importFrom stringr str_pad
#' @importFrom lubridate year month day hms isoweek
#' @importFrom ggplot2 geom_tile scale_fill_gradientn geom_text
#' @examples
graph_quebec_cas_par_mtl_heatmap <- function(mtl_data = NULL){
  if(is.null(mtl_data)) mtl_data <- get_mtl_data()

  mtl_cases <- prep_data(mtl_data, arrondissement, variable = cases) %>%
         filter(arrondissement != "Territoire à confirmer")
  heatmap_cas(mtl_cases, arrondissement, "Arrondissement")
}
