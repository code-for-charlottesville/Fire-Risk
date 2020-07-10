library(plyr)
library(dplyr)
library(tidyr)

`%notin%` <- function(x,y) !(x %in% y)

addMaster <- read.csv("Data/Master_Address_Table.csv", stringsAsFactors = FALSE)

suff <- data.frame(SUFFIX = c("BYP", "GDNS"), TO = c("BYPASS", "GARDENS"), stringsAsFactors = FALSE)

addMaster <- addMaster %>%
  mutate(StreetNumber = gsub("[^0-9]", "", ST_NUMBER),
         StreetName = trimws(toupper(gsub('[^a-zA-Z0-9 ] | ("1/2")', "", ST_NAME))))

addMaster <- join_all(list(addMaster, suff), by = "SUFFIX")

addMaster$SUFFIX <- ifelse(!is.na(addMaster$TO), addMaster$TO, addMaster$SUFFIX)

addMaster$StreetName <- trimws(paste(addMaster$PREDIR, addMaster$StreetName, addMaster$SUFFIX, 
                                     addMaster$POSTDIR, sep = " "))

addMaster <- addMaster %>%
  select(StreetNumber, StreetName, Unit = ST_UNIT, ZIP, MasterAddressID, BIN) %>%
  distinct()

##RE Data
baseRE <- read.csv('Data/Real_Estate_Base_Data.csv', stringsAsFactors = FALSE)
clean <- data.frame(Base = grep("-[0-9]", baseRE$StreetNumber, value = TRUE), stringsAsFactors = FALSE) %>%
  separate(Base, c("Start", "End"), sep = "-", remove = FALSE) %>%
  filter(!grepl("[[:alpha:]]|(\\/)", Base)) %>%
  distinct()

clean$End <- ifelse((nchar(clean$Start) > nchar(clean$End)), 
                     paste(substr(clean$Start, 1, nchar(clean$Start) - nchar(clean$End)), clean$End, sep = ""),
                     clean$End)

ranges <- data.frame(StreetNumber = c(NA), StreetNumberRange=c(NA))

for (i in 1:nrow(clean)){
  if(as.numeric(clean$Start[i]) < as.numeric(clean$End[i])){
    rng <- as.numeric(clean$Start[i]):as.numeric(clean$End[i])
    ranges[(nrow(ranges)+1):((nrow(ranges))+length(rng)),] <- c(rep(clean$Base[i], length(rng)), rng)
  }
}
ranges <- ranges[complete.cases(ranges), ]

baseRE <- join_all(list(baseRE, ranges), by = "StreetNumber") %>%
  mutate(OrigStreetNumber = StreetNumber, RangeFlag = ifelse(!is.na(StreetNumberRange), "Yes", "No"))

baseRE$StreetNumber <- ifelse(!is.na(baseRE$StreetNumberRange), baseRE$StreetNumberRange, baseRE$StreetNumber)

baseRE <- baseRE %>%
  select(StreetNumber, StreetName, Unit, StateCode, GPIN, Zone, ParcelNumber, Acreage, OrigStreetNumber, RangeFlag) %>%
  mutate(StreetNumber = gsub("[^0-9]", "", StreetNumber),
         StreetName = trimws(toupper(gsub('[^a-zA-Z0-9 ] | ("1/2")', "", StreetName))),
         Index = row.names(.))

wUnit <- baseRE %>%
  filter(!is.na(Unit), Unit != "")

wUnitMatch <- join_all(list(addMaster, wUnit), by = c("StreetNumber", "StreetName", "Unit"), 
                      type = "left", match = "first") %>%
  distinct() %>%
  filter(!is.na(Index))

woUnit <- baseRE %>%
  filter(Index %notin% wUnit$Index) %>%
  select(-Unit)

noAddMatch <- addMaster %>%
  filter(MasterAddressID %notin% wUnitMatch$MasterAddressID)

woUnitMatch <- join_all(list(noAddMatch, woUnit), by = c("StreetNumber", "StreetName"), 
                        type = "left", match = "first") %>%
  distinct() %>%
  filter(!is.na(Index))

fullMatch <- rbind(wUnitMatch, woUnitMatch)

