#' Radiocarbon laboratories
#'
#' Active and defunct radiocarbon laboratories with their standard lab codes.
#' Based on the list maintained by the journal *Radiocarbon* (updated 9 April
#' 2021), with a few additions.
#'
#' @format A data frame with 285 rows and 4 variables:
#' \describe{
#'   \item{lab_code}{Character. Laboratory code, used to identify published
#'   dates as from this lab.}
#'   \item{active}{Logical. `FALSE` if the laboratory is "closed, no longer measuring
#'   14C, or operating under a different code".}
#'   \item{lab}{Character. Name of the laboratory.}
#'   \item{country}{Character.}
#' }
#'
#' @details
#' `lab_code` is *almost* unique, but there are exceptions, and sometimes case
#' is all that distinguishes two labs:
#'
#' * `"Gd"` (Gliwice) and `"GD"` (Gdansk, defunct);
#' * `"KI"` (Kiel, now `"KiA"`) and `"Ki"` (Kiev, now `"Ki(KIEV)"`);
#' * `"Lu"` (Lund, now `"LuS"`, formerly `"LuA"`) and `"LU"` (St. Petersburg);
#' * `"P"` (Max Planck) and `"P"` (Pennsylvania, defunct);
#' * `"Pi"` (Pisa, defunct) and `"PI"` (Permafrost Institute, defunct);
#' * `"TKA"` (Univ. of Tokyo Museum) and `"TKa"` (Univ. of Tokyo AMS), also `"TK"` (Univ. of Tokyo).
#'
#' @source \url{http://radiocarbon.webhost.uits.arizona.edu/node/11}
"c14_labs"
