####read ISTI inventory file and add headers NOTE:error in column names will occur if no domain column is present.. fix remove DOMAIN
INVENTORY_ANTARCTICA_SCAR_READER_monthly_stage2 <- read.table("ftp://ftp.ncdc.noaa.gov/pub/data/globaldatabank/monthly/stage2/antarctica-scar-reader/INVENTORY_ANTARCTICA-SCAR-READER_monthly_stage2",header = TRUE, fill = TRUE)####enter URL link to file
head(INVENTORY_ANTARCTICA_SCAR_READER_monthly_stage2)
write.csv(INVENTORY_ANTARCTICA_SCAR_READER_monthly_stage2,"C:/Users/67135099/Dropbox/Copernicus 2017/Inventory/ISTI_Monthly/INVENTORY_ANTARCTICA_SCAR_READER_monthly_stage2_test.csv")###write out csv file of inventory

INVENTORY_ANTARCTICA_SOUTHPOLE<- read.table("ftp://ftp.ncdc.noaa.gov/pub/data/globaldatabank/monthly/stage2/antarctica-southpole/INVENTORY_ANTARCTICA-SOUTHPOLE_monthly_stage2",header = TRUE, fill = TRUE)####enter URL link to file
head(INVENTORY_ANTARCTICA_SOUTHPOLE)
write.csv(INVENTORY_ANTARCTICA_SOUTHPOLE,"C:/Users/67135099/Dropbox/Copernicus 2017/Inventory/ISTI_Monthly/INVENTORY_ANTARCTICA_SOUTHPOLE.csv")###write out csv file of inventory

INVENTORY_ARCTIC_monthly_stage2 <- read.table("ftp://ftp.ncdc.noaa.gov/pub/data/globaldatabank/monthly/stage2/arctic/INVENTORY_ARCTIC_monthly_stage2",header = TRUE, fill = TRUE)####enter URL link to file
head(INVENTORY_ARCTIC_monthly_stage2)
write.csv(INVENTORY_ARCTIC_monthly_stage2,"C:/Users/67135099/Dropbox/Copernicus 2017/Inventory/ISTI_Monthly/INVENTORY_ARCTIC_monthly_stage2.csv")###write out csv file of inventory

INVENTORY_CANADA__monthly_stage2 <- read.table("ftp://ftp.ncdc.noaa.gov/pub/data/globaldatabank/monthly/stage2/canada/INVENTORY_CANADA_monthly_stage2",header = TRUE, fill = TRUE)####enter URL link to file
head(INVENTORY_CANADA__monthly_stage2 )
write.csv(INVENTORY_CANADA__monthly_stage2,"C:/Users/67135099/Dropbox/Copernicus 2017/Inventory/ISTI_Monthly/INVENTORY_CANADA_monthly_stage2.csv")###write out csv file of inventory


INVENTORY_CANADA_RAW_monthly_stage2 <- read.table("ftp://ftp.ncdc.noaa.gov/pub/data/globaldatabank/monthly/stage2/canada-raw/INVENTORY_CANADA-RAW_monthly_stage2",header = TRUE, fill = TRUE)####enter URL link to file
head(INVENTORY_CANADA_RAW_monthly_stage2 )
write.csv(INVENTORY_CANADA_RAW_monthly_stage2 ,"C:/Users/67135099/Dropbox/Copernicus 2017/Inventory/ISTI_Monthly/INVENTORY_CANADA_RAW_monthly_stage2.csv")###write out csv file of inventory


INVENTORY_CENTRAL_ASIA_monthly_stage2 <- read.table("ftp://ftp.ncdc.noaa.gov/pub/data/globaldatabank/monthly/stage2/central-asia/INVENTORY_CENTRAL-ASIA_monthly_stage2",header = TRUE, fill = TRUE)####enter URL link to file
head(INVENTORY_CENTRAL_ASIA_monthly_stage2)
write.csv(INVENTORY_CENTRAL_ASIA_monthly_stage2 ,"C:/Users/67135099/Dropbox/Copernicus 2017/Inventory/ISTI_Monthly/INVENTORY_CENTRAL_ASIA_monthly_stage2.csv")###write out csv file of inventory


INVENTORY_CLIMAT_BUFR_monthly_stage2 <- read.table("ftp://ftp.ncdc.noaa.gov/pub/data/globaldatabank/monthly/stage2/climat-bufr/INVENTORY_CLIMAT-BUFR_monthly_stage2",header = TRUE, fill = TRUE)####enter URL link to file
head(INVENTORY_CLIMAT_BUFR_monthly_stage2)
write.csv(INVENTORY_CLIMAT_BUFR_monthly_stage2,"C:/Users/67135099/Dropbox/Copernicus 2017/Inventory/ISTI_Monthly/INVENTORY_CLIMAT_BUFR_monthly_stage2.csv")###write out csv file of inventory


