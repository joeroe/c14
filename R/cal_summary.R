# cal_summary.R
# Functions for summarising calibrated radiocarbon dates

# Helper functions ---------------------------------------------------------

#' Find relevant curve indices for a cal object
#'
#' Finds indices of calibration curve points where the density is likely to be
#' non-negligible. Uses a heuristic based on the combined error of the date and
#' curve.
#'
#' @param cal A `cal` object of length 1.
#' @param k Number of standard deviations to include. Default: 6 (covers 99.9999998%).
#'
#' @return Integer vector of indices into the calibration curve.
#'
#' @noRd
#' @keywords internal
cal_relevant_indices <- function(cal, k = 6) {
  if (length(cal) != 1) {
    rlang::abort("`cal_relevant_indices()` expects a `cal` of length 1.",
                 class = "c14_invalid_argument")
  }

  c14_age <- field(cal, "c14_age")
  c14_error <- field(cal, "c14_error")
  curve <- cal_c14_curve(cal)

  combined_error <- sqrt(c14_error^2 + curve$c14_error^2)
  which(abs(curve$c14_age - c14_age) < k * combined_error)
}

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
  indices <- cal_relevant_indices(x)
  curve <- cal_c14_curve(x)
  ages <- curve$cal_age[indices]
  
  f <- cal_function_sparse(x)
  pdens <- f(ages)
  
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
  indices <- cal_relevant_indices(x)
  curve <- cal_c14_curve(x)
  ages <- curve$cal_age[indices]
  
  f <- cal_function_sparse(x)
  pdens <- f(ages)
  
  cum_pdens <- cumsum(pdens) / sum(pdens)
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
  indices <- cal_relevant_indices(x)
  curve <- cal_c14_curve(x)
  ages <- curve$cal_age[indices]
  
  f <- cal_function_sparse(x)
  pdens <- f(ages)
  
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
  vec_c(!!!purrr::map(x, function(cal) {
    indices <- cal_relevant_indices(cal)
    curve <- cal_c14_curve(cal)
    ages <- curve$cal_age[indices]
    
    f <- cal_function_sparse(cal)
    pdens <- f(ages)
    
    if (min_pdens > 0) {
      valid <- !is.na(pdens) & pdens >= min_pdens
      if (!any(valid)) {
        return(min(ages, na.rm = TRUE))
      }
      ages <- ages[valid]
    }
    
    min(ages, na.rm = TRUE)
  }))
}

#' @rdname cal_age_range
#' @export
cal_age_max <- function(x, min_pdens = 0) {
  vec_c(!!!purrr::map(x, function(cal) {
    indices <- cal_relevant_indices(cal)
    curve <- cal_c14_curve(cal)
    ages <- curve$cal_age[indices]
    
    f <- cal_function_sparse(cal)
    pdens <- f(ages)
    
    if (min_pdens > 0) {
      valid <- !is.na(pdens) & pdens >= min_pdens
      if (!any(valid)) {
        return(max(ages, na.rm = TRUE))
      }
      ages <- ages[valid]
    }
    
    max(ages, na.rm = TRUE)
  }))
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
  purrr::map(x, cal_hdr_single, interval = interval)
}

#' @rdname cal_hdr
#' @export
cal_hdi <- function(x, interval = 0.954) {
  purrr::map(x, cal_hdi_single, interval = interval)
}

#' @noRd
#' @keywords internal
cal_density_grid <- function(cal) {
  if (length(cal) != 1) {
    rlang::abort("`cal_density_grid()` expects a `cal` of length 1.",
                 class = "c14_invalid_argument")
  }

  indices <- cal_relevant_indices(cal)
  curve <- cal_c14_curve(cal)
  ages <- curve$cal_age[indices]
  
  f <- cal_function_sparse(cal)
  pdens <- f(ages)
  
  pdens_norm <- pdens / sum(pdens, na.rm = TRUE)
  
  list(ages = ages, pdens_norm = pdens_norm)
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
cal_hdr_single <- function(cal, interval = 0.954) {
  grid <- cal_density_grid(cal)
  ages <- grid$ages
  pdens_norm <- grid$pdens_norm
  
  threshold <- cal_density_threshold(pdens_norm, interval)
  threshold_ages <- cal_threshold_ages(ages, pdens_norm, threshold)
  
  in_hdr <- ages %in% threshold_ages
  runs <- rle(in_hdr)
  endpoints <- c(0, cumsum(runs$lengths))
  
  intervals <- list()
  for (i in seq_along(runs$lengths)) {
    if (runs$values[i]) {
      start_idx <- endpoints[i] + 1
      end_idx <- endpoints[i + 1]
      interval_ages <- ages[start_idx:end_idx]
      intervals[[length(intervals) + 1]] <- c(min(interval_ages), max(interval_ages))
    }
  }
  
  intervals
}

#' @noRd
#' @keywords internal
cal_hdi_single <- function(cal, interval = 0.954) {
  grid <- cal_density_grid(cal)
  ages <- grid$ages
  pdens_norm <- grid$pdens_norm
  
  threshold <- cal_density_threshold(pdens_norm, interval)
  threshold_ages <- cal_threshold_ages(ages, pdens_norm, threshold)
  
  c(min(threshold_ages), max(threshold_ages))
}
