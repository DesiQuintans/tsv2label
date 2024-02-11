

# Setup -------------------------------------------------------------------

library(tsv2label)

my_poker <- tsv2label::poker  # The test data
dict_path <- system.file("extdata/poker", package = "tsv2label")  # The dictionary

# deparse(colnames(my_poker)) |> clipr::write_clip()

# I set these up manually on purpose.
orig_colnames <-
    c("ID", "S1", "C1", "S2", "C2", "S3", "C3", "S4", "C4", "S5",
      "C5", "CLASS", "CAT", "COIN FLIP", "LIST_COL", "LOGICAL_CHAR",
      "LOGICAL_INT", "yesno")


new_colnames <-
    c("random_int", "c1_suit", "c1_rank", "c2_suit", "c2_rank", "c3_suit",
      "c3_rank", "c4_suit", "c4_rank", "c5_suit", "c5_rank", "hand_from_cards",
      "CAT", "coin_flip", "LIST_COL", "LOGICAL_CHAR", "LOGICAL_INT",
      "yesno")




# Tests -------------------------------------------------------------------

stopifnot(
    "Raw dataset's columns do not match expected names." =
        colnames(my_poker) == orig_colnames
)



tsv2label::rename_with_dictionary(my_poker, dict_path)

stopifnot(
    "Renamed dataset's columns do not match expected names." =
        colnames(my_poker) == new_colnames
)



tsv2label::revert_colnames(my_poker, system.file("extdata/poker", package = "tsv2label"))

stopifnot(
    "Dataset's column names did not revert to their expected original values." =
        colnames(my_poker) == orig_colnames
)



# Clean up ----------------------------------------------------------------

rm(my_poker, dict_path, orig_colnames, new_colnames)
