# Point estimates ---------------------------------------------------------

test_that("cal_point() warns about multiple modes unless quiet = TRUE", {
  multimodal_cal <- cal(10400, 20, "IntCal20")
  expect_warning(cal_point(multimodal_cal), class = "c14_ambiguous_summary")
  expect_no_warning(cal_point(multimodal_cal, quiet = TRUE),
                    class = "c14_ambiguous_summary")
})

test_that("cal_point() returns era::yr vectors for different methods", {
  x <- cal(5000, 10, "IntCal20")
  
  mode_result <- cal_point(x, method = "mode")
  median_result <- cal_point(x, method = "median")
  mean_result <- cal_point(x, method = "mean")
  
  expect_s3_class(mode_result, "era_yr")
  expect_s3_class(median_result, "era_yr")
  expect_s3_class(mean_result, "era_yr")
})

test_that("cal_point() works with vectors of cal", {
  y <- cal(c(6000, 5000, 4000), rep(10, 3), "IntCal20")
  
  mode_results <- cal_point(y, method = "mode", quiet = TRUE)
  median_results <- cal_point(y, method = "median")
  mean_results <- cal_point(y, method = "mean")
  
  expect_length(mode_results, 3)
  expect_length(median_results, 3)
  expect_length(mean_results, 3)
  
  expect_s3_class(mode_results, "era_yr")
  expect_s3_class(median_results, "era_yr")
  expect_s3_class(mean_results, "era_yr")
})

# Simple ranges -----------------------------------------------------------

x <- cal(5000, 10, "IntCal20")
y <- cal(c(6000, 5000, 4000), rep(10, 3), "IntCal20")

y_era <- era::yr_era(cal_dist_age(cal_as_cal_dist(y[[1]]))[[1]])
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

test_that("cal_age_min() and cal_age_max() respect min_pdens parameter", {
  x <- cal(5000, 10, "IntCal20")
  
  min_0 <- cal_age_min(x, min_pdens = 0)
  min_high <- cal_age_min(x, min_pdens = 0.01)
  
  max_0 <- cal_age_max(x, min_pdens = 0)
  max_high <- cal_age_max(x, min_pdens = 0.01)
  
  expect_gte(as.numeric(min_high), as.numeric(min_0))
  expect_lte(as.numeric(max_high), as.numeric(max_0))
})
