# plot.R
# Default plot method for cal objects

#' Plot calibrated radiocarbon dates
#'
#' @description
#' Plots each element of a [cal] vector as a separate calendar probability
#' distribution. Use `par(mfrow)` or `par(mfcol)` to arrange multiple plots.
#'
#' @param x A [cal] vector of calibrated radiocarbon dates.
#' @param ... Additional arguments passed to [plot.default()].
#' @param max.plot Maximum number of plots to generate. A warning is issued if
#'   `length(x) > max.plot` and only the first `max.plot` elements will be
#'   plotted. Default: `20`.
#' @param resolution Resolution of the age grid in years. If `NULL` (default),
#'   automatically calculated to produce approximately 500 points across the
#'   age range for smooth curves.
#' @param fixed_xlim Logical. If `TRUE`, all plots share the same x-axis range
#'   (calculated from all dates). If `FALSE` (default), each plot uses its own
#'   age range focused on that specific date.
#' @param show_curve Logical. If `TRUE` (default), plot the calibration curve
#'   as the main plot with the probability distribution overlaid on the right
#'   y-axis. If `FALSE`, only show the probability distribution.
#'
#' @return
#' Invisibly returns `NULL`. Called for its side effect of generating plots.
#'
#' @export
#'
#' @examples
#' x <- cal(c(1000, 2000, 3000), c(30, 40, 50), IntCal20)
#' plot(x)
#'
#' # Arrange multiple plots
#' par(mfrow = c(2, 2))
#' plot(x)
#' dev.off()
#'
#' # Use same fixed x axis limits for all plots
#' plot(x, fixed_xlim = TRUE)
#'
#' # Hide calibration curve
#' plot(x[1], show_curve = FALSE)
plot.c14_cal <- function(x, ..., max.plot = 20, resolution = NULL, fixed_xlim = FALSE, show_curve = TRUE) {
  n <- length(x)
  if (n == 0) {
    return(invisible(NULL))
  }

  if (n > max.plot) {
    rlang::warn(
      sprintf(
        "`x` has %d elements, which exceeds `max.plot = %d`. Only the first %d elements will be plotted.",
        n, max.plot, max.plot
      ),
      class = "c14_exceeded_max_plot"
    )
    x <- x[seq_len(max.plot)]
    n <- max.plot
  }

  # Calculate age ranges and resolution(s) (just one if fixed_xlim = TRUE)
  min_age <- as.numeric(cal_age_min(x, min_pdens = 0.00001))
  max_age <- as.numeric(cal_age_max(x, min_pdens = 0.00001))
  age_ranges <- if (isTRUE(fixed_xlim)) {
    list(data.frame(min = min(min_age), max = max(max_age)))
  }
  else {
    purrr::map2(min_age, max_age, \(x, y) data.frame(min = x, max = y))
  }
  
  # Calculate resolutions and age grids
  resolutions <- purrr::map(age_ranges, function(range) {
    if (is.null(resolution)) {
      (range$max - range$min) / 500
    } else {
      resolution
    }
  })
  
  age_grids <- purrr::map2(age_ranges, resolutions, function(range, res) {
    seq(range$min, range$max, by = res)
  })
  
  # Compute distributions
  dists <- purrr::map2(x, age_grids, function(cal_single, at) {
    cal_dist(cal_single, at = at)
  })
  
  # Plot each distribution
  purrr::walk2(dists, x, function(dist, cal_single) {
    plot_cal_single(dist[[1]], cal_single, show_curve = show_curve, ...)
  })

  invisible(NULL)
}

