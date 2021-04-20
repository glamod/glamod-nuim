####read ISTI inventory file and add headers NOTE:error in column names will occur if no domain column is present.. fix remove DOMIAIN
INVENTORY_ANTARCTICA_AWS_daily <- read.table("ftp://ftp.ncdc.noaa.gov/pub/data/globaldatabank/daily/stage2/antarctica-aws/INVENTORY_ANTARCTICA-AWS_daily_stage2",header = TRUE, fill = TRUE)####enter URL link to file
colnames(INVENTORY_ANTARCTICA_AWS_daily) <- c("STATION_IDENTIFICATION_ NUMBER","STATION_NAME","LATITUDE","LONGITUDE","ELEVATION_METRES_ABS","DATA_START_YEAR","DATA_END_YEAR")
head(INVENTORY_ANTARCTICA_AWS_daily)
write.csv(INVENTORY_ANTARCTICA_AWS_daily,"C:/Users/67135099/Dropbox/Copernicus 2017/Inventory/ISTI_Daily/INVENTORY_ANTARCTICA_SCAR_READER_daily.csv")###write out csv file of inventory

INVENTORY_ANTARCTICA_PALMER_daily<- read.table("ftp://ftp.ncdc.noaa.gov/pub/data/globaldatabank/daily/stage2/antarctica-palmer/INVENTORY_ANTARCTICA-PALMER_daily_stage2",header = TRUE, fill = TRUE)####enter URL link to file
colnames(INVENTORY_ANTARCTICA_PALMER_daily) <- c("STATION_IDENTIFICATION_ NUMBER","STATION_NAME","LATITUDE","LONGITUDE","ELEVATION_METRES_ABS","DATA_START_YEAR","DATA_END_YEAR")
head(INVENTORY_ANTARCTICA_PALMER_daily)
write.csv(INVENTORY_ANTARCTICA_PALMER_daily,"C:/Users/67135099/Dropbox/Copernicus 2017/Inventory/ISTI_Daily/INVENTORY_ANTARCTICA_PALMER_daily.csv")###write out csv file of inventory

INVENTORY_ARGENTINA_daily <- read.table("ftp://ftp.ncdc.noaa.gov/pub/data/globaldatabank/daily/stage2/argentina/INVENTORY_ARGENTINA_daily_stage2",header = TRUE, fill = TRUE)####enter URL link to file
colnames(INVENTORY_ARGENTINA_daily) <- c("STATION_IDENTIFICATION_ NUMBER","STATION_NAME","LATITUDE","LONGITUDE","ELEVATION_METRES_ABS","DATA_START_YEAR","DATA_END_YEAR")
head(INVENTORY_ARGENTINA_daily)
write.csv(INVENTORY_ARGENTINA_daily,"C:/Users/67135099/Dropbox/Copernicus 2017/Inventory/ISTI_Daily/INVENTORY_ARGENTINA_daily.csv")###write out csv file of inventory

INVENTORY_AUSTRALIA_daily <- read.table("ftp://ftp.ncdc.noaa.gov/pub/data/globaldatabank/daily/stage2/australia/INVENTORY_AUSTRALIA_daily_stage2",header = TRUE, fill = TRUE)####enter URL link to file
colnames(INVENTORY_AUSTRALIA_daily) <- c("STATION_IDENTIFICATION_ NUMBER","STATION_NAME","DOMAIN","LATITUDE","LONGITUDE","ELEVATION_METRES_ABS","DATA_START_YEAR","DATA_END_YEAR")
head(INVENTORY_AUSTRALIA_daily )
write.csv(INVENTORY_AUSTRALIA_daily,"C:/Users/67135099/Dropbox/Copernicus 2017/Inventory/ISTI_Daily/INVENTORY_AUSTRALIA_daily.csv")###write out csv file of inventory


