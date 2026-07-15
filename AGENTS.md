* Use idiomatic, functional R:
  * Functions should do one thing only
  * Functions should not have side-effects unless strictly necessary
  * Functions should be vectorized by default unless there is a good reason for
    them not to be
  * Where possible, functions should be vectorized by buidling on existing 
    vectorized functions
  * If this is not possible, use a map-apply pattern with purrr (if it is 
    already a dependency) or the base apply() family
  * Never, ever use for loops
* Follow the tidyverse style guide.
* Preface function names based on what inputs they expect; e.g. `c14_*()`
  functions work with raw C14 data; `cal_*()` functions work with calendar
  probability distributions.
* Clarity over concision. Spell out whole words when naming functions. Avoid
  acronyms and abbreviations. E.g. `cal_function()` not `cal_fn` or `cal_func`.
* Helper functions should be placed below the functions that call them.
