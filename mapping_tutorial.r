setwd("/home/spnichol/Dropbox/mapping_tutorial")
library(cartography) #read in map-making package
library(rgdal) #read in general GIS package 
library(stringr) #read in string manipulation package 

owner_url <- "https://data.cityofnewyork.us/api/views/tesw-yqqr/rows.csv?accessType=DOWNLOAD"
owners <- download.file(owner_url, destfile="", method="auto")
