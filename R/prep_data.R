#' prep_data est une fonction qui prend une base  le nombre de cas / décès / hospit quotidien
#' et qui retourne 7 variables supplémentaires:
#'  avg_XXX_last7
#'  total
#'  worst7
#'  last7
#'  ratio
#'  winning.
#'  group <-- soit la variable de groupe (genre 0-9 ans) réordonnée en fonction du total décroissant.. on a tu vraiment besoin de ça??
#'
#' @param data  data frame
#' @param group  nom de variable groupe, ex: health_region ou groupe_age
#' @param type  type de ce qui est compté quotidiennement , ex: cases ou deaths ou hos
#'
#' @return
#' @export
#' @importFrom dplyr enquo quo_name
#' @importFrom rlang sym syms
#' @examples prep_data(cases_prov, province, variable = cases )
prep_data <- function(data, group, variable){

  variable_column <- enquo(variable)   ## this has to be !!
  variable_name <- quo_name(variable_column) ## its a string, dont !!
  mean_name = paste0("avg_", variable_name, "_last7")
  mean_column <- sym(mean_name)

  ## pour chaque date calculer la moyenne des 7 derniers jours
  gaa <-   data %>%
    group_by( {{ group }} ) %>%
    arrange(date_report) %>%
    mutate(!!mean_name := ( !!variable_column + lag(!!variable_column, 1) + lag(!!variable_column, 2) + lag(!!variable_column, 3) + lag(!!variable_column, 4) + lag(!!variable_column, 5) + lag(!!variable_column, 6)) / 7)  %>%
    ungroup()

  # pour le group, calculer le pire 7 jours et le dernier 7 jours et voir si on est dans le pire moment jusqu'à date..
  gaa1 <- gaa %>%
    group_by( {{ group }}) %>%
    summarise(total = sum(!!variable_column),
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
    ungroup()

  gaa %>%
    left_join(gaa1)

}
