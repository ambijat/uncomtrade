library(rjson)

project_directory <- getwd()

uncomtrade_partners <- fromJSON(file = "partnerAreas.json")
#converting from json to dataframe format.
#this is done to get 2 columns of country_code and country_name.
# You can pass directly the filename
df <- lapply(uncomtrade_partners, function(results) # Loop through each "results"
{
  data.frame(matrix(unlist(results), ncol=2, byrow=T))
})

df <- do.call(rbind, df)
rownames(df) <- 1:nrow(df)

df <- df[-1,] 
#write.csv(df, "uncomtrade_partners_original.csv")
# this file needs to be opened and formatted.
# the formatted file is title as "uncomtrade_partners.csv"
######################################

string <- "classificationS4.json"

reporters <- fromJSON(file=string)

df <- lapply(reporters, function(results)
{
  data.frame(matrix(unlist(results), ncol=3, byrow=T))
})

# Now you have a list of data frames, connect them together in
# one single dataframe
df <- do.call(rbind, df)
df <- df[-(1:2),] 
rownames(df) <- 1:nrow(df)
#write.csv(df, "s4class.csv")

###########################################
# here the AG at level4 is being selected.
df1 <- df[nchar(df$X1) == 5, ]
df2 <- df1[!grepl("X",df1$X1), ]
rownames(df2) <- 1:nrow(df2)

df4 <- subset(df2, select = c("X1", "X2"))
colnames(df4)[1] <- "Commodity"
#############################################
#############################################

library(dplyr)
library(tidyverse)
## PREPARE COUNTRY LISTS  
# this is already present file.
pd <- read.csv("uncomtrade_partners.csv", stringsAsFactors = F)
pd <- pd[!grepl("Antarctica", pd$V2), ]
pd <- subset(pd, select = c(V1, V2))
colnames(pd) <- c("Partner.Code", "Partner")
####################################
#combining reporter lista nd s4

sa <- merge(df4, pd)
colnames(sa) <- c("Commodity.Code", "Commodity", "Partner.Code", "Partner")
#write.csv(sa, "s4ag5_partner.csv", row.names = F)

#################################
#################################
# NEW METHOD FOR GETTING SPECIFIC COMMODITY PARTERNS.
#an example of getting iron product codes.
iron <- df4 %>%
  filter(grepl("[I|i]ron", X2))

q <- c(unique(iron$Commodity))

df6 <- df4 %>%
  filter(Commodity %in% q)

#combining partner list with commodity list.
sa_2 <- merge(df6, pd)
colnames(sa_2) <- c("Commodity.Code", "Commodity", "Partner.Code", "Partner")
#write.csv(sa_2, "s4ag5_iron.csv", row.names = F)
# Using this file for iron data.

