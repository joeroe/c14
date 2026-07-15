# Control radiocarbon laboratory identifiers

Standardises a vector of radiocarbon laboratory identifiers to a common
format. Specifically, this `c14_control_lab_id()`:

1.  Fixes malformed identifiers with
    [`c14_fix_lab_id()`](https://c14.joeroe.io/reference/c14_fix_lab_id.md)

2.  Parses the lab code and lab number components
    ([`c14_parse_lab_id()`](https://c14.joeroe.io/reference/c14_parse_lab_id.md))

3.  Standardises lab codes against a thesaurus, by default
    [c14_lab_code_thesaurus](https://c14.joeroe.io/reference/c14_lab_code_thesaurus.md)

4.  Reunites lab codes and numbers with a uniform seperator (default:
    `"-"`)

## Usage

``` r
c14_control_lab_id(
  x,
  thesaurus = c14_lab_code_thesaurus,
  sep = "-",
  quiet = FALSE,
  warn_unmatched = TRUE
)
```

## Arguments

- x:

  Vector of radiocarbon laboratory identifiers.

- thesaurus:

  Thesaurus to use for lab codes. Defaults to the
  [c14_lab_code_thesaurus](https://c14.joeroe.io/reference/c14_lab_code_thesaurus.md)
  thesaraus included in the package.

- sep:

  Character to use to seperate lab codes and numbers in the result.
  Default: `"-"`.

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

Vector the same length as `x` with controlled laboratory identifiers.

## See also

Other functions for tidying radiocarbon metadata:
[`c14_control_material()`](https://c14.joeroe.io/reference/c14_control_material.md),
[`c14_fix_lab_id()`](https://c14.joeroe.io/reference/c14_fix_lab_id.md),
[`c14_parse_lab_id()`](https://c14.joeroe.io/reference/c14_parse_lab_id.md)

## Examples

``` r
c14_control_lab_id(c("OxA-1234", "OxA 1234", "Oxa 1234"))
#> Replaced values:
#> ℹ Oxa → OxA
#> [1] "OxA-1234" "OxA-1234" "OxA-1234"
```
