# cal_summary.R
# Functions for summarising calibrated radiocarbon dates

#' Point estimates of calibrated radiocarbon dates
#'
#' This function implements a number of methods for deriving a single point
#' estimate of calendar age from calibrated radiocarbon dates. Note that none of
#' these methods produce a *good* estimate \insertCite{Michczynski2007}{c14},
#' and should only be used as a last resort if the probability distribution
#' function or an interval estimate is not appropriate, in which case
#' `method = "mode"` (the default) is recommended.
#'
#' @param x `cal` object. A vector of calibrated radiocarbon dates.
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
#'
#' @return
#' Numeric vector the same length as `x` giving the point estimate for each
#' calibrated date.
#'
#' @references
#' \insertAllCited{}
#'
#' @export
#'
#' @examples
#' cal_point(c14_calibrate(10000, 30, verbose = FALSE))
cal_point <- function(x,
                      method = c("mode", "median", "mean", "local_mode", "central"),
                      interval = 0.954) {
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

  purrr::map(x, f, interval)
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
cal_mode <- function(x, ...) {
  y <- x$year[x$p == max(x$p)]
  if (length(y) > 1) {
    y <- y[1]
    rlang::warn(
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
  x$year[x$p == stats::quantile(x$p, 0.5)]
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
  stats::weighted.mean(x$year, x$p)
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
