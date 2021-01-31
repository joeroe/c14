# cal_metadata.R
# Functions for working with calibration metadata

#' Extract metadata from a calibrated date
#'
#' @param x  A `cal` object. See [cal()].
#'
#' @return
#' A named list of metadata attributes.
#'
#' @family cal class methods
#'
#' @export
cal_metadata <- function(x) {
  attrs <- attributes(x)
  attrs$names <- NULL
  attrs$row.names <- NULL
  attrs$class <- NULL

  return(attrs)
}


# Utility functions (internal) -------------------------------------------

cal_metadata_thesaurus <- function(what = NA) {
  thesaurus <- tibble::tribble(
    ~cal,                      ~CalDates,
    "era",                     NA,
    "lab_id",                  "DateID",
    "cra",                     "CRA",
    "error",                   "Error",
    NA,                        "Details",
    "curve",                   "CalCurve",
    "reservoir_offset",        "ResOffsets",
    "reservoir_offset_error",  "ResErrors",
    "calibration_range",       "StartBP",
    "calibration_range",       "EndBP",
    "normalised",              "Normalised",
    "F14C",                    "F14C",
    "p_cutoff",                "CalEPS"
  )

  if(!is.na(what)) {
    return(thesaurus[[what]])
  }
  else {
    return(thesaurus)
  }
}

cal_recode_metadata <- function(x,
                                from = c("CalDates", "cal"),
                                to = c("cal", "CalDates")) {
  from <- match.arg(from)
  to <- match.arg(to)

  thes <- stats::setNames(cal_metadata_thesaurus(from), cal_metadata_thesaurus(to))
  thes <- thes[!is.na(names(thes))]

  x <- x[thes]
  names(x) <- names(thes)

  # Vectors
  if(to == "CalDates") {
    x$StartBP <- x$StartBP[1]
    x$EndBP <- x$EndBP[2]
  }

  x[sapply(x, is.null)] <- NA

  return(x)
}

# rcarbon functions like spd() expect the StartBP and EndBP metadata to be set,
# but if the dates came from another source, they might be missing. This function
# reconstructs them from the probability distribution.
# x should be a cal object.
cal_repair_calibration_range <- function(x) {
  if(is.null(attr(x, "calibration_range")) ||
     any(is.na(attr(x, "calibration_range")))) {
    attr(x, "calibration_range") <- c(max(x$year), min(x$year))
  }
  return(x)
}