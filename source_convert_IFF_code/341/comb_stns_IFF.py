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
os.chdir("D:/EEC_canadian_hourly/1953_70/dpt/out")
extension = 'psv'
all_filenames = [i for i in glob.glob('*.{}'.format(extension))]
#combine all files in the list
df1 = pd.concat([pd.read_csv(f,delimiter='|') for f in all_filenames])

os.chdir("D:/EEC_canadian_hourly/1971_80/dpt/out")
extension = 'psv'
all_filenames = [i for i in glob.glob('*.{}'.format(extension))]

df2 = pd.concat([pd.read_csv(f,delimiter='|') for f in all_filenames])

os.chdir("D:/EEC_canadian_hourly/1981_90/dpt/out")
extension = 'psv'
all_filenames = [i for i in glob.glob('*.{}'.format(extension))]

#combine all files in the list
df3 = pd.concat([pd.read_csv(f,delimiter='|') for f in all_filenames])

os.chdir("D:/EEC_canadian_hourly/1991_00/dpt/out")
extension = 'psv'
all_filenames = [i for i in glob.glob('*.{}'.format(extension))]

#combine all files in the list
df4 = pd.concat([pd.read_csv(f,delimiter='|') for f in all_filenames])

os.chdir("D:/EEC_canadian_hourly/2000_10/dpt/out")
extension = 'psv'
all_filenames = [i for i in glob.glob('*.{}'.format(extension))]

#combine all files in the list
df5 = pd.concat([pd.read_csv(f,delimiter='|') for f in all_filenames])

df_final=pd.concat([df1,df2,df3,df4,df5], axis=0)
del df1,df2,df3,df4,df5

df_final['Station_ID'] = df_final['Station_ID'].astype(str) 
os.chdir(r"D:/EEC_canadian_hourly/dpt_test")
cats = sorted(df_final['Station_ID'].unique())
for cat in cats:
    outfilename = cat + "_dew_point_temperature_341.psv"
    print(outfilename)
    df_final[df_final["Station_ID"] == cat].to_csv(outfilename,sep='|',index=False)