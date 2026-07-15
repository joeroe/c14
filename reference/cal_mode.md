# Point estimates of calibrated radiocarbon dates

Functions for deriving a single point estimate of calendar age from
calibrated radiocarbon dates. Note that none of these methods produce a
*good* estimate (Michczyński 2007) , and should only be used as a last
resort if the probability distribution function or an interval estimate
is not appropriate, in which case `cal_mode()` (the default) is
recommended.

## Usage

``` r
cal_mode(x, quiet = FALSE)

cal_median(x)

cal_mean(x)

cal_local_mode(x, interval = 0.954)

cal_central(x, interval = 0.954)
```

## Arguments

- x:

  `cal` object. A vector of calibrated radiocarbon dates.

- quiet:

  Set `quiet = TRUE` to suppress warnings (only used by `cal_mode()`).

- interval:

  Numeric. The confidence interval for `cal_local_mode()` and
  `cal_central()`. Default: 0.954.

## Value

Numeric vector the same length as `x` giving the point estimate for each
calibrated date.

## Details

- `cal_mode()`:

  Age corresponding to the maximum peak of the probability distribution.
  If `x` has more than one modal value, the first is returned.

- `cal_median()`:

  Age corresponding to the median quantile of the probability
  distribution.

- `cal_mean()`:

  Mean age weighted by probability density.

- `cal_local_mode()`:

  Age corresponding to the maximum peak of the probability distribution
  within the confidence range specified by `interval` (**not yet
  implemented**).

- `cal_central()`:

  Age corresponding to the central point of the probability density
  within the confidence range specified by `interval` (**not yet
  implemented**).

## References

Michczyński A (2007). “Is it Possible to Find a Good Point Estimate of a
Calibrated Radiocarbon Date?” *Radiocarbon*, **49**(2), 393–401. ISSN
0033-8222, 1945-5755.
[doi:10.1017/S0033822200042326](https://doi.org/10.1017/S0033822200042326)
.

## See also

Other functions for summarising calibrated radiocarbon dates:
[`cal_age_range()`](https://c14.joeroe.io/reference/cal_age_range.md),
[`cal_hdr()`](https://c14.joeroe.io/reference/cal_hdr.md),
[`cal_probability()`](https://c14.joeroe.io/reference/cal_probability.md)

## Examples

``` r
x <- c14_calibrate(10000, 30)

cal_mode(x)
#> # cal BP years <yr[1]>:
#> [1] 11400
#> # Era: Before Present (cal BP): Gregorian years (365.2425 days), counted backwards from 1950
cal_median(x)
#> # cal BP years <yr[1]>:
#> [1] 11475
#> # Era: Before Present (cal BP): Gregorian years (365.2425 days), counted backwards from 1950
cal_mean(x)
#> # cal BP years <yr[1]>:
#> [1] 11479.82
#> # Era: Before Present (cal BP): Gregorian years (365.2425 days), counted backwards from 1950
```
