setwd("D:/R5b/comtrade4/cmtr_dnld")

# this code is for downloading S4 at AG5 level of export data.
# ag5 specific code for some commodities.
basdir <- "D:/R5b/comtrade4"
setwd("D:/R5b/comtrade4/cmtr_dnld")
######################################################
#list of ag5 commodities. Use %2C%20 to connect ag5 values.
iron <- read.csv("D:/R5b/comtrade4/st_class/s4ag5_iron.csv")
q <- c(unique(iron$Commodity.Code))
length(q) # cc code is limited to 20 only.
#creating string for commodity code query limiting to 20 codes.
rr <- split(q, ceiling(seq_along(q)/20)) #split into chunks of 20.
rr
qq <- list()

for(j in 1:length(rr)){
  p = ""
  i = ""
  for (i in rr[j]){
    p = strsplit(paste(i, collapse="%2C%20"), ' ')[[1]]
  }
  qq <- append(qq, p)
}
sapply(qq,class)
qq

######################################################    

get.Comtrade <- function(url="http://comtrade.un.org/api/get?"
                         ,maxrec=100000
                         ,type="C"
                         ,freq="A"
                         ,px="S4"
                         ,ps="2016"
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
#######################################################
year <- as.character(c(2009:2018))

codo <- read.csv(paste0(basdir, "/st_class/partner_list.csv"), stringsAsFactors = F)

#using 699 for India.
codo1 <- c(699) 
names(codo)

library(dplyr)
library(tidyverse)
codo2 <- codo %>%
  filter(country.code %in% codo1)
#creating all the folder of countries and the export and import folders in a single go.
setwd("D:/R5b/comtrade4/cmtr_dnld")

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
'''
as you run the code below automatically the data for each year will be stored in csv file
with name. the panel format will give all the country names and commodity in a uniform format 
for each year. the 0 values are added to those country where no entry is given.
'''
##########################################
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

#-------------------------------
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


#################################
#################################
#################################