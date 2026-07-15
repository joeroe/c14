# Convert a foreign object to a cal_dist object

`as_cal_dist()` converts objects from other packages that represent
calibrated radiocarbon distributions to the c14 `cal_dist` class.
Methods are currently implemented for:

- `CalDates`: from
  [`rcarbon::calibrate()`](https://rdrr.io/pkg/rcarbon/man/calibrate.html)

- `oxcAARCalibratedDate` and `oxcAARCalibratedDatesList`: from
  [`oxcAAR::oxcalCalibrate()`](https://rdrr.io/pkg/oxcAAR/man/oxcalCalibrate.html)

- `BchronCalibratedDates`: from
  [`Bchron::BchronCalibrate()`](https://andrewcparnell.github.io/Bchron/reference/BchronCalibrate.html)

These functions are intended for complex S3 objects from other packages.
The generic constructor
[`cal_dist()`](https://c14.joeroe.io/reference/cal_dist.md) can be used
for data frames and other base structures.

## Usage

``` r
as_cal_dist(x, ...)

# S3 method for class 'data.frame'
as_cal_dist(x, ...)

# S3 method for class 'matrix'
as_cal_dist(x, ...)

# S3 method for class 'CalDates'
as_cal_dist(x, ...)

# S3 method for class 'oxcAARCalibratedDatesList'
as_cal_dist(x, ...)

# S3 method for class 'oxcAARCalibratedDate'
as_cal_dist(x, ..., which = c("prior", "posterior"))

# S3 method for class 'BchronCalibratedDates'
as_cal_dist(x, ...)
```

## Arguments

- x:

  Object from another package to be converted to a `cal_dist` object.

- ...:

  Unused

- which:

  Which probability distribution to extract from an
  `oxcAARCalibratedDate`: `"prior"` (default) uses raw calibrated
  probabilities. `"posterior"` uses Bayesian posterior probabilities
  (error if not available).

## Value

Vector of class `c14_cal_dist`
([cal_dist](https://c14.joeroe.io/reference/cal_dist.md)).

## See also

Other cal class methods:
[`cal_dist()`](https://c14.joeroe.io/reference/cal_dist.md)
