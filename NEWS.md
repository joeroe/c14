# c14 development version

* Revised `cal` class, representing calibrated radiocarbon dates:
  * Probability distributions are now represented by `calp` class.
  * `as_calp()` converts objects from other packages (`rcarbon::calGrid`) to `calp`.
* Added summary functions for calibrated dates (`cal` class):
  * `c14_point()` for point estimates
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

# c14 0.0.0

Initial version forked from stratigraphr v0.3.0.