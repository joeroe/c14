# c14

**c14** provides basic classes and functions for radiocarbon data in R.
It makes it easier to combine methods from several existing packages
(e.g. rcarbon, Bchron, oxcAAR, c14bazAAR, ArchaeoPhases, stratigraphr)
together and work with them in a tidy data workflow.

It was forked from
[stratigraphr](https://github.com/joeroe/stratigraphr) v0.3.0.

## Installation

You can install the development version of c14 from GitHub with the
[remotes](https://remotes.r-lib.org) package:

``` r

# install.packages("remotes")
remotes::install_github(c("joeroe/controller", "joeroe/c14"))
```

Note that the dependency
[controller](https://github.com/joeroe/controller) is also not yet
available on CRAN.

## Usage

The main aim of c14 is to make it easier to work with radiocarbon data
within a tidy workflow. For example, we can combine
[`dplyr::filter()`](https://dplyr.tidyverse.org/reference/filter.html)
with
[`c14_calibrate()`](https://c14.joeroe.io/reference/c14_calibrate.md) to
only calibrate dates from a specific site:

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
#> 1 GaK 807  10400   150 11755–12710 cal BP
#> 2 OxA 2099  8840   110  9560–10190 cal BP
#> 3 OxA 2100  9010   110  9750–10485 cal BP
#> 4 OxA 2101  8850   100  9560–10195 cal BP
#> 5 OxA 2102  8690   110  9490–10145 cal BP
#> 6 SI 922    8570   210  9035–10180 cal BP
#> 7 SI 923    8625   195  9145–10200 cal BP
#> 8 SI 924    8640    90  9475–10105 cal BP
#> 9 SI 925    8385    75   9145–9530 cal BP
```

The resulting `cal`-class vector can be assigned to a new column,
allowing us to keep working with the data in the context of the original
data frame or tibble.
