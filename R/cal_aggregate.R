# cal_aggregate.R
# Functions for aggregating calibrated radiocarbon dates and other calendar
# probability distributions

#' Sum calendar probability distributions
#'
#' Aggregates a vector of calendar probability distributions (such as calibrated
#' radiocarbon dates) by summing them over a given range of ages.
#'
#' @param x A [cal] vector of calendar probability distributions
#' @param range Range of ages over which to sum. Defaults to the maximum range
#'   of `x` at one year resolution.
#' @param ... Not used
#'
#' @return The summed probability distribution as a [cal] vector.
#'
#' @details
#' This function can be evaluated in parallel using [future::plan()], which
#' substantially speeds up the computation for large sets of dates.
#'
#' @family functions for aggregating calendar probability distributions
#' @export
#'
#' @examples
#' ppnd_cal <- c14_calibrate(ppnd$cra, ppnd$error)
#' cal_sum(ppnd_cal)
cal_sum <- function(x, range = cal_age_common(x), ...) {
  # TODO: ensure x and range have the same era - or is this a job for cal validation?
  x <- cal_interpolate(x, range)
  # TODO: normalise?
  pdens_sum <- furrr::future_pmap_dbl(cal_pdens(x), \(...) sum(..., na.rm = TRUE))
  new_cal(list(data.frame(age = cal_age(x)[[1]], pdens = pdens_sum)))
}