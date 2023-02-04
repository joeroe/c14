
<!-- README.md is generated from README.Rmd. Please edit that file -->

# c14

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
[![CRAN
status](https://www.r-pkg.org/badges/version/c14)](https://CRAN.R-project.org/package=c14)
[![R-CMD-check](https://github.com/joeroe/c14/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/joeroe/c14/actions/workflows/R-CMD-check.yaml)
[![Codecov test
coverage](https://codecov.io/gh/joeroe/c14/branch/master/graph/badge.svg)](https://codecov.io/gh/joeroe/c14?branch=master)
<!-- badges: end -->

**c14** provides basic classes and functions for radiocarbon data in R.
It makes it easier to combine methods from several existing packages
(e.g. rcarbon, Bchron, oxcAAR, c14bazAAR, ArchaeoPhases, stratigraphr)
together and work with them in a tidy data workflow.

It was forked from
[stratigraphr](https://github.com/joeroe/stratigraphr) v0.3.0.

## Installation

You can install the development version of c14 from GitHub:

``` r
# install.packages("devtools")
devtools::install_github("joeroe/c14")
```

## Usage

Tidy radiocarbon calibration:

``` r
library("c14")
library("dplyr")
ppnd %>% 
  filter(site == "Ganj Dareh") %>% 
  mutate(cal = c14_calibrate(cra, error))
#> # A tibble: 9 × 11
#>   lab_id   site       latitude longi…¹ context   cra error d13c  mater…² refer…³
#>   <chr>    <chr>         <dbl>   <dbl> <chr>   <int> <int> <chr> <chr>   <chr>  
#> 1 GaK 807  Ganj Dareh     34.2    47.5 Niv. E… 10400   150 <NA>  CH      Radioc…
#> 2 OxA 2099 Ganj Dareh     34.2    47.5 GD.Fl.…  8840   110 <NA>  S (hor… Hedges…
#> 3 OxA 2100 Ganj Dareh     34.2    47.5 GD.Fl.…  9010   110 <NA>  S (hor… Hedges…
#> 4 OxA 2101 Ganj Dareh     34.2    47.5 GD.Fl.…  8850   100 <NA>  S (hor… Hedges…
#> 5 OxA 2102 Ganj Dareh     34.2    47.5 GD.Fl.…  8690   110 <NA>  S (hor… Hedges…
#> 6 SI 922   Ganj Dareh     34.2    47.5 Niv. E   8570   210 <NA>  CH      Radioc…
#> 7 SI 923   Ganj Dareh     34.2    47.5 Niv.E    8625   195 <NA>  CH      Hole 1…
#> 8 SI 924   Ganj Dareh     34.2    47.5 Niv. E   8640    90 <NA>  CH      Hole 1…
#> 9 SI 925   Ganj Dareh     34.2    47.5 Niv.E,…  8385    75 <NA>  CH      Hole 1…
#> # … with 1 more variable: cal <cal>, and abbreviated variable names ¹​longitude,
#> #   ²​material, ³​references
```

The result is a `cal` vector, which fits nicely into a data frame or
tibble and comes with print methods etc.:

``` r
c14_calibrate(10000, 30)
#> <c14_cal[1]>
#> [1] 11400 cal BP
```
