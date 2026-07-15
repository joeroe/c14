# Calibrate radiocarbon dates

Transforms 'raw' radiocarbon ages into a calendar probability
distribution using a calibration curve.

## Usage

``` r
c14_calibrate(c14_age, c14_error, c14_curve = IntCal20)
```

## Arguments

- c14_age:

  Vector of uncalibrated radiocarbon ages.

- c14_error:

  Vector of standard errors associated with `c14_age`.

- c14_curve:

  A [c14_curve](https://c14.joeroe.io/reference/c14_curve.md) object or
  list of `c14_curve` objects. See
  [c14_curves](https://c14.joeroe.io/reference/c14_curves.md) for a list
  of the standard curves provided with the packages. Default:
  `IntCal20`.

## Value

A `cal` vector.

## Examples

``` r
c14_calibrate(1000, 30)
#> <c14_cal[1]>
#> [1] 797–956 cal BP
c14_calibrate(1000, 30, IntCal20)
#> <c14_cal[1]>
#> [1] 797–956 cal BP
```
