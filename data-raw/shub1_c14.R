# shub1_c14.R
# Prepare shub1_c14 dataset – radiocarbon dates from Shubayqa 1 (Richter et al.
# 2017, ESM 2, "Radiocarbon Dates")
#
# Citation: Richter, T., Arranz-Otaegui, A., Yeomans, L. et al. High Resolution
#   AMS Dates from Shubayqa 1, northeast Jordan Reveal Complex Origins of Late
#   Epipalaeolithic Natufian in the Levant. Sci Rep 7, 17025 (2017).
#   https://doi.org/10.1038/s41598-017-17096-5

shub1_c14 <- readxl::read_xlsx("data-raw/41598_2017_17096_MOESM2_ESM.xlsx")

# Discard unwanted columns and normalise the names of the rest
shub1_c14 <- dplyr::select(shub1_c14,
                           lab_id = `Laboratory Code`,
                           phase = `Archaeological Phase`,
                           sample = `Sample Context ID`,
                           material = `Sample material`,
                           age = `C-14 Age ±1σ year BP`
)

# Fill missing phases
shub1_c14 <- tidyr::fill(shub1_c14, phase)

# Discard non-data rows
shub1_c14 <- tidyr::drop_na(shub1_c14, lab_id)

# Normalise lab IDs
shub1_c14 <- dplyr::mutate(shub1_c14,
                           lab_id = stringr::str_remove(lab_id, "R_Date "))

# Add an outlier column (marked with a "*" next to the lab ID in the original data)
shub1_c14 <- dplyr::mutate(shub1_c14,
                           outlier = stringr::str_detect(lab_id, stringr::coll("*")),
                           lab_id = stringr::str_remove(lab_id, stringr::coll("*")))

# Separate age and error in radiocarbon date
shub1_c14 <- tidyr::separate(shub1_c14, age, c("c14_age", "c14_error"), " ±")
shub1_c14$c14_age <- as.integer(shub1_c14$c14_age)
shub1_c14$c14_error <- as.integer(shub1_c14$c14_error)

# Add schematic context numbers to match "shub1" dataset from stratigraphr
shub1_c14 <- dplyr::mutate(shub1_c14,
                           context = dplyr::recode(lab_id,
                                                   `RTD-7951` = 23,
                                                   `Beta-112146` = 24,
                                                   `RTD-7317` = 26,
                                                   `RTD-7318` = 27,
                                                   `RTD-7948` = 24,
                                                   `RTD-7947` = 22,
                                                   `RTD-7313` = 22,
                                                   `RTD-7311` = 22,
                                                   `RTD-7312` = 22,
                                                   `RTD-7314` = 22,
                                                   `RTD-7316` = 22,
                                                   `RTD-7315` = 22,
                                                   `RTK-6818` = 14,
                                                   `RTK-6820` = 14,
                                                   `RTK-6821` = 16,
                                                   `RTK-6822` = 16,
                                                   `RTK-6823` = 16,
                                                   `RTK-6813` = 12,
                                                   `RTK-6816` = 12,
                                                   `RTK-6819` = 5,
                                                   `RTK-6812` = 3,
                                                   `RTK-6817` = 2,
                                                   `RTD-8904` = 1,
                                                   `RTK-6814` = 1,
                                                   `RTD-8902` = 1,
                                                   `RTD-8903` = 1,
                                                   `RTK-6815` = 1))
shub1_c14 <- dplyr::relocate(shub1_c14, context, .after = lab_id)
shub1_c14$context <- as.integer(shub1_c14$context)

# Export
usethis::use_data(shub1_c14, overwrite = TRUE)
