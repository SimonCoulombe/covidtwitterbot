library(tidyverse)
library(rtweet)
library(covidtwitterbot)
#token <- rtweet::get_tokens()
auth_as( auth =   rtweet_bot(
    api_key = Sys.getenv("covid_coulsim_api_key"),
    api_secret =   Sys.getenv("covid_coulsim_api_secret_key"),
    access_token = Sys.getenv("covid_coulsim_access_token"),
    access_secret = Sys.getenv("covid_coulsim_access_token_secret")
  )
)

emoji_carte <- intToUtf8(0x1F5FA)
emoji_graph <- intToUtf8(0x1F4C8)
emoji_malade <- intToUtf8(0x1F912)
emoji_cercueil <- intToUtf8(0x26B0)
emoji_hopital <- intToUtf8(0x1F3E5)
emoji_eprouvette <- intToUtf8(0x1F9EA)
emoji_robot <-  intToUtf8(0x1F916)
emoji_thread <- intToUtf8(0x1F9F5)

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
    "RÉSUMÉ:\n",

    format(nouveau_cas, big.mark = " "), " ", intToUtf8(0x1F912), " cas (", format(round(avg_cas_quo_tot_n_last7_per_1M, 0), big.mark = " "), " par M sur 7 j)\n",
    format(nouveau_deces, big.mark = " "), " ", intToUtf8(0x26B0), " décès (", format(total_deces, big.mark = " "), ")\n",
    format(hospit_en_cours, big.mark = " "), " ", intToUtf8(0x1F3E5), " hospit. (diff: ", format(hospit_delta, big.mark = " "), ")\n",
    format(tests, big.mark = " "), " ", intToUtf8(0x1F9EA), " tests (", sprintf("%.1f", round(pct_positif, 1)), " % positif)\n\n",

    intToUtf8(0x1F4C8), " Tests, hospitalisations, soins intensifs et décès de #covid\n",
    "#polqc 1/10"
  ),

  media = c(
    "~/git/adhoc_prive/covid19_PNG/quebec_deces_si.png"
  ),
  token = NULL,
  in_reply_to_status_id = NULL,
  destroy_id = NULL,
  retweet_id = NULL,
  auto_populate_reply_metadata = FALSE
)


premier_tweet_de_la_thread <-  get_timeline("covid_coulsim") %>% filter(str_detect(text, "covid")) %>% head(1)



post_tweet(
  status = paste0("RÉGIONS 2/10 covid\n" ,
                  intToUtf8(0x1F4C8), "\n",
                  "Cas par million par région\n",
                  "Hospit par million par région\n",
                  "Décès par million par région\n",
                  "Tests par million par région\n"
  ),

  media = c(
    "~/git/adhoc_prive/covid19_PNG/quebec_cases_by_pop.png",
    "~/git/adhoc_prive/covid19_PNG/quebec_new_hospit_par_region.png",
    "~/git/adhoc_prive/covid19_PNG/quebec_deces_par_region.png",
    "~/git/adhoc_prive/covid19_PNG/quebec_tests_par_region.png"
  ),
  token = NULL,
  in_reply_to_status_id = get_timeline("covid_coulsim") %>% arrange(desc(created_at)) %>% filter(str_detect(text, "covid")) %>% pull(status_id) %>% .[1],
  destroy_id = NULL,
  retweet_id = NULL,
  auto_populate_reply_metadata = FALSE
)



post_tweet(
  status = paste0("ÂGE 3A/10 covid\n" ,
    intToUtf8(0x1F4C8), "covid \n",
    "Cas par million par groupe d'âge\n",
    "Hospit par million par groupe d'âge\n",
    "Décès par million par groupe d'âge\n",
    "Tests par million par groupe d'âge"
  ),

  media = c(
    "~/git/adhoc_prive/covid19_PNG/quebec_age.png",
    "~/git/adhoc_prive/covid19_PNG/quebec_new_hospit_par_age.png",
    "~/git/adhoc_prive/covid19_PNG/quebec_deces_par_age.png",
    "~/git/adhoc_prive/covid19_PNG/quebec_tests_par_age.png"
  ),
  token = NULL,
  in_reply_to_status_id = get_timeline("covid_coulsim") %>% arrange(desc(created_at)) %>% filter(str_detect(text, "covid")) %>% pull(status_id) %>% .[1],
  destroy_id = NULL,
  retweet_id = NULL,
  auto_populate_reply_metadata = FALSE
)

