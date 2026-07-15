# cal_summary.R
# Functions for summarising calibrated radiocarbon dates

# Point estimates ---------------------------------------------------------

#' Point estimates of calibrated radiocarbon dates
#'
#' Functions for deriving a single point estimate of calendar age from calibrated
#' radiocarbon dates. Note that none of these methods produce a *good* estimate
#' \insertCite{Michczynski2007}{c14}, and should only be used as a last resort
#' if the probability distribution function or an interval estimate is not
#' appropriate, in which case [cal_mode()] (the default) is recommended.
#'
#' @param x `cal` object. A vector of calibrated radiocarbon dates.
#' @param quiet Set `quiet = TRUE` to suppress warnings (only used by
#'   [cal_mode()]).
#' @param interval Numeric. The confidence interval for [cal_local_mode()] and
#'   [cal_central()]. Default: 0.954.
#'
#' @details
#'
#' \describe{
#'   \item{`cal_mode()`}{Age corresponding to the maximum peak of the probability
#'     distribution. If `x` has more than one modal value, the first is returned.}
#'   \item{`cal_median()`}{Age corresponding to the median quantile of the
#'     probability distribution.}
#'   \item{`cal_mean()`}{Mean age weighted by probability density.}
#'   \item{`cal_local_mode()`}{Age corresponding to the maximum peak of the
#'     probability distribution within the confidence range specified by
#'     `interval` (**not yet implemented**).}
#'   \item{`cal_central()`}{Age corresponding to the central point of the
#'     probability density within the confidence range specified by `interval`
#'     (**not yet implemented**).}
#' }
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
#' @aliases cal_point
#'
#' @examples
#' x <- c14_calibrate(10000, 30)
#'
#' cal_mode(x)
#' cal_median(x)
#' cal_mean(x)
cal_mode <- function(x, quiet = FALSE) {
  cal_mode_single <- function(x, quiet) {
    dist <- cal_dist(x)
    ages <- dist[[1]]$age
    pdens <- dist[[1]]$pdens

    y <- ages[pdens == max(pdens, na.rm = TRUE) & !is.na(pdens)]
    if (length(y) > 1) {
      y <- y[1]
      if (!isTRUE(quiet)) rlang::warn(
        "`x` has more than one modal value. Only the first will be returned.",
        "c14_ambiguous_summary"
      )
    }
    y
  }
  furrr::future_map_vec(x, cal_mode_single, quiet = quiet)
}

#' @rdname cal_mode
#' @export
cal_median <- function(x) {
  cal_median_single <- function(x) {
    dist <- cal_dist_normalise(cal_dist(x))
    ages <- dist[[1]]$age
    pdens <- dist[[1]]$pdens

    cum_pdens <- cumsum(pdens)
    ages[which(cum_pdens >= 0.5)[1]]
  }
  furrr::future_map_vec(x, cal_median_single)
}

#' @rdname cal_mode
#' @export
cal_mean <- function(x) {
  cal_mean_single <- function(x) {
    dist <- cal_dist(x)
    ages <- dist[[1]]$age
    pdens <- dist[[1]]$pdens

    result <- stats::weighted.mean(as.numeric(ages), pdens)
    era::yr(result, era::yr_era(ages))
  }
  furrr::future_map_vec(x, cal_mean_single)
}

#' @rdname cal_mode
#' @export
cal_local_mode <- function(x, interval = 0.954) {
  rlang::abort(
    "Sorry, `cal_local_mode()` is not yet implemented!",
    "c14_unimplemented_function"
  )
}

#' @rdname cal_mode
#' @export
cal_central <- function(x, interval = 0.954) {
  rlang::abort(
    "Sorry, `cal_central()` is not yet implemented!",
    "c14_unimplemented_function"
  )
}


# Highest Density Regions -------------------------------------------------

#' Highest Density Region and Highest Density Interval
#'
#' @description
#' `cal_hdr()` calculates the Highest Density Region (HDR) for calibrated
#' radiocarbon dates. The HDR is the shortest interval (or set of intervals)
#' that contains the specified proportion of the probability mass.
#'
#' `cal_hdi()` calculates the Highest Density Interval (HDI), which is the
#' single shortest contiguous interval containing the specified proportion of
#' the probability mass. Unlike `cal_hdr()`, which can return multiple intervals
#' for multimodal distributions, `cal_hdi()` always returns exactly one interval.
#'
#' @param x A [cal] vector of calibrated radiocarbon dates.
#' @param interval Numeric. The probability content of the HDR/HDI. Default:
#'   0.954 (approximately 2 standard deviations).
#'
#' @return
#' For `cal_hdr()`: A list of the same length as `x`. Each element is a list of
#' numeric vectors, where each vector has two elements: the start and end ages
#' of an HDR interval. For multimodal distributions, multiple intervals may be
#' returned.
#'
#' For `cal_hdi()`: A list of the same length as `x`. Each element is a numeric
#' vector with two elements: the start and end ages of the HDI interval.
#'
#' @family functions for summarising calibrated radiocarbon dates
#' @export
#'
#' @examples
#' x <- c14_calibrate(5000, 10)
#' cal_hdr(x)
#' cal_hdi(x)
#' cal_hdr(x, interval = 0.683)
#' cal_hdi(x, interval = 0.683)
cal_hdr <- function(x, interval = 0.954) {
  dists <- cal_dist_interpolate(cal_dist(x))
  purrr::map(dists, cal_hdr_single, interval = interval)
}