INVENTORY_BRAZIL_daily <- read.table("ftp://ftp.ncdc.noaa.gov/pub/data/globaldatabank/daily/stage2/brazil/INVENTORY_BRAZIL_daily_stage2",header = TRUE, fill = TRUE)####enter URL link to file
colnames(INVENTORY_BRAZIL_daily ) <- c("STATION_IDENTIFICATION_ NUMBER","STATION_NAME","DOMAIN","LATITUDE","LONGITUDE","ELEVATION_METRES_ABS","DATA_START_YEAR","DATA_END_YEAR")
head(INVENTORY_BRAZIL_daily )
write.csv(INVENTORY_BRAZIL_daily ,"C:/Users/67135099/Dropbox/Copernicus 2017/Inventory/ISTI_Daily/INVENTORY_BRAZIL_daily.csv")###write out csv file of inventory


INVENTORY_BRAZIL_INMET_daily<- read.table("ftp://ftp.ncdc.noaa.gov/pub/data/globaldatabank/daily/stage2/brazil-inmet/INVENTORY_BRAZIL-INMET_daily_stage2",header = TRUE, fill = TRUE)####enter URL link to file
colnames(INVENTORY_BRAZIL_INMET_daily) <- c("STATION_IDENTIFICATION_ NUMBER","STATION_NAME","DOMAIN","LATITUDE","LONGITUDE","ELEVATION_METRES_ABS","DATA_START_YEAR","DATA_END_YEAR")
head(INVENTORY_BRAZIL_INMET_daily)
write.csv(INVENTORY_BRAZIL_INMET_daily ,"C:/Users/67135099/Dropbox/Copernicus 2017/Inventory/ISTI_Daily/INVENTORY_BRAZIL_INMET_daily.csv")###write out csv file of inventory


INVENTORY_CHANNEL_ISLANDS_daily <- read.table("ftp://ftp.ncdc.noaa.gov/pub/data/globaldatabank/daily/stage2/channel-islands/INVENTORY_CHANNEL-ISLANDS_daily_stage2",header = TRUE, fill = TRUE)####enter URL link to file
colnames(INVENTORY_CHANNEL_ISLANDS_daily) <- c("STATION_IDENTIFICATION_ NUMBER","STATION_NAME","DOMAIN","LATITUDE","LONGITUDE","ELEVATION_METRES_ABS","DATA_START_YEAR","DATA_END_YEAR")
head(INVENTORY_CHANNEL_ISLANDS_daily)
write.csv(INVENTORY_CHANNEL_ISLANDS_daily,"C:/Users/67135099/Dropbox/Copernicus 2017/Inventory/ISTI_Daily/INVENTORY_CHANNEL_ISLANDS_daily.csv")###write out csv file of inventory

INVENTORY_ECAD_daily<- read.table("ftp://ftp.ncdc.noaa.gov/pub/data/globaldatabank/daily/stage2/ecad/INVENTORY_ECAD_daily_stage2",header = TRUE, fill = TRUE)####enter URL link to file
colnames(INVENTORY_ECAD_daily) <- c("STATION_IDENTIFICATION_ NUMBER","STATION_NAME","LATITUDE","LONGITUDE","ELEVATION_METRES_ABS","DATA_START_YEAR","DATA_END_YEAR")
head(INVENTORY_ECAD_daily)
write.csv(INVENTORY_ECAD_daily,"C:/Users/67135099/Dropbox/Copernicus 2017/Inventory/ISTI_Daily/INVENTORY_ECAD_daily.csv")###write out csv file of inventory


INVENTORY_ECAD_NON_BLENDED_daily<- read.table("ftp://ftp.ncdc.noaa.gov/pub/data/globaldatabank/daily/stage2/ecad_non-blended/INVENTORY_ECAD_NON-BLENDED_daily_stage2",header = TRUE, fill = TRUE)####enter URL link to file
colnames(INVENTORY_ECAD_NON_BLENDED_daily) <- c("STATION_IDENTIFICATION_ NUMBER","STATION_NAME","DOMAIN","LATITUDE","LONGITUDE","ELEVATION_METRES_ABS","DATA_START_YEAR","DATA_END_YEAR")
head(INVENTORY_ECAD_NON_BLENDED_daily)
write.csv(INVENTORY_ECAD_NON_BLENDED_daily,"C:/Users/67135099/Dropbox/Copernicus 2017/Inventory/ISTI_Daily/INVENTORY_ECAD_NON_BLENDED_daily.csv")###write out csv file of inventory


