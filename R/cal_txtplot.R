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