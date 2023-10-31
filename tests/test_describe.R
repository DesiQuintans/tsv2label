

# Setup -------------------------------------------------------------------

my_poker <- tsv2label::poker  # The test data
dict_path <- system.file("extdata/poker", package = "tsv2label")  # The dictionary



# Tests -------------------------------------------------------------------

stopifnot(
    "Column 'C3' has an unexpected label in the raw dataset." =
        is.null(attr(my_poker$C3, "label"))
)



tsv2label::describe_with_dictionary(my_poker, dict_path)

stopifnot(
    "Column 'C3' was not correctly labelled." =
        attr(my_poker$C3, "label") == "Rank of card #3"
)



# Clean up ----------------------------------------------------------------

rm(my_poker, dict_path)
