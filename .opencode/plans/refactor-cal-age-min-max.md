# Plan: Refactor cal_age_min and cal_age_max

## Problem
`cal_age_min()` and `cal_age_max()` are nearly identical functions with only one difference:
- `cal_age_min()` uses `min()` to find the minimum age
- `cal_age_max()` uses `max()` to find the maximum age

All other logic (grid selection, filtering, iteration) is duplicated.

## Solution
Extract the common logic into a private helper function that accepts the aggregation function as a parameter.

## Implementation

### Step 1: Create helper function `cal_age_bound()`
Create a new internal function that handles the common logic:

```r
#' @noRd
#' @keywords internal
cal_age_bound <- function(x, min_pdens = NULL, fn) {
  # Only use full curve when min_pdens is explicitly set to 0
  if (!is.null(min_pdens) && min_pdens == 0) {
    curve <- cal_c14_curve(x)
    dists <- cal_dist(x, at = curve$cal_age)
  } else {
    # Use sparse grid (default for NULL and > 0)
    dists <- cal_dist(x)
  }
  
  ages <- cal_dist_age(dists)
  pdens <- cal_dist_pdens(dists)
  
  purrr::map2_vec(ages, pdens, function(age, pdens) {
    # Treat NULL as 0 (no filtering)
    threshold <- if (is.null(min_pdens)) 0 else min_pdens
    if (threshold > 0) {
      valid <- !is.na(pdens) & pdens >= threshold
      if (!any(valid)) {
        return(fn(age, na.rm = TRUE))
      }
      age <- age[valid]
    }
    fn(age, na.rm = TRUE)
  })
}
```

### Step 2: Simplify `cal_age_min()`
Replace the implementation with a call to the helper:

```r
#' @rdname cal_age_range
#' @export
cal_age_min <- function(x, min_pdens = NULL) {
  cal_age_bound(x, min_pdens, min)
}
```

### Step 3: Simplify `cal_age_max()`
Replace the implementation with a call to the helper:

```r
#' @rdname cal_age_range
#' @export
cal_age_max <- function(x, min_pdens = NULL) {
  cal_age_bound(x, min_pdens, max)
}
```

## Benefits
- Eliminates ~50 lines of duplicated code
- Single source of truth for the grid selection and filtering logic
- Easier to maintain and modify in the future
- Public API remains unchanged
- No performance impact

## Testing
- All existing tests should pass without modification
- The behavior of both functions should remain identical to before
