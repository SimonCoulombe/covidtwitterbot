#' format de date en anglais
#' @export
format_francais <- "%d %B %Y"

#' format de date en anglais
#' @export
format_anglais <- "%B %d %Y"



#' format date as string 10 novembre 2021
#' @export
format_date_francais <- "%d %B %Y"

#' format date as string November 10 2021
#' @export
format_date_anglais <- "%B %d %Y"


#' convert number to character, with a " " bigmark separator
#' @export
format_chiffre <- function(chiffre, big.mark = " ", ...){
  scales::label_number( big.mark = big.mark,...)(chiffre)   # format_chiffre(123456.12345, accuracy = 0.1)
}

#' convert number to character with a percentage sign
#' @export
format_pourcent <- function(chiffre, accuracy = 0.1, suffix = "%", ...){
  scales::label_percent(accuracy = accuracy, suffix = suffix, ...)(chiffre)
}

#' convert number to character with a dollar sign
#' @export
format_piasse <-  function(chiffre, big.mark = " ", prefix = "", suffix =" $", ...){
  scales::label_dollar(big.mark = big.mark, prefix = prefix, suffix = suffix,...)(chiffre)
}
