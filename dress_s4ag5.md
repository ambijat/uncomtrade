Dressing the Downloaded Data
----------------------------

The data in raw form is not uniform in terms of partner countries and
commodities as a table across the 10 years. So, we will make it uniform
in the sense that each country and each commodity is on the panel for
each year. And, there shall be zeros for values which are missing.

Reading the list of partner countries
-------------------------------------

As we already know the reporter country India has code 699 so will also
create a variable for it apart from loading the list of partner
countries, which are 156 as per our earlier coding exercise.

``` r
codo <- read.csv("partner_list.csv", stringsAsFactors = F) 
codo1 <- c(699)
```

Intializing the libraries
-------------------------

``` r
library(dplyr)
library(tidyverse)
```

    ## Warning: package 'ggplot2' was built under R version 4.0.2

Creating the Folders for Processed Data
---------------------------------------

The same arrangement of folders is needed with country folder at the top
and 2 sub directories of export and import that will hold the processed
CSV files for each year.

If the folder exists it will not create otherwise it will create folder
based on codo1.

Loading the Commodity list
--------------------------

Since our demostration here is limited to only specific set of S4
commodities, which contain iron at AG5 level, we will be loading the
relevant commodity listing prepared from previous steps.

There is one teasy issue. The downloaded data has commodity.code as
number which are actually in the form of character. So we will be using
same data class here also by converting all kinds of numeric code into
character code.

``` r
s4p <- read.csv("s4ag5_iron.csv", stringsAsFactors = F) 

s4p1 <- s4p %>%
  select(Partner.Code, Partner.name, Commodity.Code, Commodity.name) %>%
  mutate(Partner.Code = as.character(Partner.Code)) %>%
  mutate(Commodity.Code = as.character(Commodity.Code)) 
```

Dressing the Exports Data
-------------------------

This function is fairly length and it has plenty of string manipulation
to dress up the data, which can be enumerated as follows.

-   There is joining of partner list and commodity countries
-   some country names are modified with more familiar ones
-   part of the string in commodity names is removes so as to get true
    commodity names.
-   imputing missing names from adjacent columns
-   finally pasting the dress up data inot a new CSV file to be stored
    in exported folder.

``` r
for (j in codo1){
  setwd(paste0(codo2$country.name[codo2$country.code == j], "/export"))
  cnx <- list.files()
  for (i in cnx){
    f1 <- read.csv(i, stringsAsFactors = F)
    f2 <- f1 %>%
      select("Partner.Code"
             , "Partner"
             , "Commodity.Code"
             , "Commodity"
             , "Trade.Value..US..")
    
    f2$Partner.Code <- as.character(f2$Partner.Code)
    f2$Commodity.Code <- as.character(f2$Commodity.Code)
    
    f3 <- left_join(s4p1, f2, by = c("Partner.Code", "Commodity.Code"))
    f3$Partner.y <- ifelse(is.na(f3$Partner.y), f3$Partner.x, f3$Partner.y)
    
    #several modified names are there.
    f3$Partner.y[f3$Partner.y == "China, Hong Kong SAR"] <- "Hong Kong"
    f3$Partner.y[f3$Partner.y == "Dem. People's Rep. of Korea"] <- "North Korea" 
    f3$Partner.y[f3$Partner.y == "Rep. of Korea"] <- "South Korea" 
    f3$Partner.y[f3$Partner.y == "Lao People's Dem. Rep."] <- "Laos"
    f3$Partner.y[f3$Partner.y == "Russian Federation"] <- "Russia"
    f3$Partner.y[f3$Partner.y == "Viet Nam"] <- "Vietnam"
    f3$Partner.y[f3$Partner.y == "United Arab Emirates"] <-  "UAE"
    f3$Partner.y[f3$Partner.y == "Bolivia (Plurinational State of)"] <-  "Bolivia"
    f3$Partner.y[f3$Partner.y == "Dem. Rep. of the Congo"] <-  "Congo Democratic"
    f3$Partner.y[f3$Partner.y == "CÃ´te d'Ivoire"] <-  "Cote de voire"
    f3$Partner.y[f3$Partner.y == "China, Macao SAR"] <-  "Macao"
    f3$Partner.y[f3$Partner.y == "Rep. of Moldova"] <-  "Moldova"
    f3$Partner.y[f3$Partner.y == "North Macedonia"] <-  "Macedonia"
    f3$Partner.y[f3$Partner.y == "United Rep. of Tanzania"] <-  "Tanzania"
    f3$Partner.y[f3$Partner.y == "Eswatini"] <-  "Swaziland"
    
    #removing part of string
    f3$Commodity.x <- substring(f3$Commodity.x, 9, nchar(f3$Commodity.x))
    #copying missing commodity into y column.
    f3$Commodity.y <- ifelse(is.na(f3$Commodity.y), f3$Commodity.x, f3$Commodity.y)
    #checking identity id TRUE.
    identical(f3$Commodity.y, f3$Commodity.x)
    identical(f3$Partner.x, f3$Partner.y)
    
    colnames(f3)[7] <- "TradeValue"
    
    f4 <- f3 %>%
      select(Partner.y, Commodity.Code, Commodity.y, TradeValue)
    
    colnames(f4) <- c("Partner", "Code", "Commodity", "TradeValue")
    
    f4$TradeValue[is.na(f4$TradeValue == TRUE)] <- 0
    f4$Year <- substr(i, 1, 4)
    #changing location is important.
    write.csv(f4, paste0(codo2$country.name[codo2$country.code == j], "/export/", i), row.names = F)
    
  }
  setwd("D:/Git/git_reserve")
}
```

