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
  if (length(d14c) == 0) {
    d14c <- rep(NA_real_, length(cal_age))
  }
  if (length(d14c_error) == 0) {
    d14c_error <- rep(NA_real_, length(cal_age))
  }

  df <- data.frame(
    cal_age = cal_age,
    c14_age = c14_age,
    c14_error = c14_error,
    d14c = d14c,
    d14c_error = d14c_error
  )
  class(df) <- c("c14_curve_14c", "c14_curve", "data.frame")
  df
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

  df <- data.frame(
    cal_age = cal_age,
    f14c = f14c,
    f14c_error = f14c_error
  )
  class(df) <- c("c14_curve_f14c", "c14_curve", "data.frame")
  df
}


# Validators --------------------------------------------------------------

is_c14_curve <- function(x) {
  inherits(x, "c14_curve")
}

#' @noRd
#' @keywords internal
c14_curve_name <- function(x) {
  name <- attr(x, "name", exact = TRUE)
  if (is.null(name)) "custom curve" else name
}

#' @noRd
#' @keywords internal
c14_curve_type <- function(x) {
  if (inherits(x, "c14_curve_14c")) "14C"
  else if (inherits(x, "c14_curve_f14c")) "F14C"
}

#' @noRd
#' @keywords internal
c14_curve_range <- function(x) {
  cal_age <- x$cal_age
  r <- range(cal_age)
  era <- era::era_label(era::yr_era(cal_age))
  paste0(as.numeric(r[1]), "\u2013", as.numeric(r[2]), " ", era)
}

# Print/format ------------------------------------------------------------

#' @export
format.c14_curve <- function(x, ...) {
  name <- c14_curve_name(x)
  subclass <- class(x)[1]

  type_desc <- if (inherits(x, "c14_curve_14c")) {
    "Conventional radiocarbon age calibration curve"
  } else if (inherits(x, "c14_curve_f14c")) {
    "Fraction modern radiocarbon calibration curve"
  } else {
    "Radiocarbon calibration curve"
  }

  range_str <- if (nrow(x) > 0) {
    r <- range(x$cal_age, na.rm = TRUE)
    era <- era::era_label(era::yr_era(x$cal_age))
    paste0("Range: ", as.numeric(r[1]), "\u2013", as.numeric(r[2]), " ", era)
  } else {
    "Range: (empty)"
  }

  header <- paste0(name, " <", subclass, ">")

  if (nrow(x) > 0) {
    n_show <- min(5, nrow(x))
    data_preview <- utils::capture.output(print.data.frame(utils::head(x, n_show)))
    data_preview <- paste(data_preview, collapse = "\n")
  } else {
    data_preview <- "(no data)"
  }

  footer <- if (nrow(x) > 5) {
    paste0("# ", nrow(x) - 5, " more rows")
  }

  paste0(
    "# ", header, "\n",
    "# ", type_desc, "\n",
    "# ", range_str, "\n",
    data_preview,
    if (!is.null(footer)) paste0("\n", footer)
  )
}

#' @export
print.c14_curve <- function(x, ...) {
  cat(format(x, ...), "\n")
  invisible(x)
}


# Cast/coerce -------------------------------------------------------------

#' @method as.matrix c14_curve
#' @export
as.matrix.c14_curve <- function(x, ..., resolution = 1) {
  d <- purrr::map2(as.numeric(x$c14_age), as.numeric(x$c14_error),
                   ~stats::dnorm(x$cal_age, .x, .y))
  d <- do.call(cbind, d)
  rownames(d) <- x$c14_age
  colnames(d) <- x$cal_age

  d
}

#' @export
as.data.frame.c14_curve_14c <- function(x, ...) x

#' @export
as.data.frame.c14_curve_f14c <- function(x, ...) x