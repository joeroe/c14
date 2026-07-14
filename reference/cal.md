# Calibrated radiocarbon dates

The `cal` class represents a vector of calendar probability
distribution; typically calibrated radiocarbon dates.

`cal()` constructs a new `cal` vector from a set of data frames
containing the raw probability distributions.

## Usage

``` r
cal(..., .era = era::era("cal BP"))
```

## Arguments

- ...:

  \<[dynamic-dots](https://rlang.r-lib.org/reference/dyn-dots.html)\> A
  set of data frames. Each should have two columns, the first a vector
  of calendar ages, and the second a vector of associated probability
  densities. If the first column is not an
  [`era::yr()`](https://era.joeroe.io/reference/yr.html) vector, it is
  coerced to one using the time scale specified by `.era`.

- .era:

  [`era::era()`](https://era.joeroe.io/reference/era.html) object
  describing the time scale used for ages. Defaults to calendar years
  Before Present (`era("cal BP")`). Not used if the ages specified in
  `...` are already
  [`era::yr()`](https://era.joeroe.io/reference/yr.html) vectors.

## Value

A list of data frames with class `cal` (`c14_cal`). Each element has two
columns: `age` and `pdens`.

## Examples

``` r
# Uniform distribution between 1 and 10 BP:
cal(data.frame(age = era::yr(1:10, "cal BP"), pdens = rep(0.1, 10)))
#> <c14_cal[1]>
#> [1] c. 1 cal BP
```
