x <- c14_calibrate(5000, 10)
y <- c14_calibrate(c(6000, 5000, 3000), rep(10, 3))

y_era <- era::yr_era(cal_age(y)[[1]])
y_yr_ptype <- era::yr(era = y_era)

test_that("cal_crop() with default min_pdens does nothing", {
  expect_equal(x, cal_crop(x))
})

test_that("cal_crop() returns pdens >= x if min_pdens is not 0", {
  expect_gte(min((cal_pdens(cal_crop(x, 0.001)))[[1]]), 0.001)
})

test_that("cal_age_common() returns a yr vector", {
  # TODO: somehow test the expected length?
  expect_vector(cal_age_common(y), y_yr_ptype)
})

test_that("cal_interpolate() is normalised", {
  expect_equal(sum(cal_pdens(cal_interpolate(x))[[1]]), 1)
})
