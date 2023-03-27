Labelling datasets using a data dictionary, with `tsv2label`
================
Desi Quintans
2023-03-27

# Installation

``` r
remotes::install_github("DesiQuintans/tsv2label")
# CRAN coming soon
```

``` r
library(tsv2label)
```

If you’ve ever tried to find your way through a dataset with cryptic
names and values, you’ve probably made a spreadsheet that had columns
like: 1) variable name, 2) what it contains, 3) what its types are,
especially if it looks like they are coding for something.

`tsv2label` lets you use such a spreadsheet to label, rename, and
factorise your dataset automatically; especially helpful if your dataset
is hundreds of columns wide.

It uses tab-delimited spreadsheets which are editable in Excel; easy to
assemble by copying and pasting from existing messy data dictionaries;
can be cleaned and reshaped with regular expressions; and can be tracked
and diffed with version control software.

![](data-raw/tsv2label.png)

------------------------------------------------------------------------

## What the package expects as a data dictionary

A data dictionary is a directory or .zip file with no subfolders, which
contains tab-delimited spreadsheets in either *.TSV* or *.TXT* format.

The Appendix below has the [formal definition of a
dictionary](#formal-definition-of-a-tsv2label-data-dictionary), but the
easiest way to understand how a data dictionary is shaped is by looking
at the one that is included with `tsv2label`. You can find where it is
installed on your computer by running:

``` r
library(tsv2label)

system.file("extdata/poker", package = "tsv2label")
```

### Index file

The central file is called `index`; it must always exist, and must be a
tab-delimited file in *.TSV* or *.TXT* format.

``` r
read.delim(system.file("extdata/poker/index.tsv", package = "tsv2label")) |>
  head()
```

    ##   name     rename                 description  factor_file
    ## 1   ID random_int A bunch of random integers.             
    ## 2   S1    c1_suit             Suit of card #1 values_suits
    ## 3   C1    c1_rank             Rank of card #1 values_ranks
    ## 4   S2    c2_suit             Suit of card #2 values_suits
    ## 5   C2    c2_rank             Rank of card #2 values_ranks
    ## 6   S3    c3_suit             Suit of card #3 values_suits

It must have these four columns, in any order:

1.  `name` is the name of a column/variable in your dataset.
2.  `rename` is what to rename the column. Leave it blank if unneeded.
3.  `description` is a human-readable description of what the variable
    is about.
4.  `factor_file` is used to convert categorical data into Factors. It
    has the filename (with or without file extension) of a spreadsheet
    in the same folder that describes how values are mapped to labels,
    e.g. postal codes to place names. Leave it blank if unneeded. As you
    can see, many variables can use the same `factor_file`.

Any other columns in the file will be ignored.

### Factor files

The factor files control how a variable is going to be converted to a
Factor type. What you name the file does not matter, as long as you
write its name exactly in the `index`’s `factor_file` fields.

A factor file look like this:

``` r
read.delim(system.file("extdata/poker/values_suits.tsv", package = "tsv2label")) |>
  head()
```

    ##   level    label ordered
    ## 1     1   Hearts   FALSE
    ## 2     2   Spades      NA
    ## 3     3 Diamonds      NA
    ## 4     4    Clubs      NA

This file has three columns:

1.  `level` contains the raw values in your dataset. It is used as the
    levels of the new factor.
2.  `label` contains the label to apply to each level.
3.  `ordered` controls whether this will be created as an ordered
    factor. An affirmative value (case-insensitive: `true`, `t`, `yes`,
    `y`, or `1`) in *any* cell of this column will make it an ordered
    factor.

These columns are named after their matching arguments in `factor()`:

``` r
str(factor)
```

    ## function (x = character(), levels, labels = levels, exclude = NA, ordered = is.ordered(x), 
    ##     nmax = NA)

------------------------------------------------------------------------

# Functions

`tsv2label` gives you four main functions:

| Function                              | Description                            |
|:--------------------------------------|:---------------------------------------|
| `factorise_with_dictionary(df, path)` | Convert variables to Factor            |
| `describe_with_dictionary(df, path)`  | Add descriptions (labels) to variables |
| `rename_with_dictionary(df, path)`    | Rename variables                       |
|                                       |                                        |
| `revert_colnames(df, path)`           | Return columns to their original names |

## Order of operations

When `factorise_with_dictionary()` converts variables to Factors, any
labels associated with them are lost. When `rename_with_dictionary()`
renames variables, `factorise_with_dictionary()` and
`describe_with_dictionary()` can no longer find and act on them.

This means that operations should be done in the order given above:
First factorising, then describing, then renaming. If needed,
`revert_colnames()` can undo a renaming.

------------------------------------------------------------------------

# Example: Describing the Poker Hands dataset

`tsv2label` ships with a built-in dataset called `poker`, which is a
subset of the [Poker
Hand](https://archive.ics.uci.edu/ml/datasets/Poker+Hand) dataset with
some added columns:

``` r
head(poker)
```

    ##   ID S1 C1 S2 C2 S3 C3 S4 C4 S5 C5 CLASS    CAT  FLIP
    ## 1  1  1 10  1 11  1 13  1 12  1  1     9  Socks FALSE
    ## 2  2  2 11  2 13  2 10  2 12  2  1     9   Fred FALSE
    ## 3  3  3 12  3 11  3 13  3 10  3  1     9 Fluffy  TRUE
    ## 4  4  4 10  4 11  4  1  4 13  4 12     9   Nala  TRUE
    ## 5  5  4  1  4 13  4 12  4 11  4 10     9   Cher  TRUE
    ## 6  6  1  2  1  4  1  5  1  3  1  6     8   Lily  TRUE

As shown before, `tsv2label` also ships with the data dictionary for
this dataset, in both .zip and folder forms:

``` r
list.files(system.file("extdata", package = "tsv2label"))
```

    ## [1] "poker"     "poker.zip"

``` r
list.files(system.file("extdata/poker", package = "tsv2label"))
```

    ## [1] "index.tsv"        "values_hands.tsv" "values_ranks.tsv" "values_suits.tsv"

``` r
index.tsv
```

    ##         name          rename                               description
    ## 1         ID      random_int               A bunch of random integers.
    ## 2         S1         c1_suit                           Suit of card #1
    ## 3         C1         c1_rank                           Rank of card #1
    ## 4         S2         c2_suit                           Suit of card #2
    ## 5         C2         c2_rank                           Rank of card #2
    ## 6         S3         c3_suit                           Suit of card #3
    ## 7         C3         c3_rank                           Rank of card #3
    ## 8         S4         c4_suit                           Suit of card #4
    ## 9         C4         c4_rank                           Rank of card #4
    ## 10        S5         c5_suit                           Suit of card #5
    ## 11        C5         c5_rank                           Rank of card #5
    ## 12     CLASS hand_from_cards         Poker hand formed by cards 1 to 5
    ## 13       CAT     random_cats        Randomly generated names for cats.
    ## 14      FLIP                          Results of a simulated coinflip.
    ## 15 not_exist                 This column doesn't exist in the dataset.
    ##     factor_file
    ## 1              
    ## 2  values_suits
    ## 3  values_ranks
    ## 4  values_suits
    ## 5  values_ranks
    ## 6  values_suits
    ## 7  values_ranks
    ## 8  values_suits
    ## 9  values_ranks
    ## 10 values_suits
    ## 11 values_ranks
    ## 12 values_hands
    ## 13             
    ## 14             
    ## 15

``` r
values_hands
```

    ##    level           label ordered
    ## 1      0 Nothing in hand    TRUE
    ## 2      1        One pair      NA
    ## 3      2       Two pairs      NA
    ## 4      3 Three of a kind      NA
    ## 5      4        Straight      NA
    ## 6      5           Flush      NA
    ## 7      6      Full house      NA
    ## 8      7  Four of a kind      NA
    ## 9      8  Straight flush      NA
    ## 10     9     Royal flush      NA

``` r
values_ranks
```

    ##    level label ordered
    ## 1      1   Ace   FALSE
    ## 2      2     2      NA
    ## 3      3     3      NA
    ## 4      4     4      NA
    ## 5      5     5      NA
    ## 6      6     6      NA
    ## 7      7     7      NA
    ## 8      8     8      NA
    ## 9      9     9      NA
    ## 10    10    10      NA
    ## 11    11  Jack      NA
    ## 12    12 Queen      NA
    ## 13    13  King      NA

``` r
values_suits
```

    ##   level    label ordered
    ## 1     1   Hearts   FALSE
    ## 2     2   Spades      NA
    ## 3     3 Diamonds      NA
    ## 4     4    Clubs      NA

### Preparation

Let’s make a copy of `poker` that we can label.

``` r
poker_copy <- poker
```

Let’s also make a variable pointing to our data dictionary. For this
vignette, this points to where my package is installed. Your install
location will differ from mine if you run this code yourself.

If you were using your own data dictionary, then this would be a path to
where ever you have it on your computer.

``` r
dictionary_dir <- system.file("extdata/poker", package = "tsv2label")
dictionary_dir
```

    ## [1] "C:/Users/me/AppData/Local/R/win-library/4.2/tsv2label/extdata/poker"

### Converting categorical variables to Factors

Converting to Factor always comes first in our [order of
operations](#order-of-operations).

``` r
# If you were using your own data dictionary, then your `path` argument would
# point to its location on your computer.
factorise_with_dictionary(df = poker_copy, path = dictionary_dir)
```

    ##   Peeking at 'levels(poker_copy$CLASS)', built from 'values_hands':

    ##   Nothing in hand, One pair, Two pairs, Three of a kind, Straight, 
    ##   Flush, Full house, Four of a kind, Straight flush, Royal flush

    ##   Peeking at 'levels(poker_copy$C1)', built from 'values_ranks':

    ##   Ace, 2, 3, 4, 5, 6, 7, 8, 9, 10, Jack, Queen, King

    ##   Peeking at 'levels(poker_copy$S1)', built from 'values_suits':

    ##   Hearts, Spades, Diamonds, Clubs

Columns S1 to C5 all had a `factor_file` associated with them in
`index`, so they were all converted to Factors:

``` r
head(poker_copy)
```

    ##   ID       S1    C1       S2   C2       S3    C3       S4    C4       S5    C5
    ## 1  1   Hearts    10   Hearts Jack   Hearts  King   Hearts Queen   Hearts   Ace
    ## 2  2   Spades  Jack   Spades King   Spades    10   Spades Queen   Spades   Ace
    ## 3  3 Diamonds Queen Diamonds Jack Diamonds  King Diamonds    10 Diamonds   Ace
    ## 4  4    Clubs    10    Clubs Jack    Clubs   Ace    Clubs  King    Clubs Queen
    ## 5  5    Clubs   Ace    Clubs King    Clubs Queen    Clubs  Jack    Clubs    10
    ## 6  6   Hearts     2   Hearts    4   Hearts     5   Hearts     3   Hearts     6
    ##            CLASS    CAT  FLIP
    ## 1    Royal flush  Socks FALSE
    ## 2    Royal flush   Fred FALSE
    ## 3    Royal flush Fluffy  TRUE
    ## 4    Royal flush   Nala  TRUE
    ## 5    Royal flush   Cher  TRUE
    ## 6 Straight flush   Lily  TRUE

### Adding labels/descriptions to columns

Adding variable descriptions comes next. These are used by many R
packages to add extra functionality. For example, RStudio can display
labels in `View()`, the [`gtsummary`
package](https://github.com/ddsjoberg/gtsummary) uses the label
attribute to name variables in its output tables where possible, and my
[`sift` package](https://github.com/DesiQuintans/sift/) allows you to
search the labels (among all other text in each variable) to find the
right variable in large datasets.

``` r
describe_with_dictionary(df = poker_copy, path = dictionary_dir)
```

    ##   head() of 'label' attribute:

    ##   ID A bunch of random integers. 
    ##   S1 Suit of card #1 
    ##   C1 Rank of card #1 
    ##   S2 Suit of card #2 
    ##   C2 Rank of card #2 
    ##   S3 Suit of card #3

All columns had a `description` in `index`, so all of them have a new
`"label"` attribute:

``` r
str(poker_copy, 1)
```

    ## 'data.frame':    100 obs. of  14 variables:
    ##  $ ID   : int  1 2 3 4 5 6 7 8 9 10 ...
    ##   ..- attr(*, "label")= chr "A bunch of random integers."
    ##  $ S1   : Factor w/ 4 levels "Hearts","Spades",..: 1 2 3 4 4 1 1 2 3 4 ...
    ##   ..- attr(*, "label")= chr "Suit of card #1"
    ##  $ C1   : Factor w/ 13 levels "Ace","2","3",..: 10 11 12 10 1 2 9 1 5 1 ...
    ##   ..- attr(*, "label")= chr "Rank of card #1"
    ##  $ S2   : Factor w/ 4 levels "Hearts","Spades",..: 1 2 3 4 4 1 1 2 3 4 ...
    ##   ..- attr(*, "label")= chr "Suit of card #2"
    ##  $ C2   : Factor w/ 13 levels "Ace","2","3",..: 11 13 11 11 13 4 12 2 6 4 ...
    ##   ..- attr(*, "label")= chr "Rank of card #2"
    ##  $ S3   : Factor w/ 4 levels "Hearts","Spades",..: 1 2 3 4 4 1 1 2 3 4 ...
    ##   ..- attr(*, "label")= chr "Suit of card #3"
    ##  $ C3   : Factor w/ 13 levels "Ace","2","3",..: 13 10 13 1 12 5 10 3 9 2 ...
    ##   ..- attr(*, "label")= chr "Rank of card #3"
    ##  $ S4   : Factor w/ 4 levels "Hearts","Spades",..: 1 2 3 4 4 1 1 2 3 4 ...
    ##   ..- attr(*, "label")= chr "Suit of card #4"
    ##  $ C4   : Factor w/ 13 levels "Ace","2","3",..: 12 12 10 13 11 3 11 4 7 3 ...
    ##   ..- attr(*, "label")= chr "Rank of card #4"
    ##  $ S5   : Factor w/ 4 levels "Hearts","Spades",..: 1 2 3 4 4 1 1 2 3 4 ...
    ##   ..- attr(*, "label")= chr "Suit of card #5"
    ##  $ C5   : Factor w/ 13 levels "Ace","2","3",..: 1 1 1 12 10 6 13 5 8 5 ...
    ##   ..- attr(*, "label")= chr "Rank of card #5"
    ##  $ CLASS: Ord.factor w/ 10 levels "Nothing in hand"<..: 10 10 10 10 10 9 9 9 9 9 ...
    ##   ..- attr(*, "label")= chr "Poker hand formed by cards 1 to 5"
    ##  $ CAT  : chr  "Socks" "Fred" "Fluffy" "Nala" ...
    ##   ..- attr(*, "label")= chr "Randomly generated names for cats."
    ##  $ FLIP : logi  FALSE FALSE TRUE TRUE TRUE TRUE ...
    ##   ..- attr(*, "label")= chr "Results of a simulated coinflip."

### Renaming variables

Finally, we can rename the variables based on the `rename` column in
`index`.

``` r
rename_with_dictionary(df = poker_copy, path = dictionary_dir)
```

    ##   head(colnames(poker_copy)):

    ##   random_int c1_suit c1_rank c2_suit c2_rank c3_suit

The `FLIP` column did *not* have a `rename` associated with it in
`index`, so it was not renamed.

``` r
colnames(poker_copy)
```

    ##  [1] "random_int"      "c1_suit"         "c1_rank"         "c2_suit"        
    ##  [5] "c2_rank"         "c3_suit"         "c3_rank"         "c4_suit"        
    ##  [9] "c4_rank"         "c5_suit"         "c5_rank"         "hand_from_cards"
    ## [13] "random_cats"     "FLIP"

------------------------------------------------------------------------

# Appendix

## Formal definition of a `tsv2label` data dictionary

The keywords **REQUIRED/MUST**, **MUST NOT**, and **MAY/OPTIONAL** are
interpreted according to [RFC
2119](https://www.ietf.org/rfc/rfc2119.txt). I add an extra keyword,
**IGNORED**, for clarity about what `tsv2label` will permit.

- REQUIRED/MUST and MUST NOT are absolute requirements, or else the
  software will throw errors.
- MAY or OPTIONAL are elements that you can leave out if not needed.
- IGNORED are things that tsv2label does not attempt to access or use.

‘Variable’ and ‘column’ are used interchangeably; they refer to a column
of a dataframe object.

### File structure

`tsv2label`’s functions take a `path` argument, which we will call the
*dictionary path*. This path:

- **MUST** be the path to a directory or a .zip file.
- The *dictionary path* **MUST** contain a file called `index.tsv` or
  `index.txt` in its root folder.
- Subfolders in the *dictionary path* are **IGNORED**.
- Files in the *dictionary path* that are not `.tsv` or `.txt` format
  are **IGNORED**.
- Files that are not called `index.tsv` or `index.txt`, and are not
  referenced in the `factor_file` variable of `index` (see below), are
  **IGNORED**.

### Contents of `index` file

- `index` **MUST** be a tab-delimited spreadsheet. You can get this from
  Excel by saving your spreadsheet as *“Text (Tab delimited) (.txt)”*.
  .TXT files are recognised by `tsv2label`, so you do not have to change
  its extension.
- `index` **MUST** have these columns: `name`, `rename`, `description`,
  and `factor_file`.
  - `name` — The name of a variable in your dataframe.
    - **MUST NOT** be left blank.
    - **MUST** exactly match a variable’s name.
    - **MAY** be the name of a variable that doesn’t exist in the
      dataframe. This means that you can pre-name a variable that you
      expect to be creating in the future.
  - `rename` — What to rename the variable.
    - **MAY** be left blank. This means that the variable will not be
      renamed.
    - If not blank, **MUST** be a [syntactically valid
      name](https://stat.ethz.ch/R-manual/R-devel/library/base/html/make.names.html)
      in R.
  - `description` — Description of what the variable contains or is
    about. Also known as ‘variable labels’. Used to fill the `"label"`
    attribute of the variable.
    - **MAY** be left blank. This means that the variable will not be
      described.
  - `factor_file` — The filename of a spreadsheet in the *dictionary
    path* that describes how the variable’s values are mapped to labels,
    e.g. postal codes to place names. These are also known as ‘value
    labels’. These are used to convert the variable to a Factor type.
    - **MAY** be left blank. This means that the variable will not be
      converted to a Factor.
    - If not blank, **MUST** exactly match the filename of a file in the
      *dictionary path*.
    - All factor files that are named here **MUST** exist.
    - **MAY** be given with or without a file extension; it is assumed
      to point to a `.tsv` or `.txt` file.
    - More than one `name` **MAY** share the same `factor_file`.

### Contents of `factor_file` files

If defined for a variable in the `factor_file` column of `index`:

- **MUST** be in the *dictionary path*, and exactly match the name given
  in the `factor_file` column.
- **MUST** be a tab-delimited spreadsheet in either *.tsv* or *.txt*
  format.
- **MUST** have these columns: `level`, `label`, `ordered`.
  - `level` — Values in the variable.
  - `label` — Labels to apply to each level.
  - `ordered` — Should this be created as an ordered factor?
    - **MAY** be left blank. If all cells are blank, then an unordered
      factor will be created.
    - To create an ordered variable, at least one cell in the column
      **MUST** contain one of `true`, `t`, `yes`, `y`, or `1`
      (case-insensitive).
    - You **MAY** fill out just one cell in this column and leave the
      rest blank.
- The columns above are passed into the `factor()` function to do the
  conversion, and therefore must meet the expectations of that function,
  namely:
  - Each `level` entry **MUST** exactly match a value in the variable.
  - There **SHOULD** be a `level` entry for each unique value in the
    variable.
  - There **MUST** be a `label` for every `level`.
  - Levels are created in the order they are listed.
