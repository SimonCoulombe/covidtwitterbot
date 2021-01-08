library(tidyverse)
library(sf)
library(covidtwitterbot) # pour shp_water

# Input : Shapefile "Centres de services scolaires francophones (SDA)" shapefile https://www.donneesquebec.ca/recherche/dataset/territoires-des-commissions-scolaires-du-quebec/resource/4cd70cc8-2663-4f10-bfce-bb46f62a77da

# shapefile css
shp_arrondissement <- read_sf("~/git/adhoc_prive/data/downloads/LIMADMIN.shp") %>%
  sf::st_make_valid() %>%
  st_transform(crs = 4326)



shp_arrondissement <- st_difference(shp_arrondissement, shp_water) %>%
  sf::st_make_valid() %>%
  st_collection_extract(type = "POLYGON")


shp_arrondissement <- shp_arrondissement %>%
  select(-dummy, -dummy2) %>%
  mutate(arrondissement = NOM) %>%
  mutate(
    arrondissement =
      case_when(
        arrondissement == "Ahuntsic-Cartierville" ~ "Ahuntsic–Cartierville",
        arrondissement == "Baie-d'Urfé" ~ "Baie D'urfé",
        arrondissement == "Côte-des-Neiges-Notre-Dame-de-Grâce" ~ "Côte-des-Neiges–Notre-Dame-de-Grâce",
        arrondissement == "L'Île-Bizard-Sainte-Geneviève" ~ "L'Île-Bizard–Sainte-Geneviève",
        arrondissement == "Mercier-Hochelaga-Maisonneuve" ~ "Mercier–Hochelaga-Maisonneuve",
        arrondissement == "Montréal-Est" ~ "Montréal Est",
        arrondissement == "Pierrefonds-Roxboro" ~ "Pierrefonds–Roxboro",
        arrondissement == "Le Plateau-Mont-Royal" ~ "Plateau Mont-Royal",
        arrondissement == "Rivière-des-Prairies-Pointe-aux-Trembles" ~ "Rivière-des-Prairies–Pointe-aux-Trembles",
        arrondissement == "Rosemont-La Petite-Patrie" ~ "Rosemont–La Petite Patrie",
        arrondissement == "Le Sud-Ouest" ~ "Sud-Ouest",
        arrondissement == "Villeray-Saint-Michel-Parc-Extension" ~ "Villeray–Saint-Michel–Parc-Extension",
        TRUE ~ arrondissement
      )
  )


shp_arrondissement %>%
  anti_join(mtl_population) %>%
  pull(arrondissement) # manque ile dorval dans population. c'est correct
mtl_population %>% anti_join(shp_arrondissement) # manque total montréal dans shapefile. c'est correct


shp_mtl <- shp_arrondissement
usethis::use_data(shp_mtl)
