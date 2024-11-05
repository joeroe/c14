c14_age <- c(7000, 8000, 9000)
c14_error <- c(10, 20, 30)

test_that("ages with pdens < min_pdens are filtered from c14_calibrate()", {
  # For rcarbon, Bchron and intcal engines
  cal_intcal <- c14_calibrate(c14_age, c14_error, engine = "intcal", min_pdens = 0.01)
  # https://github.com/joeroe/c14/issues/24
  # cal_rcarbon <- c14_calibrate(c14_age, c14_error, engine = "rcarbon", min_pdens = 0.01)
  # cal_bchron <- c14_calibrate(c14_age, c14_error, engine = "bchron", min_pdens = 0.01)
  expect_gte(min(map_dbl(cal_pdens(cal_intcal), min)), 0.01)
  # expect_gte(min(map_dbl(cal_pdens(cal_rcarbon, min)), 0.01)
  # expect_gte(min(map_dbl(cal_pdens(cal_bchron), min)), 0.01)
})

test_that('c14_calibrate() warns that min_pdens is not supported with `engine = "oxcal"`', {
  mockery::stub(c14_calibrate, "oxcAAR::quickSetupOxcal", NULL)
  mockery::stub(c14_calibrate, "oxcAAR::oxcalCalibrate",
                data.frame(x = numeric(), y = numeric()))
  expect_warning(
    c14_calibrate(c14_age, c14_error, engine = "oxcal", min_pdens = 0.01),
    class = "c14_invalid_arguments"
  )
})