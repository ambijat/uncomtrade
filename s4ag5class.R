'''
this is for creating a panel of partners with all the s4 level commodities at ag level 5
so that the panel gets its data filled from uncomtrade download.
'''
#reading the commodities of s4 class from json file.
string <- "classificationS4.json"
library(rjson)

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
# here the AG at level5 is being selected.
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
pd <- read.csv("partner_list.csv", stringsAsFactors = F)
colnames(pd) <- c("Partner.Code", "Partner")

####################################
#combining partner list and s4

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
# Using this file for iron data.
#write.csv(sa_2, "s4ag5_iron.csv", row.names = F)



