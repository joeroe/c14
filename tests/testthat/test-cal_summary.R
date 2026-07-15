# Point estimates ---------------------------------------------------------

test_that("cal_point() warns about multiple modes unless quiet = TRUE", {
  multimodal_cal <- cal(10400, 20, IntCal20)
  expect_warning(cal_point(multimodal_cal), class = "c14_ambiguous_summary")
  expect_no_warning(cal_point(multimodal_cal, quiet = TRUE),
                    class = "c14_ambiguous_summary")
})

test_that("cal_point() returns era::yr vectors for different methods", {
  x <- cal(5000, 10, IntCal20)
  
  mode_result <- cal_point(x, method = "mode")
  median_result <- cal_point(x, method = "median")
  mean_result <- cal_point(x, method = "mean")
  
  expect_s3_class(mode_result, "era_yr")
  expect_s3_class(median_result, "era_yr")
  expect_s3_class(mean_result, "era_yr")
})

test_that("cal_point() works with vectors of cal", {
  y <- cal(c(6000, 5000, 4000), rep(10, 3), IntCal20)
  
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

x <- cal(5000, 10, IntCal20)
y <- cal(c(6000, 5000, 4000), rep(10, 3), IntCal20)

y_era <- era::yr_era(cal_dist_age(cal_dist(y[[1]]))[[1]])
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
  x <- cal(5000, 10, IntCal20)
  
  # NULL (default) uses sparse grid with no filtering
  min_default <- cal_age_min(x)
  
  # 0 (explicit) uses full curve range
  min_full <- cal_age_min(x, min_pdens = 0)
  
  # > 0 uses sparse grid with filtering
  min_filtered <- cal_age_min(x, min_pdens = 0.01)
  
  max_default <- cal_age_max(x)
  max_full <- cal_age_max(x, min_pdens = 0)
  max_filtered <- cal_age_max(x, min_pdens = 0.01)
  
  # Full curve should give wider or equal range compared to sparse grid
  expect_lte(as.numeric(min_full), as.numeric(min_default))
  expect_gte(as.numeric(max_full), as.numeric(max_default))
  
  # Filtered should give narrower or equal range compared to default
  expect_gte(as.numeric(min_filtered), as.numeric(min_default))
  expect_lte(as.numeric(max_filtered), as.numeric(max_default))
})

# Highest Density Regions -------------------------------------------------

test_that("cal_hdr() returns a list of the same length as x", {
  x <- cal(5000, 10, IntCal20)
  y <- cal(c(6000, 5000, 4000), rep(10, 3), IntCal20)
  
  result_x <- cal_hdr(x)
  result_y <- cal_hdr(y)
  
  expect_length(result_x, length(x))
  expect_length(result_y, length(y))
})

test_that("cal_hdr() returns intervals with correct structure", {
  x <- cal(5000, 10, IntCal20)
  result <- cal_hdr(x)
  
  expect_type(result, "list")
  expect_type(result[[1]], "list")
  
  for (interval in result[[1]]) {
    expect_type(interval, "double")
    expect_length(interval, 2)
    expect_lte(interval[1], interval[2])
  }
})

test_that("cal_hdr() respects the interval parameter", {
  x <- cal(5000, 10, IntCal20)
  
  hdr_68 <- cal_hdr(x, interval = 0.683)
  hdr_95 <- cal_hdr(x, interval = 0.954)
  
  total_width_68 <- sum(sapply(hdr_68[[1]], function(iv) iv[2] - iv[1]))
  total_width_95 <- sum(sapply(hdr_95[[1]], function(iv) iv[2] - iv[1]))
  
  expect_lt(total_width_68, total_width_95)
})

test_that("cal_hdr() handles multimodal distributions", {
  multimodal_cal <- cal(10400, 20, IntCal20)
  result <- cal_hdr(multimodal_cal)
  
  expect_type(result, "list")
  expect_gte(length(result[[1]]), 1)
})

test_that("cal_hdr() intervals are contained within age range", {
  x <- cal(5000, 10, IntCal20)
  result <- cal_hdr(x)
  
  age_min <- cal_age_min(x)
  age_max <- cal_age_max(x)
  
  for (interval in result[[1]]) {
    expect_gte(as.numeric(interval[1]), as.numeric(age_min))
    expect_lte(as.numeric(interval[2]), as.numeric(age_max))
  }
})

# Highest Density Intervals -----------------------------------------------

test_that("cal_hdi() returns a list of the same length as x", {
  x <- cal(5000, 10, IntCal20)
  y <- cal(c(6000, 5000, 4000), rep(10, 3), IntCal20)
  
  result_x <- cal_hdi(x)
  result_y <- cal_hdi(y)
  
  expect_length(result_x, length(x))
  expect_length(result_y, length(y))
})

