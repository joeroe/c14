# c14_calibrate.R
# Functions for tidy radiocarbon calibration

#' Calibrate radiocarbon dates
#'
#' A thin wrapper of [rcarbon::calibrate()] that returns calibrated dates as a
#' single list rather than a `CalDates`` object. Useful, for example, if you want
#' to add a column of calibrated dates to an existing table with [dplyr::mutate()]
#'
#' @param cra     A vector of uncalibrated radiocarbon ages.
#' @param error   A vector of standard errors associated with `cra`
#' @param ...     Optional arguments passed to calibration function.
#' @param engine  Package to use for calibration, i.e. [rcarbon::calibrate()]
#'                (`"rcarbon"`), [oxcAAR::oxcalCalibrate()] (`"OxCal"`), or
#'                [Bchron::BchronCalibrate()] (`"Bchron"`). Default: `"rcarbon"`.
#'
#' @return A list of `cal` objects.
#' @export
#'
#' @family tidy radiocarbon functions
c14_calibrate <- function(cra, error, ...,
                          engine = c("rcarbon", "OxCal", "Bchron")) {
  engine <- rlang::arg_match(engine)

  if (engine == "rcarbon") {
    cals <- rcarbon::calibrate(cra, error, calMatrix = FALSE, ...)
  }

  else if (engine == "OxCal") {
    if(!requireNamespace("oxcAAR")) {
      stop('`engine` = "OxCal" requires package oxcAAR')
    }
    oxcAAR::quickSetupOxcal()
    cals <- oxcAAR::oxcalCalibrate(cra, error, ...)
  }

  else if (engine == "Bchron") {
    if(!requireNamespace("Bchron")) {
      stop('`engine` = "Bchron" requires package Bchron')
    }

    cals <- Bchron::BchronCalibrate(cra, error, ...)
  }

  else {
    stop('`engine` must be one of "rcarbon", "OxCal" or "Bchron"')
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

#' @export
c14_calibrate_linear <- function(age, error,
                                 c14_curve = IntCal20, resolution = 1) {
  uncal <- c14_age_norm(age, error, resolution)
}


#' Generate the normal distribution of a radiocarbon age
#'
#' @param age Radiocarbon age in years.
#' @param error Error associated with the radiocarbon age in years.
#' @param resolution Desired resolution in years.
#' @param sigma Desired sigma range.
#'
#' @return
#' A vector of probability density with years as names.
#'
#' @export
#'
#' @examples
#' c14_age_norm(10000, 30)
c14_age_norm <- function(age, error, resolution = 1, sigma = 5) {
  x <- seq(from = age - error * sigma,
           to = age + error * sigma,
           by = resolution)

  d <- stats::dnorm(x, age, error)
  names(d) <- x

  # TODO: rescale to sum to 1? only if resolution != 1?
  return(d)
}