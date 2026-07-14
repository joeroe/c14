x <- cal(c(1500, 1600, 1700), rep(20, 3), "IntCal20")

test_that("cal_sum() returns a cal_dist vector of length 1", {
  expect_vector(cal_sum(x), cal_dist(), 1)
})

test_that("cal_sum(normalise = TRUE) normalised pdens to 1", {
  dist <- cal_sum(x, normalise = TRUE)
  expect_equal(sum(cal_dist_pdens(dist)[[1]]), 1)
})

test_that("sum() is an alias of cal_sum() for cal objects", {
  expect_equal(sum(x), cal_sum(x))
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
  sampler <- purrr::map(x, cal_sample)
  expect_equal(
    purrr::map_dbl(sampler, \(f) length(f(5))),
    rep(5, length(x))
  )
})

test_that("cal_bootstraps() has the expected dimensions", {
  times <- 5
  strata <- c("a", "b", "b")
  expect_equal(
    sapply(cal_bootstraps(x, times), length),
    rep(length(x), times)
  )
  expect_equal(
    sapply(cal_bootstraps(x, times, strata), length),
    rep(length(x), times)
  )
})