INVENTORY_ECUADOR_daily<- read.table("ftp://ftp.ncdc.noaa.gov/pub/data/globaldatabank/daily/stage2/ecuador/INVENTORY_ECUADOR_daily_stage2",header = TRUE, fill = TRUE)####enter URL link to file
colnames(INVENTORY_ECUADOR_daily) <- c("STATION_IDENTIFICATION_ NUMBER","STATION_NAME","DOMAIN","LATITUDE","LONGITUDE","ELEVATION_METRES_ABS","DATA_START_YEAR","DATA_END_YEAR")
head(INVENTORY_ECUADOR_daily)
write.csv(INVENTORY_ECUADOR_daily,"C:/Users/67135099/Dropbox/Copernicus 2017/Inventory/ISTI_Daily/INVENTORY_ECUADOR_daily.csv")###write out csv file of inventory

INVENTORY_GIESSEN_daily<- read.table("ftp://ftp.ncdc.noaa.gov/pub/data/globaldatabank/daily/stage2/giessen/INVENTORY_GIESSEN_daily_stage2",header = TRUE, fill = TRUE)####enter URL link to file
colnames(INVENTORY_GIESSEN_daily) <- c("STATION_IDENTIFICATION_ NUMBER","STATION_NAME","DOMAIN","LATITUDE","LONGITUDE","ELEVATION_METRES_ABS","DATA_START_YEAR","DATA_END_YEAR")
head(INVENTORY_GIESSEN_daily)
write.csv(INVENTORY_GIESSEN_daily,"C:/Users/67135099/Dropbox/Copernicus 2017/Inventory/ISTI_Daily/INVENTORY_GIESSEN_daily.csv")###write out csv file of inventory

INVENTORY_GREENLAND_daily<- read.table("ftp://ftp.ncdc.noaa.gov/pub/data/globaldatabank/daily/stage2/greenland/INVENTORY_GREENLAND_daily_stage2",header = TRUE, fill = TRUE)####enter URL link to file
colnames(INVENTORY_GREENLAND_daily) <- c("STATION_IDENTIFICATION_ NUMBER","STATION_NAME","DOMAIN","LATITUDE","LONGITUDE","ELEVATION_METRES_ABS","DATA_START_YEAR","DATA_END_YEAR")
head(INVENTORY_GREENLAND_daily)
write.csv(INVENTORY_GREENLAND_daily,"C:/Users/67135099/Dropbox/Copernicus 2017/Inventory/ISTI_Daily/INVENTORY_GREENLAND_daily.csv")###write out csv file of inventory

INVENTORY_GSN_SWEDEN_daily<- read.table("ftp://ftp.ncdc.noaa.gov/pub/data/globaldatabank/daily/stage2/gsn-sweden/INVENTORY_GSN-SWEDEN_daily_stage2",header = TRUE, fill = TRUE)####enter URL link to file
colnames(INVENTORY_GSN_SWEDEN_daily) <- c("STATION_IDENTIFICATION_ NUMBER","STATION_NAME","DOMAIN","LATITUDE","LONGITUDE","ELEVATION_METRES_ABS","DATA_START_YEAR","DATA_END_YEAR")
head(INVENTORY_GSN_SWEDEN_daily)
write.csv(INVENTORY_GSN_SWEDEN_daily,"C:/Users/67135099/Dropbox/Copernicus 2017/Inventory/ISTI_Daily/INVENTORY_GSN_SWEDEN_daily.csv")###write out csv file of inventory


INVENTORY_GSOD_daily<- read.table("ftp://ftp.ncdc.noaa.gov/pub/data/globaldatabank/daily/stage2/gsod/INVENTORY_GSOD_daily_stage2",header = TRUE, fill = TRUE)####enter URL link to file
colnames(INVENTORY_GSOD_daily) <- c("STATION_IDENTIFICATION_ NUMBER","STATION_NAME","LATITUDE","LONGITUDE","ELEVATION_METRES_ABS","DATA_START_YEAR","DATA_END_YEAR")
head(INVENTORY_GSOD_daily)
write.csv(INVENTORY_GSOD_daily,"C:/Users/67135099/Dropbox/Copernicus 2017/Inventory/ISTI_Daily/INVENTORY_GSOD_daily.csv")###write out csv file of inventory