#' @rdname cal_hdr
#' @export
cal_hdi <- function(x, interval = 0.954) {
  dists <- cal_dist_interpolate(cal_dist(x))
  purrr::map(dists, cal_hdi_single, interval = interval)
}

#' @noRd
#' @keywords internal
cal_density_threshold <- function(pdens_norm, interval = 0.954) {
  pdens_norm <- pdens_norm[!is.na(pdens_norm)]
  sorted_idx <- order(pdens_norm, decreasing = TRUE)
  cum_prob <- cumsum(pdens_norm[sorted_idx])

  threshold_idx <- which(cum_prob >= interval)[1]
  if (is.na(threshold_idx)) {
    threshold_idx <- length(sorted_idx)
  }

  pdens_norm[sorted_idx[threshold_idx]]
}

#' @noRd
#' @keywords internal
cal_threshold_ages <- function(ages, pdens_norm, threshold) {
  ages[!is.na(pdens_norm) & pdens_norm >= threshold]
}

#' @noRd
#' @keywords internal
cal_hdr_single <- function(dist, interval = 0.954) {
  dist <- cal_dist_normalise(list(dist))
  ages <- dist[[1]]$age
  pdens_norm <- dist[[1]]$pdens

  threshold <- cal_density_threshold(pdens_norm, interval)
  threshold_ages <- cal_threshold_ages(ages, pdens_norm, threshold)

  in_hdr <- ages %in% threshold_ages
  runs <- rle(in_hdr)
  endpoints <- c(0, cumsum(runs$lengths))

  # Get indices of TRUE runs
  true_runs <- which(runs$values)

  # Calculate start and end indices for each TRUE run
  start_indices <- endpoints[true_runs] + 1
  end_indices <- endpoints[true_runs + 1]

  # Extract ages for each interval and compute min/max
  intervals <- purrr::map2(start_indices, end_indices, function(start, end) {
    interval_ages <- ages[start:end]
    c(min(interval_ages), max(interval_ages))
  })

  intervals
}

#' @noRd
#' @keywords internal
cal_hdi_single <- function(dist, interval = 0.954) {
  dist <- cal_dist_normalise(list(dist))
  ages <- dist[[1]]$age
  pdens_norm <- dist[[1]]$pdens

  threshold <- cal_density_threshold(pdens_norm, interval)
  threshold_ages <- cal_threshold_ages(ages, pdens_norm, threshold)

  c(min(threshold_ages), max(threshold_ages))
}

# Probability within an interval -------------------------------------------

#' Probability that a calibrated date falls within an age range
#'
#' Calculates the probability that a calibrated radiocarbon date falls within a
#' given calendar age range or a single year.
#'
#' @param x A [cal] vector of calibrated radiocarbon dates.
#' @param from Numeric. Start of the age range (inclusive), in the same era as
#'   the calibration (typically cal BP).
#' @param to Numeric or `NULL`. End of the age range (inclusive). If `NULL`
#'   (the default), returns the probability mass at the single year given by
#'   `from`.
#'
#' @return
#' Numeric vector of probabilities between 0 and 1, the same length as `x`.
#'
#' @source
#' Rundkvist, Martin. 20 November 2024. Radiocarbon in the AD 900s on 
#' Riddarholmen. *Aardvarchaeology*. <https://aardvarchaeology.wordpress.com/2024/11/20/radiocarbon-in-the-ad-900s-on-riddarholmen/>
#'
#' @family functions for summarising calibrated radiocarbon dates
#' @seealso 
#' This function is the inverse of [cal_hdi()] and [cal_hdr()], which find 
#' intervals for a given probability mass.
#'
#' @export
#'
#' @examples
#' x <- c14_calibrate(1116, 30)
#'
#' # Probability within an age range
#' cal_probability(x, 970, 1060)
#'
#' # Probability at a single year
#' cal_probability(x, 5000)
cal_probability <- function(x, from, to = NULL) {
  if (is.null(to)) to <- from
  ages_list <- purrr::map(cal_dist(x), function(d) {
    seq(min(d$age), max(d$age), by = 1)
  })
  dists <- cal_dist_normalise(cal_dist(x, at = ages_list))
  purrr::map_dbl(dists, function(d) {
    sum(d$pdens[d$age >= from & d$age <= to], na.rm = TRUE)
  })
}
