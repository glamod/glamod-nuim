
#!/usr/bin/env python3# -*- coding: utf-8 -*-
"""
Created on Wed Jul 17 14:22:41 2019

@author: snoone


"""


import os
import glob
import pandas as pd
import csv

##import all psv files in current dir
#os.chdir ("/work/scratch-nompiio/snoone/convert_IFF/nuschinaweather/output/maximum_temperature/324")
os.chdir ("C:/Users/snoone/Dropbox/PYTHON_TRAINING/NUS_China_weather/output/min_temp/324")
extension = 'psv'

all_filenames = [i for i in glob.glob('*.{}'.format(extension))]

for filename in all_filenames:

    #combine all files in the list
    df = pd.read_csv(filename ,delimiter='|')

    #combine unique value columns Station_ID,Lat, Long and Elev
    df['Station_ID2'] = df["Station_ID"].map(str)+ "_" + df["Latitude"].map(str) 
    df['Station_ID3'] = df['Station_ID2'].map(str)+ "_" + df["Longitude"].map(str)
    #df['Station_ID4'] = df['Station_ID3'].map(str)+ "_" +df["Elevation"].map(str)
    df['Station_ID4'] = df['Station_ID3'].map(str)+ "_" +df["Year"].map(str)
    #idenify and add record number (configuration) to ID column for all unique values in Station_ID4
    df.sort_values('Station_ID4', ascending=False)
    #df.sort_values(["Year", "Month", "Day"], ascending=[True, True, True])
   # df['ID'] = (df.Station_ID4 != df.Station_ID4.shift()).cumsum()
    df['ID'] = df.groupby(['Station_ID3']).ngroup()+1
    df["Station_ID"]= df["Station_ID"].map(str)+ "-" + df["ID"].map(str)
    #delete unwanted columns
    del df["ID"] 
    del df["Station_ID4"] 
    del df["Station_ID3"] 
    del df["Station_ID2"]


    
    
    df2=df1.sort_index()
    
    #write to csv
   # os.chdir ("/work/scratch-nompiio/snoone/convert_IFF/nuschinaweather/output/maximum_temperature/324/")
    #os.chdir ("C:/Users/snoone/Dropbox/PYTHON_TRAINING/NUS_China_weather/output/min_temp/324/3")
    df2.to_csv("combined.csv",index=False)
    
    

    #open combined csv and separate and rename files as per by staation_id 
    
    with open('combined.csv') as fin:    
        csvin = csv.DictReader(fin)
       #os.chdir ("/work/scratch-nompiio/snoone/convert_IFF/nuschinaweather/output/maximum_temperature/324/324a")
        #csvin.columns = [x.replace(' ', '_') for x in csvin.columns]  
        # Category -> open file lookup
        outputs = {}
        for row in csvin:
            cat = row['Station_ID']
            # Open a new file and write the header
            if cat not in outputs:
                fout = open ('{}_minimum_temperature_324.psv'.format(cat), "w", newline = "")
                dw = csv.DictWriter(fout, fieldnames=csvin.fieldnames,delimiter='|')
                dw.writeheader()
                outputs[cat] = fout, dw
            # Always write the row
            outputs[cat][1].writerow(row)
        # Close all the filesaa
        for fout, _ in outputs.values():
            fout.close()
     

    