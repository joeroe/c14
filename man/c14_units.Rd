% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/c14_units.R
\name{c14_units}
\alias{c14_units}
\alias{c14_age}
\alias{c14_f14c}
\title{Radiocarbon unit calculations}
\usage{
c14_age(x, decay = c14::c14_decay_libby)

c14_f14c(x, decay = c14::c14_decay_libby)
}
\arguments{
\item{x}{For \code{c14_age()}, a vector of fraction modern
(\mjeqn{F^{14}C}{F14C}) measurements. For \code{c14_f14c()}, a vector of
conventional radiocarbon ages.}

\item{decay}{Decay constant. The default is the Libby
constant (\code{c14_decay_libby}), which is the standard for calculating
conventional radiocarbon ages. Use \code{c14_decay_cambridge} for the Cambridge
constant, or a single numeric for other values.}
}
\value{
Vector the same length as \code{x}.
}
\description{
\loadmathjax
Functions for calculating basic units used in radiocarbon measurements.

\code{c14_age()} calculates the conventional radiocarbon age (CRA) from a fraction
modern measurement.

\code{c14_f14c()} reverse-calculates the fractionation-corrected fraction modern
value (\mjeqn{F^{14}C}{F14C} or \mjeqn{pM}{pM}) of a radiocarbon age.
}
\details{
\code{c14_age()} calculates the conventional radiocarbon age, \mjeqn{t}{t},
as defined by \insertCite{Stuiver1977;textual}{c14}:

\mjdeqn{t = -\frac{1}{\lambda}\ln{F^{14}C}}{t = -1/l * ln(F^14C)}

\code{c14_f14c()} implements the inverse of this function:

\mjdeqn{F^{14}C = e^{-\lambda t}}{F14C = e^(-lt)}

The decay constant conventionally used for calculating radiocarbon ages is
the Libby decay constant, \mjeqn{\lambda_L=8033^{-1}}{lL = 1/8033}.
An alternative is the Cambridge decay constant,
\mjeqn{\lambda_C=8267^{-1}}{lC = 1/8267} \insertCite{Stenstrom2011}{c14}.

Reported radiocarbon ages are usually rounded based on the magnitude of the
error \insertCite{Stuiver1977}{c14}. For this reason, reverse-calculating
fraction modern from a radiocarbon age is unlikely to return the precise
original measurement of the sample.

Where available, fraction modern is the recommended measurement for
calibration \insertCite{Bronk_Ramsey2008}{c14}.
}
\examples{
c14_age(0.9239)
c14_f14c(636)
}
\references{
\insertAllCited{}
}
\concept{functions for working with radiocarbon measurements}
