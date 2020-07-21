Downloading Data from UN Comtrade API
-------------------------------------

This page sets the query parameters and sends them to API for fetching
the data. Since, there are usage restrictions to the number of requests
that can be pulled by a guest user. The same shall be borne in mind
while fetching the data.

### Loading the commodity classification CSV

The list of iron products derived in previous step was stored in
s4ag5\_iron.csv file. The same is being loaded.

``` r
iron <- read.csv("D:/Git/UNComtrade/s4ag5_iron.csv")
q <- c(unique(iron$Commodity.Code))
length(q)
```

    ## [1] 54

``` r
head(q)
```

    ## [1] 27862 27861 28231 28233 52254 67121

Since, the UN Comtrade API portal limits the specific queries to a batch
of 20 one at a time. Therefore, we will split the block of 54
commodities into the batches of 20 as shown below.

``` r
rr <- split(q, ceiling(seq_along(q)/20))
rr
```

    ## $`1`
    ##  [1] 27862 27861 28231 28233 52254 67121 67122 67123 67131 67132 67133 67241
    ## [13] 67245 67611 67619 67621 67629 67633 67643 67644
    ## 
    ## $`2`
    ##  [1] 67681 67682 67683 67684 67685 67686 67701 67709 67912 67913 67914 67911
    ## [13] 67951 67959 69211 69241 69243 69311 69731 69732
    ## 
    ## $`3`
    ##  [1] 69733 69741 69744 69751 69931 69932 69961 69962 69963 69965 69967 69969
    ## [13] 73731 77584

Now as to impute the above 3 strings into query we need to put comma
sign \[,\] in between those queries. This is not done by actually
putting the sign, instead a string \[“%2C%20”\] is used to insert the
comma sign in between the two codes.

This is done as follows.

-   First by creating empty list qq.
-   Iterating the string \[“%2C%20”\] for each string in rr.
-   Finally appending the results into qq.

``` r
qq <- list()
for(j in 1:length(rr)){
  p = ""
  i = ""
  for (i in rr[j]){
    p = strsplit(paste(i, collapse="%2C%20"), ' ')[[1]]
  }
  qq <- append(qq, p)
}
```

Now if see the output we will be able to understand the work done by the
code above.

``` r
sapply(qq,class)
```

    ## [1] "character" "character" "character"

``` r
qq
```

    ## [[1]]
    ## [1] "27862%2C%2027861%2C%2028231%2C%2028233%2C%2052254%2C%2067121%2C%2067122%2C%2067123%2C%2067131%2C%2067132%2C%2067133%2C%2067241%2C%2067245%2C%2067611%2C%2067619%2C%2067621%2C%2067629%2C%2067633%2C%2067643%2C%2067644"
    ## 
    ## [[2]]
    ## [1] "67681%2C%2067682%2C%2067683%2C%2067684%2C%2067685%2C%2067686%2C%2067701%2C%2067709%2C%2067912%2C%2067913%2C%2067914%2C%2067911%2C%2067951%2C%2067959%2C%2069211%2C%2069241%2C%2069243%2C%2069311%2C%2069731%2C%2069732"
    ## 
    ## [[3]]
    ## [1] "69733%2C%2069741%2C%2069744%2C%2069751%2C%2069931%2C%2069932%2C%2069961%2C%2069962%2C%2069963%2C%2069965%2C%2069967%2C%2069969%2C%2073731%2C%2077584"

Using the Comtrade API function
-------------------------------

The next few lines of code give the Comtrade API function and a list of
parameters is needed for the function to work out the desired query.

