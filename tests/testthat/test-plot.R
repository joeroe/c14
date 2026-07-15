# Tests for plot.c14_cal

test_that("plot.c14_cal runs without error on single date", {
  x <- cal(1000, 30, IntCal20)
  expect_invisible(plot(x))
})

test_that("plot.c14_cal runs without error on multiple dates", {
  x <- cal(c(1000, 2000, 3000), c(30, 40, 50), IntCal20)
  expect_invisible(plot(x))
})

test_that("plot.c14_cal warns and truncates when max.plot exceeded", {
  x <- cal(rep(1000, 25), rep(30, 25), IntCal20)
  expect_warning(plot(x, max.plot = 20), class = "c14_exceeded_max_plot")
})

test_that("plot.c14_cal allows overriding max.plot", {
  x <- cal(rep(1000, 25), rep(30, 25), IntCal20)
  expect_invisible(plot(x, max.plot = 30))
})

test_that("plot.c14_cal handles empty cal", {
  x <- cal()
  expect_invisible(plot(x))
})

test_that("plot.c14_cal accepts custom parameters", {
  x <- cal(1000, 30, IntCal20)
  expect_invisible(plot(x, main = "Test", col = "red", rev_x = FALSE))
})

test_that("plot.c14_cal accepts resolution parameter", {
  x <- cal(1000, 30, IntCal20)
  expect_invisible(plot(x, resolution = 1))
  expect_invisible(plot(x, resolution = 10))
})

test_that("plot.c14_cal accepts fixed_xlim parameter", {
  x <- cal(c(1000, 2000, 3000), c(30, 40, 50), IntCal20)
  expect_invisible(plot(x, fixed_xlim = FALSE))
  expect_invisible(plot(x, fixed_xlim = TRUE))
})

test_that("plot.c14_cal accepts show_curve parameter", {
  x <- cal(c(1000, 2000, 3000), c(30, 40, 50), IntCal20)
  expect_invisible(plot(x, show_curve = FALSE))
  expect_invisible(plot(x, show_curve = TRUE))
  expect_invisible(plot(x[1], show_curve = TRUE))
})
