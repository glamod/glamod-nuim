#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Jul 10 10:22:31 2019

@author: snoone
"""
     ###extract wind direction from TD-13 large csv files and rename columns to IFF
     
import pandas as pd
import os   
import pandas as pd

os.chdir ("/work/scratch-nompiio/snoone/convert_IFF/nuschinaweather/data/")
 
df = pd.read_csv("wthr-19121951-annotated.csv", usecols = ['year', 'month',"day"
                                          ,"longitude",
                                          "latitude","elevation",              
                                          "station", "tmin"])

# add source id column and add source id to columns
df["Source_ID"]="Source_ID"
df["Source_ID"] = 324
##add in IFF columns and change the columns names in df to match IFF 
df["Alias_station_name"]="Null"
df["Source_QC_flag"]="Null"
df['Original_observed_value']="Null"
df['Original_observed_value_units']="Null"
df['Gravity_corrected_by_source']='Null'
df['Homogenization_corrected_by_source']='Null'
df['Report_type_code']='Null'
df['Minute']='00'
df["Hour"]="0"
df = df.rename(columns=({'tmin':'Observed_value'}))
df['Station_ID']=df["station"]
df['Station_name']=df["station"]
df['Elevation']=df["elevation"].astype(int)
df['Latitude']=df["latitude"]
df['Longitude']=df["longitude"]
df['Month']=df["month"]
df['Day']=df["day"]
df['Year']=df["year"]
#round convcerted values to 2 decimal places if needed
df['Observed_value']= round(df['Observed_value'],1)
##reorder the columns headers
df = df[["Source_ID",'Station_ID',"Station_name","Alias_station_name",  
                                 "Year","Month","Day","Hour","Minute",
                                "Latitude","Longitude","Elevation","Observed_value",
                                "Source_QC_flag","Original_observed_value",
                                "Original_observed_value_units",                                
                                "Report_type_code","Gravity_corrected_by_source",
                                "Homogenization_corrected_by_source"]]

df.to_csv("output.csv",index=False)





##### separate the large csv file by station ID and save as IFF named Station_Id+variable+Source_ID
import csv

with open('output.csv') as fin:    
    csvin = csv.DictReader(fin)
    os.chdir ("/work/scratch-nompiio/snoone/convert_IFF/YKFeng_NUS_China_324/nuschinaweather/output/minimum_temperature/324")

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
    # Close all the files
    for fout, _ in outputs.values():
        fout.close()