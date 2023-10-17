# -*- coding: utf-8 -*-
"""
Created on Thu Jan 26 12:17:19 2023

@author: snoone
"""

import os   
import glob
import pandas as pd
import csv
OUTDIR2 = "C:/Users/snoone/Dropbox/OLD_BELGIAN_AFRICAN_DARE_INVENTORY/Kevin_folder_african_inv/checked_forms_clidar_2022/Macenta_Form_2/dy_temperature/mean"
OUTDIR1 = "C:/Users/snoone/Dropbox/OLD_BELGIAN_AFRICAN_DARE_INVENTORY/Kevin_folder_african_inv/checked_forms_clidar_2022/Macenta_Form_2/dy_temperature/max"
OUTDIR = "C:/Users/snoone/Dropbox/OLD_BELGIAN_AFRICAN_DARE_INVENTORY/Kevin_folder_african_inv/checked_forms_clidar_2022/Macenta_Form_2/dy_temperature/min"
os.chdir("C:/Users/snoone/Dropbox/OLD_BELGIAN_AFRICAN_DARE_INVENTORY/Kevin_folder_african_inv/checked_forms_clidar_2022/Macenta_Form_2/")
extension = 'xlsx'
all_filenames = [i for i in glob.glob('*.{}'.format(extension))]


for filename in all_filenames:
    try:
        df = pd.read_excel(filename,skiprows=6, header=None)
        df.columns = ["Day", "min_t", "max_t", "mean_t","dbt_7","wbt_7","diff_7","Hstate_7","dbt_12","wbt_12","diff_12","Hstate_12","dbt_17","wbt_17","diff_17","Hstate_17","cld_7","cld_12","cld_17"]
    #df=df.drop(columns =["8","9","10","11","12","13"])
   
        df1=pd.read_excel(filename,nrows=0)
        df1 = df1.T.reset_index().T.reset_index(drop=True)
        df1.columns =  ["1", "Station_name", "2", "3","4","Month","6","Year","8","9","10","11","12","13","14","15","16","17","18"]
        df1=df1.drop(columns =["1",  "2", "3","4","6","8","9","10","11","12","13","14","15","16","17","18"])
        df1.to_csv("header.csv",index=False)
        df["Source_ID"] = "383"
        df["Station_ID"]="383-00002"
        df["Station_name"]="Macenta"
        df["Alias_station_name"]=""
        df["Latitude"]="8.533"
        df["Longitude"]="-9.467"
        df["Elevation"]="544"
        df["Source_QC_flag"]=""
        df["Original_observed_value"]=""
        df['Original_observed_value_units']="c"
        df['Report_type_code']=''
        df['Measurement_code_1']=''
        df['Measurement_code_2']='' 
        df2 = pd.read_csv("header.csv",squeeze=True)
        df2 = df2.astype(str)
        df= df2.merge(df, on=['Station_name'])
        df["Minute"]="00"  
        df = df.replace('nt','0', regex=True)
        df = df.replace('NT','0', regex=True)
        df["Station_name"]="Macenta"
        n = 3
## D ropping last n rows using dro
        df.drop(df.tail(n).index,
        inplace = True)
        df=df.dropna(subset = ['min_t'])
    except:
         continue
    
##extract daily tmin 
    try:
        df_tmin=df
        df_tmin=df_tmin.drop(columns =["max_t", "mean_t","dbt_7","wbt_7","diff_7","Hstate_7","dbt_12","wbt_12","diff_12","Hstate_12","dbt_17","wbt_17","diff_17","Hstate_17","cld_7","cld_12","cld_17"])
        df_tmin["Hour"]="7" 
        df_tmin= df_tmin.rename(columns=({'min_t':'Observed_value'}))
        df_tmin["Original_observed_value"]=df_tmin["Observed_value"]
        df_tmin["Observed_value"] = pd.to_numeric(df_tmin["Observed_value"],errors='coerce')
        #df_tmin["Observed_value"]=df_tmin["Observed_value"]/10

        df_tmin = df_tmin[["Source_ID",'Station_ID',"Station_name","Alias_station_name",  
                                 "Year","Month","Day","Hour","Minute",
                                "Latitude","Longitude","Elevation","Observed_value",
                                "Source_QC_flag","Original_observed_value",
                                "Original_observed_value_units",                                
                                "Report_type_code","Measurement_code_1",
                                "Measurement_code_2"]]
  