INVENTORY_HADISD_daily<- read.table("ftp://ftp.ncdc.noaa.gov/pub/data/globaldatabank/daily/stage2/hadisd/INVENTORY_HADISD_daily_stage2",header = TRUE, fill = TRUE)####enter URL link to file
colnames(INVENTORY_HADISD_daily) <- c("STATION_IDENTIFICATION_ NUMBER","STATION_NAME","DOMAIN","LATITUDE","LONGITUDE","ELEVATION_METRES_ABS","DATA_START_YEAR","DATA_END_YEAR")
head(INVENTORY_HADISD_daily)
write.csv(INVENTORY_HADISD_daily,"C:/Users/67135099/Dropbox/Copernicus 2017/Inventory/ISTI_Daily/INVENTORY_HADISD_daily.csv")###write out csv file of inventory


INVENTORY_INDIA_daily<- read.table("ftp://ftp.ncdc.noaa.gov/pub/data/globaldatabank/daily/stage2/india/INVENTORY_INDIA_daily_stage2",header = TRUE, fill = TRUE)####enter URL link to file
colnames(INVENTORY_INDIA_daily) <- c("STATION_IDENTIFICATION_ NUMBER","STATION_NAME","DOMAIN","LATITUDE","LONGITUDE","ELEVATION_METRES_ABS","DATA_START_YEAR","DATA_END_YEAR")
head(INVENTORY_INDIA_daily)
write.csv(INVENTORY_INDIA_daily,"C:/Users/67135099/Dropbox/Copernicus 2017/Inventory/ISTI_Daily/INVENTORY_INDIA_daily.csv")###write out csv file of inventory

INVENTORY_ISPD_IPY_daily<- read.table("ftp://ftp.ncdc.noaa.gov/pub/data/globaldatabank/daily/stage2/ispd-ipy/INVENTORY_ISPD-IPY_daily_stage2",header = TRUE, fill = TRUE)####enter URL link to file
colnames(INVENTORY_ISPD_IPY_daily) <- c("STATION_IDENTIFICATION_ NUMBER","STATION_NAME","DOMAIN","LATITUDE","LONGITUDE","ELEVATION_METRES_ABS","DATA_START_YEAR","DATA_END_YEAR")
head(INVENTORY_ISPD_IPY_daily)
write.csv(INVENTORY_ISPD_IPY_daily,"C:/Users/67135099/Dropbox/Copernicus 2017/Inventory/ISTI_Daily/INVENTORY_ISPD_IPY_daily.csv")###write out csv file of inventory

INVENTORY_ISPD_SWISS_daily<- read.table("ftp://ftp.ncdc.noaa.gov/pub/data/globaldatabank/daily/stage2/ispd-swiss/INVENTORY_ISPD-SWISS_daily_stage2",header = TRUE, fill = TRUE)####enter URL link to file
colnames(INVENTORY_ISPD_SWISS_daily) <- c("STATION_IDENTIFICATION_ NUMBER","STATION_NAME","LATITUDE","LONGITUDE","ELEVATION_METRES_ABS","DATA_START_YEAR","DATA_END_YEAR")
head(INVENTORY_ISPD_SWISS_daily)
write.csv(INVENTORY_ISPD_SWISS_daily,"C:/Users/67135099/Dropbox/Copernicus 2017/Inventory/ISTI_Daily/INVENTORY_ISPD_SWISS_daily.csv")###write out csv file of inventory


INVENTORY_ISPD_SYDNEY_daily<- read.table("ftp://ftp.ncdc.noaa.gov/pub/data/globaldatabank/daily/stage2/ispd-sydney/INVENTORY_ISPD-SYDNEY_daily_stage2",header = TRUE, fill = TRUE)####enter URL link to file
colnames(INVENTORY_ISPD_SYDNEY_daily) <- c("STATION_IDENTIFICATION_ NUMBER","STATION_NAME","DOMAIN","LATITUDE","LONGITUDE","ELEVATION_METRES_ABS","DATA_START_YEAR","DATA_END_YEAR")
head(INVENTORY_ISPD_SYDNEY_daily)
write.csv(INVENTORY_ISPD_SYDNEY_daily,"C:/Users/67135099/Dropbox/Copernicus 2017/Inventory/ISTI_Daily/INVENTORY_ISPD_SYDNEY_daily.csv")###write out csv file of inventory