post_tweet(
  status = paste0("ÂGE 3B/10 covid\n" ,
    intToUtf8(0x1F4C8), "Nombre absolus: \n",
    "Cas par groupe d'âge\n",
    "Hospit par groupe d'âge\n",
    "Décès  par groupe d'âge\n",
    "Tests par groupe d'âge"
  ),

  media = c(
    "~/git/adhoc_prive/covid19_PNG/quebec_cas_par_age_absolu.png",
    "~/git/adhoc_prive/covid19_PNG/quebec_new_hospit_par_age_absolu.png",
    "~/git/adhoc_prive/covid19_PNG/quebec_deces_par_age_absolu.png",
    "~/git/adhoc_prive/covid19_PNG/quebec_tests_par_age_absolu.png"
  ),
  token = NULL,
  in_reply_to_status_id = get_timeline("covid_coulsim") %>% arrange(desc(created_at)) %>% filter(str_detect(text, "covid")) %>% pull(status_id) %>% .[1],
  destroy_id = NULL,
  retweet_id = NULL,
  auto_populate_reply_metadata = FALSE
)




post_tweet(
  status = paste0("CENTRES DE SERVICES SCOLAIRES covid 4/10\n",
    intToUtf8(0x1F4C8), intToUtf8(0x1F5FA), " Cas par habitant par centre de service scolaire (CSS)\n",
    intToUtf8(0x1F4C8), "Heatmap Cas par habitant par groupe d'âge"
  ),
  media = c(
    "~/git/adhoc_prive/covid19_PNG/carte_css_cases.png",
    "~/git/adhoc_prive/covid19_PNG/css_cases_bars.png",
    "~/git/adhoc_prive/covid19_PNG/heatmap_age.png"
  ),

  token = NULL,
  in_reply_to_status_id = get_timeline("covid_coulsim") %>% arrange(desc(created_at)) %>% filter(str_detect(text, "covid")) %>% pull(status_id) %>% .[1],
  destroy_id = NULL,
  retweet_id = NULL,
  auto_populate_reply_metadata = FALSE
)



post_tweet(
  status = paste0("RÉSEAUX LOCAUX DE SERVICES covid 5/10 \n",
    intToUtf8(0x1F4C8), intToUtf8(0x1F5FA), " Cas par habitant par réseaux locaux de service (RLS)\n",
    "Données sauvées par @jpsoucy"
  ),
  media = c(
    "~/git/adhoc_prive/covid19_PNG/carte_rls_cases.png",
    "~/git/adhoc_prive/covid19_PNG/heatmap_rls.png",
    "~/git/adhoc_prive/covid19_PNG/carte_rls_cases_zoom_montreal.png"
  ),
  token = NULL,
  in_reply_to_status_id = get_timeline("covid_coulsim") %>% arrange(desc(created_at)) %>% filter(str_detect(text, "covid")) %>% pull(status_id) %>% .[1],
  destroy_id = NULL,
  retweet_id = NULL,
  auto_populate_reply_metadata = FALSE
)


post_tweet(
  status = paste0("TAUX DE POSITIVITÉ covid 6/10\n",
    intToUtf8(0x1F4C8), " Taux de positivité par région\n",
    intToUtf8(0x1F4C8), " Taux de positivité par âge"
  ),
  media = c(

    "~/git/adhoc_prive/covid19_PNG/quebec_positivite_par_region.png",
    "~/git/adhoc_prive/covid19_PNG/quebec_positivite_par_age.png"
  ),
  token = NULL,
  in_reply_to_status_id = get_timeline("covid_coulsim") %>% arrange(desc(created_at)) %>% filter(str_detect(text, "covid")) %>% pull(status_id) %>% .[1],
  # in_reply_to_status_id = NULL,
  destroy_id = NULL,
  retweet_id = NULL,
  auto_populate_reply_metadata = FALSE
)

post_tweet(
  status = paste0("MONTRÉAL covid 7/10\n",
    emoji_graph, emoji_carte, " Cas par habitant par arrondissement de la ville de Montréal"
  ),
  media = c(
    "~/git/adhoc_prive/covid19_PNG/heatmap_mtl.png",
    "~/git/adhoc_prive/covid19_PNG/carte_mtl.png"
  ),
  token = NULL,
  in_reply_to_status_id = get_timeline("covid_coulsim") %>% arrange(desc(created_at)) %>% filter(str_detect(text, "covid")) %>% pull(status_id) %>% .[1],
  destroy_id = NULL,
  retweet_id = NULL,
  auto_populate_reply_metadata = FALSE
)


