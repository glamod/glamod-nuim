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
os.chdir("/gws/nopw/j04/c3s311a_lot2/data/level1/land/level1a_sub_daily_data/sea_level_pressure/341_a")
extension = 'psv'
all_filenames = [i for i in glob.glob('*.{}'.format(extension))]
#combine all files in the list
df1 = pd.concat([pd.read_csv(f,delimiter='|') for f in all_filenames])

os.chdir("/gws/nopw/j04/c3s311a_lot2/data/level1/land/level1a_sub_daily_data/sea_level_pressure/341_b")
extension = 'psv'
all_filenames = [i for i in glob.glob('*.{}'.format(extension))]

df2 = pd.concat([pd.read_csv(f,delimiter='|') for f in all_filenames])

os.chdir("/gws/nopw/j04/c3s311a_lot2/data/level1/land/level1a_sub_daily_data/sea_level_pressure/341_c")
extension = 'psv'
all_filenames = [i for i in glob.glob('*.{}'.format(extension))]

#combine all files in the list
df3 = pd.concat([pd.read_csv(f,delimiter='|') for f in all_filenames])

os.chdir("/gws/nopw/j04/c3s311a_lot2/data/level1/land/level1a_sub_daily_data/sea_level_pressure/341_d")
extension = 'psv'
all_filenames = [i for i in glob.glob('*.{}'.format(extension))]

#combine all files in the list
df4 = pd.concat([pd.read_csv(f,delimiter='|') for f in all_filenames])

os.chdir("/gws/nopw/j04/c3s311a_lot2/data/level1/land/level1a_sub_daily_data/sea_level_pressure/341_e")
extension = 'psv'
all_filenames = [i for i in glob.glob('*.{}'.format(extension))]

#combine all files in the list
df5 = pd.concat([pd.read_csv(f,delimiter='|') for f in all_filenames])

os.chdir("/gws/nopw/j04/c3s311a_lot2/data/level1/land/level1a_sub_daily_data/sea_level_pressure/341_f")
extension = 'psv'
all_filenames = [i for i in glob.glob('*.{}'.format(extension))]

#combine all files in the list
df6 = pd.concat([pd.read_csv(f,delimiter='|') for f in all_filenames])

df_final=pd.concat([df1,df2,df3,df4,df5,df6], axis=0)
del df1,df2,df3,df4,df5,df6

df_final['Station_ID'] = df_final['Station_ID'].astype(str) 
os.chdir(r"/gws/nopw/j04/c3s311a_lot2/data/level1/land/level1a_sub_daily_data/sea_level_pressure/341")
cats = sorted(df_final['Station_ID'].unique())
for cat in cats:
    outfilename = cat + "_sea_level_pressure_341.psv"
    print(outfilename)
    df_final[df_final["Station_ID"] == cat].to_csv(outfilename,sep='|',index=False)