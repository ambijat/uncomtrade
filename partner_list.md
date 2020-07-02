Creating a Partner List
-----------------------

The partners of trade are the variables in column each country that has
entered into trade with the reporting country. There almost 200
countries in the world. But, each is not significant enough to be
enlisted for its trade value. Therefore, some criteria needs to be set
up for selecting the range of column variables. And, here we can choose
**GNI**, the Gross National Income as the criterion for eliminating the
countries whose trade is assumed to non-significant.

#### WDI - World Development Indicators library

It is suitable for downloading the data for individual countries from
the world bank database.

``` r
library(WDI)
```

    ## Warning: package 'WDI' was built under R version 4.0.2

``` r
WDIsearch("gni.*current")
```

    ##      indicator           name                                           
    ## [1,] "NY.GNP.ATLS.CD"    "GNI, Atlas method (current US$)"              
    ## [2,] "NY.GNP.MKTP.CD"    "GNI (current US$)"                            
    ## [3,] "NY.GNP.MKTP.CN"    "GNI (current LCU)"                            
    ## [4,] "NY.GNP.MKTP.PC.CD" "GNI per capita (current US$)"                 
    ## [5,] "NY.GNP.MKTP.PP.CD" "GNI, PPP (current international $)"           
    ## [6,] "NY.GNP.PCAP.CD"    "GNI per capita, Atlas method (current US$)"   
    ## [7,] "NY.GNP.PCAP.CN"    "GNI per capita (current LCU)"                 
    ## [8,] "NY.GNP.PCAP.PP.CD" "GNI per capita, PPP (current international $)"

If you the name then “GNI (current US$)” is of relevance to us. We take
its indicator which is “NY.GNP.MKTP.CD” to find and import the GNI
figures for all the countries.

``` r
indicator <- "NY.GNP.MKTP.CD"
wdi_cat <- WDI(indicator = indicator, start = 2010, end = 2010, extra = T)
wdi_cat[1:10,]
```

    ##    iso2c                                       country NY.GNP.MKTP.CD year
    ## 1     1A                                    Arab World   2.091012e+12 2010
    ## 2     1W                                         World   6.599366e+13 2010
    ## 3     4E   East Asia & Pacific (excluding high income)   7.824143e+12 2010
    ## 4     7E Europe & Central Asia (excluding high income)   2.858405e+12 2010
    ## 5     8S                                    South Asia   2.058046e+12 2010
    ## 6     AD                                       Andorra             NA 2010
    ## 7     AE                          United Arab Emirates   2.897035e+11 2010
    ## 8     AF                                   Afghanistan   1.588451e+10 2010
    ## 9     AG                           Antigua and Barbuda   1.120980e+09 2010
    ## 10    AL                                       Albania   1.180722e+10 2010
    ##    iso3c region          capital longitude latitude income lending
    ## 1    ARB     NA                                         NA        
    ## 2    WLD     NA                                         NA        
    ## 3    EAP     NA                                         NA        
    ## 4    ECA     NA                                         NA        
    ## 5    SAS     NA                                         NA        
    ## 6    AND     Z7 Andorra la Vella    1.5218  42.5075     XD      XX
    ## 7    ARE     ZQ        Abu Dhabi   54.3705  24.4764     XD      XX
    ## 8    AFG     8S            Kabul   69.1761  34.5228     XM      XI
    ## 9    ATG     ZJ     Saint John's  -61.8456  17.1175     XD      XF
    ## 10   ALB     Z7           Tirane   19.8172  41.3317     XT      XF

As you can see a sample of 10 rows where the country codes and GNI
figures (“NY.GNP.MKTP.CD” column) are given is presented. And, we will
be needing only the some of these columns for our data processing.

``` r
names(wdi_cat)
```

    ##  [1] "iso2c"          "country"        "NY.GNP.MKTP.CD" "year"          
    ##  [5] "iso3c"          "region"         "capital"        "longitude"     
    ##  [9] "latitude"       "income"         "lending"

