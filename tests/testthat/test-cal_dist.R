# Tests for the cal_dist list_of class (Phase 1)

# --- Constructor ---

test_that("cal_dist() constructs a single-element cal_dist", {
  d <- cal_dist(data.frame(age = era::yr(1:10, "cal BP"), pdens = rep(0.1, 10)))
  expect_s3_class(d, "c14_cal_dist")
  expect_s3_class(d, "vctrs_vctr")
  expect_equal(vec_size(d), 1)
})

test_that("cal_dist() stores data frames with age and pdens columns", {
  d <- cal_dist(data.frame(age = era::yr(1:10, "cal BP"), pdens = rep(0.1, 10)))
  el <- d[[1]]
  expect_s3_class(el, "data.frame")
  expect_named(el, c("age", "pdens"))
  expect_s3_class(el$age, "era_yr")
})

test_that("cal_dist() constructs multiple elements", {
  d1 <- data.frame(age = era::yr(1:10, "cal BP"), pdens = rep(0.1, 10))
  d2 <- data.frame(age = era::yr(20:30, "cal BP"), pdens = rep(0.09, 11))
  d <- cal_dist(d1, d2)
  expect_equal(vec_size(d), 2)
})

test_that("cal_dist() coerces age to era::yr", {
  d <- cal_dist(data.frame(age = 1:10, pdens = rep(0.1, 10)))
  expect_s3_class(d[[1]]$age, "era_yr")
})

# --- Vctrs operations ---

test_that("cal_dist supports subsetting", {
  d1 <- data.frame(age = era::yr(1:10, "cal BP"), pdens = rep(0.1, 10))
  d2 <- data.frame(age = era::yr(20:30, "cal BP"), pdens = rep(0.09, 11))
  d <- cal_dist(d1, d2)
  expect_equal(vec_size(d[1]), 1)
  expect_equal(vec_size(d[1:2]), 2)
})

test_that("cal_dist supports c()", {
  d1 <- cal_dist(data.frame(age = era::yr(1:10, "cal BP"), pdens = rep(0.1, 10)))
  d2 <- cal_dist(data.frame(age = era::yr(20:30, "cal BP"), pdens = rep(0.09, 11)))
  d <- c(d1, d2)
  expect_equal(vec_size(d), 2)
})

test_that("vec_data() returns a list of data frames", {
  d <- cal_dist(data.frame(age = era::yr(1:10, "cal BP"), pdens = rep(0.1, 10)))
  data <- vec_data(d)
  expect_type(data, "list")
  expect_equal(length(data), 1)
})

# --- Format ---

test_that("format() returns character vector", {
  d <- cal_dist(data.frame(age = era::yr(1:10, "cal BP"), pdens = rep(0.1, 10)))
  f <- format(d)
  expect_type(f, "character")
  expect_length(f, 1)
})

test_that("cal_dist works in tibble columns", {
  d <- cal_dist(data.frame(age = era::yr(1:10, "cal BP"), pdens = rep(0.1, 10)))
  df <- tibble::tibble(id = 1, d = d)
  expect_equal(vec_size(df), 1)
})

# --- cal_dist.cal ---

test_that("cal_dist() returns a cal_dist of length 1 from a cal of length 1", {
  x <- cal(1000, 30, IntCal20)
  d <- cal_dist(x)
  expect_s3_class(d, "c14_cal_dist")
  expect_equal(vec_size(d), 1)
})

test_that("cal_dist() returns a cal_dist of the same length as cal", {
  x <- cal(c(1000, 2000), c(30, 40), IntCal20)
  d <- cal_dist(x)
  expect_s3_class(d, "c14_cal_dist")
  expect_equal(vec_size(d), 2)
})

test_that("cal_dist() uses curve's native resolution when at = NULL", {
  x <- cal(1000, 30, IntCal20)
  d <- cal_dist(x)
  el <- d[[1]]
  expect_true(nrow(el) > 0)
})

test_that("cal_dist() respects custom at parameter", {
  x <- cal(1000, 30, IntCal20)
  at <- era::yr(seq(0, 40000, by = 1000), "cal BP")
  d <- cal_dist(x, at = at)
  el <- d[[1]]
  expect_true(nrow(el) == length(at))
})

# --- cal_dist_age_min / cal_dist_age_max ---

test_that("cal_dist_age_min() returns correct minimum age", {
  d <- cal_dist(data.frame(age = era::yr(1:10, "cal BP"), pdens = rep(0.1, 10)))
  expect_equal(cal_dist_age_min(d), era::yr(1, "cal BP"))
})

test_that("cal_dist_age_max() returns correct maximum age", {
  d <- cal_dist(data.frame(age = era::yr(1:10, "cal BP"), pdens = rep(0.1, 10)))
  expect_equal(cal_dist_age_max(d), era::yr(10, "cal BP"))
})