INVENTORY_ISPD_TUNISIA_MOROCCO_daily<- read.table("ftp://ftp.ncdc.noaa.gov/pub/data/globaldatabank/daily/stage2/ispd-tunisia-morroco/INVENTORY_ISPD-TUNISIA-MOROCCO_daily_stage2",header = TRUE, fill = TRUE)####enter URL link to file
colnames(INVENTORY_ISPD_TUNISIA_MOROCCO_daily) <- c("STATION_IDENTIFICATION_ NUMBER","STATION_NAME","DOMAIN","LATITUDE","LONGITUDE","ELEVATION_METRES_ABS","DATA_START_YEAR","DATA_END_YEAR")
head(INVENTORY_ISPD_TUNISIA_MOROCCO_daily)
write.csv(INVENTORY_ISPD_TUNISIA_MOROCCO_daily,"C:/Users/67135099/Dropbox/Copernicus 2017/Inventory/ISTI_Daily/INVENTORY_ISPD_TUNISIA_MOROCCO_daily.csv")###write out csv file of inventory

INVENTORY_JAPAN_daily<- read.table("ftp://ftp.ncdc.noaa.gov/pub/data/globaldatabank/daily/stage2/japan/INVENTORY_JAPAN_daily_stage2",header = TRUE, fill = TRUE)####enter URL link to file
colnames(INVENTORY_JAPAN_daily) <- c("STATION_IDENTIFICATION_ NUMBER","STATION_NAME","DOMAIN","LATITUDE","LONGITUDE","ELEVATION_METRES_ABS","DATA_START_YEAR","DATA_END_YEAR")
head(INVENTORY_JAPAN_daily)
write.csv(INVENTORY_JAPAN_daily,"C:/Users/67135099/Dropbox/Copernicus 2017/Inventory/ISTI_Daily/INVENTORY_JAPAN_daily.csv")###write out csv file of inventory

INVENTORY_MEXICO_daily<- read.table("ftp://ftp.ncdc.noaa.gov/pub/data/globaldatabank/daily/stage2/mexico/INVENTORY_MEXICO_daily_stage2",header = TRUE, fill = TRUE)####enter URL link to file
colnames(INVENTORY_MEXICO_daily) <- c("STATION_IDENTIFICATION_ NUMBER","STATION_NAME","DOMAIN","LATITUDE","LONGITUDE","ELEVATION_METRES_ABS","DATA_START_YEAR","DATA_END_YEAR")
head(INVENTORY_MEXICO_daily)
write.csv(INVENTORY_MEXICO_daily,"C:/Users/67135099/Dropbox/Copernicus 2017/Inventory/ISTI_Daily/INVENTORY_MEXICO_daily.csv")###write out csv file of inventory

INVENTORY_PITCAIRNISLAND_daily<- read.table("ftp://ftp.ncdc.noaa.gov/pub/data/globaldatabank/daily/stage2/pitcairnisland/INVENTORY_PITCAIRNISLAND_daily_stage2",header = TRUE, fill = TRUE)####enter URL link to file
colnames(INVENTORY_PITCAIRNISLAND_daily) <- c("STATION_IDENTIFICATION_ NUMBER","STATION_NAME","LATITUDE","LONGITUDE","ELEVATION_METRES_ABS","DATA_START_YEAR","DATA_END_YEAR")
head(INVENTORY_PITCAIRNISLAND_daily)
write.csv(INVENTORY_PITCAIRNISLAND_daily,"C:/Users/67135099/Dropbox/Copernicus 2017/Inventory/ISTI_Daily/INVENTORY_PITCAIRNISLAND_daily.csv")###write out csv file of inventory

