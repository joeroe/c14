# Tests for the cal record class (Phase 1)

# --- Constructor ---

test_that("cal() constructs a single-element cal", {
  x <- cal(1000, 30)
  expect_s3_class(x, "c14_cal")
  expect_s3_class(x, "vctrs_rcrd")
  expect_equal(vec_size(x), 1)
})

test_that("cal() stores correct fields", {
  x <- cal(1000, 30)
  expect_equal(field(x, "c14_age"), 1000)
  expect_equal(field(x, "c14_error"), 30)
  expect_equal(field(x, "c14_curve"), "IntCal20")
})

test_that("cal() defaults c14_curve to IntCal20", {
  x <- cal(1000, 30)
  expect_equal(field(x, "c14_curve"), "IntCal20")
})

test_that("cal() accepts custom c14_curve", {
  x <- cal(1000, 30, c14_curve = "SHCal20")
  expect_equal(field(x, "c14_curve"), "SHCal20")
})

test_that("cal() recycles inputs to common length", {
  x <- cal(c(1000, 2000, 3000), 30)
  expect_equal(vec_size(x), 3)
  expect_equal(field(x, "c14_error"), c(30, 30, 30))
})

test_that("cal() casts inputs to correct types", {
  x <- cal(1000L, 30L)
  expect_type(field(x, "c14_age"), "double")
  expect_type(field(x, "c14_error"), "double")
})

# --- Vctrs operations ---

test_that("cal supports subsetting", {
  x <- cal(c(1000, 2000, 3000), c(30, 40, 50))
  expect_equal(vec_size(x[1:2]), 2)
  expect_equal(field(x[1], "c14_age"), 1000)
})

test_that("cal supports c()", {
  x <- cal(c(1000, 2000), c(30, 40))
  y <- cal(c(3000), c(50))
  z <- c(x, y)
  expect_equal(vec_size(z), 3)
  expect_equal(field(z, "c14_age"), c(1000, 2000, 3000))
})

test_that("vec_data() returns a data frame", {
  x <- cal(c(1000, 2000), c(30, 40))
  d <- vec_data(x)
  expect_s3_class(d, "data.frame")
  expect_equal(names(d), c("c14_age", "c14_error", "c14_curve"))
  expect_equal(d$c14_age, c(1000, 2000))
})

# --- Format ---

test_that("format() returns character vector", {
  x <- cal(c(1000, 2000), c(30, 40))
  f <- format(x)
  expect_type(f, "character")
  expect_length(f, 2)
})

test_that("format() includes age, error, and curve", {
  x <- cal(1000, 30, c14_curve = "IntCal20")
  f <- format(x)
  expect_match(f, "1000")
  expect_match(f, "30")
  expect_match(f, "IntCal20")
})

# --- Tibble integration ---

test_that("cal works in tibble columns", {
  df <- tibble::tibble(
    id = 1:2,
    c1 = cal(c(1000, 2000), c(30, 40))
  )
  expect_s3_class(df$c1, "c14_cal")
  expect_equal(vec_size(df), 2)
})
