# curve.R
# S3 record class c14_curve: radiocarbon calibration curves


# Constructors ------------------------------------------------------------

#' Radiocarbon calibration curve class
#'
#' @description
#' The `c14_curve` class represents a radiocarbon calibration curve, which
#' estimates the calendar ages corresponding to a set of radiocarbon
#' measurements. Usually calibration is performed with either one of the
#' standard curves included with the package (see [c14_curves]) or read in from
#' a file with [read_14c()].
#'
#' `c14_curve()` constructs a a new calibration curve using values in 14C years,
#' optionally with their associated d14C values.
#'
#' `c14_fcurve()` constructs a curve using fraction modern values (F14C or pMC),
#' typically used for "post-bomb" calibration.
#'
#' @param cal_age Vector of calendar ages. If `cal_age` is an object of class
#'  [era::yr], its epoch will be respected, otherwise it is assumed to be
#'  `"cal BP"`.
#' @param c14_age Vector of uncalibrated radiocarbon ages.
#' @param c14_error Vector of errors (sigma values) associated with `c14_age`.
#' @param d14c Vector of Delta-14C values (optional).
#' @param d14c_error Vector of errors (sigma values) associated with `d14c`
#'  (optional).
#' @param f14c Vector of fraction modern (F14C or pMC) values.
#' @param f14c_error Vector of errors (sigma values) associated with `f14c`.
#'
#' @return
#' Object of class `c14_curve`.
#'
#' @family calibration curve functions
#'
#' @references
#' \insertRef{Stenstrom2011}{c14}
#'
#' @export
c14_curve <- function(cal_age = era::yr(),
                      c14_age = numeric(),
                      c14_error = numeric(),
                      d14c = numeric(),
                      d14c_error = numeric()) {
  if (!era::is_yr(cal_age)) {
    cal_age <- vec_cast(cal_age, numeric())
    cal_age <- era::yr(cal_age, "cal BP")
  }

  c14_age <- vec_cast(c14_age, numeric())
  c14_error <- vec_cast(c14_error, numeric())

  d14c <- vec_cast(d14c, numeric())
  d14c_error <- vec_cast(d14c_error, numeric())
  if (all(is.na(d14c))) {
    d14c <- vec_recycle(d14c, length(cal_age))
  }
  if (all(is.na(d14c_error))) {
    d14c_error <- vec_recycle(d14c_error, length(cal_age))
  }

  new_c14_curve(cal_age, c14_age = c14_age, c14_error = c14_error,
                d14c = d14c, d14c_error = d14c_error,
                subclass = "c14_curve_14c")
}

#' @rdname c14_curve
#' @export
c14_fcurve <- function(cal_age = era::yr(),
                       f14c = numeric(),
                       f14c_error = numeric()) {
  if (!era::is_yr(cal_age)) {
    cal_age <- vec_cast(cal_age, numeric())
    cal_age <- era::yr(cal_age, "cal BP")
  }
  f14c <- vec_cast(f14c, numeric())
  f14c_error <- vec_cast(f14c_error, numeric())

  new_c14_curve(cal_age, f14c = f14c, f14c_error = f14c_error,
                subclass = "c14_curve_f14c")
}

#' Construct a `c14_curve` object
#'
#' `c14_curve` is an S3 record class representing a calibration curve. It has
#' two subclasses: `c14_curve_14c` for standard curves with 14C ages and
#' optionally also d14C values; and `c14_curve_f14c` for curves with only
#' F14C values (typically for post-bomb calibration).
#'
#' `cal_age` should be an [era_yr] vector.
#'
#' This function should only be used internally. The user-friendly constructors
#' are [c14_curve()] and [c14_fcurve()].
#'
#' @family calibration curve functions
#'
#' @noRd
#' @keywords internal
new_c14_curve <- function(cal_age = numeric(),
                          c14_age = numeric(),
                          c14_error = numeric(),
                          d14c = numeric(),
                          d14c_error = numeric(),
                          f14c = numeric(),
                          f14c_error = numeric(),
                          subclass = c("c14_curve_14c", "c14_curve_f14c")) {
  subclass <- rlang::arg_match(subclass)
  if (subclass == "c14_curve_14c") {
    new_rcrd(list(cal_age = cal_age, c14_age = c14_age, c14_error = c14_error,
                  d14c = d14c, d14c_error = d14c_error),
             class = c("c14_curve_14c", "c14_curve"))
  }
  else if (subclass == "c14_curve_f14c") {
    new_rcrd(list(cal_age = cal_age, f14c = f14c, f14c_error = f14c_error),
             class = c("c14_curve_f14c", "c14_curve"))
  }
}

# Validators --------------------------------------------------------------

is_c14_curve <- function(x) {
  inherits(x, "c14_curve")
}

# Print/format ------------------------------------------------------------

#' @export
vec_ptype_abbr.c14_curve_14c <- function(x, ...) "c14_curve"

#' @export
vec_ptype_abbr.c14_curve_f14c <- function(x, ...) "c14_curve"

#' @export
format.c14_curve_14c <- function(x, ...) NextMethod()

#' @export
format.c14_curve_f14c <- function(x, ...) NextMethod()

#' @export
format.c14_curve <- function(x, ...) {
  format(vec_proxy(x))
}


# Cast/coerce -------------------------------------------------------------

#' @method as.matrix c14_curve
#' @export
as.matrix.c14_curve <- function(x, resolution = 1) {
  # TODO: Interpolate to resolution?
  x <- vec_data(x)

  d <- purrr::map2(as.numeric(x$c14_age), as.numeric(x$c14_error),
                   ~stats::dnorm(x$cal_age, .x, .y))
  d <- do.call(cbind, d)
  rownames(d) <- x$c14_age
  colnames(d) <- x$cal_age

  # TODO: rescale to sum to 1? only if resolution != 1?
  d
}
