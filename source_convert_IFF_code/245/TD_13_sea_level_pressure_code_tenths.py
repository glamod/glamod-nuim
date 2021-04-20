# -*- coding: utf-8 -*-
"""
Created on Wed Jul 10 10:22:31 2019

@author: snoone
"""
    ##move 1~_output3.csv to new folder and rrun tsi code toe xtract and convert
    #tenths pessure some files have both

### remove the Pressure flag column
import numpy as np       
import pandas as pd

df3 = pd.read_csv("1_output3.csv", low_memory =False)
del df3["Pressure_flag"]   
df3.to_csv("1_output4.csv",index=False)

###convert tenths mb to 1000 and hundreths <50+1000 >50+900

df4 = pd.read_csv("1_output4.csv",low_memory =False)
df4['Observed_value2'] = np.where(df4['Observed_value']>=50,+900,+1000)
df4['Observed_value3'] = df4['Observed_value2'] + df4['Observed_value'] 
del df4["Observed_value2"]  
del df4["Observed_value"]
df4 = df4.rename(columns=({'Observed_value3':'Observed_value'}))
#reorder to IFF
df4 = df4[["Source_ID",'Station_ID',"Station_name","Alias_station_name",  
                                 "Year","Month","Day","Hour","Minute",
                                "Latitude","Longitude","Elevation","Observed_value",
                                "Source_QC_flag","Original_observed_value",
                                "Original_observed_value_units",                                
                                "Report_type_code","Gravity_corrected_by_source",
                                "Homogenization_corrected_by_source"]] 
df4.to_csv("1_output5.csv",index=False)



##### separate the large csv file based on 1_ by station ID and save as IFF named Station_Id+variable+Source_ID
import csv

with open('1_output5.csv') as fin:    
    csvin = csv.DictReader(fin)
    #csvin.columns = [x.replace(' ', '_') for x in csvin.columns]  
    # Category -> open file lookup
    outputs = {}
    for row in csvin:
        cat = row['Station_ID']
        # Open a new file and write the header
        if cat not in outputs:
            fout = open ('{}_sea_level_pressure_245.psv'.format(cat), "w", newline = "")
            dw = csv.DictWriter(fout, fieldnames=csvin.fieldnames,delimiter='|')
            dw.writeheader()
            outputs[cat] = fout, dw
        # Always write the row
        outputs[cat][1].writerow(row)
    # Close all the files
    for fout, _ in outputs.values():
        fout.close()

        