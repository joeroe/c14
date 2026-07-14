# Radiocarbon calibration curve class

The `c14_curve` class represents a radiocarbon calibration curve, which
estimates the calendar ages corresponding to a set of radiocarbon
measurements. Usually calibration is performed with either one of the
standard curves included with the package (see
[c14_curves](https://c14.joeroe.io/reference/c14_curves.md)) or read in
from a file with
[`read_14c()`](https://c14.joeroe.io/reference/read_14c.md).

`c14_curve()` constructs a a new calibration curve using values in 14C
years, optionally with their associated d14C values.

`c14_fcurve()` constructs a curve using fraction modern values (F14C or
pMC), typically used for "post-bomb" calibration.

## Usage

``` r
c14_curve(
  cal_age = era::yr(),
  c14_age = numeric(),
  c14_error = numeric(),
  d14c = numeric(),
  d14c_error = numeric()
)

c14_fcurve(cal_age = era::yr(), f14c = numeric(), f14c_error = numeric())
```

## Arguments

- cal_age:

  Vector of calendar ages. If `cal_age` is an object of class
  [era::yr](https://era.joeroe.io/reference/yr.html), its epoch will be
  respected, otherwise it is assumed to be `"cal BP"`.

- c14_age:

  Vector of uncalibrated radiocarbon ages.

- c14_error:

  Vector of errors (sigma values) associated with `c14_age`.

- d14c:

  Vector of Delta-14C values (optional).

- d14c_error:

  Vector of errors (sigma values) associated with `d14c` (optional).

- f14c:

  Vector of fraction modern (F14C or pMC) values.

- f14c_error:

  Vector of errors (sigma values) associated with `f14c`.

## Value

Object of class `c14_curve`.

## References

Stenström KE, Skog G, Georgiadou E, Genberg J, Johansson A (2011). “A
guide to radiocarbon units and calculations.” Technical Report
LUNFD6(NFFR-3111)/1-17/(2011), Lund University, Nuclear Physics.

## See also

Other calibration curve functions:
[`read_14c()`](https://c14.joeroe.io/reference/read_14c.md)
