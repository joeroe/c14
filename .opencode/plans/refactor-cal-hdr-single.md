# Plan: Refactor cal_hdr_single to remove for loop

## Problem
`cal_hdr_single` uses a for loop to iterate through RLE runs and extract interval boundaries. This is not idiomatic R and can be replaced with vectorized operations.

## Current Implementation (lines 314-324)
```r
intervals <- list()
for (i in seq_along(runs$lengths)) {
  if (runs$values[i]) {
    start_idx <- endpoints[i] + 1
    end_idx <- endpoints[i + 1]
    interval_ages <- ages[start_idx:end_idx]
    intervals[[length(intervals) + 1]] <- c(min(interval_ages), max(interval_ages))
  }
}

intervals
```

## Refactoring Strategy
Replace the for loop with vectorized operations:

1. **Identify TRUE runs**: Use `which(runs$values)` to get indices of runs where `values` is TRUE
2. **Calculate boundaries**: Vectorize the start/end index calculations
3. **Extract intervals**: Use `purrr::map2` to iterate over start/end indices in parallel

## New Implementation
```r
# Get indices of TRUE runs
true_runs <- which(runs$values)

# Calculate start and end indices for each TRUE run
start_indices <- endpoints[true_runs] + 1
end_indices <- endpoints[true_runs + 1]

# Extract ages for each interval and compute min/max
intervals <- purrr::map2(start_indices, end_indices, function(start, end) {
  interval_ages <- ages[start:end]
  c(min(interval_ages), max(interval_ages))
})

intervals
```

## Benefits
- More idiomatic R (no explicit for loop)
- Clearer intent (vectorized operations)
- Same performance characteristics (still O(n) where n is number of runs)
- Easier to read and maintain

## Testing
- Run existing tests to ensure behavior is unchanged
- Test with multimodal distributions to verify multiple intervals are extracted correctly
