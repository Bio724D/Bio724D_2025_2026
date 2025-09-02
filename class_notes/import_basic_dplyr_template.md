---
title: "Data import and simple data frame manipulation"
date-format: iso
format: 
  html:
    embed-resources: true
---

# Data and libraries

### Data

Download the following files to your `~/Bio724` directory. These are direct links to the raw files; right click and "Save Link As..." (or equivalent):

* [`penguins.csv`](https://github.com/Bio724D/Bio724D_2024_2025/raw/main/data/penguins.csv)
* [`spellman-1998-expression.tsv`](https://github.com/Bio724D/Bio724D_2024_2025/raw/main/data/spellman-1998-expression.tsv)[^1]
* [`cryptococcus_tecan_run.txt`](https://github.com/Bio724D/Bio724D_2024_2025/raw/main/data/cryptococcus_tecan_run.txt)
* [`Nagalakshmi_et_al_2008_TableS2.xls`](https://github.com/Bio724D/Bio724D_2024_2025/raw/main/data/Nagalakshmi_et_al_2008_TableS2.xls)[^2]

[^1]: Spellman PT, Sherlock G, Zhang MQ, Iyer VR, Anders K, Eisen MB, Brown PO, Botstein D, Futcher B. Comprehensive identification of cell cycle-regulated genes of the yeast Saccharomyces cerevisiae by microarray hybridization. Mol Biol Cell. 1998 Dec;9(12):3273-97. doi: 10.1091/mbc.9.12.3273. PMID: 9843569; PMCID: PMC25624.

[^2]: Nagalakshmi U, Wang Z, Waern K, Shou C, Raha D, Gerstein M, Snyder M. The transcriptional landscape of the yeast genome defined by RNA sequencing. Science. 2008 Jun 6;320(5881):1344-9. doi: 10.1126/science.1158441. Epub 2008 May 1. PMID: 18451266; PMCID: PMC2951732.


### Libraries

```{r}
#| output: false
library(tidyverse)
```

# Base R vs The Tidyverse

The [Tidyverse](https://www.tidyverse.org/) is a "meta-package" of useful libraries designed with similar interfaces  working with data. Key libraries in the Tidyverse include ggplot2, dplyr, readr, tidyr, and others. We're emphasizing the use of Tidyverse packages in this class because they provide a consistent and relatively intuitive approach for working with data.  


In some cases Tidyverse packages provide similar functionality to base R functions, but with slightly different names and different behaviors. For example `read_csv` (from readr) and `read.csv` (a base R package) both read CSVs but have different arguments and different default behaviors.  Usually, the output of these two functions will be similar but there are some gotchas lurking if you substitute one for the other.  Neither one is necessarily better than the other, but it's good to be aware of which one you're using.


# Data import

## Reading delimited files (CSV, TSV, other) using `readr`

`readr` provides convenient tools for working with data from files in CSV (comma separated values), TSV (tab separated values), or other delimited formats (`read_delim`).

* [`readr` cheat sheet](https://raw.githubusercontent.com/rstudio/cheatsheets/main/data-import.pdf)

### RTFM for the `read_csv` and related

Look at help for `read_csv` / `read_tsv` / `read_delim`:

* Dealing with files without header names
* Selecting a subset of columns
* Specifying columns types
* Missing data 
* Comment lines

### Load a well formed CSV file

You've already seen how to import a "well formed" CSV file:

```{r}
penguins <- read_csv("~/Bio724/penguins.csv")
```



### Load a fairly well formed TSV file


The next  file, `spellman-1998-expression.tsv` is a TSV file, that is "mostly" well formed:

```{r}
# read spellman TSV data

```


```{r}
# examine dimension, names, etc
```



#### Loading only a subset of columns

You can read only a subset of columns using the `col_select` argument to the `read_` functions:

```{r}
# read first six columns of data file

```



### Loading a file with a non-standard encoding

ASCII and unicode encoded files are the most common file types you're likely to work with, but you may encounter files with unusual encodings. For example the file [`cryptococcus_tecan_run.txt`]() is a TSV file produced by an instrument in my lab.  One of the data columns includes a degree Celsius symbol, and the file is encoded in a legacy format called ["windows-1252" encoding](https://en.wikipedia.org/wiki/Windows-1252).

```{r, error=TRUE}
#| output: false
# this will generate an error
tecan <- read_tsv("~/Bio724/cryptococcus_tecan_run.txt")
```

We can use the `locale` argument to `read_tsv` to specify the encoding (assuming we know what it is):

```{r}
# fix the error by specifying the correct encoding using the local argument
# also tell read_tsv there are no col_names

tecan <- read_tsv("~/Bio724/cryptococcus_tecan_run.txt",
                  locale = locale(encoding = "windows-1252"),
                  col_names = FALSE)

```

There are still some problems with our data file (see the warning above). If we follow the instructions to use the `problems` function on our data frame, we'll get some additional info about what R sees as wrong with our data import:

```{r}
problems(tecan)
```

If you go back and look at the raw data file, you'll see that the last two lines of the file have some accessory information about the instrument run. These are not properly formatted data rows. We'll see how to deal with these issues below.


## Reading excel files with `readxl`

[`readxl`](https://readxl.tidyverse.org/) provides a `read_excel` function for reading data directly from Excel spreadsheets. 

A key difference to be aware of when working with Excel files is the presence of multiple "sheets" within a single document.  Another frequent complication of Excel files is that Excel users often start tables in non-standard positions within a sheet.  `read_excel` provides some arguments to deal with such cases.

Key arguments for `read_excel`:
* sheet
* range

#### Example

The file `Nagalakshmi_et_al_2008_TableS2.xls` illustrates both common Excel complications highlighted above.


```{r}
# use read_excel to extract the low expression table 
# from Nagalakshmi Supp Table 2
library(readxl)
```


## Interactive data import in RStudio

See class demo of the "Import Dataset" button in RStudio.


## renaming columns after import


The `rename` function provides a convenient syntax for renaming columns.

Rename the first column of the Spellman data frame to "ID":

```{r}
# rename spellman first column to "ID"
```




# Data frame manipulation using dplyr

The package `dplyr` provides a "grammar of data manipulation" (note ggplot is a "grammar of graphics"; there's a trend here!)

Some Basic "verbs" of dplyr (we'll see more next lecture):

* `select` -- get specific columns
* `mutate` -- create new columns
* `filter` -- get specific rows
* `arrange` -- order rows


## `select` 

`select` subsets columns

### positive and negative selection

```{r}
# get only species and "bill" columns from penguin data 
```

```{r}
# get everything except "bill" columns from penguins
```


### selecting on types

The `where` helper function in conjunction with `select` can be use to form predicate statements:

```{r}
# get numeric columns from penguin data
```


### selecting on string matches 

The `matches` function can be used to match column names by string matching:

```{r}
# get all the "length" columns from penguins
```


We'll cover more details about string matching and searching in a later lecture.




## `mutate`

`mutate` can be used to create derived or new columns:

```{r}
# create a derived column, body_mass_kg, in penguins

```



## `filter` examples

`filter` subsets rows.

### Filter on positive and negative matches

```{r}
# get only the rows representing Gentoo penguins

```


```{r}
# exclude the rows that are Gentoo penguins

```



### Multiple filters are "ands"


```{r}
# get the Gentoo penguins bigger than 4.5 kg
```


```{r}
#| output: false
# This will return an empty table because multiple arguments to filter 
# are treated as AND; in this data, no penguin is both a "Gentoo" and an "Adelie" penguin
penguins |>
  filter(species == "Gentoo", species == "Adelie" )

```

### More complex filters using and (&), or (|), and %in% 

```{r}
# get both Gentoo and Adelie penguins using the OR operator
```

### %in% allows you to filter  on sets

```{r}
# Get Gentoo and Adelie penguins using the %in% operator
```



### Filtering on missing data and complete cases

```{r}
# find rows where body_mass_g has NA values
```


```{r}
# get all rows where body_mass data is NOT missing
```


Dropping missing values is so common that there is a specific function for this in the Tidyverse package `tidyr`, called `drop_na`:

```{r}
# drop any rows where body_mass_g is missing using drop_na
```

When you don't pass one or more column names to `drop_na` it only returns rows where there are no missing values anywhere:

```{r}
# drop rows where any variable has an NA value
```

# Sorting data using `arrange`

Arrange sorts a data frame on the column(s) you specify:

```{r}
# sort penguins by bill_length_mm
```

By default, the data are arrange in ascending order (smallest to biggest). To sort in descending order use the`desc` helper function:
```{r}
# sort penguins by bill_length_mm from biggest to smallest
penguins |>
  arrange(desc(bill_length_mm))
```

`arrange` can be used with multiple columns to break ties:

```{r}
# sort penguins by flipper_length and  bill_length
```



# Base R indexing for column and row subsetting

So far we've been looking at subsetting rows and columns using dplyr functions. 

It's good to know some of the base R syntax for working with columns and rows. The act of specifying particular regions of a data structure is called "indexing".  When dealing with a tabular data structure, we need to index both rows and columns.


```{r}
penguins[1, 1]  # row 1, col 1
```

```{r}
penguins[1:5, 1:3]  # rows 1 to 5, columns 1 to 3
```

Columns are taken to represent variables in R data frames.  If we don't specify rows, R assumes we're working with columns:

```{r}
penguins[1:4]
```

We can index columns using vector of strings like so:

```{r}
penguins[c("species", "island", "body_mass_g", "sex")]
```



## Column indexing using `$` operator

Note that everything up to now has returned a new data frame; the `$` operator returns a vector instead of a data frame.


```{r}
penguins$body_mass_g |>
  head(50)
```

Compare the above to:

```{r}
penguins[c("body_mass_g")] |>
  head(50)
```



