
# Evaluate a character vector of code in the environment above this one (up to .Globalenv)
#
# By far the cheapest approach for labelling large dataframes:
#
# bigiris <- sample(iris, 6e6, replace = TRUE)
#
#   expression                           `itr/sec` mem_alloc `gc/sec` n_itr  n_gc
#   <bch:expr>                               <dbl> <bch:byt>    <dbl> <int> <dbl>
# 1 labelled::var_label() in .Globalenv      0.957   723.2MB     1.91     1     2
# 2 labelled::set_variable_labels()          0.715   677.4MB     1.43     1     2
# 3 attr(df, "label") in .Globalenv        796.       72.6KB     0      399     0
#
# RETURNS:
#   Side-effect (mutates global state)
#
# EXAMPLE:
#   eval_above("head(iris)", 1)
eval_above <- function(code_chr, up) {
    eval.parent(parse(text = code_chr), n = up)
}
