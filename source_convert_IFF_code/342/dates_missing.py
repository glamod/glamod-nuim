# -*- coding: utf-8 -*-
"""
Created on Mon Jul 19 14:10:42 2021

@author: snoone
"""


#import pandas
import os
import glob
import pandas as pd

OUTDIR = "D:/brazil_inmet/missing_test/out"
os.chdir("D:/brazil_inmet/missing_test")
  
extension = 'psv'
all_filenames = [i for i in glob.glob('*{}'.format(extension))]
for filename in all_filenames:
    df = pd.read_csv(filename,delimiter='|')
    df["Date"] = df[df.columns[4:7]].apply(
    lambda x: '-'.join(x.dropna().astype(str)),axis=1)
    df = df.set_index ("Date")
    df.index = pd.to_datetime(df.index)
    start= df.iloc[0:,0:]
    end= df.iloc[0:,-1:]
    df2=(pd.date_range(start=start, end=end).difference(df.index))
    
    outname = os.path.join(OUTDIR, filename)
    df2.to_csv(outname+"_missing.psv", index=False, sep="|")
   

my_range = pd.date_range(
  start="2021-01-10", end="2021-01-31", freq='B')
  
print(my_range.difference(df['Date']))