#' Plot a single calendar probability distribution
#'
#' @param dist A single `cal_dist` element (data frame with `age` and `pdens`).
#' @param cal_single A single `cal` element (for accessing calibration curve and c14 data).
#' @param show_curve Logical. If `TRUE`, overlay the calibration curve.
#' @param main Plot title. Default: auto-generated from calibration parameters.
#' @param xlab X-axis label. Default: `"Calendar age (cal BP)"`.
#' @param ylab Y-axis label. Default: `expression("Radiocarbon age ("^14*"C yr BP)")`.
#' @param rev_x Logical. Reverse the x-axis? Default: `TRUE`.
#' @param col Fill colour for the distribution. Default: `"black"`.
#' @param border Outline colour. Default: same as `col`.
#' @param ... Additional arguments passed to [plot.default()].
#'
#' @importFrom graphics plot polygon segments lines axis mtext par abline
#' @importFrom grDevices adjustcolor
#' @noRd
#' @keywords internal
plot_cal_single <- function(dist,
                             cal_single,
                             show_curve = TRUE,
                             main = NULL,
                             xlab = "Calendar age (cal BP)",
                             ylab = expression("Radiocarbon age ("^14*"C yr BP)"),
                             rev_x = TRUE,
                             col = "black",
                             border = NULL,
                             ...) {
  ages <- dist$age
  pdens <- dist$pdens

  if (is.null(border)) border <- col

  # Generate default main title from calibration parameters
  if (is.null(main)) {
    c14_age <- vctrs::field(cal_single, "c14_age")
    c14_error <- vctrs::field(cal_single, "c14_error")
    curve <- cal_c14_curve(cal_single)
    curve_name <- attr(curve, "name")
    if (is.null(curve_name)) curve_name <- "unknown"
    
    main <- bquote(.(as.integer(c14_age)) * "\u00b1" * .(as.integer(c14_error)) ~ ""^{14} * "C yr BP (" * .(curve_name) * ")")
  }

  # Compute HDI intervals
  hdi_99 <- cal_hdi_single(dist, interval = 0.997)
  hdi_95 <- cal_hdi_single(dist, interval = 0.954)
  hdi_68 <- cal_hdi_single(dist, interval = 0.682)

  # Set up plot
  xlim <- range(ages, na.rm = TRUE)

  if (rev_x) {
    xlim <- rev(xlim)
  }

  if (show_curve) {
    # Increase right margin for right y-axis label
    old_mar <- par("mar")
    par(mar = c(old_mar[1], old_mar[2], old_mar[3], old_mar[4] + 2))
    on.exit(par(mar = old_mar))
    
    # Plot calibration curve as main plot
    plot_cal_draw_curve_main(cal_single, xlim, ylab, xlab, main, rev_x, col)
    
    # Overlay probability distribution on right y-axis
    plot_cal_draw_dist_overlay(ages, pdens, xlim, col, border, hdi_99, hdi_95, hdi_68)
  } else {
    # Original behavior: probability distribution as main plot
    ylim <- c(0, max(pdens, na.rm = TRUE))
    
    plot(
      ages,
      pdens,
      type = "n",
      main = main,
      xlab = xlab,
      ylab = ylab,
      xlim = xlim,
      ylim = ylim,
      bty = "n",
      ...
    )

    # Draw full distribution (transparent)
    plot_cal_draw_polygon(ages, pdens, col = adjustcolor(col, 0), border = NA)

    # Draw 99.7% HDI (33% opacity)
    plot_cal_draw_hdr(ages, pdens, list(hdi_99), col = adjustcolor(col, 0.33))

    # Draw 95.4% HDI (33% opacity)
    plot_cal_draw_hdr(ages, pdens, list(hdi_95), col = adjustcolor(col, 0.33))

    # Draw 68.2% HDI (33% opacity)
    plot_cal_draw_hdr(ages, pdens, list(hdi_68), col = adjustcolor(col, 0.33))

    # Draw outline (without bottom border)
    plot_cal_draw_outline(ages, pdens, border = border)

    # Draw legend
    plot_cal_draw_legend(hdi_99, hdi_95, hdi_68, col)
  }
}

#' Draw a filled polygon for a distribution
#'
#' @param ages Numeric vector of ages.
#' @param pdens Numeric vector of probability densities.
#' @param col Fill colour.
#' @param border Border colour.
#'
#' @noRd
#' @keywords internal
plot_cal_draw_polygon <- function(ages, pdens, col, border) {
  n <- length(ages)
  polygon(
    c(ages[1], ages, ages[n]),
    c(0, pdens, 0),
    col = col,
    border = border
  )
}

