#this code is for s4ag5_iron only so the partner_list is only for iron products from st_class folder.


basdir <- "D:/R5b/comtrade4"
setwd("D:/R5b/comtrade4/dt_dressing")

#creating the folders for storing dressed up data.
codo <- read.csv(paste0(basdir, "/st_class/partner_list.csv"), stringsAsFactors = F) 
codo1 <- c(699)

#########################################

library(dplyr)
library(tidyverse)
codo2 <- codo %>%
  filter(country.code %in% codo1)

#creating all the folder of countries and the export and import folders in a single go.
# if the folder exists it will not create otherwise it will create folder based on codo1.

for (i in codo1){
  subdir <- as.name(codo2$country.name[codo2$country.code == i])
  ifelse(!dir.exists(file.path(getwd(), subdir)),
         dir.create(file.path(getwd(), subdir)), FALSE)
  ifelse(!dir.exists(paste0(file.path(getwd(), subdir), "/export")), 
         dir.create(paste0(file.path(getwd(), subdir), "/export")), FALSE)
  ifelse(!dir.exists(paste0(file.path(getwd(), subdir), "/import")),
         dir.create(paste0(file.path(getwd(), subdir), "/import")), FALSE)
}

##########################################

#only for iron products
s4p <- read.csv(paste0(basdir, "/st_class/s4ag5_iron.csv"), stringsAsFactors = F) 

s4p1 <- s4p %>%
  select(Partner.Code, Partner, Commodity.Code, Commodity) %>%
  mutate(Partner.Code = as.character(Partner.Code)) %>%
  mutate(Commodity.Code = as.character(Commodity.Code)) # again problem due to cmtr_dnld

#################################################

# now dressing the data of exports that is present in cmtr_dnld

for (j in codo1){
  setwd(paste0(basdir, "/cmtr_dnld/", codo2$country.name[codo2$country.code == j], "/export"))
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
    f3$Partner.y[f3$Partner.y == "Côte d'Ivoire"] <-  "Cote de voire"
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
    write.csv(f4, paste0(basdir, "/dt_dressing/", codo2$country.name[codo2$country.code == j], "/export/", i), row.names = F)
    
  }
  setwd(basdir)
}

############################################
############################################

# dressing the data of imports that is present in cmtr_dnld

for (j in codo1){
  setwd(paste0(basdir, "/cmtr_dnld/", codo2$country.name[codo2$country.code == j], "/import"))
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
    f3$Partner.y[f3$Partner.y == "Côte d'Ivoire"] <-  "Cote de voire"
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
    write.csv(f4, paste0(basdir, "/dt_dressing/", codo2$country.name[codo2$country.code == j], "/import/", i), row.names = F)
    
  }
  setwd(basdir)
}
