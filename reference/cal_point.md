# Point estimates of calibrated radiocarbon dates

This function implements a number of methods for deriving a single point
estimate of calendar age from calibrated radiocarbon dates. Note that
none of these methods produce a *good* estimate (Michczyński 2007) , and
should only be used as a last resort if the probability distribution
function or an interval estimate is not appropriate, in which case
`method = "mode"` (the default) is recommended.

## Usage

``` r
cal_point(
  x,
  method = c("mode", "median", "mean", "local_mode", "central"),
  interval = 0.954,
  quiet = FALSE
)
```

## Arguments

- x:

  `cal` object. A vector of calibrated radiocarbon dates

- method:

  Character. Method of estimation:

  `"mode"` (default)

  :   age corresponding to the maximum peak of the probability
      distribution

  `"median"`

  :   age corresponding to the median quantile of the probability
      distribution

  `"mean"`

  :   mean age weighted by probability density

  `"local_mode"`

  :   age corresponding to the maximum peak of the probability
      distribution within the confidence range specified by `interval`
      (**not yet implemented**)

  `"central"`

  :   age corresponding to the central point of the probability density
      within the confidence range specified by `interval` (**not yet
      implemented**)

- interval:

  Numeric. Only used for `method = "local_mode"` and
  `method = "central"`.

- quiet:

  Set `quiet = TRUE` to suppress warnings and messages

## Value

Numeric vector the same length as `x` giving the point estimate for each
calibrated date.

## Details

If `x` has more than one modal value, `cal_point(x, method = "mode")`
will return the first.

## References

Michczyński A (2007). “Is it Possible to Find a Good Point Estimate of a
Calibrated Radiocarbon Date?” *Radiocarbon*, **49**(2), 393–401. ISSN
0033-8222, 1945-5755.
[doi:10.1017/S0033822200042326](https://doi.org/10.1017/S0033822200042326)
.

## See also

Other functions for summarising calibrated radiocarbon dates:
[`cal_age_range()`](https://c14.joeroe.io/reference/cal_age_range.md)

## Examples

``` r
cal_point(c14_calibrate(10000, 30))
#> # cal BP years <yr[1]>:
#> [1] 11400
#> # Era: Before Present (cal BP): Gregorian years (365.2425 days), counted backwards from 1950
```