#' Draw outline for a distribution (without bottom border)
#'
#' @param ages Numeric vector of ages.
#' @param pdens Numeric vector of probability densities.
#' @param border Border colour.
#'
#' @noRd
#' @keywords internal
plot_cal_draw_outline <- function(ages, pdens, border) {
  # Draw left vertical line
  graphics::segments(ages[1], 0, ages[1], pdens[1], col = border)
  # Draw top curve
  graphics::lines(ages, pdens, col = border)
  # Draw right vertical line
  graphics::segments(ages[length(ages)], pdens[length(pdens)], ages[length(ages)], 0, col = border)
}

#' Draw HDR shading for a distribution
#'
#' @param ages Numeric vector of ages.
#' @param pdens Numeric vector of probability densities.
#' @param hdr List of HDR intervals (from `cal_hdr_single()`).
#' @param col Fill colour.
#'
#' @noRd
#' @keywords internal
plot_cal_draw_hdr <- function(ages, pdens, hdr, col) {
  for (interval in hdr) {
    idx <- ages >= interval[1] & ages <= interval[2]
    if (any(idx)) {
      plot_cal_draw_polygon(ages[idx], pdens[idx], col = col, border = NA)
    }
  }
}

#' Draw legend for HDI intervals
#'
#' @param hdi_99 99.7% HDI interval (numeric vector of length 2).
#' @param hdi_95 95.4% HDI interval (numeric vector of length 2).
#' @param hdi_68 68.2% HDI interval (numeric vector of length 2).
#' @param col Fill colour.
#' @param cal_single A single `cal` element (for calibration parameters).
#'
#' @noRd
#' @keywords internal
plot_cal_draw_legend <- function(hdi_99, hdi_95, hdi_68, col) {
  label_99 <- plot_cal_format_hdi(hdi_99, "99.7%")
  label_95 <- plot_cal_format_hdi(hdi_95, "95.4%")
  label_68 <- plot_cal_format_hdi(hdi_68, "68.2%")

  graphics::legend(
    "topright",
    legend = c(label_99, label_95, label_68),
    fill = c(adjustcolor(col, 0.3), adjustcolor(col, 0.6), adjustcolor(col, 0.9)),
    border = NA,
    bty = "n",
    xjust = 1
  )
}

#' Format HDI interval as legend label
#'
#' @param hdi HDI interval (numeric vector of length 2).
#' @param prefix Label prefix (e.g., "98%").
#'
#' @return Character string with formatted interval.
#'
#' @noRd
#' @keywords internal
plot_cal_format_hdi <- function(hdi, prefix) {
  interval <- sprintf("%d--%d cal BP", as.integer(hdi[2]), as.integer(hdi[1]))
  sprintf("%s (%s)", interval, prefix)
}

