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

OUTDIR = "C:/Users/snoone/Dropbox/OLD_BELGIAN_AFRICAN_DARE_INVENTORY/Kevin_folder_african_inv/checked_forms_clidar_2022/Andapa_Form_3/Andapa_Form_3/ws/IFF"
os.chdir("C:/Users/snoone/Dropbox/OLD_BELGIAN_AFRICAN_DARE_INVENTORY/Kevin_folder_african_inv/checked_forms_clidar_2022/Andapa_Form_3/Andapa_Form_3/ws")
extension = 'psv'
all_filenames = [i for i in glob.glob('*.{}'.format(extension))]
#combine all files in the list
df = pd.concat([pd.read_csv(f,delimiter='|') for f in all_filenames])
df = df.dropna(subset=["Observed_value"])

##change with variables##

#df["Observed_value"]=df["Observed_value"]*10
#df["Observed_value"] = pd.to_numeric(df["Observed_value"],errors='coerce')
#df["Observed_value"]= df["Observed_value"].round(1)
#["Original_observed_value"] = pd.to_numeric(df["Original_observed_value"],errors='coerce')
#df["Original_observed_value"]= df["Original_observed_value"].round(1)
#df['Observed_value'] = df['Observed_value'].astype(str).apply(lambda x: x.replace('.0',''))
#df['Original_observed_value'] = df['Original_observed_value'].astype(str).apply(lambda x: x.replace('.0',''))

os.chdir("C:/Users/snoone/Dropbox/OLD_BELGIAN_AFRICAN_DARE_INVENTORY/Kevin_folder_african_inv/checked_forms_clidar_2022/Andapa_Form_3/Andapa_Form_3/ws")    
cats = sorted(df['Station_ID'].unique())
for cat in cats:
    outfilename = cat +"_wind_speed__383.psv"
    print(outfilename)
    df[df["Station_ID"] == cat].to_csv(outfilename,sep='|',index=False)
    os.chdir("C:/Users/snoone/Dropbox/OLD_BELGIAN_AFRICAN_DARE_INVENTORY/Kevin_folder_african_inv/checked_forms_clidar_2022/Andapa_Form_3/Andapa_Form_3/ws")
         
##################################################

