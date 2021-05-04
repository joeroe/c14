# Script to prepare dataset `c14_labs`: table of active and defunct radiocarbon
#  laboratories and lab codes.
# Sources:
# - *Radiocarbon* list, 9 April 2021, <http://radiocarbon.webhost.uits.arizona.edu/node/11>
library(dplyr)
library(stringr)
library(tabulizer)
library(tidyr)

lab_list <- "http://radiocarbon.webhost.uits.arizona.edu/sites/default/files/Labs-2021_Apr-09.pdf"
c14_labs <- extract_text(lab_list, pages = 20:22)

# Wrangle lines into a table
c14_labs %>%
  str_split("\n") %>%
  unlist() %>%
  tibble() ->
  c14_labs

# Extract columns
c14_labs <- extract(c14_labs, 1,
                    into = c("lab_code", "active", "lab", "country"),
                    regex = "^([^\\s\\*]*)(\\**)(.*?)([^\\s]*)\\s*$")


# Clean data and reunite wrapped lines
c14_labs %>%
  mutate(across(everything(), str_squish)) %>%
  mutate(active = recode(active, "*" = FALSE, .default = TRUE)) %>%
  mutate(lab = if_else(lead(lab_code) == "", paste(lab, lead(lab), lead(country)), lab)) %>%
  mutate(across(everything(), na_if, "")) %>%
  drop_na() %>%
  filter(lab_code != "LABORATORY") ->
  c14_labs

# Hotfix awkward lab codes
c14_labs$lab_code[c14_labs$lab_code == "Ki"] <- "Ki(KIEV)"
c14_labs$lab_code[c14_labs$lab == "A Gif-sur-Yvette and Orsay"] <- "GifA"

# Addendum
c14_labs_addendum <- readr::read_tsv("data-raw/c14_labs_addendum.tsv",
                                     col_types = "clcc")
c14_labs <- bind_rows(c14_labs, c14_labs_addendum)

usethis::use_data(c14_labs, overwrite = TRUE)
