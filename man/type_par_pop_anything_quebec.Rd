% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/graph_quebec_cas_par_age.R
\name{type_par_pop_anything_quebec}
\alias{type_par_pop_anything_quebec}
\title{Title}
\usage{
type_par_pop_anything_quebec(type, variable, hist_data = NULL)
}
\arguments{
\item{variable}{genre "cas_totaux_quotidien" ou}

\item{groupe}{défini par la fonction type... genre "groupe_age" ou "region"}
}
\value{

}
\description{
Title
}
\examples{
type_par_pop_anything_quebec(type = region, variable = hos_quo_tot_m) \%>\% ggplot(aes(x = date_report, y = avg_hos_quo_tot_m_last7_per_1M)) +
  geom_line() +
  facet_wrap(~groupe)
 avg_XXX_last7
 total
 worst7
 last7
 ratio
 winning.
 group <--- qui est la mÃªme que le type (genre health_region ou groupe_age, mais rÃ©ordonnÃ© en fonction du total de cas.... TODO: on ditche tu Ã§a?
}
