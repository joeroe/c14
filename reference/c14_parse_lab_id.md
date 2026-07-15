# Parse radiocarbon laboratory identifiers

Splits a vector of radiocarbon lab IDs (e.g. `"OxA-1234"`) into its
constituent parts: the lab code (`"OxA"`) and quasi-numeric unique
identifier (`"1324"`). If `x` contains values that don't fit the
standard format (`"OxA-1234"` or `"OxA 4567"`), by default the function
will attempt to fix these with
[`c14_fix_lab_id()`](https://c14.joeroe.io/reference/c14_fix_lab_id.md)
before parsing.

## Usage

``` r
c14_parse_lab_id(x, fix = TRUE)
```

## Arguments

- x:

  Vector of lab IDs, e.g. `"OxA-1234"`.

- fix:

  If `TRUE` (the default), attempts to fix malformed lab IDs before
  parsing.

## Value

A data frame with two character columns: `lab_code` and `lab_number`. If
`x` is of length one, this is simplified to a named character vector of
length 2.

## See also

Other functions for tidying radiocarbon metadata:
[`c14_control_lab_id()`](https://c14.joeroe.io/reference/c14_control_lab_id.md),
[`c14_control_material()`](https://c14.joeroe.io/reference/c14_control_material.md),
[`c14_fix_lab_id()`](https://c14.joeroe.io/reference/c14_fix_lab_id.md)

## Examples

``` r
c14_parse_lab_id(c("OxA-1234", "Ly 456", "RT 1234-5678"))
#>   lab_code lab_number
#> 1      OxA       1234
#> 2       Ly        456
#> 3       RT  1234-5678

# By default, tries to fix malformed values of x before parsing
# Use fix = FALSE for strict parsing
c14_parse_lab_id(c("OxA 1234", "OxA_5678", "Gif/LSN-123"))
#>   lab_code lab_number
#> 1      OxA       1234
#> 2      OxA       5678
#> 3  Gif/LSN        123
c14_parse_lab_id(c("OxA 1234", "OxA_5678", "Gif/LSN-123"), fix = FALSE)
#>   lab_code lab_number
#> 1      OxA       1234
#> 2      OxA       5678
#> 3  Gif/LSN        123

# Single values of x are simplified to a character vector
c14_parse_lab_id("OxA 1234")
#>   lab_code lab_number 
#>      "OxA"     "1234" 
```
