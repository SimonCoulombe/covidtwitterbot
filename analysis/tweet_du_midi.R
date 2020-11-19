library(tidyverse)
library(rtweet)

token <- get_tokens()

post_tweet(
  status = paste0("Thread #covid19 du midi.",
                  "\nNouveaux cas de covid au Québec par région sociosanitaire, commission scolaire et âge ",
                  "\n#polqc #Covid19Qc  #eduqc #covid19 ",
                  "\n 1/6"),
  media = c("~/git/adhoc_prive/covid19_PNG/quebec_cases_by_pop.png",
            "~/git/adhoc_prive/covid19_PNG/carte_css_cases.png",
            "~/git/adhoc_prive/covid19_PNG/css_cases_bars.png",
            "~/git/adhoc_prive/covid19_PNG/heatmap_age.png"
  ),
  token = NULL,
  in_reply_to_status_id = NULL,
  destroy_id = NULL,
  retweet_id = NULL,
  auto_populate_reply_metadata = FALSE
)


post_tweet(
  status = paste0("Tableau/carte/heatmap des cas de #covid par réseaux locaux de service (RLS)\n  2/6"),
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
  status = paste0("Tests, hospitalisations aux soins intensifs et décès de #covid",
                  ".\n  3/6"),
  media = c("~/git/adhoc_prive/covid19_PNG/quebec_deces_si.png"
  ),
  token = NULL,
  in_reply_to_status_id = get_timeline("covid_coulsim") %>% filter(str_detect(text, "covid")) %>% pull(status_id) %>% .[1],
  #in_reply_to_status_id = NULL,
  destroy_id = NULL,
  retweet_id = NULL,
  auto_populate_reply_metadata = FALSE
)


