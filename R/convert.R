# convert.R
# Functions for converting foreign objects to or from c14 classes

#' Convert a foreign object to a cal object
#'
#' @description
#' `as_cal()` converts objects from other packages that represent calibrated
#' radiocarbon dates to the c14 `cal` class.
#' Methods are currently implemented for:
#'
#' * `CalDates`: from [rcarbon::calibrate()]
#' * `oxcAARCalibratedDate` and `oxcAARCalibratedDatesList`: from [oxcAAR::oxcalCalibrate()]
#' * `BchronCalibratedDates`: from [Bchron::BchronCalibrate()]
#'
#' These functions are intended for complex S3 objects from other packages.
#' See [cal()] for a more generic constructor, e.g. using a data frame.
#'
#' @param x  Object from another package to be converted to a `cal` object.
#'
#' @returns
#' Vector of class `c14_cal` ([cal]).
#'
#' @family cal class methods
#' @family c14 conversion functions
#'
#' @export
as_cal <- function(x) UseMethod("as_cal")

#' @rdname as_cal
#' @export
as_cal.CalDates <- function(x) {
  if(!is.na(x$calmatrix)) {
    warning("calMatrix object in CalDates ignored.")
  }

  caldates <- cal_recode_metadata(x$metadata, "CalDates", "cal")
  caldates$pd <- purrr::map(x$grids, as_calp)
  caldates$engine <- "rcarbon"
  caldates$engine_version <- utils::packageVersion("rcarbon")

  do.call(new_cal, caldates)
}

#' Convert cal objects to an rcarbon CalDates object
#'
#' @param x  A list of `cal` objects.
#'
#' @return
#' A `CalDates` object. See [rcarbon::calibrate()] for details.
#'
#' @family c14 conversion functions
#'
#' @export
as.CalDates.cal <- function(x) {
  x <- purrr::map(x, cal_repair_calibration_range)

  metadata <- purrr::map(x, cal_metadata)
  metadata <- purrr::map_dfr(metadata, cal_recode_metadata,
                             from = "cal", to = "CalDates")
  metadata <- as.data.frame(metadata)

  grids <- purrr::map(x, data.frame)
  grids <- purrr::map(grids, structure,
                      class = c("calGrid", "data.frame"),
                      names =  c("calBP", "PrDens"))

  calMatrix <- NA

  CalDates <- list(metadata = metadata,
                   grids = grids,
                   calMatrix = calMatrix)
  class(CalDates) <- c("CalDates", "list")

  return(CalDates)
}

#' @rdname as_cal
#' @export
as_cal.oxcAARCalibratedDatesList <- function(x) {
  purrr::map(x, as_cal)
}

#' @rdname as_cal
#' @export
as_cal.oxcAARCalibratedDate <- function(x) {
  # TODO: Metadata?
  y <- x$raw_probabilities

  if (!all(is.na(x$posterior_probabilities))) {
    y <- rbind(data.frame(y, bayesian = "prior"),
               data.frame(x$posterior_probabilities,
                          bayesian = "posterior"))
  }

  new_cal(y)
}

#' @rdname as_cal
#' @export
as_cal.BchronCalibratedDates <- function(x) {
  #TODO: Metadata?
  x %>%
    purrr::map(~data.frame(year = .x$ageGrid, p = .x$densities)) %>%
    purrr::map(new_cal)
}
