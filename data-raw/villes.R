library(tidyverse)
library(ggmap)
library(sf)
ggmap::register_google(
  key = Sys.getenv("googlemap_api_key"),
  account_type = "premium"
)
cities <- c("Montréal", "Sherbrooke", "Quebec city", "Trois-Rivières", "Gatineau", "Saguenay", "Rivière-du-Loup", "Saint-Georges-de-Beauce")
latlongs <- geocode(cities)
villes <- tibble(cities, lon = latlongs$lon, lat = latlongs$lat)


readr::write_csv(villes, "data-raw/villes.csv")


villes <- st_as_sf(villes, coords = c("lon", "lat"), remove = FALSE, crs = 4326, agr = "constant")
usethis::use_data(villes)
