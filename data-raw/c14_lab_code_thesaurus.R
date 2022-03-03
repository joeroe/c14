# Script to prepare dataset `c14_lab_code_thesaurus`: a thesaurus of radiocarbon
# code variants and their preferred (canon) form.

c14_lab_code_thesaurus <- readr::read_tsv("data-raw/c14_lab_code_thesaurus.tsv",
                            col_types = "cc")

c14_lab_code_thesaurus <- as.data.frame(c14_lab_code_thesaurus)
usethis::use_data(c14_lab_code_thesaurus, overwrite = TRUE)
