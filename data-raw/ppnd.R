# ppnd.R
# Prepares 'ppnd' dataset: example radiocarbon data from Neolithic Southwest Asia

ppnd <- readr::read_csv("./data-raw/ppnd.csv", col_types = "ccnnciiccc")

usethis::use_data(ppnd, overwrite = TRUE)
