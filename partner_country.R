setwd("D:/R5b")
'''
this script is to filter the list of country based on ther GDP for defining the variables for
panel data.
'''
library(WDI)

WDIsearch("gni")
library(readxl)
country_list <- read_excel("comtradecountry_nowlist.xlsx")
colnames(country_list) <- c("country.code", "country.name", "iso3c")

#this indicator is for GNI ar current USD.
indicator <- "NY.GNP.MKTP.CD"
wdi_cat <- WDI(indicator = indicator, start = 2010, end = 2010, extra = T)
names(wdi_cat)

library(dplyr)
library(tidyverse)

wdi2 <- wdi_cat %>%
  select("country", "NY.GNP.MKTP.CD", "iso3c")

#joining the list
pp <- left_join(country_list, wdi2, by = "iso3c")
colnames(pp)[5] <- "GNI"
names(pp)
pp$share <- round((pp$GNI/6.594123e+13)*100, 2)
#removing NA rows by complete.cases
pp1 <- na.omit(pp)
pp2 <- pp1 %>%
  filter(share > 0) %>%
  select(country.code, country.name)

write.csv(pp2, "partner_list.csv", row.names = F)