Dressing the data of imports
----------------------------

The same set of steps as mentioned prior to above function are repeated
here below as well. Except that this time the storage folder is imports.

``` r
for (j in codo1){
  setwd(paste0(codo2$country.name[codo2$country.code == j], "/import"))
  cnx <- list.files()
  for (i in cnx){
    f1 <- read.csv(i, stringsAsFactors = F)
    f2 <- f1 %>%
      select("Partner.Code"
             , "Partner"
             , "Commodity.Code"
             , "Commodity"
             , "Trade.Value..US..")
    
    f2$Partner.Code <- as.character(f2$Partner.Code)
    f2$Commodity.Code <- as.character(f2$Commodity.Code)
    
    f3 <- left_join(s4p1, f2, by = c("Partner.Code", "Commodity.Code"))
    f3$Partner.y <- ifelse(is.na(f3$Partner.y), f3$Partner.x, f3$Partner.y)
    
    #several modified names are there.
    f3$Partner.y[f3$Partner.y == "China, Hong Kong SAR"] <- "Hong Kong"
    f3$Partner.y[f3$Partner.y == "Dem. People's Rep. of Korea"] <- "North Korea" 
    f3$Partner.y[f3$Partner.y == "Rep. of Korea"] <- "South Korea" 
    f3$Partner.y[f3$Partner.y == "Lao People's Dem. Rep."] <- "Laos"
    f3$Partner.y[f3$Partner.y == "Russian Federation"] <- "Russia"
    f3$Partner.y[f3$Partner.y == "Viet Nam"] <- "Vietnam"
    f3$Partner.y[f3$Partner.y == "United Arab Emirates"] <-  "UAE"
    f3$Partner.y[f3$Partner.y == "Bolivia (Plurinational State of)"] <-  "Bolivia"
    f3$Partner.y[f3$Partner.y == "Dem. Rep. of the Congo"] <-  "Congo Democratic"
    f3$Partner.y[f3$Partner.y == "CÃ´te d'Ivoire"] <-  "Cote de voire"
    f3$Partner.y[f3$Partner.y == "China, Macao SAR"] <-  "Macao"
    f3$Partner.y[f3$Partner.y == "Rep. of Moldova"] <-  "Moldova"
    f3$Partner.y[f3$Partner.y == "North Macedonia"] <-  "Macedonia"
    f3$Partner.y[f3$Partner.y == "United Rep. of Tanzania"] <-  "Tanzania"
    f3$Partner.y[f3$Partner.y == "Eswatini"] <-  "Swaziland"
    
    #removing part of string
    f3$Commodity.x <- substring(f3$Commodity.x, 9, nchar(f3$Commodity.x))
    #copying missing commodity into y column.
    f3$Commodity.y <- ifelse(is.na(f3$Commodity.y), f3$Commodity.x, f3$Commodity.y)
    #checking identity id TRUE.
    identical(f3$Commodity.y, f3$Commodity.x)
    identical(f3$Partner.x, f3$Partner.y)
    
    colnames(f3)[7] <- "TradeValue"
    
    f4 <- f3 %>%
      select(Partner.y, Commodity.Code, Commodity.y, TradeValue)
    
    colnames(f4) <- c("Partner", "Code", "Commodity", "TradeValue")
    
    f4$TradeValue[is.na(f4$TradeValue == TRUE)] <- 0
    f4$Year <- substr(i, 1, 4)
    #changing location is important.
    write.csv(f4, paste0(codo2$country.name[codo2$country.code == j], "/import/", i), row.names = F)
    
  }
  setwd("D:/Git/git_reserve")
}
```
