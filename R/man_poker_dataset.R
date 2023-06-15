
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
#' meanings. It shows how the same `value_file` can be used to add value label
#' to many columns (e.g. labelling the 5 card ranks columns using the same
#' file), or how a `value_file` can be dedicated to one column only (e.g.
#' `value_hands` to label the `CLASS` column). I have added 2 extra columns of
#' different types (`ID`, `CAT`) to show that `tsv2label` leaves
#' them alone if no `value_file` is specified for them in `index.tsv`. I have
#' also added a column with a non-syntactic name (`COIN FLIP`) and a list column
#' (`LIST_COL`) for testing.
#'
#' @format ## `poker`
#' A data frame with 100 rows and 15 columns.
#'
#' @source <https://archive.ics.uci.edu/ml/datasets/Poker+Hand>
#' @md
"poker"
