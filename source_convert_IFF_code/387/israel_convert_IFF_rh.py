#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Jul 17 14:22:41 2019

@author: snoone
"""
import os
import glob
import pandas as pd
OUTDIR1 = "C:/Users/snoone/Dropbox/ISRAEL_HOURLY/IFF/v"
OUTDIR6 = "C:/Users/snoone/Dropbox/ISRAEL_HOURLY/IFF/ws"
OUTDIR5 = "C:/Users/snoone/Dropbox/ISRAEL_HOURLY/IFF/wd"
OUTDIR4 = "C:/Users/snoone/Dropbox/ISRAEL_HOURLY/IFF/rh"
OUTDIR3 = "C:/Users/snoone/Dropbox/ISRAEL_HOURLY/IFF/dpt"
OUTDIR2 = "C:/Users/snoone/Dropbox/ISRAEL_HOURLY/IFF/wetT"
OUTDIR1 = "C:/Users/snoone/Dropbox/ISRAEL_HOURLY/IFF/temp"
OUTDIR = "C:/Users/snoone/Dropbox/ISRAEL_HOURLY/IFF/mslp"
os.chdir("C:/Users/snoone/Dropbox/ISRAEL_HOURLY/data/")
extension = '.csv'
all_filenames = [i for i in glob.glob('*{}'.format(extension))]
for filename in all_filenames:
    df = pd.read_csv(filename)
    #df_master = df.copy()
    df["Source_ID"]="387"
    df["Alias_station_name"]=""
    df["Source_QC_flag"]=""
    df["Original_observed_value_units"] = "%"
    df['Report_type_code'] = ""
    df['Measurement_code_1'] = ""
    df['Measurement_code_2'] = ""
    df = df.replace('null','', regex=True)
    df["Observed_value"] = df["Relative humidity (%)"]
    df["Original_observed_value"] = df["Relative humidity (%)"]
    try:
        df["Latitude"] = df["latitude"]
        df["Longitude"] = df["longitude"]
        df["Elevation"] = df["elevation"]
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
    df2.dropna(subset = ["Observed_value"], inplace=True)
    df2['Observed_value'] = df2['Observed_value'].round(0).astype(int)
    df2['Original_observed_value'] = df2['Original_observed_value'].round(0).astype(int)
    try:
        
        ID=df2.iloc[0]["Station_ID"]
        outname = os.path.join(OUTDIR4, ID)
        a = df2['Station_ID'].unique()
        print (a)
        #with open(filename, "w") as outfile:
        df2.to_csv(outname+"_relative_humidity_387.psv", index=False, sep="|")
    except:
        continue