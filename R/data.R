#' Radiocarbon dates from Neolithic Southwest Asia
#'
#' A dataset of 1049 radiocarbon dates from Epipalaeolithic and Neolithic sites
#' in Southwest Asia, compiled by Marion Benz in the [Platform for Neolithic
#' Radiocarbon Dates](https://www.exoriente.org/associated_projects/ppnd.php)
#' (PPND).
#'
#' @format A data frame with 1049 rows and 10 variables:
#' \describe{
#'   \item{lab_id}{Character. Laboratory code and ID of the dated sample.}
#'   \item{site}{Character. Name of the site from which the sample was retrieved.}
#'   \item{latitude, longitude}{Double. Coordinates of the site.}
#'   \item{context}{Character. Description of the context from which the sample was retrieved.}
#'   \item{cra}{Integer. Conventional radiocarbon age (CRA) of the sample Before Present.}
#'   \item{error}{Integer. Error associated with the radiocarbon measurement.}
#'   \item{d13c}{Character. d13C measurement and error (separated by a plus/minus symbol) associated with the sample.}
#'   \item{material}{Character. Description of the sample material.}
#'   \item{references}{Character. Bibliographic reference associated with the sample. See bibliography at <https://www.exoriente.org/associated_projects/ppnd_references.php>.}
#' }
#' @source \url{https://www.exoriente.org/associated_projects/ppnd.php} (Retrieved 2018-04-02)
"ppnd"

# shub1_radiocarbon -------------------------------------------------------
#' Radiocarbon dates from Shubayqa 1
#'
#' Radiocarbon dates from Shubayqa 1, an Epipalaeolithic site in eastern Jordan,
#' from \insertCite{Richter2017;textual}{c14}.
#'
#' @format A data frame with 27 rows and 8 variables:
#' \describe{
#'   \item{lab_id}{character; standardised lab code uniquely identifying the dated sample.}
#'   \item{context}{integer; schematic context number the sample was found in (see details).}
#'   \item{phase}{character; phase the sample was assigned to.}
#'   \item{sample}{character; description of the sample context, including its real context number.}
#'   \item{material}{character; description of the sample material.}
#'   \item{c14_age}{integer; conventional radiocarbon age of the sample in years cal BP.}
#'   \item{c14_error}{integer; standard error associated with the radiocarbon measurement in ± years cal BP.}
#'   \item{outlier}{logical; whether the sample is considered an outlier.}
#' }
#'
#' @details
#'
#' `context` refers to the schematic stratigraphy included in [stratigraphr::shub1];
#' the real context number is described in `sample`.
#'
#' @source \insertCite{Richter2017;textual}{c14}
#'
#' @references
#' \insertAllCited{}
"shub1_c14"


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
#' Originally compiled by Clemens Schmid, David Matzig, Dirk Seidensticker,
#' Joe Roe, and Thomas Huet, for the package
#' [c14bazAAR](https://docs.ropensci.org/c14bazAAR/).
"c14_material_thesaurus"