``` r
wdi2 <- wdi_cat %>%
  select("country", "NY.GNP.MKTP.CD", "iso3c")
head(wdi2)
```

    ##                                         country NY.GNP.MKTP.CD iso3c
    ## 1                                    Arab World   2.091012e+12   ARB
    ## 2                                         World   6.599366e+13   WLD
    ## 3   East Asia & Pacific (excluding high income)   7.824143e+12   EAP
    ## 4 Europe & Central Asia (excluding high income)   2.858405e+12   ECA
    ## 5                                    South Asia   2.058046e+12   SAS
    ## 6                                       Andorra             NA   AND

So, there are 3 columns for our need, 1. country, 2. NY.GNP.MKTP.CD, 3.
iso3c.

The last one is the country code that is necessary for joining the
dataframe with our partners list we have.

Loading country\_list from excel file downloaded from the UN Comtrade
database.

<a href="https://unstats.un.org/unsd/tradekb/Knowledgebase/50377/Comtrade-Country-Code-and-Name" class="uri">https://unstats.un.org/unsd/tradekb/Knowledgebase/50377/Comtrade-Country-Code-and-Name</a>

``` r
library(readxl)
country_list <- read_excel("comtradecountry_nowlist.xlsx")
```

renaming the columns of the dataframe

``` r
colnames(country_list) <- c("country.code", "country.name", "iso3c")
head(country_list)
```

    ## # A tibble: 6 x 3
    ##   country.code country.name   iso3c
    ##          <dbl> <chr>          <chr>
    ## 1            4 Afghanistan    AFG  
    ## 2            8 Albania        ALB  
    ## 3           12 Algeria        DZA  
    ## 4           16 American Samoa ASM  
    ## 5           20 Andorra        AND  
    ## 6           24 Angola         AGO

The WDI data is joined with the country\_list so as to match the GNI for
UN Comtrade list countries.

``` r
pp <- left_join(country_list, wdi2, by = "iso3c")
colnames(pp)[5] <- "GNI"
names(pp)
```

    ## [1] "country.code" "country.name" "iso3c"        "country"      "GNI"

After joining the datasets the share of each country’s GNI against the
world GNI is calculated. A new column share is created for enlisting the
ratios of each country’s GNI.

``` r
pp$share <- round((pp$GNI/6.594123e+13)*100, 2)
head(pp)
```

    ## # A tibble: 6 x 6
    ##   country.code country.name   iso3c country                  GNI share
    ##          <dbl> <chr>          <chr> <chr>                  <dbl> <dbl>
    ## 1            4 Afghanistan    AFG   Afghanistan     15884505938.  0.02
    ## 2            8 Albania        ALB   Albania         11807221086.  0.02
    ## 3           12 Algeria        DZA   Algeria        160820354235.  0.24
    ## 4           16 American Samoa ASM   American Samoa           NA  NA   
    ## 5           20 Andorra        AND   Andorra                  NA  NA   
    ## 6           24 Angola         AGO   Angola          75712633817.  0.11

removing NA rows by using complete.cases

``` r
pp1 <- na.omit(pp)
nrow(pp)
```

    ## [1] 248

``` r
nrow(pp1)
```

    ## [1] 191

As you can see the complete cases are only 191 out of total cases of
248. Now filtering only those countries whose GNI share is above 0.

``` r
pp2 <- pp1 %>%
  filter(share > 0) %>%
  select(country.code, country.name)
nrow(pp2)
```

    ## [1] 156

The list of countries whose GNI is of some significance are 156 in
total. So, for the panel data the list of 156 countries would be used
for creating a block of matrix against the selected commodities. It
would allow us only meaningful entities for datadownloading.

``` r
write.csv(pp2, "partner_list.csv", row.names = F)
```

Above command shall export the list of 156 country.name and their
country.code in a comma separated file (csv).
