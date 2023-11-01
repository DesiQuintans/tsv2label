
# Converter: Returns TRUE, FALSE, and NA.
#
# This function is deliberately over-wrought for safety.
#
# When running in `strict = TRUE`:
#   Only returns TRUEs and FALSEs for recognised truthy and falsy values, and
#   returns NA for everything else, including unrecognised values and existing NAs.
#
# When running in `strict = FALSE`:
#   Returns TRUEs for recognised truthy values, returns FALSE for everything else
#   except NAs (which remain NA).
#
# Note that both cases are stricter than the `%in%` operator, which
# evaluates `c(TRUE, FALSE, NA) %in% TRUE` as "TRUE, FALSE, FALSE".
#
# @param vec (Vector) A vector. Will be coerced to Character.
# @param strict (Logical) If FALSE, exits early with a more permissive result.
#
# @return A Logical vector.
#
# @examples
# test <-
#     c("apple",  "1",   NA, "fAlSe", "maybe", "yes", "TRUE", NA,    0)
#
# conv_truefalse(test, strict = TRUE)
# [1]        NA  TRUE    NA    FALSE       NA   TRUE   TRUE   NA FALSE
#
# conv_truefalse(test, strict = FALSE)
# [1]     FALSE  TRUE    NA    FALSE    FALSE   TRUE   TRUE   NA FALSE
conv_truefalse <- function(vec, strict = TRUE) {
    chr <- trimws(tolower(as.character(vec)))

    true_vals <- chr %in% c("1",
                            "y",
                            "yes",
                            "t",
                            "true")

    if (strict == FALSE) {
        # An early exit here means simply applying NAs and returning the truthy matches.
        true_vals[which(is.na(vec))] <- NA
        return(true_vals)
    }

    false_vals <- chr %in% c("0",
                             "n",
                             "no",
                             "f",
                             "false")

    result <- rep(NA, length(vec))  # In the strict mode, NA is the default state for safety.
    result[which(true_vals)]  <- TRUE
    result[which(false_vals)] <- FALSE

    return(result)
}
