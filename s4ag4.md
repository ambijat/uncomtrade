For Classification
------------------

The JSON file for S4 classification can be downloaded from
<a href="https://comtrade.un.org/Data/cache/classificationS4.json" class="uri">https://comtrade.un.org/Data/cache/classificationS4.json</a>.
This has all the AG levels upto 5. We need to extract the AG5 level from
this file.

Reading the JSON file with the help of library rjson. We use the unlist
method to flatten the data and convert it into dataframe.

``` r
library(rjson)
string <- "classificationS4.json"
reporters <- fromJSON(file=string)

df <- lapply(reporters, function(results)
{
  data.frame(matrix(unlist(results), ncol=3, byrow=T))
})
sapply(df, class)
```

    ##               more minimumInputLength          classCode          className 
    ##       "data.frame"       "data.frame"       "data.frame"       "data.frame" 
    ##            results 
    ##       "data.frame"

Extracting the AG5 level.
-------------------------

Now you have df as a list of data frames. We will collapse it into one
single dataframe. We have also need a bit dressing of the new dataframe
such as removing the top 2 rows and then re numbering the rows.

``` r
df <- do.call(rbind, df)
df <- df[-(1:2),] 
rownames(df) <- 1:nrow(df)
```

We can see the first column X1 contains the number codes for various
commodity levels. It has all the levels out of which we can extract
those commodities which have 5 digit code, meaning the AG 5 level. This
can be done as follows.

If you see the condition nchar(df$X1) == 5 mentioned as row condition
against all the columns, it is the one that will give us all the
commodities for desired level. If you need AG4 level then change it from
5 to 4.

``` r
df1 <- df[nchar(df$X1) == 5, ]
```

The next step below is for a tricky situation in S4 classification.
There are several Memorandum Items, which are yet to be classified and
hence are under single categories. I have removed these Memorandum Items
which have letter X against each code.

``` r
df2 <- df1[!grepl("X",df1$X1), ]
```

After this we can select the relevant first 2 columns and rename them
and renumber them as below.

``` r
df4 <- subset(df2, select = c("X1", "X2"))
colnames(df4) <- c("Commodity.code", "Commodity.name")
rownames(df4) <- 1:nrow(df4)
head(df4)
```

    ##   Commodity.code                                Commodity.name
    ## 1          TOTAL           Total of all SITC Rev.4 commodities
    ## 2          00111            00111 - Pure-bred breeding animals
    ## 3          00119 00119 - Other than pure-bred breeding animals
    ## 4          00121                           00121 - Sheep, live
    ## 5          00122                           00122 - Goats, live
    ## 6          00131            00131 - Pure-bred breeding animals

Joining Partner COuntries with S4AG5 Commodity level.
-----------------------------------------------------

First initializing the libraries.

    ## 
    ## Attaching package: 'dplyr'

    ## The following objects are masked from 'package:stats':
    ## 
    ##     filter, lag

    ## The following objects are masked from 'package:base':
    ## 
    ##     intersect, setdiff, setequal, union

    ## -- Attaching packages ---------------------------------------------------------------------------------------- tidyverse 1.3.0 --

    ## v ggplot2 3.3.2     v purrr   0.3.4
    ## v tibble  3.0.1     v stringr 1.4.0
    ## v tidyr   1.1.0     v forcats 0.5.0
    ## v readr   1.3.1

    ## Warning: package 'ggplot2' was built under R version 4.0.2

    ## -- Conflicts ------------------------------------------------------------------------------------------- tidyverse_conflicts() --
    ## x dplyr::filter() masks stats::filter()
    ## x dplyr::lag()    masks stats::lag()

Next, we import the partner countries from partner\_list.

``` r
pd <- read.csv("partner_list.csv", stringsAsFactors = F)
colnames(pd) <- c("Partner.Code", "Partner.name")
```

combining partner list and s4
=============================

``` r
sa <- merge(df4, pd)
colnames(sa) <- c("Commodity.code", "Commodity.name", "Partner.Code", "Partner.name")
nrow(sa)
```

    ## [1] 413868

Selecting a group of Commodities
--------------------------------

If we look into the total rows of dataframe, then the number is quite
large 4,13,868 (which is 2653\*156). This is usually problematic for the
UN Comtrade data limitation for a guest user is 1,00,000 queries.
Therefore, it is advisable to work for desired group of commodities.
