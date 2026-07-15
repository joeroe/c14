# Tests for cal_relevant_indices()

# --- Return structure ---

test_that("cal_relevant_indices returns a list", {
  x <- cal(1000, 30, IntCal20)
  result <- cal_relevant_indices(x)
  expect_type(result, "list")
})

test_that("cal_relevant_indices returns one element per cal", {
  x <- cal(c(1000, 2000), c(30, 40), IntCal20)
  result <- cal_relevant_indices(x)
  expect_length(result, 2)
})

test_that("cal_relevant_indices returns integer vectors", {
  x <- cal(1000, 30, IntCal20)
  result <- cal_relevant_indices(x)
  expect_type(result[[1]], "integer")
})

test_that("cal_relevant_indices returns at least one index per cal", {
  x <- cal(c(1000, 5000, 10000), c(30, 30, 30), IntCal20)
  result <- cal_relevant_indices(x)
  expect_true(all(lengths(result) >= 1))
})

# --- Index validity ---

test_that("cal_relevant_indices indices are within curve bounds", {
  x <- cal(1000, 30, IntCal20)
  curve <- cal_c14_curve(x)
  result <- cal_relevant_indices(x)
  expect_true(all(result[[1]] >= 1))
  expect_true(all(result[[1]] <= nrow(curve)))
})

test_that("cal_relevant_indices includes the nearest curve point", {
  x <- cal(1000, 30, IntCal20)
  curve <- cal_c14_curve(x)
  nearest <- which.min(abs(curve$c14_age - 1000))
  result <- cal_relevant_indices(x)
  expect_true(nearest %in% result[[1]])
})

# --- k parameter ---

test_that("smaller k produces fewer or equal indices", {
  x <- cal(1000, 30, IntCal20)
  wide <- cal_relevant_indices(x, k = 6)
  narrow <- cal_relevant_indices(x, k = 2)
  expect_true(length(narrow[[1]]) <= length(wide[[1]]))
})

# --- Vectorized input ---

test_that("cal_relevant_indices handles vectorized cal", {
  x <- cal(c(1000, 2000, 3000), c(30, 40, 50), IntCal20)
  result <- cal_relevant_indices(x)
  expect_length(result, 3)
  expect_true(all(vapply(result, is.integer, logical(1))))
})

test_that("different dates can produce different index counts", {
  x <- cal(c(1000, 1000), c(10, 500), IntCal20)
  result <- cal_relevant_indices(x)
  expect_true(length(result[[1]]) != length(result[[2]]))
})

# --- Edge cases ---

test_that("cal_relevant_indices works with SHCal20", {
  x <- cal(1000, 30, SHCal20)
  result <- cal_relevant_indices(x)
  expect_type(result, "list")
  expect_length(result, 1)
  expect_true(length(result[[1]]) >= 1)
})

test_that("cal_relevant_indices works with length-1 vectorised call", {
  x <- cal(1000, 30, IntCal20)
  result <- cal_relevant_indices(x)
  expect_length(result, 1)
  expect_true(is.integer(result[[1]]))
})