INVENTORY_CLIMAT_NCDC_monthly_stage2<- read.table("ftp://ftp.ncdc.noaa.gov/pub/data/globaldatabank/monthly/stage2/climat-ncdc/INVENTORY_CLIMAT-NCDC_monthly_stage2",header = TRUE, fill = TRUE)####enter URL link to file
head(INVENTORY_CLIMAT_NCDC_monthly_stage2)
write.csv(INVENTORY_CLIMAT_NCDC_monthly_stage2,"C:/Users/67135099/Dropbox/Copernicus 2017/Inventory/ISTI_Monthly/INVENTORY_CLIMAT_NCDC_monthly_stage2.csv")###write out csv file of inventory


INVENTORY_CLIMAT_PRELIM_monthly_stage2<- read.table("ftp://ftp.ncdc.noaa.gov/pub/data/globaldatabank/monthly/stage2/climat-prelim/INVENTORY_CLIMAT-PRELIM_monthly_stage2",header = TRUE, fill = TRUE)####enter URL link to file
head(INVENTORY_CLIMAT_PRELIM_monthly_stage2)
write.csv(INVENTORY_CLIMAT_PRELIM_monthly_stage2,"C:/Users/67135099/Dropbox/Copernicus 2017/Inventory/ISTI_Monthly/INVENTORY_CLIMAT_PRELIM_monthly_stage2.csv")###write out csv file of inventory


INVENTORY_CLIMAT_UK_monthly_stage2<- read.table("ftp://ftp.ncdc.noaa.gov/pub/data/globaldatabank/monthly/stage2/climat-uk/INVENTORY_CLIMAT-UK_monthly_stage2",header = TRUE, fill = TRUE)####enter URL link to file
head(INVENTORY_CLIMAT_UK_monthly_stage2)
write.csv(INVENTORY_CLIMAT_UK_monthly_stage2,"C:/Users/67135099/Dropbox/Copernicus 2017/Inventory/ISTI_Monthly/INVENTORY_CLIMAT_UK_monthly_stage2.csv")###write out csv file of inventory

INVENTORY_COLONIALERA_monthly_stage2<- read.table("ftp://ftp.ncdc.noaa.gov/pub/data/globaldatabank/monthly/stage2/colonialera/INVENTORY_COLONIALERA_monthly_stage2",header = TRUE, fill = TRUE)####enter URL link to file
head(INVENTORY_COLONIALERA_monthly_stage2)
write.csv(INVENTORY_COLONIALERA_monthly_stage2,"C:/Users/67135099/Dropbox/Copernicus 2017/Inventory/ISTI_Monthly/INVENTORY_COLONIALERA_monthly_stage2.csv")###write out csv file of inventory

INVENTORY_CRUTEM3_monthly_stage2<- read.table("ftp://ftp.ncdc.noaa.gov/pub/data/globaldatabank/monthly/stage2/crutem3/INVENTORY_CRUTEM3_monthly_stage2",header = TRUE, fill = TRUE)####enter URL link to file
head(INVENTORY_CRUTEM3_monthly_stage2)
write.csv(INVENTORY_CRUTEM3_monthly_stage2,"C:/Users/67135099/Dropbox/Copernicus 2017/Inventory/ISTI_Monthly/INVENTORY_CRUTEM3_monthly_stage2.csv")###write out csv file of inventory

INVENTORY_CRUTEM4_monthly_stage2<- read.table("ftp://ftp.ncdc.noaa.gov/pub/data/globaldatabank/monthly/stage2/crutem4/INVENTORY_CRUTEM4_monthly_stage2",header = TRUE, fill = TRUE)####enter URL link to file
head(INVENTORY_CRUTEM4_monthly_stage2)
write.csv(INVENTORY_CRUTEM4_monthly_stage2,"C:/Users/67135099/Dropbox/Copernicus 2017/Inventory/ISTI_Monthly/INVENTORY_CRUTEM4_monthly_stage2.csv")###write out csv file of inventory


INVENTORY_EAST_AFRICA_monthly_stage2<- read.table("ftp://ftp.ncdc.noaa.gov/pub/data/globaldatabank/monthly/stage2/east-africa/INVENTORY_EAST-AFRICA_monthly_stage2",header = TRUE, fill = TRUE)####enter URL link to file
head(INVENTORY_EAST_AFRICA_monthly_stage2)
write.csv(INVENTORY_EAST_AFRICA_monthly_stage2,"C:/Users/67135099/Dropbox/Copernicus 2017/Inventory/ISTI_Monthly/INVENTORY_EAST_AFRICA_monthly_stage2.csv")###write out csv file of inventory

