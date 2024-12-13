% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/cal_summary.R
\name{cal_age_range}
\alias{cal_age_range}
\alias{cal_age_min}
\alias{cal_age_max}
\title{Range of a calendar probability distribution}
\usage{
cal_age_range(x, min_pdens = 0)

cal_age_min(x, min_pdens = 0)

cal_age_max(x, min_pdens = 0)
}
\arguments{
\item{x}{A \link{cal} vector of calendar probability distributions.}

\item{min_pdens}{Ignores ages with values less than the given value when
calculating the minimum or maximum. Default: 0.}
}
\value{
A data frame with two columns giving the minimum (\code{min}) and maximum
(\code{max}) ages.
}
\description{
Functions for calculating the minimum and maximum ages of a \link{cal} vector.
This function does not take into account the probability distribution.
}
\examples{
x <- c14_calibrate(c(10000, 9000, 8000), rep(10, 3))

cal_age_min(x)
cal_age_max(x)
cal_age_range(x)
}
\seealso{
Other functions for summarising calibrated radiocarbon dates: 
\code{\link{cal_point}()}
}
\concept{functions for summarising calibrated radiocarbon dates}
