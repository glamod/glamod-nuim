# -*- coding: utf-8 -*-
"""
Created on Thu Nov 11 16:31:58 2021

@author: snoone
"""
 ###FTP transfer of most up to date diff file for the GHCND from NOAA/NCEI 
    #####
import ftplib
import os 
import tarfile
os.chdir(r"/gws/nopw/j04/c3s311a_lot2/data/level0/land/daily_data_processing/ghcnd_diff_updates") 
#Open ftp connection works OK and get the last update tar.gz file (diff)
ftp = ftplib.FTP('ftp.ncdc.noaa.gov')
ftp.login(user='anonymous', passwd = 'anonymous')
names = ftp.nlst("/pub/data/ghcn/daily/superghcnd/*.tar.gz")
#names ='*tar.gz'
latest_time = None
latest_name = None

for name in names:
    time = ftp.voidcmd("MDTM " + name)
    if (latest_time is None) or (time > latest_time):
        latest_name = name
        latest_time = time


##split the string to remove the path and get the file name
split=latest_name.split("/")

latest_file=split[6]
print(latest_file)

last_file = open('last_file.txt', 'r').read()
##compare todays file name with yesterdays if same quit else continue
if latest_file == last_file:
    ftp.quit()
    print ("not updated")
else:
    print("updated")
    import ftplib
    path = '/pub/data/ghcn/daily/superghcnd/'
    filename = (latest_file)
    ftp = ftplib.FTP("ftp.ncdc.noaa.gov") 
    ftp.login("anonymous", "anonymous") 
    ftp.cwd(path)
    ftp.retrbinary("RETR " + filename, open(filename, 'wb').write)
    with open("last_file.txt", "w") as output:
        output.write(str(filename))
        ftp.quit()
 ##download the last updated file (latest_file) to current directory
SOURCE_DIR = "/gws/nopw/j04/c3s311a_lot2/data/level0/land/daily_data_processing/ghcnd_diff_updates"
OUTPUT_DIR = "/gws/nopw/j04/c3s311a_lot2/data/level0/land/daily_data_processing/ghcnd_diff_updates"
last_file = open(os.path.join(SOURCE_DIR, 'last_file.txt'), 'r').read()
dir_name = last_file.split(".")[0]
dir_path = os.path.join(OUTPUT_DIR, dir_name)


    # use last_file to untar the most recent file
tar_gz = os.path.join(SOURCE_DIR, last_file)
    #tar_gz = os.path.join(OUTPUT_DIR, dir_name)
print(f'[INFO] Untarring: {tar_gz} --> {last_file}')

tf = tarfile.open(tar_gz)
tf.extractall("/gws/nopw/j04/c3s311a_lot2/data/level0/land/daily_data_processing/ghcnd_diff_updates")

## strat processing the new daily update files.
import glob
import pandas as pd
import numpy as np
pd.options.mode.chained_assignment = None  # default='warn'

#set all the output directories and initial working directory

OUTDIR4 = "/gws/nopw/j04/c3s311a_lot2/data/level2/land/daily_updates/header_tables"
OUTDIR3 = "/gws/nopw/j04/c3s311a_lot2/data/level2/land/daily_updates/observations_tables"
OUTDIR2= "/gws/nopw/j04/c3s311a_lot2/data/level2/land/daily_updates/qc_tables"
OUTDIR = "/gws/nopw/j04/c3s311a_lot2/data/level2/land/daily_updates/cdm_lite_tables"
os.chdir("/gws/nopw/j04/c3s311a_lot2/data/level0/land/daily_data_processing/ghcnd_diff_updates")

# read the last file processed details in last_f.txt whohc shwos tehlast date proecessed by the code
last_f=pd.read_csv("/gws/nopw/j04/c3s311a_lot2/data/level0/land/daily_data_processing/ghcnd_diff_updates/last_file.txt","sep=\t", header = None)
# remove unwanted text from the last_f to ceraet the details of the untarred dircetrpy where the  new insert.csv file exists
# need to write that recognises a new daily update directory exists and contimues to process 
last_f.columns=["file"]
filename= last_f[["file"]]
last_f["file"] = last_f["file"].str[:36]
filename["file"] = filename["file"].str[:36]
filename["file"] = filename["file"].str[16:]
filename=filename.iloc[0]["file"]
last_f = last_f.iloc[0]["file"]

