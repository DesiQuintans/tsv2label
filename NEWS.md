# CHANGELOG


## GitHub-installed in-development version

- ADDED
    - Optional `exclude` column in factor files, which lets you exclude a level/label from the final factor (i.e. turn it into `NA`) by setting the value of `exclude` to (case-insensitive) `true`, `t`, `yes`, `y`, or `1`. Previously, `NA`ing levels was done by omitting them from the factor file entirely. This lets you keep the level in the dictionary for completeness and transparency.

- FIXED
    - Files with multiple extensions (e.g. "index.tsv.txt") are accounted for.
    - Factor files with mixed-case names are handled properly.



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