##change time zones
        df_tmin["Timestamp2"] = df_tmin["Year"].map(str) + "-" + df_tmin["Month"].map(str)+ "-" + df_tmin["Day"].map(str)  
        df_tmin["Timestamp"] = df_tmin["Timestamp2"].map(str)+ " " + df_tmin["Hour"].map(str)+":"+df_tmin["Minute"].map(str)
        df_tmin= df_tmin.drop(columns=["Timestamp2"])
    
        df_tmin['Timestamp'] =  pd.to_datetime(df_tmin['Timestamp'], format='%Y-%m-%d' " ""%H:%M:%S")
        df_tmin['Timestamp'] = df_tmin['Timestamp'].dt.tz_localize('Etc/GMT-0').dt.tz_convert('GMT')
        df_tmin['Year'] = df_tmin['Timestamp'].dt.year 
        df_tmin['Month'] = df_tmin['Timestamp'].dt.month  
        df_tmin['Day'] = df_tmin['Timestamp'].dt.day 
        df_tmin['Hour'] = df_tmin['Timestamp'].dt.hour 
        df_tmin['Minute'] = df_tmin['Timestamp'].dt.minute
        df_tmin['Seconds'] = df_tmin['Timestamp'].dt.second
    
##delete unwanted columns 
        df_tmin = df_tmin.drop(columns="Timestamp")
        df_tmin['Minute']='00'
     
        df_tmin = df_tmin[["Source_ID",'Station_ID',"Station_name","Alias_station_name",  
                                 "Year","Month","Day","Hour","Minute",
                                "Latitude","Longitude","Elevation","Observed_value",
                                "Source_QC_flag","Original_observed_value",
                                "Original_observed_value_units",                                
                                "Report_type_code","Measurement_code_1",
                                "Measurement_code_2"]]
        df_tmin = df_tmin.astype(str)
    

##save output file   
        year=df_tmin.iloc[0]["Year"]
        month=df_tmin.iloc[0]["Month"]
        date=(year+"_"+month)
        source_id=df_tmin.iloc[0]["Source_ID"]
        cdm_type=(date+"_minimum_temperature_"+source_id)
        a = df_tmin['Station_ID'].unique()
        print (a)
        outname = os.path.join(OUTDIR,cdm_type)
      #with open(filename, "w") as outfile:
        df_tmin.to_csv(outname+".psv", index=False, sep="|")

    except:
         continue
    
##extract daily tmax taken 
    try:
        df_tmax=df
        df_tmax=df_tmax.drop(columns =["min_t", "mean_t","dbt_7","wbt_7","diff_7","Hstate_7","dbt_12","wbt_12","diff_12","Hstate_12","dbt_17","wbt_17","diff_17","Hstate_17","cld_7","cld_12","cld_17"])
        df_tmax["Hour"]="7" 
        df_tmax= df_tmax.rename(columns=({'max_t':'Observed_value'}))
        df_tmax["Original_observed_value"]=df_tmax["Observed_value"]
        df_tmax["Observed_value"] = pd.to_numeric(df_tmax["Observed_value"],errors='coerce')
        #df_tmax["Observed_value"]=df_tmax["Observed_value"]/10

        df_tmax = df_tmax[["Source_ID",'Station_ID',"Station_name","Alias_station_name",  
                                 "Year","Month","Day","Hour","Minute",
                                "Latitude","Longitude","Elevation","Observed_value",
                                "Source_QC_flag","Original_observed_value",
                                "Original_observed_value_units",                                
                                "Report_type_code","Measurement_code_1",
                                "Measurement_code_2"]]
  
    #change time zones
        df_tmax["Timestamp2"] = df_tmax["Year"].map(str) + "-" + df_tmax["Month"].map(str)+ "-" + df_tmax["Day"].map(str)  
        df_tmax["Timestamp"] = df_tmax["Timestamp2"].map(str)+ " " + df_tmax["Hour"].map(str)+":"+df_tmax["Minute"].map(str)
        df_tmax= df_tmax.drop(columns=["Timestamp2"])
    
        df_tmax['Timestamp'] =  pd.to_datetime(df_tmax['Timestamp'], format='%Y-%m-%d' " ""%H:%M:%S")
        df_tmax['Timestamp'] = df_tmax['Timestamp'].dt.tz_localize('Etc/GMT-0').dt.tz_convert('GMT')
        df_tmax['Year'] = df_tmax['Timestamp'].dt.year 
        df_tmax['Month'] = df_tmax['Timestamp'].dt.month  
        df_tmax['Day'] = df_tmax['Timestamp'].dt.day 
        df_tmax['Hour'] = df_tmax['Timestamp'].dt.hour 
        df_tmax['Minute'] = df_tmax['Timestamp'].dt.minute
        df_tmax['Seconds'] = df_tmax['Timestamp'].dt.second
    
