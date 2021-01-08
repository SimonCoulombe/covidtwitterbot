library(tidyverse)
library(rtweet)
library(covidtwitterbot)
token <- rtweet::get_tokens()

emoji_carte <- intToUtf8(0x1F5FA)
emoji_graph <- intToUtf8(0x1F4C8)
emoji_malade <- intToUtf8(0x1F912)
emoji_cercueil <- intToUtf8(0x26B0)
emoji_hopital <- intToUtf8(0x1F3E5)
emoji_eprouvette <- intToUtf8(0x1F9EA)
Sys.setlocale("LC_TIME", "fr_CA.UTF8")

avg_cas_quo_tot_n_last7_per_1M <- type_par_pop_anything_quebec(type = region, variable = cas_quo_tot_n) %>%
  filter(groupe == "Ensemble du Québec", date_report == max(date_report)) %>%
  pull(avg_cas_quo_tot_n_last7_per_1M)
accueil <- get_inspq_manual_data_tableau_accueil()

nouveau_cas <- accueil %>%
  filter(type == "quotidien") %>%
  pull(cas)
total_cas <- accueil %>%
  filter(type == "cumulatif") %>%
  pull(cas)
nouveau_deces <- accueil %>%
  filter(type == "quotidien") %>%
  pull(deces)
total_deces <- accueil %>%
  filter(type == "cumulatif") %>%
  pull(deces)
hospit_en_cours <- accueil %>%
  filter(type == "cumulatif") %>%
  pull(hospit)
hospit_delta <- accueil %>%
  filter(type == "quotidien") %>%
  pull(hospit)
si_en_cours <- accueil %>%
  filter(type == "cumulatif") %>%
  pull(soins)
si_delta <- accueil %>%
  filter(type == "quotidien") %>%
  pull(soins)
tests <- accueil %>%
  filter(type == "cumulatif") %>%
  pull(analyses)

hist <- get_inspq_covid19_hist()
pct_positif <- hist %>%
  filter(Nom == "Ensemble du Québec", !is.na(psi_quo_pos_t)) %>%
  filter(date == max(date)) %>%
  pull(psi_quo_pos_t)

## https://unicode.org/emoji/charts/full-emoji-list.html

post_tweet(
  status = paste0(
    intToUtf8(0x1F9F5), "covid du ", format(as.Date(Sys.Date()), format = format_francais), "\n\n",
    "Sommaire:\n",
    format(nouveau_cas, big.mark = " "), " ", intToUtf8(0x1F912), " cas (", format(round(avg_cas_quo_tot_n_last7_per_1M, 0), big.mark = " "), " par M sur 7 j)\n",
    format(nouveau_deces, big.mark = " "), " ", intToUtf8(0x26B0), " décès (", format(total_deces, big.mark = " "), ")\n",
    format(hospit_en_cours, big.mark = " "), " ", intToUtf8(0x1F3E5), " hospit. (diff: ", format(hospit_delta, big.mark = " "), ")\n",
    format(tests, big.mark = " "), " ", intToUtf8(0x1F9EA), " tests (", sprintf("%.1f", round(pct_positif, 1)), " % positif)\n\n",

    intToUtf8(0x1F4C8), "\n",
    "Cas par million par région\n",
    "Hospit par million par région\n",
    "Décès par million par région\n",
    "Tests par million par région\n",
    "#polqc 1/5"
  ),

  media = c(
    "~/git/adhoc_prive/covid19_PNG/quebec_cases_by_pop.png",
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
    intToUtf8(0x1F4C8), intToUtf8(0x1F5FA), " Cas par habitant par centre de service scolaire (CSS)\n",
    intToUtf8(0x1F4C8), "Cas par habitant par groupe d'âge\n",
    "covid 2/5"
  ),
  media = c(
    "~/git/adhoc_prive/covid19_PNG/quebec_age.png",
    "~/git/adhoc_prive/covid19_PNG/carte_css_cases.png",
    "~/git/adhoc_prive/covid19_PNG/css_cases_bars.png",
    "~/git/adhoc_prive/covid19_PNG/heatmap_age.png"
  ),

  token = NULL,
  in_reply_to_status_id = get_timeline("covid_coulsim") %>% filter(str_detect(text, "covid")) %>% pull(status_id) %>% .[1],
  destroy_id = NULL,
  retweet_id = NULL,
  auto_populate_reply_metadata = FALSE
)