INVENTORY_EKLIMA_monthly_stage2<- read.table("ftp://ftp.ncdc.noaa.gov/pub/data/globaldatabank/monthly/stage2/ekilma/INVENTORY_EKLIMA_monthly_stage2",header = TRUE, fill = TRUE)####enter URL link to file
head(INVENTORY_EKLIMA_monthly_stage2)
write.csv(INVENTORY_EKLIMA_monthly_stage2,"C:/Users/67135099/Dropbox/Copernicus 2017/Inventory/ISTI_Monthly/INVENTORY_EKLIMA_monthly_stage2.csv")###write out csv file of inventory


INVENTORY_GERMANY_monthly_stage2<- read.table("ftp://ftp.ncdc.noaa.gov/pub/data/globaldatabank/monthly/stage2/germany/INVENTORY_GERMANY_monthly_stage2",header = TRUE, fill = TRUE)####enter URL link to file
head(INVENTORY_GERMANY_monthly_stage2)
write.csv(INVENTORY_GERMANY_monthly_stage2,"C:/Users/67135099/Dropbox/Copernicus 2017/Inventory/ISTI_Monthly/INVENTORY_GERMANY_monthly_stage2.csv")###write out csv file of inventory

INVENTORY_GHCNMV2_monthly_stage2<- read.table("ftp://ftp.ncdc.noaa.gov/pub/data/globaldatabank/monthly/stage2/ghcnmv2/INVENTORY_GHCNMV2_monthly_stage2",header = TRUE, fill = TRUE)####enter URL link to file
head(INVENTORY_GHCNMV2_monthly_stage2)
write.csv(INVENTORY_GHCNMV2_monthly_stage2,"C:/Users/67135099/Dropbox/Copernicus 2017/Inventory/ISTI_Monthly/INVENTORY_GHCNMV2_monthly_stage2.csv")###write out csv file of inventory

INVENTORY_GHCNSOURCE_monthly_stage2<- read.table("ftp://ftp.ncdc.noaa.gov/pub/data/globaldatabank/monthly/stage2/ghcnsource/INVENTORY_GHCNSOURCE_monthly_stage2",header = TRUE, fill = TRUE)####enter URL link to file
head(INVENTORY_GHCNSOURCE_monthly_stage2)
write.csv(INVENTORY_GHCNSOURCE_monthly_stage2,"C:/Users/67135099/Dropbox/Copernicus 2017/Inventory/ISTI_Monthly/INVENTORY_GHCNSOURCE_monthly_stage2.csv")###write out csv file of inventory

INVENTORY_HISTALP_monthly_stage2<- read.table("ftp://ftp.ncdc.noaa.gov/pub/data/globaldatabank/monthly/stage2/histalp/INVENTORY_HISTALP_monthly_stage2",header = TRUE, fill = TRUE)####enter URL link to file
head(INVENTORY_HISTALP_monthly_stage2)
write.csv(INVENTORY_HISTALP_monthly_stage2,"C:/Users/67135099/Dropbox/Copernicus 2017/Inventory/ISTI_Monthly/INVENTORY_HISTALP_monthly_stage2.csv")###write out csv file of inventory

INVENTORY_KNMI_monthly_stage2<- read.table("ftp://ftp.ncdc.noaa.gov/pub/data/globaldatabank/monthly/stage2/knmi/INVENTORY_KNMI_monthly_stage2",header = TRUE, fill = TRUE)####enter URL link to file
head(INVENTORY_KNMI_monthly_stage2)
write.csv(INVENTORY_KNMI_monthly_stage2,"C:/Users/67135099/Dropbox/Copernicus 2017/Inventory/ISTI_Monthly/INVENTORY_KNMI_monthly_stage2.csv")###write out csv file of inventory

INVENTORY_MCDW_monthly_stage2<- read.table("ftp://ftp.ncdc.noaa.gov/pub/data/globaldatabank/monthly/stage2/mcdw/INVENTORY_MCDW_monthly_stage2",header = TRUE, fill = TRUE)####enter URL link to file
head(INVENTORY_MCDW_monthly_stage2)
write.csv(INVENTORY_MCDW_monthly_stage2,"C:/Users/67135099/Dropbox/Copernicus 2017/Inventory/ISTI_Monthly/INVENTORY_MCDW_monthly_stage2.csv")###write out csv file of inventory

INVENTORY_MCDW_UNPUBLISHED_monthly_stage2<- read.table("ftp://ftp.ncdc.noaa.gov/pub/data/globaldatabank/monthly/stage2/mcdw-unpublished/INVENTORY_MCDW-UNPUBLISHED_monthly_stage2",header = TRUE, fill = TRUE)####enter URL link to file
head(INVENTORY_MCDW_UNPUBLISHED_monthly_stage2)
write.csv(INVENTORY_MCDW_UNPUBLISHED_monthly_stage2,"C:/Users/67135099/Dropbox/Copernicus 2017/Inventory/ISTI_Monthly/INVENTORY_MCDW-UNPUBLISHED_monthly_stage2.csv")###write out csv file of inventory

