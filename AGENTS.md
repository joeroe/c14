* Follow a strict functional programming style of R:
  * Functions should do one thing only
  * Functions should not have side-effects unless strictly necessary
* Follow the tidyverse style guide.
* Preface function names based on what inputs they expect; e.g. `c14_*()`
  functions work with raw C14 data; `cal_*()` functions work with calendar
  probability distributions.
* Clarity over concision. Spell out whole words when naming functions. Avoid
  acronyms and abbreviations. E.g. `cal_function()` not `cal_fn` or `cal_func`.
