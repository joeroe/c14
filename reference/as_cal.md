# Convert a foreign object to a cal object

`as_cal()` converts objects from other packages that represent
calibrated radiocarbon dates to the c14 `cal` class. Methods are
currently implemented for:

- `CalDates`: from
  [`rcarbon::calibrate()`](https://rdrr.io/pkg/rcarbon/man/calibrate.html)

- `oxcAARCalibratedDate` and `oxcAARCalibratedDatesList`: from
  [`oxcAAR::oxcalCalibrate()`](https://rdrr.io/pkg/oxcAAR/man/oxcalCalibrate.html)

- `BchronCalibratedDates`: from
  [`Bchron::BchronCalibrate()`](https://andrewcparnell.github.io/Bchron/reference/BchronCalibrate.html)

These functions are intended for complex S3 objects from other packages.
The generic constructor
[`cal()`](https://c14.joeroe.io/reference/cal.md) can be used for data
frames and other base structures.

## Usage

``` r
as_cal(x)

# S3 method for class 'data.frame'
as_cal(x)

# S3 method for class 'matrix'
as_cal(x)

# S3 method for class 'CalDates'
as_cal(x)

# S3 method for class 'oxcAARCalibratedDatesList'
as_cal(x)

# S3 method for class 'oxcAARCalibratedDate'
as_cal(x)

# S3 method for class 'BchronCalibratedDates'
as_cal(x)
```

## Arguments

- x:

  Object from another package to be converted to a `cal` object.

## Value

Vector of class `c14_cal`
([cal](https://c14.joeroe.io/reference/cal.md)).