This function is provided by the UN Comtrade itself, which can be
modified according to the needs of the code we intend to write. Those
whoe are interested more on this can find further details on the
[webpage](https://comtrade.un.org/data/Doc/api/ex/r) here.

I you go through the parameters required for the function then their
explanation is as follows.

-   url - it is the link to the API.
-   maxrec - for a guest user 100000 is the maximum limit, we are using
    the same.
-   type - here “C” is for commodities
-   freq - here “A” is for annual
-   px - for classification type, we are using “S4” here.
-   ps - time period. This has a limitation of 5 years but we will use
    10 year range and by pass the limitation in the subsequent code
    below.
-   r - the reporter country, whose data we want to download. This case
    we are using only India, however we can use a range of maximum 5
    countrie as per UN Comtrade limitation. But this limitation can also
    be by passed in our code below.
-   p - the partner countries, who are trading with reporter countries.
    We have already created the panel of 156 countries in our
    partner\_list code.
-   rg - direction of the trade, “1” for import and “2” is for export
-   cc - this is the aggregate level at which the data is to be
    collected. We are taking here AG5.
-   fmt - file format for download. csv or json. We will be downloading
    in csv format.

``` r
options(scipen=999)
get.Comtrade <- function(url="http://comtrade.un.org/api/get?"
                         ,maxrec=100000
                         ,type="C"
                         ,freq="A"
                         ,px="S4"
                         ,ps
                         ,r
                         ,p
                         ,rg
                         ,cc
                         ,fmt="csv"
)
{
  string<- paste(url
                 ,"max=",maxrec,"&" #maximum no. of records returned
                 ,"type=",type,"&" #type of trade (c=commodities)
                 ,"freq=",freq,"&" #frequency
                 ,"px=",px,"&" #classification
                 ,"ps=",ps,"&" #time period
                 ,"r=",r,"&" #reporting area
                 ,"p=",p,"&" #partner country
                 ,"rg=",rg,"&" #trade flow
                 ,"cc=",cc,"&" #classification code
                 ,"fmt=",fmt        #Format
                 ,sep = ""
  )
  
  if(fmt == "csv") {
    raw.data<- read.csv(string,header=TRUE)
    return(list(validation=NULL, data=raw.data))
  } else {
    if(fmt == "json" ) {
      raw.data<- fromJSON(file=string)
      data<- raw.data$dataset
      validation<- unlist(raw.data$validation, recursive=TRUE)
      ndata<- NULL
      if(length(data)> 0) {
        var.names<- names(data[[1]])
        data<- as.data.frame(t( sapply(data,rbind)))
        ndata<- NULL
        for(i in 1:ncol(data)){
          data[sapply(data[,i],is.null),i]<- NA
          ndata<- cbind(ndata, unlist(data[,i]))
        }
        ndata<- as.data.frame(ndata)
        colnames(ndata)<- var.names
      }
      return(list(validation=validation,data =ndata))
    }
  }
}
```

Creating the Country folder for storage
---------------------------------------

The CSV files for each year would be downloaded for a period from 2009
to 2018, i.e., 10 files for 10 years. The partner\_list file is loaded
for getting the code of the reported country, which in this case is
India. India’s code is 699.

``` r
year <- as.character(c(2009:2018))

codo <- read.csv("D:/Git/UNComtrade/partner_list.csv", stringsAsFactors = F)

#using 699 for India.
codo1 <- c(699) 
names(codo)
```

Intializing the libraries

``` r
library(dplyr)
library(tidyverse)
```

    ## Warning: package 'ggplot2' was built under R version 4.0.2

We will use it as a variable to create first folder with the name India
and in it there will be 2 separate folders will be created for export
and import.

``` r
codo2 <- codo %>%
  filter(country.code %in% codo1)

for (i in codo1){
  subdir <- as.name(codo2$country.name[codo2$country.code == i])
  ifelse(!dir.exists(file.path(getwd(), subdir)),
         dir.create(file.path(getwd(), subdir)), FALSE)
  ifelse(!dir.exists(paste0(file.path(getwd(), subdir), "/export")), 
         dir.create(paste0(file.path(getwd(), subdir), "/export")), FALSE)
  ifelse(!dir.exists(paste0(file.path(getwd(), subdir), "/import")),
         dir.create(paste0(file.path(getwd(), subdir), "/import")), FALSE)
}
```

Using the Comtrade function
---------------------------

Now we are ready to run the function for downloading the data as CSV
files. For each individual year the files will be downloaded in the
country folder and the sub-folder as the case may be of import and
export.

An if-else command is used below which has a specific use. As the query
is being made for the 3 strings (if you remember we created in variable
qq). The iteration for each string shall give headers for columns and we
do not want headers for each time data is appended except the first
time. So, we solve that puzzle by using if-else command.

Once again to harmonize with the query limitation we use a time lapse of
1 minute within te loop after each country. Since here it is only 1
reporter country India its effect wont be noticed.

``` r
#for export.

for (j in codo1){
  cn2 = 0
  for (i in year){
    cn1 = 0
    for (k in qq){
      s2 <- get.Comtrade(r=j, rg = "2", cc=k, p="all", ps = i, fmt="csv")
      if (cn1 == 0){
        write.table(s2$data, paste0(getwd(), "/", codo2$country.name[codo2$country.code == j], "/export/", i, ".csv"), 
                    append = T, row.names = F, col.names = T, sep = ",")
      }
      else {
        write.table(s2$data, paste0(getwd(), "/", codo2$country.name[codo2$country.code == j], "/export/", i, ".csv"), 
                    append = T, row.names = F, col.names = F, sep = ",")
      }
      cn1 = cn1 + 1
    }
    cn2 = cn2 + 1
    if (cn2 == 3) {
      Sys.sleep(3) # delay of 1 minute after every 3 years data to avoid connection errors.
    }
  }
}
```

The query for export and import are 2 separate functions. Hence, once
the first query is run then the second query of import shall be run to
download the import data in respective folders.

``` r
#for import.

for (j in codo1){
  cn2 = 0
  for (i in year){
    cn1 = 0
    for (k in qq){
      s2 <- get.Comtrade(r=j, rg = "1", cc=k, p="all", ps = i, fmt="csv")
      if (cn1 == 0){
        write.table(s2$data, paste0(getwd(), "/", codo2$country.name[codo2$country.code == j], "/import/", i, ".csv"), 
                    append = T, row.names = F, col.names = T, sep = ",")
      }
      else {
        write.table(s2$data, paste0(getwd(), "/", codo2$country.name[codo2$country.code == j], "/import/", i, ".csv"), 
                    append = T, row.names = F, col.names = F, sep = ",")
      }
      cn1 = cn1 + 1
    }
    cn2 = cn2 + 1
    if (cn2 == 3) {
      Sys.sleep(3) # delay of 1 minute after every 3 years data to avoid connection errors.
    }
  }
}
```

After successfully running this code the structure of raw data shall
emerge as shown here
[India](https://github.com/ambijat/uncomtrade/tree/master/India_iron_raw).
The github names have been modified only to indicate the folder of raw
data and the processed data.
