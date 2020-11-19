
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

Pour les utilisateurs linux, vous aurez probablement besoin d’installer
des librairies tels que `geos-devel sqlite3-devel proj-devel gdal-devel
libopenssl-devel`

## Example

### Tables

Here are the tables you can fetch and the graphics you can generate..
They are generated from the most up-to-date data.

``` r
library(covidtwitterbot)
```

#### load\_inspq\_covid19\_hist()

The `load_inspq_covid19_hist()` function fetches historical data for
Quebec by age, health region and gender. This includes the numbers of
cases (“cas\_*"), of deaths ("dec\_*”) of hospitalizations (“hos\_*")
and persons tested ("psi\_*”).

**dictionnaire (partiel)des données: **

cas\_cum\_tot\_n = nombre de cas confirmés (cumulatifs) selon date de
déclaration cas\_cum\_lab\_n = nombre de cas confirmés en laboratoire
(cumulatif) selon date de déclaration cas\_cum\_epi\_n = nombre de cas
confirmés par lien épidémiologique (cumulatif) selon date de déclaration
cas\_quo\_tot\_n = nombre de cas confirmés (quotidien) selon date de
déclaration cas\_quo\_lab\_n = nombre de cas confirmés en laboratoire
(quotidien) selon date de déclaration cas\_quo\_epi\_n = nombre de cas
confirmés par lien épidémiologique (quotidien) selon date de déclaration

act\_cum\_tot\_n = nombre de cas actifs (aujourd’hui)

ret\_cum\_tot\_n = nombre de cas rétablis (cumulatifs ret\_quo\_tot\_n =
nombre de cas rétablis (quotidien)

dec\_cum\_tot\_n = total des décès (cumulatif) dec\_cum\_chs\_n = total
des décès en CHSLD (cumulatif) dec\_cum\_rpa\_n = total des décès en RPA
(cumulatif) dec\_cum\_dom\_n = total des décès à domicile et inconnu
(cumulatif) dec\_cum\_aut\_n = total des décès en RI et autre
(cumulatif)

dec\_quo\_tot\_n = total des décès (quotidien) dec\_quo\_chs\_n = total
des décès en CHSLD (quotidien) dec\_quo\_rpa\_n = total des décès en RPA
(quotidien) dec\_quo\_dom\_n = total des décès à domicile et inconnu
(quotidien) dec\_quo\_aut\_n = total des décès en RI et autre
(quotidien)

hos\_quo\_tot\_n = nouvelles hospitalisations (régulières + soins
intensifs) hos\_quo\_reg\_n = nouvelles hospitalisations hors soins
intensifs hos\_quo\_si\_n = nouvelles hospitalisations aux soins
intensifs

psi\_cum\_test\_pos = cas confirmés cumulatif psi\_cum\_test\_inf =
personnes infirmées (test négatifs) cumulatif psi\_cum\_test\_n = cumul
de personnes testées cumulatif

psi\_quo\_test\_pos = cas confirmés quotidien \#\# cet colonne est vide
pour la dernière journée psi\_quo\_test\_inf = personnes infirmées (test
négatifs) quotidien \#\# cet colonne est vide pour la dernière journée
psi\_quo\_test\_n = cumul de personnes testées quotidien \#\# cet
colonne est vide pour la dernière journée

``` r
load_inspq_covid19_hist() %>% tail(20)
#> # A tibble: 20 x 54
#>    Date  Regroupement Croisement Nom   cas_cum_lab_n cas_cum_epi_n cas_cum_tot_n
#>    <chr> <chr>        <chr>      <chr>         <dbl>         <dbl>         <dbl>
#>  1 2020… Groupe de r… REG02      Cein…         22255          1704         23959
#>  2 2020… Groupe de r… REG03      Autr…         44011          2192         46203
#>  3 2020… Groupe de r… REG00      Inco…             3             0             3
#>  4 2020… Groupe de r… REG98      Hors…            75             2            77
#>  5 2020… Groupe d'âge 0_9        0-9 …          5289          1400          6689
#>  6 2020… Groupe d'âge 10_19      10-1…         12146          1225         13371
#>  7 2020… Groupe d'âge 20_29      20-2…         18944          1235         20179
#>  8 2020… Groupe d'âge 30_39      30-3…         16567           963         17530
#>  9 2020… Groupe d'âge 40_49      40-4…         17974           986         18960
#> 10 2020… Groupe d'âge 50_59      50-5…         16173           870         17043
#> 11 2020… Groupe d'âge 60_69      60-6…         10156           465         10621
#> 12 2020… Groupe d'âge 70_79      70-7…          7703           192          7895
#> 13 2020… Groupe d'âge 80_89      80-8…          9486           252          9738
#> 14 2020… Groupe d'âge 90_        90 a…          6123           216          6339
#> 15 2020… Groupe d'âge INC        Inco…            37            35            72
#> 16 2020… Groupe d'âge TOT        Total        120598          7839        128437
#> 17 2020… Sexe         MASC       Masc…         54038          3958         57996
#> 18 2020… Sexe         FEM        Fémi…         66451          3880         70331
#> 19 2020… Sexe         INC        Inco…           109             1           110
#> 20 2020… Sexe         TOT        Total        120598          7839        128437
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

# load\_inspq\_manual\_data()

The load\_inspq\_manual\_data() function returns the historical number
of hospitalisation (hospits\_ancien and hospits), intensive care (si)
and number of tests (volumetrie) for the province

*dictionnaire des données *  
hospits = hospitalisation hors intensif en cours  
hospits\_ancien = hospitalisation hors intensif en cours (ancienne
mesure, remplacée au printemps 2020 par l’actuelle)  
si = soins intensifs en cours  
volumetrie = nombre de tests (cette colonne est vide pour la dernière
journée)

``` r
load_inspq_manual_data() %>% tail(20)
#> # A tibble: 20 x 5
#>    date       hospits hospits_ancien    si volumetrie
#>    <date>       <dbl>          <dbl> <dbl>      <dbl>
#>  1 2020-10-30     421             NA    82      25279
#>  2 2020-10-31     412             NA    84      22487
#>  3 2020-11-01     418             NA    81      17057
#>  4 2020-11-02     441             NA    85      19597
#>  5 2020-11-03     458             NA    81      25563
#>  6 2020-11-04     456             NA    82      28925
#>  7 2020-11-05     462             NA    77      29776
#>  8 2020-11-06     445             NA    78      26951
#>  9 2020-11-07     450             NA    77      21884
#> 10 2020-11-08     464             NA    76      19848
#> 11 2020-11-09     452             NA    82      21851
#> 12 2020-11-10     489             NA    84      28078
#> 13 2020-11-11     497             NA    86      28916
#> 14 2020-11-12     498             NA    85      29846
#> 15 2020-11-13     501             NA    82      29512
#> 16 2020-11-14     498             NA    89      26864
#> 17 2020-11-15     504             NA    87      21685
#> 18 2020-11-16     538             NA   100      23150
#> 19 2020-11-17     552             NA   100      29842
#> 20 2020-11-18     550             NA   101         NA
```

The get\_clean\_rls\_data() function returns the historical number of
cases at the RLS (région locale de service). There are no historical
files at the RLS level on the INSPQ website. This function depends on a
bunch of historical data that I collected, plus a daily archive
repository maintained by Jean-Paul R Soucy.

This function takes a while because it has to download a few hundred of
CSVs before aggregating them.

``` r
rls_data <- get_clean_rls_data() 

rls_data %>% tail(20)
#> # A tibble: 20 x 20
#>    RSS   RLS   date_report cumulative_cases source fix_cummin cases
#>    <chr> <chr> <date>                 <dbl> <chr>       <dbl> <dbl>
#>  1 14 -… 1411… 2020-11-19              4724 curre…       4724    69
#>  2 14 -… 1412… 2020-11-19              5162 curre…       5162    46
#>  3 15 -… 1511… 2020-11-19               126 curre…        126     3
#>  4 15 -… 1512… 2020-11-19               308 curre…        308     1
#>  5 15 -… 1513… 2020-11-19               404 curre…        404     2
#>  6 15 -… 1514… 2020-11-19               258 curre…        258     1
#>  7 15 -… 1515… 2020-11-19              1610 curre…       1610     3
#>  8 15 -… 1516… 2020-11-19              2123 curre…       2123     8
#>  9 15 -… 1517… 2020-11-19              2629 curre…       2629    18
#> 10 16 -… 1611… 2020-11-19              3632 curre…       3632    19
#> 11 16 -… 1612… 2020-11-19              2124 curre…       2124    22
#> 12 16 -… 1621… 2020-11-19              3944 curre…       3944    21
#> 13 16 -… 1622… 2020-11-19              3012 curre…       3012    48
#> 14 16 -… 1623… 2020-11-19               275 curre…        275     9
#> 15 16 -… 1631… 2020-11-19              1457 curre…       1457    12
#> 16 16 -… 1632… 2020-11-19               934 curre…        934     0
#> 17 16 -… 1633… 2020-11-19               210 curre…        210     1
#> 18 16 -… 1634… 2020-11-19              2731 curre…       2731    10
#> 19 17 -… 1701… 2020-11-19                29 curre…         29     0
#> 20 18 -… 1801… 2020-11-19                16 curre…         16     0
#> # … with 13 more variables: shortname_rls <chr>, Population <dbl>,
#> #   cases_per_100k <dbl>, cases_last_7_days <dbl>,
#> #   previous_cases_last_7_days <dbl>, cases_last_7_days_per_100k <dbl>,
#> #   RLS_code <chr>, cases_per_1M <dbl>, last_cases_per_1M <dbl>,
#> #   previous_cases_per_1M <dbl>, color_per_pop <fct>, pop <dbl>,
#> #   RLS_petit_nom <chr>
```

We estimate number of cases at the school board (centre de service
scolaire) level based on the more fine-grained RLS data. It is not
perfect (sometime a RLS stradles 2 CSS so we have to split the cases
proportionally to the population in the intersections), but it’s a good
start. The get\_css\_last\_week() functions runs faster if you provide
it with the `rls_data` object we created when we downloaded the RLS
data. If this is not provided then the RLS data has to be downloaded
again.

``` r
css_last_week  <- get_css_last_week(rls_data)
```

### Figures and maps

``` r
graph_deces_hospit_tests()
```

<img src="man/figures/README-unnamed-chunk-4-1.png" width="100%" />

``` r
graph_quebec_cas_par_region()
```

<img src="man/figures/README-unnamed-chunk-5-1.png" width="100%" />

``` r
graph_quebec_cas_par_age()
```

<img src="man/figures/README-unnamed-chunk-6-1.png" width="100%" />

``` r
graph_quebec_cas_par_age_heatmap()
```

<img src="man/figures/README-unnamed-chunk-7-1.png" width="100%" />
graph\_quebec\_cas\_par\_rls\_heatmap() generates the heatmap showing
the history of cases per capita. It runs faster if you provide it with
an already-downloaded “rls\_data” dataframe provided by
get\_clean\_rls\_data()

``` r
graph_quebec_cas_par_rls_heatmap(rls_data)
```

<img src="man/figures/README-unnamed-chunk-8-1.png" width="100%" />
`carte_rls()` crée une carte montrant le nombre moyen de cas par jour
par million d’habitant durant les 7 derniers jours

``` r
carte_rls(rls_data)
```

<img src="man/figures/README-unnamed-chunk-9-1.png" width="100%" />

``` r
carte_rls_zoom_montreal(rls_data)
```

<img src="man/figures/README-unnamed-chunk-10-1.png" width="100%" />

We can also generate some charts from the estimated cases by CSS for the
previous week:

``` r
carte_css(css_last_week)
```

<img src="man/figures/README-unnamed-chunk-11-1.png" width="100%" />

``` r
graph_css_bars(css_last_week)
```

<img src="man/figures/README-unnamed-chunk-12-1.png" width="100%" />

### Shapefiles

Some shapefiles are included with this package. They are created using
script located in the `data-raw` folder in the repo.

`shp_water` is a (simplified) shapefile showing all coastal water in a
single multipolygon. It is used when I want to remove water from other
shapefiles (such as RLS or CSS). It is derived from statistics canada’s
“Coastal waters (polygons)” for Census 2011 at
<https://www12.statcan.gc.ca/census-recensement/2011/geo/bound-limit/bound-limit-2011-eng.cfm>
. I tried the 2016 version, but some polygons are broken.

``` r
plot(shp_water[,1])
```

<img src="man/figures/README-unnamed-chunk-13-1.png" width="100%" />

The shapefile `shp_rls` shows all the RLS in Quebec after removing
water. It is derived from “Limites territoriales des réseaux locaux de
santé (RLS) en 2020”
(<https://www.donneesquebec.ca/recherche/fr/dataset/limites-territoriales/resource/a73c9996-010d-41ac-a4ba-4def322d55bf>),from
which I removed the coastal waters.

``` r
plot(shp_rls[,1])
```

<img src="man/figures/README-unnamed-chunk-14-1.png" width="100%" /> The
shapefile `shp_css` shows all the CSS (centres de services scolaires) in
Quebec after removing water. It is derived from “Centres de services
scolaires francophones (SDA)” shapefile
<https://www.donneesquebec.ca/recherche/dataset/territoires-des-commissions-scolaires-du-quebec/resource/4cd70cc8-2663-4f10-bfce-bb46f62a77da,from>
which I removed the coastal waters.

``` r
plot(shp_css[,1])
```

<img src="man/figures/README-unnamed-chunk-15-1.png" width="100%" />

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
