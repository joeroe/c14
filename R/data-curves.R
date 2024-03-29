# Documentation for calibration curve datasets (generated by data-raw/curves.R)

#' Radiocarbon calibration curves
#'
#' @description
#' Radiocarbon calibration requires a calibration curve: an estimate of the true
#' calendar age associated with a radiocarbon measurement. The following curves
#' are included with the c14 package:
#'
#' \describe{
#'   \item{IntCal20}{
#'     IntCal Northern Hemisphere curve, 0–55,000 cal BP \insertCite{Reimer2020}{c14}.
#'   }
#'   \item{SHCal20}{
#'     IntCal Southern Hemisphere curve, 0–55,000 cal BP \insertCite{Hogg2020}{c14}.
#'   }
#'   \item{Marine20}{
#'     IntCal marine curve, 0–55,000 cal BP \insertCite{Heaton2020}{c14}.
#'   }
#'   \item{IntCal13, IntCal09, IntCal04, IntCal98}{
#'     Previous IntCal Northern Hemisphere curves
#'     \insertCite{Reimer2013,Reimer2009,Reimer2004,Stuiver1998}{c14}.
#'     Superseded by `IntCal20`.
#'   }
#'   \item{SHCal13, SHCal04}{
#'     Previous IntCal Southern Hemisphere curves
#'     \insertCite{Hogg2013,McCormac2004}{c14}.
#'     Superseded by `SHCal20`.
#'   }
#'   \item{Marine13, Marine09, Marine04, Marine98}{
#'     Previous IntCal marine curves
#'     \insertCite{Reimer2013,Reimer2009,Hughen2004,Stuiver1998}{c14}.
#'     Superseded by `Marine20`.
#'   }
#' }
#'
#' Generally, it is recommended to use the latest curve from the IntCal series:
#' `IntCal20` for samples from the northern hemisphere; `SHCal20` for samples
#' from the southern hemisphere; or `Marine20` for samples that obtained their
#' 14C in a marine environment.
#'
#' @format
#' A [c14_curve] object with the following fields.
#'
#' For standard curves:
#' \describe{
#'   \item{cal_age}{Calendar ages with associated era ([era::yr] class).}
#'   \item{c14_age}{Uncalibrated radiocarbon ages.}
#'   \item{c14_error}{Errors (sigma values) associated with `c14_age`.}
#'   \item{d14c}{Delta-14C values.}
#'   \item{d14c_error}{Errors (sigma values) associated with `d14c`.}
#' }
#'
#' For post-bomb curves:
#' \describe{
#'   \item{cal_age}{Calendar ages with their associated era ([era::yr] class).}
#'   \item{f14c}{Fraction modern (F14C or pMC) values.}
#'   \item{f14c_error}{Errors (sigma values) associated with `f14c`.}
#' }
#'
#' @name c14_curves
#'
#' @family calibration curves
#'
#' @source
#' <http://intcal.org/curves/> and <http://calib.org/CALIBomb/>
#'
#' @references
#' \insertAllCited{}
NULL

#' @rdname c14_curves
"IntCal20"

#' @rdname c14_curves
"SHCal20"

#' @rdname c14_curves
"Marine20"

#' @rdname c14_curves
"IntCal13"

#' @rdname c14_curves
"SHCal13"

#' @rdname c14_curves
"Marine13"

#' @rdname c14_curves
"IntCal09"

#' @rdname c14_curves
"Marine09"

#' @rdname c14_curves
"IntCal04"

#' @rdname c14_curves
"SHCal04"

#' @rdname c14_curves
"Marine04"

#' @rdname c14_curves
"IntCal98"

#' @rdname c14_curves
"Marine98"

#' #' @rdname c14_curves
#' "NHZ1"
#'
#' #' @rdname c14_curves
#' "NHZ2"
#'
#' #' @rdname c14_curves
#' "NHZ3"
#'
#' #' @rdname c14_curves
#' "SHZ1_2"
#'
#' #' @rdname c14_curves
#' "SHZ3"
#'
#' #' @rdname c14_curves
#' "Brazil"
#'
#' #' @rdname c14_curves
#' "KureAtoll"
