# Calibrate radiocarbon dates

Transforms 'raw' radiocarbon ages into a calendar probability
distribution using a calibration curve.

## Usage

``` r
c14_calibrate(
  c14_age,
  c14_error,
  ...,
  engine = c("intcal", "rcarbon", "oxcal", "bchron"),
  min_pdens = 1e-05
)
```

## Arguments

- c14_age:

  Vector of uncalibrated radiocarbon ages.

- c14_error:

  Vector of standard errors associated with `c14_age`.

- ...:

  Optional arguments passed to calibration function (see below).

- engine:

  Method to use for calibration. The default (`"intcal"`) is fast and
  simple. Other options require additional packages to be installed.
  Available engines:

  - `"intcal"`:
    [`IntCal::caldist()`](https://rdrr.io/pkg/IntCal/man/caldist.html)
    (default)

  - `"rcarbon"`:
    [`rcarbon::calibrate()`](https://rdrr.io/pkg/rcarbon/man/calibrate.html)

  - `"oxcal"`:
    [`oxcAAR::oxcalCalibrate()`](https://rdrr.io/pkg/oxcAAR/man/oxcalCalibrate.html)

  - `"bchron"`:
    [`Bchron::BchronCalibrate()`](https://andrewcparnell.github.io/Bchron/reference/BchronCalibrate.html)

- min_pdens:

  Minimum probability density threshold below which ages are excluded
  from the result. Set to `NULL` to use the full calibration curve.

## Value

A list of `cal` objects.

## Details

`c14_age` and `c14_error` are recycled to a common length.

Parallelisation is supported for engines `"intcal"` and `"rcarbon"` and
can dramatically speed up calibration of large numbers of dates. For
`"intcal"`, it must first be enabled with
[`future::plan()`](https://future.futureverse.org/reference/plan.html).
For `"rcarbon"`, it requires the `doSNOW` package and can be controlled
with the `ncores` argument of
[`rcarbon::calibrate()`](https://rdrr.io/pkg/rcarbon/man/calibrate.html).

## Examples

``` r
c14_calibrate(1000, 30)
#> <c14_cal[1]>
#> [1] c. 922 cal BP
```
