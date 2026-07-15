test_that("c14_age() calculates correct age from known F14C value", {
  expect_equal(c14_age(0.9239), 635.8235, tolerance = 1e-3)
})

test_that("c14_f14c() calculates correct F14C from known age", {
  expect_equal(c14_f14c(636), 0.9238797, tolerance = 1e-5)
})

test_that("c14_age() and c14_f14c() are inverses", {
  f14c_vals <- c(0.01, 0.1, 0.5, 0.9, 1.0, 1.5)
  expect_equal(c14_f14c(c14_age(f14c_vals)), f14c_vals)

  age_vals <- c(0, 100, 1000, 5000, 10000)
  expect_equal(c14_age(c14_f14c(age_vals)), age_vals)
})

test_that("c14_age() handles edge cases", {
  expect_equal(c14_age(1), 0)
  expect_equal(c14_age(0), Inf)
  expect_true(c14_age(1.5) < 0)
})

test_that("c14_f14c() handles edge cases", {
  expect_equal(c14_f14c(0), 1)
  expect_true(c14_f14c(-1000) > 1)
})

test_that("c14_age() accepts custom decay constant", {
  expect_equal(c14_age(0.9239, decay = c14::c14_decay_cambridge), 654.3449, tolerance = 1e-3)
})

test_that("c14_f14c() accepts custom decay constant", {
  expect_equal(c14_f14c(636, decay = c14::c14_decay_cambridge), 0.9259525, tolerance = 1e-5)
})

test_that("c14_age() and c14_f14c() are vectorized", {
  expect_length(c14_age(c(0.5, 0.9, 1.0)), 3)
  expect_length(c14_f14c(c(100, 1000, 5000)), 3)
})
