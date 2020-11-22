#This script creates all the figures used by the bot.

library(covidtwitterbot)

## demo some data functions, not necessary here



get_sommaire_quebec <- function(){

  hist <- get_inspq_covid19_hist() %>% filter(Nom == "Ensemble du Québec")
  manual <- get_inspq_manual_data_hospits()
  cas_confirmes_cumulatif <- hist %>% filter(date == max(date)) %>% pull(cas_cum_tot_n) # manque 3 ? OK avec graphique 1, pas avec dsahboard
  #cas_confirmes_quotidien <- hist %>% filter(date == max(date)) %>% pull(cas_quo_tot_n)
  cas_actifs <- hist %>% filter(date==max(date))  %>% pull(act_cum_tot_n) # ok
  retablis_cumulatif <-  hist %>% filter(date==max(date)) %>% pull(ret_cum_tot_n )# wrong
  retablis_quotidien <-  hist %>% filter(date==max(date)) %>% pull( ret_quo_tot_n ) #wrong
  deces_cumulatif <- hist %>% filter(date==max(date)) %>% pull(dec_cum_tot_n) #  ok avec graphique 2, wrong avec dashboard
  deces_quotidien <- hist %>% filter(date==max(date)) %>% pull(dec_quo_tot_n) # ok avec tableau 2, pas avec dashboard

  hospitalisations_en_cours <- manual %>% filter(date==max(date)) %>%
    mutate(hospitalisations_en_cours = hospits + si) %>% pull(hospitalisations_en_cours)# OK
  hospitalisations_si_en_cours <- manual %>% filter(date==max(date)) %>%  pull(si) # OK
  prelements_analyses <- manual %>% filter(!is.na(volumetrie)) %>% filter(date==max(date)) %>% pull(volumetrie) # OK

}


graph_deces_hospit_tests()
myggsave(filename = "~/git/adhoc_prive/covid19_PNG/quebec_deces_si.png")

graph_quebec_cas_par_region()
myggsave(filename = "~/git/adhoc_prive/covid19_PNG/quebec_cases_by_pop.png")

graph_quebec_cas_par_age()
myggsave(filename = "~/git/adhoc_prive/covid19_PNG/quebec_age.png" )

graph_quebec_cas_par_age_heatmap()
myggsave(filename = "~/git/adhoc_prive/covid19_PNG/heatmap_age.png" , width = 14, height =6)



# shapefiles
#plot(shp_rls[,1])
#plot(shp_css[,1])
#plot(shp_water[,1])

# créer la carte des cas par RLS de la semaine passée
rls_data <- get_rls_data()

graph_quebec_cas_par_rls_heatmap(rls_data = rls_data)
myggsave(filename = "~/git/adhoc_prive/covid19_PNG/heatmap_rls.png" , width = 16, height =22)

carte <- carte_rls(rls_data = rls_data)
myggsave(filename = "~/git/adhoc_prive/covid19_PNG/carte_rls_cases.png" , width = 12, height =10)

carte <- carte_rls_zoom_montreal(rls_data = rls_data)
myggsave(filename = "~/git/adhoc_prive/covid19_PNG/carte_rls_cases_zoom_montreal.png" , width = 12, height =10)


css_last_week <- get_css_last_week(rls_data)

carte_css(css_last_week)
myggsave(filename = "~/git/adhoc_prive/covid19_PNG/carte_css_cases.png" , width = 14, height =14)

graph_css_bars(css_last_week)
myggsave(filename = "~/git/adhoc_prive/covid19_PNG/css_cases_bars.png" , width = 14, height =14)




