
setwd("/home/spnichol/Dropbox/mapping_tutorial")
#install neccesary packages 
install.packages(c("cartography", "rgdal", "stringr"))

library(cartography) #read in map-making package
library(rgdal) #read in general GIS package 
library(stringr) #read in string manipulation package 


#ownership registrations 
owners <- read.csv("owners.csv")
#building data 
bldgs <- read.csv("bldg.csv")

head(owners)


owner_count <- aggregate(RegistrationID ~ RegistrationContactID, data=owners, FUN=length)
names(owner_count) <- c("RegistrationContactID", "Building_Count")
head(owner_count)
nrow(owner_count[owner_count$Building_Count > 2 ,])


org_agg <- aggregate(RegistrationID ~ CorporationName, data=owners, FUN=length)
nrow(org_agg[org_agg$RegistrationID > 2 ,])
org_agg <- aggregate(RegistrationID ~ CorporationName, data=owners, FUN=length)
names(org_agg) <- c("CorporationName", "Building_Count")
nrow(org_agg[org_agg$Building_Count > 2 ,])


org_agg$CorporationName<- gsub("[^[:alnum:][:blank:]]", "", org_agg$CorporationName)
org_agg <- org_agg[org_agg$CorporationName !="" ,]
head(org_agg)
nrow(org_agg[org_agg$Building_Count > 2 ,])



owners$RealID <- paste(owners$BusinessHouseNumber, owners$BusinessStreetName, sep=" ")
real_agg <- aggregate(RegistrationID ~ RealID, data=owners, FUN=length)
names(real_agg) <- c("RealID", "Building_Count")
nrow(real_agg[real_agg$Building_Count > 2 ,])


summary(owners$Type)

owners <- owners[! duplicated(owners$RegistrationID) ,]
real_agg <- aggregate(RegistrationID ~ RealID, data=owners, FUN=length)
names(real_agg) <- c("RealID", "Building_Count")
nrow(real_agg[real_agg$Building_Count > 2 ,])


#merge building count with owner DF
owners <- merge(x=owners, y=real_agg, by="RealID")

head(bldgs)

bldg_counts <- merge(x=bldgs, y=owners, by="RegistrationID")

bldg_counts <- bldg_counts[! is.na(bldg_counts$Building_Count) ,]
