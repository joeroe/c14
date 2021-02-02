# s3-calp.R
# data.frame subclass c14_calp (calp): calibrated/calendar probability distributions

# Register formal class for S4 compatibility
# https://vctrs.r-lib.org/articles/s3-vector.html#implementing-a-vctrs-s3-class-in-a-package-1
methods::setOldClass(c("c14_calp", "data.frame"))

# Constructors ------------------------------------------------------------

#' Calendar probability distributions
#'
#' @description
#' The `calp` class represents a calibrated radiocarbon or other calendar-based
#' probability distribution as a data frame with two columns: age and
#' probability density. It is usually contained within a [cal] object and
#' constructed by a calibration or conversion function.
#'
#' Use `calp()` to construct a new `calp` object from a pair of vectors. Use
#' as `as_calp()` to convert an object from another package to the `calp` class.
#'
#' @param age Vector of calendar ages. Either an [era::yr] vector with era
#'  specified, or a numeric vector, in which case the era is assumed to be "cal
#'  BP".
#' @param pdens Probability densities for each value of `age`.
#' @param x For `as_calp()`, foreign object to convert to a `calp` object.
#' @param ... Arguments passed to other functions (currently unused).
#'
#' @return
#' A data frame with class `calp` (`c14_calp`) and two columns: `age` and `pdens`.
#'
#' @export
#'
#' @examples
#' # Uniform distribution between 1 and 10 BP:
#' calp(era::yr(1:10, "BP"), rep(0.1, 10))
calp <- function(age = numeric(), pdens = numeric()) {
  missing_age <- missing(age)

  if (!era::is_yr(age)) {
    age <- vec_cast(age, numeric())
    age <- era::yr(age, "cal BP")
    if (!missing_age) {
      rlang::warn(
        'era of `age` not specified, defaulting to "cal BP".',
        i = "Use era::yr() to specify the era used."
      )
    }
  }
  pdens <- vec_cast(pdens, numeric())

  new_calp(age, pdens)
}

#' Construct a `c14_calp` object
#'
#' @description
#' `c14_calp` (abbreviated `calp`) is a data.frame subclass representing
#' calibrated radiocarbon or other calendar-based probability distributions.
#' Inputs are recycled using vctrs::vec_recycle_common().
#'
#' This function should only be used internally. The user-friendly constructor
#' is [calp()].
#'
#' @param age [era::yr] vector of ages.
#' @param pdens Probability density for each value of age.
#'
#' @return
#' Data frame with subclass `c14_calp`.
#'
#' @noRd
#' @keywords Internal
new_calp <- function(age = era::yr(), pdens = numeric()) {
  # TODO: assert age is a yr
  vec_assert(pdens, numeric())

  new_data_frame(df_list(age = age, pdens = pdens), class = "c14_calp")
}


# Conversion --------------------------------------------------------------

#' @rdname calp
#' @export
as_calp <- function(x, ...) UseMethod("as_calp")

#' @method as_calp calGrid
#' @export
as_calp.calGrid <- function(x, ...) {
  new_calp(era::yr(x$calBP, "cal BP"), x$PrDens)
}


# Validators --------------------------------------------------------------


# Print/format ------------------------------------------------------------

#' @export
vec_ptype_abbr.c14_calp <- function(x, ...) "calp"

#' @method print c14_calp
#' @export
print.c14_calp <- function(x, ...) {
  obj_print(x, ...)
  invisible(x)
}

#' @export
obj_print_header.c14_calp <- function(x, ...) {
  cli::cat_line("# Calendar probability distribution <", vec_ptype_abbr(x), ">",
                " with ", vec_size(x), " rows:")
  invisible(x)
}

#' @method obj_print_footer c14_calp
#' @export
obj_print_footer.c14_calp <- function(x, ...) {
  cli::cat_line("# Era: ", format(era::yr_era(x$age)), sep = "")
  invisible(x)
}

# Casting/coercion --------------------------------------------------------



