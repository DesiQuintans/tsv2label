
#' Add descriptions to variables using a data dictionary
#'
#' Variable descriptions (the attribute called `"label"`) are used by lots of
#' R packages to add functionality. For example, RStudio can display labels in
#' [View()], the `gtsummary` package uses the label attribute to name
#' variables in its output tables where possible, and the `siftr` package allows
#' you to search the labels to find variables in large datasets.
#'
#' @param df (Dataframe) A dataframe to label.
#' @param path (Character) Path to the dataset's dictionary files, which is
#'      either a folder or a .zip file. See [expected_files] for more info.
#' @param up (Integer) The number of environments to step back in, determining
#'   where this function will be evaluated. See [parent.frame()] for details.
#'   The default value of `up = 2` is usually appropriate.
#'
#' @return Mutates `df` in-place in the specified environment.
#' @export
#'
#' @examples
#' \donttest{
#' # An unlabelled dataset that is built-into this package.
#' my_poker <- poker
#'
#' # system.file() gives the path to a dictionary for this dataset, which is also
#' # built-into this package.
#' describe_with_dictionary(my_poker, system.file("extdata/poker", package = "tsv2label"))
#'
#' ##  head() of 'label' attribute:
#' ##  ID Some random integers.
#' ##  S1 Suit of card #1
#' ##  C1 Rank of card #1
#' ##  S2 Suit of card #2
#' ##  C2 Rank of card #2
#' ##  S3 Suit of card #3
#' }
#' @md
describe_with_dictionary <- function(df, path, quiet = FALSE, up = 2) {
    df_char <- deparse(substitute(df))

    # 1. Get the filenames in the label directory.
    flist <- list_label_files(path)

    # 2. Get the index.
    index_tsv <- get_file(path, flist["index"])

    # 3. This should only affect columns that are actually in the dataframe.
    index_tsv <- index_tsv[index_tsv$name %in% colnames(df), ]

    # 4. This should only affect columns that have descriptions.
    index_tsv <- index_tsv[index_tsv$description != "", ]

    # 5. Write code
    # attr(df[["col"]], "label") <- "new label"
    # `[[` is used to handle non-syntactic names.
    # Note that it must be `[[` and not `[` in order to apply the attribute to
    # the underlying vector.
    code <- sprintf('attr(%s[["%s"]], "label") <- "%s"',
                    df_char, index_tsv$name, index_tsv$description)

    # 6. Evaluate that code in the environment above this one.
    eval_above(code, up = up)


    if (quiet == FALSE) {
        cat(" ", eval_above(sprintf('tsv2label:::display_attr(%s, "label")', df_char), up = up))
        cat("\n\n")
    }
}
