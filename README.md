
<!-- README.md is generated from README.Rmd. Please edit that file -->

# c14

<!-- badges: start -->

[![Project Status: WIP – Initial development is in progress, but there
has not yet been a stable, usable release suitable for the
public.](https://www.repostatus.org/badges/latest/wip.svg)](https://www.repostatus.org/#wip)
[![CRAN
status](https://www.r-pkg.org/badges/version/c14)](https://CRAN.R-project.org/package=c14)
[![R-CMD-check](https://github.com/joeroe/c14/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/joeroe/c14/actions/workflows/R-CMD-check.yaml)
[![Test
coverage](https://codecov.io/gh/joeroe/c14/graph/badge.svg)](https://app.codecov.io/gh/joeroe/c14)
<!-- badges: end -->

**c14** provides basic classes and functions for radiocarbon data in R.
It makes it easier to combine methods from several existing packages
(e.g. rcarbon, Bchron, oxcAAR, c14bazAAR, ArchaeoPhases, stratigraphr)
together and work with them in a tidy data workflow.

It was forked from
[stratigraphr](https://github.com/joeroe/stratigraphr) v0.3.0.

## Installation

You can install the latest release of c14 [from
CRAN](https://cran.r-project.org/package=c14) with:

``` r
install.packages("c14")
```

Or the development version from GitHub using the
[remotes](https://remotes.r-lib.org/) package:

``` r
# install.packages("remotes")
remotes::install_github("joeroe/c14")
```

## Usage

The main aim of c14 is to make it easier to work with radiocarbon data
within a tidy workflow. For example, we can combine `dplyr::filter()`
with `c14_calibrate()` to only calibrate dates from a specific site:

``` r
library("c14")
library("dplyr", warn.conflicts = FALSE)

ppnd |>
  filter(site == "Ganj Dareh") |>
  select(lab_id, cra, error) |>
  mutate(cal = c14_calibrate(cra, error))
#> # A tibble: 9 × 4
#>   lab_id     cra error                cal
#>   <chr>    <int> <int>              <cal>
#> 1 GaK 807  10400   150 11751–12709 cal BP
#> 2 OxA 2099  8840   110  9557–10193 cal BP
#> 3 OxA 2100  9010   110  9748–10486 cal BP
#> 4 OxA 2101  8850   100  9560–10197 cal BP
#> 5 OxA 2102  8690   110  9490–10144 cal BP
#> 6 SI 922    8570   210  9034–10181 cal BP
#> 7 SI 923    8625   195  9142–10202 cal BP
#> 8 SI 924    8640    90  9470–10106 cal BP
#> 9 SI 925    8385    75   9141–9534 cal BP
```

The resulting `cal`-class vector can be assigned to a new column,
allowing us to keep working with the data in the context of the original
data frame or tibble.
