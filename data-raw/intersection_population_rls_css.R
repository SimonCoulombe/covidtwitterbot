# tictoc::tic()
library(tidyverse)
library(sf)
library(tongfen)
library(covidtwitterbot) # pour shp_rls et shp_css
library(cancensus) # to get population

shp_intersections <- st_intersection(
  shp_rls %>% select(RLS_code), ## RLS = région locale de service = health region,   RLS_code = health region id
  shp_css %>% select(CD_CS, NOM_CS)
) %>% ## CS = school board, CD_CS = school board id
  st_collection_extract(type = "POLYGON") ## drop polylines

census_data_da <- get_census(dataset = "CA16", regions = list(PR = "24"), vectors = c("pop2016" = "v_CA16_401"), level = "DA", geo_format = "sf")

intersections_populations_rls_css <- tongfen_estimate(
  shp_intersections,
  census_data_da,
  meta_for_additive_variables("census_data_da", "Population")
)
# tictoc::toc() #128seconds

usethis::use_data(intersections_populations_rls_css)
