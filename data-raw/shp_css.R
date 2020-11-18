library(tidyverse)
library(sf)
library(covidtwitterbot) # pour shp_water

# Input : Shapefile "Centres de services scolaires francophones (SDA)" shapefile https://www.donneesquebec.ca/recherche/dataset/territoires-des-commissions-scolaires-du-quebec/resource/4cd70cc8-2663-4f10-bfce-bb46f62a77da

# shapefile css
CS_FRA_SDA_simple <- read_sf("~/git/adhoc_prive/data/downloads/CS/CS_FRA_SDA.shp") %>%
  rmapshaper::ms_simplify(keep = 0.3)  %>%
  sf::st_make_valid() %>%
  st_transform(crs=4326)



shp_css <- st_difference(CS_FRA_SDA_simple, shp_water) %>%
  rmapshaper::ms_simplify(keep = 0.5) %>%
  sf::st_make_valid() %>%
  st_collection_extract(type="POLYGON")


usethis::use_data(shp_css)
