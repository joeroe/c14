#' Radiocarbon laboratories
#'
#' @description
#' Table of active and defunct radiocarbon laboratories with their standard lab
#' codes.
#'
#' Primarily based on the list maintained by the journal *Radiocarbon*
#' (updated 20 July 2021), with a few additions.
#'
#' @format A data frame with 297 rows and 4 variables:
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
#' @references
#' List of known radiocarbon laboratories. *Radiocarbon*. Last updated 20 July
#'   2021. <http://radiocarbon.webhost.uits.arizona.edu/node/11>
#'
#' Wang, C., Lu, H., Zhang, J., Gu, Z. and He, K., 2014. Prehistoric demographic
#'   fluctuations in China inferred from radiocarbon data and their linkage with
#'   climate change over the past 50,000 years. *Quaternary Science Reviews*,
#'   98, pp.45-59. doi:10.1016/j.quascirev.2014.05.015
"c14_labs"
