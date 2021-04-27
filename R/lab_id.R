# lab_id.R
# Functions for laboratory IDs

#' Parse radiocarbon laboratory identifiers
#'
#' Splits a vector of radiocarbon lab IDs (e.g. `"OxA-1234"`)
#' into its constituent parts: the lab code (`"OxA"`) and quasi-numeric unique
#' identifier (`"1324"`). If `x` contains values that don't fit the standard
#' format (`"OxA-1234"` or `"OxA 4567"`), by default the function will attempt
#' to fix these with [c14_fix_lab_id()] before parsing.
#'
#' @param x Vector of lab IDs, e.g. `"OxA-1234"`.
#' @param fix If `TRUE` (the default), attempts to fix malformed lab IDs before
#'   parsing.
#'
#' @return
#' A data frame with two character columns: `lab_code` and `lab_number`. If `x`
#' is of length one, this is simplified to a named character vector of length 2.
#'
#' @export
#'
#' @examples
#' c14_parse_lab_id(c("OxA-1234", "Ly 456", "RT 1234-5678"))
#'
#' # By default, tries to fix malformed values of x before parsing
#' # Use fix = FALSE for strict parsing
#' c14_parse_lab_id(c("OxA 1234", "OxA_5678", "Gif/LSN-123"))
#' c14_parse_lab_id(c("OxA 1234", "OxA_5678", "Gif/LSN-123"), fix = FALSE)
#'
#' # Single values of x are simplified to a character vector
#' c14_parse_lab_id("OxA 1234")
c14_parse_lab_id <- function(x, fix = TRUE) {
  if (isTRUE(fix)) {
    x <- c14_fix_lab_id(x)
  }

  x <- stringr::str_match(x, c14_lab_id_std())
  x <- x[, 2:3]

  nm <- c("lab_code", "lab_num")
  if (length(x) > 2) {
    x <- as.data.frame(x, stringsAsFactors = FALSE)
    colnames(x) <- nm
  }
  else {
    names(x) <- nm
  }

  return(x)
}

#' Detect and fix malformed radiocarbon laboratory identifiers
#'
#' @description
#' `c14_is_lab_id()` tests whether a lab ID matches the conventional format,
#' e.g. `"OxA-1234"` or `"OxA 5678"`.
#'
#' `c14_fix_lab_id()` attempts to coerce malformed lab IDs into this format, by
#' fixing common issues and variant forms.
#'
#' @param x Vector of potentially malformed lab IDs.
#'
#' @details
#' The regular expression used to test for the conventional format is
#' `"^([\w\(\)/]{1,8})[ -](.*)$"`. This accepts unusual but parsable
#' variants such as `"Ki(KIEV)-1234"` or `"Gif/LSN-5678"`
#'
#' @return
#' `c14_is_lab_id()` returns a logical vector the same length as `x`.
#'
#' `c14_fix_lab_id()` returns `x` with values replaced to match the conventional
#' format where possible.
#'
#' @export
#'
#' @examples
#' c14_is_lab_id(c("OxA-1234", "OxA_4567"))
#'
#' c14_fix_lab_id(c("OxA-1234", "OxA_4567"))
c14_fix_lab_id <- function(x) {
  y <- x

  # Variant delimiters
  broken <- !c14_is_lab_id(y) & !is.na(y)
  y[broken] <- stringr::str_replace(y[broken], "[\u2010\u2013_#\\.\\+]", "-")

  # Lab code but no number
  broken <- !c14_is_lab_id(y) & !is.na(y)
  bare_lab_code <- stringr::str_detect(y, paste0(c14_lab_code_std(), "$"))
  y[broken & bare_lab_code] <- stringr::str_replace(y[broken & bare_lab_code],
                                                    "$", "-")

  # Only replace if we've managed to make it valid
  x[!c14_is_lab_id(x) & c14_is_lab_id(y)] <- y[!c14_is_lab_id(x) & c14_is_lab_id(y)]

  return(x)
}

#' @rdname c14_fix_lab_id
#' @export
c14_is_lab_id <- function(x) {
  stringr::str_detect(x, c14_lab_id_std()) & !is.na(x)
}

#' Standard radiocarbon lab ID regex
#'
#' @keywords internal
#' @noRd
c14_lab_id_std <- function() paste0(c14_lab_code_std(), "[ -](.*)$")

#' Standard radiocarbon lab ID regex
#'
#' @keywords internal
#' @noRd
c14_lab_code_std <- function() "^([\\w\\(\\)/]{1,8})"
