library(tidyverse)
library(sf)
library(covidtwitterbot) # pour shp_water
# Here we create a RLS shapefile with simplified geometry where the borders match the shoreline instead of extending into the rivers/ocean.

# Input:
#  -Limites territoriales des réseaux locaux de santé (RLS) en 2020  (https://www.donneesquebec.ca/recherche/fr/dataset/limites-territoriales/resource/a73c9996-010d-41ac-a4ba-4def322d55bf)
#  - Coastal waters (polygons) from Statistics Canada. I used the polygons from the 2011 census by mistake.. but water shouldnt move much.  https://www12.statcan.gc.ca/census-recensement/2011/geo/bound-limit/bound-limit-2011-eng.cfm

# Technique:
#  - merge all the water polygons into a single geometry collection using summarise(),
#  - make these features valid, simplify them, make them valid again
#  - extract the polycons from the geometry collection using st_collection_extract(type="POLYGON")
#  - remove the water from the RLS polygons using st_difference.  Then make

rls_shp_simple <- read_sf("~/git/adhoc_prive/data/downloads/Territoires_RLS_2020.shp") %>%
  st_transform(crs = 4326) %>%
  rmapshaper::ms_simplify()

# write_sf(rls_shp_simple,here::here("data/processed/Territoires_RLS_2020_simple.shp"))

rls_no_water <- st_difference(rls_shp_simple, shp_water) # shp_water est fourni avec le package..

shp_rls <- rls_no_water %>%
  rmapshaper::ms_simplify(keep = 0.7) %>%
  sf::st_make_valid() %>%
  st_collection_extract(type = "POLYGON")


usethis::use_data(shp_rls)
