
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

| Date       | Regroupement     | Croisement | Nom                  | cas\_cum\_lab\_n | cas\_cum\_epi\_n | cas\_cum\_tot\_n | cas\_cum\_tot\_t | cas\_quo\_tot\_t | cas\_quo\_lab\_n | cas\_quo\_epi\_n | cas\_quo\_tot\_n | act\_cum\_tot\_n | act\_cum\_tot\_t | cas\_quo\_tot\_m | cas\_quo\_tot\_tm | ret\_cum\_tot\_n | ret\_quo\_tot\_n | dec\_cum\_tot\_n | dec\_cum\_tot\_t | dec\_quo\_tot\_t | dec\_cum\_chs\_n | dec\_cum\_rpa\_n | dec\_cum\_dom\_n | dec\_cum\_aut\_n | dec\_quo\_tot\_n | dec\_quo\_chs\_n | dec\_quo\_rpa\_n | dec\_quo\_dom\_n | dec\_quo\_aut\_n | dec\_quo\_tot\_m | dec\_quo\_tot\_tm | hos\_cum\_reg\_n | hos\_cum\_si\_n | hos\_cum\_tot\_n | hos\_cum\_tot\_t | hos\_quo\_tot\_t | hos\_quo\_reg\_n | hos\_quo\_si\_n | hos\_quo\_tot\_n | hos\_quo\_tot\_m | psi\_cum\_tes\_n | psi\_cum\_pos\_n | psi\_cum\_inf\_n | psi\_quo\_pos\_n | psi\_quo\_inf\_n | psi\_quo\_tes\_n | psi\_quo\_pos\_t | date       | type             | groupe               | cas\_totaux\_cumul | cas\_totaux\_quotidien | deces\_totaux\_quotidien |     pop |
| :--------- | :--------------- | :--------- | :------------------- | ---------------: | ---------------: | ---------------: | ---------------: | ---------------: | ---------------: | ---------------: | ---------------: | ---------------: | ---------------: | ---------------: | ----------------: | ---------------: | ---------------: | ---------------: | ---------------: | ---------------: | ---------------: | ---------------: | ---------------: | ---------------: | ---------------: | ---------------: | ---------------: | ---------------: | ---------------: | ---------------: | ----------------: | ---------------: | --------------: | ---------------: | ---------------: | ---------------: | ---------------: | --------------: | ---------------: | ---------------: | ---------------: | ---------------: | ---------------: | ---------------: | ---------------: | ---------------: | ---------------: | :--------- | :--------------- | :------------------- | -----------------: | ---------------------: | -----------------------: | ------: |
| 2020-11-20 | Groupe de région | REG02      | Ceinture de Montréal |            22622 |             1709 |            24331 |          1651.17 |             8.08 |              118 |                1 |              119 |             2147 |           145.70 |               NA |                NA |            20899 |              269 |             1018 |            69.08 |             0.14 |              579 |              220 |              151 |               68 |                2 |                1 |                1 |                0 |                0 |               NA |                NA |               NA |              NA |               NA |               NA |               NA |               NA |              NA |               NA |               NA |           378043 |            22452 |           355591 |               NA |               NA |               NA |               NA | 2020-11-20 | region\_montreal | Ceinture de Montréal |              24331 |                    119 |                        2 |      NA |
| 2020-11-20 | Groupe de région | REG03      | Autres régions       |            45364 |             2216 |            47580 |          1044.08 |             9.83 |              439 |                9 |              448 |             5854 |           128.46 |               NA |                NA |            39553 |              634 |             1433 |            31.45 |             0.07 |              658 |              376 |              311 |               88 |                3 |                1 |                2 |                0 |                0 |               NA |                NA |               NA |              NA |               NA |               NA |               NA |               NA |              NA |               NA |               NA |          1011628 |            44593 |           967035 |               NA |               NA |               NA |               NA | 2020-11-20 | region\_montreal | Autres régions       |              47580 |                    448 |                        3 |      NA |
| 2020-11-20 | Groupe de région | REG00      | Inconnu              |                3 |                0 |                3 |               NA |               NA |                0 |                0 |                0 |                0 |               NA |               NA |                NA |                3 |                0 |                0 |               NA |               NA |                0 |                0 |                0 |                0 |                0 |                0 |                0 |                0 |                0 |               NA |                NA |               NA |              NA |               NA |               NA |               NA |               NA |              NA |               NA |               NA |             5641 |              149 |             5492 |               NA |               NA |               NA |               NA | 2020-11-20 | region\_montreal | Inconnue             |                  3 |                      0 |                        0 |      NA |
| 2020-11-20 | Groupe de région | REG98      | Hors Québec          |               76 |                2 |               78 |               NA |               NA |                0 |                0 |                0 |                4 |               NA |               NA |                NA |               73 |                0 |                0 |               NA |               NA |                0 |                0 |                0 |                0 |                0 |                0 |                0 |                0 |                0 |               NA |                NA |               NA |              NA |               NA |               NA |               NA |               NA |              NA |               NA |               NA |             5363 |              223 |             5140 |               NA |               NA |               NA |               NA | 2020-11-20 | region\_montreal | Hors Québec          |                 78 |                      0 |                        0 |      NA |
| 2020-11-20 | Groupe d’âge     | 0\_9       | 0-9 ans              |             5502 |             1414 |             6916 |           773.62 |             9.40 |               79 |                5 |               84 |              847 |            94.75 |               NA |                NA |             5973 |              131 |                0 |             0.00 |             0.00 |                0 |                0 |                0 |                0 |                0 |                0 |                0 |                0 |                0 |               NA |                NA |               NA |              NA |               NA |               NA |               NA |               NA |              NA |               NA |               NA |           207979 |             4534 |           203445 |               NA |               NA |               NA |               NA | 2020-11-20 | groupe\_age      | 0 à 9 ans            |               6916 |                     84 |                        0 |  893977 |
| 2020-11-20 | Groupe d’âge     | 10\_19     | 10-19 ans            |            12477 |             1234 |            13711 |          1561.00 |            14.35 |              122 |                4 |              126 |             1426 |           162.35 |               NA |                NA |            12119 |              244 |                1 |             0.11 |             0.00 |                0 |                0 |                1 |                0 |                0 |                0 |                0 |                0 |                0 |               NA |                NA |               NA |              NA |               NA |               NA |               NA |               NA |              NA |               NA |               NA |           217814 |            10759 |           207055 |               NA |               NA |               NA |               NA | 2020-11-20 | groupe\_age      | 10 à 19 ans          |              13711 |                    126 |                        0 |  878347 |
| 2020-11-20 | Groupe d’âge     | 20\_29     | 20-29 ans            |            19288 |             1238 |            20526 |          1943.31 |            11.17 |              118 |                0 |              118 |             1336 |           126.49 |               NA |                NA |            18941 |              167 |                3 |             0.28 |             0.00 |                0 |                0 |                3 |                0 |                0 |                0 |                0 |                0 |                0 |               NA |                NA |               NA |              NA |               NA |               NA |               NA |               NA |              NA |               NA |               NA |           269453 |            17240 |           252213 |               NA |               NA |               NA |               NA | 2020-11-20 | groupe\_age      | 20 à 29 ans          |              20526 |                    118 |                        0 | 1056242 |
| 2020-11-20 | Groupe d’âge     | 30\_39     | 30-39 ans            |            16895 |              966 |            17861 |          1600.58 |            10.31 |              113 |                2 |              115 |             1392 |           124.74 |               NA |                NA |            16226 |              188 |                7 |             0.63 |             0.00 |                2 |                0 |                5 |                0 |                0 |                0 |                0 |                0 |                0 |               NA |                NA |               NA |              NA |               NA |               NA |               NA |               NA |              NA |               NA |               NA |           283577 |            15139 |           268438 |               NA |               NA |               NA |               NA | 2020-11-20 | groupe\_age      | 30 à 39 ans          |              17861 |                    115 |                        0 | 1115906 |
| 2020-11-20 | Groupe d’âge     | 40\_49     | 40-49 ans            |            18303 |              986 |            19289 |          1752.22 |             9.63 |              104 |                2 |              106 |             1424 |           129.36 |               NA |                NA |            17616 |              204 |               26 |             2.36 |             0.00 |               11 |                1 |               13 |                1 |                0 |                0 |                0 |                0 |                0 |               NA |                NA |               NA |              NA |               NA |               NA |               NA |               NA |              NA |               NA |               NA |           260050 |            16528 |           243522 |               NA |               NA |               NA |               NA | 2020-11-20 | groupe\_age      | 40 à 49 ans          |              19289 |                    106 |                        0 | 1100826 |
| 2020-11-20 | Groupe d’âge     | 50\_59     | 50-59 ans            |            16486 |              872 |            17358 |          1468.46 |             9.31 |              109 |                1 |              110 |             1351 |           114.29 |               NA |                NA |            15671 |              183 |              124 |            10.49 |             0.00 |               67 |                1 |               49 |                7 |                0 |                0 |                0 |                0 |                0 |               NA |                NA |               NA |              NA |               NA |               NA |               NA |               NA |              NA |               NA |               NA |           225962 |            15033 |           210929 |               NA |               NA |               NA |               NA | 2020-11-20 | groupe\_age      | 50 à 59 ans          |              17358 |                    110 |                        0 | 1182044 |
| 2020-11-20 | Groupe d’âge     | 60\_69     | 60-69 ans            |            10358 |              463 |            10821 |           942.86 |             6.01 |               69 |                0 |               69 |              952 |            82.95 |               NA |                NA |             9343 |              110 |              399 |            34.77 |             0.00 |              237 |               24 |              114 |               24 |                0 |                0 |                0 |                0 |                0 |               NA |                NA |               NA |              NA |               NA |               NA |               NA |               NA |              NA |               NA |               NA |           185340 |             9600 |           175740 |               NA |               NA |               NA |               NA | 2020-11-20 | groupe\_age      | 60 à 69 ans          |              10821 |                     69 |                        0 | 1147664 |
| 2020-11-20 | Groupe d’âge     | 70\_79     | 70-79 ans            |             7839 |              191 |             8030 |          1065.41 |             5.71 |               43 |                0 |               43 |              739 |            98.05 |               NA |                NA |             5941 |               60 |             1258 |           166.91 |             0.00 |              759 |              137 |              292 |               70 |                0 |                0 |                0 |                0 |                0 |               NA |                NA |               NA |              NA |               NA |               NA |               NA |               NA |              NA |               NA |               NA |           128875 |             7045 |           121830 |               NA |               NA |               NA |               NA | 2020-11-20 | groupe\_age      | 70 à 79 ans          |               8030 |                     43 |                        0 |  753700 |
| 2020-11-20 | Groupe d’âge     | 80\_89     | 80-89 ans            |             9625 |              252 |             9877 |          3014.27 |            20.14 |               66 |                0 |               66 |             1221 |           372.63 |               NA |                NA |             5776 |               55 |             2698 |           823.38 |             0.92 |             1746 |              523 |              295 |              134 |                3 |                1 |                2 |                0 |                0 |               NA |                NA |               NA |              NA |               NA |               NA |               NA |               NA |              NA |               NA |               NA |            83542 |             8612 |            74930 |               NA |               NA |               NA |               NA | 2020-11-20 | groupe\_age      | 80 à 89 ans          |               9877 |                     66 |                        3 |  327675 |
| 2020-11-20 | Groupe d’âge     | 90\_       | 90 ans et plus       |             6207 |              216 |             6423 |          7769.44 |            48.39 |               40 |                0 |               40 |              657 |           794.73 |               NA |                NA |             3498 |               24 |             2238 |          2707.15 |             2.42 |             1538 |              480 |              110 |              110 |                2 |                1 |                1 |                0 |                0 |               NA |                NA |               NA |              NA |               NA |               NA |               NA |               NA |              NA |               NA |               NA |            36809 |             6224 |            30585 |               NA |               NA |               NA |               NA | 2020-11-20 | groupe\_age      | 90 ans et +          |               6423 |                     40 |                        2 |   82670 |
| 2020-11-20 | Groupe d’âge     | INC        | Inconnu              |               38 |               35 |               73 |               NA |               NA |                0 |                0 |                0 |                3 |               NA |               NA |                NA |               69 |                0 |                0 |               NA |               NA |                0 |                0 |                0 |                0 |                0 |                0 |                0 |                0 |                0 |               NA |                NA |               NA |              NA |               NA |               NA |               NA |               NA |              NA |               NA |               NA |           201802 |            12182 |           189620 |               NA |               NA |               NA |               NA | 2020-11-20 | groupe\_age      | Âge inconnu          |                 73 |                      0 |                        0 |      NA |
| 2020-11-20 | Groupe d’âge     | TOT        | Total                |           123018 |             7867 |           130885 |          1532.78 |            10.27 |              863 |               14 |              877 |            11348 |           132.89 |               NA |                NA |           111173 |             1366 |             6754 |            79.10 |             0.06 |             4360 |             1166 |              882 |              346 |                5 |                2 |                3 |                0 |                0 |               NA |                NA |               NA |              NA |               NA |               NA |               NA |               NA |              NA |               NA |               NA |          2101203 |           122896 |          1978307 |               NA |               NA |               NA |               NA | 2020-11-20 | groupe\_age      | Total                |             130885 |                    877 |                        5 | 8390499 |
| 2020-11-20 | Sexe             | MASC       | Masculin             |            55135 |             3975 |            59110 |          1385.21 |             9.23 |              388 |                6 |              394 |             5126 |           120.12 |               NA |                NA |            50194 |              672 |             3074 |            72.04 |             0.02 |             1876 |              509 |              522 |              167 |                1 |                0 |                1 |                0 |                0 |               NA |                NA |               NA |              NA |               NA |               NA |               NA |               NA |              NA |               NA |               NA |           935710 |            54838 |           880872 |               NA |               NA |               NA |               NA | 2020-11-20 | sexe             | Masculin             |              59110 |                    394 |                        1 |      NA |
| 2020-11-20 | Sexe             | FEM        | Féminin              |            67776 |             3891 |            71667 |          1677.66 |            11.31 |              475 |                8 |              483 |             6219 |           145.58 |               NA |                NA |            60875 |              693 |             3679 |            86.12 |             0.09 |             2484 |              656 |              360 |              179 |                4 |                2 |                2 |                0 |                0 |               NA |                NA |               NA |              NA |               NA |               NA |               NA |               NA |              NA |               NA |               NA |          1160627 |            67777 |          1092850 |               NA |               NA |               NA |               NA | 2020-11-20 | sexe             | Féminin              |              71667 |                    483 |                        4 |      NA |
| 2020-11-20 | Sexe             | INC        | Inconnu              |              107 |                1 |              108 |               NA |               NA |                0 |                0 |                0 |                3 |               NA |               NA |                NA |              104 |                1 |                1 |               NA |               NA |                0 |                1 |                0 |                0 |                0 |                0 |                0 |                0 |                0 |               NA |                NA |               NA |              NA |               NA |               NA |               NA |               NA |              NA |               NA |               NA |             4866 |              281 |             4585 |               NA |               NA |               NA |               NA | 2020-11-20 | sexe             | Sexe inconnu         |                108 |                      0 |                        0 |      NA |
| 2020-11-20 | Sexe             | TOT        | Total                |           123018 |             7867 |           130885 |          1532.78 |            10.27 |              863 |               14 |              877 |            11348 |           132.89 |               NA |                NA |           111173 |             1366 |             6754 |            79.10 |             0.06 |             4360 |             1166 |              882 |              346 |                5 |                2 |                3 |                0 |                0 |               NA |                NA |               NA |              NA |               NA |               NA |               NA |               NA |              NA |               NA |               NA |          2101203 |           122896 |          1978307 |               NA |               NA |               NA |               NA | 2020-11-20 | sexe             | Total                |             130885 |                    877 |                        5 |      NA |

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
| :--------- | ------: | --------------: | --: | ---------: |
| 2020-11-01 |     418 |              NA |  81 |      17057 |
| 2020-11-02 |     441 |              NA |  85 |      19597 |
| 2020-11-03 |     458 |              NA |  81 |      25563 |
| 2020-11-04 |     456 |              NA |  82 |      28925 |
| 2020-11-05 |     462 |              NA |  77 |      29776 |
| 2020-11-06 |     445 |              NA |  78 |      26951 |
| 2020-11-07 |     450 |              NA |  77 |      21884 |
| 2020-11-08 |     464 |              NA |  76 |      19848 |
| 2020-11-09 |     452 |              NA |  82 |      21851 |
| 2020-11-10 |     489 |              NA |  84 |      28078 |
| 2020-11-11 |     497 |              NA |  86 |      28916 |
| 2020-11-12 |     498 |              NA |  85 |      29846 |
| 2020-11-13 |     501 |              NA |  82 |      29512 |
| 2020-11-14 |     498 |              NA |  89 |      26864 |
| 2020-11-15 |     504 |              NA |  87 |      21685 |
| 2020-11-16 |     538 |              NA | 100 |      23289 |
| 2020-11-17 |     552 |              NA | 100 |      30045 |
| 2020-11-18 |     550 |              NA | 101 |      33422 |
| 2020-11-19 |     528 |              NA |  96 |      30294 |
| 2020-11-20 |     547 |              NA |  99 |         NA |

