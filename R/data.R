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

#' Radiocarbon laboratory code thesaurus
#'
#' @description
#' A thesaurus of canonical (matching those given in [c14_labs]) radiocarbon
#' laboratory codes and variants of these codes observed in various published
#' datasets.
#'
#' @format A data frame with 688 rows and 2 variables:
#' \describe{
#'   \item{canon}{Character. The preferred code for the laboratory.}
#'   \item{variant}{Character. Variant codes.}
#' }
#'
#' @details
#' The thesaurus aims to be precise and conservative. That is, canonical forms
#' are only given for variants when they can be unambiguously interpreted as
#' that of a known laboratory listed in [c14_labs]. It is case sensitive,
#' because there are laboratory codes that can only be distinguished by
#' case (see [c14_labs] for examples).
#'
#' Variants that cannot (or have not yet) been unambiguously matched to a
#' known, standard lab code have a `canon` value of `NA`.
"c14_lab_code_thesaurus"

#' Radiocarbon sample material thesaurus
#'
#' @description
#' A thesaurus of standardised radiocarbon sample material descriptions and
#' variants of these materials observed in various published datasets.
#'
#' @format A data frame with 8854 rows and 2 variables:
#' \describe{
#'   \item{canon}{Character. The preferred description of the sample material.}
#'   \item{variant}{Character. Variant descriptions.}
#' }
#'
#' @author
#' Originally compiled by Clemens Schmid, David Matzing, Dirk Seidensticker,
#' Joe Roe, and Thomas Huet, for the package
#' [c14bazAAR](https://docs.ropensci.org/c14bazAAR/).
"c14_material_thesaurus"
