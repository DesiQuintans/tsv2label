# Formats messages so that they wrap nicely in the console and are indented
# and/or exdented for easier reading.
wrap_console <- function(exdent, indent = 0) {
    # exdent is how subsequent lines of the message are set to the right.
    # It should be the same length as the banner. For example, "Error: " is
    # 7 chars, so the exdent should be 7.

    function(...) {
        strwrap(paste0(...), prefix = "\n", initial = "",
                exdent = exdent, indent = indent)
    }
}

stop_fmt <- wrap_console(7)
warn_fmt <- wrap_console(4, 4)
msg_fmt  <- wrap_console(2, 2)
