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

#' @rdname cal_sum
#' @export
sum.c14_cal <- function(x, range = cal_age_common(x), normalise = FALSE, ...) {
  cal_sum(x, range = range, normalise = normalise, ...)
}

#' Kernel density estimation of calendar probability distributions
#'
#' Aggregates calibrated radiocarbon dates and other calendar probability
#' distributions using the bootstrapped composite kernel density estimate (cKDE)
#' method \insertCite{Brown2017,McLaughlin2019}{c14}. This involves repeatedly
#' computing the kernel density estimate of a random sample of ages drawn from
#' the calendar probability distributions provided and deriving a mean estimate
#' and confidence interval from the resulting bootstrapped set.
#'
#' @param x A [cal] vector of calendar probability distributions
#' @param bw Kernel bandwidth size passed to [stats::density()]. Can be either
#'   an integer value or a character selection rule, but the latter will likely
#'   result in a different bandwidth being applied to each bootstrapped sample
#'   and therefore should be avoided. Default: `30` (years).
#' @param ... Further arguments passed to [stats::density()]
#' @param times Number of bootstrap samples to generate. The default of `25` is
#'   suitable for testing but should be set much higher in practice.
#'
#' @details
#' See \insertCite{McLaughlin2019;textual}{c14} and
#' \insertCite{Crema2022;textual}{c14} for discussions of bandwith selection.
#'
#' @return
#' The result as a data frame or [tibble::tibble] with three columns: `age`
#' (interpolated to common range of `x`), `.estimate` (mean of the bootstrapped
#' KDEs), and `.error` (standard error of the bootstrapped KDEs).
#'
#' @references \insertAllCited{}
#'
#' @export
#'
#' @examples
#' data(shub1_c14)
#' shub1_cal <- c14_calibrate(shub1_c14$c14_age, shub1_c14$c14_error)
#' cal_density(shub1_cal)
cal_density <- function(x, bw = 30, ..., times = 25) {
  # TODO: guard against character argument to bw?

  age_grid <- cal_age_common(x)

  bootstrap <- do.call(rbind, cal_sample(x, times))
  kdes <- apply(bootstrap, 2, stats::density, bw = bw,
                from = min(age_grid), to = max(age_grid), ...,
                simplify = FALSE)

  x <- kdes[[1]]$x
  y <- do.call(rbind, purrr::map(kdes, "y"))
  tibble::tibble(
    age = age_grid,
    .estimate = stats::approx(x, colMeans(y, na.rm = TRUE), xout = age_grid)$y,
    .error = stats::approx(x, apply(y, 2, stats::sd, na.rm = TRUE),
                           xout = age_grid)$y
  )
}

#' @rdname cal_density
#' @export
density.c14_cal <- function(x, bw = 30, ..., times = 25) {
  cal_density(x, bw = bw, ..., times = times)
}

#' Randomly sample from calendar probability distributions
#'
#' @noRd
#' @keywords internal
# TODO: worth exporting?
cal_sample <- function(x, times) {
  purrr::map2(cal_age(x), cal_pdens(x), function(x, y, s) {
    sample(x, s, replace = TRUE, prob = y)
  }, s = times)
}