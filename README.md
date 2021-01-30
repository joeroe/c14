
<!-- README.md is generated from README.Rmd. Please edit that file -->

# c14

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
[![CRAN
status](https://www.r-pkg.org/badges/version/c14)](https://CRAN.R-project.org/package=c14)
[![R build
status](https://github.com/joeroe/c14/workflows/R-CMD-check/badge.svg)](https://github.com/joeroe/c14/actions)
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
  mutate(cal = c14_calibrate(cra, error, verbose = FALSE))
#> # A tibble: 9 x 11
#>   lab_id site  latitude longitude context   cra error d13c  material references
#>   <chr>  <chr>    <dbl>     <dbl> <chr>   <int> <int> <chr> <chr>    <chr>     
#> 1 GaK 8… Ganj…     34.2      47.5 Niv. E… 10400   150 <NA>  CH       Radiocarb…
#> 2 OxA 2… Ganj…     34.2      47.5 GD.Fl.…  8840   110 <NA>  S (hord… Hedges et…
#> 3 OxA 2… Ganj…     34.2      47.5 GD.Fl.…  9010   110 <NA>  S (hord… Hedges et…
#> 4 OxA 2… Ganj…     34.2      47.5 GD.Fl.…  8850   100 <NA>  S (hord… Hedges et…
#> 5 OxA 2… Ganj…     34.2      47.5 GD.Fl.…  8690   110 <NA>  S (hord… Hedges et…
#> 6 SI 922 Ganj…     34.2      47.5 Niv. E   8570   210 <NA>  CH       Radiocarb…
#> 7 SI 923 Ganj…     34.2      47.5 Niv.E    8625   195 <NA>  CH       Hole 1987 
#> 8 SI 924 Ganj…     34.2      47.5 Niv. E   8640    90 <NA>  CH       Hole 1987 
#> 9 SI 925 Ganj…     34.2      47.5 Niv.E,…  8385    75 <NA>  CH       Hole 1987 
#> # … with 1 more variable: cal <list>
```

The result is a `cal` vector, which fits nicely into a data frame or
tibble and comes with print methods etc.:

``` r
c14_calibrate(10000, 30, verbose = FALSE)
#> [[1]]
#> # Calibrated probability distribution from 11806 to 11251 cal BP
#> 
#>                        #     #####              ###                             
#>                 ###   ##   ##########       ########                            
#>                #####  ##  ############   ###########                            
#>              #########################  #############        #                  
#>            ###########################################       ##                 
#>      #####################################################  #####               
#>   |---------|--------------|--------------|--------------|--------------|------|
#> 11300     11400          11500          11600          11700          11800  11900
#> Lab ID: 1
#> Uncalibrated: 10000±30 uncal BP
#> era: cal BP
#> curve: intcal20
#> reservoir_offset: 0
#> reservoir_offset_error: 0
#> calibration_range: 55000–0 BP
#> normalised: TRUE
#> F14C: FALSE
#> p_cutoff: 1e-05
```
