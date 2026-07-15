# Radiocarbon unit calculations

Functions for calculating basic units used in radiocarbon measurements.

`c14_age()` calculates the conventional radiocarbon age (CRA) from a
fraction modern measurement.

`c14_f14c()` reverse-calculates the fractionation-corrected fraction
modern value (\\F^{14}C\\ or \\pM\\) of a radiocarbon age.

## Usage

``` r
c14_age(x, decay = c14::c14_decay_libby)

c14_f14c(x, decay = c14::c14_decay_libby)
```

## Arguments

- x:

  For `c14_age()`, a vector of fraction modern (\\F^{14}C\\)
  measurements. For `c14_f14c()`, a vector of conventional radiocarbon
  ages.

- decay:

  Decay constant. The default is the Libby constant (`c14_decay_libby`),
  which is the standard for calculating conventional radiocarbon ages.
  Use `c14_decay_cambridge` for the Cambridge constant, or a single
  numeric for other values.

## Value

Vector the same length as `x`.

## Details

`c14_age()` calculates the conventional radiocarbon age, \\t\\, as
defined by Stuiver and Polach (1977) :

\\t = -\frac{1}{\lambda}\ln{F^{14}C}\\

`c14_f14c()` implements the inverse of this function:

\\F^{14}C = e^{-\lambda t}\\

The decay constant conventionally used for calculating radiocarbon ages
is the Libby decay constant, \\\lambda_L=8033^{-1}\\. An alternative is
the Cambridge decay constant, \\\lambda_C=8267^{-1}\\ (Stenström et al.
2011) .

Reported radiocarbon ages are usually rounded based on the magnitude of
the error (Stuiver and Polach 1977) . For this reason,
reverse-calculating fraction modern from a radiocarbon age is unlikely
to return the precise original measurement of the sample.

Where available, fraction modern is the recommended measurement for
calibration (Bronk Ramsey 2008) .

## References

Bronk Ramsey C (2008). “Radiocarbon dating: revolutions in
understanding.” *Archaeometry*, **50**(2), 249–275. ISSN 0003-813X,
1475-4754.
[doi:10.1111/j.1475-4754.2008.00394.x](https://doi.org/10.1111/j.1475-4754.2008.00394.x)
.  
  
Stenström KE, Skog G, Georgiadou E, Genberg J, Johansson A (2011). “A
guide to radiocarbon units and calculations.” Technical Report
LUNFD6(NFFR-3111)/1-17/(2011), Lund University, Nuclear Physics.  
  
Stuiver M, Polach HA (1977). “Reporting of 14C Data.” *Radiocarbon*,
**19**(3), 355–363. ISSN 0033-8222, 1945-5755.
[doi:10.1017/S0033822200003672](https://doi.org/10.1017/S0033822200003672)
.

## Examples

``` r
c14_age(0.9239)
#> [1] 635.8235
c14_f14c(636)
#> [1] 0.9238797
```
