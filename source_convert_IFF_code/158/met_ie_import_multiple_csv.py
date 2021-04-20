# -*- coding: utf-8 -*-
"""
Created on Wed Jul 17 14:22:41 2019

@author: snoone
"""
import os
import glob
import pandas as pd
import csv


##import all csv files in current dir that need timezone changing to GMT based on hours offset 
os.chdir ("D:/Met_Eireann_sbdy/data")
extension = 'csv'
all_filenames = [i for i in glob.glob('*.{}'.format(extension))]
#combine all files in the list
df = pd.concat([pd.read_csv(f,delimiter=',') for f in all_filenames])



##add in IFF columns and change the columns names in df to match IFF 
df["Alias_station_name"]="Null"
df["Source_QC_flag"]="Null"
df['Original_observed_value']="Null"
df['Original_observed_value_units']="Null"
df['Gravity_corrected_by_source']='Null'
df['Homogenization_corrected_by_source']='Null'
df['Report_type_code']='0'
df['Minute']='00'
df = df.rename(columns=({'station_id':'Station_ID'}))
df = df.rename(columns=({'station_name':'Station_name'}))
df = df.rename(columns=({'hour':'Hour'}))
df = df.rename(columns=({'latitude':'Latitude'}))
df = df.rename(columns=({'longitude':'Longitude'}))
df = df.rename(columns=({'elevation':'Elevation'}))
df = df.rename(columns=({'year':'Year'}))
df = df.rename(columns=({'month':'Month'}))
df = df.rename(columns=({'day':'Day'}))
df = df.rename(columns=({'source_id':'Source_ID'}))
############################################################################
##extract variable 

df = df.rename(columns=({'wdsp':'Observed_value'}))

df2 = df[["Source_ID",'Station_ID',"Station_name","Alias_station_name",  
                                 "Year","Month","Day","Hour","Minute",
                                "Latitude","Longitude","Elevation","Observed_value",
                                "Source_QC_flag","Original_observed_value",
                                "Original_observed_value_units",                                
                                "Report_type_code","Gravity_corrected_by_source",
                                "Homogenization_corrected_by_source"]]

##set output directory for each variable
os.chdir ("D:/Met_Eireann_sbdy/data/output/wind_s")
##write output combined
df2.to_csv("combined.csv",index=False)

##separate combined to separate files based on a column chabnge fout =open fdetails each variab

with open('combined.csv') as fin:    
    csvin = csv.DictReader(fin)
    #csvin.columns = [x.replace(' ', '_') for x in csvin.columns]  
    # Category -> open file lookup
    outputs = {}
    for row in csvin:
        cat = row['Station_ID']
        # Open a new file and write the header
        if cat not in outputs:
            fout = open ('{}_wind_speed_158.psv'.format(cat), "w", newline = "")
            dw = csv.DictWriter(fout, fieldnames=csvin.fieldnames,delimiter='|')
            dw.writeheader()
            outputs[cat] = fout, dw
        # Always write the row
        outputs[cat][1].writerow(row)
    # Close all the files
    for fout, _ in outputs.values():
        fout.close()
        

