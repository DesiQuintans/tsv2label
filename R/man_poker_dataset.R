
#' Poker Hand example dataset
#'
#' This is the first 100 rows of the training subset of the "Poker Hand"
#' dataset, originally from the UCI Machine Learning Repository. This package
#' comes with a set of labels for it, located in the `extdata/poker` folder
#' where this package is installed --- use `find.package("tsv2label")` to find
#' out where that is.
#'
#' I chose it as example data for `tsv2label` because it codes a playing card's
#' suit and rank as integers that need to be relabelled with their actual
#' meanings. It shows features of `tsv2label` like:
#'
#' 1. One `factor_file` can be applied to many columns (e.g. all 5 cards'
#'    ranks are named using the same `values_ranks` file).
#' 2. A `factor_file` can also be dedicated to one column only (e.g. `value_hands`
#'    factorises the `CLASS` column only).
#' 3. Factor conversion is not performed on columns without a named `factor_file`
#'    (e.g. `ID`, `CAT`).
#' 4. Columns are not renamed if they have no `rename` value (e.g. `CAT`).
#' 5. A data dictionary can contain columns that don't exist in the data (e.g. `not_exist`).
#' 6. A data dictionary can omit columns that **do** exist in the data (e.g. `LIST_COL`).
#' 7. Non-syntactic names are allowed (e.g. `COIN FLIP`).
#' 8. List columns are supported (e.g. `LIST_COL`).
#' 9. Conversion of truthy and falsy variables (`LOGICAL_CHAR`, `LOGICAL_INT`, and `yesno`)
#'    using built-in converters.
#'
#' @format ## `poker`
#' A data frame with 100 rows and 18 columns.
#'
#' @source <https://archive.ics.uci.edu/ml/datasets/Poker+Hand>
#' @md
"poker"
