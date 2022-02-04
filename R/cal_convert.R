# cal_convert.R
# Functions for converting foreign objects to or from the c14 cal class


# rcarbon (CalDates) ------------------------------------------------------



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
#' The generic constructor [cal()] can be used for data frames and other base
#' structures.
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


# Base classes ------------------------------------------------------------

#' @rdname as_cal
#' @export
as_cal.data.frame <- function(x) {
  cal(x)
}

#' @rdname as_cal
#' @export
as_cal.matrix <- function(x) {
  cal(as.data.frame(x))
}

# rcarbon (CalDates) ------------------------------------------------------

#' @rdname as_cal
#' @export
as_cal.CalDates <- function(x) {
  x <- validate_CalDates(x)

  pds <- x[[grids_or_calmatrix(x)]]

  if (grids_or_calmatrix(x) == "calmatrix") {
    rlang::abort("as_cal method for calMatrix not yet implemented!",
                 class = "c14_unimplemented_function")
  }

  pds <- purrr::map(pds, `class<-`, value = "data.frame")

  cal(!!!pds)
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
grids_or_calmatrix <- function(x) {
  if (!all(is.na(x[["grids"]]))) "grids"
  else if (!all(is.na(x[["calmatrix"]]))) "calmatrix"
  else NA
}

# oxcAAR (oxcAARCalibrated*) ----------------------------------------------

#' @rdname as_cal
#' @export
as_cal.oxcAARCalibratedDatesList <- function(x) {
  purrr::map(x, as_cal)
}

#' @rdname as_cal
#' @export
as_cal.oxcAARCalibratedDate <- function(x) {
  y <- x$raw_probabilities

  if (!all(is.na(x$posterior_probabilities))) {
    y <- rbind(data.frame(y, bayesian = "prior"),
               data.frame(x$posterior_probabilities,
                          bayesian = "posterior"))
  }

  new_cal(y)
}


# Bchron (BchronCalibratedDates) ------------------------------------------

#' @rdname as_cal
#' @export
as_cal.BchronCalibratedDates <- function(x) {
  x %>%
    purrr::map(~data.frame(year = .x$ageGrid, p = .x$densities)) %>%
    purrr::map(new_cal)
}
