# this code transposes the tables and spreads the data into panel framework.

setwd("D:/R5b/comtrade4/dt_dressing")

aa <- list.files(pattern = "*.csv", recursive = T)
length(aa)

library(dplyr)
library(tidyverse)

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

