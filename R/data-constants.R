#' Radiocarbon decay constants
#'
#' @description
#' \loadmathjax
#' Decay constants used in the calculation of radiocarbon ages (see [c14_age()]).
#'
#' @format A numeric of length 1:
#' \describe{
#'   \item{c14_decay_libby}{The Libby decay constant, \mjeqn{\lambda_L=8033^{-1}}{1/8033}. The standard for calculating the conventional radiocarbon age (CRA).}
#'   \item{c14_decay_cambridge}{The Cambridge decay constant, \mjeqn{\lambda_C=8267^{-1}}{1/8267}.}
#' }
#'
#' @name c14_decay
#'
#' @family radiocarbon-related constants
#'
#' @source \insertRef{Stenstrom2011}{c14}
NULL

#' @rdname c14_decay
"c14_decay_libby"

#' @rdname c14_decay
"c14_decay_cambridge"