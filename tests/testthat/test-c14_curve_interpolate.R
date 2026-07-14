# Tests for c14_curve_interpolate and helpers

# Helper to create a test curve without d14c values (common case)
test_curve <- function() {
  c14_curve(
    cal_age = era::yr(c(0, 1000, 2000, 3000, 40000), "cal BP"),
    c14_age = c(350, 1000, 2000, 3000, 40000),
    c14_error = c(5, 10, 15, 20, 25)
  )
}

# Helper to create a test curve with d14c values
test_curve_with_d14c <- function() {
  c14_curve(
    cal_age = era::yr(c(0, 1000, 2000, 3000, 40000), "cal BP"),
    c14_age = c(350, 1000, 2000, 3000, 40000),
    c14_error = c(5, 10, 15, 20, 25),
    d14c = c(40, 120, 250, 380, 5000),
    d14c_error = c(1, 2, 3, 4, 5)
  )
}

# --- c14_curve_out_of_range ---

test_that("c14_curve_out_of_range() returns FALSE for ages within range", {
  curve <- test_curve()
  expect_false(c14_curve_out_of_range(curve, era::yr(5000, "cal BP")))
})

test_that("c14_curve_out_of_range() returns TRUE for ages outside range", {
  curve <- test_curve()
  expect_true(c14_curve_out_of_range(curve, era::yr(50000, "cal BP")))
})

test_that("c14_curve_out_of_range() returns logical", {
  curve <- test_curve()
  expect_type(c14_curve_out_of_range(curve, era::yr(5000, "cal BP")), "logical")
})

# --- c14_curve_warn_if_out_of_range ---

test_that("c14_curve_warn_if_out_of_range() warns when out of range", {
  curve <- test_curve()
  expect_warning(
    c14_curve_warn_if_out_of_range(curve, era::yr(50000, "cal BP")),
    class = "c14_age_out_of_range"
  )
})

test_that("c14_curve_warn_if_out_of_range() does not warn when in range", {
  curve <- test_curve()
  expect_silent(c14_curve_warn_if_out_of_range(curve, era::yr(5000, "cal BP")))
})

# --- c14_curve_interpolation_function ---

test_that("c14_curve_interpolation_function() returns a function", {
  curve <- test_curve()
  interp <- c14_curve_interpolation_function(curve, era::yr(c(500, 1500), "cal BP"))
  expect_type(interp, "closure")
})

test_that("c14_curve_interpolation_function() interpolates correctly", {
  curve <- test_curve()
  interp <- c14_curve_interpolation_function(curve, era::yr(c(500, 1500), "cal BP"))
  result <- interp(curve$c14_age)
  expect_true(is.numeric(result))
  expect_length(result, 2)
  expect_true(result[1] >= 350 && result[1] <= 1000)
})

# --- c14_curve_interpolate ---

test_that("c14_curve_interpolate() returns a c14_curve", {
  curve <- test_curve()
  result <- c14_curve_interpolate(curve, era::yr(c(500, 1500, 2500), "cal BP"))
  expect_s3_class(result, "c14_curve")
  expect_s3_class(result, "c14_curve_14c")
})

test_that("c14_curve_interpolate() interpolates all fields", {
  curve <- test_curve()
  result <- c14_curve_interpolate(curve, era::yr(c(500, 1500, 2500), "cal BP"))
  expect_true(is.numeric(result$c14_age))
  expect_true(is.numeric(result$c14_error))
  expect_true(length(result$c14_age) == 3)
  expect_true(length(result$c14_error) == 3)
})

test_that("c14_curve_interpolate() works for c14_curve_f14c", {
  curve <- c14_fcurve(
    cal_age = era::yr(c(0, 1000, 2000, 3000, 40000), "cal BP"),
    f14c = c(1.2, 1.1, 1.0, 0.9, 0.5),
    f14c_error = c(0.001, 0.0015, 0.002, 0.0025, 0.003)
  )
  result <- c14_curve_interpolate(curve, era::yr(c(500, 1500, 2500), "cal BP"))
  expect_s3_class(result, "c14_curve_f14c")
  expect_true(is.numeric(result$f14c))
  expect_true(length(result$f14c) == 3)
})

test_that("c14_curve_interpolate() returns NA for d14c when not present", {
  curve <- test_curve()
  result <- c14_curve_interpolate(curve, era::yr(c(500, 1500, 2500), "cal BP"))
  expect_true(all(is.na(result$d14c)))
  expect_true(all(is.na(result$d14c_error)))
  expect_length(result$d14c, 3)
})

test_that("c14_curve_interpolate() interpolates d14c when present", {
  curve <- test_curve_with_d14c()
  result <- c14_curve_interpolate(curve, era::yr(c(500, 1500, 2500), "cal BP"))
  expect_true(is.numeric(result$d14c))
  expect_true(is.numeric(result$d14c_error))
  expect_true(!all(is.na(result$d14c)))
  expect_length(result$d14c, 3)
})