INVENTORY_RUSSSOURCE_monthly_stage2<- read.table("ftp://ftp.ncdc.noaa.gov/pub/data/globaldatabank/monthly/stage2/russsource/INVENTORY_RUSSSOURCE_monthly_stage2",header = TRUE, fill = TRUE)####enter URL link to file
head(INVENTORY_RUSSSOURCE_monthly_stage2)
write.csv(INVENTORY_RUSSSOURCE_monthly_stage2,"C:/Users/67135099/Dropbox/Copernicus 2017/Inventory/ISTI_Monthly/INVENTORY_RUSSSOURCE_monthly_stage2.csv")###write out csv file of inventory

INVENTORY_RUSSSOURCE_AK_HI_CLIMAT_monthly_stage2<- read.table("ftp://ftp.ncdc.noaa.gov/pub/data/globaldatabank/monthly/stage2/russsource-ak-hi-climat/INVENTORY_RUSSSOURCE-AK-HI-CLIMAT_monthly_stage2",header = TRUE, fill = TRUE)####enter URL link to file
head(INVENTORY_RUSSSOURCE_AK_HI_CLIMAT_monthly_stage2)
write.csv(INVENTORY_RUSSSOURCE_AK_HI_CLIMAT_monthly_stage2,"C:/Users/67135099/Dropbox/Copernicus 2017/Inventory/ISTI_Monthly/INVENTORY_RUSSSOURCE_AK_HI_CLIMAT_monthly_stage2.csv")###write out csv file of inventory

INVENTORY_RUSSSOURCE_ANTARCTICA_monthly_stage2<- read.table("ftp://ftp.ncdc.noaa.gov/pub/data/globaldatabank/monthly/stage2/russsource-antarctica/INVENTORY_RUSSSOURCE-ANTARCTICA_monthly_stage2",header = TRUE, fill = TRUE)####enter URL link to file
head(INVENTORY_RUSSSOURCE_ANTARCTICA_monthly_stage2)
write.csv(INVENTORY_RUSSSOURCE_ANTARCTICA_monthly_stage2,"C:/Users/67135099/Dropbox/Copernicus 2017/Inventory/ISTI_Monthly/INVENTORY_RUSSSOURCE_ANTARCTICA_monthly_stage2.csv")###write out csv file of inventory

INVENTORY_RUSSSOURCE_ARGENTINA_monthly_stage2<- read.table("ftp://ftp.ncdc.noaa.gov/pub/data/globaldatabank/monthly/stage2/russsource-argentina/INVENTORY_RUSSSOURCE-ARGENTINA_monthly_stage2",header = TRUE, fill = TRUE)####enter URL link to file
head(INVENTORY_RUSSSOURCE_ARGENTINA_monthly_stage2)
write.csv(INVENTORY_RUSSSOURCE_ARGENTINA_monthly_stage2,"C:/Users/67135099/Dropbox/Copernicus 2017/Inventory/ISTI_Monthly/INVENTORY_RUSSSOURCE_ARGENTINA_monthly_stage2.csv")###write out csv file of inventory

INVENTORY_RUSSSOURCE_AUSTRALIA_monthly_stage2<- read.table("ftp://ftp.ncdc.noaa.gov/pub/data/globaldatabank/monthly/stage2/russsource-australia/INVENTORY_RUSSSOURCE-AUSTRALIA_monthly_stage2",header = TRUE, fill = TRUE)####enter URL link to file
head(INVENTORY_RUSSSOURCE_AUSTRALIA_monthly_stage2)
write.csv(INVENTORY_RUSSSOURCE_AUSTRALIA_monthly_stage2,"C:/Users/67135099/Dropbox/Copernicus 2017/Inventory/ISTI_Monthly/INVENTORY_RUSSSOURCE_AUSTRALIA_monthly_stage2.csv")###write out csv file of inventory

INVENTORY_RUSSSOURCE_AUSTRALIA_DE_monthly_stage2<- read.table("ftp://ftp.ncdc.noaa.gov/pub/data/globaldatabank/monthly/stage2/russsource-australia-de/INVENTORY_RUSSSOURCE-AUSTRALIA-DE_monthly_stage2",header = TRUE, fill = TRUE)####enter URL link to file
head(INVENTORY_RUSSSOURCE_AUSTRALIA_DE_monthly_stage2)
write.csv(INVENTORY_RUSSSOURCE_AUSTRALIA_DE_monthly_stage2,"C:/Users/67135099/Dropbox/Copernicus 2017/Inventory/ISTI_Monthly/INVENTORY_RUSSSOURCE_AUSTRALIA_DE_monthly_stage2.csv")###write out csv file of inventory

