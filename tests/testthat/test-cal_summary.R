# Point estimates ---------------------------------------------------------

test_that("cal_point() warns about multiple modes unless quiet = TRUE", {
  multimodal_cal <- c14_calibrate(10400, 20)
  expect_warning(cal_point(multimodal_cal), class = "c14_ambiguous_summary")
  expect_no_warning(cal_point(multimodal_cal, quiet = TRUE),
                    class = "c14_ambiguous_summary")
})

# Simple ranges -----------------------------------------------------------

x <- c14_calibrate(5000, 10)
y <- c14_calibrate(c(6000, 5000, 4000), rep(10, 3))

y_era <- era::yr_era(cal_age(y)[[1]])
y_yr_ptype <- era::yr(era = y_era)

test_that("cal_age_min() and cal_age_max() return a yr vector of the same length as x", {
  expect_vector(cal_age_min(y), y_yr_ptype, length(y))
  expect_vector(cal_age_max(y), y_yr_ptype, length(y))
})

test_that("cal_age_min() is less than or equal to cal_age_max()", {
  expect_lte(cal_age_min(x), cal_age_max(x))
})

test_that("cal_age_range() returns a two-column data frame of the same length as x", {
  expect_vector(
    cal_age_range(y),
    data_frame(min = y_yr_ptype, max = y_yr_ptype),
    size = length(y)
  )
})
