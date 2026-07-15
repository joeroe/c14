# Kernel density estimation of calendar probability distributions

Aggregates calibrated radiocarbon dates and other calendar probability
distributions using the composite kernel density estimate (cKDE) method
method (Brown 2017) . This involves estimating the density of a set of
dates by repeatedly computing the kernel density estimate of a random
sample of ages drawn from their probability distributions.

## Usage

``` r
cal_density(x, bw = 30, ..., times = 25, bootstrap = TRUE, strata = NULL)

# S3 method for class 'c14_cal'
density(x, ...)
```

## Arguments

- x:

  A [cal](https://c14.joeroe.io/reference/cal.md) vector of calendar
  probability distributions.

- bw:

  Kernel bandwidth size passed to
  [`stats::density()`](https://rdrr.io/r/stats/density.html). Can be
  either an integer value or a character selection rule, but the latter
  will likely result in a different bandwidth being applied to each
  bootstrapped sample and therefore should be avoided. Default: `30`
  (years).

- ...:

  Further arguments passed to
  [`stats::density()`](https://rdrr.io/r/stats/density.html).

- times:

  Number of bootstrap samples to generate. The default of `25` is
  suitable for testing but should be set much higher in practice.

- bootstrap:

  If `TRUE` (the default), randomly resamples with replacement from `x`
  before each KDE calculation.

- strata:

  If not `NULL`, KDEs will be weighted to ensure equal representation of
  classes specified by a factor or character vector. If
  `bootstrap = TRUE`, bootstrap samples are generated using stratified
  resampling of the same classes.

## Value

The result as a data frame or
[tibble::tibble](https://tibble.tidyverse.org/reference/tibble.html)
with three columns: `age` (interpolated to common range of `x`),
`.estimate` (mean of the bootstrapped KDEs), and `.error` (standard
error of the bootstrapped KDEs).

## Details

`cal_density(..., bootstrap = TRUE)` performs composite kernel density
estimation with bootstrapping (McLaughlin 2019) , where sampling error.
`x` is estimated by randomly resampling `x` before each KDE calculation.

See McLaughlin (2019) and Crema (2022) for discussions of bandwith
selection.

## References

Brown WA (2017). “The Past and Future of Growth Rate Estimation in
Demographic Temporal Frequency Analysis: Biodemographic Interpretability
and the Ascendance of Dynamic Growth Models.” *Journal of Archaeological
Science*, **80**, 96–108. ISSN 0305-4403.
[doi:10.1016/j.jas.2017.02.003](https://doi.org/10.1016/j.jas.2017.02.003)
.  
  
Crema ER (2022). “Statistical Inference of Prehistoric Demography from
Frequency Distributions of Radiocarbon Dates: A Review and a Guide for
the Perplexed.” *Journal of Archaeological Method and Theory*,
**29**(4), 1387–1418. ISSN 1573-7764.
[doi:10.1007/s10816-022-09559-5](https://doi.org/10.1007/s10816-022-09559-5)
.  
  
McLaughlin TR (2019). “On Applications of Space–Time Modelling with
Open-Source 14C Age Calibration.” *Journal of Archaeological Method and
Theory*, **26**(2), 479–501. ISSN 1573-7764.
[doi:10.1007/s10816-018-9381-3](https://doi.org/10.1007/s10816-018-9381-3)
.

## See also

Other functions for aggregating calendar probability distributions:
[`cal_sum()`](https://c14.joeroe.io/reference/cal_sum.md)

## Examples

``` r
data(shub1_c14)
shub1_cal <- c14_calibrate(shub1_c14$c14_age, shub1_c14$c14_error)
cal_density(shub1_cal)
#> # A tibble: 14,792 × 3
#>           age .estimate   .error
#>          <yr>     <dbl>    <dbl>
#>  1 789 cal BP  2.83e-14 1.41e-13
#>  2 790 cal BP  1.90e-13 9.50e-13
#>  3 791 cal BP  3.52e-13 1.76e-12
#>  4 792 cal BP  5.14e-13 2.57e-12
#>  5 793 cal BP  6.75e-13 3.38e-12
#>  6 794 cal BP  8.37e-13 4.18e-12
#>  7 795 cal BP  9.99e-13 4.99e-12
#>  8 796 cal BP  1.16e-12 5.80e-12
#>  9 797 cal BP  1.32e-12 6.61e-12
#> 10 798 cal BP  1.48e-12 7.42e-12
#> # ℹ 14,782 more rows

# Stratify and weight bootstrap estimation by phase
cal_density(shub1_cal, strata = shub1_c14$phase)
#> Warning: sum(weights) != 1  -- will not get true density
#> Warning: sum(weights) != 1  -- will not get true density
#> Warning: sum(weights) != 1  -- will not get true density
#> Warning: sum(weights) != 1  -- will not get true density
#> Warning: sum(weights) != 1  -- will not get true density
#> Warning: sum(weights) != 1  -- will not get true density
#> Warning: sum(weights) != 1  -- will not get true density
#> Warning: sum(weights) != 1  -- will not get true density
#> Warning: sum(weights) != 1  -- will not get true density
#> Warning: sum(weights) != 1  -- will not get true density
#> Warning: sum(weights) != 1  -- will not get true density
#> Warning: sum(weights) != 1  -- will not get true density
#> Warning: sum(weights) != 1  -- will not get true density
#> Warning: sum(weights) != 1  -- will not get true density
#> Warning: sum(weights) != 1  -- will not get true density
#> Warning: sum(weights) != 1  -- will not get true density
#> Warning: sum(weights) != 1  -- will not get true density
#> Warning: sum(weights) != 1  -- will not get true density
#> Warning: sum(weights) != 1  -- will not get true density
#> Warning: sum(weights) != 1  -- will not get true density
#> Warning: sum(weights) != 1  -- will not get true density
#> Warning: sum(weights) != 1  -- will not get true density
#> Warning: sum(weights) != 1  -- will not get true density
#> Warning: sum(weights) != 1  -- will not get true density
#> Warning: sum(weights) != 1  -- will not get true density
#> # A tibble: 14,792 × 3
#>           age .estimate   .error
#>          <yr>     <dbl>    <dbl>
#>  1 789 cal BP  8.33e-14 4.16e-13
#>  2 790 cal BP  5.61e-13 2.81e-12
#>  3 791 cal BP  1.04e-12 5.20e-12
#>  4 792 cal BP  1.52e-12 7.59e-12
#>  5 793 cal BP  2.00e-12 9.98e-12
#>  6 794 cal BP  2.47e-12 1.24e-11
#>  7 795 cal BP  2.95e-12 1.48e-11
#>  8 796 cal BP  3.43e-12 1.71e-11
#>  9 797 cal BP  3.91e-12 1.95e-11
#> 10 798 cal BP  4.39e-12 2.19e-11
#> # ℹ 14,782 more rows
```
