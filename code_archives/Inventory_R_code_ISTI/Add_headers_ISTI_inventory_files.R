###r###read invenmtory csv files and add column header information
info<-read.csv("INVENTORY_GSOD_daily.csv",header = TRUE, fill = TRUE)###change with in csv name
head(info)
SOURCE_NAME<-info[1,1]##source
SOURCE_NAME2=as.character(SOURCE_NAME)###CONVERT TO TEXT
DOMAIN<-info[1,4]##domain
DOMAIN=as.character(DOMAIN)###CONVERT TO TEXT
NORTH_BOUND<-max(info$LATITUDE)##northbound
SOUTH_BOUND<-min(info$LATITUDE)##southbound
EAST_BOUND<-max(info$LONGITUDE)##eastbound
WEST_BOUND<-min(info$LONGITUDE)##westbound
DATA_FIRST_YEAR<-min(info$DATA_START_YEAR)##data start year
DATA_END_YEAR<-max(info$DATA_END_YEAR)###data end year 
info$newcolumn <- info$DATA_END_YEAR - info$DATA_START_YEAR ###calculate diff end years from start years
DATA_MEAN_YEARS<-mean(info$newcolumn)## calculte mean data years of source
INVENTORY<-cbind(SOURCE_NAME2,DOMAIN,NORTH_BOUND,SOUTH_BOUND,WEST_BOUND,EAST_BOUND,
                 DATA_FIRST_YEAR,DATA_END_YEAR,DATA_MEAN_YEARS)

 write.csv(INVENTORY,"C:/Users/67135099/Dropbox/Copernicus 2017/Inventory/ISTI_Daily/inv_work/INVENTORY_GSOD_daily.csv")