test_that("cal_hdi() returns a single interval with correct structure", {
  x <- cal(5000, 10, IntCal20)
  result <- cal_hdi(x)
  
  expect_type(result, "list")
  expect_length(result[[1]], 2)
  expect_lte(as.numeric(result[[1]][1]), as.numeric(result[[1]][2]))
})

test_that("cal_hdi() respects the interval parameter", {
  x <- cal(5000, 10, IntCal20)
  
  hdi_68 <- cal_hdi(x, interval = 0.683)
  hdi_95 <- cal_hdi(x, interval = 0.954)
  
  width_68 <- as.numeric(hdi_68[[1]][2]) - as.numeric(hdi_68[[1]][1])
  width_95 <- as.numeric(hdi_95[[1]][2]) - as.numeric(hdi_95[[1]][1])
  
  expect_lt(width_68, width_95)
})

test_that("cal_hdi() returns a single interval even for multimodal distributions", {
  multimodal_cal <- cal(10400, 20, IntCal20)
  result <- cal_hdi(multimodal_cal)
  
  expect_type(result, "list")
  expect_length(result[[1]], 2)
})

test_that("cal_hdi() interval is contained within age range", {
  x <- cal(5000, 10, IntCal20)
  result <- cal_hdi(x)
  
  age_min <- cal_age_min(x)
  age_max <- cal_age_max(x)
  
  expect_gte(as.numeric(result[[1]][1]), as.numeric(age_min))
  expect_lte(as.numeric(result[[1]][2]), as.numeric(age_max))
})

test_that("cal_hdi() is contained within cal_hdr()", {
  x <- cal(5000, 10, IntCal20)
  
  hdi_result <- cal_hdi(x, interval = 0.954)[[1]]
  hdr_intervals <- cal_hdr(x, interval = 0.954)[[1]]
  
  hdr_min <- min(sapply(hdr_intervals, function(iv) iv[1]))
  hdr_max <- max(sapply(hdr_intervals, function(iv) iv[2]))
  
  expect_gte(as.numeric(hdi_result[1]), as.numeric(hdr_min))
  expect_lte(as.numeric(hdi_result[2]), as.numeric(hdr_max))
})

# Probability within an interval -------------------------------------------

test_that("cal_probability() returns numeric vector same length as x", {
  x <- cal(c(5000, 6000), rep(10, 2), IntCal20)
  result <- cal_probability(x, 4900, 5100)

  expect_type(result, "double")
  expect_length(result, 2)
})

test_that("cal_probability() values are between 0 and 1", {
  x <- cal(5000, 10, IntCal20)
  result <- cal_probability(x, 4900, 5100)

  expect_gte(result, 0)
  expect_lte(result, 1)
})

test_that("cal_probability() with to = NULL returns point probability", {
  x <- cal(5000, 10, IntCal20)
  result <- cal_probability(x, 5000)

  expect_type(result, "double")
  expect_length(result, 1)
  expect_gte(result, 0)
  expect_lte(result, 1)
})

test_that("cal_probability() with from == to matches to = NULL", {
  x <- cal(5000, 10, IntCal20)
  point <- cal_probability(x, 5000)
  range_same <- cal_probability(x, 5000, 5000)

  expect_equal(point, range_same)
})

test_that("cal_probability() probability increases with wider range", {
  x <- cal(5000, 10, IntCal20)
  narrow <- cal_probability(x, 5700, 5800)
  wide <- cal_probability(x, 5650, 5850)

  expect_lt(narrow, wide)
})

test_that("cal_probability() of HDI interval is at least its probability content", {
  x <- cal(5000, 10, IntCal20)
  hdi <- cal_hdi(x, interval = 0.954)[[1]]
  prob <- cal_probability(x, hdi[1], hdi[2])

  expect_gte(prob, 0.954)
  expect_lte(prob, 1)
})

test_that("cal_probability() is accurate at coarse-grid ages", {
  # c14_age = 20000 BP falls in the 10-year-resolution region of IntCal20
  # (plausible cal BP range ~23440-24600). Without 1-year-resolution
  # evaluation, queries at non-grid years would return 0 (no native-grid
  # point in range) and range sums would underestimate the true mass.
  x <- cal(20000, 50, IntCal20)

  # Query at non-grid years within the plausible range — would be 0 without
  # 1-year interpolation.
  result <- cal_probability(x, 24005, 24015)
  expect_gt(result, 0)
  expect_lt(result, 1)

  # Wider range contains more probability than narrower range.
  narrow <- cal_probability(x, 24000, 24010)
  wide <- cal_probability(x, 23500, 24500)
  expect_lt(narrow, wide)
})
