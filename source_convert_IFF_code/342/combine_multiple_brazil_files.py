# -*- coding: utf-8 -*-
"""
Created on Wed Jul 17 14:22:41 2019

@author: snoone
"""
import os
import glob
import pandas as pd
import csv

##import all psv files in current dir
os.chdir("D:/brazil_inmet/DataDaily_A_all_years_IFF/precipitation")
extension = 'psv'
all_filenames = [i for i in glob.glob('*.{}'.format(extension))]
#combine all files in the list
df = pd.concat([pd.read_csv(f,delimiter='|') for f in all_filenames])

df["Latitude"] = pd.to_numeric(df["Latitude"],errors='coerce')
df["Longitude"] = pd.to_numeric(df["Longitude"],errors='coerce')
df['Latitude'] = df["Latitude"].round(3)
df["Longitude"] = df["Longitude"].round(3)
df["Elevation"] = df["Elevation"].round(1)
df = df.astype({"Observed_value": int})
df = df.astype({"Original_observed_value": int})
#df['Hour'] = df['Hour'].astype(str)
#df['Hour1'] = df['Hour'].str[2:2]
#del df["Hour"]
#df['Hour'] = df['Hour1']
df=df.sort_values ("Year")

df.to_csv("combined.csv",index=False)

os.chdir("D:/brazil_inmet/DataA_all_years_IFF/global_radiation/5")
with open('combined.csv') as fin:    
    csvin = csv.DictReader(fin)
    os.chdir("D:/brazil_inmet/DataA_all_years_IFF/global_radiation")
    #csvin.columns = [x.replace(' ', '_') for x in csvin.columns]  
    # Category -> open file lookup
    outputs = {}
    for row in csvin:
        cat = row['Station_ID']
        # Open a new file and write the header
        if cat not in outputs:
            fout = open ('{}_global_radiation_342.psv'.format(cat), "w", newline = "")
            dw = csv.DictWriter(fout, fieldnames=csvin.fieldnames,delimiter='|')
            dw.writeheader()
            outputs[cat] = fout, dw
        # Always write the row
        outputs[cat][1].writerow(row)
    # Close all the files
    for fout, _ in outputs.values():
        fout.close()
      
