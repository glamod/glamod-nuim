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




os.chdir("C:/Users/snoone/Dropbox/Ed_Hawkins_data/weather-rescue-data/UK-DWRs/IFF/fix_iff/nairn_fix/wbt")
extension = 'psv'

all_filenames = [i for i in glob.glob('*.{}'.format(extension))]

for filename in all_filenames:
    df=pd.read_csv(filename, sep="|").astype(str)
    df_merged1 = df[df["Station_name"].isin(["Nairn"])]
    df_merged1["Station_ID"]="381-00059"
    df_merged1["Latitude"]="57.577607"
    df_merged1["Longitude"]="-3.895321"
    df_merged1["Elevation"]="25"
    df_merged1["Latitude"] = pd.to_numeric(df_merged1["Latitude"],errors='coerce')
    df_merged1["Longitude"] = pd.to_numeric(df_merged1["Longitude"],errors='coerce')
    df_merged1["Latitude"]= df_merged1["Latitude"].round(3)
    df_merged1["Longitude"]= df_merged1["Longitude"].round(3)
    df_merged1["Observed_value"] = pd.to_numeric(df_merged1["Observed_value"],errors='coerce')
    df_merged1["Observed_value"]= df_merged1["Observed_value"].round(1)
    
    
    
      
    os.chdir = ("C:/Users/snoone/Dropbox/Ed_Hawkins_data/weather-rescue-data/UK-DWRs/IFF/fix_iff/nairn_fix/wbt/out")      
    cats = sorted(df_merged1['Station_ID'].unique())
    for cat in cats:
        outfilename = cat +"_wet_bulb_temperature_381.psv"
        print(outfilename)
        df_merged1[df_merged1["Station_ID"] == cat].to_csv(outfilename,sep='|',index=False)
        
        
        
        
    