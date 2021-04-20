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


OUTDIR = "D:/UERRA_multiple source_sub_daily/UERRA_sub_daily/UERRA_C3_D1.6_digitiseddata_2017-05-30/UERRA_C3_D1.6_digitiseddata_2017-05-30/out/dp"
os.chdir("D:/UERRA_multiple source_sub_daily/UERRA_sub_daily/UERRA_C3_D1.6_digitiseddata_2017-05-30/UERRA_C3_D1.6_digitiseddata_2017-05-30/test")
extension = 'csv'
all_filenames = [i for i in glob.glob('*.{}'.format(extension))]
for filename in all_filenames:
    df = pd.read_csv(filename, sep=',')

  ##elementid
    df = df.loc[df["id"].isin(["dp"])]
        
    outname = os.path.join(OUTDIR, filename)
    #with open(filename, "w") as outfile:
    df.to_csv(outname, index=False, sep=",")
    