
# Lists files non-recursively in a directory or zip.
#
# ENSURES:
#   1. The path/zip exists, and that
#   2. It contains TSV or CSV files, and that
#   3. One of those files is index.tsv/index.txt.
#
# RETURNS:
#   A named Character vector of TSV and TXT files in that dir or zip.
list_label_files <- function(path) {
    if (file.exists(path) == FALSE) {
        stop(stop_fmt("'", path, "' does not exist, or is inaccessible."))
    }

    if (grepl("\\.zip$", x = path, ignore.case = TRUE)) {
        in_zip <- utils::unzip(path, list = TRUE)$Name
        flist  <- in_zip[grepl("\\.(tsv|txt)$", x = in_zip, ignore.case = TRUE)]
    } else {
        flist <- list.files(path, pattern = "(tsv|txt)$", ignore.case = TRUE,
                            recursive = FALSE)
    }

    if (length(flist) < 1) {
        stop(stop_fmt("'", path, "' does not contain any .tsv or .txt files."))
    }

    # Standardising the names to lower case here because it seems safer than
    # having to account for people getting capitalisation exactly right in their
    # index.tsv's 'value_file' column.
    names(flist) <- tolower(gsub("(\\.(tsv|txt))+$", "", flist))

    if ("index" %in% names(flist) == FALSE) {
        stop(stop_fmt("'", path, "' does not contain an 'index.tsv' or
                      'index.txt' file, which `tsv2label` needs. See
                      '?expected_files' for more information."))
    }

    return(flist)
}
