test_that("as_cal_dist.data.frame works", {
  df <- data.frame(age = 1:10, pdens = rep(0.1, 10))
  d <- as_cal_dist(df)
  expect_s3_class(d, "c14_cal_dist")
  expect_equal(vec_size(d), 1)
  expect_s3_class(d[[1]]$age, "era_yr")
})

test_that("as_cal_dist.matrix works", {
  m <- matrix(1:20, ncol = 2)
  d <- as_cal_dist(m)
  expect_s3_class(d, "c14_cal_dist")
  expect_equal(vec_size(d), 1)
})

test_that("as_cal_dist.CalDates works", {
  skip_if_not_installed("rcarbon")
  library(rcarbon)
  rc <- calibrate(c(1000, 2000), c(30, 40))
  d <- as_cal_dist(rc)
  expect_s3_class(d, "c14_cal_dist")
  expect_equal(vec_size(d), 2)
  expect_named(d[[1]], c("age", "pdens"))
  expect_s3_class(d[[1]]$age, "era_yr")
})

test_that("as_cal_dist.CalDates errors on calmatrix", {
  skip_if_not_installed("rcarbon")
  library(rcarbon)
  rc <- calibrate(1000, 30, calMatrix = TRUE)
  expect_error(as_cal_dist(rc), "calMatrix not yet implemented")
})

test_that("as_cal_dist.oxcAARCalibratedDate works with prior", {
  skip_if_not_installed("oxcAAR")
  library(oxcAAR)
  quickSetupOxcal()
  ox <- oxcalCalibrate(bp = 1000, std = 30, names = "test")
  d <- as_cal_dist(ox[[1]], which = "prior")
  expect_s3_class(d, "c14_cal_dist")
  expect_equal(vec_size(d), 1)
  expect_named(d[[1]], c("age", "pdens"))
  expect_s3_class(d[[1]]$age, "era_yr")
})

test_that("as_cal_dist.oxcAARCalibratedDate converts BC/AD to cal BP", {
  skip_if_not_installed("oxcAAR")
  library(oxcAAR)
  quickSetupOxcal()
  ox <- oxcalCalibrate(bp = 1000, std = 30, names = "test")
  d <- as_cal_dist(ox[[1]], which = "prior")
  dates <- ox[[1]]$raw_probabilities$dates
  expected_age <- 1950 - dates
  expect_equal(d[[1]]$age, era::yr(expected_age, "cal BP"))
})

test_that("as_cal_dist.oxcAARCalibratedDate errors on missing posterior", {
  skip_if_not_installed("oxcAAR")
  library(oxcAAR)
  quickSetupOxcal()
  ox <- oxcalCalibrate(bp = 1000, std = 30, names = "test")
  expect_error(as_cal_dist(ox[[1]], which = "posterior"), "No posterior probabilities")
})

test_that("as_cal_dist.oxcAARCalibratedDatesList works", {
  skip_if_not_installed("oxcAAR")
  library(oxcAAR)
  quickSetupOxcal()
  ox <- oxcalCalibrate(bp = c(1000, 2000), std = c(30, 40), names = c("a", "b"))
  d <- as_cal_dist(ox)
  expect_type(d, "list")
  expect_length(d, 2)
  expect_s3_class(d[[1]], "c14_cal_dist")
})

test_that("as_cal_dist.BchronCalibratedDates works", {
  skip_if_not_installed("Bchron")
  library(Bchron)
  bc <- BchronCalibrate(
    ages = c(1000, 2000),
    ageSds = c(30, 40),
    calCurves = c("intcal20", "intcal20")
  )
  d <- as_cal_dist(bc)
  expect_s3_class(d, "c14_cal_dist")
  expect_equal(vec_size(d), 2)
  expect_named(d[[1]], c("age", "pdens"))
  expect_s3_class(d[[1]]$age, "era_yr")
})
