# Script to prepare dataset `c14_material_thesaurus`: a thesaurus of radiocarbon
# sample material variants and their preferred (canon) form.

c14_material_thesaurus <- readr::read_csv("data-raw/c14_material_thesaurus.csv",
                                          col_types = "cc")

c14_material_thesaurus <- as.data.frame(c14_material_thesaurus)
usethis::use_data(c14_material_thesaurus, overwrite = TRUE)