# read in the insert.csv file for procesing
df=pd.read_csv("/gws/nopw/j04/c3s311a_lot2/data/level0/land/daily_data_processing/ghcnd_diff_updates"+last_f+"/insert.csv", sep=",", header = None)
# add column headers
df.columns=["Station_ID", "Date", "observed_variable", "observation_value","quality_flag","Measurement_flag","Source_flag","hour"]
df = df.astype(str)
df = df[df["observed_variable"].isin(["SNWD", "PRCP", "TMIN", "TMAX", "TAVG", "SNOW", "AWND", "AWDR", "WESD"])]
df["Source_flag"]=df["Source_flag"]. astype(str) 
df['Source_flag'] = df['Source_flag'].str.replace("0","c")
df['Source_flag'] = df['Source_flag'].str.replace("6","n")
df['Source_flag'] = df['Source_flag'].str.replace("7","t")
df['Source_flag'] = df['Source_flag'].str.replace("A","224")
df['Source_flag'] = df['Source_flag'].str.replace("c","161")
df['Source_flag'] = df['Source_flag'].str.replace("n","162")
df['Source_flag'] = df['Source_flag'].str.replace("t","120")
df['Source_flag'] = df['Source_flag'].str.replace("A","224")
df['Source_flag'] = df['Source_flag'].str.replace("a","225")
df['Source_flag'] = df['Source_flag'].str.replace("B","159")
df['Source_flag'] = df['Source_flag'].str.replace("b","226")
df['Source_flag'] = df['Source_flag'].str.replace("C","227")
df['Source_flag'] = df['Source_flag'].str.replace("D","228")
df['Source_flag'] = df['Source_flag'].str.replace("E","229")
df['Source_flag'] = df['Source_flag'].str.replace("F","230")
df['Source_flag'] = df['Source_flag'].str.replace("G","231")
df['Source_flag'] = df['Source_flag'].str.replace("H","160")
df['Source_flag'] = df['Source_flag'].str.replace("I","232")
df['Source_flag'] = df['Source_flag'].str.replace("K","233")
df['Source_flag'] = df['Source_flag'].str.replace("M","234")
df['Source_flag'] = df['Source_flag'].str.replace("N","235")
df['Source_flag'] = df['Source_flag'].str.replace("Q","236")
df['Source_flag'] = df['Source_flag'].str.replace("R","237")
df['Source_flag'] = df['Source_flag'].str.replace("r","238")
df['Source_flag'] = df['Source_flag'].str.replace("S","166")
df['Source_flag'] = df['Source_flag'].str.replace("s","239")
df['Source_flag'] = df['Source_flag'].str.replace("T","240")
df['Source_flag'] = df['Source_flag'].str.replace("U","241")
df['Source_flag'] = df['Source_flag'].str.replace("u","242")
df['Source_flag'] = df['Source_flag'].str.replace("W","163")
df['Source_flag'] = df['Source_flag'].str.replace("X","164")
df['Source_flag'] = df['Source_flag'].str.replace("Z","165")
df['Source_flag'] = df['Source_flag'].str.replace("z","243")
df['Source_flag'] = df['Source_flag'].str.replace("m","196")
 
# set the value significnace for each variable
df["value_significance"]="" 
df['observed_variable'] = df['observed_variable'].str.replace("SNWD","53")
df.loc[df['observed_variable'] == "53", 'value_significance'] = '13'
df['observed_variable'] = df['observed_variable'].str.replace("PRCP","44")
df.loc[df['observed_variable'] == "44", 'value_significance'] = "13" 
df.loc[df['observed_variable'] == "TMIN", 'value_significance'] = '1'
df['observed_variable'] = df['observed_variable'].str.replace("TMIN","85")
df.loc[df['observed_variable'] == "TMAX", 'value_significance'] = '0'
df['observed_variable'] = df['observed_variable'].str.replace("TMAX","85")
df.loc[df['observed_variable'] == "TAVG", 'value_significance'] = '2'
df['observed_variable'] = df['observed_variable'].str.replace("TAVG","85")
df['observed_variable'] = df['observed_variable'].str.replace("SNOW","45")
df.loc[df['observed_variable'] == "45", 'value_significance'] = '13'
df['observed_variable'] = df['observed_variable'].str.replace("AWND","107")
df.loc[df['observed_variable'] == "107", 'value_significance'] = '2'
df['observed_variable'] = df['observed_variable'].str.replace("AWDR","106")
df.loc[df['observed_variable'] == "106", 'value_significance'] = '2'
df['observed_variable'] = df['observed_variable'].str.replace("WESD","55")
df.loc[df['observed_variable'] == "55", 'value_significance'] = '13' 
# set the unkts for each variable
df["units"]=""
df.loc[df['observed_variable'] == "85", 'units'] = '5' 
df.loc[df['observed_variable'] == "44", 'units'] = '710'
df.loc[df['observed_variable'] == "45", 'units'] = '710'
df.loc[df['observed_variable'] == "55", 'units'] = '710' 
df.loc[df['observed_variable'] == "106", 'units'] = '731' 
df.loc[df['observed_variable'] == "107", 'units'] = "320"
df.loc[df['observed_variable'] == "53", 'units'] = '715' 

