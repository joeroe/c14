# Highest Density Region and Highest Density Interval

`cal_hdr()` calculates the Highest Density Region (HDR) for calibrated
radiocarbon dates. The HDR is the shortest interval (or set of
intervals) that contains the specified proportion of the probability
mass.

`cal_hdi()` calculates the Highest Density Interval (HDI), which is the
single shortest contiguous interval containing the specified proportion
of the probability mass. Unlike `cal_hdr()`, which can return multiple
intervals for multimodal distributions, `cal_hdi()` always returns
exactly one interval.

## Usage

``` r
cal_hdr(x, interval = 0.954)

cal_hdi(x, interval = 0.954)
```

## Arguments

- x:

  A [cal](https://c14.joeroe.io/reference/cal.md) vector of calibrated
  radiocarbon dates.

- interval:

  Numeric. The probability content of the HDR/HDI. Default: 0.954
  (approximately 2 standard deviations).

## Value

For `cal_hdr()`: A list of the same length as `x`. Each element is a
list of numeric vectors, where each vector has two elements: the start
and end ages of an HDR interval. For multimodal distributions, multiple
intervals may be returned.

For `cal_hdi()`: A list of the same length as `x`. Each element is a
numeric vector with two elements: the start and end ages of the HDI
interval.

## See also

Other functions for summarising calibrated radiocarbon dates:
[`cal_age_range()`](https://c14.joeroe.io/reference/cal_age_range.md),
[`cal_mode()`](https://c14.joeroe.io/reference/cal_mode.md),
[`cal_probability()`](https://c14.joeroe.io/reference/cal_probability.md)

## Examples

``` r
x <- c14_calibrate(5000, 10)
cal_hdr(x)
#> [[1]]
#> [[1]][[1]]
#> # cal BP years <yr[2]>:
#> [1] 5657 5749
#> # Era: Before Present (cal BP): Gregorian years (365.2425 days), counted backwards from 1950
#> 
#> [[1]][[2]]
#> # cal BP years <yr[2]>:
#> [1] 5828 5849
#> # Era: Before Present (cal BP): Gregorian years (365.2425 days), counted backwards from 1950
#> 
#> 
cal_hdi(x)
#> [[1]]
#> # cal BP years <yr[2]>:
#> [1] 5657 5849
#> # Era: Before Present (cal BP): Gregorian years (365.2425 days), counted backwards from 1950
#> 
cal_hdr(x, interval = 0.683)
#> [[1]]
#> [[1]][[1]]
#> # cal BP years <yr[2]>:
#> [1] 5663 5686
#> # Era: Before Present (cal BP): Gregorian years (365.2425 days), counted backwards from 1950
#> 
#> [[1]][[2]]
#> # cal BP years <yr[2]>:
#> [1] 5712 5744
#> # Era: Before Present (cal BP): Gregorian years (365.2425 days), counted backwards from 1950
#> 
#> 
cal_hdi(x, interval = 0.683)
#> [[1]]
#> # cal BP years <yr[2]>:
#> [1] 5663 5744
#> # Era: Before Present (cal BP): Gregorian years (365.2425 days), counted backwards from 1950
#> 
```
