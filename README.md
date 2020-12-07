
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
| 2020-12-05 | Groupe de région | REG02      | Ceinture de Montréal |            25715 |             1730 |            27445 |          1862.49 |             8.96 |              129 |                3 |              132 |             2125 |           144.21 |               NA |                NA |            23952 |              185 |             1099 |            74.58 |             0.07 |              629 |              231 |              170 |               69 |                1 |                1 |                0 |                0 |                0 |               NA |                NA |               NA |              NA |               NA |               NA |               NA |               NA |              NA |               NA |               NA |           401205 |            25410 |           375795 |               NA |               NA |               NA |               NA | 2020-12-05 | region\_montreal | Ceinture de Montréal |              27445 |                    132 |                        1 |      NA |
| 2020-12-05 | Groupe de région | REG03      | Autres régions       |            55641 |             2378 |            58019 |          1273.15 |            12.49 |              551 |               18 |              569 |             7033 |           154.33 |               NA |                NA |            48351 |              606 |             1703 |            37.37 |             0.15 |              744 |              476 |              376 |              107 |                7 |                6 |                1 |                0 |                0 |               NA |                NA |               NA |              NA |               NA |               NA |               NA |               NA |              NA |               NA |               NA |          1092060 |            55038 |          1037022 |               NA |               NA |               NA |               NA | 2020-12-05 | region\_montreal | Autres régions       |              58019 |                    569 |                        7 |      NA |
| 2020-12-05 | Groupe de région | REG00      | Inconnu              |                3 |                0 |                3 |               NA |               NA |                0 |                0 |                0 |                0 |               NA |               NA |                NA |                3 |                0 |                0 |               NA |               NA |                0 |                0 |                0 |                0 |                0 |                0 |                0 |                0 |                0 |               NA |                NA |               NA |              NA |               NA |               NA |               NA |               NA |              NA |               NA |               NA |             5810 |              165 |             5645 |               NA |               NA |               NA |               NA | 2020-12-05 | region\_montreal | Inconnue             |                  3 |                      0 |                        0 |      NA |
| 2020-12-05 | Groupe de région | REG98      | Hors Québec          |              124 |                2 |              126 |               NA |               NA |                1 |                0 |                1 |               17 |               NA |               NA |                NA |              108 |                3 |                0 |               NA |               NA |                0 |                0 |                0 |                0 |                0 |                0 |                0 |                0 |                0 |               NA |                NA |               NA |              NA |               NA |               NA |               NA |               NA |              NA |               NA |               NA |             5589 |              253 |             5336 |               NA |               NA |               NA |               NA | 2020-12-05 | region\_montreal | Hors Québec          |                126 |                      1 |                        0 |      NA |
| 2020-12-05 | Groupe d’âge     | 0\_9       | 0-9 ans              |             7186 |             1480 |             8666 |           969.38 |            12.08 |              104 |                4 |              108 |             1112 |           124.39 |               NA |                NA |             7449 |               89 |                0 |             0.00 |             0.00 |                0 |                0 |                0 |                0 |                0 |                0 |                0 |                0 |                0 |               NA |                NA |               NA |              NA |               NA |               NA |               NA |               NA |              NA |               NA |               NA |           224649 |             5929 |           218720 |               NA |               NA |               NA |               NA | 2020-12-05 | groupe\_age      | 0 à 9 ans            |               8666 |                    108 |                        0 |  893977 |
| 2020-12-05 | Groupe d’âge     | 10\_19     | 10-19 ans            |            15091 |             1263 |            16354 |          1861.90 |            20.15 |              175 |                2 |              177 |             1537 |           174.99 |               NA |                NA |            14642 |              152 |                1 |             0.11 |             0.00 |                0 |                0 |                1 |                0 |                0 |                0 |                0 |                0 |                0 |               NA |                NA |               NA |              NA |               NA |               NA |               NA |               NA |              NA |               NA |               NA |           235807 |            13032 |           222775 |               NA |               NA |               NA |               NA | 2020-12-05 | groupe\_age      | 10 à 19 ans          |              16354 |                    177 |                        0 |  878347 |
| 2020-12-05 | Groupe d’âge     | 20\_29     | 20-29 ans            |            22247 |             1274 |            23521 |          2226.87 |            17.80 |              184 |                4 |              188 |             1856 |           175.72 |               NA |                NA |            21412 |              159 |                3 |             0.28 |             0.00 |                0 |                0 |                3 |                0 |                0 |                0 |                0 |                0 |                0 |               NA |                NA |               NA |              NA |               NA |               NA |               NA |               NA |              NA |               NA |               NA |           286774 |            19881 |           266893 |               NA |               NA |               NA |               NA | 2020-12-05 | groupe\_age      | 20 à 29 ans          |              23521 |                    188 |                        0 | 1056242 |
| 2020-12-05 | Groupe d’âge     | 30\_39     | 30-39 ans            |            19691 |             1003 |            20694 |          1854.46 |            15.86 |              173 |                4 |              177 |             1778 |           159.33 |               NA |                NA |            18665 |              175 |                8 |             0.72 |             0.00 |                2 |                0 |                5 |                1 |                0 |                0 |                0 |                0 |                0 |               NA |                NA |               NA |              NA |               NA |               NA |               NA |               NA |              NA |               NA |               NA |           302500 |            17569 |           284931 |               NA |               NA |               NA |               NA | 2020-12-05 | groupe\_age      | 30 à 39 ans          |              20694 |                    177 |                        0 | 1115906 |
| 2020-12-05 | Groupe d’âge     | 40\_49     | 40-49 ans            |            21260 |             1024 |            22284 |          2024.29 |            17.08 |              182 |                6 |              188 |             1859 |           168.87 |               NA |                NA |            20154 |              216 |               27 |             2.45 |             0.00 |               11 |                2 |               13 |                1 |                0 |                0 |                0 |                0 |                0 |               NA |                NA |               NA |              NA |               NA |               NA |               NA |               NA |              NA |               NA |               NA |           277159 |            19188 |           257971 |               NA |               NA |               NA |               NA | 2020-12-05 | groupe\_age      | 40 à 49 ans          |              22284 |                    188 |                        0 | 1100826 |
| 2020-12-05 | Groupe d’âge     | 50\_59     | 50-59 ans            |            19099 |              885 |            19984 |          1690.62 |            13.28 |              155 |                2 |              157 |             1670 |           141.28 |               NA |                NA |            17953 |              189 |              134 |            11.34 |             0.00 |               68 |                1 |               58 |                7 |                0 |                0 |                0 |                0 |                0 |               NA |                NA |               NA |              NA |               NA |               NA |               NA |               NA |              NA |               NA |               NA |           241406 |            17403 |           224003 |               NA |               NA |               NA |               NA | 2020-12-05 | groupe\_age      | 50 à 59 ans          |              19984 |                    157 |                        0 | 1182044 |
| 2020-12-05 | Groupe d’âge     | 60\_69     | 60-69 ans            |            11984 |              471 |            12455 |          1085.24 |             8.80 |              101 |                0 |              101 |             1123 |            97.85 |               NA |                NA |            10758 |              101 |              428 |            37.29 |             0.00 |              245 |               27 |              130 |               26 |                0 |                0 |                0 |                0 |                0 |               NA |                NA |               NA |              NA |               NA |               NA |               NA |               NA |              NA |               NA |               NA |           198474 |            11117 |           187357 |               NA |               NA |               NA |               NA | 2020-12-05 | groupe\_age      | 60 à 69 ans          |              12455 |                    101 |                        0 | 1147664 |
| 2020-12-05 | Groupe d’âge     | 70\_79     | 70-79 ans            |             8896 |              198 |             9094 |          1206.58 |             9.69 |               72 |                1 |               73 |              803 |           106.54 |               NA |                NA |             6840 |               64 |             1338 |           177.52 |             0.27 |              785 |              151 |              325 |               77 |                2 |                2 |                0 |                0 |                0 |               NA |                NA |               NA |              NA |               NA |               NA |               NA |               NA |              NA |               NA |               NA |           137315 |             7986 |           129329 |               NA |               NA |               NA |               NA | 2020-12-05 | groupe\_age      | 70 à 79 ans          |               9094 |                     73 |                        2 |  753700 |
| 2020-12-05 | Groupe d’âge     | 80\_89     | 80-89 ans            |            10959 |              253 |            11212 |          3421.68 |            22.89 |               75 |                0 |               75 |             1635 |           498.97 |               NA |                NA |             6455 |               36 |             2870 |           875.87 |             0.92 |             1811 |              583 |              333 |              143 |                3 |                3 |                0 |                0 |                0 |               NA |                NA |               NA |              NA |               NA |               NA |               NA |               NA |              NA |               NA |               NA |            89109 |             9794 |            79315 |               NA |               NA |               NA |               NA | 2020-12-05 | groupe\_age      | 80 à 89 ans          |              11212 |                     75 |                        3 |  327675 |
| 2020-12-05 | Groupe d’âge     | 90\_       | 90 ans et plus       |             7045 |              216 |             7261 |          8783.11 |            55.64 |               46 |                0 |               46 |              948 |          1146.73 |               NA |                NA |             3862 |               17 |             2384 |          2883.75 |             6.05 |             1606 |              532 |              126 |              120 |                5 |                3 |                1 |                1 |                0 |               NA |                NA |               NA |              NA |               NA |               NA |               NA |               NA |              NA |               NA |               NA |            39155 |             7056 |            32099 |               NA |               NA |               NA |               NA | 2020-12-05 | groupe\_age      | 90 ans et +          |               7261 |                     46 |                        5 |   82670 |
| 2020-12-05 | Groupe d’âge     | INC        | Inconnu              |               35 |               34 |               69 |               NA |               NA |                0 |                0 |                0 |                2 |               NA |               NA |                NA |               66 |                0 |                0 |               NA |               NA |                0 |                0 |                0 |                0 |                0 |                0 |                0 |                0 |                0 |               NA |                NA |               NA |              NA |               NA |               NA |               NA |               NA |              NA |               NA |               NA |           216000 |            14244 |           201756 |               NA |               NA |               NA |               NA | 2020-12-05 | groupe\_age      | Âge inconnu          |                 69 |                      0 |                        0 |      NA |
| 2020-12-05 | Groupe d’âge     | TOT        | Total                |           143493 |             8101 |           151594 |          1775.30 |            15.11 |             1267 |               23 |             1290 |            14323 |           167.73 |               NA |                NA |           128256 |             1198 |             7193 |            84.24 |             0.12 |             4528 |             1296 |              994 |              375 |               10 |                8 |                1 |                1 |                0 |               NA |                NA |               NA |              NA |               NA |               NA |               NA |               NA |              NA |               NA |               NA |          2248348 |           143199 |          2105149 |               NA |               NA |               NA |               NA | 2020-12-05 | groupe\_age      | Total                |             151594 |                   1290 |                       10 | 8390499 |
| 2020-12-05 | Sexe             | MASC       | Masculin             |            64603 |             4100 |            68703 |          1610.01 |            14.06 |              592 |                8 |              600 |             6495 |           152.21 |               NA |                NA |            58085 |              541 |             3300 |            77.33 |             0.12 |             1953 |              576 |              586 |              185 |                5 |                4 |                0 |                1 |                0 |               NA |                NA |               NA |              NA |               NA |               NA |               NA |               NA |              NA |               NA |               NA |          1004233 |            64181 |           940052 |               NA |               NA |               NA |               NA | 2020-12-05 | sexe             | Masculin             |              68703 |                    600 |                        5 |      NA |
| 2020-12-05 | Sexe             | FEM        | Féminin              |            78782 |             4000 |            82782 |          1937.85 |            16.15 |              675 |               15 |              690 |             7827 |           183.22 |               NA |                NA |            70064 |              657 |             3892 |            91.11 |             0.12 |             2575 |              719 |              408 |              190 |                5 |                4 |                1 |                0 |                0 |               NA |                NA |               NA |              NA |               NA |               NA |               NA |               NA |              NA |               NA |               NA |          1239015 |            78705 |          1160310 |               NA |               NA |               NA |               NA | 2020-12-05 | sexe             | Féminin              |              82782 |                    690 |                        5 |      NA |
| 2020-12-05 | Sexe             | INC        | Inconnu              |              108 |                1 |              109 |               NA |               NA |                0 |                0 |                0 |                1 |               NA |               NA |                NA |              107 |                0 |                1 |               NA |               NA |                0 |                1 |                0 |                0 |                0 |                0 |                0 |                0 |                0 |               NA |                NA |               NA |              NA |               NA |               NA |               NA |               NA |              NA |               NA |               NA |             5100 |              313 |             4787 |               NA |               NA |               NA |               NA | 2020-12-05 | sexe             | Sexe inconnu         |                109 |                      0 |                        0 |      NA |
| 2020-12-05 | Sexe             | TOT        | Total                |           143493 |             8101 |           151594 |          1775.30 |            15.11 |             1267 |               23 |             1290 |            14323 |           167.73 |               NA |                NA |           128256 |             1198 |             7193 |            84.24 |             0.12 |             4528 |             1296 |              994 |              375 |               10 |                8 |                1 |                1 |                0 |               NA |                NA |               NA |              NA |               NA |               NA |               NA |               NA |              NA |               NA |               NA |          2248348 |           143199 |          2105149 |               NA |               NA |               NA |               NA | 2020-12-05 | sexe             | Total                |             151594 |                   1290 |                       10 |      NA |

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
| 2020-11-16 |     538 |              NA | 100 |      23289 |
| 2020-11-17 |     552 |              NA | 100 |      30045 |
| 2020-11-18 |     550 |              NA | 101 |      33422 |
| 2020-11-19 |     528 |              NA |  96 |      31696 |
| 2020-11-20 |     547 |              NA |  99 |      31469 |
| 2020-11-21 |     539 |              NA | 103 |      26091 |
| 2020-11-22 |     536 |              NA |  98 |      21378 |
| 2020-11-23 |     559 |              NA |  96 |      21697 |
| 2020-11-24 |     562 |              NA |  93 |      31323 |
| 2020-11-25 |     585 |              NA |  90 |      32144 |
| 2020-11-26 |     579 |              NA |  90 |      31484 |
| 2020-11-27 |     585 |              NA |  93 |      28679 |
| 2020-11-28 |     573 |              NA |  92 |      24064 |
| 2020-11-29 |     599 |              NA |  94 |      21555 |
| 2020-11-30 |     621 |              NA |  98 |      24081 |
| 2020-12-01 |     641 |              NA |  99 |      33469 |
| 2020-12-02 |     638 |              NA |  99 |      33582 |
| 2020-12-03 |     664 |              NA |  97 |      36097 |
| 2020-12-04 |     658 |              NA |  96 |      30847 |
| 2020-12-05 |     676 |              NA | 102 |         NA |

