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
