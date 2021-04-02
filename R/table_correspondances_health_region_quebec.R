#' table de correspondance des différents noms des health regions du québec
#' @export
table_correspondances_health_region_quebec <-
  tibble::tribble(
    ~Nom, ~groupe, ~health_region, ~health_region_short, ~region_sociosanitaire,
    "Bas-Saint-Laurent", "01 Bas-Saint-Laurent", "Bas-Saint-Laurent", "Bas-Saint-Laurent", "01 - Bas-Saint-Laurent",
    "Saguenay–Lac-Saint-Jean", "02 Saguenay-Lac-Saint-Jean", "Saguenay", "Saguenay", "02 - Saguenay–Lac-Saint-Jean",
    "Capitale-Nationale", "03 Capitale-Nationale", "Capitale-Nationale", "Capitale-Nationale", "03 - Capitale-Nationale",
    "Mauricie et Centre-du-Québec", "04 Mauricie et Centre-du-Québec", "Mauricie", "Mauricie", "04 - Mauricie et Centre-du-Québec",
    "Estrie", "05 Estrie", "Estrie", "Estrie", "05 - Estrie",
    "Montréal", "06 Montréal", "Montréal", "Montréal", "06 - Montréal",
    "Outaouais", "07 Outaouais", "Outaouais", "Outaouais", "07 - Outaouais",
    "Abitibi-Témiscamingue", "08 Abitibi-Témiscamingue", "Abitibi-Témiscamingue", "Abitibi", "08 - Abitibi-Témiscamingue",
    "Côte-Nord", "09 Côte-Nord", "Côte-Nord", "Côte-Nord", "09 - Côte-Nord",
    "Nord-du-Québec", "10 Nord-du-Québec", "Nord-du-Québec", "Nord-du-Québec", "10 - Nord-du-Québec",
    "Gaspésie–Îles-de-la-Madeleine", "11 Gaspésie-Îles-de-la-Madeleine", "Gaspésie-Îles-de-la-Madeleine", "Gaspésie", "11 - Gaspésie–Îles-de-la-Madeleine",
    "Chaudière-Appalaches", "12 Chaudière-Appalaches", "Chaudière-Appalaches", "Chaudière-Appalaches",  "12 - Chaudière-Appalaches",
    "Laval", "13 Laval", "Laval", "Laval", "13 - Laval",
    "Lanaudière", "14 Lanaudière", "Lanaudière", "Lanaudière", "14 - Lanaudière",
    "Laurentides", "15 Laurentides", "Laurentides", "Laurentides", "15 - Laurentides",
    "Montérégie", "16 Montérégie", "Montérégie", "Montérégie", "16 - Montérégie",
    "Nunavik", "17 Nunavik", "Nunavik", "Nunavik", "NUNAVIK_MANQUANT",
    "Terres-Cries-de-la-Baie-James", "18 Terres-Cries-de-la-Baie-James", "Terres-Cries-de-la-Baie-James", "Terres-Cries", "TERRES_CRIES_DE_LA_BAIE_JAMES_MANQUANT",
    "Ensemble du Québec", "Ensemble du Québec", "Ensemble du Québec", "Ensemble du Québec", "Ensemble du Québec",
    "Hors Québec", "Hors Québec", "Hors Québec", "Hors Québec", "Hors Québec",
    "Inconnu", "Inconnue", "Inconnue", "Inconnue", "Inconnu"
  )
