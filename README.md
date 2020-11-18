
<!-- README.md is generated from README.Rmd. Please edit that file -->

# covidtwitterbot

<!-- badges: start -->

<!-- badges: end -->

The goal of covidtwitterbot is to generate the figures and maps that are
posted on my twitter bot, @covid\_coulsim.

## Installation

You can install the development version from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("SimonCoulombe/covidtwitterbot")
```

## Example

### Tables

Here are the tables you can fetch and the graphics you can generate..
They are generated from the most up-to-date data.

``` r
library(covidtwitterbot)
```

The `load_inspq_covid19_hist()` function fetches historical data for
Quebec by age, health region and gender. This includes the numbers of
cases (“cas\_*"), of deaths ("dec\_*”) of hospitalizations (“hos\_*")
and .. something else ("psi\_*”).

``` r
load_inspq_covid19_hist() %>% tail(20)
#> # A tibble: 20 x 54
#>    Date  Regroupement Croisement Nom   cas_cum_lab_n cas_cum_epi_n cas_cum_tot_n
#>    <chr> <chr>        <chr>      <chr>         <dbl>         <dbl>         <dbl>
#>  1 2020… Groupe de r… REG02      Cein…         21858          1698         23556
#>  2 2020… Groupe de r… REG03      Autr…         42683          2170         44853
#>  3 2020… Groupe de r… REG00      Inco…             3             0             3
#>  4 2020… Groupe de r… REG98      Hors…            74             2            76
#>  5 2020… Groupe d'âge 0_9        0-9 …          5112          1388          6500
#>  6 2020… Groupe d'âge 10_19      10-1…         11820          1221         13041
#>  7 2020… Groupe d'âge 20_29      20-2…         18652          1228         19880
#>  8 2020… Groupe d'âge 30_39      30-3…         16215           959         17174
#>  9 2020… Groupe d'âge 40_49      40-4…         17639           982         18621
#> 10 2020… Groupe d'âge 50_59      50-5…         15881           867         16748
#> 11 2020… Groupe d'âge 60_69      60-6…          9939           462         10401
#> 12 2020… Groupe d'âge 70_79      70-7…          7558           192          7750
#> 13 2020… Groupe d'âge 80_89      80-8…          9347           252          9599
#> 14 2020… Groupe d'âge 90_        90 a…          6049           215          6264
#> 15 2020… Groupe d'âge INC        Inco…            38            35            73
#> 16 2020… Groupe d'âge TOT        Total        118250          7801        126051
#> 17 2020… Sexe         MASC       Masc…         52923          3938         56861
#> 18 2020… Sexe         FEM        Fémi…         65218          3862         69080
#> 19 2020… Sexe         INC        Inco…           109             1           110
#> 20 2020… Sexe         TOT        Total        118250          7801        126051
#> # … with 47 more variables: cas_cum_tot_t <chr>, cas_quo_tot_t <chr>,
#> #   cas_quo_lab_n <dbl>, cas_quo_epi_n <dbl>, cas_quo_tot_n <dbl>,
#> #   act_cum_tot_n <dbl>, act_cum_tot_t <chr>, cas_quo_tot_m <dbl>,
#> #   cas_quo_tot_tm <dbl>, ret_cum_tot_n <dbl>, ret_quo_tot_n <dbl>,
#> #   dec_cum_tot_n <dbl>, dec_cum_tot_t <chr>, dec_quo_tot_t <chr>,
#> #   dec_cum_chs_n <dbl>, dec_cum_rpa_n <dbl>, dec_cum_dom_n <dbl>,
#> #   dec_cum_aut_n <dbl>, dec_quo_tot_n <dbl>, dec_quo_chs_n <dbl>,
#> #   dec_quo_rpa_n <dbl>, dec_quo_dom_n <dbl>, dec_quo_aut_n <dbl>,
#> #   dec_quo_tot_m <dbl>, dec_quo_tot_tm <dbl>, hos_cum_reg_n <chr>,
#> #   hos_cum_si_n <chr>, hos_cum_tot_n <chr>, hos_cum_tot_t <chr>,
#> #   hos_quo_tot_t <chr>, hos_quo_reg_n <chr>, hos_quo_si_n <chr>,
#> #   hos_quo_tot_n <chr>, hos_quo_tot_m <chr>, psi_cum_tes_n <dbl>,
#> #   psi_cum_pos_n <dbl>, psi_cum_inf_n <dbl>, psi_quo_pos_n <dbl>,
#> #   psi_quo_inf_n <dbl>, psi_quo_tes_n <dbl>, psi_quo_pos_t <chr>, date <date>,
#> #   type <chr>, groupe <chr>, cas_totaux_cumul <dbl>,
#> #   cas_totaux_quotidien <dbl>, deces_totaux_quotidien <dbl>
```

The load\_inspq\_manual\_data() function returns the historical number
of hospitalisation (hospits\_ancien and hospits), intensive care (si)
and number of tests (volumetrie) for the province

``` r
load_inspq_manual_data() %>% tail(20)
#> # A tibble: 20 x 5
#>    date       hospits hospits_ancien    si volumetrie
#>    <date>       <dbl>          <dbl> <dbl>      <dbl>
#>  1 2020-10-28     431             NA    78      26642
#>  2 2020-10-29     434             NA    81      27993
#>  3 2020-10-30     421             NA    82      25279
#>  4 2020-10-31     412             NA    84      22487
#>  5 2020-11-01     418             NA    81      17057
#>  6 2020-11-02     441             NA    85      19597
#>  7 2020-11-03     458             NA    81      25563
#>  8 2020-11-04     456             NA    82      28925
#>  9 2020-11-05     462             NA    77      29776
#> 10 2020-11-06     445             NA    78      26951
#> 11 2020-11-07     450             NA    77      21884
#> 12 2020-11-08     464             NA    76      19848
#> 13 2020-11-09     452             NA    82      21851
#> 14 2020-11-10     489             NA    84      28078
#> 15 2020-11-11     497             NA    86      28916
#> 16 2020-11-12     498             NA    85      29846
#> 17 2020-11-13     501             NA    82      29512
#> 18 2020-11-14     498             NA    89      26864
#> 19 2020-11-15     504             NA    87      19775
#> 20 2020-11-16     538             NA   100         NA
```

The get\_clean\_rls\_data() function returns the historical number of
cases at the RLS (région locale de service). There are no historical
files at the RLS level on the INSPQ website. This function depends on a
bunch of historical data that I collected, plus a daily archive
repository maintained by Jean-Paul R Soucy.

This function takes a while because it has to download a few hundred of
CSVs before aggregating them.

``` r
get_clean_rls_data() %>% tail(20)
#> # A tibble: 20 x 20
#>    RSS   RLS   date_report cumulative_cases source fix_cummin cases
#>    <chr> <chr> <date>                 <dbl> <chr>       <dbl> <dbl>
#>  1 14 -… 1411… 2020-11-17              4590 curre…       4590    80
#>  2 14 -… 1412… 2020-11-17              5065 curre…       5065    50
#>  3 15 -… 1511… 2020-11-17               119 curre…        119     1
#>  4 15 -… 1512… 2020-11-17               307 curre…        307     1
#>  5 15 -… 1513… 2020-11-17               397 curre…        397     1
#>  6 15 -… 1514… 2020-11-17               257 curre…        257     1
#>  7 15 -… 1515… 2020-11-17              1600 curre…       1600     5
#>  8 15 -… 1516… 2020-11-17              2107 curre…       2107     6
#>  9 15 -… 1517… 2020-11-17              2583 curre…       2583     5
#> 10 16 -… 1611… 2020-11-17              3577 curre…       3577    20
#> 11 16 -… 1612… 2020-11-17              2080 curre…       2080    23
#> 12 16 -… 1621… 2020-11-17              3903 curre…       3903    25
#> 13 16 -… 1622… 2020-11-17              2938 curre…       2938    28
#> 14 16 -… 1623… 2020-11-17               258 curre…        258     4
#> 15 16 -… 1631… 2020-11-17              1439 curre…       1439    10
#> 16 16 -… 1632… 2020-11-17               934 curre…        934     4
#> 17 16 -… 1633… 2020-11-17               209 curre…        209     1
#> 18 16 -… 1634… 2020-11-17              2707 curre…       2707    19
#> 19 17 -… 1701… 2020-11-17                29 curre…         29     0
#> 20 18 -… 1801… 2020-11-17                16 curre…         16     0
#> # … with 13 more variables: shortname_rls <chr>, Population <dbl>,
#> #   cases_per_100k <dbl>, cases_last_7_days <dbl>,
#> #   previous_cases_last_7_days <dbl>, cases_last_7_days_per_100k <dbl>,
#> #   RLS_code <chr>, cases_per_1M <dbl>, last_cases_per_1M <dbl>,
#> #   previous_cases_per_1M <dbl>, color_per_pop <fct>, pop <dbl>,
#> #   RLS_petit_nom <chr>
```

### Figures and maps

``` r
graph_deces_hospit_tests()
```

<img src="man/figures/README-unnamed-chunk-3-1.png" width="100%" />

``` r
graph_quebec_cas_par_region()
```

<img src="man/figures/README-unnamed-chunk-4-1.png" width="100%" />

``` r
graph_quebec_cas_par_age()
```

<img src="man/figures/README-unnamed-chunk-5-1.png" width="100%" />

``` r
graph_quebec_cas_par_age_heatmap()
```

<img src="man/figures/README-unnamed-chunk-6-1.png" width="100%" />

``` r
graph_quebec_cas_par_rls_heatmap()
```

<img src="man/figures/README-unnamed-chunk-7-1.png" width="100%" />
`carte_rls()` crée une carte montrant le nombre moyen de cas par jour
par million d’habitant durant les 7 derniers jours

``` r
carte_rls()
```

<img src="man/figures/README-unnamed-chunk-8-1.png" width="100%" />

### Shapefile

The shapefile `shp_rls` shows all the RLS in Quebec after removing
water.

``` r
plot(shp_rls[,1])
```

<img src="man/figures/README-unnamed-chunk-9-1.png" width="100%" />

### Palettes

palette\_OkabeIto is a color palette that was built by higher beings to
be visible to color-blind people

``` r
palette_OkabeIto
#>        orange       skyblue   bluishgreen        yellow          blue 
#>     "#E69F00"     "#56B4E9"     "#009E73"     "#F0E442"     "#0072B2" 
#>    vermillion reddishpurple          gray 
#>     "#D55E00"     "#CC79A7"     "#999999"
```
