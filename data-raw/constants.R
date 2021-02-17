# constants.R
# Prepares datasets containing various radiocarbon-related constants

c14_decay_libby <- 1 / 8033

c14_decay_cambridge <- 1 / 8267

usethis::use_data(c14_decay_libby, overwrite = TRUE)
usethis::use_data(c14_decay_cambridge, overwrite = TRUE)
