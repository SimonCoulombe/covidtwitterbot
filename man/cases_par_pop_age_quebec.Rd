% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/graph_quebec_cas_par_age.R
\name{cases_par_pop_age_quebec}
\alias{cases_par_pop_age_quebec}
\title{cases_par_pop_age_quebec
-exécute prep data pour avoir la moyenne sur 7 jours, ainsi que le pire 7 jours et le dernier 7 jour et le ratio dernier/pire,
- left_join la population et calcule
 - cases_per_1M  , soit avg_cases_last7 / 1000000 * pop
 - last_cases_per_1M, soit le cases_per_1M final, qui nous donne la couleur
 -color_per_pop , la couleur qui dépend de last_cases_per_1M}
\usage{
cases_par_pop_age_quebec()
}
\value{

}
\description{
cases_par_pop_age_quebec
-exécute prep data pour avoir la moyenne sur 7 jours, ainsi que le pire 7 jours et le dernier 7 jour et le ratio dernier/pire,
- left_join la population et calcule
 - cases_per_1M  , soit avg_cases_last7 / 1000000 * pop
 - last_cases_per_1M, soit le cases_per_1M final, qui nous donne la couleur
 -color_per_pop , la couleur qui dépend de last_cases_per_1M
}
\examples{
 avg_XXX_last7
 total
 worst7
 last7
 ratio
 winning.
 group <--- qui est la mÃªme que le type (genre health_region ou groupe_age, mais rÃ©ordonnÃ© en fonction du total de cas..)
}
