# CHANGELOG


## 1.0.0

- REMOVED
    - `factorise_with_dictionary()` is removed and replaced with `recode_with_dictionary()` to support the introduction of _converters_ (below). Since this package is not yet in wide usage, I have decided to make this a breaking change.

- CHANGED
    - The column name `factor_file` is now renamed to `recode_with` to support the introduction of _converters_ (below). Since this package is not yet in wide usage, I have decided to make this a breaking change.
    - 'Factor files' (i.e. the spreadsheets used to map values to factor levels) are now called 'mapping spreadsheets'.
    - Columns `LOGICAL_CHAR`, `LOGICAL_INT`, and `yesno` added to the built-in `poker` dataset for unit testing.

- ADDED
    - **Converters!** Pre-made converters so that you don't have to keep making factor files for routine jobs:
        - `<truefalse>` - Strict conversion to Logical. Truthy values (1, y, yes, t, true) return Logical `TRUE`, falsey values (0, n, no, f, false) return FALSE, everything else (including `NA`) returns `NA`.
        - `<truefalse-lazy>` - Lazy conversion to Logical. Truthy values return `TRUE`, everything else returns `FALSE`, `NA` returns `NA`.
        - `<yesno>` and `<noyes>` - Like `<truefalse>`, but returns Factor instead of Logical. The difference between the two is the order of the levels; you may want `<noyes>` if you're planning to feed a variable to a model, for example, so that the first level ("No") is used as the reference level.
        - `<yesno-lazy>` and `<noyes-lazy>` - Like `<truefalse-lazy>`, but returns Factor instead of Logical.
    - Functions now have a `up` argument that gives you optional control over the environment where the functions will be evaluated.
    - `recode_with_dictionary()` tells you if your mapping spreadsheet is missing the required columns `levels` and `labels`.
    - `recode_with_dictionary()` announces which mapping spreadsheet and columns it's currently working on. Good for large datasets so you know it isn't frozen. Closes <https://github.com/DesiQuintans/tsv2label/issues/10>.
    - Optional `exclude` column in mapping spreadsheets, which lets you exclude a level/label from the final factor (i.e. turn it into `NA`) by setting the value of `exclude` to (case-insensitive) `true`, `t`, `yes`, `y`, or `1`. Previously, `NA`ing levels was done by omitting them from the factor file entirely. This lets you keep the level in the dictionary for completeness and transparency.
    - Documentation demonstrates how unused factor levels can be dropped with `base::droplevels()`. Closes <https://github.com/DesiQuintans/tsv2label/issues/9>
    - Unit tests.

- FIXED
    - `.Globalenv` is no longer hard-coded. Closes <https://github.com/DesiQuintans/tsv2label/issues/14>.
    - Empty `recode_with` cells (e.g. spaces only) are handled correctly. Closes <https://github.com/DesiQuintans/tsv2label/issues/11>.
    - Files with multiple extensions (e.g. "index.tsv.txt") are accounted for.
    - Mapping spreadsheets with mixed-case names are handled properly.
    - `recode_with_dictionary()` trims trailing whitespace from factor levels and labels at all stages, including from the raw input vector.



## 0.2.0

- FIXED
    - Non-syntactic column names (e.g. column names with spaces) are now okay. Closes <https://github.com/DesiQuintans/tsv2label/issues/2>.

- CHANGED
    - `factor_file` and `factorise_with_dictionary()` are no longer picky about users giving filenames *without* extensions. It just chops off  *.tsv* and *.txt* extensions if they're present in `factor_file`.
    - Factor file columns now actually match the argument names of `factor()`. They used to be `level` and `label`, and now they are `levels` and `labels`.

- ADDED
    - Add a column with a non-syntactic name (`COIN FLIP`) to the built-in `poker` dataset. 
    - Add a list column (`LIST_COL`) to the built-in `poker` dataset. Closes <https://github.com/DesiQuintans/tsv2label/issues/4>.
    - Updated the `poker` dictionary to include `COIN FLIP` but **not** `LIST_COL` (so that the dictionary now has both a column that is in the dictionary but not in the data (`not_exist`) as well as a column that is in the data but not in the dictionary).



## 0.1.0 (2023-03-25)

- Initial commit and release
