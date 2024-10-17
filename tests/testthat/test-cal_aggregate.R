x <- c14_calibrate(c(1500, 1600, 1700), rep(20, 3))

test_that("cal_sum() returns a cal vector of length 1", {
  expect_vector(cal_sum(x), cal(), 1)
})
