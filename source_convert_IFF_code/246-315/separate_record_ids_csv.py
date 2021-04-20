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
os.chdir(os.curdir)
extension = 'psv'
all_filenames = [i for i in glob.glob('*.{}'.format(extension))]
#combine all files in the list
df = pd.concat([pd.read_csv(f,delimiter='|') for f in all_filenames])
#combine unique value columns Station_ID,Lat, Long and Elev
df['Station_ID2'] = df["Station_ID"].map(str)+ "_" + df["Latitude"].map(str) 
df['Station_ID3'] = df['Station_ID2'].map(str)+ "_" + df["Longitude"].map(str)
df['Station_ID4'] = df['Station_ID3'].map(str)+ "_" +df["Elevation"].map(str) 
#idenify and add record number (configuration) to ID column for all unique values in Station_ID4
df['ID'] = (df.Station_ID4 != df.Station_ID4.shift()).cumsum()
df["Station_ID"]= df["Station_ID"].map(str)+ "-" + df["ID"].map(str)
#delete unwanted columns
del df["ID"] 
del df["Station_ID4"] 
del df["Station_ID3"] 
del df["Station_ID2"] 
#write to csv
df.to_csv("combined.csv",index=False)




#open combined csv and separate and rename files as per by station_id 
with open('combined.csv') as fin:    
    csvin = csv.DictReader(fin)
    #csvin.columns = [x.replace(' ', '_') for x in csvin.columns]  
    # Category -> open file lookup
    outputs = {}
    for row in csvin:
        cat = row['Station_ID']
        # Open a new file and write the header
        if cat not in outputs:
            fout = open ('{}_sea_level_pressure_247.psv'.format(cat), "w", newline = "")
            dw = csv.DictWriter(fout, fieldnames=csvin.fieldnames,delimiter='|')
            dw.writeheader()
            outputs[cat] = fout, dw
        # Always write the row
        outputs[cat][1].writerow(row)
    # Close all the files
    for fout, _ in outputs.values():
        fout.close()
