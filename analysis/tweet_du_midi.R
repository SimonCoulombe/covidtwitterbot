library(tidyverse)
library(rtweet)
library(covidtwitterbot)
token <- rtweet::get_tokens()


accueil <- get_inspq_manual_data_tableau_accueil()

nouveau_cas <- accueil %>% filter(type == "quotidien") %>% pull(cas)
total_cas <-accueil %>% filter(type == "cumulatif") %>% pull(cas)
nouveau_deces <- accueil %>% filter(type == "quotidien") %>% pull(deces)
total_deces <- accueil %>% filter(type == "cumulatif") %>% pull(deces)
hospit_en_cours <- accueil %>% filter(type == "cumulatif") %>% pull(hospit)
hospit_delta <- accueil %>% filter(type == "quotidien") %>% pull(hospit)
si_en_cours <- accueil %>% filter(type == "cumulatif") %>% pull(soins)
si_delta <- accueil %>% filter(type == "quotidien") %>% pull(soins)
tests <- accueil %>% filter(type == "cumulatif") %>% pull(analyses)



## https://unicode.org/emoji/charts/full-emoji-list.html

post_tweet(
  status = paste0(intToUtf8(0x1F9F5), " covid du ",format(as.Date(Sys.Date()), format = format_francais) ," midi.\n\n",
                  intToUtf8(0x1F3F3), " Sommaire:\n",
                  "+", format(nouveau_cas, big.mark = " "), " cas (", format(total_cas,big.mark = " "),")\n",
                  "+", format(nouveau_deces, big.mark = " "), " décès déclarés (", format(total_deces,big.mark = " "),")\n",
                  format(hospit_en_cours, big.mark = " "), " hospit. en cours (diff: ",format(hospit_delta,big.mark = " "),")\n",
                  "+", format(tests, big.mark = " "), " tests\n\n",


                  intToUtf8(0x1F4C8), " Cas par habitant par région\n",
                  intToUtf8(0x1F4C8), " Hospit par habitant par région\n",
                  intToUtf8(0x1F4C8), " Décès par habitant par région\n",
                  intToUtf8(0x1F4C8), " Tests par habitant par région\n",
                  #polqc #Covid19Qc  #eduqc #covid19 \n",
                  "1/4"),

  media = c("~/git/adhoc_prive/covid19_PNG/quebec_cases_by_pop.png",
            "~/git/adhoc_prive/covid19_PNG/quebec_hospit_by_pop.png",
            "~/git/adhoc_prive/covid19_PNG/quebec_deces_by_pop.png",
            "~/git/adhoc_prive/covid19_PNG/quebec_tests_by_pop.png"
  ),
  token = NULL,
  in_reply_to_status_id = NULL,
  destroy_id = NULL,
  retweet_id = NULL,
  auto_populate_reply_metadata = FALSE
)


post_tweet(
  status = paste0(
    intToUtf8(0x1F4C8),  intToUtf8(0x1F5FA)," Cas par habitant par centre de service scolaire (CSS)\n",
    intToUtf8(0x1F4C8), "Cas par habitant par groupe d'âge\n",
  "covid 2/4"),
  media = c("~/git/adhoc_prive/covid19_PNG/quebec_age.png",
            "~/git/adhoc_prive/covid19_PNG/carte_css_cases.png",
            "~/git/adhoc_prive/covid19_PNG/css_cases_bars.png",
            "~/git/adhoc_prive/covid19_PNG/heatmap_age.png"),

  token = NULL,
  in_reply_to_status_id = get_timeline("covid_coulsim") %>% filter(str_detect(text, "covid")) %>% pull(status_id) %>% .[1],
  destroy_id = NULL,
  retweet_id = NULL,
  auto_populate_reply_metadata = FALSE
)



post_tweet(
  status = paste0(intToUtf8(0x1F4C8),  intToUtf8(0x1F5FA)," Cas par habitant par réseaux locaux de service (RLS)\n"
  , "covid 3/4"),
  media = c("~/git/adhoc_prive/covid19_PNG/carte_rls_cases.png",
            "~/git/adhoc_prive/covid19_PNG/heatmap_rls.png",
            "~/git/adhoc_prive/covid19_PNG/carte_rls_cases_zoom_montreal.png"),
  token = NULL,
  in_reply_to_status_id = get_timeline("covid_coulsim") %>% filter(str_detect(text, "covid")) %>% pull(status_id) %>% .[1],
  destroy_id = NULL,
  retweet_id = NULL,
  auto_populate_reply_metadata = FALSE
)


post_tweet(
  status = paste0(intToUtf8(0x1F4C8), "Tests, hospitalisations aux soins intensifs et décès de #covid\n",
                  "4/4"),
  media = c("~/git/adhoc_prive/covid19_PNG/quebec_deces_si.png"
  ),
  token = NULL,
  in_reply_to_status_id = get_timeline("covid_coulsim") %>% filter(str_detect(text, "covid")) %>% pull(status_id) %>% .[1],
  #in_reply_to_status_id = NULL,
  destroy_id = NULL,
  retweet_id = NULL,
  auto_populate_reply_metadata = FALSE
)


