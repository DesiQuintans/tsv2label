
#' Convert variables to Factors with a data dictionary
#'
#' Datasets imported into R from foreign analysis packages (SPSS, SAS, MATLAB)
#' often come with "value labels" which, for example, tell you that a `0` in a
#' column actually means `"Travelling locally"` or something. R represents such
#' categorical data as Factors. Some other R packages put these labels into an
#' attribute called `"labels"` (note plural) as a temporary measure until you
#' decide to convert them into factors. _This_ package goes straight to
#' converting them so that they're ready to use.
#'
#' @param df (Dataframe) A dataframe to label.
#' @param path (Character) Path to the dataset's dictionary files, which is
#'      either a folder or a .zip file. See [expected_files] for more info.
#'
#' @return Mutates `df` in-place in the global environment.
#' @export
#'
#' @examples
#' \donttest{
#' # An unlabelled dataset that is built-into this package.
#' my_poker <- poker
#'
#' # system.file() gives the path to a dictionary for this dataset that is also
#' # built-into this package.
#' factorise_with_dictionary(my_poker, system.file("extdata/poker", package = "tsv2label"))
#'
#' ##  Peeking at 'levels(my_poker[["COIN FLIP"]])', built from
#' ##  'values coin flip':
#' ##  Heads, Tails
#' ##
#' ##  Peeking at 'levels(my_poker[["CLASS"]])', built from
#' ##  'values_hands':
#' ##  Nothing in hand, One pair, Two pairs, Three of a kind,
#' ##  Straight, Flush, Full house, Four of a kind, Straight
#' ##  flush, Royal flush
#' ##
#' ##  Peeking at 'levels(my_poker[["C1"]])', built from
#' ##  'values_ranks':
#' ##  Ace, 2, 3, 4, 5, 6, 7, 8, 9, 10, Jack, Queen, King
#' ##
#' ##  Peeking at 'levels(my_poker[["S1"]])', built from
#' ##  'values_suits':
#' ##  Hearts, Spades, Diamonds, Clubs
#' }
#' @md
factorise_with_dictionary <- function(df, path) {
    # Value labels are basically hold-overs from other analysis packages, and
    # are useless in R until converted into factors.

    df_char <- deparse(substitute(df))

    flist <- list_label_files(path)
    index_tsv <- get_file(path, flist["index"])
    index_tsv <- index_tsv[index_tsv$name %in% colnames(df), ]

    # Get columns that have factor files associated with them
    val_flist <- index_tsv[, c("name", "factor_file")]
    val_flist <- val_flist[val_flist$factor_file != "", ]

    # factor_file might have been given with file extensions. Remove them and
    # lowercase them so that they match up with the names of flist.
    val_flist$factor_file <- tolower(gsub("(\\.(tsv|txt))+$", "", val_flist$factor_file))

    # It's likely that several columns will use the same value file; I should
    # only load each file once, and label all of those columns together.
    # `each_file` is a named list:
    #   name     = a factor file
    #   contents = character vector of column names using this value file
    each_file <- tapply(val_flist$name, val_flist$factor_file, unique)

    for (i in seq_along(each_file)) {
        factor_file <- names(each_file[i])                      # The factor file
        cols        <- unlist(each_file[i], use.names = FALSE)  # The columns

        # 1. Convert the receiving columns to Character, to match the value file
        #    which is always read in as Character.
        # NOTE: Whatever types these columns started in, the fact that they are
        # labelled means that they are categorical and therefore their true type
        # in R should be Factor, which is what this function will turn them into.
        global_eval(sprintf('%1$s[["%2$s"]] <- as.character(%1$s[["%2$s"]])',
                            df_char, cols))

        # 2. Get the value file
        vfile      <- get_file(path, flist[factor_file])

        # Should the factor be an ordered one?
        if (is.null(vfile$ordered)) {
            # The ordered column doesn't exist, so make an unordered factor
            is_ordered <- FALSE
        } else {
            is_ordered <- any(c("true", "t", "yes", "y", "1") %in% tolower(vfile$ordered))
        }

        # Which levels are not excluded from the final factor?
        if (is.null(vfile$exclude) == FALSE) {
            vfile <- vfile[!(tolower(vfile$exclude) %in% c("true", "t", "yes", "y", "1")), ]
        }

        # 3. Turn the columns into Factors.
        code <- sprintf('%1$s[["%2$s"]] <- factor(%1$s[["%2$s"]], levels = %3$s, labels = %4$s, ordered = %5$s)',
                        df_char, cols, deparse2(vfile$levels), deparse2(vfile$labels),
                        is_ordered)

        global_eval(code)
    }

    # Preview the change
    # Here's up to 6 columns, one from each value file.
    x <- utils::head(sapply(each_file, utils::head, 1))

    for (i in seq_along(x)) {
        message(msg_fmt(
            sprintf("Peeking at 'levels(%s[[\"%s\"]])', built from '%s':",
                    df_char, x[i], names(x[i]))
            ))
        cat(msg_fmt(paste(global_eval(sprintf('levels(%s[["%s"]])', df_char, x[i])), collapse = ", ")))
        cat("\n\n")
    }
}

#' @rdname factorise_with_dictionary
factorize_with_dictionary <- factorise_with_dictionary
