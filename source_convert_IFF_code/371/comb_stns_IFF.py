# -*- coding: utf-8 -*-
"""
Created on Wed Jul 17 14:22:41 2019

@author: snoone
"""
import os
import glob
import pandas as pd
import csv


##import all csv files in current dir that need timezone changing to GMT based on hours offset 
os.chdir("C:/Users/snoone/Dropbox/Hungarian_hourly/hourly/historical/ws/")
extension = 'psv'
all_filenames = [i for i in glob.glob('*.{}'.format(extension))]
#combine all files in the list
df1 = pd.concat([pd.read_csv(f,delimiter='|') for f in all_filenames])


df1['Station_ID'] = df1['Station_ID'].astype(str) 
os.chdir(r"C:/Users/snoone/Dropbox/Hungarian_hourly/hourly/historical/ws/IFF")
cats = sorted(df1['Station_ID'].unique())
for cat in cats:
    outfilename = cat + "_wind_speed_370.psv"
    print(outfilename)
    df1[df1["Station_ID"] == cat].to_csv(outfilename,sep='|',index=False)