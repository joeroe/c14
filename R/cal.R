# cal.R
# S3 record class c14_cal (cal): calibrated radiocarbon dates

# Register formal class for S4 compatibility
# https://vctrs.r-lib.org/articles/s3-vector.html#implementing-a-vctrs-s3-class-in-a-package-1
methods::setOldClass(c("c14_cal", "vctrs_vctr"))

# Constructors ------------------------------------------------------------

#' Calibrated radiocarbon dates
#'
#' The `cal` class represents a calibrated radiocarbon date.
#'
#' @param x                       A `data.frame` with two columns, with calendar years and associated probabilities.
#' @param curve                   (Optional) `character`. Atmospheric curve used for calibration, e.g. "intcal20".
#' @param era                     (Optional) `character`. Calendar system used. Default: `cal BP`.
#' @param lab_id                  (Optional) `character`. Lab code or other label for the calibrated sample.
#' @param cra                     (Optional) `integer`. Uncalibrated conventional radiocarbon age (CRA) of the sample.
#' @param error                   (Optional) `integer`. Error associated with the uncalibrated sample.
#' @param reservoir_offset        (Optional) `integer`. Marine reservoir offset used in the calibration, if any.
#' @param reservoir_offset_error  (Optional) `integer`. Error associated with the marine reservoir offset.
#' @param calibration_range       (Optional) `integer` vector of length 2. The range of years over which the calibration was performed, i.e. `c(start, end)`.
#' @param F14C                    (Optional) `logical`. Whether the calibration was calculated using F14C values instead of the CRA.
#' @param normalised              (Optional) `logical`. Whether the calibrated probability densities were normalised.
#' @param p_cutoff                (Optional) `numeric`. Lower threshold beyond which probability densities were considered zero.
#' @param ...                     (Optional) Arguments based to other functions.
#'
#' @return
#' `cal` object: a data frame with two columns, `year` and `p`, representing
#' the calibrated probability distribution. All other values are stored as
#' attributes and can be accessed with [cal_metadata()].
#'
#' @family cal class methods
#'
#' @export
cal <- function(label = character(),
                c14_age = numeric(),
                c14_error = numeric(),
                curve = c14_curve(),
                offset = numeric(),
                offset_error = numeric(),
                pd = calp(),
                normalised = logical(),
                p_cutoff = numeric(),
                engine = character(),
                engine_version = character()) {
  new_cal(label,
          c14_age,
          c14_error,
          curve,
          offset,
          offset_error,
          pd,
          normalised,
          p_cutoff,
          engine,
          engine_version)
}

new_cal <- function(label = character(),
                    c14_age = numeric(),
                    c14_error = numeric(),
                    curve = c14_curve(),
                    offset = numeric(),
                    offset_error = numeric(),
                    pd = calp(),
                    normalised = logical(),
                    p_cutoff = numeric(),
                    engine = character(),
                    engine_version = character()) {
  new_rcrd(list(
    label = label,
    c14_age = c14_age,
    curve = curve,
    offset = offset,
    offset_error = offset_error,
    pd = pd,
    normalised = normalised,
    p_cutoff = p_cutoff,
    engine = engine,
    engine_version = engine_version
  ),
  class = "c14_cal")
}

# Validators --------------------------------------------------------------


# Print/format ------------------------------------------------------------

#' @export
vec_ptype_abbr.c14_cal <- function(x, ...) "cal"

#' @export
format.c14_cal <- function(x, ...) {
  format(field(x, "label"))
}

# Casting/coercion --------------------------------------------------------


# Maths -------------------------------------------------------------------

#' @export
min.cal <- function(...) {
  # TODO: Probably broken
  cals <- rlang::list2(...)
  cals <- dplyr::bind_rows(cals)
  cals[cals$p <= 0] <- NULL
  max(cals$year)
}

#' @export
max.cal <- function(...) {
  # TODO: Probably broken
  cals <- rlang::list2(...)
  cals <- dplyr::bind_rows(cals)
  cals[cals$p <= 0] <- NULL
  min(cals$year)
}

# Attributes --------------------------------------------------------------