resRE <- read.csv('Data/Real_Estate_Residential_Details.csv', stringsAsFactors = FALSE)
resRE <- resRE %>%
  mutate(StreetNumber = gsub("[^0-9]", "", StreetNumber),
         StreetName = trimws(toupper(gsub("[^a-zA-Z0-9 ]", "", StreetName)))) %>%
  select(ParcelNumber, UseCode, Style, Grade, Roof, Heating, Fireplace, YearBuilt, TotalRooms, Bedrooms, 
         FullBathrooms, BasementGarage, Basement, FinishedBasement, BasementType, ExternalWalls, 
         NumberOfStories, SquareFootageFinishedLiving, resStreetName = StreetName, resStreetNumber = StreetNumber, 
         resUnit = Unit)

commRE <- read.csv('Data/Real_Estate_Commercial_Details.csv', stringsAsFactors = FALSE)
commRE <- commRE %>%
  mutate(StreetNumber = gsub("[^0-9]", "", StreetNumber),
         StreetName = trimws(toupper(gsub('[^a-zA-Z0-9 ] | ("1/2")', "", StreetName)))) %>%
  select(ParcelNumber, UseCode, YearBuilt, GrossArea, StoryHeight, NumberOfStories, commStreetName = StreetName, 
         commStreetNumber = StreetNumber, commUnit = Unit)

RE <- join_all(list(fullMatch, resRE, commRE), by = "ParcelNumber", type = "full") %>%
  distinct()

# dupes <- RE %>% 
#   count(ParcelNumber) %>% 
#   filter(n>1) %>%
#   select(ParcelNumber)
# 
# dupeRE <- RE %>%
#   filter(ParcelNumber %in% dupes$ParcelNumber)

##Parcel Data

areaPAR <- read.csv('Data/Parcel_Area_Details.csv', stringsAsFactors = FALSE)
areaPAR <- areaPAR %>%
  select(FileType, LotSquareFeet, TaxYear, Zoning, Assessment, 
         GPIN = GeoParcelIdentificationNumber, ParcelNumber, StreetNumber, StreetName, Unit) %>%
  mutate(StreetNumber = gsub("[^0-9]", "", StreetNumber),
         StreetName = trimws(toupper(gsub('[^a-zA-Z0-9 ] | ("1/2")', "", StreetName))))

pointsPAR <- read.csv('Data/Parcel_Owner_Points.csv', stringsAsFactors = FALSE)
pointsPAR <- pointsPAR %>%
  select(X, Y, GPIN = GeoParcelIdentificationNumber, OwnerName, ParcelNumber, StreetNumber, StreetName,
         Unit, ZipCode, Zone) %>%
  mutate(StreetNumber = gsub("[^0-9]", "", StreetNumber),
         StreetName = trimws(toupper(gsub('[^a-zA-Z0-9 ] | ("1/2")', "", StreetName))))

PAR <- join_all(list(areaPAR, pointsPAR), by = c("ParcelNumber", "GPIN"), type = "full", match = "first") %>%
  distinct()

##Permits and Structure

buildPER <- read.csv('Data/Building_Permits_Spatial_.csv', stringsAsFactors = FALSE)
buildPER <- buildPER %>%
  select(IssuedDate, ParcelNumber, SubType, Type, WorkDescription)

existSTR <- read.csv('Data/Existing_Structure_Area.csv', stringsAsFactors = FALSE)
existSTR <- existSTR %>%
  select(BIN, StreetNumber = ST_NUMBER, StreetName = STREET) %>%
  mutate(StreetNumber = gsub("[^0-9]", "", StreetNumber),
         StreetName = trimws(toupper(gsub('[^a-zA-Z0-9 ] | ("1/2")', "", StreetName))))

##Let's get wild

mainOut <- join_all(list(RE, PAR), by = "ParcelNumber", type ="full")
# mainOut <- join_all(list(mainOut, existSTR), by = c("StreetNumber", "StreetName"), type = "left", match = "first") %>%
  # distinct()

# mainOut %>% 
#   count(StreetNumber, StreetName, Unit, ParcelNumber) %>% 
#   View()
# 
# mainOut %>% group_by(StreetName, StreetNumber, Unit) %>% 
#   summarise(Parcels = length(unique(ParcelNumber))) %>% 
#   View()
  
write.csv(mainOut, "Data/Output.csv", row.names = FALSE)