#### get\_inspq\_manual\_data\_tableau\_accueil()

get\_inspq\_manual\_data\_tableau\_accueil() retourne les chiffres
utilisés dans le haut de la page de données covid19 de l’inspq. ça
balance pas toujours avec l’output des 2 fonctions précédentes.

``` r
get_inspq_manual_data_tableau_accueil()   %>%  knitr::kable()
```

| cas    | deces | hospit | soins | gueris | analyses | type      |
| :----- | :---- | -----: | ----: | :----- | :------- | :-------- |
| 130888 | 6806  |    646 |    99 | 112734 | 30294    | cumulatif |
| 1189   | 32    |     22 |     3 | 1408   | NA       | quotidien |

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

| RSS                                | RLS                                             | date\_report | cumulative\_cases | source  | fix\_cummin | cases | shortname\_rls                    | Population | cases\_per\_100k | cases\_last\_7\_days | previous\_cases\_last\_7\_days | cases\_last\_7\_days\_per\_100k | RLS\_code | cases\_per\_1M | last\_cases\_per\_1M | previous\_cases\_per\_1M | color\_per\_pop                 |    pop | RLS\_petit\_nom                       |
| :--------------------------------- | :---------------------------------------------- | :----------- | ----------------: | :------ | ----------: | ----: | :-------------------------------- | ---------: | ---------------: | -------------------: | -----------------------------: | ------------------------------: | :-------- | -------------: | -------------------: | -----------------------: | :------------------------------ | -----: | :------------------------------------ |
| 14 - Lanaudière                    | 1411 - RLS de Lanaudière-Nord                   | 2020-11-21   |              4852 | current |        4852 |    62 | Lanaudière-Nord                   |     223099 |        27.790353 |                  514 |                            746 |                       230.39099 | 1411      |      329.12999 |            329.12999 |                477.68672 | plus de 100 cas par million     | 223099 | 1411 - Lanaudière-Nord                |
| 14 - Lanaudière                    | 1412 - RLS de Lanaudière-Sud                    | 2020-11-21   |              5251 | current |        5251 |    48 | Lanaudière-Sud                    |     296993 |        16.161997 |                  308 |                            404 |                       103.70615 | 1412      |      148.15164 |            148.15164 |                194.32877 | plus de 100 cas par million     | 296993 | 1412 - Lanaudière-Sud                 |
| 15 - Laurentides                   | 1511 - RLS d’Antoine-Labelle                    | 2020-11-21   |               130 | current |         130 |     1 | d’Antoine-Labelle                 |      35580 |         2.810568 |                   18 |                             17 |                        50.59022 | 1511      |       72.27174 |             72.27174 |                 68.25665 | entre 60 et 100 cas par million |  35580 | 1511 - d’Antoine-Labelle              |
| 15 - Laurentides                   | 1512 - RLS des Laurentides                      | 2020-11-21   |               319 | current |         319 |     7 | des Laurentides                   |      48016 |        14.578474 |                   15 |                             28 |                        31.23959 | 1512      |       44.62798 |             44.62798 |                 83.30556 | entre 20 et 60 cas par million  |  48016 | 1512 - Laurentides                    |
| 15 - Laurentides                   | 1513 - RLS des Pays-d’en-Haut                   | 2020-11-21   |               408 | current |         408 |     1 | des Pays-d’en-Haut                |      44362 |         2.254182 |                   14 |                             18 |                        31.55854 | 1513      |       45.08363 |             45.08363 |                 57.96467 | entre 20 et 60 cas par million  |  44362 | 1513 - Pays-d’en-Haut                 |
| 15 - Laurentides                   | 1514 - RLS d’Argenteuil                         | 2020-11-21   |               259 | current |         259 |     2 | d’Argenteuil                      |      33422 |         5.984082 |                    4 |                              6 |                        11.96816 | 1514      |       17.09738 |             17.09738 |                 25.64607 | moins de 20 cas par million     |  33422 | 1514 - d’Argenteuil                   |
| 15 - Laurentides                   | 1515 - RLS de Deux-Montagnes - Mirabel-Sud      | 2020-11-21   |              1624 | current |        1624 |     5 | Deux-Montagnes - Mirabel-Sud      |     124641 |         4.011521 |                   60 |                             96 |                        48.13825 | 1515      |       68.76893 |             68.76893 |                110.03029 | entre 60 et 100 cas par million | 124641 | 1515 - Deux-Montagnes - Mirabel-Sud   |
| 15 - Laurentides                   | 1516 - RLS de la Rivière-du-Nord - Mirabel-Nord | 2020-11-21   |              2143 | current |        2143 |    12 | la Rivière-du-Nord - Mirabel-Nord |     177517 |         6.759916 |                   73 |                            144 |                        41.12282 | 1516      |       58.74689 |             58.74689 |                115.88427 | entre 20 et 60 cas par million  | 177517 | 1516 - Rivière-du-Nord - Mirabel-Nord |
| 15 - Laurentides                   | 1517 - RLS de Thérèse-De Blainville             | 2020-11-21   |              2660 | current |        2660 |    20 | Thérèse-De Blainville             |     163430 |        12.237655 |                  138 |                            197 |                        84.43982 | 1517      |      120.62832 |            120.62832 |                172.20129 | plus de 100 cas par million     | 163430 | 1517 - Thérèse-De Blainville          |
| 16 - Montérégie                    | 1611 - RLS de Champlain                         | 2020-11-21   |              3678 | current |        3678 |    19 | Champlain                         |     225442 |         8.427888 |                  151 |                            173 |                        66.97953 | 1611      |       95.68505 |             95.68505 |                109.62592 | entre 60 et 100 cas par million | 225442 | 1611 - Champlain                      |
| 16 - Montérégie                    | 1612 - RLS du Haut-Richelieu - Rouville         | 2020-11-21   |              2162 | current |        2162 |    22 | du Haut-Richelieu - Rouville      |     195297 |        11.264894 |                  156 |                            160 |                        79.87834 | 1612      |      114.11191 |            114.11191 |                117.03786 | plus de 100 cas par million     | 195297 | 1612 - Haut-Richelieu - Rouville      |
| 16 - Montérégie                    | 1621 - RLS Pierre-Boucher                       | 2020-11-21   |              3985 | current |        3985 |    15 | Pierre-Boucher                    |     262440 |         5.715592 |                  158 |                            181 |                        60.20424 | 1621      |       86.00605 |             86.00605 |                 98.52592 | entre 60 et 100 cas par million | 262440 | 1621 - Pierre-Boucher                 |
| 16 - Montérégie                    | 1622 - RLS de Richelieu-Yamaska                 | 2020-11-21   |              3080 | current |        3080 |    31 | Richelieu-Yamaska                 |     220957 |        14.029879 |                  249 |                            310 |                       112.69161 | 1622      |      160.98801 |            160.98801 |                200.42684 | plus de 100 cas par million     | 220957 | 1622 - Richelieu-Yamaska              |
| 16 - Montérégie                    | 1623 - RLS Pierre-De Saurel                     | 2020-11-21   |               313 | current |         313 |    18 | Pierre-De Saurel                  |      51371 |        35.039225 |                   72 |                             39 |                       140.15690 | 1623      |      200.22414 |            200.22414 |                108.45474 | plus de 100 cas par million     |  51371 | 1623 - Pierre-De Saurel               |
| 16 - Montérégie                    | 1631 - RLS de Vaudreuil-Soulanges               | 2020-11-21   |              1475 | current |        1475 |     9 | Vaudreuil-Soulanges               |     160002 |         5.624930 |                   73 |                             76 |                        45.62443 | 1631      |       65.17776 |             65.17776 |                 67.85629 | entre 60 et 100 cas par million | 160002 | 1631 - Vaudreuil-Soulanges            |
| 16 - Montérégie                    | 1632 - RLS du Suroît                            | 2020-11-21   |               939 | current |         939 |     1 | du Suroît                         |      60523 |         1.652264 |                   14 |                             15 |                        23.13170 | 1632      |       33.04529 |             33.04529 |                 35.40567 | entre 20 et 60 cas par million  |  60523 | 1632 - Suroît                         |
| 16 - Montérégie                    | 1633 - RLS du Haut-Saint-Laurent                | 2020-11-21   |               210 | current |         210 |     0 | du Haut-Saint-Laurent             |      24346 |         0.000000 |                    5 |                             10 |                        20.53725 | 1633      |       29.33894 |             29.33894 |                 58.67787 | entre 20 et 60 cas par million  |  24346 | 1633 - Haut-Saint-Laurent             |
| 16 - Montérégie                    | 1634 - RLS de Jardins-Roussillon                | 2020-11-21   |              2760 | current |        2760 |    14 | Jardins-Roussillon                |     232373 |         6.024796 |                  124 |                            131 |                        53.36248 | 1634      |       76.23212 |             76.23212 |                 80.53554 | entre 60 et 100 cas par million | 232373 | 1634 - Jardins-Roussillon             |
| 17 - Nunavik                       | 1701 - Nunavik                                  | 2020-11-21   |                29 | current |          29 |     0 | NA                                |      14260 |         0.000000 |                    0 |                              1 |                         0.00000 | 1701      |        0.00000 |              0.00000 |                 10.01803 | moins de 20 cas par million     |  14260 | 1701 - Nunavik                        |
| 18 - Terres-Cries-de-la-Baie-James | 1801 - Terres-Cries-de-la-Baie-James            | 2020-11-21   |                16 | current |          16 |     0 | NA                                |      18385 |         0.000000 |                    0 |                              1 |                         0.00000 | 1801      |        0.00000 |              0.00000 |                  7.77031 | moins de 20 cas par million     |  18385 | 1801 - Terres-Cries-de-la-Baie-James  |

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