# set each height above station surface for each variable
df["observation_height_above_station_surface"]=""
df.loc[df['observed_variable'] == "85", 'observation_height_above_station_surface'] = '2' 
df.loc[df['observed_variable'] == "44", 'observation_height_above_station_surface'] = '1'
df.loc[df['observed_variable'] == "45", 'observation_height_above_station_surface'] = '1'
df.loc[df['observed_variable'] == "55", 'observation_height_above_station_surface'] = '1' 
df.loc[df['observed_variable'] == "106", 'observation_height_above_station_surface'] = '10' 
df.loc[df['observed_variable'] == "107", 'observation_height_above_station_surface'] = "10"
df.loc[df['observed_variable'] == "53", 'observation_height_above_station_surface'] = "1"
 
# add all columns for cdmlite
df['year'] = df['Date'].str[:4]
df['month'] = df['Date'].map(lambda x: x[4:6])
df['day'] = df['Date'].map(lambda x: x[6:8])
df["hour"] ="00"
df["Minute"]="00"
df["report_type"]="3"
df["source_id"]=df["Source_flag"]
df["date_time_meaning"]="1"
df["observation_duration"]="13"
df["platform_type"]=""
df["station_type"]="1"
df["observation_id"]=""
df["data_policy_licence"]="" 
df["primary_station_id"]=df["Station_ID"]
df["qc_method"]=df["quality_flag"].astype(str)
df["quality_flag"]=df["quality_flag"].astype(str)

# set quality flag to pass 0 or fail 1
df.quality_flag[df.quality_flag == "nan"] = "0"
df.quality_flag = df.quality_flag.str.replace('D', '1') \
 .str.replace('G', '1') \
     .str.replace('I', '1')\
         .str.replace('K', '1')\
             .str.replace('L', '1')\
                 .str.replace('M', '1')\
                     .str.replace('N', '1')\
                         .str.replace('O', '1')\
                             .str.replace('R', '1')\
                                 .str.replace('S', '1')\
                                     .str.replace('T', '1')\
                                         .str.replace('W', '1')\
                                             .str.replace('X', '1')\
                                                 .str.replace('Z', '1')\
                                                   .str.replace('H', '1')\
                                                       .str.replace('P', '1')
#at this point set up new df1 for cdm obeervations table later on                                                    
df1 = df.copy()
                                                       
# SET OBSERVED VALUES TO CDM COMPLIANT values
df["observation_value"] = pd.to_numeric(df["observation_value"],errors='coerce')
# df["observed_variable"] = pd.to_numeric(df["observed_variable"],errors='coerce')
# df['observation_value'] = df['observation_value'].astype(int).round(2)
df['observation_value'] = np.where(df['observed_variable'] == "44",
                                        df['observation_value'] / 10,
                                        df['observation_value']).round(2)
df['observation_value'] = np.where(df['observed_variable'] == "53",
                                        df['observation_value'] / 10,
                                        df['observation_value']).round(2)
df['observation_value'] = np.where(df['observed_variable'] == "85",
                                        df['observation_value'] / 10 + 273.15,
                                        df['observation_value']).round(2)
df['observation_value'] = np.where(df['observed_variable'] == '45',
                                        df['observation_value'] / 10,
                                        df['observation_value']).round(2)
df['observation_value'] = np.where(df['observed_variable'] == '55',
                                        df['observation_value'] / 10,
                                        df['observation_value']).round(2)

# print (df.dtypes)                       
# add timestamp to df and create report id
df["Timestamp2"] = df["year"].map(str) + "-" + df["month"].map(str)+ "-" + df["day"].map(str)  
df["Seconds"]="00"
df["offset"]="+00"
df["date_time"] = df["Timestamp2"].map(str)+ " " + df["hour"].map(str)+":"+df["Minute"].map(str)+":"+df["Seconds"].map(str) 
df.date_time = df.date_time + '+00'
df["report_id"]=df["date_time"]  
df['primary_station_id_2']=df['primary_station_id'].astype(str)+'-'+df['source_id'].astype(str)
df["observation_value"] = pd.to_numeric(df["observation_value"],errors='coerce')
df = df.astype(str)                                       
df['source_id'] = df['source_id'].astype(str).apply(lambda x: x.replace('.0',''))
df['primary_station_id_2']=df['primary_station_id'].astype(str)+'-'+df['source_id'].astype(str)
 
