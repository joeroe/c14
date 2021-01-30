#' Radiocarbon dates from Neolithic Southwest Asia
#'
#' A dataset of 1049 radiocarbon dates from Epipalaeolithic and Neolithic sites
#' in Southwest Asia, collected in ex oriente's 'Platform for Neolithic
#' Radiocarbon Dates' (PPND).
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