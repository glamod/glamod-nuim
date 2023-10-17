# -*- coding: utf-8 -*-
"""
Created on Thu Jan 26 12:17:19 2023

@author: snoone
"""

import os   
import glob
import pandas as pd
import csv

OUTDIR = "C:/Users/snoone/Dropbox/OLD_BELGIAN_AFRICAN_DARE_INVENTORY/students_GY201_examples_sheets/code_extract/andapa/form1/out"
os.chdir("C:/Users/snoone/Dropbox/OLD_BELGIAN_AFRICAN_DARE_INVENTORY/students_GY201_examples_sheets/code_extract/andapa/form1")
extension = 'xlsx'
all_filenames = [i for i in glob.glob('*.{}'.format(extension))]


for filename in all_filenames:
    df = pd.read_excel(filename,skiprows=6, header=None)
    df.columns = ["Day", "precip_17", "precip7", "total_precip","evap_18","evap_7","evap_total","8","9","10","11","12","13"]
    df=df.drop(columns =["8","9","10","11","12","13"])
   
    df1=pd.read_excel(filename,nrows=0)
    df1 = df1.T.reset_index().T.reset_index(drop=True)
    df1.columns =  ["1", "Station_name", "2", "3","4","Month","5","Year","9","10","11","12","13"]
    df1=df1.drop(columns =["1",  "2", "3","4","5","9","10","11","12","13"])
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
    df['Original_observed_value_units']="mm"
    df['Report_type_code']=''
    df['Measurement_code_1']=''
    df['Measurement_code_2']='' 
    df2 = pd.read_csv("header.csv",squeeze=True)
    df2 = df2.astype(str)
    df= df2.merge(df, on=['Station_name'])
    df["Minute"]="00"  
    df = df.replace('nt','0', regex=True)
    df = df.replace('NT','0', regex=True)
    n = 3
 # Dropping last n rows using dro
    df.drop(df.tail(n).index,
        inplace = True)
    
##extract precipip taken at 1700
    
    df_precip17=df
    df_precip17=df_precip17.drop(columns =["precip7","total_precip", "evap_18","evap_7","evap_total"])
    df_precip17["Hour"]="17" 
    df_precip17= df_precip17.rename(columns=({'precip_17':'Observed_value'}))
    df_precip17["Original_observed_value"]=df_precip17["Observed_value"]
    df_precip17["Observed_value"] = pd.to_numeric(df_precip17["Observed_value"],errors='coerce')
    df_precip17["Observed_value"]=df_precip17["Observed_value"]/10

    df_precip17 = df_precip17[["Source_ID",'Station_ID',"Station_name","Alias_station_name",  
                                 "Year","Month","Day","Hour","Minute",
                                "Latitude","Longitude","Elevation","Observed_value",
                                "Source_QC_flag","Original_observed_value",
                                "Original_observed_value_units",                                
                                "Report_type_code","Measurement_code_1",
                                "Measurement_code_2"]]
    ##extract precipip taken at 1700
    
    df_precip7=df
    df_precip7=df_precip7.drop(columns =["precip_17","total_precip", "evap_18","evap_7","evap_total"])
    df_precip7["Hour"]="7" 
    df_precip7= df_precip7.rename(columns=({'precip7':'Observed_value'}))
    df_precip7["Original_observed_value"]=df_precip7["Observed_value"]
    df_precip7["Observed_value"] = pd.to_numeric(df_precip7["Observed_value"],errors='coerce')
    df_precip7["Observed_value"]=df_precip7["Observed_value"]/10

    df_precip7 = df_precip7[["Source_ID",'Station_ID',"Station_name","Alias_station_name",  
                                 "Year","Month","Day","Hour","Minute",
                                "Latitude","Longitude","Elevation","Observed_value",
                                "Source_QC_flag","Original_observed_value",
                                "Original_observed_value_units",                                
                                "Report_type_code","Measurement_code_1",
                                "Measurement_code_2"]]
    merged_precip=pd.concat([df_precip17,df_precip7], axis=0)
    
    #change time zones
    merged_precip["Timestamp2"] = merged_precip["Year"].map(str) + "-" + merged_precip["Month"].map(str)+ "-" + merged_precip["Day"].map(str)  
    merged_precip["Timestamp"] = merged_precip["Timestamp2"].map(str)+ " " + merged_precip["Hour"].map(str)+":"+merged_precip["Minute"].map(str)
    merged_precip= merged_precip.drop(columns=["Timestamp2"])
    
    merged_precip['Timestamp'] =  pd.to_datetime(merged_precip['Timestamp'], format='%Y-%m-%d' " ""%H:%M:%S")
    merged_precip['Timestamp'] = merged_precip['Timestamp'].dt.tz_localize('Etc/GMT-3').dt.tz_convert('GMT')
    merged_precip['Year'] = merged_precip['Timestamp'].dt.year 
    merged_precip['Month'] = merged_precip['Timestamp'].dt.month  
    merged_precip['Day'] = merged_precip['Timestamp'].dt.day 
    merged_precip['Hour'] = merged_precip['Timestamp'].dt.hour 
    merged_precip['Minute'] = merged_precip['Timestamp'].dt.minute
    merged_precip['Seconds'] = merged_precip['Timestamp'].dt.second
    
##delete unwanted columns 
    merged_precip = merged_precip.drop(columns="Timestamp")
    merged_precip['Minute']='00'
    
    merged_precip = merged_precip[["Source_ID",'Station_ID',"Station_name","Alias_station_name",  
                                 "Year","Month","Day","Hour","Minute",
                                "Latitude","Longitude","Elevation","Observed_value",
                                "Source_QC_flag","Original_observed_value",
                                "Original_observed_value_units",                                
                                "Report_type_code","Measurement_code_1",
                                "Measurement_code_2"]]
    

#save output file   
    station_id=merged_precip.iloc[1]["Station_ID"]
    source_id=merged_precip.iloc[1]["Source_ID"]
    cdm_type=(station_id+"_precipitation_"+source_id)
     
    a = merged_precip['Station_ID'].unique()
    print (a)
    outname = os.path.join(OUTDIR,cdm_type)
    #with open(filename, "w") as outfile:
    merged_precip.to_csv(outname+".psv", index=False, sep="|")
    
    
    
    