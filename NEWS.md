# CHANGELOG

## Unreleased

- FIXED
    - Non-syntactic column names (e.g. column names with spaces) are now supported. Closes <https://github.com/DesiQuintans/tsv2label/issues/2>.

- CHANGED
    - `factor_file` and `factorise_with_dictionary()` are no longer picky about users giving filenames *without* extensions. It just chops off  *.tsv* and *.txt* extensions if they're present in `factor_file`.

- ADDED
    - Add a column with a non-syntactic name (`COIN FLIP`) to the built-in `poker` dataset. 
    - Add a list column (`LIST_COL`) to the built-in `poker` dataset. Closes <https://github.com/DesiQuintans/tsv2label/issues/4>.

## 0.10.0 (2023-03-25)

- Initial commit and release
