## code to prepare `rls_claude` dataset goes here

library(tidyverse)
library(googlesheets4)

url_rls <- "https://docs.google.com/spreadsheets/d/17eJ05pg6fkzKlwwiWn0ztdMvzBX9pGx3q6w7h3_vJw4/"
gs4_deauth()

attempt <- 0
prout <- NULL
while (is.null(prout) && attempt <= 100) {
  attempt <- attempt + 1
  message(attempt)
  Sys.sleep(3)
  try(
    prout <- read_sheet(url_rls)
  )
}

# #rls_population <- prout %>% select(RLS, Population) %>% filter(RLS != "Total")
# #datapasta::dpasta(rls_population)

rls_claude <- prout[1:which(prout$NoRLS == 1801), ] %>%
  filter(!is.na(NoRLS)) %>%
  select(-No, -NoRLS, -Population) %>%
  gather(key = key, value = cumulative_cases, -RLS, -RSS) %>%
  mutate_at(vars(cumulative_cases), as.numeric) %>%
  filter(!is.na(cumulative_cases)) %>%
  # filter(NoRLS == "0112") %>%
  mutate(cumulative_cases = map_int(cumulative_cases, ~ as.integer(str_replace_all(.x, " ", "")))) %>% # remove spaces from numbers
  mutate(date_report = lubridate::ymd(key)) %>%
  select(-key) %>%
  filter(!is.na(cumulative_cases))


write_csv(rls_claude, "data-raw/rls_claude.csv")
usethis::use_data(rls_claude)
