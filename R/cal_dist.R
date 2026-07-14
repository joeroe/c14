# cal_dist.R
# vctrs list_of class c14_cal_dist (cal_dist): computed calendar probability
# distributions
#
# A cal_dist represents the evaluated probability distribution for a calibrated
# radiocarbon date. It is derived from a cal object via cal_as_cal_dist().

# Register formal class for S4 compatibility
methods::setOldClass(c("c14_cal_dist", "vctrs_list_of"))

# Constructors ------------------------------------------------------------

#' Calendar probability distribution
#'
#' @description
#' The `cal_dist` class represents a vector of calendar probability
#' distributions; typically the evaluated output of [cal_as_cal_dist()].
#'
#' `cal_dist()` constructs a new `cal_dist` vector from a set of data frames
#' containing probability distributions.
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
#' A list of data frames with class `cal_dist` (`c14_cal_dist`). Each element
#' has two columns: `age` and `pdens`.
#'
#' @export
#'
#' @examples
#' # Uniform distribution between 1 and 10 BP:
#' cal_dist(data.frame(age = era::yr(1:10, "cal BP"), pdens = rep(0.1, 10)))
cal_dist <- function(..., .era = era::era("cal BP")) {
  x <- rlang::list2(...)

  x <- purrr::map(x, purrr::set_names, nm = c("age", "pdens"))
  x <- purrr::map_if(x, ~!era::is_yr(.[["age"]]),
                     ~data.frame(age = era::yr_set_era(.[["age"]], .era),
                                 pdens = .[["pdens"]]))

  new_cal_dist(x)
}

#' Construct a `c14_cal_dist` object
#'
#' @param x List of data frames.
#'
#' @return
#' [vctrs::new_list_of] subclass `c14_cal_dist`.
#'
#' @noRd
#' @keywords internal
new_cal_dist <- function(x = list()) {
  new_vctr(x, class = "c14_cal_dist")
}

# Derivation -------------------------------------------------------------

#' Derive a cal_dist from a cal
#'
#' @param cal A `cal` object of length 1.
#' @param at Calendar ages at which to evaluate the distribution. If `NULL`,
#'   uses the calibration curve's native resolution.
#'
#' @return
#' A `cal_dist` object of length 1.
#'
#' @noRd
#' @keywords internal
cal_as_cal_dist <- function(cal, at = NULL) {
  if (length(cal) != 1) {
    rlang::abort("`cal_as_cal_dist()` expects a `cal` of length 1.",
                 class = "c14_invalid_argument")
  }

  f <- cal_function(cal)

  if (is.null(at)) {
    curve_name <- field(cal, "c14_curve")
    curve <- get(curve_name, envir = asNamespace("c14"))
    at <- c14_curve_age_seq(curve)
  }

  pdens <- f(at)
  cal_dist(data.frame(age = at, pdens = pdens))
}

#' Prototype for individual elements of a cal_dist vector
#'
#' @noRd
#' @keywords internal
cal_dist_ptype <- function() data.frame(age = era::yr(), pdens = numeric())

# Validators --------------------------------------------------------------

#' Test if an object is a cal_dist
#'
#' @keywords internal
#' @noRd
is_cal_dist <- function(x) {
  inherits(x, "c14_cal_dist")
}

# Print/format ------------------------------------------------------------

#' @export
vec_ptype_full.c14_cal_dist <- function(x, ...) "c14_cal_dist"

#' @export
vec_ptype_abbr.c14_cal_dist <- function(x, ...) "cal_dist"

#' @export
obj_print_data.c14_cal_dist <- function(x, ...) {
  print(format(x), quote = FALSE)
}

#' @export
format.c14_cal_dist <- function(x, ..., formatter = cal_dist_format_point) {
  formatter(x)
}

#' @importFrom pillar pillar_shaft
#' @export
pillar_shaft.c14_cal_dist <- function(x, ...) {
  out <- format(x, formatter = cal_dist_format_point_colour)
  pillar::new_pillar_shaft_simple(out, align = "right")
}

#' @noRd
#' @keywords internal
cal_dist_format_point <- function(x) {
  y <- cal_dist_point(x)
  ret <- sprintf("c. %s", y)
  format(ret, justify = "right")
}

#' @noRd
#' @keywords internal
cal_dist_format_point_colour <- function(x) {
  y <- cal_dist_point(x)
  ret <- sprintf(
    "%s %d %s",
    pillar::style_subtle("c."),
    as.numeric(y),
    pillar::style_subtle(era::era_label(era::yr_era(y)))
  )
  format(ret, justify = "right")
}

#' @noRd
#' @keywords internal
cal_dist_point <- function(x) {
  ages <- cal_dist_age(x)
  pdens <- cal_dist_pdens(x)
  
  purrr::map2_vec(ages, pdens, function(age, pdens) {
    age[pdens == max(pdens, na.rm = TRUE) & !is.na(pdens)][1]
  })
}

# Accessors ---------------------------------------------------------------

#' Extract ages from cal_dist vectors
#'
#' @keywords internal
#' @noRd
cal_dist_age <- function(x) {
  purrr::map(vec_data(x), "age")
}

#' Extract probabilities from cal_dist vectors
#'
#' @keywords internal
#' @noRd
cal_dist_pdens <- function(x) {
  purrr::map(vec_data(x), "pdens")
}

#' @noRd
#' @keywords internal
cal_dist_age_min <- function(x) {
  purrr::map_vec(cal_dist_age(x), min, na.rm = TRUE)
}

#' @noRd
#' @keywords internal
cal_dist_age_max <- function(x) {
  purrr::map_vec(cal_dist_age(x), max, na.rm = TRUE)
}

# Misc --------------------------------------------------------------------

#' Filter cal_dist vectors to a given minimum probability density
#'
#' @noRd
#' @keywords internal
cal_dist_crop <- function(x, min_pdens = 0) {
  if (min_pdens <= 0) return(x)
  new_cal_dist(furrr::future_map(vec_data(x), \(x) x[x$pdens >= min_pdens,]))
}

#' Generate a sequence of ages that covers a cal_dist vector at the given
#' resolution
#'
#' @noRd
#' @keywords internal
cal_dist_age_common <- function(x, resolution = 1) {
  min_age <- min(cal_dist_age_min(x))
  max_age <- max(cal_dist_age_max(x))
  seq(from = min_age, to = max_age, by = resolution)
}

#' Interpolate a cal_dist vector over the given range
#'
#' Result is normalised.
#'
#' @noRd
#' @keywords internal
cal_dist_interpolate <- function(x, range = cal_dist_age_common(x)) {
  new_cal_dist(furrr::future_map(vec_data(x), function(x) {
    x <- approx_df(x, range)
    x$pdens <- x$pdens / sum(x$pdens, na.rm = TRUE)
    x
  }))
}
