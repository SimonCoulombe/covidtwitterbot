library(sf)
library(tidyverse)

# This program generates 'shp_water', a shapefile based on Statistics Canada "Coastal waters (polygons)"  for CEnsus 2011
# https://www12.statcan.gc.ca/census-recensement/2011/geo/bound-limit/bound-limit-2011-eng.cfm
# NOTE: I tried 2016, but there appears to be a broken polygon in there across the North.

water_shapefile <- st_read("~/git/adhoc_prive/data/downloads/ghy_000h11a_e/ghy_000h11a_e.shp", options = "ENCODING=WINDOWS-1252")


water_shapefile_simple <- water_shapefile %>%
  rmapshaper::ms_simplify(keep=0.3) %>%
  sf::st_make_valid() %>%
  sf::st_transform( crs = 4326)

water_single_collection <- water_shapefile_simple %>%
  mutate( dummy = 1 ) %>%
  group_by(dummy) %>%
  summarise(dummy2= 1)

water_single_collection2 <- water_single_collection %>%
  sf::st_make_valid() %>%
  rmapshaper::ms_simplify(keep=0.7) %>%
  sf::st_make_valid()

shp_water <- water_single_collection2 %>%
  st_collection_extract(type="POLYGON")

#mapview::mapview(water_clean)

#  inondable4 <-  inondable3 %>% sf::st_make_valid()
# inondable5 <- inondable4 %>% rmapshaper::ms_simplify(keep=0.3)%>% sf::st_make_valid()
#st_write(inondable5, here::here("data/water_union_valid_simple.shp"))

#water_union_valid_simple <- read_sf(here::here("data/water_union_valid_simple.shp"))
