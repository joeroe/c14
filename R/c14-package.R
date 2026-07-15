#' @keywords internal
"_PACKAGE"

# The following block is used by usethis to automatically manage
# roxygen namespace tags. Modify with care!
## usethis namespace: start
## usethis namespace: end
NULL

# Suppress R CMD check NOTEs for lazy-loaded datasets used as default arguments
# (IntCal20 in c14_calibrate, thesauri in c14_control_lab_id / c14_control_material)
utils::globalVariables(c("IntCal20", "c14_lab_code_thesaurus", "c14_material_thesaurus"))

#' Internal Rdpack methods
#'
#' @keywords internal
#' @importFrom Rdpack reprompt
#' @name c14-Rdpack
NULL

#' Internal vctrs methods
#'
#' @import vctrs
#' @keywords internal
#' @name c14-vctrs
NULL

#' Internal zeallot methods
#'
#' @import zeallot
#' @keywords internal
#' @name c14-zeallot
NULL

#' Ignore unused imports
#' @noRd
#' @keywords internal
ignore_unused_imports <- function() {
  methods::setOldClass # used in cal.R
  mathjaxr::preview_rd # used in RdMacros
}
