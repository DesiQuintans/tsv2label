
# Prints a preview of an attribute.
display_attr <- function(df, which) {
    res <- sapply(df, attr, which = which)
    # I probably have to filter out empty values here.
    res <- sprintf("%s    %s\n", names(res), unname(res))

    message(msg_fmt("head() of '", which, "' attribute:"))
    cat(msg_fmt(utils::head(res)))
}