INVENTORY_RUSSIA_daily<- read.table("ftp://ftp.ncdc.noaa.gov/pub/data/globaldatabank/daily/stage2/russia/INVENTORY_RUSSIA_daily_stage2",header = TRUE, fill = TRUE)####enter URL link to file
colnames(INVENTORY_RUSSIA_daily) <- c("STATION_IDENTIFICATION_ NUMBER","STATION_NAME","LATITUDE","LONGITUDE","ELEVATION_METRES_ABS","DATA_START_YEAR","DATA_END_YEAR")
head(INVENTORY_RUSSIA_daily)
write.csv(INVENTORY_RUSSIA_daily,"C:/Users/67135099/Dropbox/Copernicus 2017/Inventory/ISTI_Daily/INVENTORY_RUSSIA_daily.csv")###write out csv file of inventory

INVENTORY_SACAD_daily<- read.table("ftp://ftp.ncdc.noaa.gov/pub/data/globaldatabank/daily/stage2/sacad/INVENTORY_SACAD_daily_stage2",header = TRUE, fill = TRUE)####enter URL link to file
colnames(INVENTORY_SACAD_daily) <- c("STATION_IDENTIFICATION_ NUMBER","STATION_NAME","LATITUDE","LONGITUDE","ELEVATION_METRES_ABS","DATA_START_YEAR","DATA_END_YEAR")
head(INVENTORY_SACAD_daily)
write.csv(INVENTORY_SACAD_daily,"C:/Users/67135099/Dropbox/Copernicus 2017/Inventory/ISTI_Daily/INVENTORY_SACAD_daily.csv")###write out csv file of inventory

INVENTORY_SACAD_NON_BLENDED_daily<- read.table("ftp://ftp.ncdc.noaa.gov/pub/data/globaldatabank/daily/stage2/sacad_non-blended/INVENTORY_SACAD_NON-BLENDED_daily_stage2",header = TRUE, fill = TRUE)####enter URL link to file
colnames(INVENTORY_SACAD_NON_BLENDED_daily) <- c("STATION_IDENTIFICATION_ NUMBER","STATION_NAME","LATITUDE","LONGITUDE","ELEVATION_METRES_ABS","DATA_START_YEAR","DATA_END_YEAR")
head(INVENTORY_SACAD_NON_BLENDED_daily)
write.csv(INVENTORY_SACAD_NON_BLENDED_daily,"C:/Users/67135099/Dropbox/Copernicus 2017/Inventory/ISTI_Daily/INVENTORY_SACAD_NON_BLENDED_daily.csv")###write out csv file of inventory

INVENTORY_SPAIN_daily<- read.table("ftp://ftp.ncdc.noaa.gov/pub/data/globaldatabank/daily/stage2/spain/INVENTORY_SPAIN_daily_stage2",header = TRUE, fill = TRUE)####enter URL link to file
colnames(INVENTORY_SPAIN_daily) <- c("STATION_IDENTIFICATION_ NUMBER","STATION_NAME","LATITUDE","LONGITUDE","ELEVATION_METRES_ABS","DATA_START_YEAR","DATA_END_YEAR")
head(INVENTORY_SPAIN_daily)
write.csv(INVENTORY_SPAIN_daily,"C:/Users/67135099/Dropbox/Copernicus 2017/Inventory/ISTI_Daily/INVENTORY_SPAIN_daily.csv")###write out csv file of inventory

INVENTORY_SWISS_DIGIHOM_daily<- read.table("ftp://ftp.ncdc.noaa.gov/pub/data/globaldatabank/daily/stage2/swiss-digihom/INVENTORY_SWISS-DIGIHOM_daily_stage2",header = TRUE, fill = TRUE)####enter URL link to file
colnames(INVENTORY_SWISS_DIGIHOM_daily)<- c("STATION_IDENTIFICATION_ NUMBER","STATION_NAME","LATITUDE","LONGITUDE","ELEVATION_METRES_ABS","DATA_START_YEAR","DATA_END_YEAR")
head(INVENTORY_SWISS_DIGIHOM_daily)
write.csv(INVENTORY_SWISS_DIGIHOM_daily,"C:/Users/67135099/Dropbox/Copernicus 2017/Inventory/ISTI_Daily/INVENTORY_SWISS_DIGIHOM_daily.csv")###write out csv file of inventory

