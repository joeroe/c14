# cal_dist.R
# vctrs list_of class c14_cal_dist (cal_dist): computed calendar probability
# distributions
#
# A cal_dist represents the evaluated probability distribution for a calibrated
# radiocarbon date. It is derived from a cal object via cal_dist().

# Register formal class for S4 compatibility
methods::setOldClass(c("c14_cal_dist", "vctrs_list_of"))

# Constructors ------------------------------------------------------------

#' Calendar probability distribution
#'
#' @description
#' The `cal_dist` class represents a vector of calendar probability
#' distributions.
#'
#' `cal_dist()` is an S3 generic that constructs a new `cal_dist` vector:
#' - From a `cal` object: evaluates the calibrated probability distribution
#' - From a `data.frame`: constructs from raw age and probability density data
#'
#' @param x An object to convert to a `cal_dist`. Currently supports `cal` and
#'   `data.frame` objects.
#' @param ... Additional arguments passed to methods.
#' @param .era [era::era()] object describing the time scale used for ages.
#'   Defaults to calendar years Before Present (`era("cal BP")`). Only used by
#'   the `data.frame` method when ages are not already `era::yr()` vectors.
#'
#' @return
#' A list of data frames with class `cal_dist` (`c14_cal_dist`). Each element
#' has two columns: `age` and `pdens`.
#'
#' @noRd
#' @keywords internal
#'
#' @examples
#' # From data frames:
#' cal_dist(data.frame(age = era::yr(1:10, "cal BP"), pdens = rep(0.1, 10)))
#'
#' # From cal objects:
#' cal <- c14::cal(5000, 10, c14::IntCal20)
#' cal_dist(cal)
cal_dist <- function(x, ...) {
  UseMethod("cal_dist")
}

#' @exportS3Method
#' @noRd
#' @keywords internal
cal_dist.c14_cal <- function(x, at = NULL, ...) {
  ages_list <- cal_dist_ages(x, at)
  f_list <- cal_dist_function(x, at)
  
  purrr::map2(ages_list, f_list, \(x, f) data.frame(age = x, pdens = f(x))) |> 
    new_cal_dist()
}

#' Determine ages at which to evaluate density for each cal object
#' @noRd
#' @keywords internal
cal_dist_ages <- function(cal, at = NULL) {
  if (is.null(at)) {
    purrr::map(cal, cal_dist_ages_sparse)
  } else {
    rep(list(at), length(cal))
  }
}

#' Get sparse grid ages for a single cal object
#' @noRd
#' @keywords internal
cal_dist_ages_sparse <- function(cal_single) {
  indices <- cal_relevant_indices(cal_single)
  curve <- cal_c14_curve(cal_single)
  curve$cal_age[indices]
}

#' Create appropriate density function(s) for cal object(s)
#' @noRd
#' @keywords internal
cal_dist_function <- function(cal, at = NULL) {
  if (is.null(at)) {
    purrr::map(cal, cal_function_sparse)
  } else {
    purrr::map(cal, cal_function)
  }
}

#' @exportS3Method
#' @noRd
#' @keywords internal
cal_dist.data.frame <- function(x, ..., .era = era::era("cal BP")) {
  dfs <- list(x, ...)

  if (!all(purrr::map_lgl(dfs, is.data.frame))) {
    rlang::abort("All arguments to `cal_dist.data.frame()` must be data frames.",
                 class = "c14_invalid_argument")
  }

  dfs <- purrr::map(dfs, purrr::set_names, nm = c("age", "pdens"))
  dfs <- purrr::map_if(dfs, ~!era::is_yr(.[["age"]]),
                       ~data.frame(age = era::yr_set_era(.[["age"]], .era),
                                   pdens = .[["pdens"]]))
  new_cal_dist(dfs)
}

#' @exportS3Method
#' @noRd
#' @keywords internal
cal_dist.default <- function(x, ...) {
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

#' Normalise a cal_dist to sum to 1
#'
#' @param x A `cal_dist` object.
#'
#' @return A `cal_dist` object with normalised probabilities.
#'
#' @noRd
#' @keywords internal
cal_dist_normalise <- function(x) {
  new_cal_dist(purrr::map(vec_data(x), function(df) {
    df$pdens <- df$pdens / sum(df$pdens, na.rm = TRUE)
    df
  }))
}

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
