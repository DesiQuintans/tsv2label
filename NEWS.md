# CHANGELOG


## In-development version

- FIXED
    - Files with multiple extensions (e.g. "index.tsv.txt") are accounted for.
    - 



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
