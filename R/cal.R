# cal.R
# vector list_of class c14_cal (cal): calibrated radiocarbon dates and other
# calendar probability distributions

# Register formal class for S4 compatibility
# https://vctrs.r-lib.org/articles/s3-vector.html#implementing-a-vctrs-s3-class-in-a-package-1
methods::setOldClass(c("c14_cal", "vctrs_list_of"))

# Constructors ------------------------------------------------------------

#' Calibrated radiocarbon dates
#'
#' @description
#' The `cal` class represents a vector of calendar probability distribution;
#' typically calibrated radiocarbon dates.
#'
#' `cal()` constructs a new `cal` vector from a set of data frames containing
#' the raw probability distributions.
#'
#' @param ... <[dynamic-dots][rlang::dyn-dots]> A set of data frames. Each
#'  should have two columns, the first a vector of calendar ages, and the second
#'  a vector of associated probability densities. If the first column is not an
#'  [era::yr()] vector, it is coerced to one using the time scale specified by
#'  `.era`.
#' @param .era [era::era()] object describing the time scale used for ages.
#'  Defaults to calendar years Before Present (`era("cal BP")`). Not used if
#'  the ages specified in `...` are already `era::yr()` vectors.
#'
#' @return
#' A list of data frames with class `cal` (`c14_cal`). Each element has two
#' columns: `age` and `pdens`.
#'
#' @export
#'
#' @examples
#' # Uniform distribution between 1 and 10 BP:
#' cal(data.frame(age = era::yr(1:10, "cal BP"), pdens = rep(0.1, 10)))
cal <- function(..., .era = era::era("cal BP")) {
  # TODO: If ... is a single list, unlist it (? – maybe too clever)
  # if (rlang::is_bare_list(..., n = 1))
  # TODO: ensure that all ages use the same era

  x <- rlang::list2(...)

  # x <- purrr::map(x, vctrs::vec_assert, ptype = cal_atomic_ptype())
  x <- purrr::map(x, purrr::set_names, nm = c("age", "pdens"))
  # TODO: Message if coerced?
  x <- purrr::map_if(x, ~!era::is_yr(.[["age"]]),
                     ~data.frame(age = era::yr_set_era(.[["age"]], .era),
                                 pdens = .[["pdens"]]))

  new_cal(x)
}



#' Construct a `c14_cal` object
#'
#' @description
#' `c14_cal` (abbreviated `cal`) is a list of data frames representing
#' calibrated radiocarbon or other calendar-based probability distributions.
#' Inputs are recycled using vctrs::vec_recycle_common().
#'
#' This function should only be used internally. The user-friendly constructor
#' is [cal()].
#'
#' @param x List of data frames.
#'
#' @return
#' [vctrs::new_list_of] subclass `c14_cal`.
#'
#' @noRd
#' @keywords Internal
new_cal <- function(x = list()) {
  new_vctr(x, class = "c14_cal")
}

#' Shorthand prototype for individual elements of a cal vector
#'
#' @noRd
#' @keywords Internal
cal_atomic_ptype <- function() data.frame(age = era::yr(), pdens = numeric())


# Validators --------------------------------------------------------------

# TODO: validate that all ages use the same era

# Print/format ------------------------------------------------------------

#' @export
vec_ptype_full.c14_cal <- function(x, ...) "c14_cal"

#' @export
vec_ptype_abbr.c14_cal <- function(x, ...) "cal"

#' @export
obj_print_data.c14_cal <- function(x, ...) {
  print(format(x), quote = FALSE)
}

#' @export
format.c14_cal <- function(x, ..., formatter = circa_point_yr) {
  # TODO: handle NA/invalid cals?
  formatter(x)
}

#' @importFrom pillar pillar_shaft
#' @export
pillar_shaft.c14_cal <- function(x, ...) {
  out <- format(x, formatter = circa_point_yr_colour)
  pillar::new_pillar_shaft_simple(out, align = "right")
}

#' @noRd
#' @keywords internal
circa_point_yr <- function(x) {
  y <- cal_point(x)
  ret <- sprintf("c. %s", y)
  format(ret, justify = "right")
}

#' @noRd
#' @keywords internal
circa_point_yr_colour <- function(x) {
  y <- cal_point(x)
  ret <- sprintf(
    "%s %d %s",
    pillar::style_subtle("c."),
    as.numeric(y),
    pillar::style_subtle(era::era_label(era::yr_era(y)))
  )
  format(ret, justify = "right")
}

# Casting/coercion --------------------------------------------------------


# Accessors ---------------------------------------------------------------

#' Extract ages from cal vectors
#'
#' @keywords internal
#' @noRd
cal_age <- function(x) {
  purrr::map(vec_data(x), "age")
}

#' Extract probabilities from cal vectors
#'
#' @keywords internal
#' @noRd
cal_pdens <- function(x) {
  purrr::map(vec_data(x), "pdens")
}

# Misc --------------------------------------------------------------------

#' Filter cal vectors to a given minimum probability density
#'
#' @noRd
#' @keywords internal
cal_crop <- function(x, min_pdens = 0) {
  if (min_pdens <= 0) return(x)
  new_cal(furrr::future_map(vec_data(x), \(x) x[x$pdens >= min_pdens,]))
}

#' Generate a sequence of ages that covers a cal vector at the given resolution
#'
#' @noRd
#' @keywords internal
cal_age_common <- function(x, resolution = 1) {
  min_age <- min(cal_age_min(x))
  max_age <- max(cal_age_max(x))
  seq(from = min_age, to = max_age, by = resolution)
}

#' Interpolate a cal vector over the given range
#'
#' Result is normalised
#'
#' @noRd
#' @keywords internal
cal_interpolate <- function(x, range = cal_age_common(x)) {
  new_cal(furrr::future_map(vec_data(x), function(x) {
    x <- approx_df(x, range, ties = "ordered")
    x$pdens <- x$pdens / sum(x$pdens, na.rm = TRUE)
    x
  }))
}