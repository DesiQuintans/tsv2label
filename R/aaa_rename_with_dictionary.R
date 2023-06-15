
# This is a function factory because using new or old colnames is the same basic
# code, but with the old and new names simply swapped around.
closure.tsv_to_colnames <- function(orig_to_new) {
    function(df, path) {
        df_char <- deparse(substitute(df))

        flist <- list_label_files(path)
        index_tsv <- get_file(path, flist["index"])[, c("name", "rename")]

        if (orig_to_new == TRUE) {
            colnames(index_tsv) <- c("past_name", "future_name")
        } else {
            colnames(index_tsv) <- c("future_name", "past_name")
        }

        # This should only affect columns that are actually in the dataframe, in
        # case people choose to 'pre-name' columns that don't exist yet.
        index_tsv <- index_tsv[index_tsv$past_name %in% colnames(df), ]

        # This should also only be applied if the `rename` column has been filled.
        index_tsv <- index_tsv[index_tsv$future_name != "", ]

        # Need to rename columns *by name*, not by order.
        # colnames(df)[colnames(df) == "colname"] = "future_name"
        code <- sprintf('colnames(%1$s)[colnames(%1$s) == "%2$s"] = "%3$s"',
                        df_char, index_tsv$past_name, index_tsv$future_name)

        global_eval(code)

        message(msg_fmt("head(colnames(", df_char ,")):"))
        cat(" ", global_eval(sprintf("head(colnames(%s))", df_char)))
    }
}


#' Rename columns using a data dictionary
#'
#' Datasets from foreign analysis packages sometimes impose character length
#' limits on their variables, which leads to variable names that can be obtuse.
#' This function lets you rename columns (and undo that renaming) using a data
#' dictionary.
#'
#' Only columns that are an exact match will be renamed, all others will be left
#' alone; this means that you can 'pre-name' a column that doesn't exist in your
#' dataframe yet, create that column, and then name it from the dictionary
#' afterwards.
#'
#' @param df (Dataframe) A dataframe whose columns you want to rename.
#' @param path (Character) Path to the dataset's dictionary files, which is
#'   either a folder or a .zip file. See [expected_files] for more info.
#'
#' @return Mutates `df` in-place in the global environment.
#'
#' @name rename_columns
#'
#' @examples
#' \donttest{
#' # An unlabelled dataset that is built-into this package.
#' my_poker <- poker
#'
#' # system.file() gives the path to a dictionary for this dataset, which is
#' # also built-into this package.
#' rename_with_dictionary(my_poker, system.file("extdata/poker", package = "tsv2label"))
#'
#' ##  head(colnames(my_poker)):
#' ##  random_int c1_suit c1_rank c2_suit c2_rank c3_suit
#'
#' revert_colnames(my_poker, system.file("extdata/poker", package = "tsv2label"))
#'
#' ##  head(colnames(my_poker)):
#' ##  ID S1 C1 S2 C2 S3
#' }
#' @md
NULL

#' @describeIn rename_columns Replace original column names with new ones.
#' @export
rename_with_dictionary  <- closure.tsv_to_colnames(orig_to_new = TRUE)

#' @describeIn rename_columns Revert column names to original names.
#' @export
revert_colnames <- closure.tsv_to_colnames(orig_to_new = FALSE)
