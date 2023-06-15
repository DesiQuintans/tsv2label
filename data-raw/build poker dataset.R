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

poker$LIST_COL <- replicate(100, list(sample(letters, 3)))

usethis::use_data(poker, overwrite = TRUE)