# add in location infromatin ro cdm lite station 
df2=pd.read_csv("/gws/nopw/j04/c3s311a_lot2/data/level0/land/daily_data_processing/ghcnd_diff_updates/code/record_id_dy.csv")
df['primary_station_id_2'] = df['primary_station_id_2'].astype(str)
df2 = df2.astype(str)
df= df2.merge(df, on=['primary_station_id_2'])
df['data_policy_licence'] = df['data_policy_licence_x']
df['data_policy_licence'] = df['data_policy_licence'].astype(str).apply(lambda x: x.replace('.0',''))
df["observation_value"] = pd.to_numeric(df["observation_value"],errors='coerce')
df = df.fillna("null")
df = df.replace({"null":""})
 
#set up master df to extrcat each variable
    
df["latitude"] = pd.to_numeric(df["latitude"],errors='coerce')
df["longitude"] = pd.to_numeric(df["longitude"],errors='coerce')
df["latitude"]= df["latitude"].round(3)
df["longitude"]= df["longitude"].round(3)

# add observation id to datafrme
df["dates"]=""
df["dates"]=df["report_id"].str[:-11]
df['observation_id']=df['primary_station_id'].astype(str)+'-'+df['record_number'].astype(str)+'-'+df['dates'].astype(str)
df['observation_id'] = df['observation_id'].str.replace(r' ', '-')
df["observation_id"]=df["observation_id"]+df['observed_variable']+'-'+df['value_significance']
df["primary_id"]=df["primary_station_id"]

# merge in station list csv that contains the stations with multilpe variables available for processing
# this  removes all stations with only one variable
 
station_list=pd.read_csv("/gws/nopw/j04/c3s311a_lot2/data/level0/land/daily_data_processing/ghcnd_diff_updates/code/station_list_dy.csv")
df['primary_id'] = df['primary_id'].astype(str)
station_list= station_list.astype(str)
df= df.merge(station_list, on=['primary_id'])

 
# extract qc table information

qct= df[["primary_station_id","report_id","record_number","qc_method","quality_flag","observed_variable","value_significance"]]
qct = qct.astype(str)
qct["dates"]=""
qct["dates"]=qct["report_id"].str[:-11]
qct['observation_id']=qct['primary_station_id'].astype(str)+'-'+qct['record_number'].astype(str)+'-'+qct['dates'].astype(str)
qct['observation_id'] = qct['observation_id'].str.replace(r' ', '-')
qct["observation_id"]=qct["observation_id"]+qct['observed_variable']+'-'+qct['value_significance']
qct= qct[["report_id","observation_id","qc_method","quality_flag"]]
qct["quality_flag"] = pd.to_numeric(qct["quality_flag"],errors='coerce')
qct.loc[qct['quality_flag'].notnull(), "quality_flag"] = 1
qct = qct.fillna("Null")
qct.quality_flag[qct.quality_flag == "Null"] = 0
qct.astype(str)
qct['qc_method'] = qct['qc_method'].str.replace("D","16,")
qct['qc_method'] = qct['qc_method'].str.replace("H","30,")
qct['qc_method'] = qct['qc_method'].str.replace("G","17,")
qct['qc_method'] = qct['qc_method'].str.replace("I","18,")
qct['qc_method'] = qct['qc_method'].str.replace("K","19,")
qct['qc_method'] = qct['qc_method'].str.replace("M","20,")
qct['qc_method'] = qct['qc_method'].str.replace("N","22,")
qct['qc_method'] = qct['qc_method'].str.replace("O","23,")
qct['qc_method'] = qct['qc_method'].str.replace("R","24,")
qct['qc_method'] = qct['qc_method'].str.replace("S","25,")
qct['qc_method'] = qct['qc_method'].str.replace("T","26,")
qct['qc_method'] = qct['qc_method'].str.replace("W","27,")
qct['qc_method'] = qct['qc_method'].str.replace("X","28,")
qct['qc_method'] = qct['qc_method'].str.replace("V","12,")
qct['qc_method'] = qct['qc_method'].str.replace("Z","29,")
qct['qc_method'] = qct['qc_method'].str.replace("P","30,")
qct = qct.fillna("null")
qct = qct[qct.qc_method != ""]
qct = qct[qct.qc_method != "nan"]
qct = qct[qct.quality_flag != 0]
qct['qc_method'] = qct['qc_method'].str[:-1]
qct.dropna(subset = ["qc_method"], inplace=True)
qct["quality_flag"]=qct["quality_flag"].astype(int)
   
