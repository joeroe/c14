# Calibrated radiocarbon dates

The `cal` class represents a vector of calibrated radiocarbon dates as a
lazy record. Each element stores the parameters needed to derive a
calendar probability distribution (`c14_age`, `c14_error`, and
`c14_curve`), but does not compute the distribution until requested.

## Usage

``` r
cal(c14_age = double(), c14_error = double(), curve = c14_curve())
```

## Arguments

- c14_age:

  Vector of uncalibrated radiocarbon ages.

- c14_error:

  Vector of standard errors associated with `c14_age`.

- curve:

  A `c14_curve` object or list of `c14_curve` objects. Default:
  `IntCal20`.

## Value

A vector of class `cal` (`c14_cal`).

## Examples

``` r
cal(1000, 30, curve = IntCal20)
#> <c14_cal[1]>
#> [1] 797–956 cal BP
cal(c(1000, 2000), c(30, 40), curve = IntCal20)
#> <c14_cal[2]>
#> [1]   797–956 cal BP 1827–2044 cal BP
```
