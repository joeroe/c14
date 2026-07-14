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
#' @param c14_curve A `c14_curve` object or list of `c14_curve` objects.
#'   Default: `IntCal20`.
#'
#' @return
#' A vector of class `cal` (`c14_cal`). Each element is a record with three
#' fields: `c14_age`, `c14_error`, and `c14_curve`.
#'
#' @export
#'
#' @examples
#' cal(1000, 30, c14_curve = IntCal20)
#' cal(c(1000, 2000), c(30, 40), c14_curve = IntCal20)
cal <- function(c14_age = double(), c14_error = double(),
                c14_curve = IntCal20) {
  c14_age <- vec_cast(c14_age, numeric())
  c14_error <- vec_cast(c14_error, numeric())

  if (is_c14_curve(c14_curve)) {
    c14_curve <- list(c14_curve)
  } else if (is.list(c14_curve)) {
    if (!all(vapply(c14_curve, is_c14_curve, logical(1)))) {
      rlang::abort(
        "`c14_curve` must be a `c14_curve` object or list of `c14_curve` objects. See ?c14_curves for available curves."
      )
    }
  } else {
    rlang::abort(
      "`c14_curve` must be a `c14_curve` object or list of `c14_curve` objects. See ?c14_curves for available curves."
    )
  }

  n_age <- vec_size(c14_age)
  n_error <- vec_size(c14_error)
  n_curve <- length(c14_curve)

  if (n_age == 0 && n_error == 0) {
    return(new_cal(double(), double(), list()))
  }

  sizes <- c(n_age, n_error, n_curve)
  sizes <- sizes[sizes > 0]
  if (length(sizes) == 0) {
    n <- 0L
  } else {
    n <- max(sizes)
    for (s in sizes) {
      if (n %% s != 0) {
        rlang::abort("Inputs must have compatible lengths.")
      }
    }
  }

  c14_age <- vec_recycle(c14_age, n)
  c14_error <- vec_recycle(c14_error, n)
  c14_curve <- rep(c14_curve, length.out = n)

  curve_names <- purrr::map_chr(c14_curve, c14_curve_name)
  new_cal(c14_age, c14_error, curve_names, c14_curve)
}

#' Construct a `c14_cal` object
#'
#' Low-level constructor for `cal` record objects.
#'
#' @param c14_age Numeric vector of uncalibrated radiocarbon ages.
#' @param c14_error Numeric vector of standard errors.
#' @param c14_curve Character vector of curve names (for display/storage).
#' @param .curves List of `c14_curve` objects (stored as attribute).
#'
#' @return
#' A [vctrs::new_rcrd] subclass `c14_cal`.
#'
#' @noRd
#' @keywords internal
new_cal <- function(c14_age = double(),
                    c14_error = double(),
                    c14_curve = character(),
                    .curves = list()) {
  x <- new_rcrd(
    list(c14_age = c14_age, c14_error = c14_error, c14_curve = c14_curve),
    class = "c14_cal"
  )
  attr(x, ".curves") <- .curves
  x
}

# Validators --------------------------------------------------------------

#' Test if an object is a cal
#'
#' @keywords internal
#' @noRd
is_cal <- function(x) {
  inherits(x, "c14_cal")
}

#' Extract c14_curve field from cal
#'
#' Helper function to extract the c14_curve field from a cal object.
#' The curves are stored in an attribute to avoid issues with vctrs subsetting.
#'
#' @param x A `cal` object.
#'
#' @return
#' A list of `c14_curve` objects.
#'
#' @keywords internal
#' @noRd
cal_curve <- function(x) {
  attr(x, ".curves", exact = TRUE)
}

# Print/format ------------------------------------------------------------

#' @export
vec_ptype_full.c14_cal <- function(x, ...) "c14_cal"

#' @export
vec_ptype_abbr.c14_cal <- function(x, ...) "cal"

#' @export
format.c14_cal <- function(x, ...) {
  c14_age <- field(x, "c14_age")
  c14_error <- field(x, "c14_error")
  c14_curve <- field(x, "c14_curve")

  out <- sprintf(
    "%d ± %d (%s)",
    as.integer(c14_age),
    as.integer(c14_error),
    c14_curve
  )
  format(out, justify = "right")
}

#' @export
vec_proxy.c14_cal <- function(x, ...) {
  data.frame(
    c14_age = field(x, "c14_age"),
    c14_error = field(x, "c14_error"),
    c14_curve = field(x, "c14_curve"),
    stringsAsFactors = FALSE
  )
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

#' @export
`[.c14_cal` <- function(x, i, ...) {
  curves <- cal_curve(x)
  result <- NextMethod()
  if (!is.null(curves) && length(curves) > 0) {
    if (missing(i)) {
      attr(result, ".curves") <- curves
    } else {
      attr(result, ".curves") <- curves[i]
    }
  }
  result
}

#' @export
`[[.c14_cal` <- function(x, i, ...) {
  curves <- cal_curve(x)
  result <- NextMethod()
  if (!is.null(curves) && length(curves) > 0) {
    attr(result, ".curves") <- curves[i]
  }
  result
}

#' @export
c.c14_cal <- function(...) {
  args <- list(...)
  curves <- unlist(lapply(args, cal_curve), recursive = FALSE)
  result <- NextMethod()
  attr(result, ".curves") <- curves
  result
}
