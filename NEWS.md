# v0.1.0.9000 (development version)

* New `cal_probability()` summary of the probability that a calibrated date
  lies in a specified range #38
* New default `plot()` method for `cal` vectors (#32)
* New `cal_hdi()` and `cal_hdr()` summaries of the highest density interval and
  region(s) of a calibrated radiocarbon dates
  * Default printing of `cal` vectors is now the highest density interval
* `c14_calibrate` and all summary and aggregation functions now use an efficient
  internal calibration algorithm, instead of an external dependency
  * `c14_calibrate()` no longer has `engine` or `min_pdens` arguments (#24, #26)
  * `c14_calibrate()` now accepts a `curve` argument (#9)

# v0.1.0

Development version as of December 2024. Major changes since fork from 
stratigraphr:

* Revised the definition of the `cal` class, representing calibrated radiocarbon dates:
  * `cal` is now a `vctrs::list_of` subclass; a list of two-column data frames representing the probability distribution
  * The `age` column of a `cal` element is now an `era::yr` vector.
  * "Metadata" has been removed from the class definition
* Added summary functions for calibrated dates (`cal` class):
  * `cal_point()` for point estimates
  * `cal_age_range()`, `cal_age_min()`, and `cal_age_max()` for simple ranges
* Added aggregation functions for for calibrated dates (`cal` class):
  * `cal_sum()` for summed probability
  * `cal_density()` for composite kernel density estimation
* Added classes, functions and datasets for calibration curves:
  * `c14_curve` is a vctrs record class representing a calibration curve, with
    subclasses `c14_curve_14c` and `c14_curve_f14c` for CRA-based and F14C-based
    records respectively.
  * `c14_curve()` constructs a `c14_curve_14c` object
  * `c14_fcurve()` constructs a `c14_curve_f14c` object
  * `read_14c()` reads .14c and .f14c files
  * `?c14_curves`: exported datasets for the IntCal20, SHCal20, Marine20,
    IntCal13, SHCal13, Marine13, IntCal09, Marine09, IntCal04, SHCal04, 
    Marine04, IntCal98, and Marine98 curves.
* Added functions and datasets for working with radiocarbon measurements:
  * `c14_age()` for calculating a radiocarbon age from fraction modern.
  * `c14_f14c()` for reverse-calculating fraction modern from a radiocarbon age.
  * Decay constants `c14_decay_libby` and `c14_decay_cambridge`.
* Added example datasets `ppnd` and `shub1_c14`

# v0.0.0

The initial version of this package was forked from stratigraphr v0.3.0
