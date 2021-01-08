#' table de correspondance des différents noms des health regions du québec
#' @export
table_correspondances_health_region_quebec <-
  tibble::tribble(
    ~Nom, ~groupe, ~health_region, ~health_region_short,
    "Bas-Saint-Laurent", "01 Bas-Saint-Laurent", "Bas-Saint-Laurent", "Bas-Saint-Laurent",
    "Saguenay–Lac-Saint-Jean", "02 Saguenay-Lac-Saint-Jean", "Saguenay", "Saguenay",
    "Capitale-Nationale", "03 Capitale-Nationale", "Capitale-Nationale", "Capitale-Nationale",
    "Mauricie et Centre-du-Québec", "04 Mauricie et Centre-du-Québec", "Mauricie", "Mauricie",
    "Estrie", "05 Estrie", "Estrie", "Estrie",
    "Montréal", "06 Montréal", "Montréal", "Montréal",
    "Outaouais", "07 Outaouais", "Outaouais", "Outaouais",
    "Abitibi-Témiscamingue", "08 Abitibi-Témiscamingue", "Abitibi-Témiscamingue", "Abitibi",
    "Côte-Nord", "09 Côte-Nord", "Côte-Nord", "Côte-Nord",
    "Nord-du-Québec", "10 Nord-du-Québec", "Nord-du-Québec", "Nord-du-Québec",
    "Gaspésie–Îles-de-la-Madeleine", "11 Gaspésie-Îles-de-la-Madeleine", "Gaspésie-Îles-de-la-Madeleine", "Gaspésie",
    "Chaudière-Appalaches", "12 Chaudière-Appalaches", "Chaudière-Appalaches", "Chaudière-Appalaches",
    "Laval", "13 Laval", "Laval", "Laval",
    "Lanaudière", "14 Lanaudière", "Lanaudière", "Lanaudière",
    "Laurentides", "15 Laurentides", "Laurentides", "Laurentides",
    "Montérégie", "16 Montérégie", "Montérégie", "Montérégie",
    "Nunavik", "17 Nunavik", "Nunavik", "Nunavik",
    "Terres-Cries-de-la-Baie-James", "18 Terres-Cries-de-la-Baie-James", "Terres-Cries-de-la-Baie-James", "Terres-Cries",
    "Ensemble du Québec", "Ensemble du Québec", "Ensemble du Québec", "Ensemble du Québec",
    "Hors Québec", "Hors Québec", "Hors Québec", "Hors Québec",
    "Inconnu", "Inconnue", "Inconnue", "Inconnue"
  )
