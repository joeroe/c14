# S3 class representing calibrated dates

# Constructor functions ---------------------------------------------------

# new_cal <- function(x = data.frame(year = integer(0), p = numeric(0)), ...) {
#   if (ncol(x) == 2) {
#     colnames(x) <- c("year", "p")
#   }
#   else if (ncol(x) == 3) {
#     colnames(x) <- c("year", "p", "bayesian")
#   }
#   else {
#     stop("`x` must be a data frame with 2 or 3 columns.")
#   }
#
#   attrs <- list(...)
#
#   class(x) <- c("cal", "data.frame")
#   attributes(x) <- c(attributes(x), attrs)
#
#   return(x)
# }


# validate_cal <- function() {
#
# }


# Print methods --------------------------------------------------------------

#' @rdname cal
# print.cal <- function(x, ...) {
#   #TODO: Method for Bayesian calibrated dates
#   if ("bayesian" %in% names(x)) {
#     x <- x[x$bayesian == "prior",]
#   }
#
#   start <- max(x$year)
#   end <- min(x$year)
#   era <- attr(x, "era")
#
#   metadata <- cal_metadata(x)
#
#   cli::cli_text("# Calibrated probability distribution from {start} to {end} {era}")
#   cli::cat_line()
#   cal_txtplot(x)
#   cli::cat_line()
#   # TODO: Messy – should probably refactor into its own function
#   if(!is.null(metadata$lab_id)) {
#     cli::cli_dl(list(`Lab ID` = metadata$lab_id))
#     metadata$lab_id <- NULL
#   }
#   if(!is.null(metadata$cra)) {
#     cli::cli_dl(list(`Uncalibrated` = glue::glue("{metadata$cra}\u00B1{metadata$error} uncal BP")))
#     metadata$cra <- NULL
#     metadata$error <- NULL
#   }
#   if(!is.null(metadata$calibration_range) &&
#      !all(is.na(metadata$calibration_range))) {
#     metadata$calibration_range <- glue::glue("{metadata$calibration_range[1]}\u2013{metadata$calibration_range[2]} BP")
#   }
#   cli::cli_dl(metadata)
#
#   invisible(x)
# }

cal_txtplot <- function(x, height = 8, margin = 2) {
  width <- cli::console_width()
  if (width > 80) width <- 80

  # Plot geometries
  geom_area <- cal_txtplot_geom_area(x, width - margin, height - 2)

  # Axis & labels
  # TODO: Detect direction of year
  nbreaks <- floor((width - margin) / (max(nchar(round(x$year))) * 3))
  breaks <- pretty(x$year, nbreaks - 1)
  while (sum(nchar(breaks)) >= (width - margin)) {
    nbreaks <- nbreaks - 1
    breaks <- pretty(x$year, nbreaks - 1)
  }
  xaxis <- cal_txtplot_scale(x$year, breaks, width - margin)
  labels <- cal_txtplot_labels(x$year, breaks, width - margin)

  # Print
  cli::cat_line(stringr::str_pad(geom_area, width, side = "left"))
  cli::cat_line(stringr::str_pad(xaxis, width, side = "left"))
  cli::cat_line(stringr::str_pad(labels, width, side = "left"))
}

cal_txtplot_geom_area <- function(x, width, height) {
  k <- stats::ksmooth(x$year, x$p,
                      bandwidth = abs(max(x$year) - min(x$year)) / width,
                      n.points = width)
  k$y[is.na(k$y)] <- 0
  k$y <- round((k$y / max(k$y)) * height)

  stringr::str_dup("#", k$y) %>%
    stringr::str_pad(height, side = "left") %>%
    stringr::str_split(pattern = "", simplify = TRUE) %>%
    apply(2, paste0, collapse = "")
}

cal_txtplot_scale <- function(x, breaks, width) {
  breakpoints <- cal_txtplot_breakpoints(x, breaks, width)

  axis <- rep("-", width)
  axis[breakpoints] <- "|"
  paste(axis, collapse = "")
}

cal_txtplot_labels <- function(x, breaks, width) {
  breakpoints <- cal_txtplot_breakpoints(x, breaks, width)

  labels <- stringr::str_pad(breaks[-1], c(diff(breakpoints)), side = "left")
  paste(labels, collapse = "")
}

cal_txtplot_breakpoints <- function(x, breaks, width) {
  if (x[1] > x[length(x)]) {
    x <- -x
    breaks <- -breaks
  }
  sort(round(findInterval(breaks, x) / length(x) * width))
}

# S3 Methods ------------------------------------------------------------------

#' @export
min.cal <- function(...) {
  cals <- rlang::list2(...)
  cals <- dplyr::bind_rows(cals)
  cals[cals$p <= 0] <- NULL
  max(cals$year)
}

#' @export
max.cal <- function(...) {
  cals <- rlang::list2(...)
  cals <- dplyr::bind_rows(cals)
  cals[cals$p <= 0] <- NULL
  min(cals$year)
}
