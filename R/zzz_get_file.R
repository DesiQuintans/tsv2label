
# Get a tab-delimited file from a directory or zip.
#
# If the file is in a zip file, it unzips it to the tempdir(). It overwrites
# any existing copies there.
#
# ENSURES:
#   1. The file exists in the dir/zip
#
# RETURNS:
#   A dataframe.
get_file <- function(path, name) {
    if (grepl("\\.zip$", x = path, ignore.case = TRUE)) {
        # File is supposed to be inside a zip file.
        if (name %in% utils::unzip(path, list = TRUE)$Name == FALSE) {
            stop(stop_fmt(sprintf("'%s' was not found in zip file '%s'.", name, path)))
        }

        fpath <- utils::unzip(path, files = name, exdir = tempdir())
    } else {
        # File is supposed to be inside a directory.
        if (file.exists(file.path(path, name)) == FALSE) {
            stop(stop_fmt("'", fpath, "' does not exist, or is inaccessible."))
        }

        fpath <- file.path(path, name)
    }

    # Note that all columns returned by get_file are Character.
    utils::read.delim(fpath, colClasses = c("character"))
}
