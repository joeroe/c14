# cal_metadata.R
# Functions for working with calibration metadata

#' Repair calibration range
#'
#' rcarbon functions like spd() expect the StartBP and EndBP metadata to be set,
#' but if the dates came from another source, they might be missing. This function
#' reconstructs them from the probability distribution.
#' x should be a cal object.
#'
#' @noRd
#' @keywords Internal
cal_repair_calibration_range <- function(x) {
  if(is.null(attr(x, "calibration_range")) ||
     any(is.na(attr(x, "calibration_range")))) {
    attr(x, "calibration_range") <- c(max(x$year), min(x$year))
  }
  return(x)
}