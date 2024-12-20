# -*- coding: utf-8 -*-
"""
Created on Wed Jul 17 14:22:41 2019

@author: snoone
"""
import os
import glob
import pandas as pd
import csv
import datetime
import numpy as np

##import all csv files in current dir that need timezone changing to GMT based on hours offset 
os.chdir(os.curdir)
extension = 'psv'
all_filenames = [i for i in glob.glob('*.{}'.format(extension))]
#combine all files in the list
df = pd.concat([pd.read_csv(f,delimiter='|') for f in all_filenames])
#df['Observed_value']= round(df['Observed_value'],1)
df = df.drop([df.index[0]])
##convert timezones to UTC
#df['Timestamp'] = df['Timestamp'].dt.tz_convert('GMT')
#from datetime import datetime
#date_str3 = df["Timestamp"]
#df["Timestamp"] = datetime.strptime(date_str3, '%m/%d/%Y %H:%M')
df['Timestamp'] =  pd.to_datetime(df['Timestamp'], format='%Y/%m/%d' " ""%H:%M")
df['Timestamp'] = df['Timestamp'].dt.tz_localize('Etc/GMT-3').dt.tz_convert('GMT')

#split the (GMT)  timestampinto columns 
df['Year'] = df['Timestamp'].dt.year 
df['Month'] = df['Timestamp'].dt.month 
df['Day'] = df['Timestamp'].dt.day 
df['Hour'] = df['Timestamp'].dt.hour 
df['Minute'] = df['Timestamp'].dt.minute 
##delete unwanted columns 
df = df.drop(columns="Timestamp")

##round values

df['Year']= round(df['Year'])
df['Month']= round(df['Month'])
df['Day']= round(df["Day"])
df['Hour']= round(df['Hour'])
df['Minute']= round(df['Minute'])
df['Minute']= "30"

df = df[["Source_ID",'Station_ID',"Station_name","Alias_station_name",  
                                 "Year","Month","Day","Hour","Minute",
                                "Latitude","Longitude","Elevation","Observed_value",
                                "Source_QC_flag","Original_observed_value",
                                "Original_observed_value_units",                                
                                "Report_type_code","Measurement_code_1",
                                "Measurement_code_2"]]
df.to_csv("combined.csv",index=False)

##separate combined to separate files based on a column 
###CHANGE OUTPUT FILE NAME WITHE ACH NEW VARIABLE##

with open('combined.csv') as fin:    
    csvin = csv.DictReader(fin)
    #csvin.columns = [x.replace(' ', '_') for x in csvin.columns]  
    # Category -> open file lookup
    outputs = {}
    for row in csvin:
        cat = row['Station_ID']
        # Open a new file and write the header
        if cat not in outputs:
            fout = open ('{}_station_pressure_321.psv'.format(cat), "w", newline = "")
            dw = csv.DictWriter(fout, fieldnames=csvin.fieldnames,delimiter='|')
            dw.writeheader()
            outputs[cat] = fout, dw
        # Always write the row
        outputs[cat][1].writerow(row)
    # Close all the files
    for fout, _ in outputs.values():
        fout.close()
