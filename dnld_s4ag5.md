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
sing \[,\] in between those queries. This is not done by actually
putting the sign, instead a string \[“%2C%20”\] is used to insert the
comma sign in between each code.

This is done as follows. \* First by creating empty list qq. \*
Iterating the string \[“%2C%20”\] for each string in rr. \* Finally
appending the results into qq.

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
