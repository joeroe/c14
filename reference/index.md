# Package index

## Tidy radiocarbon

Core functions for working with radiocarbon data in a tidy framework.

- [`c14_age_norm()`](https://c14.joeroe.io/reference/c14_age_norm.md) :
  Generate the normal distribution of a radiocarbon age
- [`c14_calibrate()`](https://c14.joeroe.io/reference/c14_calibrate.md)
  : Calibrate radiocarbon dates
- [`c14_control_lab_id()`](https://c14.joeroe.io/reference/c14_control_lab_id.md)
  : Control radiocarbon laboratory identifiers
- [`c14_control_material()`](https://c14.joeroe.io/reference/c14_control_material.md)
  : Control radiocarbon sample materials
- [`c14_curve()`](https://c14.joeroe.io/reference/c14_curve.md)
  [`c14_fcurve()`](https://c14.joeroe.io/reference/c14_curve.md) :
  Radiocarbon calibration curve class
- [`IntCal20`](https://c14.joeroe.io/reference/c14_curves.md)
  [`SHCal20`](https://c14.joeroe.io/reference/c14_curves.md)
  [`Marine20`](https://c14.joeroe.io/reference/c14_curves.md)
  [`IntCal13`](https://c14.joeroe.io/reference/c14_curves.md)
  [`SHCal13`](https://c14.joeroe.io/reference/c14_curves.md)
  [`Marine13`](https://c14.joeroe.io/reference/c14_curves.md)
  [`IntCal09`](https://c14.joeroe.io/reference/c14_curves.md)
  [`Marine09`](https://c14.joeroe.io/reference/c14_curves.md)
  [`IntCal04`](https://c14.joeroe.io/reference/c14_curves.md)
  [`SHCal04`](https://c14.joeroe.io/reference/c14_curves.md)
  [`Marine04`](https://c14.joeroe.io/reference/c14_curves.md)
  [`IntCal98`](https://c14.joeroe.io/reference/c14_curves.md)
  [`Marine98`](https://c14.joeroe.io/reference/c14_curves.md) :
  Radiocarbon calibration curves
- [`c14_decay_libby`](https://c14.joeroe.io/reference/c14_decay.md)
  [`c14_decay_cambridge`](https://c14.joeroe.io/reference/c14_decay.md)
  : Radiocarbon decay constants
- [`c14_fix_lab_id()`](https://c14.joeroe.io/reference/c14_fix_lab_id.md)
  [`c14_is_lab_id()`](https://c14.joeroe.io/reference/c14_fix_lab_id.md)
  : Detect and fix malformed radiocarbon laboratory identifiers
- [`c14_lab_code_thesaurus`](https://c14.joeroe.io/reference/c14_lab_code_thesaurus.md)
  : Radiocarbon laboratory code thesaurus
- [`c14_labs`](https://c14.joeroe.io/reference/c14_labs.md) :
  Radiocarbon laboratories
- [`c14_material_thesaurus`](https://c14.joeroe.io/reference/c14_material_thesaurus.md)
  : Radiocarbon sample material thesaurus
- [`c14_parse_lab_id()`](https://c14.joeroe.io/reference/c14_parse_lab_id.md)
  : Parse radiocarbon laboratory identifiers
- [`c14_age()`](https://c14.joeroe.io/reference/c14_units.md)
  [`c14_f14c()`](https://c14.joeroe.io/reference/c14_units.md) :
  Radiocarbon unit calculations

## Radiocarbon measurements

Functions for working with uncalibrated radiocarbon measurements.

- [`c14_age()`](https://c14.joeroe.io/reference/c14_units.md)
  [`c14_f14c()`](https://c14.joeroe.io/reference/c14_units.md) :
  Radiocarbon unit calculations

## Summarise calibrated dates

Functions for summarising calibrated radiocarbon dates.

- [`cal_age_range()`](https://c14.joeroe.io/reference/cal_age_range.md)
  [`cal_age_min()`](https://c14.joeroe.io/reference/cal_age_range.md)
  [`cal_age_max()`](https://c14.joeroe.io/reference/cal_age_range.md) :
  Range of calibrated radiocarbon dates
- [`cal_hdr()`](https://c14.joeroe.io/reference/cal_hdr.md)
  [`cal_hdi()`](https://c14.joeroe.io/reference/cal_hdr.md) : Highest
  Density Region and Highest Density Interval
- [`cal_point()`](https://c14.joeroe.io/reference/cal_point.md) : Point
  estimates of calibrated radiocarbon dates

## Aggregate calibrated dates

Functions for aggregating calibrated radiocarbon dates.

- [`cal_density()`](https://c14.joeroe.io/reference/cal_density.md)
  [`density(`*`<c14_cal>`*`)`](https://c14.joeroe.io/reference/cal_density.md)
  : Kernel density estimation of calendar probability distributions
- [`cal_sum()`](https://c14.joeroe.io/reference/cal_sum.md)
  [`sum(`*`<c14_cal>`*`)`](https://c14.joeroe.io/reference/cal_sum.md) :
  Sum calendar probability distributions

## cal class methods

Methods for the `cal` class – vectors of calibrated radiocarbon dates.

- [`cal()`](https://c14.joeroe.io/reference/cal.md) : Calibrated
  radiocarbon dates
- [`as_cal()`](https://c14.joeroe.io/reference/as_cal.md) : Convert a
  foreign object to a cal object

## Conversion

Convert objects from other packages from or to c14 classes.

- [`as_cal()`](https://c14.joeroe.io/reference/as_cal.md) : Convert a
  foreign object to a cal object

## Calibration curves

Data, classes and functions for radiocarbon calibration curves.

- [`c14_curve()`](https://c14.joeroe.io/reference/c14_curve.md)
  [`c14_fcurve()`](https://c14.joeroe.io/reference/c14_curve.md) :
  Radiocarbon calibration curve class
- [`read_14c()`](https://c14.joeroe.io/reference/read_14c.md) : Read
  calibration curve files

## Datasets

Data included with the package.

- [`ppnd`](https://c14.joeroe.io/reference/ppnd.md) : Radiocarbon dates
  from Neolithic Southwest Asia
- [`shub1_c14`](https://c14.joeroe.io/reference/shub1_c14.md) :
  Radiocarbon dates from Shubayqa 1
- [`IntCal20`](https://c14.joeroe.io/reference/c14_curves.md)
  [`SHCal20`](https://c14.joeroe.io/reference/c14_curves.md)
  [`Marine20`](https://c14.joeroe.io/reference/c14_curves.md)
  [`IntCal13`](https://c14.joeroe.io/reference/c14_curves.md)
  [`SHCal13`](https://c14.joeroe.io/reference/c14_curves.md)
  [`Marine13`](https://c14.joeroe.io/reference/c14_curves.md)
  [`IntCal09`](https://c14.joeroe.io/reference/c14_curves.md)
  [`Marine09`](https://c14.joeroe.io/reference/c14_curves.md)
  [`IntCal04`](https://c14.joeroe.io/reference/c14_curves.md)
  [`SHCal04`](https://c14.joeroe.io/reference/c14_curves.md)
  [`Marine04`](https://c14.joeroe.io/reference/c14_curves.md)
  [`IntCal98`](https://c14.joeroe.io/reference/c14_curves.md)
  [`Marine98`](https://c14.joeroe.io/reference/c14_curves.md) :
  Radiocarbon calibration curves
- [`c14_decay_libby`](https://c14.joeroe.io/reference/c14_decay.md)
  [`c14_decay_cambridge`](https://c14.joeroe.io/reference/c14_decay.md)
  : Radiocarbon decay constants