# reorder df columns
df = df[["observation_id","report_type","date_time","date_time_meaning",
           "latitude","longitude","observation_height_above_station_surface"
           ,"observed_variable","units","observation_value",
           "value_significance","observation_duration","platform_type",
           "station_type","primary_station_id","station_name","quality_flag"
           ,"data_policy_licence","source_id"]]
 
# save one of each file to relevant directory
cdm_type=("qc_definition_")
outname2= os.path.join(OUTDIR2,cdm_type)
qct.to_csv(outname2  +"_"+ filename +".psv.gz", index=False, sep="|",compression="gzip")
          

cdm_type=("cdm_lite_")
outname = os.path.join(OUTDIR,cdm_type)
df.to_csv(outname + filename +".psv.gz", index=False, sep="|",compression="gzip")


    
# copy cdm_lite df to new df for cdm obs

df1= df1[["observation_id","report_type","year","day","month","date_time_meaning",
           "observation_height_above_station_surface","observed_variable","units"
           ,"observation_value","value_significance","observation_duration","platform_type",
           "station_type","primary_station_id","quality_flag"
           ,"data_policy_licence","source_id"]]


#  set up original values            
df1["original_value"]=df1["observation_value"]
df1["observation_value"] = pd.to_numeric(df1["observation_value"],errors='coerce')
df1["original_value"]=df1["observation_value"]
df1['original_value'] = np.where(df1['observed_variable'] == "44",
                                           df1['original_value'] / 10,
                                           df1['original_value']).round(2)
df1['original_value'] = np.where(df1['observed_variable'] == "53",
                                           df1['original_value'] / 10,
                                           df1['original_value']).round(2)
df1['original_value'] = np.where(df1['observed_variable'] == "85",
                                           df1['original_value'] / 10,
                                           df1['original_value']).round(2)
df1["original_value"] = np.where(df1['observed_variable'] == '45',
                                           df1['original_value'] / 10,
                                           df1['original_value']).round(2)
df1['original_value'] = np.where(df1['observed_variable'] == '55',
                                           df1['original_value'] / 10,
                                           df1['original_value']).round(2)
# SET OBSERVED VALUES TO CDM COMPLIANT values
df1["observation_value"] = pd.to_numeric(df1["observation_value"],errors='coerce')

df1['observation_value'] = np.where(df1['observed_variable'] == "44",
                                        df1['observation_value'] / 10,
                                        df1['observation_value']).round(2)
df1['observation_value'] = np.where(df1['observed_variable'] == "53",
                                        df1['observation_value'] / 10,
                                        df1['observation_value']).round(2)
df1['observation_value'] = np.where(df1['observed_variable'] == "85",
                                        df1['observation_value'] / 10 + 273.15,
                                        df1['observation_value']).round(2)
df1['observation_value'] = np.where(df1['observed_variable'] == '45',
                                        df1['observation_value'] / 10,
                                        df1['observation_value']).round(2)
df1['observation_value'] = np.where(df1['observed_variable'] == '55',
                                        df1['observation_value'] / 10,
                                        df1['observation_value']).round(2)

# set the units for each variable
df1["original_units"]=""
df1.loc[df1['observed_variable'] == "85", 'original_units'] = '350' 
df1.loc[df1['observed_variable'] == "44", 'original_units'] = '710'
df1.loc[df1['observed_variable'] == "45", 'original_units'] = '710'
df1.loc[df1['observed_variable'] == "55", 'original_units'] = '710' 
df1.loc[df1['observed_variable'] == "106", 'original_units'] = '731' 
df1.loc[df1['observed_variable'] == "107", 'original_units'] = "320"
df1.loc[df1['observed_variable'] == "53", 'original_units'] = '715'

