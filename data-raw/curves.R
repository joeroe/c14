# curves.R
# Prepares calibiration curve datasets

# IntCal <http://intcal.org/curves/>
IntCal20 <- read_14c("./data-raw/curves/intcal20.14c")
IntCal13 <- read_14c("./data-raw/curves/intcal13.14c")
IntCal09 <- read_14c("./data-raw/curves/intcal09.14c")
IntCal04 <- read_14c("./data-raw/curves/intcal04.14c")
IntCal98 <- read_14c("./data-raw/curves/intcal98.14c", delim = "", cal_era = "CE",
                     col_names = c("cal_age", "d14c", "d14c_error", "c14_age", "c14_error"))

# Marine <http://intcal.org/curves/>
Marine20 <- read_14c("./data-raw/curves/marine20.14c")
Marine13 <- read_14c("./data-raw/curves/marine13.14c")
Marine09 <- read_14c("./data-raw/curves/marine09.14c")
Marine04 <- read_14c("./data-raw/curves/marine04.14c")
Marine98 <- read_14c("./data-raw/curves/marine98.14c", delim = "", cal_era = "CE",
                     col_names = c("cal_age", "d14c", "d14c_error", "c14_age", "c14_error"))

# SHCal <http://intcal.org/curves/>
SHCal20 <- read_14c("./data-raw/curves/shcal20.14c")
SHCal13 <- read_14c("./data-raw/curves/shcal13.14c")
SHCal04 <- read_14c("./data-raw/curves/shcal04.14c")

# TODO: Look for more authorative source of these
# Northern Hemisphere Zone X (post-bomb) <http://calib.org/CALIBomb/>
# NHZ1 <- read_14c("./data-raw/curves/NHZ1.f14c")
# NHZ2 <- read_14c("./data-raw/curves/NHZ2.f14c")
# NHZ3 <- read_14c("./data-raw/curves/NHZ3.f14c")

# Southern Hemisphere Zone X (post-bomb) <http://calib.org/CALIBomb/>
# SHZ1_2 <- read_14c("./data-raw/curves/SHZ1_2.f14c")
# SHZ3 <- read_14c("./data-raw/curves/SHZ3.f14c")

# Misc. post-bomb <http://calib.org/CALIBomb/>
# Brazil <- read_14c("./data-raw/curves/Brazil.f14c")
# KureAtoll <- read_14c("./data-raw/curves/KureAtoll.f14c")
# Levin <- read_14c("./data-raw/curves/Levin.f14c")

usethis::use_data(IntCal20, overwrite = TRUE)
usethis::use_data(IntCal13, overwrite = TRUE)
usethis::use_data(IntCal09, overwrite = TRUE)
usethis::use_data(IntCal04, overwrite = TRUE)
usethis::use_data(IntCal98, overwrite = TRUE)
usethis::use_data(Marine20, overwrite = TRUE)
usethis::use_data(Marine13, overwrite = TRUE)
usethis::use_data(Marine09, overwrite = TRUE)
usethis::use_data(Marine04, overwrite = TRUE)
usethis::use_data(Marine98, overwrite = TRUE)
usethis::use_data(SHCal20, overwrite = TRUE)
usethis::use_data(SHCal13, overwrite = TRUE)
usethis::use_data(SHCal04, overwrite = TRUE)
# usethis::use_data(NHZ1, overwrite = TRUE)
# usethis::use_data(NHZ2, overwrite = TRUE)
# usethis::use_data(NHZ3, overwrite = TRUE)
# usethis::use_data(SHZ1_2, overwrite = TRUE)
# usethis::use_data(SHZ3, overwrite = TRUE)
# usethis::use_data(Brazil, overwrite = TRUE)
# usethis::use_data(KureAtoll, overwrite = TRUE)
# usethis::use_data(Levin, overwrite = TRUE)