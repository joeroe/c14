# lab_id.R
# Functions for laboratory IDs

#' Control radiocarbon laboratory identifiers
#'
#' @description
#' Standardises a vector of radiocarbon laboratory identifiers to a common
#' format. Specifically, this `c14_control_lab_id()`:
#'
#' 1. Fixes malformed identifiers with [c14_fix_lab_id()]
#' 2. Parses the lab code and lab number components ([c14_parse_lab_id()])
#' 3. Standardises lab codes against a thesaurus, by default [c14_lab_code_thesaurus]
#' 5. Reunites lab codes and numbers with a uniform seperator (default: `"-"`)
#'
#' @param x Vector of radiocarbon laboratory identifiers.
#' @param thesaurus Thesaurus to use for lab codes. Defaults to the [c14_lab_code_thesaurus]
#'  thesaraus included in the package.
#' @param sep Character to use to seperate lab codes and numbers in the result.
#'  Default: `"-"`.
#' @param quiet Passed to [controller::control()]. Set to `TRUE` to suppress
#'  messages about replaced values. Default: `FALSE`.
#' @param warn_unmatched Passed to [controller::control()]. Set to `FALSE` to
#'  suppress warnings about unmatched values. Default: `TRUE`.
#'
#' @return
#' Vector the same length as `x` with controlled laboratory identifiers.
#'
#' @examples
#' c14_control_lab_id(c("OxA-1234", "OxA 1234", "Oxa 1234"))
#'
#' @export
c14_control_lab_id <- function(x,
                               thesaurus = c14_lab_code_thesaurus,
                               sep = "-",
                               quiet = FALSE,
                               warn_unmatched = TRUE) {
  x <- c14_parse_lab_id(x, fix = TRUE)
  x[["lab_code"]] <- controller::control(x[["lab_code"]],
                                         thesaurus,
                                         case_insensitive = FALSE,
                                         fuzzy_boundary = FALSE,
                                         fuzzy_encoding = FALSE,
                                         quiet = quiet,
                                         warn_unmatched = warn_unmatched,
                                         coalesce = TRUE)
  paste(x[["lab_code"]], x[["lab_number"]], sep = sep)
}

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

  nm <- c("lab_code", "lab_number")
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
#' `"^([[:alpha:]\(\)/]{1,8})[ -\u2010\u2013_#\.\+](.*)$"`. This accepts unusual
#' but parsable variants such as `"Ki(KIEV)-1234"` or `"Gif/LSN_5678"`
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
c14_fix_lab_id <- function(x) {
  y <- x

  # Lab code but no number
  broken <- !c14_is_lab_id(y) & !is.na(y)
  bare_lab_code <- stringr::str_detect(y, paste0(c14_lab_code_std(), "$"))
  y[broken & bare_lab_code] <- stringr::str_replace(y[broken & bare_lab_code],
                                                    "$", "-")

  # TODO: spaces in lab code, e.g. c14_parse_lab_id("Ki (KIEV)-14546")
  # TODO: digits in lab code?

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
c14_lab_id_std <- function() paste0(c14_lab_code_std(),
                                    c14_lab_delim_std(),
                                    "(.*)$")

#' Standard radiocarbon lab ID regex
#'
#' @keywords internal
#' @noRd
c14_lab_code_std <- function() "^([[:alpha:]\\(\\)/]{1,8})"

c14_lab_delim_std <- function() "[ -\u2010\u2013_#\\.\\+]"
