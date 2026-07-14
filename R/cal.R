# cal.R
# vctrs record class c14_cal (cal): lazy calibrated radiocarbon dates

# Register formal class for S4 compatibility
methods::setOldClass(c("c14_cal", "vctrs_rcrd"))

# Constructors ------------------------------------------------------------

#' Calibrated radiocarbon dates
#'
#' @description
#' The `cal` class represents a vector of calibrated radiocarbon dates as a
#' lazy record. Each element stores the parameters needed to derive a calendar
#' probability distribution (`c14_age`, `c14_error`, and `c14_curve`), but does
#' not compute the distribution until requested.
#'
#' Use [cal_function()] to derive the probability density function, or
#' [cal_dist()] to evaluate it at specific ages.
#'
#' @param c14_age Vector of uncalibrated radiocarbon ages.
#' @param c14_error Vector of standard errors associated with `c14_age`.
#' @param curve A `c14_curve` object or list of `c14_curve` objects.
#'   Default: `IntCal20`.
#'
#' @return
#' A vector of class `cal` (`c14_cal`).
#'
#' @export
#'
#' @examples
#' cal(1000, 30, curve = IntCal20)
#' cal(c(1000, 2000), c(30, 40), curve = IntCal20)
cal <- function(c14_age = double(), c14_error = double(),
                curve = c14_curve()) {
  if (!is_c14_curve(curve)) {
    rlang::abort(
      "`curve` must be a `c14_curve` object. See ?c14_curves for available calibration curves.",
      class = "c14_invalid_curve"
    )
  }

  c14_age <- vec_cast(c14_age, numeric())
  c14_error <- vec_cast(c14_error, numeric())

  c(c14_age, c14_error) %<-% vec_recycle_common(c14_age, c14_error)

  new_cal(c14_age, c14_error, curve)
}

#' Construct a `c14_cal` object
#'
#' Low-level constructor for `cal` record objects.
#'
#' @param c14_age Numeric vector of uncalibrated radiocarbon ages.
#' @param c14_error Numeric vector of standard errors.
#' @param curve A `c14_curve` object (stored as attribute).
#'
#' @return
#' A [vctrs::new_rcrd] subclass `c14_cal`.
#'
#' @noRd
#' @keywords internal
new_cal <- function(c14_age = double(), c14_error = double(),
                    curve = c14_curve()) {
  new_rcrd(
    list(c14_age = c14_age, c14_error = c14_error),
    class = "c14_cal",
    curve = curve
  )
}

# Validators --------------------------------------------------------------

#' Test if an object is a cal
#'
#' @keywords internal
#' @noRd
is_cal <- function(x) {
  inherits(x, "c14_cal")
}

#' Extract c14_curve from cal
#'
#' @param x A `cal` object.
#' @return The `c14_curve` object associated with `x`.
#' @noRd
#' @keywords internal
cal_c14_curve <- function(x) {
  attr(x, "curve", exact = TRUE)
}

# Print/format ------------------------------------------------------------

#' @export
vec_ptype_full.c14_cal <- function(x, ...) "c14_cal"

#' @export
vec_ptype_abbr.c14_cal <- function(x, ...) "cal"

#' @export
format.c14_cal <- function(x, ...) {
  hdi <- cal_hdi(x)
  
  out <- purrr::map_chr(hdi, function(interval) {
    era_label <- era::era_label(era::yr_era(interval[1]))
    sprintf("%d–%d %s", 
            as.integer(interval[1]), 
            as.integer(interval[2]), 
            era_label)
  })
  
  format(out, justify = "right")
}

# Casting/coerce ----------------------------------------------------------

#' @export
vec_ptype2.c14_cal.c14_cal <- function(x, y, ...) {
  new_cal()
}

#' @export
vec_cast.c14_cal.c14_cal <- function(x, to, ...) {
  x
}
