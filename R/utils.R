#' Name-preserving interpolation
#'
#' Wrapper for stats::approx() that takes and returns a data frame, preserving
#' its column names
#'
#' @noRd
#' @keywords internal
approx_df <- function(x, xout, ...) {
  y <- stats::approx(x, xout = xout, ...)
  y <- data.frame(y)
  colnames(y) <- colnames(x)
  y
}