#' get_raw_variant_data downloads variant data from JP's s3 bucket
#'
#' @return
#' @export
#'
#' @examples
get_raw_variant_data <- function(){
  plan("multisession", workers = availableCores() - 1)

  filelist_s3_bucket <- aws.s3::get_bucket("data.opencovid.ca" , prefix= "archive/qc/variants/", region = "us-east-2", max= Inf)

  filelist <-
    map(filelist_s3_bucket,
        function(x){
          x$Key
        }
    ) %>%
    unlist() %>%
    unname()



  suppressWarnings(
    csvs <-
      furrr::future_map(
        filelist,
        function(x){
          readr::read_csv(
            rawToChar(get_object(object = x, bucket = "data.opencovid.ca", region ="us-east-2")),
            col_types = readr::cols(
              `RÉGION SOCIOSANITAIRE` = readr::col_character(),
              .default = readr::col_number()
            )
          )
        }
      )
  )
  # end - replacement code that uses aws.s3()


  years <- stringr::str_sub(filelist, -20, -17)
  months <- stringr::str_sub(filelist, -15, -14)
  days <- stringr::str_sub(filelist, -12, -11)
  hours <- stringr::str_sub(filelist, -9, -8)
  minutes <- stringr::str_sub(filelist, -6, -5)
  datetimes <- lubridate::ymd_hm(paste(years, months, days, hours, minutes))


  current_csv <- readr::read_csv("https://www.inspq.qc.ca/sites/default/files/covid/donnees/variants.csv",
                                 col_types = readr::cols(
                                   `RÉGION SOCIOSANITAIRE` = readr::col_character(),
                                   .default = readr::col_number()
                                 )
  )

  current_datetime <- lubridate::ymd_hms(Sys.time())


  csvs <- c(csvs, list(current_csv))
  datetimes <- c(datetimes, current_datetime)
  # drop duplicates
  keep <- rep(TRUE, length(csvs))
  for (i in seq(from = 2, to = length(csvs))) {
    if (isTRUE(dplyr::all_equal(csvs[[i]], csvs[[i - 1]]))) {
      keep[i] <- FALSE
    }
  }

  return(list(datetimes = datetimes[keep], csvs = csvs[keep]))
}


#' get_variant_data() cleans data from JP's s3 bucket
#'
#' @return
#' @export
#'
#' @examples
get_variant_data <- function(){
  z <-get_raw_variant_data()

  pouet <- create_date_report_from_datetimes(z$datetimes, z$csvs) %>%
    bind_rows() %>%
    janitor::clean_names() %>%
    mutate(cumulatif_sequencage =  coalesce(cas_totaux_de_variants, total_confirmes,  total_sequencage),
           cumulatif_criblage = coalesce(presomptifs_recus, criblage)
    )

  pouet2 <- pouet %>%
    fix_cumulative(., date_report, cumulatif_criblage, region_sociosanitaire) %>%   # fix first cumulatif pour assurer qu'oon a pas de baisse de cmulatif
    fix_cumulative(., date_report, cumulatif_sequencage, region_sociosanitaire)  %>% # fix second cumulatif pour assurer qu'oon a pas de baisse de cmulatif
    add_slope(., date_report, cumulatif_criblage, region_sociosanitaire) %>%  # add slope for cumulatif1 for fill in missing dates
    add_slope(., date_report, cumulatif_sequencage, region_sociosanitaire)  %>% # add slope for cumulatif2 for fill in missing dates
    add_missing_dates(., date_report, region_sociosanitaire) %>%
    fill_cumulative_using_slope(., date_report, cumulatif_criblage, region_sociosanitaire) %>%
    fill_cumulative_using_slope(., date_report, cumulatif_sequencage, region_sociosanitaire) %>%
    add_daily_count_frum_cumulative(., date_report, cumulatif_sequencage, quotidien_sequencage, region_sociosanitaire) %>%
    add_daily_count_frum_cumulative(., date_report, cumulatif_criblage, quotidien_criblage, region_sociosanitaire) %>%
    select(region_sociosanitaire, date_report, cumulatif_sequencage, cumulatif_criblage ,  quotidien_sequencage , quotidien_criblage ) %>%
    left_join(table_correspondances_health_region_quebec %>% select(region_sociosanitaire, health_region, health_region_short)) %>%
  mutate(
    province = "Quebec",
    pr_region = paste0(province, "-", health_region)
  )%>%
  left_join(populations %>% select(pr_region, pop)) %>%
    mutate(quotidien_sequencage_par_1M = quotidien_sequencage * 1e6 / pop,
           quotidien_criblage_par_1M = quotidien_criblage * 1e6 / pop)
  return(pouet2)
}

## deébut  version group_vars dans les ... ----

#' fix_cumulative ensures than no cumulative count is lower than a previous value.  step 1 in the "create daile counts from cumulative counts" chain
#'
#' @param df
#' @param date
#' @param cumulative
#' @param ...
#'
#' @return
#' @export
#'
#' @examples
fix_cumulative <- function(df, date, cumulative,...) {
  group_vars <- quos(...)
  date_var <- enquo(date)
  cumulative_var <- enquo(cumulative)

  df %>%
    group_by(!!!group_vars) %>%
    arrange(!!!group_vars, desc(!!date_var)) %>%
    mutate(fix_cummin = cummin(tidyr::replace_na(!!cumulative_var, Inf))) %>%
    mutate(!!cumulative_var := if_else(!!cumulative_var > fix_cummin, fix_cummin, !!cumulative_var, !!cumulative_var)) %>%  ## cumulative can't be bigger than next day.. if so reduce to next day level.
    select(-fix_cummin) %>%
    arrange(!!!group_vars, !!date_var) %>%
    ungroup()
}

