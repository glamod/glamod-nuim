#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Jul 17 14:22:41 2019

@author: snoone
"""
import os
import glob
import pandas as pd
import csv

import numpy as np

os.chdir("C:/Users/snoone/Dropbox/Ed_Hawkins_data/weather-rescue-data/UK-DWRs/IFF/fix_iff/london_fix/wbt")
OUTDIR = ("C:/Users/snoone/Dropbox/Ed_Hawkins_data/weather-rescue-data/UK-DWRs/IFF/fix_iff/london_fix/wbt/out")
extension = 'psv'
all_filenames = [i for i in glob.glob('*.{}'.format(extension))]
for filename in all_filenames:
    df = pd.read_csv(filename, sep='|').astype(str)
    
    stn_list = pd.read_csv("C:/Users/snoone/Dropbox/Ed_Hawkins_data/weather-rescue-data/UK-DWRs/Stations2.csv").astype(str)
    df=df.merge(stn_list, on='Station_ID', how='left')
    df=df.drop("Station_ID",axis=1)
    #df=df.drop("Station_name",axis=1)
    df["Station_ID"] = df["Station_ID_new"]
    #df["Station_name"] = df["Station_name_new"]
    df['Hour'] = df['Hour'].fillna(0).astype(int)
    df['Minute'] = df['Minute'].fillna(0).astype(int)
    df["Latitude"] = pd.to_numeric(df["Latitude"],errors='coerce')
    df["Longitude"] = pd.to_numeric(df["Longitude"],errors='coerce')
    df["Latitude"]= df["Latitude"].round(3)
    df["Longitude"]= df["Longitude"].round(3)
    df["Elevation"] = pd.to_numeric(df["Elevation"],errors='coerce')
    df["Elevation"]= df["Elevation"].round(3)
    df["Observed_value"] = pd.to_numeric(df["Observed_value"],errors='coerce')
    df["Observed_value"]= df["Observed_value"].round(1)
    df['Report_type_code']=''
    df['Measurement_code_1']=''
    df['Measurement_code_2']=''
    df["Alias_station_name"]=""
    df["Source_QC_flag"]=""
    df["Original_observed_value"]=""
    df=df[["Source_ID",'Station_ID',"Station_name","Alias_station_name",  
                                 "Year","Month","Day","Hour","Minute",
                                "Latitude","Longitude","Elevation","Observed_value",
                                "Source_QC_flag","Original_observed_value",
                                "Original_observed_value_units","Report_type_code",
                                "Measurement_code_1",
                                "Measurement_code_2"]]
    
    
    os.chdir("C:/Users/snoone/Dropbox/Ed_Hawkins_data/weather-rescue-data/UK-DWRs/IFF/fix_iff/london_fix/wbt/out")    
    cats = sorted(df['Station_ID'].unique())
    for cat in cats:
        outfilename = cat +"_wet_bulb_temperature_381.psv"
        print(outfilename)
        df[df["Station_ID"] == cat].to_csv(outfilename,sep='|',index=False)
    os.chdir("C:/Users/snoone/Dropbox/Ed_Hawkins_data/weather-rescue-data/UK-DWRs/IFF/fix_iff/london_fix/wbt")
         
##################################################