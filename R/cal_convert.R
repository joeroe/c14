# cal_convert.R
# Functions for converting foreign objects to or from the c14 cal_dist class


# Base classes ------------------------------------------------------------


#' Convert a foreign object to a cal_dist object
#'
#' @description
#' `as_cal_dist()` converts objects from other packages that represent calibrated
#' radiocarbon distributions to the c14 `cal_dist` class.
#' Methods are currently implemented for:
#'
#' * `CalDates`: from [rcarbon::calibrate()]
#' * `oxcAARCalibratedDate` and `oxcAARCalibratedDatesList`: from [oxcAAR::oxcalCalibrate()]
#' * `BchronCalibratedDates`: from [Bchron::BchronCalibrate()]
#'
#' These functions are intended for complex S3 objects from other packages.
#' The generic constructor [cal_dist()] can be used for data frames and other base
#' structures.
#'
#' @param x  Object from another package to be converted to a `cal_dist` object.
#' @param ... Unused
#'
#' @returns
#' Vector of class `c14_cal_dist` ([cal_dist]).
#'
#' @family cal class methods
#' @family c14 conversion functions
#'
#' @export
as_cal_dist <- function(x, ...) UseMethod("as_cal_dist")


#' @rdname as_cal_dist
#' @export
as_cal_dist.data.frame <- function(x, ...) {
  cal_dist(x)
}

#' @rdname as_cal_dist
#' @export
as_cal_dist.matrix <- function(x, ...) {
  cal_dist(as.data.frame(x))
}

# rcarbon (CalDates) ------------------------------------------------------

#' @rdname as_cal_dist
#' @export
as_cal_dist.CalDates <- function(x, ...) {
  x <- validate_CalDates(x)

  pds <- x[[grids_or_calmatrix(x)]]

  if (grids_or_calmatrix(x) == "calmatrix") {
    rlang::abort("as_cal_dist method for calMatrix not yet implemented!",
                 class = "c14_unimplemented_function")
  }

  pds <- purrr::map(pds, `class<-`, value = "data.frame")

  do.call(cal_dist, unname(pds))
}

#' Test whether an object is a valid rcarbon::CalDates.
#'
#' @noRd
#' @keywords Internal
validate_CalDates <- function(x) {
  message <- "`x` must be a valid `CalDates` object."

  if (!"CalDates" %in% class(x)) {
    message <- c(message, x = '`x` is not of class "CalDates"')
  }

  else if (!all.equal(names(x), c("metadata", "grids", "calmatrix"))) {
    message <- c(message, x = "`x` does not have correct element names")
  }

  else if (is.na(grids_or_calmatrix(x))) {
    message <- c(message, x = "`x` does not contain a probability distribution: `grids` and `calmatrix` elements are both NA")
  }

  if (length(message) > 1) {
    rlang::abort(message, class = "c14_invalid_foreign_object")
  }
  else {
    invisible(x)
  }
}

#' Are the probabilities in a CalDates object stored as grids or a calmatrix?
#'
#' @noRd
#' @keywords Internal
grids_or_calmatrix <- function(x, ...) {
  if (!all(is.na(x[["grids"]]))) "grids"
  else if (!all(is.na(x[["calmatrix"]]))) "calmatrix"
  else NA
}

# oxcAAR (oxcAARCalibrated*) ----------------------------------------------

#' @rdname as_cal_dist
#' @export
as_cal_dist.oxcAARCalibratedDatesList <- function(x, ...) {
  purrr::map(x, as_cal_dist, ...)
}

#' @param which Which probability distribution to extract from an `oxcAARCalibratedDate`:
#'   `"prior"` (default) uses raw calibrated probabilities.
#'   `"posterior"` uses Bayesian posterior probabilities (error if not available).
#'
#' @rdname as_cal_dist
#' @export
as_cal_dist.oxcAARCalibratedDate <- function(x, ..., which = c("prior", "posterior")) {
  which <- match.arg(which)

  if (which == "prior") {
    return(oxcAAR_to_cal_dist(x$raw_probabilities))
  }

  if (all(is.na(x$posterior_probabilities))) {
    rlang::abort(
      "No posterior probabilities available in this oxcAAR object.",
      class = "c14_invalid_foreign_object"
    )
  }

  oxcAAR_to_cal_dist(x$posterior_probabilities)
}

#' Convert oxcAAR probability data frame to cal_dist
#'
#' @noRd
#' @keywords Internal
oxcAAR_to_cal_dist <- function(x, ...) {
  cal_dist(data.frame(age = 1950 - x$dates, pdens = x$probabilities))
}

# Bchron (BchronCalibratedDates) ------------------------------------------

#' @rdname as_cal_dist
#' @export
as_cal_dist.BchronCalibratedDates <- function(x, ...) {
  dfs <- purrr::map(x, ~data.frame(age = .x$ageGrid, pdens = .x$densities))
  do.call(cal_dist, unname(dfs))
}
