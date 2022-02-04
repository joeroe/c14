# c14_calibrate.R
# Functions for tidy radiocarbon calibration

#' Calibrate radiocarbon dates
#'
#' Transforms 'raw' radiocarbon ages into a calendar probability distribution
#' using a calibration curve.
#'
#' @param c14_age   Vector of uncalibrated radiocarbon ages.
#' @param c14_error Vector of standard errors associated with `c14_age`.
#' @param ...       Optional arguments passed to calibration function (see below).
#' @param engine    Method to use for calibration. The default (`"intcal"`) is
#'   fast and simple. Other options require additional packages to be installed.
#'   Available engines:
#'   * `"intcal"`: [IntCal::caldist()] (default)
#'   * `"rcarbon"`: [rcarbon::calibrate()]
#'   * `"oxcal"`: [oxcAAR::oxcalCalibrate()]
#'   * `"bchron"`: [Bchron::BchronCalibrate()]
#'
#' @details
#' `c14_age` and `c14_error` are recycled to a common length.
#'
#' Parallelisation is supported for engines `"intcal"` and `"rcarbon"` and can
#' dramatically speed up calibration of large numbers of dates. For `"intcal"`,
#' it must first be enabled with [future::plan()]. For `"rcarbon"`, it requires
#' the `doSNOW` package and can be controlled with the `ncores` argument of
#' [rcarbon::calibrate()].
#'
#' @return A list of `cal` objects.
#' @export
#'
#' @family tidy radiocarbon functions
c14_calibrate <- function(c14_age,
                          c14_error,
                          ...,
                          engine = c("intcal", "rcarbon", "oxcal", "bchron"),
                          n_cores = parallel::detectCores()) {
  c(c14_age, c14_error) %<-% vec_recycle_common(c14_age, c14_error)
  engine <- rlang::arg_match(engine)


  if (engine == "intcal") {
    cals <- c14_calibrate_intcal(c14_age, c14_error, ...)
  }

  else if (engine == "rcarbon") {
    if(!requireNamespace("rcarbon", quietly = TRUE)) {
      stop('`engine` = "rcarbon" requires package rcarbon')
    }
    cals <- rcarbon::calibrate(c14_age, c14_error, calMatrix = FALSE,
                               verbose = FALSE, ...)
    cals <- as_cal(cals)
  }

  else if (engine == "oxcal") {
    if(!requireNamespace("oxcAAR", quietly = TRUE)) {
      stop('`engine` = "OxCal" requires package oxcAAR')
    }
    oxcAAR::quickSetupOxcal()
    cals <- oxcAAR::oxcalCalibrate(c14_age, c14_error, ...)
    cals <- as_cal(cals)
  }

  else if (engine == "bchron") {
    if(!requireNamespace("Bchron", quietly = TRUE)) {
      stop('`engine` = "Bchron" requires package Bchron')
    }
    cals <- Bchron::BchronCalibrate(c14_age, c14_error, ...)
    cals <- as_cal(cals)
  }

  return(cals)
}

#' Vectorised wrapper for IntCal::caldist
#'
#' @return
#' A cal vector.
#'
#' @noRd
#' @keywords internal
c14_calibrate_intcal <- function(c14_age, c14_error, ...) {
  furrr::future_map2(c14_age, c14_error, IntCal::caldist, ...) |>
    furrr::future_map(as.data.frame) |>
    do.call(what = cal)
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