# c14_curve_interpolate.R
# Functions for interpolating calibration curves at arbitrary calendar ages

# c14_curve_interpolate (S3 methods) ------------------------------------------

#' Interpolate a calibration curve at given calendar ages
#'
#' @param curve A `c14_curve` object.
#' @param at Calendar ages to interpolate at. Numeric values are treated as
#'   cal BP.
#'
#' @return
#' A `c14_curve` object of the same subclass as `curve`, with all fields
#' interpolated to the requested ages. Ages outside the curve range are `NA`.
#'
#' @noRd
#' @keywords internal
c14_curve_interpolate <- function(curve, at) {
  UseMethod("c14_curve_interpolate")
}

#' @exportS3Method
#' @noRd
#' @keywords internal
c14_curve_interpolate.c14_curve_14c <- function(curve, at) {
  c14_curve_warn_if_out_of_range(curve, at)
  interp <- c14_curve_interpolation_function(curve, at)

  c14_curve(
    cal_age = at,
    c14_age = interp(curve$c14_age),
    c14_error = interp(curve$c14_error),
    d14c = interp(curve$d14c),
    d14c_error = interp(curve$d14c_error)
  )
}

#' @exportS3Method
#' @noRd
#' @keywords internal
c14_curve_interpolate.c14_curve_f14c <- function(curve, at) {
  c14_curve_warn_if_out_of_range(curve, at)
  interp <- c14_curve_interpolation_function(curve, at)

  c14_fcurve(
    cal_age = at,
    f14c = interp(curve$f14c),
    f14c_error = interp(curve$f14c_error)
  )
}

# c14_curve_interpolate helpers -----------------------------------------------

#' Test if calendar ages are outside the calibration curve range
#'
#' @param curve A `c14_curve` object.
#' @param at Calendar ages to check.
#'
#' @return
#' A logical scalar: `TRUE` if any ages are outside the curve range, `FALSE`
#' otherwise.
#'
#' @noRd
#' @keywords internal
c14_curve_out_of_range <- function(curve, at) {
  cal_age <- curve$cal_age
  any(at < min(cal_age) | at > max(cal_age), na.rm = TRUE)
}

#' Warn if calendar ages are outside the calibration curve range
#'
#' @param curve A `c14_curve` object.
#' @param at Calendar ages to check.
#'
#' @return
#' Called for its side-effect of issuing a warning. Returns `TRUE` invisibly
#' if ages are out of range, `FALSE` otherwise.
#'
#' @noRd
#' @keywords internal
c14_curve_warn_if_out_of_range <- function(curve, at) {
  out_of_range <- c14_curve_out_of_range(curve, at)
  if (isTRUE(out_of_range)) {
    rlang::warn(
      "Some ages are outside the calibration curve range",
      class = "c14_age_out_of_range"
    )
  }
  invisible(out_of_range)
}

#' Create an interpolation function for a calibration curve
#'
#' Returns a function that, given a vector of values defined on the curve's
#' calendar age grid, returns those values interpolated to new calendar ages.
#' If the input is all `NA`, returns `NA` values of the appropriate length.
#'
#' @param curve A `c14_curve` object.
#' @param at Calendar ages to interpolate to.
#'
#' @return
#' A function of the form `function(x)` where `x` is a numeric vector of the
#' same length as the curve's `cal_age` field.
#'
#' @noRd
#' @keywords internal
c14_curve_interpolation_function <- function(curve, at) {
  cal_age <- curve$cal_age

  function(x) {
    if (all(is.na(x))) {
      rep(NA_real_, length(at))
    } else {
      stats::approx(cal_age, x, xout = at, rule = 2)$y
    }
  }
}

