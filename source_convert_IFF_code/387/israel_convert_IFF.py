#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Jul 17 14:22:41 2019

@author: snoone
"""
import os
import glob
import pandas as pd

OUTDIR = "C:/Users/snoone/Dropbox/ISRAEL_HOURLY/IFF/slp"
os.chdir("C:/Users/snoone/Dropbox/ISRAEL_HOURLY/data/original_data/slp/data")
extension = 'csv'
all_filenames = [i for i in glob.glob('*{}'.format(extension))]
for filename in all_filenames:
    df = pd.read_csv(filename)
    df_master = df.copy()
    df["Source_ID"]="387"
    df["Alias_station_name"]=""
    df["Source_QC_flag"]=""
    df["Original_observed_value_units"] = "Hpa"
    df['Report_type_code'] = ""
    df['Measurement_code_1'] = ""
    df['Measurement_code_2'] = ""
    df = df.replace('null','', regex=True)
    df["Observed_value"] = df["Pressure at station level (hPa)"]
    df["Original_observed_value"] = df["Pressure at station level (hPa)"]
    try:
        df["Latitude"] = df["Latitude"]
        df["Longitude"] = df["Longitude"]
        df["Elevation"] = df["Elevation"]
    except:
        pass
    
    df["Station_name"] = df["Station"]
    df['Timestamp']=df["Date & Time (UTC)"]
    try: 
        df["Timestamp"] = pd.to_datetime(df["Timestamp"], format="%d/%m/%Y %H:%M")
    except ValueError:
    # If parsing with forward slashes fails, try again with hyphens
        df["Timestamp"] = pd.to_datetime(df["Timestamp"], format="%d-%m-%Y %H:%M")
    df['Year'] = df['Timestamp'].dt.year 
    df['Month'] = df['Timestamp'].dt.month 
    df['Day'] = df['Timestamp'].dt.day 
    df['Hour'] = df['Timestamp'].dt.hour 
    df['Minute'] = df['Timestamp'].dt.minute
    df['Seconds'] = df['Timestamp'].dt.second
    #df["Timestamp2"] = df["Year"].map(str) + "-" + df["Month"].map(str)+ "-" + df["Day"].map(str)  
    #df["Timestamp"] = df["Timestamp2"].map(str)+ " " + df["Hour"].map(str)+":"+df["Minute"].map(str) 

    df2=df[["Source_ID",'Station_ID',"Station_name","Alias_station_name",  
                                 "Year","Month","Day","Hour","Minute",
                                "Latitude","Longitude","Elevation","Observed_value",
                                "Source_QC_flag","Original_observed_value",
                                "Original_observed_value_units",                                
                                "Report_type_code","Measurement_code_1",
                                "Measurement_code_2"]]
    try:
        df2.dropna(subset = ["Observed_value"], inplace=True)
        ID=df2.iloc[0]["Station_ID"]
        outname = os.path.join(OUTDIR, ID)
        a = df2['Station_ID'].unique()
        print (a)
        #with open(filename, "w") as outfile:
        df2.to_csv(outname+"_station_level_pressure_387.psv", index=False, sep="|")
    except:
        continue
    
       
   
