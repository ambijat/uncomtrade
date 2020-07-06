Finalising the Data Matrix
--------------------------

This step could have been added to previous code, but to highlight the
clarity needed separate treatment. This code does nothing great except
picking up each individual CSV files and transposing the rows into
columns so that countries are represented as variables. The rows give
discrete data on commodities.

This essentially involves spreading the data, which was in a gathered
form in the previous step. And, then re-writing the files.

First step is to initialize the libraries.

``` r
library(dplyr)
library(tidyverse)
```

``` r
aa <- list.files(pattern = "*.csv", recursive = T)
length(aa)

for (i in aa){
  s1 <- read.csv(i, stringsAsFactors = F, strip.white = T)
  
  s2 <- s1 %>%
    select("Partner", "Code", "Commodity", "TradeValue") %>%
    spread(Partner, TradeValue)
  sapply(s2, class)
  s2[is.na(s2)] <- 0
  s2$Total <- rowSums(s2[3:ncol(s2)])
  s3 <- s2 %>% 
    group_by(Code) %>%
    top_n(1, abs(Total))
  
  s3$Total <- NULL
  
  colnames(s3)[1] <- "Product"
  write.csv(s3, i, row.names = F)
  
}
```

The final sets of data are ready can be examined here.