| CD\_CS | NOM\_CS                           | SITE\_WEB                    |  SUPRF\_KM2 |  PERMT\_KM | NOM\_VERSN | dummy | dummy2 | date\_report | cases\_last\_7\_days | previous\_cases\_last\_7\_days | Population | dailycases\_per\_1M\_avg\_7\_days | previous\_dailycases\_per\_1M\_avg\_7\_days | color\_per\_pop                 | cases\_last\_7\_days\_per\_100k | NOM\_CS\_petit\_nom        |
| :----- | :-------------------------------- | :--------------------------- | ----------: | ---------: | :--------- | ----: | -----: | :----------- | -------------------: | -----------------------------: | ---------: | --------------------------------: | ------------------------------------------: | :------------------------------ | ------------------------------: | :------------------------- |
| 731000 | CSS de Charlevoix                 | www.cscharlevoix.qc.ca       |   7066.5687 |  403.05820 | V2020-07   |     1 |      1 | 2020-11-21   |                   20 |                     35.8337417 |      28295 |                             100.5 |                                       180.9 | plus de 100 cas par million     |                            70.4 | Charlevoix                 |
| 821000 | CSS de la Côte-du-Sud             | <http://www.cscotesud.qc.ca> |   5959.9203 |  418.42028 | V2020-07   |     1 |      1 | 2020-11-21   |                   46 |                     75.7430869 |      70237 |                              93.7 |                                       154.1 | entre 60 et 100 cas par million |                            65.6 | Côte-du-Sud                |
| 852000 | CSS de la Rivière-du-Nord         | <http://www2.csrdn.qc.ca/>   |   2049.6010 |  322.44185 | V2020-07   |     1 |      1 | 2020-11-21   |                   75 |                    146.5053108 |     190425 |                              56.6 |                                       109.9 | entre 20 et 60 cas par million  |                            39.6 | Rivière-du-Nord            |
| 772000 | CSS des Portages-de-l’Outaouais   | www.cspo.qc.ca               |   1382.6493 |  195.52992 | V2020-07   |     1 |      1 | 2020-11-21   |                  127 |                    117.5015579 |     153423 |                             118.5 |                                       109.4 | plus de 100 cas par million     |                            82.9 | Portages-de-l’Outaouais    |
| 724000 | CSS De La Jonquière               | www.csjonquiere.qc.ca        |   1001.8302 |  169.10289 | V2020-07   |     1 |      1 | 2020-11-21   |                  263 |                    211.8884710 |      66718 |                             562.8 |                                       453.7 | plus de 100 cas par million     |                           394.0 | De La Jonquière            |
| 773000 | CSS au Coeur-des-Vallées          | www.cscv.qc.ca               |   3458.9423 |  322.35632 | V2020-07   |     1 |      1 | 2020-11-21   |                   27 |                     20.6384571 |      53658 |                              70.6 |                                        54.9 | entre 60 et 100 cas par million |                            49.5 | au Coeur-des-Vallées       |
| 774000 | CSS des Hauts-Bois-de-l’Outaouais | www.cshbo.qc.ca              |  28080.7957 | 1363.04393 | V2020-07   |     1 |      1 | 2020-11-21   |                   10 |                      9.9283405 |      33868 |                              41.9 |                                        41.9 | entre 20 et 60 cas par million  |                            29.3 | Hauts-Bois-de-l’Outaouais  |
| 791000 | CSS de l’Estuaire                 | www.csestuaire.qc.ca         |  57965.0122 | 1241.96584 | V2020-07   |     1 |      1 | 2020-11-21   |                   13 |                      4.0006899 |      41543 |                              44.7 |                                        13.8 | entre 20 et 60 cas par million  |                            31.3 | l’Estuaire                 |
| 782000 | CSS de Rouyn-Noranda              | www.csrn.qc.ca               |   6073.5950 |  416.44383 | V2020-07   |     1 |      1 | 2020-11-21   |                    1 |                      0.0000407 |      41784 |                               3.4 |                                         0.0 | moins de 20 cas par million     |                             2.4 | Rouyn-Noranda              |
| 801000 | CSS de la Baie-James              | <http://csbj.qc.ca/>         | 343574.3467 | 5631.60890 | V2020-07   |     1 |      1 | 2020-11-21   |                   20 |                     10.9999294 |      16151 |                             176.9 |                                        97.3 | plus de 100 cas par million     |                           123.8 | Baie-James                 |
| 742000 | CSS de l’Énergie                  | www.csenergie.qc.ca          |  37903.5713 | 1189.64144 | V2020-07   |     1 |      1 | 2020-11-21   |                   98 |                    122.5649603 |      97133 |                             144.1 |                                       180.3 | plus de 100 cas par million     |                           100.9 | l’Énergie                  |
| 762000 | CSS de Montréal                   | www.csdm.qc.ca               |    163.9897 |  112.21365 | V2020-07   |     1 |      1 | 2020-11-21   |                  936 |                   1034.7413942 |    1009727 |                             132.5 |                                       146.4 | plus de 100 cas par million     |                            92.7 | Montréal                   |
| 763000 | CSS Marguerite-Bourgeoys          | www.csmb.qc.ca               |    356.2161 |  133.05741 | V2020-07   |     1 |      1 | 2020-11-21   |                  591 |                    684.4379081 |     611365 |                             138.1 |                                       159.9 | plus de 100 cas par million     |                            96.7 | Marguerite-Bourgeoys       |
| 869000 | CSS des Trois-Lacs                | www.cstrois-lacs.qc.ca       |   1023.8689 |  154.98997 | V2020-07   |     1 |      1 | 2020-11-21   |                   73 |                     75.9996790 |     147799 |                              70.6 |                                        73.5 | entre 60 et 100 cas par million |                            49.4 | Trois-Lacs                 |
| 823000 | CSS de la Beauce-Etchemin         | www.csbe.qc.ca               |   6202.0129 |  542.92776 | V2020-07   |     1 |      1 | 2020-11-21   |                  147 |                    185.5639364 |     123821 |                             169.8 |                                       214.1 | plus de 100 cas par million     |                           118.9 | Beauce-Etchemin            |
| 868000 | CSS de la Vallée-des-Tisserands   | www.csvt.qc.ca               |   1847.3375 |  219.29223 | V2020-07   |     1 |      1 | 2020-11-21   |                   23 |                     29.3088132 |      86081 |                              38.3 |                                        48.6 | entre 20 et 60 cas par million  |                            26.8 | Vallée-des-Tisserands      |
| 854000 | CSS Pierre-Neveu                  | www.cspn.qc.ca               |  16291.9939 |  859.45936 | V2020-07   |     1 |      1 | 2020-11-21   |                   18 |                     16.9999125 |      35249 |                              72.9 |                                        68.9 | entre 60 et 100 cas par million |                            51.1 | Pierre-Neveu               |
| 714000 | CSS de Kamouraska-Rivière-du-Loup | www.cskamloup.qc.ca          |   5054.5614 |  413.10309 | V2020-07   |     1 |      1 | 2020-11-21   |                    3 |                      6.7359175 |      55614 |                               7.6 |                                        17.3 | moins de 20 cas par million     |                             5.3 | Kamouraska-Rivière-du-Loup |
| 853000 | CSS des Laurentides               | www.cslaurentides.qc.ca      |   3970.8926 |  362.47283 | V2020-07   |     1 |      1 | 2020-11-21   |                   39 |                     59.9032215 |      92025 |                              60.0 |                                        93.0 | entre 60 et 100 cas par million |                            42.0 | Laurentides                |
| 831000 | CSS de Laval                      | www.cslaval.qc.ca            |    266.9471 |   83.47677 | V2020-07   |     1 |      1 | 2020-11-21   |                  521 |                    551.0000000 |     418557 |                             177.8 |                                       188.1 | plus de 100 cas par million     |                           124.5 | Laval                      |

