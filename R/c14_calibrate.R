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
#' @return A list of `cal` objects.
#' @export
#'
#' @family tidy radiocarbon functions
c14_calibrate <- function(c14_age,
                          c14_error,
                          ...,
                          engine = c("intcal", "rcarbon", "oxcal", "bchron")) {
  engine <- rlang::arg_match(engine)

  if (engine == "intcal") {
    cals <- IntCal::caldist(c14_age, c14_error)
  }

  else if (engine == "rcarbon") {
    if(!requireNamespace("rcarbon", quietly = TRUE)) {
      stop('`engine` = "rcarbon" requires package rcarbon')
    }
    cals <- rcarbon::calibrate(c14_age, c14_error, calMatrix = FALSE,
                               verbose = FALSE, ...)
  }

  else if (engine == "oxcal") {
    if(!requireNamespace("oxcAAR", quietly = TRUE)) {
      stop('`engine` = "OxCal" requires package oxcAAR')
    }
    oxcAAR::quickSetupOxcal()
    cals <- oxcAAR::oxcalCalibrate(c14_age, c14_error, ...)
  }

  else if (engine == "bchron") {
    if(!requireNamespace("Bchron", quietly = TRUE)) {
      stop('`engine` = "Bchron" requires package Bchron')
    }

    cals <- Bchron::BchronCalibrate(c14_age, c14_error, ...)
  }

  cals <- as_cal(cals)
  return(cals)
}

#' Sum radiocarbon dates with tidy syntax
#'
#' A wrapper for [rcarbon::spd()] that takes a list of calibrated dates rather
#' than a `CalDates` object. This allows you to use the output of [c14_calibrate()] and
#' take advantage of tidy summary syntax ([dplyr::group_by()], etc.)
#'
#' @param cal        A list of `cal` objects.
#' @param time_range Vector of length 2 indicating the range of calendar dates
#'                   over which to sum. If left `NA`, the maximum range of the
#'                   `cal` will be used. See details.
#' @param ...        Optional arguments to be passed to [rcarbon::spd()]
#'
#' @return
#' A `calGrid` object containing the summed probability distribution.
#'
#' @export
#'
#' @details
#' Unlike [rcarbon::spd()], this function will attempt to guess an appropriate
#' time range if it isn't explicitly specified with `time_range`. It's probably
#' a good idea to specify it.
#'
#' @family tidy radiocarbon functions
c14_sum <- function(cal, time_range = NA, ...) {
  cal_dates <- as.CalDates.cal(cal)

  if(is.na(time_range)) {
    time_range <- c(min.cal(cal), max.cal(cal))
  }

  summed <- rcarbon::spd(cal_dates, timeRange = time_range, ...)
  return(list(summed$grid))
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