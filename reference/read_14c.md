# Read calibration curve files

Reads the .14c and .f14c formats used for radiocarbon calibration curves
and returns a [c14_curve](https://c14.joeroe.io/reference/c14_curve.md)
object.

For most files, only the first argument needs to be supplied. Further
arguments can be used if the file does not follow the conventional
format.

## Usage

``` r
read_14c(
  file,
  format = c("14c", "f14c"),
  delim = NA,
  cal_era = "cal BP",
  col_names = switch(format, `14c` = c("cal_age", "c14_age", "c14_error", "d14c",
    "d14c_error"), f14c = c("cal_age", "f14c", "f14c_error"))
)
```

## Arguments

- file:

  Path, connection, or URL of a calibration curve file, typically with
  the extension .14c or .f14c.

- format:

  `"14c"` or `"f14c"`. If not supplied, will be inferred from the the
  extension of `file`.

- delim:

  Character used to separate fields. If `NA` (the default), will be
  inferred from `format`: `","` for .14c files or `""` (any whitespace)
  for .f14c files.

- cal_era:

  Character label or
  [era::era](https://era.joeroe.io/reference/era.html) object describing
  the time scale used in the calibration curve's `cal_age` field.
  Default: `"cal BP"`.

- col_names:

  Vector of column names specifying the order of fields in the file. If
  not supplied, they are assumed to be in the usual order. Must contain
  all of the following elements, depending on the value of `format`:

  `format = "14c"`:

  :   `"cal_age"`, `"c14_age"`, `"c14_error"`, and optionally `"d14c"`
      and `"d14c_error"`

  `format = "f14c"`:

  :   `"cal_age"`, `"f14c"`, and `"f14c_error"`

  See [`c14_curve()`](https://c14.joeroe.io/reference/c14_curve.md) for
  more details on these fields.

## Value

A [c14_curve](https://c14.joeroe.io/reference/c14_curve.md) object.

## See also

Other calibration curve functions:
[`c14_curve()`](https://c14.joeroe.io/reference/c14_curve.md)

## Examples

``` r
read_14c("https://intcal.org/curves/intcal20.14c")
#> # custom curve <c14_curve_14c>
#> # Conventional radiocarbon age calibration curve
#> # Range: 0–55000 cal BP
#>   cal_age c14_age c14_error  d14c d14c_error
#> 1   55000   50100      1024 528.5      193.9
#> 2   54980   50081      1018 528.3      192.7
#> 3   54960   50063      1013 527.9      191.7
#> 4   54940   50043      1007 527.8      190.6
#> 5   54920   50027      1003 527.0      189.5
#> # 9496 more rows 
```