# set each height above station surface for each variable
df1["observation_height_above_station_surface"]=""
df1.loc[df1['observed_variable'] == "85", 'observation_height_above_station_surface'] = '2' 
df1.loc[df1['observed_variable'] == "44", 'observation_height_above_station_surface'] = '1'
df1.loc[df1['observed_variable'] == "45", 'observation_height_above_station_surface'] = '1'
df1.loc[df1['observed_variable'] == "55", 'observation_height_above_station_surface'] = '1' 
df1.loc[df1['observed_variable'] == "106", 'observation_height_above_station_surface'] = '10' 
df1.loc[df1['observed_variable'] == "107", 'observation_height_above_station_surface'] = "10"
df1.loc[df1['observed_variable'] == "53", 'observation_height_above_station_surface'] = "1"
# set conversion flags for variables
df1["conversion_flag"]=""
df1.loc[df1['observed_variable'] == "85", 'conversion_flag'] = '0' 
df1.loc[df1['observed_variable'] == "44", 'conversion_flag'] = '2'
df1.loc[df1['observed_variable'] == "45", 'conversion_flag'] = '2'
df1.loc[df1['observed_variable'] == "55", 'conversion_flag'] = '2' 
df1.loc[df1['observed_variable'] == "106", 'conversion_flag'] = '2' 
df1.loc[df1['observed_variable'] == "107", 'conversion_flag'] = "2"
df1.loc[df1['observed_variable'] == "53", 'conversion_flag'] = "2"
# set conversion method for variables
df1["conversion_method"]=""
df1.loc[df1['observed_variable'] == "85", 'conversion_method'] = '1' 
# set numerical precision for variables
df1["numerical_precision"]=""
df1.loc[df1['observed_variable'] == "85", 'numerical_precision'] = '0.01' 
df1.loc[df1['observed_variable'] == "44", 'numerical_precision'] = '0.1'
df1.loc[df1['observed_variable'] == "45", 'numerical_precision'] = '0.1'
df1.loc[df1['observed_variable'] == "55", 'numerical_precision'] = '0.1' 
df1.loc[df1['observed_variable'] == "106", 'numerical_precision'] = '0.1' 
df1.loc[df1['observed_variable'] == "107", 'numerical_precision'] = "0.1"
df1.loc[df1['observed_variable'] == "53", 'numerical_precision'] = "1"
df1["original_precision"]=""
df1.loc[df1['observed_variable'] == "85", 'original_precision'] = '0.1' 
df1.loc[df1['observed_variable'] == "44", 'original_precision'] = '0.1'
df1.loc[df1['observed_variable'] == "45", 'original_precision'] = '0.1'
df1.loc[df1['observed_variable'] == "55", "original_precision"] = '0.1' 
df1.loc[df1['observed_variable'] == "106", 'original_precision'] = '1' 
df1.loc[df1['observed_variable'] == "107", 'original_precision'] = "0.1"
df1.loc[df1['observed_variable'] == "53", 'original_precision'] = "1"

# add all columns for cdm_obs
df1["hour"] ="00"
df1["Minute"]="00"
df1["report_type"]="3"
df1["platform_type"]=""
df1["station_type"]="1"
df1["crs"]=""
df1["z_coordinate"]=""
df1["z_coordinate_type"]=""
df1["secondary_variable"]=""
df1["secondary_value"]=""
df1["code_table"]=""
df1["sensor_id"]=""
df1["sensor_automation_status"]=""
df1["exposure_of_sensor"]=""
df1["processing_code"]=""
df1["processing_level"]="0"
df1["adjustment_id"]=""
df1["traceability"]=""
df1["advanced_qc"]=""
df1["advanced_uncertainty"]=""
df1["advanced_homogenisation"]=""
df1["advanced_assimilation_feedback"]=""
df1["source_record_id"]=""
df1["location_method"]=""
df1["location_precision"]=""
df1["z_coordinate_method"]=""
df1["bbox_min_longitude"]=""
df1["bbox_max_longitude"]=""
df1["bbox_min_latitude"]=""
df1["bbox_max_latitude"]=""
df1["spatial_representativeness"]=""
df1["original_code_table"]=""
df1["report_id"]=df1["observation_id"].str[:24]


# add timestamp to df1 and create report id
df1["Timestamp2"] = df1["year"].map(str) + "-" + df1["month"].map(str)+ "-" + df1["day"].map(str) 
df1["Seconds"]="00"
df1["offset"]="+00"
df1["date_time"] = df1["Timestamp2"].map(str)+ " " + df1["hour"].map(str)+":"+df1["Minute"].map(str)+":"+df1["Seconds"].map(str) 
df1.date_time = df1.date_time + '+00'
df1["dates"]=df1["date_time"].str[:-11]
df1['primary_station_id_2']=df1['primary_station_id'].astype(str)+'-'+df1['source_id'].astype(str)
df1["observation_value"] = pd.to_numeric(df1["observation_value"],errors='coerce')
df1 = df1.astype(str) 
df1['source_id'] = df1['source_id'].astype(str).apply(lambda x: x.replace('.0',''))
df1['primary_station_id_2']=df1['primary_station_id'].astype(str)+'-'+df1['source_id'].astype(str)