#' Draw calibration curve as main plot
#'
#' @param cal_single A single `cal` element.
#' @param xlim X-axis limits.
#' @param ylab Y-axis label.
#' @param xlab X-axis label.
#' @param main Plot title.
#' @param rev_x Logical. Is the x-axis reversed?
#' @param col Colour for the uncalibrated date display.
#'
#' @noRd
#' @keywords internal
plot_cal_draw_curve_main <- function(cal_single, xlim, ylab, xlab, main, rev_x, col) {
  curve <- cal_c14_curve(cal_single)
  c14_age <- vctrs::field(cal_single, "c14_age")
  
  # Get curve data
  cal_ages <- as.numeric(curve$cal_age)
  c14_ages <- curve$c14_age
  c14_errors <- curve$c14_error
  
  # Filter to visible range
  x_range <- sort(xlim)
  idx <- cal_ages >= x_range[1] & cal_ages <= x_range[2]
  if (!any(idx)) return()
  
  cal_ages <- cal_ages[idx]
  c14_ages <- c14_ages[idx]
  c14_errors <- c14_errors[idx]
  
  # Get c14 error for the measured date
  c14_error <- vctrs::field(cal_single, "c14_error")
  
  # Calculate ribbon bounds (mean ± error)
  c14_upper <- c14_ages + c14_errors
  c14_lower <- c14_ages - c14_errors
  
  # Determine y-axis range for the curve
  ylim <- range(c(c14_upper, c14_lower, c14_age + 3 * c14_error, c14_age - 3 * c14_error), na.rm = TRUE)
  y_range <- diff(ylim)
  ylim <- ylim + c(-0.05, 0.05) * y_range
  
  # Plot main frame
  plot(
    cal_ages, c14_ages,
    type = "n",
    main = main,
    xlab = xlab,
    ylab = ylab,
    xlim = xlim,
    ylim = ylim,
    bty = "n"
  )
  
  # Draw ribbon (polygon) in red
  polygon(
    c(cal_ages, rev(cal_ages)),
    c(c14_upper, rev(c14_lower)),
    col = adjustcolor("red", 0.3),
    border = NA
  )
  
  # Draw neatlines for ribbon bounds
  lines(cal_ages, c14_upper, col = "red", lwd = 1)
  lines(cal_ages, c14_lower, col = "red", lwd = 1)
  
  # Draw uncalibrated probability distribution as bell curve on left side
  # Create sequence of C14 ages for the bell curve
  c14_range <- c14_age + c(-3, 3) * c14_error
  c14_seq <- seq(c14_range[1], c14_range[2], length.out = 100)
  
  # Calculate normal distribution PDF
  bell_curve <- stats::dnorm(c14_seq, mean = c14_age, sd = c14_error)
  
  # Scale bell curve to fit in left portion of plot (10% of x-range)
  x_span <- diff(x_range)
  bell_scale <- x_span * 0.1 / max(bell_curve)
  bell_x <- x_range[2] - bell_curve * bell_scale  # Position on left side
  
  # Draw bell curve as filled polygon
  # Create closed polygon: curve on left, flat baseline on right
  polygon(
    c(bell_x, x_range[2], x_range[2]),
    c(c14_seq[1], c14_seq, c14_seq[length(c14_seq)]),
    col = adjustcolor("blue", 0.3),
    border = NA
  )
  
  # Draw bell curve outline (left side)
  lines(bell_x, c14_seq, col = "blue", lwd = 1.5)
}

#' Overlay probability distribution on right y-axis
#'
#' @param ages Numeric vector of ages.
#' @param pdens Numeric vector of probability densities.
#' @param xlim X-axis limits.
#' @param col Fill colour.
#' @param border Border colour.
#' @param hdi_99 99.7% HDI interval.
#' @param hdi_95 95.4% HDI interval.
#' @param hdi_68 68.2% HDI interval.
#'
#' @noRd
#' @keywords internal
plot_cal_draw_dist_overlay <- function(ages, pdens, xlim, col, border, hdi_99, hdi_95, hdi_68) {
  # Set up overlay - scale distribution to 1/3 height
  ylim <- c(0, max(pdens, na.rm = TRUE) * 3)
  
  par(new = TRUE)
  
  plot(
    ages, pdens,
    type = "n",
    axes = FALSE,
    xlab = "",
    ylab = "",
    xlim = xlim,
    ylim = ylim
  )
  
  # Draw full distribution (transparent)
  plot_cal_draw_polygon(ages, pdens, col = adjustcolor(col, 0), border = NA)
  
  # Draw HDI shading
  plot_cal_draw_hdr(ages, pdens, list(hdi_99), col = adjustcolor(col, 0.3))
  plot_cal_draw_hdr(ages, pdens, list(hdi_95), col = adjustcolor(col, 0.3))
  plot_cal_draw_hdr(ages, pdens, list(hdi_68), col = adjustcolor(col, 0.3))
  
  # Draw outline (without bottom border)
  plot_cal_draw_outline(ages, pdens, border = border)
  
  # Add right y-axis
  axis(4)
  mtext("Probability density", side = 4, line = 2.0, cex = par("cex.lab"))
  
  # Draw legend
  plot_cal_draw_legend(hdi_99, hdi_95, hdi_68, col)
}
