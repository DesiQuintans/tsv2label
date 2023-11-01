
#' Recode variables with a data dictionary
#'
#' @description
#' 'Recoding a variable' means re-interpreting it from its original data type
#' (e.g. `"Yes"`s and `"No"`s) into a different type that is appropriate for
#' analysis in R (e.g. `TRUE` and `FALSE`, or a Factor). This can be done in
#' two ways:
#'
#' 1. A **mapping spreadsheet** can be used, which defines how the unique values
#'    of the variable are assigned to Factor levels, just like [factor()].
#' 2. A **converter** can be used. Converters are built-in mapping tables that can
#'    convert to Factor and Logical for common use-cases. For example, the
#'    `<truefalse>` converter recodes a variable into Logical. See 'Details' for
#'    a list of accepted converters.
#'
#' @details
#' Recoding with a mapping spreadsheet can produce a large number of unused factor
#' levels, e.g. converting `country_of_residence` to a factor using a dictionary
#' of hundreds of countries, but your dataset only contains people from Australia.
#' Use the base function [droplevels()] to remove unused levels (see 'Examples').
#'
#' ## Accepted converters
#'
#' These converters work on 'truthy' and 'falsy' values, ignoring case. 'Truthy'
#' values are `{1, y, yes, t, true}`. 'Falsy' values are `{0, n, no, f, false}`.
#'
#' - **`<truefalse>`**      : Converts truthy values to `TRUE`, falsy values to
#'   `FALSE`, everything else (including `NA`) to `NA`.
#' - **`<truefalse-lazy>`** : Converts truthy values to `TRUE` and everything
#'   else to `FALSE`, but preserves `NA` as `NA`.
#'
#' - **`<yesno>`**          : Converts truthy values to factor level `"Yes"`,
#'   falsy values to factor level `"No"`, and everything else (including `NA`)
#'   to `NA`. `"Yes"` is the first factor level.
#' - **`<noyes>`**          : Same as above, but with `"No"` as the first factor level.
#'
#' - **`<yesno-lazy>`**     : Converts truthy values to factor level `"Yes"` and
#'   everything else to factor level `"No"`, but preserves `NA` as `NA`. `"Yes"`
#'   is the first factor level.
#' - **`<noyes-lazy>`**     : Same as above, but with `"No"` as the first factor level.
#'
#'
#' @param df (Dataframe) A dataframe to label.
#' @param path (Character) Path to the dataset's dictionary files, which is
#'      either a folder or a .zip file. See [expected_files] for more info.
#' @param up (Integer) The number of environments to step back in, determining
#'   where this function will be evaluated. See [parent.frame()] for details.
#'   The default value of `up = 2` is usually appropriate.
#'
#'
#' @return Mutates `df` in-place in the specified environment.
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
#' recode_with_dictionary(my_poker, system.file("extdata/poker", package = "tsv2label"))
#'
#' ##  (1/6)  Using '<noyes-lazy>' for LOGICAL_INT.
#' ##  (2/6)  Using '<truefalse>' for LOGICAL_CHAR, yesno.
#' ##  (3/6)  Using 'values_flip' for COIN FLIP.
#' ##  (4/6)  Using 'values_hands' for CLASS.
#' ##  (5/6)  Using 'values_ranks' for C1, C2, C3, C4, C5.
#' ##  (6/6)  Using 'values_suits' for S1, S2, S3, S4, S5.
#' ##
#' ##  Peeking at 'levels(my_poker[["LOGICAL_INT"]])', built from
#' ##  '<noyes-lazy>':
#' ##  No, Yes
#' ##
#' ##  Peeking at 'unique(my_poker[["LOGICAL_CHAR"]])', built from
#' ##  '<truefalse>':
#' ##  TRUE, NA, FALSE
#' ##
#' ##  Peeking at 'levels(my_poker[["COIN FLIP"]])', built from
#' ##  'values_flip':
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
recode_with_dictionary <- function(df, path, up = 2) {
    df_char <- deparse(substitute(df))


    # 1. Identify columns to be recoded ---------------------------------------

    # a. From the index file, get the columns that need to be recoded.
    flist <- list_label_files(path)
    index_tsv <- get_file(path, flist["index"])
    index_tsv <- index_tsv[index_tsv$name %in% colnames(df), ]
    index_tsv <- index_tsv[, c("name", "recode_with")]

    index_tsv$recode_with <- gsub("(\\.(tsv|txt))+$", "", tolower(trimws(index_tsv$recode_with)))
    index_tsv <- index_tsv[index_tsv$recode_with != "", ]

    # b. Flag columns that must be recoded with a converter.
    # Converters start and end with <>, which can't be used in Windows filenames.
    index_tsv$is_converter <- grepl("^<.+>$", index_tsv$recode_with)  # Faster and cheaper than substr()ing both sides.

    # c. Split the columns into two sets: One for converters and one for factor definition files.
    to_convert   <- index_tsv[index_tsv$is_converter == TRUE, ]
    to_factorise <- index_tsv[index_tsv$is_converter == FALSE, ]


    # 2. Replace converter tags with code -------------------------------------

    # Build function calls from converter names.
    # "iris$Species <- conv_yesno(iris$Species, strict = TRUE)"
    recognised_converters <- c(
        `<truefalse>`      = '%1$s[["%2$s"]] <- tsv2label:::conv_truefalse(%1$s[["%2$s"]], strict = TRUE)',
        `<truefalse-lazy>` = '%1$s[["%2$s"]] <- tsv2label:::conv_truefalse(%1$s[["%2$s"]], strict = FALSE)',

        `<yesno>`          = '%1$s[["%2$s"]] <- tsv2label:::conv_yesno(%1$s[["%2$s"]], strict = TRUE)',
        `<yesno-lazy>`     = '%1$s[["%2$s"]] <- tsv2label:::conv_yesno(%1$s[["%2$s"]], strict = FALSE)',

        `<noyes>`          = '%1$s[["%2$s"]] <- tsv2label:::conv_noyes(%1$s[["%2$s"]], strict = TRUE)',
        `<noyes-lazy>`     = '%1$s[["%2$s"]] <- tsv2label:::conv_noyes(%1$s[["%2$s"]], strict = FALSE)'
    )


    # 3. Quality checking -----------------------------------------------------

    # Are there any missing factor definition files?
    missing_files <- unique(to_factorise$recode_with[which(!(to_factorise$recode_with %in% names(flist)))])

    if (length(missing_files) > 0) {
        stop(
            sprintf("Missing file(s): \n    %s\n  These files exist in the dictionary: \n    %s.",
                    paste(missing_files, collapse = ", "),
                    paste(unique(flist), collapse = ", "))
        )
    }


    # Are there any unrecognised converter tags?
    missing_converters <- unique(to_convert$recode_with[which(is.na(to_convert$code))])

    if (length(missing_converters) > 0) {
        stop(
            sprintf("Invalid converter(s): \n    %s\n  Valid converters are: \n    %s.",
                    paste(missing_converters, collapse = ", "),
                    paste(unique(names(recognised_converters)), collapse = ", "))
        )
    }


    # 4. Style messages -------------------------------------------------------

    # Variables used for the status updates
    num_recodings <- length(unique(c(to_convert$recode_with, to_factorise$recode_with)))
    count_width <- nchar(num_recodings)

    # "  (  1/100)    Using '<my-converter>' for col1, col2, col3."
    # "  ( 10/100)    Using 'my_file' for col13."
    message_str <- paste0("  (%0", count_width, "i/", num_recodings, ")  Using '%s' for %s.")


    # 5. Apply converters -----------------------------------------------------

    # It's likely that several columns will use the same converter; I should
    # convert all of them together.
    # `each_converter` is a named list:
    #   the name = The converter's tag.
    #   contents = character vector of column names using this converter
    each_converter <- tapply(to_convert$name, to_convert$recode_with, unique)

    for (i in seq_along(each_converter)) {
        converter_tag  <- names(each_converter[i])
        converter_call <- recognised_converters[converter_tag]
        cols           <- unlist(each_converter[i], use.names = FALSE)

        # 0. Tell the user which converter is being applied (so that they know
        # something is happening).
        message(sprintf(message_str, i, converter_tag, paste(cols, collapse = ", ")))

        # 1. Run the code
        code <- sprintf(converter_call, df_char, cols)

        eval_above(code, up = up)
    }


    # 6. Apply factor definition files ----------------------------------------

    # It's likely that several columns will use the same value file; I should
    # only load each file once, and label all of those columns together.
    # `each_file` is a named list:
    #   name     = a factor file
    #   contents = character vector of column names using this value file
    each_file <- tapply(to_factorise$name, to_factorise$recode_with, unique)

    for (i in seq_along(each_file)) {
        recode_with <- names(each_file[i])                      # The definition file
        cols        <- unlist(each_file[i], use.names = FALSE)  # The columns

        # 0. Tell the user which file is being applied (so that they know something
        # is happening).
        message(sprintf(message_str, i + length(each_converter), recode_with, paste(cols, collapse = ", ")))

        # 1. Convert the receiving columns to Character, to match the value file
        #    which is always read in as Character. Also trim whitespace from them.
        # NOTE: Whatever types these columns started in, the fact that they are
        # labelled means that they are categorical and therefore their true type
        # in R should be Factor, which is what this function will turn them into.
        eval_above(sprintf('%1$s[["%2$s"]] <- trimws(as.character(%1$s[["%2$s"]]))',
                            df_char, cols), up = up)

        # 2. Get the value file
        vfile <- get_file(path, flist[recode_with])
        vfile <- as.data.frame(lapply(vfile, trimws))  # as.data.frame() is important for rowwise filtering below.

        # Check that the file contains the minimum columns: 'levels' and 'labels'.
        if (("levels" %in% colnames(vfile)) == FALSE) {
            stop("The file '", recode_with, "' does not have a column called 'levels'.")
        }

        if (("labels" %in% colnames(vfile)) == FALSE) {
            stop("The file '", recode_with, "' does not have a column called 'labels'.")
        }

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

        eval_above(code, up = up)
    }


    # 6. Preview the change ---------------------------------------------------

    # Here's up to 6 columns, one from each converter and definition file
    x <- utils::head(sapply(c(each_converter, each_file), utils::head, 1))

    cat("\n")

    for (i in seq_along(x)) {
        this_levels <- eval_above(sprintf('levels(%s[["%s"]])', df_char, x[i]), up = up)

        if (!is.null(this_levels)) {
            message(msg_fmt(
                sprintf("Peeking at 'levels(%s[[\"%s\"]])', built from '%s':",
                        df_char, x[i], names(x[i]))
            ))
            cat(msg_fmt(paste(this_levels, collapse = ", ")))
        } else {
            message(msg_fmt(
                sprintf("Peeking at 'unique(%s[[\"%s\"]])', built from '%s':",
                        df_char, x[i], names(x[i]))
            ))
            cat(msg_fmt(paste(eval_above(sprintf('unique(%s[["%s"]])', df_char, x[i]), up = up), collapse = ", ")))
        }

        cat("\n\n")
    }
}
