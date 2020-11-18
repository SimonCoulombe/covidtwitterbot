
#' graph_quebec_cas_par_rls_heatmap
#'
#' @return
#' @export
#' @importFrom stringr str_pad
#' @importFrom lubridate year month day hms isoweek
#' @importFrom ggplot2 geom_tile scale_fill_gradientn geom_text
#' @examples
graph_quebec_cas_par_rls_heatmap <- function(){


  rls <- get_clean_rls_data()
  rls_cases <- prep_data(rls, shortname_rls, type = cases)
  heatmap_cas(rls_cases, RLS_petit_nom, "RLS")
}



