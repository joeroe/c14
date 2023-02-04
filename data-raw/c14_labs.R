# Script to prepare dataset `c14_labs`: table of active and defunct radiocarbon
#  laboratories and lab codes.

library(readr)
c14_labs <- readr::read_tsv("data-raw/c14_labs.tsv", col_types = "clcc")

c14_labs <- as.data.frame(c14_labs)
usethis::use_data(c14_labs, overwrite = TRUE)
