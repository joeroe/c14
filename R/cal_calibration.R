# cal_calibration.R
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
  curve <- cal_c14_curve(cal)

  function(age, offset = NA) {
    curve_at <- c14_curve_interpolate(curve, age)
    sd <- sqrt(c14_error^2 + curve_at$c14_error^2)
    stats::dnorm(c14_age, mean = curve_at$c14_age, sd = sd)
  }
}

#' Create a sparse probability density function from a cal
#'
#' Like `cal_function()`, but only evaluates on the calibration curve's native
#' grid. Errors if ages are not on the grid. This is significantly faster than
#' `cal_function()` when evaluating on the native grid because it avoids
#' interpolation overhead.
#'
#' @param cal A `cal` object of length 1.
#'
#' @return
#' A function of the form `function(age, offset = NA)` that returns
#' unnormalized probability densities at the given calendar ages. Ages not on
#' the calibration curve's native grid cause an error.
#'
#' The `offset` argument is a placeholder for future use (e.g. marine reservoir
#' offsets) and is currently ignored.
#'
#' @noRd
#' @keywords internal
cal_function_sparse <- function(cal) {
  if (length(cal) != 1) {
    rlang::abort("`cal_function_sparse()` expects a `cal` of length 1.",
                 class = "c14_invalid_argument")
  }

  c14_age <- field(cal, "c14_age")
  c14_error <- field(cal, "c14_error")
  curve <- cal_c14_curve(cal)
  cal_age_grid <- curve$cal_age
  cal_age_grid_numeric <- vctrs::vec_data(cal_age_grid)

  function(age, offset = NA) {
    if (era::is_yr(age)) {
      age_numeric <- vctrs::vec_data(age)
    } else {
      age_numeric <- age
    }

    matches <- match(age_numeric, cal_age_grid_numeric)

    off_grid <- is.na(matches)
    if (any(off_grid)) {
      rlang::abort(
        paste0("`cal_function_sparse()` can only evaluate on the calibration curve's native grid. ",
               "Found ", sum(off_grid), " age(s) not on the grid."),
        class = "c14_age_not_on_grid"
      )
    }

    curve_c14_age <- curve$c14_age[matches]
    curve_c14_error <- curve$c14_error[matches]
    sd <- sqrt(c14_error^2 + curve_c14_error^2)
    stats::dnorm(c14_age, mean = curve_c14_age, sd = sd)
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

  indices <- cal_relevant_indices(cal)
  curve <- cal_c14_curve(cal)
  ages_range <- range(curve$cal_age[indices])
  ages <- seq(from = ages_range[1], to = ages_range[2], by = 1)
  
  f <- cal_function(cal)
  pdens <- f(ages)

  function(n) {
    valid <- !is.na(pdens)
    sample(ages[valid], n, replace = TRUE, prob = pdens[valid])
  }
}

#' Find relevant curve indices for a cal object
#'
#' Finds indices of calibration curve points where the density is likely to be
#' non-negligible. Uses a heuristic based on the combined error of the date and
#' curve.
#'
#' @param cal A `cal` object of length 1.
#' @param k Number of standard deviations to include. Default: 6 (covers 99.9999998%).
#'
#' @return Integer vector of indices into the calibration curve.
#'
#' @noRd
#' @keywords internal
cal_relevant_indices <- function(cal, k = 6) {
  if (length(cal) != 1) {
    rlang::abort("`cal_relevant_indices()` expects a `cal` of length 1.",
                 class = "c14_invalid_argument")
  }

  c14_age <- field(cal, "c14_age")
  c14_error <- field(cal, "c14_error")
  curve <- cal_c14_curve(cal)

  combined_error <- sqrt(c14_error^2 + curve$c14_error^2)
  which(abs(curve$c14_age - c14_age) < k * combined_error)
}