INVENTORY_URUGUAY_INIA_daily<- read.table("ftp://ftp.ncdc.noaa.gov/pub/data/globaldatabank/daily/stage2/uruguay-inia/INVENTORY_URUGUAY-INIA_daily_stage2",header = TRUE, fill = TRUE)####enter URL link to file
colnames(INVENTORY_URUGUAY_INIA_daily) <- c("STATION_IDENTIFICATION_ NUMBER","STATION_NAME","LATITUDE","LONGITUDE","ELEVATION_METRES_ABS","DATA_START_YEAR","DATA_END_YEAR")
head(INVENTORY_URUGUAY_INIA_daily)
write.csv(INVENTORY_URUGUAY_INIA_daily,"C:/Users/67135099/Dropbox/Copernicus 2017/Inventory/ISTI_Daily/INVENTORY_URUGUAY_INIA_daily.csv")###write out csv file of inventory

INVENTORY_URUGUAY_daily<- read.table("ftp://ftp.ncdc.noaa.gov/pub/data/globaldatabank/daily/stage2/uruguay/INVENTORY_URUGUAY_daily_stage2",header = TRUE, fill = TRUE)####enter URL link to file
colnames(INVENTORY_URUGUAY_daily) <- c("STATION_IDENTIFICATION_ NUMBER","STATION_NAME","LATITUDE","LONGITUDE","ELEVATION_METRES_ABS","DATA_START_YEAR","DATA_END_YEAR")
head(INVENTORY_URUGUAY_daily)
write.csv(INVENTORY_URUGUAY_daily,"C:/Users/67135099/Dropbox/Copernicus 2017/Inventory/ISTI_Daily/INVENTORY_URUGUAY_daily.csv")###write out csv file of inventory

INVENTORY_USFORTS_daily<- read.table("ftp://ftp.ncdc.noaa.gov/pub/data/globaldatabank/daily/stage2/usforts/INVENTORY_USFORTS_daily_stage2",header = TRUE, fill = TRUE)####enter URL link to file
colnames(INVENTORY_USFORTS_daily) <- c("STATION_IDENTIFICATION_ NUMBER","STATION_NAME","LATITUDE","LONGITUDE","ELEVATION_METRES_ABS","DATA_START_YEAR","DATA_END_YEAR")
head(INVENTORY_USFORTS_daily)
write.csv(INVENTORY_USFORTS_daily,"C:/Users/67135099/Dropbox/Copernicus 2017/Inventory/ISTI_Daily/INVENTORY_USFORTS_daily.csv")###write out csv file of inventory

INVENTORY_VIETNAM_daily<- read.table("ftp://ftp.ncdc.noaa.gov/pub/data/globaldatabank/daily/stage2/vietnam/INVENTORY_VIETNAM_daily_stage2",header = TRUE, fill = TRUE)####enter URL link to file
colnames(INVENTORY_VIETNAM_daily) <- c("STATION_IDENTIFICATION_ NUMBER","STATION_NAME","LATITUDE","LONGITUDE","ELEVATION_METRES_ABS","DATA_START_YEAR","DATA_END_YEAR")
head(INVENTORY_VIETNAM_daily)
write.csv(INVENTORY_VIETNAM_daily,"C:/Users/67135099/Dropbox/Copernicus 2017/Inventory/ISTI_Daily/INVENTORY_VIETNAM_daily.csv")###write out csv file of inventory

####################################################################################################################
###########################################################################################################

####set working directory to folder with inventory files and then combine all files into one csv and export to directory
#setwd()
tbl = list.files(pattern="*.csv")
for (i in 1:length(tbl)) assign(tbl[i], read.csv(tbl[i]))
list_of_data = lapply(tbl, read.csv)
head(tbl)
library(plyr)
all_data = do.call(rbind.fill, list_of_data)
head(all_data)
write.csv(all_data,"C:/Users/67135099/Dropbox/Copernicus 2017/Inventory/ISTI_Daily/INVENTORY_ISTI_Daily_comb.csv")###write out csv file of inventory
#############

