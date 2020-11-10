#' graph_deces_hospit_tests
#' @return
#' @export
#' @examples graph_deces_hospit_tests()
#' @importFrom ggplot2 '%+replace%'
#' @importFrom ggplot2 theme margin element_text element_line element_blank xlim ylim scale_y_continuous scale_x_continuous
graph_deces_hospit_tests <- function(){
  rr <- load_inspq_manual_data() %>%
    dplyr::filter(date >= lubridate::ymd("20200315")) %>%
    dplyr::select(date, soins_intensifs = si, volumetrie, hospits,hospits_ancien)  %>%
    dplyr::mutate(hospitalisations = dplyr::coalesce(hospits, hospits_ancien)) %>%
    dplyr::select(-hospits, -hospits_ancien) %>%
    tidyr::gather(key= type, value = nombre, soins_intensifs, hospitalisations,volumetrie)   %>%
    dplyr::bind_rows(load_inspq_covid19_hist() %>% dplyr::filter(!is.na(date), groupe == "Ensemble du Québec") %>%
                       dplyr::select(date, nombre = deces_totaux_quotidien) %>%
                       dplyr::mutate(type = "deces")) %>%
    dplyr::group_by(type) %>%
    dplyr::arrange(date) %>%
    dplyr::mutate(moyenne7 = (nombre+ dplyr::lag(nombre,1)+ dplyr::lag(nombre,2)+ dplyr::lag(nombre,3)+ dplyr::lead(nombre,1)+ dplyr::lead(nombre,2)+ dplyr::lead(nombre,3))/7) %>%
    dplyr::ungroup()

  p1 <-rr %>%
    ggplot2::ggplot(ggplot2::aes(x= date, y = nombre )) +
    ggplot2::geom_col(width=1) +
    ggplot2::geom_line(data = rr, ggplot2::aes(x= date, y= moyenne7), color = palette_OkabeIto["vermillion"], size =1, alpha=0.8) +
    ggplot2::facet_wrap(~type, ncol =1, scales ="free_y" )+
    theme_simon(font_size = 12) +
    ggplot2::theme(axis.text.x = element_text(angle = 30, hjust = 1, vjust = 1, color="gray50")) +
    ggplot2::labs(
      title = "Décès quotidiens, hospitalisations, soins intensifs, tests",
      x = "date",
      y = "Nombre") +
    xlim(lubridate::ymd("20200315"), NA)+
    scale_y_continuous(expand = c(0,0))

  p1

}
