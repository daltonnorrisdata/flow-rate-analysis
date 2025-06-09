###Data clean up Dallas Tributaries ###
###           June 4 2025           ###

library(dplyr)
library(stringr)
library(hash)

library(openxlsx)

## Read Data ##

RawData = export.dall93.EAD.Airport.Tributaries

## Clean Data ##

#site names dictionary
#names, latitude, longitude 
snl = c("BCGolfNorth","BCGolfSouth","BCGolfTributary", "BCNorth/Glade", "BCSouth")
lat = c("32.86687778","32.85350556","32.86059722","32.880904","32.842645")
long = c("-97.06088333","-97.05380278", "-97.06263889", "-97.068123", "-97.041733")

#asociated col numbers as the keys
namesLength <- 2:11
keys =namesLength[which(namesLength %% 2 == 0 )]
#create empty dictionary 
sitenames = hash()

#set each key's value to be corresponding site name alt and long
for (i in 1:length(keys)) {
  sitenames[[as.character(keys[i])]] = c(snl[i], lat[i], long[i])
}

#Remove false timestamp at begining of table
newDF = tail(RawData, -1417)



## Create Table ##
BearCreekTab = matrix(,ncol =6)
 
colnames(BearCreekTab)= c("Date & Time", "Site Name", "Flow", "Depth", "Latitude", "Longitude")

#for each row if not empty match column with site name
for(r in 1: nrow(newDF)){
  #check if each column is empty
  for(c in 1:length(keys)){
    if(newDF[r,keys[c]]!=""){
      #not empty add to bear creek table
      date = newDF[r,1]
      #name, lat, long
      values = sitenames[[as.character(keys[c])]]
      #add to table in correct format 
      BearCreekTab= rbind( BearCreekTab,c(date, values[1], newDF[r,keys[c]], newDF[r,keys[c]+1], values[2], values[3]))
    
    }
  }
}

## Write to a csv##
# Put in your own path for the file name
write.csv(tail(BearCreekTab,-1), "Bear Creek Depth  Flow.csv",row.names = FALSE)
## Write to excel format ##
# Put in your own path for the file name
write.xlsx(tail(BearCreekTab,-1), "Bear Creek Depth  Flow.xlsx",rowNames = FALSE)
