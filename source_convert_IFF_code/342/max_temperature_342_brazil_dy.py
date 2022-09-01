#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Jul 17 14:22:41 2019

@author: snoone
"""
import os
import glob
import pandas as pd



OUTDIR = "D:/brazil_inmet/DataDaily_A_all_years_IFF/maximum_temperature"
os.chdir("D:/brazil_inmet/Daily_auto")
extension = '*'
all_filenames = [i for i in glob.glob('*{}'.format(extension))]
for filename in all_filenames:
    df = pd.read_json(filename)
    df["Source_ID"]="342"
    df["Alias_station_name"]=""
    df['Minute'] = "0"
    df["Source_QC_flag"]=""
    df["Original_observed_value_units"] = "C"
    df['Report_type_code'] = ""
    df['Measurement_code_1'] = ""
    df['Measurement_code_2'] = ""
    df['Station_ID'] = df['CD_ESTACAO']
    df['Station_name'] = df['DC_NOME']
    df[['Year',"Month", "Day"]] = df['DT_MEDICAO'].str.split('-',expand=True)
    df['Hour'] = "0"
    df['Latitude'] = df["VL_LATITUDE"].round(3)
    df["Longitude"] = df["VL_LONGITUDE"].round(3)
    df["Elevation"] = ""
    df["Original_observed_value"] = df["TEMP_MAX"]
    df["Observed_value"] = df["TEMP_MAX"]
    #df = df.astype({"Hour": int})
    df.dropna(subset = ["Observed_value"], inplace=True)
    #df["Timestamp2"] = df["Year"].map(str) + "-" + df["Month"].map(str)+ "-" + df["Day"].map(str)  
    #df["Timestamp"] = df["Timestamp2"].map(str)+ " " + df["Hour"].map(str)+":"+df["Minute"].map(str) 

    df2=df[["Source_ID",'Station_ID',"Station_name","Alias_station_name",  
                                 "Year","Month","Day","Hour","Minute",
                                "Latitude","Longitude","Elevation","Observed_value",
                                "Source_QC_flag","Original_observed_value",
                                "Original_observed_value_units",                                
                                "Report_type_code","Measurement_code_1",
                                "Measurement_code_2"]]

    
   
    outname = os.path.join(OUTDIR, filename)
    #with open(filename, "w") as outfile:
    df2.to_csv(outname+"_maximum_temperature_342.psv", index=False, sep="|")
   