#### get\_inspq\_manual\_data\_tableau\_accueil()

get\_inspq\_manual\_data\_tableau\_accueil() retourne les chiffres
utilisés dans le haut de la page de données covid19 de l’inspq. ça
balance pas toujours avec l’output des 2 fonctions précédentes.

``` r
get_inspq_manual_data_tableau_accueil()   %>%  knitr::kable()
```

|    cas | deces | hospit | soins | gueris | analyses | type      |
| -----: | ----: | -----: | ----: | -----: | -------: | :-------- |
| 151599 |  7255 |    778 |   102 | 130018 |    30847 | cumulatif |
|   1691 |    24 |     24 |     6 |   1190 |       NA | quotidien |

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
| 14 - Lanaudière                    | 1411 - RLS de Lanaudière-Nord                   | 2020-12-06   |              5580 | current |        5580 |    46 | Lanaudière-Nord                   |     223099 |        20.618649 |                  281 |                            391 |                      125.953052 | 1411      |      179.93293 |            179.93293 |                250.36931 | plus de 100 cas par million     | 223099 | 1411 - Lanaudière-Nord                |
| 14 - Lanaudière                    | 1412 - RLS de Lanaudière-Sud                    | 2020-12-06   |              6205 | current |        6205 |    90 | Lanaudière-Sud                    |     296993 |        30.303745 |                  483 |                            421 |                      162.630096 | 1412      |      232.32871 |            232.32871 |                202.50598 | plus de 100 cas par million     | 296993 | 1412 - Lanaudière-Sud                 |
| 15 - Laurentides                   | 1511 - RLS d’Antoine-Labelle                    | 2020-12-06   |               161 | current |         161 |     2 | d’Antoine-Labelle                 |      35580 |         5.621136 |                    8 |                             20 |                       22.484542 | 1511      |       32.12077 |             32.12077 |                 80.30194 | entre 20 et 60 cas par million  |  35580 | 1511 - d’Antoine-Labelle              |
| 15 - Laurentides                   | 1512 - RLS des Laurentides                      | 2020-12-06   |               350 | current |         350 |     7 | des Laurentides                   |      48016 |        14.578474 |                   21 |                             10 |                       43.735422 | 1512      |       62.47917 |             62.47917 |                 29.75199 | entre 60 et 100 cas par million |  48016 | 1512 - Laurentides                    |
| 15 - Laurentides                   | 1513 - RLS des Pays-d’en-Haut                   | 2020-12-06   |               462 | current |         462 |    12 | des Pays-d’en-Haut                |      44362 |        27.050178 |                   35 |                             17 |                       78.896353 | 1513      |      112.70908 |            112.70908 |                 54.74441 | plus de 100 cas par million     |  44362 | 1513 - Pays-d’en-Haut                 |
| 15 - Laurentides                   | 1514 - RLS d’Argenteuil                         | 2020-12-06   |               277 | current |         277 |     4 | d’Argenteuil                      |      33422 |        11.968165 |                   10 |                              8 |                       29.920412 | 1514      |       42.74345 |             42.74345 |                 34.19476 | entre 20 et 60 cas par million  |  33422 | 1514 - d’Argenteuil                   |
| 15 - Laurentides                   | 1515 - RLS de Deux-Montagnes - Mirabel-Sud      | 2020-12-06   |              1760 | current |        1760 |     6 | Deux-Montagnes - Mirabel-Sud      |     124641 |         4.813825 |                   65 |                             64 |                       52.149774 | 1515      |       74.49968 |             74.49968 |                 73.35353 | entre 60 et 100 cas par million | 124641 | 1515 - Deux-Montagnes - Mirabel-Sud   |
| 15 - Laurentides                   | 1516 - RLS de la Rivière-du-Nord - Mirabel-Nord | 2020-12-06   |              2328 | current |        2328 |    19 | la Rivière-du-Nord - Mirabel-Nord |     177517 |        10.703200 |                  102 |                             72 |                       57.459286 | 1516      |       82.08469 |             82.08469 |                 57.94214 | entre 60 et 100 cas par million | 177517 | 1516 - Rivière-du-Nord - Mirabel-Nord |
| 15 - Laurentides                   | 1517 - RLS de Thérèse-De Blainville             | 2020-12-06   |              2930 | current |        2930 |    22 | Thérèse-De Blainville             |     163430 |        13.461421 |                  142 |                            108 |                       86.887352 | 1517      |      124.12479 |            124.12479 |                 94.40477 | plus de 100 cas par million     | 163430 | 1517 - Thérèse-De Blainville          |
| 16 - Montérégie                    | 1611 - RLS de Champlain                         | 2020-12-06   |              4029 | current |        4029 |    11 | Champlain                         |     225442 |         4.879304 |                  175 |                            165 |                       77.625287 | 1611      |      110.89327 |            110.89327 |                104.55651 | plus de 100 cas par million     | 225442 | 1611 - Champlain                      |
| 16 - Montérégie                    | 1612 - RLS du Haut-Richelieu - Rouville         | 2020-12-06   |              2387 | current |        2387 |    18 | du Haut-Richelieu - Rouville      |     195297 |         9.216731 |                  102 |                            105 |                       52.228145 | 1612      |       74.61164 |             74.61164 |                 76.80610 | entre 60 et 100 cas par million | 195297 | 1612 - Haut-Richelieu - Rouville      |
| 16 - Montérégie                    | 1621 - RLS Pierre-Boucher                       | 2020-12-06   |              4439 | current |        4439 |    36 | Pierre-Boucher                    |     262440 |        13.717421 |                  195 |                            242 |                       74.302698 | 1621      |      106.14671 |            106.14671 |                131.73079 | plus de 100 cas par million     | 262440 | 1621 - Pierre-Boucher                 |
| 16 - Montérégie                    | 1622 - RLS de Richelieu-Yamaska                 | 2020-12-06   |              3641 | current |        3641 |    58 | Richelieu-Yamaska                 |     220957 |        26.249451 |                  296 |                            213 |                      133.962717 | 1622      |      191.37531 |            191.37531 |                137.71264 | plus de 100 cas par million     | 220957 | 1622 - Richelieu-Yamaska              |
| 16 - Montérégie                    | 1623 - RLS Pierre-De Saurel                     | 2020-12-06   |               562 | current |         562 |    15 | Pierre-De Saurel                  |      51371 |        29.199354 |                   98 |                            120 |                      190.769111 | 1623      |      272.52730 |            272.52730 |                333.70690 | plus de 100 cas par million     |  51371 | 1623 - Pierre-De Saurel               |
| 16 - Montérégie                    | 1631 - RLS de Vaudreuil-Soulanges               | 2020-12-06   |              1725 | current |        1725 |    15 | Vaudreuil-Soulanges               |     160002 |         9.374883 |                  117 |                            119 |                       73.124086 | 1631      |      104.46298 |            104.46298 |                106.24867 | plus de 100 cas par million     | 160002 | 1631 - Vaudreuil-Soulanges            |
| 16 - Montérégie                    | 1632 - RLS du Suroît                            | 2020-12-06   |              1006 | current |        1006 |     4 | du Suroît                         |      60523 |         6.609058 |                   40 |                             23 |                       66.090577 | 1632      |       94.41511 |             94.41511 |                 54.28869 | entre 60 et 100 cas par million |  60523 | 1632 - Suroît                         |
| 16 - Montérégie                    | 1633 - RLS du Haut-Saint-Laurent                | 2020-12-06   |               219 | current |         219 |     3 | du Haut-Saint-Laurent             |      24346 |        12.322353 |                    5 |                              3 |                       20.537255 | 1633      |       29.33894 |             29.33894 |                 17.60336 | entre 20 et 60 cas par million  |  24346 | 1633 - Haut-Saint-Laurent             |
| 16 - Montérégie                    | 1634 - RLS de Jardins-Roussillon                | 2020-12-06   |              3192 | current |        3192 |    66 | Jardins-Roussillon                |     232373 |        28.402611 |                  271 |                            151 |                      116.622843 | 1634      |      166.60406 |            166.60406 |                 92.83105 | plus de 100 cas par million     | 232373 | 1634 - Jardins-Roussillon             |
| 17 - Nunavik                       | 1701 - Nunavik                                  | 2020-12-06   |                29 | current |          29 |     1 | NA                                |      14260 |         7.012623 |                    1 |                              0 |                        7.012623 | 1701      |       10.01803 |             10.01803 |                  0.00000 | moins de 20 cas par million     |  14260 | 1701 - Nunavik                        |
| 18 - Terres-Cries-de-la-Baie-James | 1801 - Terres-Cries-de-la-Baie-James            | 2020-12-06   |                16 | current |          16 |     0 | NA                                |      18385 |         0.000000 |                    0 |                              0 |                        0.000000 | 1801      |        0.00000 |              0.00000 |                  0.00000 | moins de 20 cas par million     |  18385 | 1801 - Terres-Cries-de-la-Baie-James  |

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
| 731000 | CSS de Charlevoix                 | www.cscharlevoix.qc.ca       |   7066.5687 |  403.05820 | V2020-07   |     1 |      1 | 2020-12-06   |                    2 |                      1.9914429 |      28295 |                              10.1 |                                        10.1 | moins de 20 cas par million     |                             7.0 | Charlevoix                 |
| 821000 | CSS de la Côte-du-Sud             | <http://www.cscotesud.qc.ca> |   5959.9203 |  418.42028 | V2020-07   |     1 |      1 | 2020-12-06   |                   60 |                     48.3445292 |      70237 |                             123.0 |                                        98.3 | plus de 100 cas par million     |                            86.1 | Côte-du-Sud                |
| 852000 | CSS de la Rivière-du-Nord         | <http://www2.csrdn.qc.ca/>   |   2049.6010 |  322.44185 | V2020-07   |     1 |      1 | 2020-12-06   |                  110 |                     78.5052642 |     190425 |                              82.2 |                                        58.9 | entre 60 et 100 cas par million |                            57.5 | Rivière-du-Nord            |
| 772000 | CSS des Portages-de-l’Outaouais   | www.cspo.qc.ca               |   1382.6493 |  195.52992 | V2020-07   |     1 |      1 | 2020-12-06   |                   66 |                    118.3204777 |     153423 |                              61.7 |                                       110.2 | entre 60 et 100 cas par million |                            43.2 | Portages-de-l’Outaouais    |
| 724000 | CSS De La Jonquière               | www.csjonquiere.qc.ca        |   1001.8302 |  169.10289 | V2020-07   |     1 |      1 | 2020-12-06   |                  165 |                    204.9050827 |      66718 |                             353.1 |                                       438.7 | plus de 100 cas par million     |                           247.2 | De La Jonquière            |
| 773000 | CSS au Coeur-des-Vallées          | www.cscv.qc.ca               |   3458.9423 |  322.35632 | V2020-07   |     1 |      1 | 2020-12-06   |                   31 |                     41.2757162 |      53658 |                              83.7 |                                       109.9 | entre 60 et 100 cas par million |                            58.6 | au Coeur-des-Vallées       |
| 774000 | CSS des Hauts-Bois-de-l’Outaouais | www.cshbo.qc.ca              |  28080.7957 | 1363.04393 | V2020-07   |     1 |      1 | 2020-12-06   |                   12 |                      5.7667089 |      33868 |                              49.0 |                                        24.3 | entre 20 et 60 cas par million  |                            34.3 | Hauts-Bois-de-l’Outaouais  |
| 791000 | CSS de l’Estuaire                 | www.csestuaire.qc.ca         |  57965.0122 | 1241.96584 | V2020-07   |     1 |      1 | 2020-12-06   |                    1 |                      5.0005820 |      41543 |                               3.4 |                                        17.2 | moins de 20 cas par million     |                             2.4 | l’Estuaire                 |
| 782000 | CSS de Rouyn-Noranda              | www.csrn.qc.ca               |   6073.5950 |  416.44383 | V2020-07   |     1 |      1 | 2020-12-06   |                    2 |                      0.0000119 |      41784 |                               6.7 |                                         0.0 | moins de 20 cas par million     |                             4.7 | Rouyn-Noranda              |
| 801000 | CSS de la Baie-James              | <http://csbj.qc.ca/>         | 343574.3467 | 5631.60890 | V2020-07   |     1 |      1 | 2020-12-06   |                    0 |                      2.0000503 |      16151 |                               0.0 |                                        17.7 | moins de 20 cas par million     |                             0.0 | Baie-James                 |
| 742000 | CSS de l’Énergie                  | www.csenergie.qc.ca          |  37903.5713 | 1189.64144 | V2020-07   |     1 |      1 | 2020-12-06   |                   50 |                     65.0666147 |      97133 |                              73.4 |                                        95.7 | entre 60 et 100 cas par million |                            51.4 | l’Énergie                  |
| 762000 | CSS de Montréal                   | www.csdm.qc.ca               |    163.9897 |  112.21365 | V2020-07   |     1 |      1 | 2020-12-06   |                 1430 |                   1099.5421699 |    1009727 |                             202.3 |                                       155.6 | plus de 100 cas par million     |                           141.6 | Montréal                   |
| 763000 | CSS Marguerite-Bourgeoys          | www.csmb.qc.ca               |    356.2161 |  133.05741 | V2020-07   |     1 |      1 | 2020-12-06   |                  922 |                    774.8425802 |     611365 |                             215.4 |                                       181.1 | plus de 100 cas par million     |                           150.8 | Marguerite-Bourgeoys       |
| 869000 | CSS des Trois-Lacs                | www.cstrois-lacs.qc.ca       |   1023.8689 |  154.98997 | V2020-07   |     1 |      1 | 2020-12-06   |                  117 |                    118.9992673 |     147799 |                             113.1 |                                       115.0 | plus de 100 cas par million     |                            79.2 | Trois-Lacs                 |
| 823000 | CSS de la Beauce-Etchemin         | www.csbe.qc.ca               |   6202.0129 |  542.92776 | V2020-07   |     1 |      1 | 2020-12-06   |                  266 |                    178.4714085 |     123821 |                             306.3 |                                       205.9 | plus de 100 cas par million     |                           214.4 | Beauce-Etchemin            |
| 868000 | CSS de la Vallée-des-Tisserands   | www.csvt.qc.ca               |   1847.3375 |  219.29223 | V2020-07   |     1 |      1 | 2020-12-06   |                   54 |                     30.9668486 |      86081 |                              89.5 |                                        51.4 | entre 60 et 100 cas par million |                            62.6 | Vallée-des-Tisserands      |
| 854000 | CSS Pierre-Neveu                  | www.cspn.qc.ca               |  16291.9939 |  859.45936 | V2020-07   |     1 |      1 | 2020-12-06   |                    8 |                     19.9989175 |      35249 |                              32.4 |                                        81.1 | entre 20 et 60 cas par million  |                            22.7 | Pierre-Neveu               |
| 714000 | CSS de Kamouraska-Rivière-du-Loup | www.cskamloup.qc.ca          |   5054.5614 |  413.10309 | V2020-07   |     1 |      1 | 2020-12-06   |                   10 |                      4.9539116 |      55614 |                              24.8 |                                        12.7 | entre 20 et 60 cas par million  |                            17.4 | Kamouraska-Rivière-du-Loup |
| 853000 | CSS des Laurentides               | www.cslaurentides.qc.ca      |   3970.8926 |  362.47283 | V2020-07   |     1 |      1 | 2020-12-06   |                   61 |                     34.5220254 |      92025 |                              95.3 |                                        53.6 | entre 60 et 100 cas par million |                            66.7 | Laurentides                |
| 831000 | CSS de Laval                      | www.cslaval.qc.ca            |    266.9471 |   83.47677 | V2020-07   |     1 |      1 | 2020-12-06   |                  816 |                    594.0000000 |     418557 |                             278.5 |                                       202.7 | plus de 100 cas par million     |                           195.0 | Laval                      |

