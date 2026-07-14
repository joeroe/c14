# cal_summary.R
# Functions for summarising calibrated radiocarbon dates

# Point estimates ---------------------------------------------------------

#' Point estimates of calibrated radiocarbon dates
#'
#' This function implements a number of methods for deriving a single point
#' estimate of calendar age from calibrated radiocarbon dates. Note that none of
#' these methods produce a *good* estimate \insertCite{Michczynski2007}{c14},
#' and should only be used as a last resort if the probability distribution
#' function or an interval estimate is not appropriate, in which case
#' `method = "mode"` (the default) is recommended.
#'
#' @param x `cal` object. A vector of calibrated radiocarbon dates
#' @param method Character. Method of estimation:
#'   \describe{
#'     \item{`"mode"` (default)}{age corresponding to the maximum peak of the probability distribution}
#'     \item{`"median"`}{age corresponding to the median quantile of the probability distribution}
#'     \item{`"mean"`}{mean age weighted by probability density}
#'     \item{`"local_mode"`}{age corresponding to the maximum peak of the probability
#'      distribution within the confidence range specified by `interval` (**not yet
#'      implemented**)}
#'     \item{`"central"`}{age corresponding to the central point of the probability
#'      density within the confidence range specified by `interval` (**not yet
#'      implemented**)}
#'   }
#' @param interval Numeric. Only used for `method = "local_mode"` and
#'  `method = "central"`.
#' @param quiet Set `quiet = TRUE` to suppress warnings and messages
#'
#' @details
#'
#' If `x` has more than one modal value, `cal_point(x, method = "mode")` will
#' return the first.
#'
#' @return
#' Numeric vector the same length as `x` giving the point estimate for each
#' calibrated date.
#'
#' @references
#' \insertAllCited{}
#'
#' @family functions for summarising calibrated radiocarbon dates
#'
#' @export
#'
#' @examples
#' cal_point(c14_calibrate(10000, 30))
cal_point <- function(x,
                      method = c("mode", "median", "mean", "local_mode", "central"),
                      interval = 0.954,
                      quiet = FALSE) {
  # TODO: Check/cast x
  method <- rlang::arg_match(method)

  f <- switch(
    method,
    mode = cal_mode,
    median = cal_median,
    mean = cal_mean,
    local_mode = cal_local_mode,
    central = cal_central
  )

  # Flatten to era_yr
  vec_c(!!!furrr::future_map(x, f, interval = interval, quiet = quiet))
}

#' Mode of a calibrated radiocarbon date
#'
#' Calculates the age "corresponding to the maximum of the density function"
#'  (Michczynski 2007).
#' Issues a warning if more than one modal value is returned (unlikely).
#' Not vectorised.
#'
#' @noRd
#' @keywords internal
cal_mode <- function(x, quiet = FALSE, ...) {
  dist <- cal_as_cal_dist(x)
  age <- cal_dist_age(dist)[[1]]
  pdens <- cal_dist_pdens(dist)[[1]]
  
  y <- age[pdens == max(pdens, na.rm = TRUE) & !is.na(pdens)]
  if (length(y) > 1) {
    y <- y[1]
    if (!isTRUE(quiet)) rlang::warn(
      "`x` has more than one modal value. Only the first will be returned.",
         "c14_ambiguous_summary"
    )
  }
  y
}

#' Median of a calibrated radiocarbon date
#'
#' Calculates the age corresponding to the median quantile of the probability
#' distribution (Michczynski 2007).
#' Not vectorised.
#'
#' @noRd
#' @keywords internal
cal_median <- function(x, ...) {
  dist <- cal_as_cal_dist(x)
  age <- cal_dist_age(dist)[[1]]
  pdens <- cal_dist_pdens(dist)[[1]]
  
  cum_pdens <- cumsum(pdens) / sum(pdens)
  age[which(cum_pdens >= 0.5)[1]]
}

#' Mean of a calibrated radiocarbon date
#'
#' Calculates the mean age weighted by the probability distribution function
#'  (Michczynski 2007).
#' Not vectorised.
#'
#' @noRd
#' @keywords internal
cal_mean <- function(x, ...) {
  dist <- cal_as_cal_dist(x)
  age <- cal_dist_age(dist)[[1]]
  pdens <- cal_dist_pdens(dist)[[1]]
  
  result <- stats::weighted.mean(as.numeric(age), pdens)
  era::yr(result, era::yr_era(age))
}

#' Local mode of a calibrated radiocarbon date
#'
#' Calculates the age corresponding to the mode (cal_mode()) of the probability
#' distribution within a given confidence interval (Michczynski 2007).
#' Not vectorised.
#'
#' @noRd
#' @keywords internal
cal_local_mode <- function(x, interval = 0.954, ...) {
  rlang::abort("Sorry, `cal_local_mode()` is not yet implemented!",
        "c14_unimplemented_function")
}

#' Central point of a calibrated radiocarbon date
#'
#' Calculates the age corresponding to the central point of the probability
#' distribution (Michczynski 2007), within a confidence interval if
#' `interval < 1`.
#' Not vectorised.
#'
#' @noRd
#' @keywords internal
cal_central <- function(x, interval = 1, ...) {
  rlang::abort("Sorry, `cal_central()` is not yet implemented!",
        "c14_unimplemented_function")
}


# Simple ranges -----------------------------------------------------------

#' Range of a calendar probability distribution
#'
#' Functions for calculating the minimum and maximum ages of a [cal] vector.
#' This function does not take into account the probability distribution.
#'
#' @param x A [cal] vector of calendar probability distributions.
#' @param min_pdens Ignores ages with values less than the given value when
#'   calculating the minimum or maximum. Default: 0.
#'
#' @return A data frame with two columns giving the minimum (`min`) and maximum
#' (`max`) ages.
#'
#' @family functions for summarising calibrated radiocarbon dates
#' @export
#'
#' @examples
#' x <- c14_calibrate(c(10000, 9000, 8000), rep(10, 3))
#'
#' cal_age_min(x)
#' cal_age_max(x)
#' cal_age_range(x)
cal_age_range <- function(x, min_pdens = 0) {
  vec_cbind(
    min = cal_age_min(x, min_pdens),
    max = cal_age_max(x, min_pdens)
  )
}

#' @rdname cal_age_range
#' @export
cal_age_min <- function(x, min_pdens = 0) {
  dist <- vec_c(!!!purrr::map(x, cal_as_cal_dist))
  dist <- cal_dist_crop(dist, min_pdens)
  cal_dist_age_min(dist)
}

#' @rdname cal_age_range
#' @export
cal_age_max <- function(x, min_pdens = 0) {
  dist <- vec_c(!!!purrr::map(x, cal_as_cal_dist))
  dist <- cal_dist_crop(dist, min_pdens)
  cal_dist_age_max(dist)
}