
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

head(bldg_counts)


pluto_bk <- read.csv("pluto.csv")
names(pluto_bk)

pluto_bk <- pluto_bk[, c(4, 5, 6, 58,71, 73, 74, 75)]
names(pluto_bk)

#subset dataframe for just Brooklyn 
bldg_counts  <- bldg_counts [bldg_counts $BoroID == 3 ,]

#create new columns with padded values 
bldg_counts ["New_Block"] <- lapply(bldg_counts ["Block"], function(x) sprintf("%05d", x))
bldg_counts ["New_Lot"] <- lapply(bldg_counts ["Lot"], function(x) sprintf("%04d", x))

#use paste function to combine everything into one variable 
bldg_counts ["BBL"] <- as.numeric(paste(bldg_counts $BoroID, bldg_counts $New_Block, bldg_counts $New_Lot, sep=""))

head(bldg_counts$BBL, n=15)

names(pluto_bk)
pluto_bk <- pluto_bk[, c(5, 2)]
nrow(bldg_counts)

bldg_counts <- merge(x=bldg_counts, y=pluto_bk1, by="BBL")
nrow(bldg_counts)

#aggregate by census tract 
over_one <- bldg_counts[bldg_counts$Building_Count > 2 ,]
tract_counts <- aggregate(Building_Count ~ CT2010, data=over_one, FUN=length )
nrow(tract_counts)
length(unique(pluto_bk$CT2010))

names(tract_counts)[1] <- "NAME10"
