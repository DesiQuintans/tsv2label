
# Converter: Factor with levels No and Yes.
#
# @param vec (Vector) A vector. Will be coerced to Character.
# @param strict (Logical) If `FALSE`, exits early with a more permissive result.
#
# @return A Logical vector.
#
# @examples
# test <-
#     c("apple",  "1",   NA, "fAlSe", "maybe", "yes", "TRUE",  NA,  0)
#
# conv_noyes(test, strict = TRUE)
# # [1]    <NA>   Yes  <NA>       No     <NA>    Yes     Yes  <NA> No
# # Levels: No Yes
#
# conv_yesno(test, strict = FALSE)
# # [1]      No   Yes  <NA>       No       No    Yes     Yes  <NA> No
# # Levels: Yes No
conv_noyes <- function(vec, strict = TRUE) {
    result <- conv_truefalse(vec, strict)

    factor(result,
           levels = c(FALSE, TRUE),
           labels = c("No", "Yes"))
}



# As above, but with the levels flipped, e.g. for modelling purposes.
conv_yesno <- function(vec, strict = TRUE) {
    result <- conv_truefalse(vec, strict)

    factor(result,
           levels = c(TRUE, FALSE),
           labels = c("Yes", "No"))
}
