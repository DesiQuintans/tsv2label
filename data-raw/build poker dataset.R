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

usethis::use_data(poker, overwrite = TRUE)
