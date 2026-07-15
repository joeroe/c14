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
  furrr::future_map_vec(x, f, interval = interval, quiet = quiet)
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

#' Median of a calibrated radiocarbon date
#'
#' Calculates the age corresponding to the median quantile of the probability
#' distribution (Michczynski 2007).
#' Not vectorised.
#'
#' @noRd
#' @keywords internal
cal_median <- function(x, ...) {
  dist <- cal_dist_normalise(cal_dist(x))
  ages <- dist[[1]]$age
  pdens <- dist[[1]]$pdens

  cum_pdens <- cumsum(pdens)
  ages[which(cum_pdens >= 0.5)[1]]
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
  dist <- cal_dist(x)
  ages <- dist[[1]]$age
  pdens <- dist[[1]]$pdens
  
  result <- stats::weighted.mean(as.numeric(ages), pdens)
  era::yr(result, era::yr_era(ages))
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

#' Range of calibrated radiocarbon dates
#'
#' Functions for calculating the minimum and maximum ages of a [cal] vector.
#' The range is determined by the probability distribution, with the extent
#' controlled by the `min_pdens` parameter.
#'
#' @param x A [cal] vector of calendar probability distributions.
#' @param min_pdens Controls the minimum probability density threshold used to
#'   determine boundaries. The default is `pdens > 0` within a plausible range
#'   around the calibrated date. Set `min_pdens` to a value between 0 and 1 to
#'   futher constrain the range or set `min_pdens = 0` to find the absolute
#'   boundaries on the full range of the calibration curve.
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
cal_age_range <- function(x, min_pdens = NULL) {
  vec_cbind(
    min = cal_age_min(x, min_pdens),
    max = cal_age_max(x, min_pdens)
  )
}

#' @rdname cal_age_range
#' @export
cal_age_min <- function(x, min_pdens = NULL) {
  cal_age_bound(x, min_pdens, min)
}

#' @rdname cal_age_range
#' @export
cal_age_max <- function(x, min_pdens = NULL) {
  cal_age_bound(x, min_pdens, max)
}

#' @noRd
#' @keywords internal
cal_age_bound <- function(x, min_pdens = NULL, fn) {
  # Only use full curve when min_pdens is explicitly set to 0
  if (!is.null(min_pdens) && min_pdens == 0) {
    curve <- cal_c14_curve(x)
    dists <- cal_dist(x, at = curve$cal_age)
  } else {
    # Use sparse grid (default for NULL and > 0)
    dists <- cal_dist(x)
  }
  
  ages <- cal_dist_age(dists)
  pdens <- cal_dist_pdens(dists)
  
  purrr::map2_vec(ages, pdens, function(age, pdens) {
    # Treat NULL as 0 (no filtering)
    threshold <- if (is.null(min_pdens)) 0 else min_pdens
    if (threshold > 0) {
      valid <- !is.na(pdens) & pdens >= threshold
      if (!any(valid)) {
        return(fn(age, na.rm = TRUE))
      }
      age <- age[valid]
    }
    fn(age, na.rm = TRUE)
  })
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
  ages[pdens_norm >= threshold]
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
