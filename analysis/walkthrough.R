
load_inspq_covid19_hist()
load_inspq_manual_data()



graph_deces_hospit_tests()
myggsave(filename = "~/git/adhoc_prive/covid19_PNG/quebec_deces_si.png")

graph_quebec_cas_par_region()
myggsave(filename = "~/git/adhoc_prive/covid19_PNG/quebec_cases_by_pop.png")

graph_quebec_cas_par_age()
myggsave(filename = "~/git/adhoc_prive/covid19_PNG/quebec_age.png" )

graph_quebec_cas_par_age_heatmap()
myggsave(filename = "~/git/adhoc_prive/covid19_PNG/heatmap_age.png" , width = 14, height =6)

## get the latest RLS data heatmap

# rls <- get_clean_rls_data()
# rls_cases <- prep_data(rls, shortname_rls, type = cases)
# heatmap_cas(rls_cases, RLS_petit_nom, "RLS")
graph_quebec_cas_par_rls_heatmap()
myggsave(filename = "~/git/adhoc_prive/covid19_PNG/heatmap_age.png" , width = 16, height =22)


# shapefile des rls sans l'eau
plot(shp_rls[,1])
