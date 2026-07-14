# cal_factories.R
# Functions for deriving probability distributions from cal records

#' Create a probability density function from a cal
#'
#' @param cal A `cal` object of length 1.
#'
#' @return
#' A function of the form `function(age, offset = NA)` that returns
#' unnormalized probability densities at the given calendar ages. Ages outside
#' the calibration curve range return `NA`.
#'
#' The `offset` argument is a placeholder for future use (e.g. marine reservoir
#' offsets) and is currently ignored.
#'
#' @noRd
#' @keywords internal
cal_function <- function(cal) {
  if (length(cal) != 1) {
    rlang::abort("`cal_function()` expects a `cal` of length 1.",
                 class = "c14_invalid_argument")
  }

  c14_age <- field(cal, "c14_age")
  c14_error <- field(cal, "c14_error")
  curve <- cal_curve(cal)[[1]]

  function(age, offset = NA) {
    curve_at <- c14_curve_interpolate(curve, age)
    sd <- sqrt(c14_error^2 + field(curve_at, "c14_error")^2)
    stats::dnorm(c14_age, mean = field(curve_at, "c14_age"), sd = sd)
  }
}

#' Create a sampling function from a cal
#'
#' @param cal A `cal` object of length 1.
#'
#' @return
#' A function of the form `function(n)` that returns `n` random samples drawn
#' from the calibrated distribution.
#'
#' @noRd
#' @keywords internal
cal_sample <- function(cal) {
  if (length(cal) != 1) {
    rlang::abort("`cal_sample()` expects a `cal` of length 1.",
                 class = "c14_invalid_argument")
  }

  f <- cal_function(cal)
  curve <- cal_curve(cal)[[1]]
  ages <- c14_curve_age_seq(curve)
  pdens <- f(ages)

  function(n) {
    valid <- !is.na(pdens)
    sample(ages[valid], n, replace = TRUE, prob = pdens[valid])
  }
}
