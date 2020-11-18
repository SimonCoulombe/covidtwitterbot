library(tidyverse)
library(sf)
shp_rls <- sf::read_sf("data-raw/shp/rls_no_water.shp")


usethis::use_data(shp_rls)
