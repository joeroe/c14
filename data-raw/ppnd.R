# ppnd.R
# Prepares 'ppnd' dataset: example radiocarbon data from Neolithic Southwest Asia

readr::read_csv("./data-raw/ppnd.csv", col_types = "ccnnciiccc") |>
  tidyr::drop_na(cra, error) ->
  ppnd

usethis::use_data(ppnd, overwrite = TRUE)
