

# Setup -------------------------------------------------------------------

library(tsv2label)

my_poker <- tsv2label::poker  # The test data
dict_path <- system.file("extdata/poker", package = "tsv2label")  # The dictionary

# deparse(my_poker$LOGICAL_CHAR) |> clipr::write_clip()

orig_S1 <-
    c(1L, 2L, 3L, 4L, 4L, 1L, 1L, 2L, 3L, 4L, 1L, 2L, 1L, 2L, 3L,
      1L, 1L, 3L, 4L, 3L, 1L, 2L, 3L, 2L, 2L, 2L, 3L, 1L, 3L, 2L, 3L,
      4L, 1L, 3L, 3L, 4L, 2L, 4L, 2L, 2L, 2L, 2L, 2L, 3L, 4L, 1L, 2L,
      1L, 4L, 4L, 1L, 1L, 4L, 4L, 2L, 4L, 2L, 4L, 1L, 1L, 4L, 3L, 1L,
      1L, 2L, 1L, 1L, 4L, 2L, 3L, 4L, 4L, 4L, 4L, 2L, 1L, 3L, 2L, 2L,
      2L, 4L, 2L, 1L, 2L, 2L, 2L, 1L, 2L, 2L, 1L, 2L, 1L, 2L, 4L, 3L,
      3L, 3L, 1L, 3L, 2L)

orig_CLASS <-
    c(9L, 9L, 9L, 9L, 9L, 8L, 8L, 8L, 8L, 8L, 1L, 0L, 0L, 0L, 1L,
      0L, 4L, 0L, 0L, 1L, 1L, 0L, 1L, 1L, 1L, 1L, 1L, 1L, 0L, 0L, 3L,
      0L, 0L, 0L, 0L, 0L, 1L, 1L, 0L, 1L, 1L, 1L, 1L, 0L, 1L, 0L, 0L,
      0L, 1L, 1L, 0L, 0L, 0L, 0L, 0L, 0L, 1L, 1L, 0L, 2L, 0L, 1L, 0L,
      0L, 1L, 0L, 0L, 0L, 1L, 1L, 1L, 0L, 1L, 5L, 1L, 2L, 1L, 2L, 1L,
      1L, 0L, 0L, 0L, 0L, 0L, 1L, 0L, 0L, 0L, 0L, 1L, 0L, 1L, 1L, 0L,
      1L, 2L, 3L, 1L, 1L)

orig_LOGICAL_CHAR <-
    c("t", "YES", NA, "apple", "FaLsE", "No", "False", "f", "n",
      "Y", "n", "t", "T", "TRUE", "F", "true", "T", "t", "y", "N",
      "FALSE", "true", "N", "yes", "True", "No", "no", "FALSE", "TRUE",
      "f", "f", "Y", "FALSE", "True", "Yes", "true", "n", "t", "True",
      "YES", "NO", "False", "F", "F", "YES", "TRUE", "yes", "False",
      "no", "yes", "F", "TRUE", "n", "FALSE", "Y", "N", "yes", "no",
      "False", "TRUE", "T", "NO", "YES", "No", "N", "yes", "YES", "n",
      "Yes", "n", "F", "yes", "TRUE", "NO", "T", "TRUE", "Yes", "TRUE",
      "Yes", "no", "false", "TRUE", "y", "f", "True", "F", "yes", "false",
      "YES", "TRUE", "T", "TRUE", "FALSE", "N", "Y", "Yes", "yes",
      "t", "NO", "Yes")



new_CLASS <-
    structure(c(10L, 10L, 10L, 10L, 10L, 9L, 9L, 9L, 9L, 9L, 2L,
                1L, 1L, 1L, 2L, 1L, 5L, 1L, 1L, 2L, 2L, 1L, 2L, 2L, 2L, 2L, 2L,
                2L, 1L, 1L, 4L, 1L, 1L, 1L, 1L, 1L, 2L, 2L, 1L, 2L, 2L, 2L, 2L,
                1L, 2L, 1L, 1L, 1L, 2L, 2L, 1L, 1L, 1L, 1L, 1L, 1L, 2L, 2L, 1L,
                3L, 1L, 2L, 1L, 1L, 2L, 1L, 1L, 1L, 2L, 2L, 2L, 1L, 2L, 6L, 2L,
                3L, 2L, 3L, 2L, 2L, 1L, 1L, 1L, 1L, 1L, 2L, 1L, 1L, 1L, 1L, 2L,
                1L, 2L, 2L, 1L, 2L, 3L, 4L, 2L, 2L),
              levels = c("Nothing in hand", "One pair", "Two pairs",
                         "Three of a kind", "Straight", "Flush", "Full house",
                         "Four of a kind", "Straight flush", "Royal flush"),
              class = c("ordered", "factor"))


