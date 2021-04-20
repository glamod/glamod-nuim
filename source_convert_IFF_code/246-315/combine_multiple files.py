# -*- coding: utf-8 -*-
"""
Created on Wed Jul 17 14:22:41 2019

@author: snoone
"""
import os
import glob
import pandas as pd
import csv

##import all csv files in current dir
os.chdir(os.curdir)
extension = 'dat'
all_filenames = [i for i in glob.glob('*.{}'.format(extension))]
#combine all files in the list
df = pd.concat([pd.read_csv(f,delimiter='|') for f in all_filenames])
#dewpointtemp df['Observed_value']= round(df['Observed_value'],1)
df.to_csv("receipts_comb.csv",index=False)