#### Montreal data

``` r
mtl_data <-suppressMessages( get_mtl_data() )

mtl_data %>% tail(20)   %>%  knitr::kable()
```

| arrondissement                           | date\_report | cumulative\_cases | source   | fix\_cummin | cases | arrond\_ville\_liee | Population | cases\_per\_100k | cases\_last\_7\_days | previous\_cases\_last\_7\_days | cases\_last\_7\_days\_per\_100k | cases\_per\_1M | last\_cases\_per\_1M | previous\_cases\_per\_1M | color\_per\_pop                 |     pop |
| :--------------------------------------- | :----------- | ----------------: | :------- | ----------: | ----: | :------------------ | ---------: | ---------------: | -------------------: | -----------------------------: | ------------------------------: | -------------: | -------------------: | -----------------------: | :------------------------------ | ------: |
| Montréal Est                             | 2020-12-06   |                87 | montreal |          87 |     0 | Ville               |       4012 |                0 |                    5 |                              3 |                       124.62612 |      178.03732 |            178.03732 |                106.82239 | plus de 100 cas par million     |    4012 |
| Montréal-Nord                            | 2020-12-06   |              4049 | montreal |        4049 |     0 | Arrond.             |      87928 |                0 |                  118 |                            123 |                       134.20071 |      191.71530 |            191.71530 |                199.83883 | plus de 100 cas par million     |   87928 |
| Montréal-Ouest                           | 2020-12-06   |                61 | montreal |          61 |     0 | Ville               |       5287 |                0 |                    2 |                              1 |                        37.82864 |       54.04091 |             54.04091 |                 27.02045 | entre 20 et 60 cas par million  |    5287 |
| Outremont                                | 2020-12-06   |               631 | montreal |         631 |     0 | Arrond.             |      25826 |                0 |                   10 |                             13 |                        38.72067 |       55.31524 |             55.31524 |                 71.90981 | entre 20 et 60 cas par million  |   25826 |
| Pierrefonds–Roxboro                      | 2020-12-06   |              1259 | montreal |        1259 |     0 | Arrond.             |      73230 |                0 |                   80 |                            104 |                       109.24484 |      156.06406 |            156.06406 |                202.88328 | plus de 100 cas par million     |   73230 |
| Plateau Mont-Royal                       | 2020-12-06   |              1941 | montreal |        1941 |     0 | Arrond.             |     108102 |                0 |                   47 |                             63 |                        43.47746 |       62.11065 |             62.11065 |                 83.25470 | entre 60 et 100 cas par million |  108102 |
| Pointe-Claire                            | 2020-12-06   |               377 | montreal |         377 |     0 | Ville               |      33382 |                0 |                   27 |                             25 |                        80.88191 |      115.54559 |            115.54559 |                106.98666 | plus de 100 cas par million     |   33382 |
| Rivière-des-Prairies–Pointe-aux-Trembles | 2020-12-06   |              3598 | montreal |        3598 |     0 | Arrond.             |     114732 |                0 |                  150 |                            109 |                       130.73946 |      186.77066 |            186.77066 |                135.72001 | plus de 100 cas par million     |  114732 |
| Rosemont–La Petite Patrie                | 2020-12-06   |              3166 | montreal |        3166 |     0 | Arrond.             |     147624 |                0 |                  107 |                            151 |                        72.48144 |      103.54491 |            103.54491 |                146.12413 | plus de 100 cas par million     |  147624 |
| Saint-Laurent                            | 2020-12-06   |              2610 | montreal |        2610 |     0 | Arrond.             |     105248 |                0 |                  108 |                            179 |                       102.61478 |      146.59254 |            146.59254 |                242.96356 | plus de 100 cas par million     |  105248 |
| Saint-Léonard                            | 2020-12-06   |              2423 | montreal |        2423 |     0 | Arrond.             |      82841 |                0 |                  178 |                            140 |                       214.86945 |      306.95636 |            306.95636 |                241.42635 | plus de 100 cas par million     |   82841 |
| Sainte-Anne-de-Bellevue                  | 2020-12-06   |                52 | montreal |          52 |     0 | Ville               |       5038 |                0 |                   14 |                             11 |                       277.88805 |      396.98293 |            396.98293 |                311.91516 | plus de 100 cas par million     |    5038 |
| Senneville                               | 2020-12-06   |                 9 | montreal |           9 |     0 | Ville               |        981 |                0 |                    1 |                              0 |                       101.93680 |      145.62400 |            145.62400 |                  0.00000 | plus de 100 cas par million     |     981 |
| Sud-Ouest                                | 2020-12-06   |              1798 | montreal |        1798 |     0 | Arrond.             |      84299 |                0 |                   44 |                             68 |                        52.19516 |       74.56452 |             74.56452 |                115.23607 | entre 60 et 100 cas par million |   84299 |
| Territoire à confirmer                   | 2020-12-06   |              1089 | montreal |        1089 |     0 | NA                  |         NA |               NA |                   21 |                             29 |                              NA |             NA |              0.00000 |                  0.00000 | moins de 20 cas par million     |      NA |
| Total à Montréal                         | 2020-12-06   |             52674 | montreal |       52674 |     0 | NA                  |    2050053 |                0 |                 1940 |                           2268 |                        94.63170 |      135.18814 |            135.18814 |                158.04469 | plus de 100 cas par million     | 2050053 |
| Verdun                                   | 2020-12-06   |              1497 | montreal |        1497 |     0 | Arrond.             |      72419 |                0 |                   29 |                             36 |                        40.04474 |       57.20677 |             57.20677 |                 71.01530 | entre 20 et 60 cas par million  |   72419 |
| Ville-Marie                              | 2020-12-06   |              2085 | montreal |        2085 |     0 | Arrond.             |      95231 |                0 |                   49 |                             56 |                        51.45383 |       73.50548 |             73.50548 |                 84.00626 | entre 60 et 100 cas par million |   95231 |
| Villeray–Saint-Michel–Parc-Extension     | 2020-12-06   |              4305 | montreal |        4305 |     0 | Arrond.             |     148202 |                0 |                  157 |                            165 |                       105.93649 |      151.33785 |            151.33785 |                159.04933 | plus de 100 cas par million     |  148202 |
| Westmount                                | 2020-12-06   |               349 | montreal |         349 |     0 | Ville               |      20974 |                0 |                   28 |                             15 |                       133.49862 |      190.71231 |            190.71231 |                102.16731 | plus de 100 cas par million     |   20974 |

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
