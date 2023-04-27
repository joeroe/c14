# material.R
# Functions for cleaning radiocarbon sample materials

#' Control radiocarbon sample materials
#'
#' @description
#' Standardises a vector of radiocarbon sample materials use a thesaurus.
#'
#' @param x Vector of radiocarbon sample materials.
#' @param thesaurus Thesaurus to use for sample materials. Defaults to the
#'  [c14_material_thesaurus] thesaraus included in the package.
#' @param quiet Passed to [controller::control()]. Set to `TRUE` to suppress
#'  messages about replaced values. Default: `FALSE`.
#' @param warn_unmatched Passed to [controller::control()]. Set to `FALSE` to
#'  suppress warnings about unmatched values. Default: `TRUE`.
#'
#' @return
#' Vector the same length as `x` with controlled sample materials.
#'
#' @export
c14_control_material <- function(x,
                               thesaurus = c14_material_thesaurus,
                               quiet = FALSE,
                               warn_unmatched = TRUE) {
  controller::control(
    x,
    thesaurus,
    case_insensitive = FALSE,
    fuzzy_boundary = FALSE,
    fuzzy_encoding = FALSE,
    quiet = quiet,
    warn_unmatched = warn_unmatched,
    coalesce = TRUE
  )
}
