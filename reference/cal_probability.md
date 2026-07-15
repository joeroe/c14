# Probability that a calibrated date falls within an age range

Calculates the probability that a calibrated radiocarbon date falls
within a given calendar age range or a single year.

## Usage

``` r
cal_probability(x, from, to = NULL)
```

## Source

Rundkvist, Martin. 20 November 2024. Radiocarbon in the AD 900s on
Riddarholmen. *Aardvarchaeology*.
<https://aardvarchaeology.wordpress.com/2024/11/20/radiocarbon-in-the-ad-900s-on-riddarholmen/>

## Arguments

- x:

  A [cal](https://c14.joeroe.io/reference/cal.md) vector of calibrated
  radiocarbon dates.

- from:

  Numeric. Start of the age range (inclusive), in the same era as the
  calibration (typically cal BP).

- to:

  Numeric or `NULL`. End of the age range (inclusive). If `NULL` (the
  default), returns the probability mass at the single year given by
  `from`.

## Value

Numeric vector of probabilities between 0 and 1, the same length as `x`.

## See also

This function is the inverse of
[`cal_hdi()`](https://c14.joeroe.io/reference/cal_hdr.md) and
[`cal_hdr()`](https://c14.joeroe.io/reference/cal_hdr.md), which find
intervals for a given probability mass.

Other functions for summarising calibrated radiocarbon dates:
[`cal_hdr()`](https://c14.joeroe.io/reference/cal_hdr.md),
[`cal_mode()`](https://c14.joeroe.io/reference/cal_mode.md)

## Examples

``` r
x <- c14_calibrate(1116, 30)

# Probability within an age range
cal_probability(x, 970, 1060)
#> [1] 0.8086552

# Probability at a single year
cal_probability(x, 5000)
#> [1] 0
```