# add in location information to cdm obs
df12=pd.read_csv("/gws/nopw/j04/c3s311a_lot2/data/level0/land/daily_data_processing/ghcnd_diff_updates/code/record_id_dy.csv")
df1['primary_station_id_2'] = df1['primary_station_id_2'].astype(str)
df12 = df12.astype(str)
df1= df12.merge(df1, on=['primary_station_id_2'])
df1['data_policy_licence'] = df1['data_policy_licence_x']
df1['data_policy_licence'] = df1['data_policy_licence'].astype(str).apply(lambda x: x.replace('.0',''))
df1["observation_value"] = pd.to_numeric(df1["observation_value"],errors='coerce')
df1 = df1.fillna("null")
df1 = df1.replace({"null":""})

# set up master df1 to extract each variable
df1["latitude"] = pd.to_numeric(df1["latitude"],errors='coerce')
df1["longitude"] = pd.to_numeric(df1["longitude"],errors='coerce')
df1["latitude"]= df1["latitude"].round(3)
df1["longitude"]= df1["longitude"].round(3)

# add observation id to datafrme
df1['observation_id']=df1['primary_station_id'].astype(str)+'-'+df1['record_number'].astype(str)+'-'+df1['dates'].astype(str)
df1['observation_id'] = df1['observation_id'].str.replace(r' ', '-')
df1["observation_id"]=df1["observation_id"]+df1['observed_variable']+'-'+df1['value_significance']

# create report_id fom observation_id
df1['report_id']=df1['primary_station_id'].astype(str)+'-'+df1['record_number'].astype(str)+'-'+df1['dates'].astype(str)
df1['report_id'] = df1['report_id'].str.strip()

# reorder df1 columns
df1 = df1[["observation_id","report_id","data_policy_licence","date_time",
"date_time_meaning","observation_duration","longitude","latitude",
"crs","z_coordinate","z_coordinate_type","observation_height_above_station_surface",
"observed_variable","secondary_variable","observation_value",
"value_significance","secondary_value","units","code_table",
"conversion_flag","location_method","location_precision",
"z_coordinate_method","bbox_min_longitude","bbox_max_longitude",
"bbox_min_latitude","bbox_max_latitude","spatial_representativeness",
"quality_flag","numerical_precision","sensor_id","sensor_automation_status",
"exposure_of_sensor","original_precision","original_units",
"original_code_table","original_value","conversion_method",
"processing_code","processing_level","adjustment_id","traceability",
"advanced_qc","advanced_uncertainty","advanced_homogenisation",
"advanced_assimilation_feedback","source_id"]]

# save one file to relevant directory
cdm_type=("cdm_observations_")
outname3 = os.path.join(OUTDIR3,cdm_type)
df1.to_csv(outname3+"_"+ filename +".psv.gz", index=False, sep="|",compression="gzip")


# make header from completed observations table

os.chdir("/gws/nopw/j04/c3s311a_lot2/data/level2/land/daily_updates/observations_tables")
col_list = ["observation_id", "report_id", "longitude", "latitude", "source_id","date_time"]
extension = 'psv'
all_filenames = [i for i in glob.glob('*.{}'.format(extension))]

