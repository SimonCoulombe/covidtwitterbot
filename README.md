
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
des librairies tels que

geos-devel  
sqlite3-devel  
proj-devel  
gdal-devel  
libopenssl-devel

## Example

### Tables

Here are the tables you can fetch and the graphics you can generate..
They are generated from the most up-to-date data.

``` r
library(ggplot2)
library(patchwork)
library(covidtwitterbot)
library(knitr)
```

#### get\_inspq\_covid19\_hist()

The `get_inspq_covid19_hist()` function fetches historical data for
Quebec by age, health region and gender. This includes the numbers of
cases (“cas\_*"), of deaths ("dec\_*”) of hospitalizations (“hos\_*")
and persons tested ("psi\_*”).

**dictionnaire (partiel)des données: **

cas\_cum\_tot\_n = nombre de cas confirmés (cumulatifs) selon date de
déclaration  
cas\_cum\_lab\_n = nombre de cas confirmés en laboratoire (cumulatif)
selon date de déclaration  
cas\_cum\_epi\_n = nombre de cas confirmés par lien épidémiologique
(cumulatif) selon date de déclaration  
cas\_quo\_tot\_n = nombre de cas confirmés (quotidien) selon date de
déclaration  
cas\_quo\_lab\_n = nombre de cas confirmés en laboratoire (quotidien)
selon date de déclaration  
cas\_quo\_epi\_n = nombre de cas confirmés par lien épidémiologique
(quotidien) selon date de déclaration

act\_cum\_tot\_n = nombre de cas actifs (aujourd’hui)

ret\_cum\_tot\_n = nombre de cas rétablis (cumulatifs  
ret\_quo\_tot\_n = nombre de cas rétablis (quotidien)

dec\_cum\_tot\_n = total des décès (cumulatif)  
dec\_cum\_chs\_n = total des décès en CHSLD (cumulatif)  
dec\_cum\_rpa\_n = total des décès en RPA (cumulatif)  
dec\_cum\_dom\_n = total des décès à domicile et inconnu (cumulatif)  
dec\_cum\_aut\_n = total des décès en RI et autre (cumulatif)  
dec\_quo\_tot\_n = total des décès (quotidien)  
dec\_quo\_chs\_n = total des décès en CHSLD (quotidien)  
dec\_quo\_rpa\_n = total des décès en RPA (quotidien)  
dec\_quo\_dom\_n = total des décès à domicile et inconnu (quotidien)  
dec\_quo\_aut\_n = total des décès en RI et autre (quotidien)

ATTENTION: EN DATE DU 18 novembre 2020 LES HOSPITALISATIONS NE SONT PAS
AUGMENTÉES ENTRE LE DERNIER JOUR ET L’AVANT DERNIER JOUR Date Nom
hos\_cum\_reg\_n hos\_cum\_si\_n hos\_cum\_tot\_n hos\_cum\_tot\_t
hos\_quo\_tot\_t hos\_quo\_reg\_n hos\_quo\_si\_n hos\_quo\_tot\_n
hos\_quo\_tot\_m <chr> <chr> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl>
<dbl> <dbl> 1 2020-11-17 Ensemble du Québec 8846 1847 10693 125. 0.37 30
2 32 NA 2 2020-11-18 Ensemble du Québec 8846 1847 10693 125. 0 0 0 0 NA

hos\_quo\_tot\_n = nouvelles hospitalisations (régulières + soins
intensifs)  
hos\_quo\_reg\_n = nouvelles hospitalisations hors soins intensifs  
hos\_quo\_si\_n = nouvelles hospitalisations aux soins intensifs

# ATENTION : EN DATE DU 18 novembre 2020 les PSI quotidiens sont à 0 pour la dernière journée .. sur le site ils utilisent le cumulatif du 18 novembre 2079892 et le quotidien du 17 novembre 28121

A tibble: 2 x 9 Date Nom psi\_cum\_tes\_n psi\_cum\_pos\_n
psi\_cum\_inf\_n psi\_quo\_pos\_n psi\_quo\_inf\_n psi\_quo\_tes\_n
psi\_quo\_pos\_t <chr> <chr> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> 1
2020-11-17 Ensemble du Québec 2074847 119933 1954914 1246 26875 28121
4.44 2 2020-11-18 Ensemble du Québec 2079892 120548 1959344 0 0 0 NA

psi\_cum\_test\_pos = cas confirmés cumulatif  
psi\_cum\_test\_inf = personnes infirmées (test négatifs) cumulatif  
psi\_cum\_test\_n = cumul de personnes testées cumulatif  
psi\_quo\_test\_pos = cas confirmés quotidien \#\# ATTENTION cet colonne
est vide pour la dernière journée  
psi\_quo\_test\_inf = personnes infirmées (test négatifs) quotidien \#\#
ATTENTION cet colonne est vide pour la dernière journée  
psi\_quo\_test\_n = cumul de personnes testées quotidien \#\# ATTENTION
cet colonne est vide pour la dernière journée

``` r
get_inspq_covid19_hist() %>% tail(20)  %>%  knitr::kable()
```

| Date       | Regroupement     | Croisement | Nom                  | cas\_cum\_lab\_n | cas\_cum\_epi\_n | cas\_cum\_tot\_n | cas\_cum\_tot\_t | cas\_quo\_tot\_t | cas\_quo\_lab\_n | cas\_quo\_epi\_n | cas\_quo\_tot\_n | act\_cum\_tot\_n | act\_cum\_tot\_t | cas\_quo\_tot\_m | cas\_quo\_tot\_tm | ret\_cum\_tot\_n | ret\_quo\_tot\_n | dec\_cum\_tot\_n | dec\_cum\_tot\_t | dec\_quo\_tot\_t | dec\_cum\_chs\_n | dec\_cum\_rpa\_n | dec\_cum\_dom\_n | dec\_cum\_aut\_n | dec\_quo\_tot\_n | dec\_quo\_chs\_n | dec\_quo\_rpa\_n | dec\_quo\_dom\_n | dec\_quo\_aut\_n | dec\_quo\_tot\_m | dec\_quo\_tot\_tm | hos\_cum\_reg\_n | hos\_cum\_si\_n | hos\_cum\_tot\_n | hos\_cum\_tot\_t | hos\_quo\_tot\_t | hos\_quo\_reg\_n | hos\_quo\_si\_n | hos\_quo\_tot\_n | hos\_quo\_tot\_m | psi\_cum\_tes\_n | psi\_cum\_pos\_n | psi\_cum\_inf\_n | psi\_cum\_adm\_n | psi\_quo\_pos\_n | psi\_quo\_inf\_n | psi\_quo\_tes\_n | psi\_quo\_pos\_t | date       | type             | groupe               | cas\_totaux\_cumul | cas\_totaux\_quotidien | deces\_totaux\_quotidien |     pop |
|:-----------|:-----------------|:-----------|:---------------------|-----------------:|-----------------:|-----------------:|-----------------:|-----------------:|-----------------:|-----------------:|-----------------:|-----------------:|-----------------:|-----------------:|------------------:|-----------------:|-----------------:|-----------------:|-----------------:|-----------------:|-----------------:|-----------------:|-----------------:|-----------------:|-----------------:|-----------------:|-----------------:|-----------------:|-----------------:|-----------------:|------------------:|-----------------:|----------------:|-----------------:|-----------------:|-----------------:|-----------------:|----------------:|-----------------:|-----------------:|-----------------:|-----------------:|-----------------:|-----------------:|-----------------:|-----------------:|-----------------:|-----------------:|:-----------|:-----------------|:---------------------|-------------------:|-----------------------:|-------------------------:|--------:|
| 2021-03-28 | Groupe de région | REG02      | Ceinture de Montréal |            50932 |             1949 |            52881 |          3572.59 |             4.44 |               66 |                0 |               66 |             1023 |            68.81 |               NA |                NA |            50017 |               98 |             1529 |           103.30 |             0.00 |              753 |              349 |              332 |               95 |                0 |                0 |                0 |                0 |                0 |               NA |                NA |               NA |              NA |               NA |               NA |               NA |               NA |              NA |               NA |               NA |           579227 |            50521 |           528706 |          1287262 |               NA |               NA |               NA |               NA | 2021-03-28 | region\_montreal | Ceinture de Montréal |              52881 |                     66 |                        0 |      NA |
| 2021-03-28 | Groupe de région | REG03      | Autres régions       |           110532 |             3279 |           113811 |          2491.18 |             6.20 |              278 |                6 |              284 |             2990 |            65.28 |               NA |                NA |           106351 |              240 |             3545 |            77.60 |             0.02 |             1452 |             1043 |              856 |              194 |                1 |                0 |                1 |                0 |                0 |               NA |                NA |               NA |              NA |               NA |               NA |               NA |               NA |              NA |               NA |               NA |          1599203 |           109751 |          1489452 |          3329728 |               NA |               NA |               NA |               NA | 2021-03-28 | region\_montreal | Autres régions       |             113811 |                    284 |                        1 |      NA |
| 2021-03-28 | Groupe de région | REG00      | Inconnu              |                4 |                0 |                4 |               NA |               NA |                0 |                0 |                0 |                0 |               NA |               NA |                NA |                4 |                0 |                0 |               NA |               NA |                0 |                0 |                0 |                0 |                0 |                0 |                0 |                0 |                0 |               NA |                NA |               NA |              NA |               NA |               NA |               NA |               NA |              NA |               NA |               NA |            10737 |              358 |            10379 |            14363 |               NA |               NA |               NA |               NA | 2021-03-28 | region\_montreal | Inconnue             |                  4 |                      0 |                        0 |      NA |
| 2021-03-28 | Groupe de région | REG98      | Hors Québec          |              276 |                5 |              281 |               NA |               NA |                0 |                0 |                0 |               10 |               NA |               NA |                NA |              267 |                1 |                0 |               NA |               NA |                0 |                0 |                0 |                0 |                0 |                0 |                0 |                0 |                0 |               NA |                NA |               NA |              NA |               NA |               NA |               NA |               NA |              NA |               NA |               NA |            13953 |              436 |            13517 |            19794 |               NA |               NA |               NA |               NA | 2021-03-28 | region\_montreal | Hors Québec          |                281 |                      0 |                        0 |      NA |
| 2021-03-28 | Groupe d’âge     | 0\_9       | 0-9 ans              |            22250 |             1977 |            24227 |          2713.39 |             7.40 |               63 |                3 |               66 |              874 |            98.01 |               NA |                NA |            23132 |               85 |                0 |             0.00 |             0.00 |                0 |                0 |                0 |                0 |                0 |                0 |                0 |                0 |                0 |               NA |                NA |               NA |              NA |               NA |               NA |               NA |               NA |              NA |               NA |               NA |           359348 |            19142 |           340206 |           589150 |               NA |               NA |               NA |               NA | 2021-03-28 | groupe\_age      | 0 à 9 ans            |              24227 |                     66 |                        0 |  893977 |
| 2021-03-28 | Groupe d’âge     | 10\_19     | 10-19 ans            |            34621 |             1478 |            36099 |          4078.30 |            11.44 |              100 |                2 |              102 |             1179 |           132.18 |               NA |                NA |            34689 |              119 |                1 |             0.11 |             0.00 |                0 |                0 |                1 |                0 |                0 |                0 |                0 |                0 |                0 |               NA |                NA |               NA |              NA |               NA |               NA |               NA |               NA |              NA |               NA |               NA |           349659 |            30396 |           319263 |           534252 |               NA |               NA |               NA |               NA | 2021-03-28 | groupe\_age      | 10 à 19 ans          |              36099 |                    102 |                        0 |  878347 |
| 2021-03-28 | Groupe d’âge     | 20\_29     | 20-29 ans            |            45769 |             1475 |            47244 |          4504.25 |             8.07 |               84 |                0 |               84 |             1077 |           103.41 |               NA |                NA |            45825 |              113 |                7 |             0.67 |             0.00 |                0 |                0 |                6 |                1 |                0 |                0 |                0 |                0 |                0 |               NA |                NA |               NA |              NA |               NA |               NA |               NA |               NA |              NA |               NA |               NA |           407874 |            41066 |           366808 |           848617 |               NA |               NA |               NA |               NA | 2021-03-28 | groupe\_age      | 20 à 29 ans          |              47244 |                     84 |                        0 | 1056242 |
| 2021-03-28 | Groupe d’âge     | 30\_39     | 30-39 ans            |            42666 |             1251 |            43917 |          3930.75 |             6.44 |               72 |                0 |               72 |             1085 |            96.99 |               NA |                NA |            42514 |              108 |               14 |             1.25 |             0.00 |                3 |                0 |                8 |                3 |                0 |                0 |                0 |                0 |                0 |               NA |                NA |               NA |              NA |               NA |               NA |               NA |               NA |              NA |               NA |               NA |           443729 |            38063 |           405666 |           959075 |               NA |               NA |               NA |               NA | 2021-03-28 | groupe\_age      | 30 à 39 ans          |              43917 |                     72 |                        0 | 1115906 |
| 2021-03-28 | Groupe d’âge     | 40\_49     | 40-49 ans            |            44924 |             1214 |            46138 |          4163.78 |             8.07 |               90 |                0 |               90 |             1172 |           105.08 |               NA |                NA |            44631 |              136 |               39 |             3.52 |             0.00 |               11 |                2 |               25 |                1 |                0 |                0 |                0 |                0 |                0 |               NA |                NA |               NA |              NA |               NA |               NA |               NA |               NA |              NA |               NA |               NA |           402124 |            40682 |           361442 |           917876 |               NA |               NA |               NA |               NA | 2021-03-28 | groupe\_age      | 40 à 49 ans          |              46138 |                     90 |                        0 | 1100826 |
| 2021-03-28 | Groupe d’âge     | 50\_59     | 50-59 ans            |            39516 |             1025 |            40541 |          3469.14 |             5.28 |               60 |                1 |               61 |             1021 |            88.38 |               NA |                NA |            39068 |              102 |              182 |            15.57 |             0.00 |               71 |                2 |               98 |               11 |                0 |                0 |                0 |                0 |                0 |               NA |                NA |               NA |              NA |               NA |               NA |               NA |               NA |              NA |               NA |               NA |           352267 |            36077 |           316190 |           836906 |               NA |               NA |               NA |               NA | 2021-03-28 | groupe\_age      | 50 à 59 ans          |              40541 |                     61 |                        0 | 1182044 |
| 2021-03-28 | Groupe d’âge     | 60\_69     | 60-69 ans            |            24597 |              546 |            25143 |          2170.75 |             2.99 |               35 |                0 |               35 |              696 |            59.55 |               NA |                NA |            23691 |               55 |              628 |            54.22 |             0.09 |              278 |               39 |              276 |               35 |                1 |                0 |                0 |                1 |                0 |               NA |                NA |               NA |              NA |               NA |               NA |               NA |               NA |              NA |               NA |               NA |           293320 |            22912 |           270408 |           614959 |               NA |               NA |               NA |               NA | 2021-03-28 | groupe\_age      | 60 à 69 ans          |              25143 |                     35 |                        1 | 1147664 |
| 2021-03-28 | Groupe d’âge     | 70\_79     | 70-79 ans            |            16479 |              241 |            16720 |          2175.91 |             2.04 |               16 |                0 |               16 |              382 |            48.78 |               NA |                NA |            14202 |               26 |             2010 |           261.58 |             0.00 |              960 |              273 |              671 |              106 |                0 |                0 |                0 |                0 |                0 |               NA |                NA |               NA |              NA |               NA |               NA |               NA |               NA |              NA |               NA |               NA |           196183 |            14897 |           181286 |           450721 |               NA |               NA |               NA |               NA | 2021-03-28 | groupe\_age      | 70 à 79 ans          |              16720 |                     16 |                        0 |  753700 |
| 2021-03-28 | Groupe d’âge     | 80\_89     | 80-89 ans            |            17900 |              280 |            18180 |          5458.30 |             2.66 |                9 |                0 |                9 |              368 |           108.73 |               NA |                NA |            13442 |               11 |             4188 |          1257.39 |             0.00 |             2240 |             1008 |              729 |              211 |                0 |                0 |                0 |                0 |                0 |               NA |                NA |               NA |              NA |               NA |               NA |               NA |               NA |              NA |               NA |               NA |           123337 |            16018 |           107319 |           410989 |               NA |               NA |               NA |               NA | 2021-03-28 | groupe\_age      | 80 à 89 ans          |              18180 |                      9 |                        0 |  327675 |
| 2021-03-28 | Groupe d’âge     | 90\_       | 90 ans et plus       |            10730 |              219 |            10949 |         12902.20 |             2.30 |                2 |                0 |                2 |              132 |           151.63 |               NA |                NA |             7360 |                4 |             3486 |          4107.87 |             1.15 |             2078 |              923 |              303 |              182 |                1 |                0 |                1 |                0 |                0 |               NA |                NA |               NA |              NA |               NA |               NA |               NA |               NA |              NA |               NA |               NA |            51319 |            10722 |            40597 |           227249 |               NA |               NA |               NA |               NA | 2021-03-28 | groupe\_age      | 90 ans et +          |              10949 |                      2 |                        1 |   82670 |
| 2021-03-28 | Groupe d’âge     | INC        | Inconnu              |               18 |               24 |               42 |               NA |               NA |                0 |                0 |                0 |                1 |               NA |               NA |                NA |               39 |                0 |                0 |               NA |               NA |                0 |                0 |                0 |                0 |                0 |                0 |                0 |                0 |                0 |               NA |                NA |               NA |              NA |               NA |               NA |               NA |               NA |              NA |               NA |               NA |           317012 |            29484 |           287528 |           684468 |               NA |               NA |               NA |               NA | 2021-03-28 | groupe\_age      | Âge inconnu          |                 42 |                      0 |                        0 |      NA |
| 2021-03-28 | Groupe d’âge     | TOT        | Total                |           299470 |             9730 |           309200 |          3609.84 |             6.25 |              531 |                6 |              537 |             7987 |            92.96 |               NA |                NA |           288593 |              759 |            10555 |           123.23 |             0.02 |             5641 |             2247 |             2117 |              550 |                2 |                0 |                1 |                1 |                0 |               NA |                NA |               NA |              NA |               NA |               NA |               NA |               NA |              NA |               NA |               NA |          3296172 |           299459 |          2996713 |          7074262 |               NA |               NA |               NA |               NA | 2021-03-28 | groupe\_age      | Total                |             309200 |                    537 |                        2 | 8390499 |
| 2021-03-28 | Sexe             | MASC       | Masculin             |           139423 |             4847 |           144270 |          3369.77 |             6.15 |              262 |                2 |              264 |             4034 |            93.91 |               NA |                NA |           134298 |              385 |             4973 |           116.16 |             0.05 |             2436 |             1020 |             1261 |              256 |                2 |                0 |                1 |                1 |                0 |               NA |                NA |               NA |              NA |               NA |               NA |               NA |               NA |              NA |               NA |               NA |          1506973 |           138943 |          1368030 |          2838213 |               NA |               NA |               NA |               NA | 2021-03-28 | sexe             | Masculin             |             144270 |                    264 |                        2 |      NA |
| 2021-03-28 | Sexe             | FEM        | Féminin              |           159922 |             4882 |           164804 |          3846.82 |             6.33 |              268 |                4 |              272 |             3952 |            91.98 |               NA |                NA |           154172 |              374 |             5581 |           130.27 |             0.00 |             3205 |             1226 |              856 |              294 |                0 |                0 |                0 |                0 |                0 |               NA |                NA |               NA |              NA |               NA |               NA |               NA |               NA |              NA |               NA |               NA |          1780768 |           159981 |          1620787 |          4224217 |               NA |               NA |               NA |               NA | 2021-03-28 | sexe             | Féminin              |             164804 |                    272 |                        0 |      NA |
| 2021-03-28 | Sexe             | INC        | Inconnu              |              125 |                1 |              126 |               NA |               NA |                1 |                0 |                1 |                1 |               NA |               NA |                NA |              123 |                0 |                1 |               NA |               NA |                0 |                1 |                0 |                0 |                0 |                0 |                0 |                0 |                0 |               NA |                NA |               NA |              NA |               NA |               NA |               NA |               NA |              NA |               NA |               NA |             8431 |              535 |             7896 |            11832 |               NA |               NA |               NA |               NA | 2021-03-28 | sexe             | Sexe inconnu         |                126 |                      1 |                        0 |      NA |
| 2021-03-28 | Sexe             | TOT        | Total                |           299470 |             9730 |           309200 |          3609.84 |             6.25 |              531 |                6 |              537 |             7987 |            92.96 |               NA |                NA |           288593 |              759 |            10555 |           123.23 |             0.02 |             5641 |             2247 |             2117 |              550 |                2 |                0 |                1 |                1 |                0 |               NA |                NA |               NA |              NA |               NA |               NA |               NA |               NA |              NA |               NA |               NA |          3296172 |           299459 |          2996713 |          7074262 |               NA |               NA |               NA |               NA | 2021-03-28 | sexe             | Total                |             309200 |                    537 |                        2 |      NA |

#### get\_inspq\_manual\_data\_hospits()

The get\_inspq\_manual\_data\_hospits() function returns the historical
number of hospitalisation (hospits\_ancien and hospits), intensive care
(si) and number of tests (volumetrie) for the province

*dictionnaire des données *  
hospits = hospitalisation hors intensif en cours  
hospits\_ancien = hospitalisation hors intensif en cours (ancienne
mesure, remplacée au printemps 2020 par l’actuelle)  
si = soins intensifs en cours  
volumetrie = nombre de tests (cette colonne est vide pour la dernière
journée)

``` r
get_inspq_manual_data_hospits() %>% tail(20)   %>%  knitr::kable()
```

| date       | hospits | hospits\_ancien |  si | volumetrie |
|:-----------|--------:|----------------:|----:|-----------:|
| 2021-03-09 |     469 |              NA | 112 |      29655 |
| 2021-03-10 |     452 |              NA | 111 |      29175 |
| 2021-03-11 |     444 |              NA | 106 |      29507 |
| 2021-03-12 |     445 |              NA | 106 |      28466 |
| 2021-03-13 |     447 |              NA | 100 |      23159 |
| 2021-03-14 |     457 |              NA |  96 |      18232 |
| 2021-03-15 |     442 |              NA |  91 |      23432 |
| 2021-03-16 |     425 |              NA | 107 |      31945 |
| 2021-03-17 |     418 |              NA | 101 |      33670 |
| 2021-03-18 |     405 |              NA |  99 |      32943 |
| 2021-03-19 |     406 |              NA |  99 |      31995 |
| 2021-03-20 |     399 |              NA | 102 |      24609 |
| 2021-03-21 |     399 |              NA | 114 |      21447 |
| 2021-03-22 |     406 |              NA | 113 |      25675 |
| 2021-03-23 |     390 |              NA | 118 |      35129 |
| 2021-03-24 |     379 |              NA | 117 |      39663 |
| 2021-03-25 |     366 |              NA | 115 |      35960 |
| 2021-03-26 |     373 |              NA | 108 |      33671 |
| 2021-03-27 |     366 |              NA | 114 |      26993 |
| 2021-03-28 |     357 |              NA | 120 |         NA |

#### get\_inspq\_manual\_data\_tableau\_accueil()

get\_inspq\_manual\_data\_tableau\_accueil() retourne les chiffres
utilisés dans le haut de la page de données covid19 de l’inspq. ça
balance pas toujours avec l’output des 2 fonctions précédentes.

``` r
get_inspq_manual_data_tableau_accueil()   %>%  knitr::kable()
```

|    cas | deces | hospit | soins | gueris | analyses | type      |
|-------:|------:|-------:|------:|-------:|---------:|:----------|
| 309202 | 10651 |    477 |   120 | 290564 |    26993 | cumulatif |
|    891 |     4 |     -3 |     6 |    737 |       NA | quotidien |

#### get\_rls\_data()

The get\_rls\_data() function returns the historical number of cases at
the RLS (région locale de service). There are no historical files at the
RLS level on the INSPQ website. This function depends on a bunch of
historical data that I collected, plus a daily archive repository
maintained by Jean-Paul R Soucy.

This function takes a while because it has to download a few hundred of
CSVs before aggregating them.

``` r
rls_data <-suppressMessages( get_rls_data() )

rls_data %>% tail(20)   %>%  knitr::kable()
```

| RSS                                | RLS                                             | date\_report | cumulative\_cases | source       | fix\_cummin | cases | shortname\_rls                    | Population | cases\_per\_100k | cases\_last\_7\_days | previous\_cases\_last\_7\_days | cases\_last\_7\_days\_per\_100k | RLS\_code | cases\_per\_1M | last\_cases\_per\_1M | previous\_cases\_per\_1M | color\_per\_pop                 |    pop | RLS\_petit\_nom                       |
|:-----------------------------------|:------------------------------------------------|:-------------|------------------:|:-------------|------------:|------:|:----------------------------------|-----------:|-----------------:|---------------------:|-------------------------------:|--------------------------------:|:----------|---------------:|---------------------:|-------------------------:|:--------------------------------|-------:|:--------------------------------------|
| 14 - Lanaudière                    | 1411 - RLS de Lanaudière-Nord                   | 2021-03-29   |              8415 | cronjob\_new |        8415 |    12 | Lanaudière-Nord                   |     223099 |         5.378778 |                   70 |                            111 |                        31.37621 | 1411      |       44.82315 |             44.82315 |                71.076710 | entre 20 et 60 cas par million  | 223099 | 1411 - Lanaudière-Nord                |
| 14 - Lanaudière                    | 1412 - RLS de Lanaudière-Sud                    | 2021-03-29   |             12778 | cronjob\_new |       12778 |    28 | Lanaudière-Sud                    |     296993 |         9.427832 |                  169 |                            202 |                        56.90370 | 1412      |       81.29100 |             81.29100 |                97.164387 | entre 60 et 100 cas par million | 296993 | 1412 - Lanaudière-Sud                 |
| 15 - Laurentides                   | 1511 - RLS d’Antoine-Labelle                    | 2021-03-29   |               836 | cronjob\_new |         836 |     4 | d’Antoine-Labelle                 |      35580 |        11.242271 |                   14 |                             16 |                        39.34795 | 1511      |       56.21135 |             56.21135 |                64.241548 | entre 20 et 60 cas par million  |  35580 | 1511 - d’Antoine-Labelle              |
| 15 - Laurentides                   | 1512 - RLS des Laurentides                      | 2021-03-29   |               922 | cronjob\_new |         922 |     4 | des Laurentides                   |      48016 |         8.330557 |                   29 |                             11 |                        60.39653 | 1512      |       86.28076 |             86.28076 |                32.727186 | entre 60 et 100 cas par million |  48016 | 1512 - Laurentides                    |
| 15 - Laurentides                   | 1513 - RLS des Pays-d’en-Haut                   | 2021-03-29   |               916 | cronjob\_new |         916 |     2 | des Pays-d’en-Haut                |      44362 |         4.508363 |                   12 |                              8 |                        27.05018 | 1513      |       38.64311 |             38.64311 |                25.762074 | entre 20 et 60 cas par million  |  44362 | 1513 - Pays-d’en-Haut                 |
| 15 - Laurentides                   | 1514 - RLS d’Argenteuil                         | 2021-03-29   |               676 | cronjob\_new |         676 |     1 | d’Argenteuil                      |      33422 |         2.992041 |                   19 |                             25 |                        56.84878 | 1514      |       81.21255 |             81.21255 |               106.858613 | entre 60 et 100 cas par million |  33422 | 1514 - d’Argenteuil                   |
| 15 - Laurentides                   | 1515 - RLS de Deux-Montagnes - Mirabel-Sud      | 2021-03-29   |              3661 | cronjob\_new |        3661 |     8 | Deux-Montagnes - Mirabel-Sud      |     124641 |         6.418434 |                   65 |                             75 |                        52.14977 | 1515      |       74.49968 |             74.49968 |                85.961166 | entre 60 et 100 cas par million | 124641 | 1515 - Deux-Montagnes - Mirabel-Sud   |
| 15 - Laurentides                   | 1516 - RLS de la Rivière-du-Nord - Mirabel-Nord | 2021-03-29   |              5020 | cronjob\_new |        5020 |    14 | la Rivière-du-Nord - Mirabel-Nord |     177517 |         7.886569 |                   57 |                             64 |                        32.10960 | 1516      |       45.87086 |             45.87086 |                51.504121 | entre 20 et 60 cas par million  | 177517 | 1516 - Rivière-du-Nord - Mirabel-Nord |
| 15 - Laurentides                   | 1517 - RLS de Thérèse-De Blainville             | 2021-03-29   |              5714 | cronjob\_new |        5714 |    27 | Thérèse-De Blainville             |     163430 |        16.520835 |                  146 |                             95 |                        89.33488 | 1517      |      127.62126 |            127.62126 |                83.041232 | plus de 100 cas par million     | 163430 | 1517 - Thérèse-De Blainville          |
| 16 - Montérégie                    | 1611 - RLS de Champlain                         | 2021-03-29   |              7821 | cronjob\_new |        7821 |    15 | Champlain                         |     225442 |         6.653596 |                  131 |                            102 |                        58.10807 | 1611      |       83.01153 |             83.01153 |                64.634933 | entre 60 et 100 cas par million | 225442 | 1611 - Champlain                      |
| 16 - Montérégie                    | 1612 - RLS du Haut-Richelieu - Rouville         | 2021-03-29   |              5000 | cronjob\_new |        5000 |    14 | du Haut-Richelieu - Rouville      |     195297 |         7.168569 |                   99 |                             66 |                        50.69202 | 1612      |       72.41718 |             72.41718 |                48.278117 | entre 60 et 100 cas par million | 195297 | 1612 - Haut-Richelieu - Rouville      |
| 16 - Montérégie                    | 1621 - RLS Pierre-Boucher                       | 2021-03-29   |              9028 | cronjob\_new |        9028 |    21 | Pierre-Boucher                    |     262440 |         8.001829 |                  137 |                             94 |                        52.20241 | 1621      |       74.57487 |             74.57487 |                51.168158 | entre 60 et 100 cas par million | 262440 | 1621 - Pierre-Boucher                 |
| 16 - Montérégie                    | 1622 - RLS de Richelieu-Yamaska                 | 2021-03-29   |              7340 | cronjob\_new |        7340 |    18 | Richelieu-Yamaska                 |     220957 |         8.146381 |                  140 |                             76 |                        63.36074 | 1622      |       90.51535 |             90.51535 |                49.136904 | entre 60 et 100 cas par million | 220957 | 1622 - Richelieu-Yamaska              |
| 16 - Montérégie                    | 1623 - RLS Pierre-De Saurel                     | 2021-03-29   |              1203 | cronjob\_new |        1203 |     0 | Pierre-De Saurel                  |      51371 |         0.000000 |                    6 |                              3 |                        11.67974 | 1623      |       16.68535 |             16.68535 |                 8.342673 | moins de 20 cas par million     |  51371 | 1623 - Pierre-De Saurel               |
| 16 - Montérégie                    | 1631 - RLS de Vaudreuil-Soulanges               | 2021-03-29   |              4032 | cronjob\_new |        4032 |    12 | Vaudreuil-Soulanges               |     160002 |         7.499906 |                   71 |                             45 |                        44.37445 | 1631      |       63.39206 |             63.39206 |                40.178069 | entre 60 et 100 cas par million | 160002 | 1631 - Vaudreuil-Soulanges            |
| 16 - Montérégie                    | 1632 - RLS du Suroît                            | 2021-03-29   |              1938 | cronjob\_new |        1938 |     3 | du Suroît                         |      60523 |         4.956793 |                   22 |                             16 |                        36.34982 | 1632      |       51.92831 |             51.92831 |                37.766044 | entre 20 et 60 cas par million  |  60523 | 1632 - Suroît                         |
| 16 - Montérégie                    | 1633 - RLS du Haut-Saint-Laurent                | 2021-03-29   |               603 | cronjob\_new |         603 |     0 | du Haut-Saint-Laurent             |      24346 |         0.000000 |                    3 |                              6 |                        12.32235 | 1633      |       17.60336 |             17.60336 |                35.206722 | moins de 20 cas par million     |  24346 | 1633 - Haut-Saint-Laurent             |
| 16 - Montérégie                    | 1634 - RLS de Jardins-Roussillon                | 2021-03-29   |              7043 | cronjob\_new |        7043 |    20 | Jardins-Roussillon                |     232373 |         8.606852 |                  119 |                             75 |                        51.21077 | 1634      |       73.15824 |             73.15824 |                46.108135 | entre 60 et 100 cas par million | 232373 | 1634 - Jardins-Roussillon             |
| 17 - Nunavik                       | 1701 - Nunavik                                  | 2021-03-29   |                46 | cronjob\_new |          46 |     0 | NA                                |      14260 |         0.000000 |                    0 |                              0 |                         0.00000 | 1701      |        0.00000 |              0.00000 |                 0.000000 | moins de 20 cas par million     |  14260 | 1701 - Nunavik                        |
| 18 - Terres-Cries-de-la-Baie-James | 1801 - Terres-Cries-de-la-Baie-James            | 2021-03-29   |               119 | cronjob\_new |         119 |     0 | NA                                |      18385 |         0.000000 |                    0 |                              0 |                         0.00000 | 1801      |        0.00000 |              0.00000 |                 0.000000 | moins de 20 cas par million     |  18385 | 1801 - Terres-Cries-de-la-Baie-James  |

We estimate number of cases at the school board (centre de service
scolaire) level based on the more fine-grained RLS data. It is not
perfect (sometime a RLS stradles 2 CSS so we have to split the cases
proportionally to the population in the intersections), but it’s a good
start. The get\_css\_last\_week() functions runs faster if you provide
it with the `rls_data` object we created when we downloaded the RLS
data. If this is not provided then the RLS data has to be downloaded
again.

#### get\_css\_last\_week()

``` r
css_last_week  <- get_css_last_week(rls_data)   
css_last_week %>% tail(20) %>% sf::st_drop_geometry() %>% knitr::kable()
```

| CD\_CS | NOM\_CS                           | SITE\_WEB                    |  SUPRF\_KM2 |  PERMT\_KM | NOM\_VERSN | dummy | dummy2 | date\_report | cases\_last\_7\_days | previous\_cases\_last\_7\_days | Population | dailycases\_per\_1M\_avg\_7\_days | previous\_dailycases\_per\_1M\_avg\_7\_days | color\_per\_pop                 | cases\_last\_7\_days\_per\_100k | cases\_per\_1M | NOM\_CS\_petit\_nom        |
|:-------|:----------------------------------|:-----------------------------|------------:|-----------:|:-----------|------:|-------:|:-------------|---------------------:|-------------------------------:|-----------:|----------------------------------:|--------------------------------------------:|:--------------------------------|--------------------------------:|---------------:|:---------------------------|
| 731000 | CSS de Charlevoix                 | www.cscharlevoix.qc.ca       |   7066.5687 |  403.05820 | V2020-07   |     1 |      1 | 2021-03-29   |                   12 |                     13.9355987 |      28295 |                              60.3 |                                        70.4 | entre 60 et 100 cas par million |                            42.2 |           60.3 | Charlevoix                 |
| 821000 | CSS de la Côte-du-Sud             | <http://www.cscotesud.qc.ca> |   5959.9203 |  418.42028 | V2020-07   |     1 |      1 | 2021-03-29   |                   27 |                      7.8543048 |      70237 |                              54.8 |                                        16.0 | entre 20 et 60 cas par million  |                            38.3 |           54.8 | Côte-du-Sud                |
| 852000 | CSS de la Rivière-du-Nord         | <http://www2.csrdn.qc.ca/>   |   2049.6010 |  322.44185 | V2020-07   |     1 |      1 | 2021-03-29   |                   75 |                     87.9243392 |     190425 |                              56.3 |                                        66.0 | entre 20 et 60 cas par million  |                            39.4 |           56.3 | Rivière-du-Nord            |
| 772000 | CSS des Portages-de-l’Outaouais   | www.cspo.qc.ca               |   1382.6493 |  195.52992 | V2020-07   |     1 |      1 | 2021-03-29   |                  220 |                    130.6675249 |     153423 |                             204.6 |                                       121.7 | plus de 100 cas par million     |                           143.2 |          204.6 | Portages-de-l’Outaouais    |
| 724000 | CSS De La Jonquière               | www.csjonquiere.qc.ca        |   1001.8302 |  169.10289 | V2020-07   |     1 |      1 | 2021-03-29   |                    6 |                      6.0001742 |      66718 |                              12.8 |                                        12.8 | moins de 20 cas par million     |                             9.0 |           12.8 | De La Jonquière            |
| 773000 | CSS au Coeur-des-Vallées          | www.cscv.qc.ca               |   3458.9423 |  322.35632 | V2020-07   |     1 |      1 | 2021-03-29   |                   25 |                      9.8282775 |      53658 |                              65.4 |                                        26.2 | entre 60 et 100 cas par million |                            45.8 |           65.4 | au Coeur-des-Vallées       |
| 774000 | CSS des Hauts-Bois-de-l’Outaouais | www.cshbo.qc.ca              |  28080.7957 | 1363.04393 | V2020-07   |     1 |      1 | 2021-03-29   |                   17 |                      9.1360234 |      33868 |                              71.8 |                                        38.5 | entre 60 et 100 cas par million |                            50.3 |           71.8 | Hauts-Bois-de-l’Outaouais  |
| 791000 | CSS de l’Estuaire                 | www.csestuaire.qc.ca         |  57965.0122 | 1241.96584 | V2020-07   |     1 |      1 | 2021-03-29   |                    0 |                      3.0005544 |      41543 |                               0.0 |                                        10.3 | moins de 20 cas par million     |                             0.0 |            0.0 | l’Estuaire                 |
| 782000 | CSS de Rouyn-Noranda              | www.csrn.qc.ca               |   6073.5950 |  416.44383 | V2020-07   |     1 |      1 | 2021-03-29   |                    4 |                      0.9868319 |      41784 |                              13.5 |                                         3.4 | moins de 20 cas par million     |                             9.4 |           13.5 | Rouyn-Noranda              |
| 801000 | CSS de la Baie-James              | <http://csbj.qc.ca/>         | 343574.3467 | 5631.60890 | V2020-07   |     1 |      1 | 2021-03-29   |                    0 |                      0.0000636 |      16151 |                               0.0 |                                         0.0 | moins de 20 cas par million     |                             0.0 |            0.0 | Baie-James                 |
| 742000 | CSS de l’Énergie                  | www.csenergie.qc.ca          |  37903.5713 | 1189.64144 | V2020-07   |     1 |      1 | 2021-03-29   |                   19 |                      5.4940374 |      97133 |                              27.5 |                                         8.1 | entre 20 et 60 cas par million  |                            19.2 |           27.5 | l’Énergie                  |
| 762000 | CSS de Montréal                   | www.csdm.qc.ca               |    163.9897 |  112.21365 | V2020-07   |     1 |      1 | 2021-03-29   |                 1072 |                   1025.4063524 |    1009727 |                             151.7 |                                       145.1 | plus de 100 cas par million     |                           106.2 |          151.7 | Montréal                   |
| 763000 | CSS Marguerite-Bourgeoys          | www.csmb.qc.ca               |    356.2161 |  133.05741 | V2020-07   |     1 |      1 | 2021-03-29   |                  660 |                    626.4738529 |     611365 |                             154.3 |                                       146.4 | plus de 100 cas par million     |                           108.0 |          154.3 | Marguerite-Bourgeoys       |
| 869000 | CSS des Trois-Lacs                | www.cstrois-lacs.qc.ca       |   1023.8689 |  154.98997 | V2020-07   |     1 |      1 | 2021-03-29   |                   71 |                     45.0033481 |     147799 |                              68.6 |                                        43.5 | entre 60 et 100 cas par million |                            48.0 |           68.6 | Trois-Lacs                 |
| 823000 | CSS de la Beauce-Etchemin         | www.csbe.qc.ca               |   6202.0129 |  542.92776 | V2020-07   |     1 |      1 | 2021-03-29   |                  158 |                     52.1075145 |     123821 |                             182.5 |                                        60.1 | plus de 100 cas par million     |                           127.8 |          182.5 | Beauce-Etchemin            |
| 868000 | CSS de la Vallée-des-Tisserands   | www.csvt.qc.ca               |   1847.3375 |  219.29223 | V2020-07   |     1 |      1 | 2021-03-29   |                   29 |                     24.4664251 |      86081 |                              48.0 |                                        40.6 | entre 20 et 60 cas par million  |                            33.6 |           48.0 | Vallée-des-Tisserands      |
| 854000 | CSS Pierre-Neveu                  | www.cspn.qc.ca               |  16291.9939 |  859.45936 | V2020-07   |     1 |      1 | 2021-03-29   |                   14 |                     15.9993964 |      35249 |                              56.7 |                                        64.8 | entre 20 et 60 cas par million  |                            39.7 |           56.7 | Pierre-Neveu               |
| 714000 | CSS de Kamouraska-Rivière-du-Loup | www.cskamloup.qc.ca          |   5054.5614 |  413.10309 | V2020-07   |     1 |      1 | 2021-03-29   |                  194 |                     36.2003193 |      55614 |                             497.3 |                                        93.0 | plus de 100 cas par million     |                           348.1 |          497.3 | Kamouraska-Rivière-du-Loup |
| 853000 | CSS des Laurentides               | www.cslaurentides.qc.ca      |   3970.8926 |  362.47283 | V2020-07   |     1 |      1 | 2021-03-29   |                   42 |                     21.1322007 |      92025 |                              66.0 |                                        32.8 | entre 60 et 100 cas par million |                            46.2 |           66.0 | Laurentides                |
| 831000 | CSS de Laval                      | www.cslaval.qc.ca            |    266.9471 |   83.47677 | V2020-07   |     1 |      1 | 2021-03-29   |                  628 |                    524.0000000 |     418557 |                             214.3 |                                       178.8 | plus de 100 cas par million     |                           150.0 |          214.3 | Laval                      |

#### Montreal data

``` r
mtl_data <-suppressMessages( get_mtl_data() )

mtl_data %>% tail(20)   %>%  knitr::kable()
```

| arrondissement                           | date\_report | cumulative\_cases | source | fix\_cummin | cases | arrond\_ville\_liee | Population | cases\_per\_100k | cases\_last\_7\_days | previous\_cases\_last\_7\_days | cases\_last\_7\_days\_per\_100k | cases\_per\_1M | last\_cases\_per\_1M | previous\_cases\_per\_1M | color\_per\_pop                 |     pop |
|:-----------------------------------------|:-------------|------------------:|:-------|------------:|------:|:--------------------|-----------:|-----------------:|---------------------:|-------------------------------:|--------------------------------:|---------------:|---------------------:|-------------------------:|:--------------------------------|--------:|
| Montréal Est                             | 2021-03-29   |               241 | github |         241 |     1 | Ville               |       4012 |        24.925224 |                    6 |                              7 |                       149.55135 |      213.64478 |            213.64478 |                249.25224 | plus de 100 cas par million     |    4012 |
| Montréal-Nord                            | 2021-03-29   |              8256 | github |        8256 |    17 | Arrond.             |      87928 |        19.334000 |                  111 |                            132 |                       126.23965 |      180.34236 |            180.34236 |                214.46118 | plus de 100 cas par million     |   87928 |
| Montréal-Ouest                           | 2021-03-29   |               145 | github |         145 |     1 | Ville               |       5287 |        18.914318 |                   11 |                              6 |                       208.05750 |      297.22500 |            297.22500 |                162.12273 | plus de 100 cas par million     |    5287 |
| Outremont                                | 2021-03-29   |              1149 | github |        1149 |     3 | Arrond.             |      25826 |        11.616201 |                   17 |                             32 |                        65.82514 |       94.03591 |             94.03591 |                177.00877 | entre 60 et 100 cas par million |   25826 |
| Pierrefonds–Roxboro                      | 2021-03-29   |              3554 | github |        3554 |    12 | Arrond.             |      73230 |        16.386727 |                   76 |                             85 |                       103.78260 |      148.26086 |            148.26086 |                165.81807 | plus de 100 cas par million     |   73230 |
| Plateau Mont-Royal                       | 2021-03-29   |              3963 | github |        3963 |     8 | Arrond.             |     108102 |         7.400418 |                   54 |                             74 |                        49.95282 |       71.36117 |             71.36117 |                 97.79124 | entre 60 et 100 cas par million |  108102 |
| Pointe-Claire                            | 2021-03-29   |               924 | github |         924 |     3 | Ville               |      33382 |         8.986879 |                   21 |                             15 |                        62.90815 |       89.86879 |             89.86879 |                 64.19199 | entre 60 et 100 cas par million |   33382 |
| Rivière-des-Prairies–Pointe-aux-Trembles | 2021-03-29   |              8045 | github |        8045 |    16 | Arrond.             |     114732 |        13.945543 |                  106 |                            117 |                        92.38922 |      131.98460 |            131.98460 |                145.68112 | plus de 100 cas par million     |  114732 |
| Rosemont–La Petite Patrie                | 2021-03-29   |              6257 | github |        6257 |    17 | Arrond.             |     147624 |        11.515743 |                  112 |                             74 |                        75.86842 |      108.38346 |            108.38346 |                 71.61050 | plus de 100 cas par million     |  147624 |
| Saint-Laurent                            | 2021-03-29   |              6845 | github |        6845 |    26 | Arrond.             |     105248 |        24.703557 |                  184 |                            151 |                       174.82517 |      249.75025 |            249.75025 |                204.95809 | plus de 100 cas par million     |  105248 |
| Saint-Léonard                            | 2021-03-29   |              6880 | github |        6880 |    19 | Arrond.             |      82841 |        22.935503 |                  121 |                            108 |                       146.06294 |      208.66134 |            208.66134 |                186.24318 | plus de 100 cas par million     |   82841 |
| Sainte-Anne-de-Bellevue                  | 2021-03-29   |               122 | github |         122 |     0 | Ville               |       5038 |         0.000000 |                    2 |                              2 |                        39.69829 |       56.71185 |             56.71185 |                 56.71185 | entre 20 et 60 cas par million  |    5038 |
| Senneville                               | 2021-03-29   |                22 | github |          22 |     0 | Ville               |        981 |         0.000000 |                    0 |                              0 |                         0.00000 |        0.00000 |              0.00000 |                  0.00000 | moins de 20 cas par million     |     981 |
| Sud-Ouest                                | 2021-03-29   |              3334 | github |        3334 |     8 | Arrond.             |      84299 |         9.490030 |                   48 |                             44 |                        56.94018 |       81.34311 |             81.34311 |                 74.56452 | entre 60 et 100 cas par million |   84299 |
| Territoire à confirmer                   | 2021-03-29   |              1745 | github |        1745 |     1 | NA                  |         NA |               NA |                   21 |                             10 |                              NA |             NA |              0.00000 |                  0.00000 | moins de 20 cas par million     |      NA |
| Total à Montréal                         | 2021-03-29   |            115154 | github |      115154 |   306 | NA                  |    2050053 |        14.926443 |                 2168 |                           2036 |                       105.75336 |      151.07623 |            151.07623 |                141.87787 | plus de 100 cas par million     | 2050053 |
| Verdun                                   | 2021-03-29   |              2823 | github |        2823 |     9 | Arrond.             |      72419 |        12.427678 |                   72 |                             71 |                        99.42142 |      142.03060 |            142.03060 |                140.05796 | plus de 100 cas par million     |   72419 |
| Ville-Marie                              | 2021-03-29   |              4138 | github |        4138 |     8 | Arrond.             |      95231 |         8.400626 |                   69 |                             57 |                        72.45540 |      103.50771 |            103.50771 |                 85.50637 | plus de 100 cas par million     |   95231 |
| Villeray–Saint-Michel–Parc-Extension     | 2021-03-29   |              9576 | github |        9576 |    27 | Arrond.             |     148202 |        18.218378 |                  189 |                            127 |                       127.52864 |      182.18378 |            182.18378 |                122.41979 | plus de 100 cas par million     |  148202 |
| Westmount                                | 2021-03-29   |               655 | github |         655 |     4 | Ville               |      20974 |        19.071231 |                   23 |                             11 |                       109.65958 |      156.65654 |            156.65654 |                 74.92269 | plus de 100 cas par million     |   20974 |

### Figures and maps

``` r
graph_deces_hospit_tests()
```

<img src="man/figures/README-unnamed-chunk-6-1.png" width="100%" />

``` r
graph_quebec_cas_par_region()
```

<img src="man/figures/README-unnamed-chunk-7-1.png" width="100%" />

``` r
graph_quebec_cas_par_age()
```

<img src="man/figures/README-unnamed-chunk-8-1.png" width="100%" />

``` r
graph_quebec_cas_par_age_heatmap()
```

<img src="man/figures/README-unnamed-chunk-9-1.png" width="100%" />
graph\_quebec\_cas\_par\_rls\_heatmap() generates the heatmap showing
the history of cases per capita. It runs faster if you provide it with
an already-downloaded “rls\_data” dataframe provided by get\_rls\_data()

``` r
graph_quebec_cas_par_rls_heatmap(rls_data)
```

<img src="man/figures/README-unnamed-chunk-10-1.png" width="100%" />
`carte_rls()` crée une carte montrant le nombre moyen de cas par jour
par million d’habitant durant les 7 derniers jours

``` r
carte_rls(rls_data)
```

<img src="man/figures/README-unnamed-chunk-11-1.png" width="100%" />

``` r
carte_rls_zoom_montreal(rls_data)
```

<img src="man/figures/README-unnamed-chunk-12-1.png" width="100%" />

We can also generate some charts from the estimated cases by CSS for the
previous week:

``` r
carte_css(css_last_week)
```

<img src="man/figures/README-unnamed-chunk-13-1.png" width="100%" />

``` r
graph_css_bars(css_last_week)
```

<img src="man/figures/README-unnamed-chunk-14-1.png" width="100%" />

``` r
graph_quebec_cas_par_mtl_heatmap(mtl_data)
```

<img src="man/figures/README-unnamed-chunk-15-1.png" width="100%" />

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
ggplot() + 
  geom_sf(data = shp_water, fill = "#56B4E950")+
  labs(title = "shp_water: Coastal water polyhon shapefile")
```

<img src="man/figures/README-unnamed-chunk-16-1.png" width="100%" />

The shapefile `shp_rls` shows all the RLS in Quebec after removing
water. It is derived from “Limites territoriales des réseaux locaux de
santé (RLS) en 2020”
(<https://www.donneesquebec.ca/recherche/fr/dataset/limites-territoriales/resource/a73c9996-010d-41ac-a4ba-4def322d55bf>),from
which I removed the coastal waters.

``` r
ggplot() +
  geom_sf(data= shp_rls, fill ="#E69F00B0")+
  labs(title = "shp_rls: Réseaux locaux de services shapefile")
```

<img src="man/figures/README-unnamed-chunk-17-1.png" width="100%" /> The
shapefile `shp_css` shows all the CSS (centres de services scolaires) in
Quebec after removing water. It is derived from “Centres de services
scolaires francophones (SDA)” shapefile
<https://www.donneesquebec.ca/recherche/dataset/territoires-des-commissions-scolaires-du-quebec/resource/4cd70cc8-2663-4f10-bfce-bb46f62a77da,from>
which I removed the coastal waters.

``` r
ggplot() + 
  geom_sf(data= shp_css, fill = "#E69F00B0") +
  labs(title = "shp_css: Centres de services francophones shapefile ")
```

<img src="man/figures/README-unnamed-chunk-18-1.png" width="100%" />

### coordinate reference systems (CRS)

I added references to 2 useful CRS : `quebec_lambert`and
`statistics_canada_lambert`

Quebec Lambert is defined here on
[spatialreference.org](https://spatialreference.org/ref/epsg/nad83-quebec-lambert/)
the string is ‘+proj=lcc +lat\_1=60 +lat\_2=46 +lat\_0=44 +lon\_0=-68.5
+x\_0=0 +y\_0=0 +ellps=GRS80 +datum=NAD83 +units=m +no\_defs’ and was
found
[here](https://spatialreference.org/ref/epsg/nad83-quebec-lambert/proj4/).

``` r
ggplot() + 
  geom_sf(data= shp_rls, fill = "#E69F00B0") + 
  coord_sf(crs= quebec_lambert) + 
  labs(title = "RLS with Quebec Lambert CRS")
```

<img src="man/figures/README-unnamed-chunk-19-1.png" width="100%" />
Statistics Canada Lambert is useful when mapping Canada as a whole. I
found a reference to it
[here](https://spatialreference.org/ref/epsg/3347/) and the string
‘+proj=lcc +lat\_1=49 +lat\_2=77 +lat\_0=63.390675
+lon\_0=-91.86666666666666 +x\_0=6200000 +y\_0=3000000 +ellps=GRS80
+datum=NAD83 +units=m +no\_defs’ was
[here](https://spatialreference.org/ref/epsg/3347/proj4/)

``` r
ggplot() + 
  geom_sf(data = shp_water, fill = "#56B4E950")+
  coord_sf(crs=statistics_canada_lambert)+
  labs(title = "shp_water: Coastal water polygon shapefile projected with statistics canada lambert")
```

<img src="man/figures/README-unnamed-chunk-20-1.png" width="100%" />

### Theme

`theme_simon` is my default theme for figures. I start with the default
`cowplot`theme and change the color of the axis lines and axis labels to
grey It comes with grids, with can be removed with the `nogrid()`
function.

``` r
base_plot <- get_inspq_covid19_hist() %>% 
  dplyr::filter(Nom == "Ensemble du Québec") %>% 
  ggplot()+
  geom_line( aes(x=date, y= hos_quo_tot_n))+
  #expand_limits(y = 0)
  scale_y_continuous(expand = c(0, 0))

p1 <- base_plot +
  labs(title = "no theme") 

p2 <-base_plot +
  cowplot::theme_cowplot()  + 
  labs(title = "theme_cowplot(") 


p3 <- base_plot +
  theme_simon() + 
  labs(title = "theme_simon()")

p4 <- base_plot +
  theme_simon() + nogrid() + 
  labs(title = "theme_simon() + nogrid()")

(p1 + p2) / (p3 + p4 )
```

<img src="man/figures/README-unnamed-chunk-21-1.png" width="100%" />

### Palettes

palette\_OkabeIto is a color palette that was built by higher beings to
be visible to color-blind people. I copied the code from Claus Wilke’s
`colorblindr` package because I don’t know how to import packages from
github.

``` r
palette_OkabeIto
#>        orange       skyblue   bluishgreen        yellow          blue 
#>     "#E69F00"     "#56B4E9"     "#009E73"     "#F0E442"     "#0072B2" 
#>    vermillion reddishpurple          gray 
#>     "#D55E00"     "#CC79A7"     "#999999"
```