##delete unwanted columns 
        df_tmax = df_tmax.drop(columns="Timestamp")
        df_tmax['Minute']='00'
    
        df_tmax = df_tmax[["Source_ID",'Station_ID',"Station_name","Alias_station_name",  
                                 "Year","Month","Day","Hour","Minute",
                                "Latitude","Longitude","Elevation","Observed_value",
                                "Source_QC_flag","Original_observed_value",
                                "Original_observed_value_units",                                
                                "Report_type_code","Measurement_code_1",
                                "Measurement_code_2"]]
        df_tmax = df_tmax.astype(str)
#save output file   
        year=df_tmax.iloc[0]["Year"]
        month=df_tmax.iloc[0]["Month"]
        date=(year+"_"+month)
        source_id=df_tmax.iloc[0]["Source_ID"]
        cdm_type=(date+"_maximum_temperature_"+source_id)
     
        a = df_tmax['Station_ID'].unique()
        print (a)
        outname = os.path.join(OUTDIR1,cdm_type)
      #with open(filename, "w") as outfile:
        df_tmax.to_csv(outname+".psv", index=False, sep="|") 
    except:
         continue
     
        ##extract daily tmean taken 
    try:
        df_tmean=df
        df_tmean=df_tmean.drop(columns =["max_t", "min_t","dbt_7","wbt_7","diff_7","Hstate_7","dbt_12","wbt_12","diff_12","Hstate_12","dbt_17","wbt_17","diff_17","Hstate_17","cld_7","cld_12","cld_17"])
        df_tmean["Hour"]="7" 
        df_tmean= df_tmean.rename(columns=({'mean_t':'Observed_value'}))
        df_tmean["Original_observed_value"]=df_tmean["Observed_value"]
        df_tmean["Observed_value"] = pd.to_numeric(df_tmean["Observed_value"],errors='coerce')
        #df_tmean["Observed_value"]=df_tmean["Observed_value"]/10

        df_tmean = df_tmean[["Source_ID",'Station_ID',"Station_name","Alias_station_name",  
                                 "Year","Month","Day","Hour","Minute",
                                "Latitude","Longitude","Elevation","Observed_value",
                                "Source_QC_flag","Original_observed_value",
                                "Original_observed_value_units",                                
                                "Report_type_code","Measurement_code_1",
                                "Measurement_code_2"]]
  
    #change time zones
        df_tmean["Timestamp2"] = df_tmean["Year"].map(str) + "-" + df_tmean["Month"].map(str)+ "-" + df_tmean["Day"].map(str)  
        df_tmean["Timestamp"] = df_tmean["Timestamp2"].map(str)+ " " + df_tmean["Hour"].map(str)+":"+df_tmean["Minute"].map(str)
        df_tmean= df_tmean.drop(columns=["Timestamp2"])
    
        df_tmean['Timestamp'] =  pd.to_datetime(df_tmean['Timestamp'], format='%Y-%m-%d' " ""%H:%M:%S")
        df_tmean['Timestamp'] = df_tmean['Timestamp'].dt.tz_localize('Etc/GMT-0').dt.tz_convert('GMT')
        df_tmean['Year'] = df_tmean['Timestamp'].dt.year 
        df_tmean['Month'] = df_tmean['Timestamp'].dt.month  
        df_tmean['Day'] = df_tmean['Timestamp'].dt.day 
        df_tmean['Hour'] = df_tmean['Timestamp'].dt.hour 
        df_tmean['Minute'] = df_tmean['Timestamp'].dt.minute
        df_tmean['Seconds'] = df_tmean['Timestamp'].dt.second
    
##delete unwanted columns 
        df_tmean = df_tmean.drop(columns="Timestamp")
        df_tmean['Minute']='00'
    
        df_tmean = df_tmean[["Source_ID",'Station_ID',"Station_name","Alias_station_name",  
                                 "Year","Month","Day","Hour","Minute",
                                "Latitude","Longitude","Elevation","Observed_value",
                                "Source_QC_flag","Original_observed_value",
                                "Original_observed_value_units",                                
                                "Report_type_code","Measurement_code_1",
                                "Measurement_code_2"]]
        df_tmean = df_tmean.astype(str)
    

#save output file   
        year=df_tmean.iloc[0]["Year"]
        month=df_tmean.iloc[0]["Month"]
        date=(year+"_"+month)
        source_id=df_tmean.iloc[0]["Source_ID"]
        cdm_type=(date+"_mean_temperature_"+source_id)
     
        a = df_tmean['Station_ID'].unique()
        print (a)
        outname = os.path.join(OUTDIR2,cdm_type)
      #with open(filename, "w") as outfile:
        df_tmean.to_csv(outname+".psv", index=False, sep="|") 
    except:
         continue
    
    
    