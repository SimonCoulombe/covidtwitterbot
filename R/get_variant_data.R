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
  )%>%
    janitor::clean_names()

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


get_variant_data <- function(){
  z <-get_raw_variant_data()
  pouet <- create_date_report_from_datetimes(z$datetimes, z$csvs) %>%
    bind_rows() %>%
    janitor::clean_names() %>%
    mutate(sequencage =  coalesce(cas_totaux_de_variants, total_confirmes,  total_sequencage),
           criblage = coalesce(presomptifs_recus, criblage),
           region = coalesce(region_sociosanitaire, region_sociosanitaire_2 )
           )
  return(pouet)
}