INVENTORY_RUSSSOURCE_AUSTRALIA_WWR_monthly_stage2<- read.table("ftp://ftp.ncdc.noaa.gov/pub/data/globaldatabank/monthly/stage2/russsource-australia-wwr/INVENTORY_RUSSSOURCE-AUSTRALIA-WWR_monthly_stage2",header = TRUE, fill = TRUE)####enter URL link to file
head(INVENTORY_RUSSSOURCE_AUSTRALIA_WWR_monthly_stage2)
write.csv(INVENTORY_RUSSSOURCE_AUSTRALIA_WWR_monthly_stage2,"C:/Users/67135099/Dropbox/Copernicus 2017/Inventory/ISTI_Monthly/INVENTORY_RUSSSOURCE_AUSTRALIA_WWR_monthly_stage2.csv")###write out csv file of inventory

INVENTORY_RUSSSOURCE_BRAZIL_monthly_stage2<- read.table("ftp://ftp.ncdc.noaa.gov/pub/data/globaldatabank/monthly/stage2/russsource-brazil/INVENTORY_RUSSSOURCE-BRAZIL_monthly_stage2",header = TRUE, fill = TRUE)####enter URL link to file
colnames(INVENTORY_RUSSSOURCE_BRAZIL_monthly_stage2) <- c("STATION_IDENTIFICATION_ NUMBER","STATION_NAME","LATITUDE","LONGITUDE","ELEVATION_METRES_ABS","DATA_START_YEAR","DATA_END_YEAR")
head(INVENTORY_RUSSSOURCE_BRAZIL_monthly_stage2)
write.csv(INVENTORY_RUSSSOURCE_BRAZIL_monthly_stage2,"C:/Users/67135099/Dropbox/Copernicus 2017/Inventory/ISTI_Monthly/INVENTORY_RUSSSOURCE_BRAZIL_monthly_stage2.csv")###write out csv file of inventory

INVENTORY_RUSSSOURCE_CANADA_monthly_stage2<- read.table("ftp://ftp.ncdc.noaa.gov/pub/data/globaldatabank/monthly/stage2/russsource-canada/INVENTORY_RUSSSOURCE-CANADA_monthly_stage2",header = TRUE, fill = TRUE)####enter URL link to file
head(INVENTORY_RUSSSOURCE_CANADA_monthly_stage2)
write.csv(INVENTORY_RUSSSOURCE_CANADA_monthly_stage2,"C:/Users/67135099/Dropbox/Copernicus 2017/Inventory/ISTI_Monthly/INVENTORY_RUSSSOURCE_CANADA_monthly_stage2.csv")###write out csv file of inventory

INVENTORY_RUSSSOURCE_CHILE_monthly_stage2<- read.table("ftp://ftp.ncdc.noaa.gov/pub/data/globaldatabank/monthly/stage2/russsource-chile/INVENTORY_RUSSSOURCE-CHILE_monthly_stage2",header = TRUE, fill = TRUE)####enter URL link to file
head(INVENTORY_RUSSSOURCE_CHILE_monthly_stage2)
write.csv(INVENTORY_RUSSSOURCE_CHILE_monthly_stage2,"C:/Users/67135099/Dropbox/Copernicus 2017/Inventory/ISTI_Monthly/INVENTORY_RUSSSOURCE_CHILE_monthly_stage2.csv")###write out csv file of inventory

INVENTORY_RUSSSOURCE_CLIMAT_monthly_stage2<- read.table("ftp://ftp.ncdc.noaa.gov/pub/data/globaldatabank/monthly/stage2/russsource-climat/INVENTORY_RUSSSOURCE-CLIMAT_monthly_stage2",header = TRUE, fill = TRUE)####enter URL link to file
head(INVENTORY_RUSSSOURCE_CLIMAT_monthly_stage2)
write.csv(INVENTORY_RUSSSOURCE_CLIMAT_monthly_stage2,"C:/Users/67135099/Dropbox/Copernicus 2017/Inventory/ISTI_Monthly/INVENTORY_RUSSSOURCE_CLIMAT_monthly_stage2.csv")###write out csv file of inventory

INVENTORY_RUSSSOURCE_CONUS_CLIMAT_monthly_stage2<- read.table("ftp://ftp.ncdc.noaa.gov/pub/data/globaldatabank/monthly/stage2/russsource-conus-climat/INVENTORY_RUSSSOURCE-CONUS-CLIMAT_monthly_stage2",header = TRUE, fill = TRUE)####enter URL link to file
head(INVENTORY_RUSSSOURCE_CONUS_CLIMAT_monthly_stage2)
write.csv(INVENTORY_RUSSSOURCE_CONUS_CLIMAT_monthly_stage2,"C:/Users/67135099/Dropbox/Copernicus 2017/Inventory/ISTI_Monthly/INVENTORY_RUSSSOURCE_CONUS_CLIMAT_monthly_stage2.csv")###write out csv file of inventory

