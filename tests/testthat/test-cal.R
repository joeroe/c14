# Tests for the cal record class (Phase 1)

# --- Constructor ---

test_that("cal() constructs a single-element cal", {
  x <- cal(1000, 30, IntCal20)
  expect_s3_class(x, "c14_cal")
  expect_s3_class(x, "vctrs_rcrd")
  expect_equal(vec_size(x), 1)
})

test_that("cal() stores correct fields", {
  x <- cal(1000, 30, IntCal20)
  expect_equal(field(x, "c14_age"), 1000)
  expect_equal(field(x, "c14_error"), 30)
  expect_s3_class(cal_c14_curve(x), "c14_curve")
})

test_that("cal() accepts custom curve", {
  x <- cal(1000, 30, curve = SHCal20)
  expect_s3_class(cal_c14_curve(x), "c14_curve")
})

test_that("cal() recycles inputs to common length", {
  x <- cal(c(1000, 2000, 3000), 30, IntCal20)
  expect_equal(vec_size(x), 3)
  expect_equal(field(x, "c14_error"), c(30, 30, 30))
})

test_that("cal() casts inputs to correct types", {
  x <- cal(1000L, 30L, IntCal20)
  expect_type(field(x, "c14_age"), "double")
  expect_type(field(x, "c14_error"), "double")
})

# --- Vctrs operations ---

test_that("cal supports subsetting", {
  x <- cal(c(1000, 2000, 3000), c(30, 40, 50), IntCal20)
  expect_equal(vec_size(x[1:2]), 2)
  expect_equal(field(x[1], "c14_age"), 1000)
})

test_that("cal supports c()", {
  x <- cal(c(1000, 2000), c(30, 40), IntCal20)
  y <- cal(c(3000), c(50), IntCal20)
  z <- c(x, y)
  expect_equal(vec_size(z), 3)
  expect_equal(field(z, "c14_age"), c(1000, 2000, 3000))
})

test_that("vec_data() returns a data frame", {
  x <- cal(c(1000, 2000), c(30, 40), IntCal20)
  d <- vec_data(x)
  expect_s3_class(d, "data.frame")
  expect_equal(names(d), c("c14_age", "c14_error"))
  expect_equal(d$c14_age, c(1000, 2000))
})

# --- Format ---

test_that("format() returns character vector", {
  x <- cal(c(1000, 2000), c(30, 40), IntCal20)
  f <- format(x)
  expect_type(f, "character")
  expect_length(f, 2)
})

test_that("format() includes age, error, and curve", {
  x <- cal(1000, 30, curve = IntCal20)
  f <- format(x)
  expect_match(f, "1000")
  expect_match(f, "30")
  expect_match(f, "IntCal20")
})

# --- Tibble integration ---

test_that("cal works in tibble columns", {
  df <- tibble::tibble(
    id = 1:2,
    c1 = cal(c(1000, 2000), c(30, 40), IntCal20)
  )
  expect_s3_class(df$c1, "c14_cal")
  expect_equal(vec_size(df), 2)
})

# --- Empty cal ---

test_that("cal() with no args produces zero-length cal with empty curve", {
  x <- cal()
  expect_s3_class(x, "c14_cal")
  expect_equal(vec_size(x), 0)
  expect_s3_class(cal_c14_curve(x), "c14_curve")
  expect_equal(nrow(cal_c14_curve(x)), 0)
})

test_that("cal() errors with class c14_invalid_curve for non-curve input", {
  expect_error(cal(1000, 30, "IntCal20"), class = "c14_invalid_curve")
})

# --- cal_function ---

test_that("cal_function() returns a function", {
  x <- cal(1000, 30, IntCal20)
  fn <- cal_function(x)
  expect_type(fn, "closure")
})

test_that("cal_function() has correct signature", {
  x <- cal(1000, 30, IntCal20)
  fn <- cal_function(x)
  expect_named(formals(fn), c("age", "offset"))
})

test_that("cal_function() errors when length(cal) != 1", {
  x <- cal(c(1000, 2000), c(30, 40), IntCal20)
  expect_error(cal_function(x), "expects a `cal` of length 1")
})

test_that("cal_function() returns numeric vector", {
  x <- cal(1000, 30, IntCal20)
  fn <- cal_function(x)
  result <- fn(era::yr(c(500, 1000, 1500), "cal BP"))
  expect_true(is.numeric(result))
  expect_length(result, 3)
})

test_that("cal_function() returns non-negative densities", {
  x <- cal(1000, 30, IntCal20)
  fn <- cal_function(x)
  result <- fn(era::yr(c(500, 1000, 1500), "cal BP"))
  expect_true(all(result >= 0))
})

# --- cal_sample ---

test_that("cal_sample() returns a function", {
  x <- cal(1000, 30, IntCal20)
  sampler <- cal_sample(x)
  expect_type(sampler, "closure")
})

test_that("cal_sample() errors when length(cal) != 1", {
  x <- cal(c(1000, 2000), c(30, 40), IntCal20)
  expect_error(cal_sample(x), "expects a `cal` of length 1")
})

test_that("cal_sample() samples correct number of values", {
  x <- cal(1000, 30, IntCal20)
  sampler <- cal_sample(x)
  result <- sampler(100)
  expect_length(result, 100)
  expect_true(is.numeric(result))
})
