# -*- coding: utf-8 -*-
"""
Created on Thu Jan 26 12:17:19 2023

@author: snoone
"""

import os   
import glob
import pandas as pd
import csv
OUTDIR = "C:/Users/snoone/Dropbox/OLD_BELGIAN_AFRICAN_DARE_INVENTORY/Kevin_folder_african_inv/checked_forms_clidar_2022/ANDAPA_Form_2/ANDAPA_Form_2/dryB"
os.chdir("C:/Users/snoone/Dropbox/OLD_BELGIAN_AFRICAN_DARE_INVENTORY/Kevin_folder_african_inv/checked_forms_clidar_2022/ANDAPA_Form_2/ANDAPA_Form_2/1958")
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
        df["Station_ID"]="383-00001"
        df["Station_name"]="Andapa"
        df["Alias_station_name"]=""
        df["Latitude"]="-14.39"
        df["Longitude"]="49.37"
        df["Elevation"]="470"
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
        df = df.replace('NE','0', regex=True)
        n = 4
        
## D ropping last n rows using dro
        df.drop(df.tail(n).index,
        inplace = True)
        df=df.dropna(subset = ['dbt_7'])
    except:
         continue
    
##extract daily tmin 
    try:
        df_dbt=df
        df_dbt=df_dbt.drop(columns =["max_t", "mean_t","min_t","wbt_7","Hstate_7","dbt_12","wbt_12","diff_12","Hstate_12","dbt_17","wbt_17","diff_17","Hstate_17","cld_7","cld_12","cld_17"])
        df_dbt["Hour"]="6" 
        df_dbt= df_dbt.rename(columns=({"dbt_7":'Observed_value'}))
        df_dbt["Original_observed_value"]=df_dbt["Observed_value"]
        df_dbt["Observed_value"] = pd.to_numeric(df_dbt["Observed_value"],errors='coerce')
        df_dbt["Observed_value"]=df_dbt["Observed_value"]#/10

        df_dbt = df_dbt[["Source_ID",'Station_ID',"Station_name","Alias_station_name",  
                                 "Year","Month","Day","Hour","Minute",
                                "Latitude","Longitude","Elevation","Observed_value",
                                "Source_QC_flag","Original_observed_value",
                                "Original_observed_value_units",                                
                                "Report_type_code","Measurement_code_1",
                                "Measurement_code_2"]]
  
 
    except:
         continue
    
##extract daily tmax taken 
    try:
        df_dbt2=df
        df_dbt2=df_dbt2.drop(columns =["min_t", "mean_t","max_t","dbt_7","wbt_7","diff_7","Hstate_7","wbt_12","diff_12","Hstate_12","dbt_17","wbt_17","diff_17","Hstate_17","cld_7","cld_12","cld_17"])
        df_dbt2["Hour"]="12" 
        df_dbt2= df_dbt2.rename(columns=({'dbt_12':'Observed_value'}))
        df_dbt2["Original_observed_value"]=df_dbt2["Observed_value"]
        df_dbt2["Observed_value"] = pd.to_numeric(df_dbt2["Observed_value"],errors='coerce')
        df_dbt2["Observed_value"]=df_dbt2["Observed_value"]#/10

        df_dbt2 = df_dbt2[["Source_ID",'Station_ID',"Station_name","Alias_station_name",  
                                 "Year","Month","Day","Hour","Minute",
                                "Latitude","Longitude","Elevation","Observed_value",
                                "Source_QC_flag","Original_observed_value",
                                "Original_observed_value_units",                                
                                "Report_type_code","Measurement_code_1",
                                "Measurement_code_2"]]
    
    except:
         continue
     
        ##extract daily tmean taken 
    try:
        df_dbt3=df
        df_dbt3=df_dbt3.drop(columns =["max_t", "min_t","mean_t","dbt_7","wbt_7","diff_7","Hstate_7","dbt_12","wbt_12","diff_12","Hstate_12","wbt_17","diff_17","Hstate_17","cld_7","cld_12","cld_17"])
        df_dbt3["Hour"]="18" 
        df_dbt3= df_dbt3.rename(columns=({'dbt_17':'Observed_value'}))
        df_dbt3["Original_observed_value"]=df_dbt3["Observed_value"]
        df_dbt3["Observed_value"] = pd.to_numeric(df_dbt3["Observed_value"],errors='coerce')
        df_dbt3["Observed_value"]=df_dbt3["Observed_value"]#/10

        df_dbt3 = df_dbt3[["Source_ID",'Station_ID',"Station_name","Alias_station_name",  
                                 "Year","Month","Day","Hour","Minute",
                                "Latitude","Longitude","Elevation","Observed_value",
                                "Source_QC_flag","Original_observed_value",
                                "Original_observed_value_units",                                
                                "Report_type_code","Measurement_code_1",
                                "Measurement_code_2"]]
        

        
        merged_dyb=pd.concat([df_dbt,df_dbt2,df_dbt3], axis=0)
        merged_dyb=merged_dyb.dropna(subset = ['Observed_value'])
        
              #change time zones
        merged_dyb["Timestamp2"] = merged_dyb["Year"].map(str) + "-" + merged_dyb["Month"].map(str)+ "-" + merged_dyb["Day"].map(str)  
        merged_dyb["Timestamp"] = merged_dyb["Timestamp2"].map(str)+ " " + merged_dyb["Hour"].map(str)+":"+merged_dyb["Minute"].map(str)
        merged_dyb= merged_dyb.drop(columns=["Timestamp2"])
    
        merged_dyb['Timestamp'] =  pd.to_datetime(merged_dyb['Timestamp'], format='%Y-%m-%d' " ""%H:%M:%S")
        merged_dyb['Timestamp'] = merged_dyb['Timestamp'].dt.tz_localize('Etc/GMT-3').dt.tz_convert('GMT')
        merged_dyb['Year'] = merged_dyb['Timestamp'].dt.year 
        merged_dyb['Month'] = merged_dyb['Timestamp'].dt.month  
        merged_dyb['Day'] = merged_dyb['Timestamp'].dt.day 
        merged_dyb['Hour'] = merged_dyb['Timestamp'].dt.hour 
        merged_dyb['Minute'] = merged_dyb['Timestamp'].dt.minute
        merged_dyb['Seconds'] = merged_dyb['Timestamp'].dt.second
    
##delete unwanted columns 
        merged_dyb = merged_dyb.drop(columns="Timestamp")
        merged_dyb['Minute']='00'
    
        merged_dyb = merged_dyb[["Source_ID",'Station_ID',"Station_name","Alias_station_name",  
                                 "Year","Month","Day","Hour","Minute",
                                "Latitude","Longitude","Elevation","Observed_value",
                                "Source_QC_flag","Original_observed_value",
                                "Original_observed_value_units",                                
                                "Report_type_code","Measurement_code_1",
                                "Measurement_code_2"]]
        merged_dyb = merged_dyb.astype(str)

#save output file 
          
        year=merged_dyb.iloc[1]["Year"]
        month=merged_dyb.iloc[1]["Month"]
        date=(year+"_"+month)
        source_id=merged_dyb.iloc[1]["Source_ID"]
        cdm_type=(date+"_dry_bulb_temperature_"+source_id)
     
        a = merged_dyb['Station_ID'].unique()
        print (a)
        outname = os.path.join(OUTDIR,cdm_type)
    #with open(filename, "w") as outfile:
        merged_dyb.to_csv(outname+".psv", index=False, sep="|")
    except:
         continue
    
    
    