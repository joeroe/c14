# Changelog

## c14 v0.1.0.9000 (development version)

- New individual functions for point summaries of calibrated radiocarbon
  dates, replacing
  [`cal_point()`](https://c14.joeroe.io/reference/cal_mode.md)
  (documented under
  [`?cal_point`](https://c14.joeroe.io/reference/cal_mode.md)):
  [`cal_mode()`](https://c14.joeroe.io/reference/cal_mode.md),
  [`cal_median()`](https://c14.joeroe.io/reference/cal_mode.md),
  [`cal_mean()`](https://c14.joeroe.io/reference/cal_mode.md),
  [`cal_local_mode()`](https://c14.joeroe.io/reference/cal_mode.md), and
  [`cal_central()`](https://c14.joeroe.io/reference/cal_mode.md).
- Package no longer depends on checkmate (depends), mockery, readr,
  readxl, usethis (suggests), or dplyr (suggests, but still required to
  build website)
- New
  [`cal_probability()`](https://c14.joeroe.io/reference/cal_probability.md)
  summary of the probability that a calibrated date lies in a specified
  range ([\#38](https://github.com/joeroe/c14/issues/38))
- New default [`plot()`](https://rdrr.io/r/graphics/plot.default.html)
  method for `cal` vectors
  ([\#32](https://github.com/joeroe/c14/issues/32))
- New [`cal_hdi()`](https://c14.joeroe.io/reference/cal_hdr.md) and
  [`cal_hdr()`](https://c14.joeroe.io/reference/cal_hdr.md) summaries of
  the highest density interval and region(s) of a calibrated radiocarbon
  dates
  - Default printing of `cal` vectors is now the highest density
    interval
  - Replaces `cal_age_range()`, `cal_age_min()`, and `cal_age_max()`
- `c14_calibrate` and all summary and aggregation functions now use an
  efficient internal calibration algorithm, instead of an external
  dependency
  - [`c14_calibrate()`](https://c14.joeroe.io/reference/c14_calibrate.md)
    no longer has `engine` or `min_pdens` arguments
    ([\#24](https://github.com/joeroe/c14/issues/24),
    [\#26](https://github.com/joeroe/c14/issues/26))
  - [`c14_calibrate()`](https://c14.joeroe.io/reference/c14_calibrate.md)
    now accepts a `curve` argument
    ([\#9](https://github.com/joeroe/c14/issues/9))

## c14 v0.1.0

Development version as of December 2024. Major changes since fork from
stratigraphr:

- Revised the definition of the `cal` class, representing calibrated
  radiocarbon dates:
  - `cal` is now a
    [`vctrs::list_of`](https://vctrs.r-lib.org/reference/list_of.html)
    subclass; a list of two-column data frames representing the
    probability distribution
  - The `age` column of a `cal` element is now an
    [`era::yr`](https://era.joeroe.io/reference/yr.html) vector.
  - “Metadata” has been removed from the class definition
- Added summary functions for calibrated dates (`cal` class):
  - [`cal_point()`](https://c14.joeroe.io/reference/cal_mode.md) for
    point estimates
  - `cal_age_range()`, `cal_age_min()`, and `cal_age_max()` for simple
    ranges
- Added aggregation functions for for calibrated dates (`cal` class):
  - [`cal_sum()`](https://c14.joeroe.io/reference/cal_sum.md) for summed
    probability
  - [`cal_density()`](https://c14.joeroe.io/reference/cal_density.md)
    for composite kernel density estimation
- Added classes, functions and datasets for calibration curves:
  - `c14_curve` is a vctrs record class representing a calibration
    curve, with subclasses `c14_curve_14c` and `c14_curve_f14c` for
    CRA-based and F14C-based records respectively.
  - [`c14_curve()`](https://c14.joeroe.io/reference/c14_curve.md)
    constructs a `c14_curve_14c` object
  - [`c14_fcurve()`](https://c14.joeroe.io/reference/c14_curve.md)
    constructs a `c14_curve_f14c` object
  - [`read_14c()`](https://c14.joeroe.io/reference/read_14c.md) reads
    .14c and .f14c files
  - [`?c14_curves`](https://c14.joeroe.io/reference/c14_curves.md):
    exported datasets for the IntCal20, SHCal20, Marine20, IntCal13,
    SHCal13, Marine13, IntCal09, Marine09, IntCal04, SHCal04, Marine04,
    IntCal98, and Marine98 curves.
- Added functions and datasets for working with radiocarbon
  measurements:
  - [`c14_age()`](https://c14.joeroe.io/reference/c14_units.md) for
    calculating a radiocarbon age from fraction modern.
  - [`c14_f14c()`](https://c14.joeroe.io/reference/c14_units.md) for
    reverse-calculating fraction modern from a radiocarbon age.
  - Decay constants `c14_decay_libby` and `c14_decay_cambridge`.
- Added example datasets `ppnd` and `shub1_c14`

## c14 v0.0.0

The initial version of this package was forked from stratigraphr v0.3.0
