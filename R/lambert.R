
#' String to define the Statistics Canada lambert projection
#' #' Projection found at https://spatialreference.org/ref/epsg/3347/
#' actual string from: https://spatialreference.org/ref/epsg/3347/proj4/
#' appears to fit the description on statistics canada here  https://www150.statcan.gc.ca/n1/pub/92-195-x/2011001/other-autre/mapproj-projcarte/m-c-eng.htm
#' @export
statistics_canada_lambert <- '+proj=lcc +lat_1=49 +lat_2=77 +lat_0=63.390675 +lon_0=-91.86666666666666 +x_0=6200000 +y_0=3000000 +ellps=GRS80 +datum=NAD83 +units=m +no_defs'

#' String to define the Quebec lambert projection
#'
#' Projection found at https://spatialreference.org/ref/epsg/nad83-quebec-lambert/
#' with the actual string found at # https://spatialreference.org/ref/epsg/nad83-quebec-lambert/proj4/
#' @export
quebec_lambert <- '+proj=lcc +lat_1=60 +lat_2=46 +lat_0=44 +lon_0=-68.5 +x_0=0 +y_0=0 +ellps=GRS80 +datum=NAD83 +units=m +no_defs'


#' @export
crs_utm_18N <- 32618 # pour montréal. pour calculer des buffers ronds en mètres comme dans le day 5 de https://gitlab.com/dickoa/30daymapchallenge/-/blob/master/day5/day5-blue.R
#  ça se trouve en comptant combien de zones de 6 degrés de longitude tu es à partir de -180 degrés..)

#' @export
crs_utm_19N <- 32619 # pour québec
