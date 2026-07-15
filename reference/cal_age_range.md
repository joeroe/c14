# Range of calibrated radiocarbon dates

Functions for calculating the minimum and maximum ages of a
[cal](https://c14.joeroe.io/reference/cal.md) vector. The range is
determined by the probability distribution, with the extent controlled
by the `min_pdens` parameter.

## Usage

``` r
cal_age_range(x, min_pdens = NULL)

cal_age_min(x, min_pdens = NULL)

cal_age_max(x, min_pdens = NULL)
```

## Arguments

- x:

  A [cal](https://c14.joeroe.io/reference/cal.md) vector of calendar
  probability distributions.

- min_pdens:

  Controls the minimum probability density threshold used to determine
  boundaries. The default is `pdens > 0` within a plausible range around
  the calibrated date. Set `min_pdens` to a value between 0 and 1 to
  futher constrain the range or set `min_pdens = 0` to find the absolute
  boundaries on the full range of the calibration curve.

## Value

A data frame with two columns giving the minimum (`min`) and maximum
(`max`) ages.

## See also

Other functions for summarising calibrated radiocarbon dates:
[`cal_hdr()`](https://c14.joeroe.io/reference/cal_hdr.md),
[`cal_point()`](https://c14.joeroe.io/reference/cal_point.md),
[`cal_probability()`](https://c14.joeroe.io/reference/cal_probability.md)

## Examples

``` r
x <- c14_calibrate(c(10000, 9000, 8000), rep(10, 3))

cal_age_min(x)
#> # cal BP years <yr[3]>:
#> [1] 11245  9910  8605
#> # Era: Before Present (cal BP): Gregorian years (365.2425 days), counted backwards from 1950
cal_age_max(x)
#> # cal BP years <yr[3]>:
#> [1] 11805 10245  9080
#> # Era: Before Present (cal BP): Gregorian years (365.2425 days), counted backwards from 1950
cal_age_range(x)
#>     min   max
#> 1 11245 11805
#> 2  9910 10245
#> 3  8605  9080
```