new_S1 <-
    structure(c(1L, 2L, 3L, 4L, 4L, 1L, 1L, 2L, 3L, 4L, 1L, 2L, 1L,
                2L, 3L, 1L, 1L, 3L, 4L, 3L, 1L, 2L, 3L, 2L, 2L, 2L, 3L, 1L, 3L,
                2L, 3L, 4L, 1L, 3L, 3L, 4L, 2L, 4L, 2L, 2L, 2L, 2L, 2L, 3L, 4L,
                1L, 2L, 1L, 4L, 4L, 1L, 1L, 4L, 4L, 2L, 4L, 2L, 4L, 1L, 1L, 4L,
                3L, 1L, 1L, 2L, 1L, 1L, 4L, 2L, 3L, 4L, 4L, 4L, 4L, 2L, 1L, 3L,
                2L, 2L, 2L, 4L, 2L, 1L, 2L, 2L, 2L, 1L, 2L, 2L, 1L, 2L, 1L, 2L,
                4L, 3L, 3L, 3L, 1L, 3L, 2L),
              levels = c("Hearts", "Spades", "Diamonds", "Clubs"),
              class  = "factor")

new_LOGICAL_CHAR <-
    c(TRUE, TRUE, NA, NA, FALSE, FALSE, FALSE, FALSE, FALSE, TRUE,
      FALSE, TRUE, TRUE, TRUE, FALSE, TRUE, TRUE, TRUE, TRUE, FALSE,
      FALSE, TRUE, FALSE, TRUE, TRUE, FALSE, FALSE, FALSE, TRUE, FALSE,
      FALSE, TRUE, FALSE, TRUE, TRUE, TRUE, FALSE, TRUE, TRUE, TRUE,
      FALSE, FALSE, FALSE, FALSE, TRUE, TRUE, TRUE, FALSE, FALSE, TRUE,
      FALSE, TRUE, FALSE, FALSE, TRUE, FALSE, TRUE, FALSE, FALSE, TRUE,
      TRUE, FALSE, TRUE, FALSE, FALSE, TRUE, TRUE, FALSE, TRUE, FALSE,
      FALSE, TRUE, TRUE, FALSE, TRUE, TRUE, TRUE, TRUE, TRUE, FALSE,
      FALSE, TRUE, TRUE, FALSE, TRUE, FALSE, TRUE, FALSE, TRUE, TRUE,
      TRUE, TRUE, FALSE, FALSE, TRUE, TRUE, TRUE, TRUE, FALSE, TRUE
    )




# Tests -------------------------------------------------------------------

stopifnot(
    "Column 'S1' should be of class 'integer', but isn't." =
        class(my_poker$S1)    == "integer",
    "Column 'CLASS' should be of class 'integer', but isn't." =
        class(my_poker$CLASS) == "integer",
    "Column 'LOGICAL_CHAR' should be of class 'character', but isn't." =
        class(my_poker$LOGICAL_CHAR) == "character",

    "Raw 'S1' has unexpected contents." =
        identical(my_poker$S1, orig_S1),
    "Raw 'CLASS' has unexpected contents." =
        identical(my_poker$CLASS, orig_CLASS),
    "Raw 'LOGICAL_CHAR' has unexpected contents." =
        identical(my_poker$LOGICAL_CHAR, orig_LOGICAL_CHAR)
)



tsv2label::recode_with_dictionary(my_poker, dict_path)

stopifnot(
    "Factorised column 'S1' should be of class 'factor', but isn't." =
        class(my_poker$S1)    == "factor",
    "Factorised column 'CLASS' should be of class 'ordered factor', but isn't." =
        class(my_poker$CLASS) == c("ordered", "factor"),
    "Converted column 'LOGICAL_CHAR' should be of class 'logical', but isn't." =
        class(my_poker$LOGICAL_CHAR) == "logical",

    "Factorised 'S1' has unexpected contents." =
        identical(my_poker$S1, new_S1),
    "Factorised 'CLASS' has unexpected contents." =
        identical(my_poker$CLASS, new_CLASS),
    "Converted 'LOGICAL_CHAR' has unexpected contents." =
        identical(my_poker$LOGICAL_CHAR, new_LOGICAL_CHAR)
)



run_nested <- function(df) {
    tsv2label::recode_with_dictionary(df, dict_path)
}

for(i in 1) {
    nested_poker <- poker
    run_nested(nested_poker)
}



# Clean up ----------------------------------------------------------------

rm(my_poker, dict_path,
   orig_S1, orig_CLASS, orig_LOGICAL_CHAR,
   new_S1, new_CLASS, new_LOGICAL_CHAR)
