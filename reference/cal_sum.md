# Sum calendar probability distributions

Aggregates a vector of calendar probability distributions (such as
calibrated radiocarbon dates) by summing them over a given range of
ages.

## Usage

``` r
cal_sum(x, range = cal_age_common(x), normalise = FALSE, ...)

# S3 method for class 'c14_cal'
sum(x, range = cal_age_common(x), normalise = FALSE, ...)
```

## Arguments

- x:

  A [cal](https://c14.joeroe.io/reference/cal.md) vector of calendar
  probability distributions

- range:

  Range of ages over which to sum. Defaults to the maximum range of `x`
  at one year resolution.

- normalise:

  Whether to normalise the summed distribution to sum to 1. The default
  is not to normalise.

- ...:

  Not used

## Value

The summed probability distribution as a
[cal](https://c14.joeroe.io/reference/cal.md) vector.

## See also

Other functions for aggregating calendar probability distributions:
[`cal_density()`](https://c14.joeroe.io/reference/cal_density.md)

## Examples

``` r
shub1_cal <- c14_calibrate(shub1_c14$c14_age, shub1_c14$c14_error)
cal_sum(shub1_cal)
#> <c14_cal[1]>
#> [1] c. 14250 cal BP
```
