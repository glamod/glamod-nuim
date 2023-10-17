
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

OUTDIR = "D:/ACRE Argentina_josvaldor/ACRE_AR/sef_data/IFF/wd/out"
os.chdir("D:/ACRE Argentina_josvaldor/ACRE_AR/sef_data/IFF/wd/out")
extension = 'psv'

all_filenames = [i for i in glob.glob('*.{}'.format(extension))]
for filename in all_filenames:
    df=pd.read_csv(filename, sep="|")
    df['Hour'] = df['Hour'].astype(str).apply(lambda x: x.replace('.0',''))
    df['Minute'] = df['Minute'].astype(str).apply(lambda x: x.replace('.0',''))
    #df["Hour"] = pd.to_numeric(df["Hour"],errors='coerce')
    #df["Minute"] = pd.to_numeric(df["Minute"],errors='coerce')

    df["Latitude"] = pd.to_numeric(df["Latitude"],errors='coerce')
    df["Longitude"] = pd.to_numeric(df["Longitude"],errors='coerce')
    df["Latitude"]= df["Latitude"].round(2)
    df["Longitude"]= df["Longitude"].round(2)
    outname = os.path.join(OUTDIR, filename)
    #with open(filename, "w") as outfile:
    df.to_csv(outname, index=False, sep="|")

    
    





