# Control radiocarbon sample materials

Standardises a vector of radiocarbon sample materials use a thesaurus.

## Usage

``` r
c14_control_material(
  x,
  thesaurus = c14_material_thesaurus,
  quiet = FALSE,
  warn_unmatched = TRUE
)
```

## Arguments

- x:

  Vector of radiocarbon sample materials.

- thesaurus:

  Thesaurus to use for sample materials. Defaults to the
  [c14_material_thesaurus](https://c14.joeroe.io/reference/c14_material_thesaurus.md)
  thesaraus included in the package.

- quiet:

  Passed to
  [`controller::control()`](https://controller.joeroe.io/reference/control.html).
  Set to `TRUE` to suppress messages about replaced values. Default:
  `FALSE`.

- warn_unmatched:

  Passed to
  [`controller::control()`](https://controller.joeroe.io/reference/control.html).
  Set to `FALSE` to suppress warnings about unmatched values. Default:
  `TRUE`.

## Value

Vector the same length as `x` with controlled sample materials.
