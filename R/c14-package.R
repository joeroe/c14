#' @keywords internal
"_PACKAGE"

# The following block is used by usethis to automatically manage
# roxygen namespace tags. Modify with care!
## usethis namespace: start
## usethis namespace: end
NULL

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
  curl::has_internet # used in read_14c() documentation
  mathjaxr::preview_rd # used in RdMacros
}
