# save on amazon ----
message("save on amazon")
# pour instructions qui disent d'aller dans amazon pis de récupérer un secret key dans IAM
# https://github.com/cloudyr/aws.s3

# pour instruction qui disent de mettre les 4 blocks à off
# https://havecamerawilltravel.com/photographer/how-allow-public-access-amazon-bucket/

# file.edit(".Renviron")
# AWS_ACCESS_KEY_ID = "mykey"
# AWS_SECRET_ACCESS_KEY = "mysecret"
# AWS_DEFAULT_REGION = "us-east-1"

Sys.setlocale("LC_TIME", "en_CA.UTF8")
library(aws.s3)
# bucketlist()
#
#
# get_bucket(bucket = 'blogsimoncoulombe')
#
#
# s3save(mtcars, bucket = "blogsimoncoulombe", object = "covid19/mtcars.Rdata")
#

# put local file into S3


path <- "/home/simon/git/adhoc_prive/covid19_PNG/"
mylist <- setdiff(list.files(path, full.names = T), list.dirs(path, recursive = F))

purrr::map(mylist, ~
put_object(
  file = .x,
  object = paste0("covid19/", basename(.x)),
  bucket = "blogsimoncoulombe",
  acl = "public-read" # ,
  # headers=list("Content-Type" = "image/png")
))
