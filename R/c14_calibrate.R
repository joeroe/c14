# c14_calibrate.R
# Functions for tidy radiocarbon calibration

#' Calibrate radiocarbon dates
#'
#' Transforms 'raw' radiocarbon ages into a calendar probability distribution
#' using a calibration curve.
#'
#' @param c14_age   Vector of uncalibrated radiocarbon ages.
#' @param c14_error Vector of standard errors associated with `c14_age`.
#' @param c14_curve A [c14_curve] object or list of `c14_curve` objects. See
#'   [c14_curves] for a list of the standard curves provided with the packages. 
#'   Default: `IntCal20`.
#'
#' @return A `cal` vector.
#' @export
#'
#' @family tidy radiocarbon functions
#'
#' @examples
#' c14_calibrate(1000, 30)
#' c14_calibrate(1000, 30, IntCal20)
c14_calibrate <- function(c14_age, c14_error, c14_curve = IntCal20) {
  if (!is.numeric(c14_age)) {
    rlang::abort("`c14_age` must be numeric.", class = "c14_invalid_argument")
  }
  if (!is.numeric(c14_error)) {
    rlang::abort("`c14_error` must be numeric.", class = "c14_invalid_argument")
  }
  if (any(c14_error <= 0, na.rm = TRUE)) {
    rlang::abort("`c14_error` must be positive.", class = "c14_invalid_argument")
  }

  cal(c14_age, c14_error, c14_curve)
}

#' Generate the normal distribution of a radiocarbon age
#'
#' @param age Radiocarbon age(s) in years.
#' @param error Error(s) associated with the radiocarbon age in years.
#' @param resolution Desired resolution in years.
#' @param sigma Desired sigma range.
#'
#' @details
#' `age` and `error` are recycled to a common length.
#'
#' @return
#' A vector of probability density with years as names.
#' If `age` or `error` has length >= 1, a list of these vectors.
#'
#' @export
#'
#' @examples
#' c14_age_norm(10000, 30)
c14_age_norm <- function(age, error, resolution = 1, sigma = 5) {
  c(age, error) %<-% vec_recycle_common(age, error)

  lower <- age - error * sigma
  upper <- age + error * sigma
  x <- purrr::map2(lower, upper, seq, by = resolution)

  d <- purrr::pmap(list(x, age, error), stats::dnorm)
  d <- purrr::map2(d, x, rlang::set_names)

  if (vec_size(d) == 1) d <- d[[1]]

  # TODO: rescale to sum to 1? only if resolution != 1?
  return(d)
}