#' add_slope evaluates how many counts were added daily between 2 cumulative values -   step 2 in the "create daile counts from cumulative counts" chain
#'
#' @param df
#' @param date
#' @param cumulative
#' @param ...
#'
#' @return
#' @export
#'
#' @examples
add_slope <- function(df, date, cumulative, ...){
  group_vars <- quos(...)
  date_var <- enquo(date)
  cumulative_var <- enquo(cumulative)
  cumulative_name <- quo_name(cumulative_var)
  df %>%
    group_by(!!!group_vars) %>%
    arrange(!!!group_vars, !!date_var) %>%
    mutate(!!paste0("slope_", cumulative_name ):= (lead(!!cumulative_var) - !!cumulative_var) / as.numeric(lead(!!date_var) - !!date_var))%>%
    ungroup()
}

#' add missing dates add missing rows   -   step 3 in the "create daile counts from cumulative counts" chain
#'
#' @param df
#' @param date
#' @param ...
#'
#' @return
#' @export
#'
#' @examples
add_missing_dates <- function(df, date, ... ){
  group_vars <- quos(...)
  date_var <- enquo(date)

  df %>%
    group_by(!!!group_vars) %>%
    tidyr::complete(!!date_var := seq.Date(min(!!date_var), max(!!date_var), by = "day")) %>%
    ungroup()
}

#' fill_cumulative_using slope replaces cumulative values from previous missing days using the previously calculated slope  -   step 4 in the "create daile counts from cumulative counts" chain
#'
#' @param df
#' @param date
#' @param cumulative
#' @param ...
#'
#' @return
#' @export
#'
#' @examples
fill_cumulative_using_slope <- function(df, date, cumulative,... ){
  group_vars <- quos(...)
  date_var <- enquo(date)
  cumulative_var <- enquo(cumulative)
  cumulative_name <- quo_name(cumulative_var)

  df %>%
    group_by(!!!group_vars) %>%
    arrange(!!!group_vars, !!date_var) %>%
    tidyr::fill(!!paste0("slope_", cumulative_name ), .direction = "down") %>%
    mutate(
      !!cumulative_var := dplyr::if_else(
        !is.na(!!cumulative_var),
        !!cumulative_var,
        floor(
          first(!!cumulative_var)  +  cumsum(  !!rlang::sym( paste0("slope_", cumulative_name)) ) - !!rlang::sym( paste0("slope_", cumulative_name))
        ),
        NA_real_
      )
    ) %>%
    select(-!!paste0("slope_", cumulative_name )) %>%
    ungroup()
}

#' add_daily_count create a daily number of counts from a cumulative count  -   step 5 /5  in the "create daile counts from cumulative counts" chain
#'
#' @param df
#' @param date
#' @param cumulative
#' @param daily
#' @param ...
#'
#' @return
#' @export
#'
#' @examples
#'
#' data <- tribble(
#'   ~"date_report", ~"age", ~"sex", ~"cumulatif1", ~"cumulatif2",
#'   "2021-01-01", 18, "M", 10, 1,
#'   "2021-01-02", 18, "M", 9, 2,
#'   "2021-01-04", 18, "M", 12, 4,
#'   "2021-01-01", 19, "M", 10, 1,
#'   "2021-01-02", 19, "M", 9, 2,
#'   "2021-01-04", 19, "M", 12,4,
#'   "2021-01-01", 19, "F", 10,1,
#'   "2021-01-02", 19, "F", 9,2,
#'   "2021-01-04", 19, "F", 12, 4
#' ) %>%
#'   mutate(date_report=as.Date(date_report))

#' data %>%
#'   fix_cumulative(., date_report, cumulatif1, age, sex) %>%   # fix first cumulatif pour assurer qu'oon a pas de baisse de cmulatif
#'   fix_cumulative(., date_report, cumulatif2, age, sex)  %>% # fix second cumulatif pour assurer qu'oon a pas de baisse de cmulatif
#'   add_slope(., date_report, cumulatif1, age, sex) %>%  # add slope for cumulatif1 for fill in missing dates
#'   add_slope(., date_report, cumulatif2, age, sex)  %>% # add slope for cumulatif2 for fill in missing dates
#'   add_missing_dates(., date_report, age, sex) %>%
#'   fill_cumulative_using_slope(., date_report, cumulatif1, age, sex) %>%
#'   fill_cumulative_using_slope(., date_report, cumulatif2, age, sex) %>%
#'   add_daily_count_frum_cumulative(., date_report, cumulatif1, daily1, age,sex) %>%
#'   add_daily_count_frum_cumulative(., date_report, cumulatif2, daily2, age,sex)
#'
add_daily_count_frum_cumulative <- function(df, date, cumulative, daily, ...){
  group_vars <- quos(...)
  date_var <- enquo(date)
  cumulative_var <- enquo(cumulative)
  cumulative_name <- quo_name(cumulative_var)
  daily_var <- enquo(daily)
  daily_name <- quo_name(daily_var)

  df %>%
    group_by(!!!group_vars) %>%
    arrange(!!!group_vars, !!date_var) %>%
    mutate(!!daily_name := !!cumulative_var - lag(!!cumulative_var)) %>%
    ungroup()
}


