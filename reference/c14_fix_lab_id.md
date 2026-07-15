# Detect and fix malformed radiocarbon laboratory identifiers

`c14_is_lab_id()` tests whether a lab ID matches the conventional
format, e.g. `"OxA-1234"` or `"OxA 5678"`.

`c14_fix_lab_id()` attempts to coerce malformed lab IDs into this
format, by fixing common issues and variant forms.

## Usage

``` r
c14_fix_lab_id(x)

c14_is_lab_id(x)
```

## Arguments

- x:

  Vector of potentially malformed lab IDs.

## Value

`c14_is_lab_id()` returns a logical vector the same length as `x`.

`c14_fix_lab_id()` returns `x` with values replaced to match the
conventional format where possible.

## Details

The regular expression used to test for the conventional format is
`"^([[:alpha:]\(\)/]{1,8})[ -\u2010\u2013_#\.\+](.*)$"`. This accepts
unusual but parsable variants such as `"Ki(KIEV)-1234"` or
`"Gif/LSN_5678"`

## See also

Other functions for tidying radiocarbon metadata:
[`c14_control_lab_id()`](https://c14.joeroe.io/reference/c14_control_lab_id.md),
[`c14_control_material()`](https://c14.joeroe.io/reference/c14_control_material.md),
[`c14_parse_lab_id()`](https://c14.joeroe.io/reference/c14_parse_lab_id.md)

## Examples

``` r
# Valid formats
c14_is_lab_id(c("OxA-1234", "OxA 1234", "OxA", "Gif/LSN_5678"))
#> [1] TRUE TRUE TRUE TRUE

# Invalid formats
c14_is_lab_id(c("1234", "1234-OxA"))
#> [1] FALSE FALSE

# Fix
c14_fix_lab_id(c("OxA", "Gif/LSN_5678", "Ki(KIEV)-1234"))
#> [1] "OxA"           "Gif/LSN_5678"  "Ki(KIEV)-1234"
```