INVENTORY_RUSSSOURCE_CUBA_monthly_stage2<- read.table("ftp://ftp.ncdc.noaa.gov/pub/data/globaldatabank/monthly/stage2/russsource-cuba/INVENTORY_RUSSSOURCE-CUBA_monthly_stage2",header = TRUE, fill = TRUE)####enter URL link to file
head(INVENTORY_RUSSSOURCE_CUBA_monthly_stage2)
write.csv(INVENTORY_RUSSSOURCE_CUBA_monthly_stage2,"C:/Users/67135099/Dropbox/Copernicus 2017/Inventory/ISTI_Monthly/INVENTORY_RUSSSOURCE_CUBA_monthly_stage2.csv")###write out csv file of inventory

INVENTORY_RUSSSOURCE_FAO_monthly_stage2<- read.table("ftp://ftp.ncdc.noaa.gov/pub/data/globaldatabank/monthly/stage2/russsource-fao/INVENTORY_RUSSSOURCE-FAO_monthly_stage2",header = TRUE, fill = TRUE)####enter URL link to file
head(INVENTORY_RUSSSOURCE_FAO_monthly_stage2)
write.csv(INVENTORY_RUSSSOURCE_FAO_monthly_stage2,"C:/Users/67135099/Dropbox/Copernicus 2017/Inventory/ISTI_Monthly/INVENTORY_RUSSSOURCE_FAO_monthly_stage2.csv")###write out csv file of inventory


INVENTORY_RUSSSOURCE_FWA_monthly_stage2<- read.table("ftp://ftp.ncdc.noaa.gov/pub/data/globaldatabank/monthly/stage2/russsource-fwa/INVENTORY_RUSSSOURCE-FWA_monthly_stage2",header = TRUE, fill = TRUE)####enter URL link to file
head(INVENTORY_RUSSSOURCE_FWA_monthly_stage2)
write.csv(INVENTORY_RUSSSOURCE_FWA_monthly_stage2,"C:/Users/67135099/Dropbox/Copernicus 2017/Inventory/ISTI_Monthly/INVENTORY_RUSSSOURCE_FWA_monthly_stage2.csv")###write out csv file of inventory

INVENTORY_RUSSSOURCE_GHCN_monthly_stage2<- read.table("ftp://ftp.ncdc.noaa.gov/pub/data/globaldatabank/monthly/stage2/russsource-ghcn/INVENTORY_RUSSSOURCE-GHCN_monthly_stage2",header = TRUE, fill = TRUE)####enter URL link to file
head(INVENTORY_RUSSSOURCE_GHCN_monthly_stage2)
write.csv(INVENTORY_RUSSSOURCE_GHCN_monthly_stage2,"C:/Users/67135099/Dropbox/Copernicus 2017/Inventory/ISTI_Monthly/INVENTORY_RUSSSOURCE_GHCN_monthly_stage2.csv")###write out csv file of inventory

INVENTORY_RUSSSOURCE_GHCND_NONCONUS_monthly_stage2<- read.table("ftp://ftp.ncdc.noaa.gov/pub/data/globaldatabank/monthly/stage2/russsource-ghcnd-nonconus/INVENTORY_RUSSSOURCE-GHCND-NONCONUS_monthly_stage2",header = TRUE, fill = TRUE)####enter URL link to file
head(INVENTORY_RUSSSOURCE_GHCND_NONCONUS_monthly_stage2)
write.csv(INVENTORY_RUSSSOURCE_GHCND_NONCONUS_monthly_stage2,"C:/Users/67135099/Dropbox/Copernicus 2017/Inventory/ISTI_Monthly/INVENTORY_RUSSSOURCE_GHCND_NONCONUS_monthly_stage2.csv")###write out csv file of inventory

INVENTORY_RUSSSOURCE_GREECE_monthly_stage2<- read.table("ftp://ftp.ncdc.noaa.gov/pub/data/globaldatabank/monthly/stage2/russsource-greece/INVENTORY_RUSSSOURCE-GREECE_monthly_stage2",header = TRUE, fill = TRUE)####enter URL link to file
head(INVENTORY_RUSSSOURCE_GREECE_monthly_stage2)
write.csv(INVENTORY_RUSSSOURCE_GREECE_monthly_stage2,"C:/Users/67135099/Dropbox/Copernicus 2017/Inventory/ISTI_Monthly/INVENTORY_RUSSSOURCE_GREECE_monthly_stage2.csv")###write out csv file of inventory

INVENTORY_RUSSSOURCE_GRIFFITHS_monthly_stage2<- read.table("ftp://ftp.ncdc.noaa.gov/pub/data/globaldatabank/monthly/stage2/russsource-griffiths/INVENTORY_RUSSSOURCE-GRIFFITHS_monthly_stage2",header = TRUE, fill = TRUE)####enter URL link to file
head(INVENTORY_RUSSSOURCE_GRIFFITHS_monthly_stage2)
write.csv(INVENTORY_RUSSSOURCE_GRIFFITHS_monthly_stage2,"C:/Users/67135099/Dropbox/Copernicus 2017/Inventory/ISTI_Monthly/INVENTORY_RUSSSOURCE_GRIFFITHS_monthly_stage2.csv")###write out csv file of inventory

