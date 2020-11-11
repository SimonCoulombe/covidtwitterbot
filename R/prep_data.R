#' prep_data
#'
#' @param data  data frame
#' @param group  nom de variable groupe, ex: health_region
#' @param type  type de ce qui est compté, ex: cases ou deaths
#'
#' @return
#' @export
#' @importFrom dplyr enquo quo_name
#' @importFrom rlang sym syms
#' @examples prep_data(cases_prov, province, type = cases )
prep_data <- function(data, group, type){

  type_column <- enquo(type)   ## this has to be !!
  type_name <- quo_name(type_column) ## its a string, dont !!
  mean_name = paste0("avg_", type_name, "_last7")
  mean_column <- sym(mean_name)
  gaa <-   data %>%
    group_by( {{ group }} ) %>%
    arrange(date_report) %>%
    mutate(!!mean_name := ( !!type_column + lag(!!type_column, 1) + lag(!!type_column, 2) + lag(!!type_column, 3) + lag(!!type_column, 4) + lag(!!type_column, 5) + lag(!!type_column, 6)) / 7)  %>%
    ungroup()

  gaa1 <- gaa %>%
    group_by( {{ group }}) %>%
    summarise(total = sum(!!type_column),
              worst7 = max(!!mean_column, na.rm = TRUE),
              last7  = max(!!mean_column * (date_report == max(date_report)), na.rm = TRUE),
              ratio = last7 / worst7,
              winning = factor(
                case_when(ratio < 0.33 ~ "Winning",
                          ratio < 0.67 ~ "Nearly there",
                          TRUE ~ "Needs action"
                )
                , levels = c("Winning", "Nearly there", "Needs action"))
    ) %>%
    ungroup() %>%

    mutate(
      group = fct_reorder( {{ group }}, total, .desc =TRUE)
    )

  gaa %>%
    left_join(gaa1)

}
