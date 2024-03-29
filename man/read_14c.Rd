% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/read.R
\name{read_14c}
\alias{read_14c}
\title{Read calibration curve files}
\usage{
read_14c(
  file,
  format = c("14c", "f14c"),
  delim = NA,
  cal_era = "cal BP",
  col_names = switch(format, `14c` = c("cal_age", "c14_age", "c14_error", "d14c",
    "d14c_error"), f14c = c("cal_age", "f14c", "f14c_error"))
)
}
\arguments{
\item{file}{Path, connection, or URL of a calibration curve file, typically
with the extension .14c or .f14c.}

\item{format}{\code{"14c"} or \code{"f14c"}. If not supplied, will be inferred from the
the extension of \code{file}.}

\item{delim}{Character used to separate fields. If \code{NA} (the default), will
be inferred from \code{format}: \code{","} for .14c files or \code{""} (any whitespace) for
.f14c files.}

\item{cal_era}{Character label or \link[era:era]{era::era} object describing the time scale
used in the calibration curve's \code{cal_age} field. Default: \code{"cal BP"}.}

\item{col_names}{Vector of column names specifying the order of fields in the
file. If not supplied, they are assumed to be in the usual order. Must
contain all of the following elements, depending on the value of \code{format}:
\describe{
\item{\code{format = "14c"}:}{\code{"cal_age"}, \code{"c14_age"}, \code{"c14_error"}, and optionally \code{"d14c"} and \code{"d14c_error"}}
\item{\code{format = "f14c"}:}{\code{"cal_age"}, \code{"f14c"}, and \code{"f14c_error"}}
}
See \code{\link[=c14_curve]{c14_curve()}} for more details on these fields.}
}
\value{
A \link{c14_curve} object.
}
\description{
Reads the .14c and .f14c formats used for radiocarbon calibration curves and
returns a \link{c14_curve} object.

For most files, only the first argument needs to be supplied. Further
arguments can be used if the file does not follow the conventional format.
}
\examples{
\dontshow{if (curl::has_internet()) (if (getRversion() >= "3.4") withAutoprint else force)(\{ # examplesIf}
read_14c("https://intcal.org/curves/intcal20.14c")
\dontshow{\}) # examplesIf}
}
\seealso{
Other calibration curve functions: 
\code{\link{c14_curve}()}
}
\concept{calibration curve functions}
