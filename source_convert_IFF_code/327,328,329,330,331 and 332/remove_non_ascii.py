# -*- coding: utf-8 -*-
"""
Created on Fri Sep  4 14:00:30 2020

@author: snoone
"""

import os
import glob
import pandas as pd
import csv

#OUTDIR = "/gws/nopw/j04/c3s311a_lot2/data/level1/land/level1a_sub_daily_data/dew_point_temperature/245_fix"
#os.chdir("/gws/nopw/j04/c3s311a_lot2/data/level1/land/level1a_sub_daily_data/dew_point_temperature/245")

def remove_non_ascii(text): 
        return ''.join(i for i in text if ord(i)<128)
    
OUTDIR = "D:/UERRA_multiple source_sub_daily/UERRA_sub_daily/MeteoCat_UERRA_WP1_provideddata_13042017/MeteoCat_data_13042017.dir/bad/out"
os.chdir("D:/UERRA_multiple source_sub_daily/UERRA_sub_daily/MeteoCat_UERRA_WP1_provideddata_13042017/MeteoCat_data_13042017.dir/bad")

extension = 'csv'
all_filenames = [i for i in glob.glob('*.{}'.format(extension))]
for filename in all_filenames:
    df = pd.read_csv(filename, sep=',')

    df['stationname'] = df['stationname'].apply(remove_non_ascii) 
        
    outname = os.path.join(OUTDIR, filename)
    #with open(filename, "w") as outfile:
    df.to_csv(outname, index=False, sep=",")
    