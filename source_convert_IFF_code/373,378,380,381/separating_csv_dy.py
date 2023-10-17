# -*- coding: utf-8 -*-
"""
Created on Fri Sep 30 08:40:38 2022

@author: snoone
"""

import os
import glob
import pandas as pd
import numpy as np
pd.options.mode.chained_assignment = None  # default='warn'




os.chdir("C:/Users/snoone/Dropbox/Ed_Hawkins_data/weather-rescue-data/UK-DWRs/IFF/fix_iff/hourly_fix/lon")
extension = 'psv'

all_filenames = [i for i in glob.glob('*.{}'.format(extension))]

for filename in all_filenames:
    df=pd.read_csv(filename, sep="|").astype(str)
    df_merged1 = df[df["Station_name"].isin(["London (Westminster)"])]
    df_merged2 = df[df["Station_name"].isin(["London (Brixton)"])]
    df_merged3 = df[df["Station_name"].isin(["London (St. James' Park)"])]
    df_merged1["Station_ID"]="381-00050"
    df_merged1["Latitude"]="51.45976551"
    df_merged1["Longitude"]="-0.127518"
    df_merged1["Elevation"]="Null"
    df_merged1["Latitude"] = pd.to_numeric(df_merged1["Latitude"],errors='coerce')
    df_merged1["Longitude"] = pd.to_numeric(df_merged1["Longitude"],errors='coerce')
    df_merged1["Latitude"]= df_merged1["Latitude"].round(3)
    df_merged1["Longitude"]= df_merged1["Longitude"].round(3)
    df_merged1["Observed_value"] = pd.to_numeric(df_merged1["Observed_value"],errors='coerce')
    df_merged1["Observed_value"]= df_merged1["Observed_value"].round(1)
    
    df_merged2["Station_ID"]="381-00105"
    df_merged2["Latitude"]="51.497665"
    df_merged2["Longitude"]="-0.134093"
    df_merged2["Elevation"]="Null"
    df_merged2["Latitude"] = pd.to_numeric(df_merged2["Latitude"],errors='coerce')
    df_merged2["Longitude"] = pd.to_numeric(df_merged2["Longitude"],errors='coerce')
    df_merged2["Latitude"]= df_merged2["Latitude"].round(3)
    df_merged2["Longitude"]= df_merged2["Longitude"].round(3)  
    df_merged2["Observed_value"] = pd.to_numeric(df_merged2["Observed_value"],errors='coerce')
    df_merged2["Observed_value"]= df_merged2["Observed_value"].round(1)
    
    df_merged3["Station_ID"]="381-00106"
    df_merged3["Latitude"] = pd.to_numeric(df_merged3["Latitude"],errors='coerce')
    df_merged3["Longitude"] = pd.to_numeric(df_merged3["Longitude"],errors='coerce')
    df_merged3["Latitude"]= df_merged3["Latitude"].round(3)
    df_merged3["Longitude"]= df_merged3["Longitude"].round(3)
    df_merged3["Observed_value"] = pd.to_numeric(df_merged3["Observed_value"],errors='coerce')
    df_merged3["Observed_value"]= df_merged3["Observed_value"].round(1)
    
    frames = [df_merged1, df_merged2, df_merged3]
    result = pd.concat(frames)
    
    os.chdir = ("C:/Users/snoone/Dropbox/Ed_Hawkins_data/weather-rescue-data/UK-DWRs/IFF/fix_iff/hourly_fix/lon/out")      
    cats = sorted(result['Station_ID'].unique())
    for cat in cats:
        outfilename = cat +"_sea_level_pressure_381.psv"
        print(outfilename)
        result[result["Station_ID"] == cat].to_csv(outfilename,sep='|',index=False)
        
        
        
        
    