INVENTORY_RUSSSOURCE_GRIFFITHS_SA_monthly_stage2<- read.table("ftp://ftp.ncdc.noaa.gov/pub/data/globaldatabank/monthly/stage2/russsource-griffiths-sa/INVENTORY_RUSSSOURCE-GRIFFITHS-SA_monthly_stage2",header = TRUE, fill = TRUE)####enter URL link to file
head(INVENTORY_RUSSSOURCE_GRIFFITHS_SA_monthly_stage2)
write.csv(INVENTORY_RUSSSOURCE_GRIFFITHS_SA_monthly_stage2,"C:/Users/67135099/Dropbox/Copernicus 2017/Inventory/ISTI_Monthly/INVENTORY_RUSSSOURCE_GRIFFITHS_SA_monthly_stage2.csv")###write out csv file of inventory

INVENTORY_RUSSSOURCE_INDONESIA_monthly_stage2<- read.table("ftp://ftp.ncdc.noaa.gov/pub/data/globaldatabank/monthly/stage2/russsource-indonesia/INVENTORY_RUSSSOURCE-INDONESIA_monthly_stage2",header = TRUE, fill = TRUE)####enter URL link to file
head(INVENTORY_RUSSSOURCE_INDONESIA_monthly_stage2)
write.csv(INVENTORY_RUSSSOURCE_INDONESIA_monthly_stage2,"C:/Users/67135099/Dropbox/Copernicus 2017/Inventory/ISTI_Monthly/INVENTORY_RUSSSOURCE_INDONESIA_monthly_stage2.csv")###write out csv file of inventory

INVENTORY_RUSSSOURCE_IRAN_monthly_stage2<- read.table("ftp://ftp.ncdc.noaa.gov/pub/data/globaldatabank/monthly/stage2/russsource-iran/INVENTORY_RUSSSOURCE-IRAN_monthly_stage2",header = TRUE, fill = TRUE)####enter URL link to file
head(INVENTORY_RUSSSOURCE_IRAN_monthly_stage2)
write.csv(INVENTORY_RUSSSOURCE_IRAN_monthly_stage2,"C:/Users/67135099/Dropbox/Copernicus 2017/Inventory/ISTI_Monthly/INVENTORY_RUSSSOURCE_IRAN_monthly_stage2.csv")###write out csv file of inventory

INVENTORY_RUSSSOURCE_ISH_monthly_stage2<- read.table("ftp://ftp.ncdc.noaa.gov/pub/data/globaldatabank/monthly/stage2/russsource-ish/INVENTORY_RUSSSOURCE-ISH_monthly_stage2",header = TRUE, fill = TRUE)####enter URL link to file
head(INVENTORY_RUSSSOURCE_ISH_monthly_stage2)
write.csv(INVENTORY_RUSSSOURCE_ISH_monthly_stage2,"C:/Users/67135099/Dropbox/Copernicus 2017/Inventory/ISTI_Monthly/INVENTORY_RUSSSOURCE_ISH_monthly_stage2.csv")###write out csv file of inventory

INVENTORY_RUSSSOURCE_MEXICO_monthly_stage2<- read.table("ftp://ftp.ncdc.noaa.gov/pub/data/globaldatabank/monthly/stage2/russsource-mexico/INVENTORY_RUSSSOURCE-MEXICO_monthly_stage2",header = TRUE, fill = TRUE)####enter URL link to file
head(INVENTORY_RUSSSOURCE_MEXICO_monthly_stage2)
write.csv(INVENTORY_RUSSSOURCE_MEXICO_monthly_stage2,"C:/Users/67135099/Dropbox/Copernicus 2017/Inventory/ISTI_Monthly/INVENTORY_RUSSSOURCE_MEXICO_monthly_stage2.csv")###write out csv file of inventory

INVENTORY_RUSSSOURCE_NEW_ZEALAND_monthly_stage2<- read.table("ftp://ftp.ncdc.noaa.gov/pub/data/globaldatabank/monthly/stage2/russsource-new-zealand/INVENTORY_RUSSSOURCE-NEW-ZEALAND_monthly_stage2",header = TRUE, fill = TRUE)####enter URL link to file
head(INVENTORY_RUSSSOURCE_NEW_ZEALAND_monthly_stage2)
write.csv(INVENTORY_RUSSSOURCE_NEW_ZEALAND_monthly_stage2,"C:/Users/67135099/Dropbox/Copernicus 2017/Inventory/ISTI_Monthly/INVENTORY_RUSSSOURCE_NEW_ZEALAND_monthly_stage2.csv")###write out csv file of inventory

