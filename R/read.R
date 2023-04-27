# read.R
# Read and write functions for radiocarbon-related file formats

#' Read calibration curve files
#'
#' @description
#' Reads the .14c and .f14c formats used for radiocarbon calibration curves and
#' returns a [c14_curve] object.
#'
#' For most files, only the first argument needs to be supplied. Further
#' arguments can be used if the file does not follow the conventional format.
#'
#' @param file Path, connection, or URL of a calibration curve file, typically
#'  with the extension .14c or .f14c.
#' @param format `"14c"` or `"f14c"`. If not supplied, will be inferred from the
#'  the extension of `file`.
#' @param delim Character used to separate fields. If `NA` (the default), will
#'  be inferred from `format`: `","` for .14c files or `""` (any whitespace) for
#'  .f14c files.
#' @param cal_era Character label or [era::era] object describing the time scale
#'  used in the calibration curve's `cal_age` field. Default: `"cal BP"`.
#' @param col_names Vector of column names specifying the order of fields in the
#'  file. If not supplied, they are assumed to be in the usual order. Must
#'  contain all of the following elements, depending on the value of `format`:
#'  \describe{
#'    \item{`format = "14c"`:}{`"cal_age"`, `"c14_age"`, `"c14_error"`, and optionally `"d14c"` and `"d14c_error"`}
#'    \item{`format = "f14c"`:}{`"cal_age"`, `"f14c"`, and `"f14c_error"`}
#'  }
#'  See [c14_curve()] for more details on these fields.
#'
#' @return
#' A [c14_curve] object.
#'
#' @family calibration curve functions
#'
#' @export
#'
#' @examplesIf curl::has_internet()
#' read_14c("https://intcal.org/curves/intcal20.14c")
read_14c <- function(file,
                     format = c("14c", "f14c"),
                     delim = NA,
                     cal_era = "cal BP",
                     col_names = switch(
                       format,
                       `14c` = c("cal_age", "c14_age", "c14_error", "d14c", "d14c_error"),
                       f14c = c("cal_age", "f14c", "f14c_error"
                       )
                     )) {
  if (missing(format)) {
    format <- tools::file_ext(file)
  }
  checkmate::assert_choice(format, c("14c", "f14c"))

  if (is.na(delim)) {
    delim <- c("14c" = ",", "f14c" = "")[format]
  }

  data <- utils::read.delim(file, header = FALSE, sep = delim, comment.char = "#")
  colnames(data) <- col_names
  data$cal_age <- era::yr(data$cal_age, cal_era)

  do.call(switch(format, `14c` = c14_curve, f14c = c14_fcurve), data)
}