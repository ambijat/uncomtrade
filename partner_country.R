setwd("D:/R5b")
'''
this script is to filter the list of country based on ther GDP for defining the variables for panel data.
'''
library(dplyr)
library(tidyverse)

library(WDI)
#searching for Gross National Income (GNI)
WDIsearch("gni")
#this indicator is for GNI ar current USD.
indicator <- "NY.GNP.MKTP.CD"
wdi_cat <- WDI(indicator = indicator, start = 2010, end = 2010, extra = T)
names(wdi_cat)
wdi2 <- wdi_cat %>%
  select("country", "NY.GNP.MKTP.CD", "iso3c")

#loading country_list from excel file downloaded from
#https://unstats.un.org/unsd/tradekb/Knowledgebase/50377/Comtrade-Country-Code-and-Name
library(readxl)
country_list <- read_excel("comtradecountry_nowlist.xlsx")
#renaming the columns
colnames(country_list) <- c("country.code", "country.name", "iso3c")

#joining the 2 dataframes
pp <- left_join(country_list, wdi2, by = "iso3c")
colnames(pp)[5] <- "GNI"
names(pp)
pp$share <- round((pp$GNI/6.594123e+13)*100, 2)
#removing NA rows by complete.cases
pp1 <- na.omit(pp)
pp2 <- pp1 %>%
  filter(share > 0) %>%
  select(country.code, country.name)

#this gives the list of those countries whose GNI was atleast above 0. So that only meaningful entities are listed for datadownloading.
write.csv(pp2, "partner_list.csv", row.names = F)
