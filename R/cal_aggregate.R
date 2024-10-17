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
#' @param normalise Whether to normalise the summed distribution to sum to 1.
#'   The default is not to normalise.
#' @param ... Not used
#'
#' @return The summed probability distribution as a [cal] vector.
#'
#' @family functions for aggregating calendar probability distributions
#' @export
#'
#' @examples
#' shub1_cal <- c14_calibrate(shub1_c14$c14_age, shub1_c14$c14_error)
#' cal_sum(shub1_cal)
cal_sum <- function(x, range = cal_age_common(x), normalise = FALSE, ...) {
  # TODO: ensure x and range have the same era - or is this a job for cal validation?
  x <- cal_interpolate(x, range)

  pdens_mat <- do.call(rbind, cal_pdens(x))
  pdens_sum <- colSums(pdens_mat, na.rm = TRUE)
  if (isTRUE(normalise)) pdens_sum <- pdens_sum / sum(pdens_sum, na.rm = TRUE)

  new_cal(list(data.frame(age = cal_age(x)[[1]], pdens = pdens_sum)))
}
