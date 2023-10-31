# This script defines the poker hand dataset that
# is included with the package.

poker <-
    read.csv("data-raw/poker_hand.csv",
             colClasses = c("integer",
                            "integer",
                            "integer",
                            "integer",
                            "integer",
                            "integer",
                            "integer",
                            "integer",
                            "integer",
                            "integer",
                            "integer",
                            "integer",
                            "character",
                            "logical"),
             check.names = FALSE)

set.seed(12345)
poker$LIST_COL <- replicate(100, list(sample(letters, 3)))


set.seed(12345)

truthy <- c("y", "Y", "yes", "Yes", "YES",
            "t", "T", "true", "True", "TRUE")

falsy <- c("n", "N", "no", "No", "NO",
           "f", "F", "false", "False", "FALSE")

poker$LOGICAL_CHAR <- c("t", "YES", NA_character_, "apple", "FaLsE",
                        sample(c(truthy, falsy), size = 95, replace = TRUE))

set.seed(12345)
poker$LOGICAL_INT <- c(0, NA_integer_, 1, 2, -1,
                       sample(c(-2:2, NA_integer_), size = 95, replace = TRUE))


usethis::use_data(poker, overwrite = TRUE)
