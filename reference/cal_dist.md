# Calendar probability distribution

The `cal_dist` class represents a vector of calendar probability
distributions.

`cal_dist()` is an S3 generic that constructs a new `cal_dist` vector:

- From a `cal` object: evaluates the calibrated probability distribution

- From a `data.frame`: constructs from raw age and probability density
  data

## Usage

``` r
cal_dist(x, ...)

# S3 method for class 'c14_cal'
cal_dist(x, at = NULL, ...)

# S3 method for class 'data.frame'
cal_dist(x, ..., .era = era::era("cal BP"))

# Default S3 method
cal_dist(x, ...)
```

## Arguments

- x:

  An object to convert to a `cal_dist`. Currently supports `cal` and
  `data.frame` objects.

- ...:

  Additional arguments passed to methods.

- at:

  List of numeric vectors giving the ages over which the distribution
  should be calculated. Recycled to `length(cal)`. If `NULL` (the
  default) then a plausible range is estimated for each calibrated date
  at the native resolution of the calibration curve (see details).

- .era:

  [`era::era()`](https://era.joeroe.io/reference/era.html) object
  describing the time scale used for ages. Defaults to calendar years
  Before Present (`era("cal BP")`). Only used by the `data.frame` method
  when ages are not already
  [`era::yr()`](https://era.joeroe.io/reference/yr.html) vectors.

## Value

A list of data frames with class `cal_dist` (`c14_cal_dist`). Each
element has two columns: `age` and `pdens`.

## Details

The 'plausible range' of a calibrated radiocarbon distribution is
estimated as the portions of the calibration curve that are no more than
six times the combined error of the determination and the curve away
from the conventional radiocarbon age.

## See also

Other cal class methods:
[`as_cal()`](https://c14.joeroe.io/reference/as_cal.md)

## Examples

``` r
# From data frames:
cal_dist(data.frame(age = era::yr(1:10, "cal BP"), pdens = rep(0.1, 10)))
#> <c14_cal_dist[1]>
#> [1] c. 1 cal BP

# From cal objects:
cal <- c14::cal(5000, 10, c14::IntCal20)
cal_dist(cal)
#> <c14_cal_dist[1]>
#> [1] c. 5730 cal BP
```
