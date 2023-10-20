
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
#' Factorising from a dictionary can produce a large number of unused factor
#' levels, e.g. converting `country_of_residence` to a factor using a dictionary
#' of hundreds of countries, but your dataset only contains people from Australia.
#' Use the base function [droplevels()] to remove unused levels (see Examples).
#'
#' @param df (Dataframe) A dataframe to label.
#' @param path (Character) Path to the dataset's dictionary files, which is
#'      either a folder or a .zip file. See [expected_files] for more info.
#'
#' @return Mutates `df` in-place in the global environment.
#' @export
#'
#' @seealso [droplevels()]
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
#' ##  (1/4)  Using 'values_flip' for COIN FLIP.
#' ##  (2/4)  Using 'values_hands' for CLASS.
#' ##  (3/4)  Using 'values_ranks' for C1, C2, C3, C4, C5.
#' ##  (4/4)  Using 'values_suits' for S1, S2, S3, S4, S5.
#' ##
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
#'
#' # Drop all unused levels from every column of a dataframe
#' my_poker <- droplevels(my_poker)
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
    val_flist <- val_flist[trimws(val_flist$factor_file) != "", ]

    # factor_file might have been given with file extensions. Remove them and
    # lowercase them so that they match up with the names of flist.
    val_flist$factor_file <- tolower(gsub("(\\.(tsv|txt))+$", "", val_flist$factor_file))

    # It's likely that several columns will use the same value file; I should
    # only load each file once, and label all of those columns together.
    # `each_file` is a named list:
    #   name     = a factor file
    #   contents = character vector of column names using this value file
    each_file <- tapply(val_flist$name, val_flist$factor_file, unique)

    # Variables used for the status updates
    num_factorfiles <- length(each_file)
    count_width <- nchar(num_factorfiles)

    # "  (  1/100)    Using 'my_factor_file' for col1, col2, col3."
    message_str <- paste0("  (%0", count_width, "i/", num_factorfiles, ")  Using '%s' for %s.")

    for (i in seq_along(each_file)) {
        factor_file <- names(each_file[i])                      # The factor file
        cols        <- unlist(each_file[i], use.names = FALSE)  # The columns

        # 0. Tell the user which file is being applied (so that they know something
        # is happening).
        message(sprintf(message_str, i, factor_file, paste(cols, collapse = ", ")))

        # 1. Convert the receiving columns to Character, to match the value file
        #    which is always read in as Character. Also trim whitespace from them.
        # NOTE: Whatever types these columns started in, the fact that they are
        # labelled means that they are categorical and therefore their true type
        # in R should be Factor, which is what this function will turn them into.
        global_eval(sprintf('%1$s[["%2$s"]] <- trimws(as.character(%1$s[["%2$s"]]))',
                            df_char, cols))

        # 2. Get the value file
        vfile <- get_file(path, flist[factor_file])
        vfile <- as.data.frame(lapply(vfile, trimws))  # as.data.frame() is important for rowwise filtering below.

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

    cat("\n")

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