post_tweet(
  status = paste0("CANADA covid 8/10\n",
    emoji_graph, " nouveaux cas quotidien par province (heatmap)\n",
    emoji_graph, " nouveaux cas quotidien par province (line)\n",
    emoji_graph, " nouveaux cas quotidiens par régions sanitaire (heatmap)\n",
    emoji_graph, " nouveaux cas quotidiens pour 16 régions sanitaires les plus touchées (ligne)\n"
  ),
  media = c(
    "~/git/adhoc_prive/covid19_PNG/heatmap_prov.png",
    "~/git/adhoc_prive/covid19_PNG/canada_cases_by_pop.png",
    "~/git/adhoc_prive/covid19_PNG/heatmap_pr_region.png",
    "~/git/adhoc_prive/covid19_PNG/canada_cases_by_worst16.png"
  ),
  token = NULL,
  in_reply_to_status_id = get_timeline("covid_coulsim") %>% arrange(desc(created_at)) %>% filter(str_detect(text, "covid")) %>% pull(status_id) %>% .[1],
  destroy_id = NULL,
  retweet_id = NULL,
  auto_populate_reply_metadata = FALSE
)


post_tweet(
  status = paste0("VACCINS covid 9/10\n",
    emoji_graph, " vaccins par région pourcent cumulatif\n",
    emoji_graph, " vaccins par âge pourcent cumulatif\n",
    emoji_graph, " vaccins par groupe prioritaire nombre cumulatif\n",
    emoji_graph, " vaccins par sexe  nombre cumulatif"

  ),
  media = c(
    "~/git/adhoc_prive/covid19_PNG/quebec_vaccin_region_pourcent_cumulatif.png",
    "~/git/adhoc_prive/covid19_PNG/quebec_vaccin_age_pourcent_cumulatif.png",
    "~/git/adhoc_prive/covid19_PNG/quebec_vaccin_groupe_prioritaire_cumulatif_absolu.png",
    "~/git/adhoc_prive/covid19_PNG/quebec_vaccin_sexe_cumulatif_absolu.png"
  ),
  token = NULL,
  in_reply_to_status_id = get_timeline("covid_coulsim") %>% arrange(desc(created_at)) %>% filter(str_detect(text, "covid")) %>% pull(status_id) %>% .[1],
  destroy_id = NULL,
  retweet_id = NULL,
  auto_populate_reply_metadata = FALSE
)


post_tweet(
  status = paste0("VARIANTS covid 10/10\n",
    emoji_graph, " variants par région nombre quotidien par million \n",
    emoji_graph, " variants par région nombre quotidien absolu \n",
    "Données sauvées par @jpsoucy"

  ),
  media = c(
    "~/git/adhoc_prive/covid19_PNG/quebec_variants_region_quotidien_pop.png",
    "~/git/adhoc_prive/covid19_PNG/quebec_variants_region_quotidien_absolu.png"
  ),
  token = NULL,
  in_reply_to_status_id = get_timeline("covid_coulsim") %>% arrange(desc(created_at)) %>% filter(str_detect(text, "covid")) %>% pull(status_id) %>% .[1],
  destroy_id = NULL,
  retweet_id = NULL,
  auto_populate_reply_metadata = FALSE
)




## reply to sante quebec


last_eligible_tweet_sante_qc <- get_timeline("sante_qc") %>%
  filter(str_detect(toupper(text), "VOICI"),
         as.integer(Sys.time() - created_at)  <= 48
  ) %>%  # filtre 48 heures pour pas trop s'acharner sur un vieux tweet.
  pull(status_id) %>% .[1]

if(!is.na(last_eligible_tweet_sante_qc)){
  post_tweet(
    status = paste0(
      emoji_thread, " Fil avec graphiques et carte des cas, hospitalisationss, décès et tests:\n",
      "-par sous-région (RLS) et commission scolaire\n",
      "-par âge\n",
      "-pour Montréal\n\n",
      "Aussi:\n",
      "-vaccination par régions et âge\n",
      "-variants par régions\n\n",
      "Un bon complément au dashboard de @sante_qc . \n",
      premier_tweet_de_la_thread$status_url
    ),
    token = NULL,
    in_reply_to_status_id = last_eligible_tweet_sante_qc,
    destroy_id = NULL,
    retweet_id = NULL,
    auto_populate_reply_metadata = FALSE
  )
}

