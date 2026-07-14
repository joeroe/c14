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

# --- Format (expected to fail until Phase 3) ---

test_that("format() returns character vector", {
  skip("Requires cal_point() from Phase 3")
  d <- cal_dist(data.frame(age = era::yr(1:10, "cal BP"), pdens = rep(0.1, 10)))
  f <- format(d)
  expect_type(f, "character")
  expect_length(f, 1)
})

test_that("cal_dist works in tibble columns", {
  skip("Requires cal_point() from Phase 3 for pillar display")
  d <- cal_dist(data.frame(age = era::yr(1:10, "cal BP"), pdens = rep(0.1, 10)))
  df <- tibble::tibble(id = 1, d = d)
  expect_equal(vec_size(df), 1)
})
