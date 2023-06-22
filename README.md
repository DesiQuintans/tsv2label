Labelling datasets using a data dictionary, with `tsv2label`
================
Desi Quintans
2023-06-16

------------------------------------------------------------------------

- [Installation](#installation)
- [List of functions](#list-of-functions)
  - [Order of operations](#order)
- [Example: Describing the Poker Hands
  dataset](#example-describing-the-poker-hands-dataset)
  - [The raw data](#the-raw-data)
  - [What does a dictionary look
    like?](#what-does-a-dictionary-look-like)
    - [Index file](#index-file)
    - [Factor files](#factor-files)
  - [Reading a dictionary](#reading-a-dictionary)
  - [Step 1: Convert categorical variables to
    Factors](#step-1-convert-categorical-variables-to-factors)
  - [Step 2: Add labels/descriptions to
    variables](#step-2-add-labelsdescriptions-to-variables)
  - [Step 3: Rename variables](#step-3-rename-variables)
- [Appendix](#appendix)
  - [Formal definition of a `tsv2label` data dictionary](#formal)
    - [File structure](#file-structure)
    - [Contents of `index` file](#contents-of-index-file)
    - [Contents of `factor_file` files](#contents-of-factor_file-files)

------------------------------------------------------------------------

# Installation

``` r
# CRAN coming soon

# Install from GitHub for up-to-date changes
remotes::install_github("DesiQuintans/tsv2label")

library(tsv2label)  # Load it up!
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
can be cleaned and reshaped with regular expressions and multiple
cursors; and can be tracked and diffed with version control software.

![](data-raw/tsv2label.png)

------------------------------------------------------------------------

# List of functions

`tsv2label` gives you four main functions:

| Function                              | Description                            |
|:--------------------------------------|:---------------------------------------|
| `factorise_with_dictionary(df, path)` | Convert variables to Factor            |
| `describe_with_dictionary(df, path)`  | Add descriptions (labels) to variables |
| `rename_with_dictionary(df, path)`    | Rename variables                       |
|                                       |                                        |
| `revert_colnames(df, path)`           | Return columns to their original names |

## Order of operations

The order that these functions should be applied is:

1.  `factorise_with_dictionary()`
2.  `describe_with_dictionary()`
3.  `rename_with_dictionary()`
4.  `revert_colnames()`

This is because when `factorise_with_dictionary()` converts variables to
Factors, any labels associated with them are lost. And when
`rename_with_dictionary()` renames variables,
`factorise_with_dictionary()` and `describe_with_dictionary()` can no
longer find and act on them.

------------------------------------------------------------------------

# Example: Describing the Poker Hands dataset

## The raw data

``` r
library(tsv2label)
```

`tsv2label` ships with a built-in dataset called `poker`, which is a
subset of the [Poker
Hand](https://archive.ics.uci.edu/ml/datasets/Poker+Hand) dataset with
some added columns:

``` r
head(poker)
```

    ##   ID S1 C1 S2 C2 S3 C3 S4 C4 S5 C5 CLASS    CAT COIN FLIP LIST_COL
    ## 1  1  1 10  1 11  1 13  1 12  1  1     9  Socks     FALSE  a, n, w
    ## 2  2  2 11  2 13  2 10  2 12  2  1     9   Fred     FALSE  v, e, c
    ## 3  3  3 12  3 11  3 13  3 10  3  1     9 Fluffy      TRUE  v, f, t
    ## 4  4  4 10  4 11  4  1  4 13  4 12     9   Nala      TRUE  h, l, o
    ## 5  5  4  1  4 13  4 12  4 11  4 10     9   Cher      TRUE  b, d, v
    ## 6  6  1  2  1  4  1  5  1  3  1  6     8   Lily      TRUE  n, p, r

There are many coded values here that need to be converted to Factors.
The column names are cryptic, and the dataset has no variable labels
which would aid in exploration, especially when using a label-aware
exploration package like
[`siftr`](https://github.com/DesiQuintans/siftr/).

Luckily, `tsv2label` ships with the data dictionary for this dataset, in
both .ZIP and folder forms (`tsv2label` can read directly from both):

``` r
# system.file() looks inside tsv2label's installed location to see the files 
# that came with it. 

system.file("extdata", package = "tsv2label") |> list.files()
```

    ## [1] "poker"     "poker.zip"

## What does a dictionary look like?

A data dictionary is a directory or .ZIP file with no subfolders, which
contains tab-delimited spreadsheets in either *.TSV* or *.TXT* format.

``` r
system.file("extdata/poker", package = "tsv2label") |> list.files()
```

    ## [1] "index.tsv"        "values_flip.tsv"  "values_hands.tsv" "values_ranks.tsv"
    ## [5] "values_suits.tsv"

The Appendix below has the [formal definition of a
dictionary](#formal-definition-of-a-tsv2label-data-dictionary), but the
easiest way to understand what should be in a dictionary is by looking
at `poker`’s.

### Index file

The central file is called `index`; it must always exist, and must be a
tab-delimited file in *.TSV* or *.TXT* format.

``` r
system.file("extdata/poker/index.tsv", package = "tsv2label") |> read.delim()
```

    ##         name          rename            description  factor_file
    ## 1         ID      random_int  Some random integers.             
    ## 2         S1         c1_suit        Suit of card #1 values_suits
    ## 3         C1         c1_rank        Rank of card #1 values_ranks
    ## 4         S2         c2_suit        Suit of card #2 values_suits
    ## 5         C2         c2_rank        Rank of card #2 values_ranks
    ## 6         S3         c3_suit        Suit of card #3 values_suits
    ## 7         C3         c3_rank        Rank of card #3 values_ranks
    ## 8         S4         c4_suit        Suit of card #4 values_suits
    ## 9         C4         c4_rank        Rank of card #4 values_ranks
    ## 10        S5         c5_suit        Suit of card #5 values_suits
    ## 11        C5         c5_rank        Rank of card #5 values_ranks
    ## 12     CLASS hand_from_cards Poker hand (cards 1-5) values_hands
    ## 13       CAT                      Random cat names.             
    ## 14 COIN FLIP       coin_flip Outcome of a coinflip.  values_flip
    ## 15 not_exist                 Column not in dataset.

It must have these four columns in any order (all other columns are
ignored):

1.  `name` is the name of a column/variable in your dataset.
2.  `rename` is what to rename the column. Leave it blank if unneeded.
3.  `description` is a human-readable description of what the variable
    is about. Leave it blank if unneeded.
4.  `factor_file` is used to convert categorical data into Factors. It
    has the filename (with or without file extension) of a spreadsheet
    in the same folder that describes how levels are mapped to labels,
    e.g. postal codes to suburb names. As you can see, one `factor_file`
    can be applied to many columns.

### Factor files

The factor files control how a variable is going to be converted to a
Factor type. Factor files must also be tab-delimited files in *.TSV* or
*.TXT* format.

``` r
system.file("extdata/poker/values_suits.tsv", package = "tsv2label") |> read.delim()
```

    ##   levels   labels ordered
    ## 1      1   Hearts   FALSE
    ## 2      2   Spades      NA
    ## 3      3 Diamonds      NA
    ## 4      4    Clubs      NA

It must have these two columns in any order:

1.  `levels` contains the raw values in your dataset. It is used as the
    levels of the new factor.
2.  `labels` contains the label to apply to each level.

Another two columns are optional, and can be presented in any order:

3.  `ordered` controls whether this will be created as an ordered
    factor. An affirmative value (case-insensitive: `true`, `t`, `yes`,
    `y`, or `1`) in *any* cell of this column will make it an ordered
    factor.
4.  `exclude` controls whether a level is excluded from the final factor
    (i.e. converted to `NA`). An affirmative value (case-insensitive:
    `true`, `t`, `yes`, `y`, or `1`) in the same row as a level will
    exclude that level.

The columns are named after their matching arguments in `factor()`:

``` r
str(factor)
```

    ## function (x = character(), levels, labels = levels, exclude = NA, ordered = is.ordered(x), 
    ##     nmax = NA)

Any other columns are ignored.

## Reading a dictionary

`tsv2label` can read dictionaries from both folders and .ZIP files. The
latter is particularly convenient because it lets you distribute a
dictionary as a single .ZIP file.

`tsv2label` functions have a `path` argument to tell them where the
dictionary is:

``` r
# To read from a folder, use the path to the folder:
factorise_with_dictionary(df = my_data, path = "C:/path/to/dictionary/folder")

# To read from a .ZIP, use the path to the .ZIP (it will unzip automatically):
factorise_with_dictionary(df = my_data, path = "C:/path/to/my_dictionary.zip")
```

For this example, let’s read the dictionary from the folder.

``` r
dictionary_dir <- system.file("extdata/poker", package = "tsv2label")
dictionary_dir
```

    ## [1] "C:/Users/.../AppData/Local/R/win-library/4.3/tsv2label/extdata/poker"

If you were using your own data dictionary, then this would be a path to
its location on your computer.

## Step 1: Convert categorical variables to Factors

Converting to Factor always comes first in our [order of
operations](#order-of-operations).

``` r
factorise_with_dictionary(df = poker, path = dictionary_dir)
```

    ##   (1/4)	Using 'values_flip' for COIN FLIP.
    ##   (2/4)	Using 'values_hands' for CLASS.
    ##   (3/4)	Using 'values_ranks' for C1, C2, C3, C4, C5.
    ##   (4/4)	Using 'values_suits' for S1, S2, S3, S4, S5.

    ##   Peeking at 'levels(poker[["COIN FLIP"]])', built from 'values_flip':

    ##   Heads, Tails

    ##   Peeking at 'levels(poker[["CLASS"]])', built from 'values_hands':

    ##   Nothing in hand, One pair, Two pairs, Three of a kind, Straight, 
    ##   Flush, Full house, Four of a kind, Straight flush, Royal flush

    ##   Peeking at 'levels(poker[["C1"]])', built from 'values_ranks':

    ##   Ace, 2, 3, 4, 5, 6, 7, 8, 9, 10, Jack, Queen, King

    ##   Peeking at 'levels(poker[["S1"]])', built from 'values_suits':

    ##   Hearts, Spades, Diamonds, Clubs

Note that we didn’t have to assign the result to a name; all `tsv2label`
functions avoid expensive copying by modifying the dataframe in-place.

Any column that had a `factor_file` associated with it in `index` will
be converted to a Factor:

``` r
head(poker)
```

    ##   ID       S1    C1       S2   C2       S3    C3       S4    C4       S5    C5
    ## 1  1   Hearts    10   Hearts Jack   Hearts  King   Hearts Queen   Hearts   Ace
    ## 2  2   Spades  Jack   Spades King   Spades    10   Spades Queen   Spades   Ace
    ## 3  3 Diamonds Queen Diamonds Jack Diamonds  King Diamonds    10 Diamonds   Ace
    ## 4  4    Clubs    10    Clubs Jack    Clubs   Ace    Clubs  King    Clubs Queen
    ## 5  5    Clubs   Ace    Clubs King    Clubs Queen    Clubs  Jack    Clubs    10
    ## 6  6   Hearts     2   Hearts    4   Hearts     5   Hearts     3   Hearts     6
    ##            CLASS    CAT COIN FLIP LIST_COL
    ## 1    Royal flush  Socks     Tails  a, n, w
    ## 2    Royal flush   Fred     Tails  v, e, c
    ## 3    Royal flush Fluffy     Heads  v, f, t
    ## 4    Royal flush   Nala     Heads  h, l, o
    ## 5    Royal flush   Cher     Heads  b, d, v
    ## 6 Straight flush   Lily     Heads  n, p, r

## Step 2: Add labels/descriptions to variables

Adding variable labels comes next. These are used by many R packages to
add extra functionality. For example, RStudio can display labels in
`View()`, the [`gtsummary`
package](https://github.com/ddsjoberg/gtsummary) uses the label
attribute to name variables in its output tables where possible, and my
[`siftr` package](https://github.com/DesiQuintans/siftr/) allows you to
search the labels (among all other text in each variable) to find the
right variable in large datasets.

``` r
describe_with_dictionary(df = poker, path = dictionary_dir)
```

    ##   head() of 'label' attribute:

    ##   ID Some random integers. 
    ##   S1 Suit of card #1 
    ##   C1 Rank of card #1 
    ##   S2 Suit of card #2 
    ##   C2 Rank of card #2 
    ##   S3 Suit of card #3

All columns except `LIST_COL` (which was not in the dictionary) had a
`description` in `index`, so all of them have a new `"label"` attribute:

``` r
Map(\(x) attr(x, "label"), poker)
```

    ## $ID
    ## [1] "Some random integers."
    ## 
    ## $S1
    ## [1] "Suit of card #1"
    ## 
    ## $C1
    ## [1] "Rank of card #1"
    ## 
    ## $S2
    ## [1] "Suit of card #2"
    ## 
    ## $C2
    ## [1] "Rank of card #2"
    ## 
    ## $S3
    ## [1] "Suit of card #3"
    ## 
    ## $C3
    ## [1] "Rank of card #3"
    ## 
    ## $S4
    ## [1] "Suit of card #4"
    ## 
    ## $C4
    ## [1] "Rank of card #4"
    ## 
    ## $S5
    ## [1] "Suit of card #5"
    ## 
    ## $C5
    ## [1] "Rank of card #5"
    ## 
    ## $CLASS
    ## [1] "Poker hand (cards 1-5)"
    ## 
    ## $CAT
    ## [1] "Random cat names."
    ## 
    ## $`COIN FLIP`
    ## [1] "Outcome of a coinflip."
    ## 
    ## $LIST_COL
    ## NULL

## Step 3: Rename variables

Finally, we can rename the variables based on the `rename` column in
`index`.

``` r
rename_with_dictionary(df = poker, path = dictionary_dir)
```

    ##   head(colnames(poker)):

    ##   random_int c1_suit c1_rank c2_suit c2_rank c3_suit

The `CAT` column did *not* have a `rename` associated with it in
`index`, so it was not renamed. The `LIST_COL` column was not in the
dictionary at all, so it is also unchanged.

``` r
colnames(poker)
```

    ##  [1] "random_int"      "c1_suit"         "c1_rank"         "c2_suit"        
    ##  [5] "c2_rank"         "c3_suit"         "c3_rank"         "c4_suit"        
    ##  [9] "c4_rank"         "c5_suit"         "c5_rank"         "hand_from_cards"
    ## [13] "CAT"             "coin_flip"       "LIST_COL"

You can also revert the names, which is useful if you make changes to
the data dictionary and want to go back to Step 1.

``` r
revert_colnames(df = poker, path = dictionary_dir)
```

    ##   head(colnames(poker)):

    ##   ID S1 C1 S2 C2 S3

``` r
colnames(poker)
```

    ##  [1] "ID"        "S1"        "C1"        "S2"        "C2"        "S3"       
    ##  [7] "C3"        "S4"        "C4"        "S5"        "C5"        "CLASS"    
    ## [13] "CAT"       "COIN FLIP" "LIST_COL"

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

- **MUST** be the path to a directory or a .ZIP file.
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

- **MUST** have these columns in any order: `levels`, `labels`.

  - `levels` — Values in the variable.
  - `labels` — Labels to apply to each level.

- **MAY** have these columns in any order: `ordered`, `exclude`.

  - `ordered` — Should this factor be an ordered factor?
    - If the column is missing, an unordered factor is created.
    - If the column is present but all cells are blank, an unordered
      factor is created.
    - An ordered factor is created if the column is present **and** at
      least one cell in the column contains one of (case-insensitive)
      `true`, `t`, `yes`, `y`, or `1`.
      - You **MAY** fill out just one cell in this column and leave the
        rest blank.
  - `exclude` — Should this level be excluded from the factor
    (i.e. converted to `NA`)?
    - If the column is missing, no levels are excluded.
    - If the column is present, any cell that contains one of
      (case-insensitive) `true`, `t`, `yes`, `y`, or `1` will make its
      matching `level` be excluded.
    - Any other value (including blanks) will keep the level.

- The columns above are passed into the `factor()` function to do the
  conversion, and therefore must meet the expectations of that function,
  namely:

  - Each `level` entry **MUST** exactly match a value in the variable.
  - There **SHOULD** be a `level` entry for each unique value in the
    variable. Values without a matching `level` entry will be coded as
    `NA` by `factor()`.
  - There **MUST** be a `label` for every `level`.
    - `label`s **MAY** be duplicated to bin different levels under the
      same label.
  - Levels are created in the order they are listed.
