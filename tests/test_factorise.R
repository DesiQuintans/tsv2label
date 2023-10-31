

# Setup -------------------------------------------------------------------

my_poker <- tsv2label::poker  # The test data
dict_path <- system.file("extdata/poker", package = "tsv2label")  # The dictionary

# deparse(my_poker$S1) |> clipr::write_clip()

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




# Tests -------------------------------------------------------------------

stopifnot(
    "Column 'S1' should be of class 'integer', but isn't." =
        class(my_poker$S1)    == "integer",
    "Column 'CLASS' should be of class 'integer', but isn't." =
        class(my_poker$CLASS) == "integer",

    "Raw 'S1' has unexpected contents." =
        my_poker$S1    == orig_S1,
    "Raw 'CLASS' has unexpected contents." =
        my_poker$CLASS == orig_CLASS
)



tsv2label::factorise_with_dictionary(my_poker, dict_path)

stopifnot(
    "Factorised column 'S1' should be of class 'factor', but isn't." =
        class(my_poker$S1)    == "factor",
    "Factorised column 'CLASS' should be of class 'ordered factor', but isn't." =
        class(my_poker$CLASS) == c("ordered", "factor"),

    "Factorised 'S1' has unexpected contents." =
        my_poker$S1    == new_S1,
    "Factorised 'CLASS' has unexpected contents." =
        my_poker$CLASS == new_CLASS
)



# Clean up ----------------------------------------------------------------

rm(my_poker, dict_path, orig_S1, orig_CLASS, new_S1, new_CLASS)