### Figures and maps

``` r
graph_deces_hospit_tests()
```

<img src="man/figures/README-unnamed-chunk-5-1.png" width="100%" />

``` r
graph_quebec_cas_par_region()
```

<img src="man/figures/README-unnamed-chunk-6-1.png" width="100%" />

``` r
graph_quebec_cas_par_age()
```

<img src="man/figures/README-unnamed-chunk-7-1.png" width="100%" />

``` r
graph_quebec_cas_par_age_heatmap()
```

<img src="man/figures/README-unnamed-chunk-8-1.png" width="100%" />
graph\_quebec\_cas\_par\_rls\_heatmap() generates the heatmap showing
the history of cases per capita. It runs faster if you provide it with
an already-downloaded “rls\_data” dataframe provided by get\_rls\_data()

``` r
graph_quebec_cas_par_rls_heatmap(rls_data)
```

<img src="man/figures/README-unnamed-chunk-9-1.png" width="100%" />
`carte_rls()` crée une carte montrant le nombre moyen de cas par jour
par million d’habitant durant les 7 derniers jours

``` r
carte_rls(rls_data)
```

<img src="man/figures/README-unnamed-chunk-10-1.png" width="100%" />

``` r
carte_rls_zoom_montreal(rls_data)
```

<img src="man/figures/README-unnamed-chunk-11-1.png" width="100%" />

We can also generate some charts from the estimated cases by CSS for the
previous week:

``` r
carte_css(css_last_week)
```

<img src="man/figures/README-unnamed-chunk-12-1.png" width="100%" />

``` r
graph_css_bars(css_last_week)
```

<img src="man/figures/README-unnamed-chunk-13-1.png" width="100%" />

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

<img src="man/figures/README-unnamed-chunk-14-1.png" width="100%" />

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

<img src="man/figures/README-unnamed-chunk-15-1.png" width="100%" /> The
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

<img src="man/figures/README-unnamed-chunk-16-1.png" width="100%" />

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

<img src="man/figures/README-unnamed-chunk-17-1.png" width="100%" />
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

<img src="man/figures/README-unnamed-chunk-18-1.png" width="100%" />

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

<img src="man/figures/README-unnamed-chunk-19-1.png" width="100%" />

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
