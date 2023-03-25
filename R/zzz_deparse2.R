
# Deparse an expression into a single character string
#
# This function is used when converting vectors into deparsed text.
# deparse() and even deparse1() always cuts line lengths, even at a maximum of
# 500 chars. This inserts breaks into the string, which stops it from being
# parsed as R code again by str2lang(). This gets it back into a single string.
#
# @param x (Expression) An expression.
#
# @return Deparsed code as a string.
#
# @example deparse2(month.abb)
deparse2 <- function(x) {
    gsub("\\s+", " ", paste0(deparse(x), collapse = ""))
}