for filenames in all_filenames:
    merged_df=pd.read_csv(filenames, sep="|", usecols=col_list)
    merged_df["report_id"] = merged_df["report_id"].str.strip()
    hdf = pd.DataFrame() 
    hdf['extract_record'] = merged_df['report_id'].str[:-11]
    hdf['station_record_number'] = hdf['extract_record'].str[12:]
    hdf['primary_station_id'] = hdf['extract_record'].str[:11]                                           
    hdf["report_id"]=merged_df["report_id"]
    hdf["application_area"]=""
    hdf["observing_programme"]=""
    hdf["report_type"]="3"
    hdf["station_type"]="1"
    hdf["platform_type"]=""
    hdf["primary_station_id_scheme"]="13"
    hdf["location_accuracy"]="0.1"
    hdf["location_method"]=""
    hdf["location_quality"]="3"
    hdf["crs"]="0"
    hdf["station_speed"]=""  
    hdf["station_course"]=""
    hdf["station_heading"]=""
    hdf["height_of_station_above_local_ground"]=""
    hdf["height_of_station_above_sea_level_accuracy"]=""
    hdf["sea_level_datum"]=""
    hdf["report_meaning_of_timestamp"]="1"
    hdf["report_timestamp"]=""
    hdf["report_duration"]="13"
    hdf["report_time_accuracy"]=""
    hdf["report_time_quality"]=""
    hdf["report_time_reference"]="0"
    hdf["platform_subtype"]=""
    hdf["profile_id"]=""
    hdf["events_at_station"]=""
    hdf["report_quality"]=""
    hdf["duplicate_status"]="4"
    hdf["duplicates"]=""
    hdf["source_record_id"]=""
    hdf ["processing_codes"]=""
    hdf["longitude"]=merged_df["longitude"]
    hdf["latitude"]=merged_df["latitude"]
    hdf["source_id"]=merged_df["source_id"]
    hdf['record_timestamp'] = pd.to_datetime('now').strftime("%Y-%m-%d %H:%M:%S")
    hdf.record_timestamp = hdf.record_timestamp + '+00'
    hdf["history"]=""
    hdf["processing_level"]="0"
    hdf["report_timestamp"]=merged_df["date_time"]
    hdf['primary_station_id_3']=hdf['primary_station_id'].astype(str)+'-'+hdf['source_id'].astype(str)+'-'+hdf['station_record_number'].astype(str)
    hdf["duplicates_report"]=hdf["report_id"]
       
    del merged_df
                     
    df2=pd.read_csv("/gws/nopw/j04/c3s311a_lot2/data/level0/land/daily_data_processing/ghcnd_diff_updates/code/record_id_dy.csv")
    hdf = hdf.astype(str)
    df2 = df2.astype(str)
    hdf= df2.merge(hdf, on=['primary_station_id_3'])
    hdf['height_of_station_above_sea_level'] = hdf['height_of_station_above_sea_level'].astype(str).apply(lambda x: x.replace('.0',''))
    # added in thsi bit of code#
    hdf = hdf.rename(columns={"latitude_x":"latitude",})
    hdf = hdf.rename(columns={"longitude_x":"longitude",})
    hdf["latitude"] = pd.to_numeric(hdf["latitude"],errors='coerce')
    hdf["longitude"] = pd.to_numeric(hdf["longitude"],errors='coerce')
    hdf["latitude"]= hdf["latitude"].round(3)
    hdf["longitude"]= hdf["longitude"].round(3)
    
    del df2
    
    hdf=hdf.drop_duplicates(subset=['duplicates_report'])

    hdf = hdf[["report_id","region","sub_region","application_area",
              "observing_programme","report_type","station_name",
              "station_type","platform_type","platform_subtype","primary_station_id",
              "station_record_number","primary_station_id_scheme",
              "longitude","latitude","location_accuracy","location_method",
              "location_quality","crs","station_speed","station_course",
              "station_heading","height_of_station_above_local_ground",
              "height_of_station_above_sea_level","height_of_station_above_sea_level_accuracy",
              "sea_level_datum","report_meaning_of_timestamp","report_timestamp",
              "report_duration","report_time_accuracy","report_time_quality",
              "report_time_reference","profile_id","events_at_station","report_quality",
              "duplicate_status","duplicates","record_timestamp","history",
              "processing_level","processing_codes","source_id","source_record_id"]]
    
    hdf.sort_values("report_timestamp")
    hdf['report_id'] = hdf['report_id'].str.strip()
  
    hdf['region'] = hdf['region'].astype(str).apply(lambda x: x.replace('.0',''))
    hdf['sub_region'] = hdf['sub_region'].astype(str).apply(lambda x: x.replace('.0',''))
    
    # save file to relevant directory 
    cdm_type2=("cdm_header_")
    outname4 = os.path.join(OUTDIR4,cdm_type2)
    hdf.to_csv(outname4  +"_"+ filename +".psv.gz", index=False, sep="|",compression="gzip")
    
   
        
    
# delete processed folder from directory
import os 
import shutil
import glob
import pandas as pd
last_f=pd.read_csv("/gws/nopw/j04/c3s311a_lot2/data/level0/land/daily_data_processing/ghcnd_diff_updates/last_file.txt","sep=\t", header = None)
# remove unwanted text from the last_f to create the details of the untarred directory where the  new insert.csv file exists
last_f.columns=["file"]
filename= last_f[["file"]]
last_f["file"] = last_f["file"].str[:36]
filename["file"] = filename["file"].str[:36]
filename["file"] = filename["file"].str[16:]
filename=filename.iloc[0]["file"]
last_f = last_f.iloc[0]["file"]
dir_path = "/gws/nopw/j04/c3s311a_lot2/data/level0/land/daily_data_processing/ghcnd_diff_updates/"+last_f

try:
    shutil.rmtree(dir_path)
except OSError as e:
    print("Error: %s : %s" % (dir_path, e.strerror))
    
    

          




    
              
 


  
       
       
       
       
    
    
   