INVENTORY_RUSSSOURCE_SOUTH_AFRICA_monthly_stage2<- read.table("ftp://ftp.ncdc.noaa.gov/pub/data/globaldatabank/monthly/stage2/russsource-south-africa/INVENTORY_RUSSSOURCE-SOUTH-AFRICA_monthly_stage2",header = TRUE, fill = TRUE)####enter URL link to file
head(INVENTORY_RUSSSOURCE_SOUTH_AFRICA_monthly_stage2)
write.csv(INVENTORY_RUSSSOURCE_SOUTH_AFRICA_monthly_stage2,"C:/Users/67135099/Dropbox/Copernicus 2017/Inventory/ISTI_Monthly/INVENTORY_RUSSSOURCE_SOUTH_AFRICA_monthly_stage2.csv")###write out csv file of inventory

INVENTORY_RUSSSOURCE_TDXX_MERGE_monthly_stage2<- read.table("ftp://ftp.ncdc.noaa.gov/pub/data/globaldatabank/monthly/stage2/russsource-tdxx-merge/INVENTORY_RUSSSOURCE-TDXX-MERGE_monthly_stage2",header = TRUE, fill = TRUE)####enter URL link to file
head(INVENTORY_RUSSSOURCE_TDXX_MERGE_monthly_stage2)
write.csv(INVENTORY_RUSSSOURCE_TDXX_MERGE_monthly_stage2,"C:/Users/67135099/Dropbox/Copernicus 2017/Inventory/ISTI_Monthly/INVENTORY_RUSSSOURCE_TDXX_MERGE_monthly_stage2.csv")###write out csv file of inventory

INVENTORY_RUSSSOURCE_WWR_monthly_stage2<- read.table("ftp://ftp.ncdc.noaa.gov/pub/data/globaldatabank/monthly/stage2/russsource-wwr/INVENTORY_RUSSSOURCE-WWR_monthly_stage2",header = TRUE, fill = TRUE)####enter URL link to file
head(INVENTORY_RUSSSOURCE_WWR_monthly_stage2)
write.csv(INVENTORY_RUSSSOURCE_WWR_monthly_stage2,"C:/Users/67135099/Dropbox/Copernicus 2017/Inventory/ISTI_Monthly/INVENTORY_RUSSSOURCE_WWR_monthly_stage2.csv")###write out csv file of inventory

INVENTORY_UGANDA_monthly_stage2<- read.table("ftp://ftp.ncdc.noaa.gov/pub/data/globaldatabank/monthly/stage2/uganda/INVENTORY_UGANDA_monthly_stage2",header = TRUE, fill = TRUE)####enter URL link to file
head(INVENTORY_UGANDA_monthly_stage2)
write.csv(INVENTORY_UGANDA_monthly_stage2,"C:/Users/67135099/Dropbox/Copernicus 2017/Inventory/ISTI_Monthly/INVENTORY_UGANDA_monthly_stage2.csv")###write out csv file of inventory

INVENTORY_UKMET_HIST_monthly_stage2<- read.table("ftp://ftp.ncdc.noaa.gov/pub/data/globaldatabank/monthly/stage2/ukmet-hist/INVENTORY_UKMET-HIST_monthly_stage2",header = TRUE, fill = TRUE)####enter URL link to file
head(INVENTORY_UKMET_HIST_monthly_stage2)
write.csv(INVENTORY_UKMET_HIST_monthly_stage2,"C:/Users/67135099/Dropbox/Copernicus 2017/Inventory/ISTI_Monthly/INVENTORY_UKMET_HIST_monthly_stage2.csv")###write out csv file of inventory

INVENTORY_WMSSC_monthly_stage2<- read.table("ftp://ftp.ncdc.noaa.gov/pub/data/globaldatabank/monthly/stage2/wmssc/INVENTORY_WMSSC_monthly_stage2",header = TRUE, fill = TRUE)####enter URL link to file
head(INVENTORY_WMSSC_monthly_stage2)
write.csv(INVENTORY_WMSSC_monthly_stage2,"C:/Users/67135099/Dropbox/Copernicus 2017/Inventory/ISTI_Monthly/INVENTORY_WMSSC_monthly_stage2.csv")###write out csv file of inventory

INVENTORY_WWR_monthly_stage2<- read.table("ftp://ftp.ncdc.noaa.gov/pub/data/globaldatabank/monthly/stage2/wwr/INVENTORY_WWR_monthly_stage2",header = TRUE, fill = TRUE)####enter URL link to file
head(INVENTORY_WWR_monthly_stage2)
write.csv(INVENTORY_WWR_monthly_stage2,"C:/Users/67135099/Dropbox/Copernicus 2017/Inventory/ISTI_Monthly/INVENTORY_WWR_monthly_stage2.csv")###write out csv file of inventory

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
write.csv(all_data,"C:/Users/67135099/Dropbox/Copernicus 2017/Inventory/ISTI_Monthly/INVENTORY_ISTI_monthly_combv2.csv")###write out csv file of inventory
