x <- c14_calibrate(c(1500, 1600, 1700), rep(20, 3))

test_that("cal_sum() returns a cal vector of length 1", {
  expect_vector(cal_sum(x), cal(), 1)
})

test_that("cal_sum(normalise = TRUE) normalised pdens to 1", {
  expect_equal(sum(cal_pdens(cal_sum(x, normalise = TRUE))[[1]]), 1)
})

test_that("cal_density() has the expected prototype", {
  expect_vector(
    cal_density(x),
    tibble::tibble(
      age = era::yr(era = "cal BP"),
      .estimate = numeric(),
      .error = numeric()
    ),
    size = length(cal_age_common(x))
  )
})

test_that("density() is an alias for cal_density() for cal objects", {
  # set tolerance to compensate for non-determinism in stats::density()
  expect_equal(density(x), cal_density(x), tolerance = 0.005)
})

test_that("cal_sample() has the expected dimensions", {
  times <- 5
  expect_equal(sapply(cal_sample(x, times), length), rep(times, length(x)))
})