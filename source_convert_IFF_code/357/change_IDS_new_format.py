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



os.chdir("D:/Palatina/sef_data/monthly/rr/IFF")
extension = 'psv'
all_filenames = [i for i in glob.glob('*.{}'.format(extension))]
for filename in all_filenames:
    df = pd.read_csv(filename, sep='|')
    #os.chdir(r"D:/C3S_south_africa_data_rescue_Uni_Witwatesrand/output/326/sub_daily_IFF/station_level_pressure/326/test")
    stn_list = pd.read_csv("D:/Palatina/sef_data/hourly/pal_stations.csv").astype(str)
    df["Alias_station_name"] = df["Station_ID"]
    df=df.merge(stn_list, on='Station_ID', how='left')
    df=df.drop("Station_ID",axis=1)
    
    df["Station_ID"] = df["Station_ID_new"]
    df['Hour'] = df['Hour'].fillna(0).astype(int)
    df['Minute'] = df['Minute'].fillna(0).astype(int)
    df["Latitude"] = pd.to_numeric(df["Latitude"],errors='coerce')
    df["Longitude"] = pd.to_numeric(df["Longitude"],errors='coerce')
    df["Latitude"]= df["Latitude"].round(3)
    df["Longitude"]= df["Longitude"].round(3)
    df["Elevation"]= df["Elevation"].round(3)
    df=df[["Source_ID",'Station_ID',"Station_name","Alias_station_name",  
                                 "Year","Month","Day","Hour","Minute",
                                "Latitude","Longitude","Elevation","Observed_value",
                                "Source_QC_flag","Original_observed_value",
                                "Original_observed_value_units","Report_type_code",
                                "Measurement_code_1",
                                "Measurement_code_2"]]
    
    #os.chdir("D:/fix_id_iff/mslp/253")    
    cats = sorted(df['Station_ID'].unique())
    for cat in cats:
        outfilename = cat + "_precipitation_357.psv"
        print(outfilename)
        df[df["Station_ID"] == cat].to_csv(outfilename,sep='|',index=False)
         
##################################################