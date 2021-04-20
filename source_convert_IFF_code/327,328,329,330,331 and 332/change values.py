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


OUTDIR = "D:/UERRA_multiple source_sub_daily/UERRA_sub_daily/UERRA_C3_D1.6_digitiseddata_2017-05-30/UERRA_C3_D1.6_digitiseddata_2017-05-30/out/rh/171/IFF"
os.chdir("D:/UERRA_multiple source_sub_daily/UERRA_sub_daily/UERRA_C3_D1.6_digitiseddata_2017-05-30/UERRA_C3_D1.6_digitiseddata_2017-05-30/out/rh/171/IFF")
extension = 'psv'
all_filenames = [i for i in glob.glob('*.{}'.format(extension))]
for filename in all_filenames:
    df = pd.read_csv(filename, sep='|')

  ##elementid
    #df=df.replace({"-999.9":"Null"})
    #df = df.replace(['-99.9'],'Null') 
    df=df.replace(to_replace = -99.9, 
                 value ="Null")
    #df= df.Observed_value = df.Observed_value.astype(int)
    df=df['Observed_value']= (df['Observed_value']).astype(str).str.replace('.', '')
        
    outname = os.path.join(OUTDIR, filename)
    #with open(filename, "w") as outfile:
    df.to_csv(outname, index=False, sep="|")
    