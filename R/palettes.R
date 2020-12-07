## this palette_OkabeIto and  palette_OkabeIto_black were taken from clauswilke::colorblindr  because I'm not sure how to have my
## package install packages that arent on CRAN

#' Color palette proposed by Okabe and Ito
#'
#' Two color palettes taken from the article "Color Universal Design" by Okabe and Ito, http://jfly.iam.u-tokyo.ac.jp/color/.
#' The variant `palette_OkabeIto` contains a gray color, while `palette_OkabeIto_black` contains black instead.
#' code taken from @clauswilke's https://github.com/clauswilke/colorblindr/blob/master/R/palettes.R
#' @export
palette_OkabeIto <- c(orange= "#E69F00", skyblue="#56B4E9", bluishgreen="#009E73", yellow="#F0E442", blue="#0072B2", vermillion="#D55E00", reddishpurple="#CC79A7", gray="#999999")

#' @rdname palette_OkabeIto
#' @export
palette_OkabeIto_black <- c(orange= "#E69F00", skyblue="#56B4E9", bluishgreen="#009E73", yellow="#F0E442", blue="#0072B2", vermillion="#D55E00", reddishpurple="#CC79A7", black = "#000000")


#' mes4 couleurs de paliers d'alertes
#' @export
mes4couleurs <- setNames(
  c(palette_OkabeIto["bluishgreen"],
    palette_OkabeIto["yellow"],
    palette_OkabeIto["orange"],
    palette_OkabeIto["vermillion"]
  ),
  c("moins de 20 cas par million" ,
    "entre 20 et 60 cas par million",
    "entre 60 et 100 cas par million",
    "plus de 100 cas par million"
  )
)

