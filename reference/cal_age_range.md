# Range of a calendar probability distribution

Functions for calculating the minimum and maximum ages of a
[cal](https://c14.joeroe.io/reference/cal.md) vector. This function does
not take into account the probability distribution.

## Usage

``` r
cal_age_range(x, min_pdens = 0)

cal_age_min(x, min_pdens = 0)

cal_age_max(x, min_pdens = 0)
```

## Arguments

- x:

  A [cal](https://c14.joeroe.io/reference/cal.md) vector of calendar
  probability distributions.

- min_pdens:

  Ignores ages with values less than the given value when calculating
  the minimum or maximum. Default: 0.

## Value

A data frame with two columns giving the minimum (`min`) and maximum
(`max`) ages.

## See also

Other functions for summarising calibrated radiocarbon dates:
[`cal_point()`](https://c14.joeroe.io/reference/cal_point.md)

## Examples

``` r
x <- c14_calibrate(c(10000, 9000, 8000), rep(10, 3))

cal_age_min(x)
#> # cal BP years <yr[3]>:
#> [1] 11275  9970  8650
#> # Era: Before Present (cal BP): Gregorian years (365.2425 days), counted backwards from 1950
cal_age_max(x)
#> # cal BP years <yr[3]>:
#> [1] 11730 10235  9005
#> # Era: Before Present (cal BP): Gregorian years (365.2425 days), counted backwards from 1950
cal_age_range(x)
#>     min   max
#> 1 11275 11730
#> 2  9970 10235
#> 3  8650  9005
```
