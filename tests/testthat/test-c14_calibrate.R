test_that("c14_calibrate() returns a cal vector of length 1", {
  x <- c14_calibrate(1000, 30)
  expect_s3_class(x, "c14_cal")
  expect_equal(vec_size(x), 1)
})

test_that("c14_calibrate() returns a cal vector of length 2", {
  x <- c14_calibrate(c(1000, 2000), c(10, 20))
  expect_s3_class(x, "c14_cal")
  expect_equal(vec_size(x), 2)
})

test_that("c14_calibrate() uses the specified curve", {
  x <- c14_calibrate(1000, 30, SHCal20)
  expect_s3_class(cal_curve(x)[[1]], "c14_curve")
  expect_equal(c14_curve_name(cal_curve(x)[[1]]), "SHCal20")
})

test_that("c14_calibrate() uses per-date curves", {
  x <- c14_calibrate(c(1000, 2000), c(10, 20), list(IntCal20, SHCal20))
  expect_equal(vec_size(x), 2)
  expect_equal(c14_curve_name(cal_curve(x)[[1]]), "IntCal20")
  expect_equal(c14_curve_name(cal_curve(x)[[2]]), "SHCal20")
})

test_that("c14_calibrate() errors with non-numeric age", {
  expect_error(c14_calibrate("a", 30), "numeric")
})

test_that("c14_calibrate() errors with negative error", {
  expect_error(c14_calibrate(1000, -10), "positive")
})

test_that("c14_calibrate() errors when curve is a string", {
  expect_error(c14_calibrate(1000, 30, "IntCal20"), "c14_curve")
})
