rm(list=ls())
setwd("/Users/AaronXu/Research_Project/Product Design/Data Analysis/The raw data")
library(openxlsx)
data1 <- read.xlsx("ProductDesign.xlsx")

table(data1$Version)

# extract each version from the Mturk dataset one and form sub dataset
version.names <- unique(data1$Version)
version.names <- version.names[-1]


for (i in 1:16) {
  
  data0 <- data1[data1$Version==version.names[i] & !is.na(data1$Version),]
  data0 <- data0[colSums(!is.na(data0))>0]
  xname <- paste("data", version.names[i], sep="-")
  cat("", xname)
  assign(xname, data0)
}


# extract each version from the Mturk dataset two and form sub dataset
data2 <- read.xlsx("ProductDesign_extra.xlsx")
version.names <- unique(data2$Version)
version.names <- version.names[1:8]

for (i in 1:8) {
  data0 <- data2[data2$Version==version.names[i] & !is.na(data2$Version),]
  data0 <- data0[colSums(!is.na(data0))>0]
  xname <- paste("data-new", version.names[i], sep="-")
  cat("", xname)
  assign(xname, data0)
}


# merge the subdatasets of the two Mturks 
for (i in 1:8) {
  
  xname1 <- paste("data",version.names[i],sep="-")
  xname2 <- paste("data-new", version.names[i], sep="-")
  cat("", xname1)
  cat("", xname2)
  assign(xname1, rbind(get(xname1), get(xname2)))
  
}

# Rename variables 
version.names <- unique(data1$Version)
version.names <- version.names[-1]

for (i in 1:16){
  
  xname1 <- paste("data",version.names[i],sep="-")
  data0 <- get(xname1) 
  colnames(data0)[c(17:23)]<- c("WTP","gender","age","country","language",
                                "education","leisure-pen")
  data0 <- data0[,c(9,14:23,27)]
  assign(xname1, data0)
}

# rename variable by each version 
colnames(`data-AH-FMa`)[c(2,3,4)] <- c("aesthetic","fun1","fun2")
colnames(`data-AH-FMb`)[c(2,3,4)] <- c("aesthetic","fun2","fun1")
colnames(`data-AHNE-FMa`)[c(2,3,4)] <- c("fun1","fun2","aesthetic")
colnames(`data-AHNE-FMb`)[c(2,3,4)] <- c("fun2","fun1","aesthetic")
colnames(`data-AL-FMa`)[c(2,3,4)] <- c("aesthetic","fun1","fun2")
colnames(`data-AL-FMb`)[c(2,3,4)] <- c("aesthetic","fun2","fun1")
colnames(`data-ALNE-FMa`)[c(2,3,4)] <- c("fun1","fun2","aesthetic")
colnames(`data-ALNE-FMb`)[c(2,3,4)] <- c("fun2","fun1","aesthetic")


colnames(`data-FLa`)[c(2,3,4)] <- c("fun1","fun2","aesthetic")
colnames(`data-FLb`)[c(2,3,4)] <- c("fun2","fun1","aesthetic")
colnames(`data-FLNEa`)[c(2,3,4)] <- c("aesthetic","fun1","fun2")
colnames(`data-FLNEb`)[c(2,3,4)] <- c("aesthetic","fun2","fun1")

colnames(`data-FHa`)[c(2,3,4)] <- c("fun1","fun2","aesthetic")
colnames(`data-FHb`)[c(2,3,4)] <- c("fun2","fun1","aesthetic")
colnames(`data-FHNEa`)[c(2,3,4)] <- c("aesthetic","fun1","fun2")
colnames(`data-FHNEb`)[c(2,3,4)] <- c("aesthetic","fun2","fun1")

# merge all version to one data  
data_all <- Reduce(function(x,y) rbind(x,y, all=TRUE), 
    list(`data-AH-FMa`,`data-AH-FMb`,`data-AL-FMa`,`data-AL-FMb`,
         `data-AHNE-FMa`,`data-AHNE-FMb`,`data-ALNE-FMa`,`data-ALNE-FMb`,
         `data-FHa`,`data-FHb`,`data-FLa`,`data-FLb`,
         `data-FHNEa`,`data-FHNEb`,`data-FLNEa`,`data-FLNEb`))
data_all <- data_all[data_all$Version!=TRUE,]

library("foreign")
write.dta(data_all,"aesthetic.dta")