post_tweet(
  status = paste0(
    intToUtf8(0x1F4C8), intToUtf8(0x1F5FA), " Cas par habitant par réseaux locaux de service (RLS)\n",
    "covid 3/5"
  ),
  media = c(
    "~/git/adhoc_prive/covid19_PNG/carte_rls_cases.png",
    "~/git/adhoc_prive/covid19_PNG/heatmap_rls.png",
    "~/git/adhoc_prive/covid19_PNG/carte_rls_cases_zoom_montreal.png"
  ),
  token = NULL,
  in_reply_to_status_id = get_timeline("covid_coulsim") %>% filter(str_detect(text, "covid")) %>% pull(status_id) %>% .[1],
  destroy_id = NULL,
  retweet_id = NULL,
  auto_populate_reply_metadata = FALSE
)


post_tweet(
  status = paste0(
    intToUtf8(0x1F4C8), " Tests, hospitalisations, soins intensifs et décès de #covid\n",
    intToUtf8(0x1F4C8), " Pourcentage de positivité (Ensemble du Québec)\n",
    intToUtf8(0x1F4C8), " Pourcentage de positivité par région\n",
    intToUtf8(0x1F4C8), " Pourcentage de positivité par âge\n",
    "4/5"
  ),
  media = c(
    "~/git/adhoc_prive/covid19_PNG/quebec_deces_si.png",
    "~/git/adhoc_prive/covid19_PNG/quebec_positivite.png",
    "~/git/adhoc_prive/covid19_PNG/quebec_positivite_par_region.png",
    "~/git/adhoc_prive/covid19_PNG/quebec_positivite_par_age.png"
  ),
  token = NULL,
  in_reply_to_status_id = get_timeline("covid_coulsim") %>% filter(str_detect(text, "covid")) %>% pull(status_id) %>% .[1],
  # in_reply_to_status_id = NULL,
  destroy_id = NULL,
  retweet_id = NULL,
  auto_populate_reply_metadata = FALSE
)



post_tweet(
  status = paste0(
    emoji_graph, emoji_carte, " Cas par habitant par arrondissement de la ville de Montréal\n",
    "covid 5/5"
  ),
  media = c(
    "~/git/adhoc_prive/covid19_PNG/heatmap_mtl.png",
    "~/git/adhoc_prive/covid19_PNG/carte_mtl.png"
  ),
  token = NULL,
  in_reply_to_status_id = get_timeline("covid_coulsim") %>% filter(str_detect(text, "covid")) %>% pull(status_id) %>% .[1],
  destroy_id = NULL,
  retweet_id = NULL,
  auto_populate_reply_metadata = FALSE
)




post_tweet(
  status = paste0(
    emoji_graph, " nouveaux cas quotidien par province (heatmap)\n",
    emoji_graph, " nouveaux cas quotidien par province (line)\n",
    emoji_graph, " nouveaux cas quotidiens par régions sanitaire (heatmap)\n",
    emoji_graph, " nouveaux cas quotidiens pour 16 régions sanitaires les plus touchées (ligne)\n",
    "covid 6/6"
  ),
  media = c(
    "~/git/adhoc_prive/covid19_PNG/heatmap_prov.png",
    "~/git/adhoc_prive/covid19_PNG/canada_cases_by_pop.png",
    "~/git/adhoc_prive/covid19_PNG/heatmap_pr_region.png",
    "~/git/adhoc_prive/covid19_PNG/canada_cases_by_worst16.png"
  ),
  token = NULL,
  in_reply_to_status_id = get_timeline("covid_coulsim") %>% filter(str_detect(text, "covid")) %>% pull(status_id) %>% .[1],
  destroy_id = NULL,
  retweet_id = NULL,
  auto_populate_reply_metadata = FALSE
)
