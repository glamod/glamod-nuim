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


OUTDIR = "D:/Chile_met/Hourly_data/rh/333/rh"
os.chdir("D:/Chile_met/Hourly_data/rh/333/rh")
extension = 'psv'
all_filenames = [i for i in glob.glob('*.{}'.format(extension))]
for filename in all_filenames:
    df = pd.read_csv(filename, sep='|')
    #df['Elevation'] = df['Elevation'].astype(str)  
    #df.Elevation = df.Elevation.apply(int)
    df = df["Observed_value"].astype(int)
    #df["Latitude"]= round(df["Latitude"],3)
    #df["Longitude"]= round(df["Longitude"],3)
    #df.Original_observed_value = df.Original_observed_value.apply(int)
    #df[["Original_observed_value","Observed_value"]] = df[["Original_observed_value","Observed_value"]].apply(pd.to_numeric, errors='coerce')
    #df['Observed_value'] = pd.to_numeric(df['Observed_value'], errors = 'coerce')
    #df['Observed_value'] = df['Observed_value'].fillna(0).astype(int)



    outname = os.path.join(OUTDIR, filename )
    #with open(filename, "w") as outfile:
    df.to_csv(outname, index=False, sep="|")
    