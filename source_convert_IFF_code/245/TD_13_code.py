# -*- coding: utf-8 -*-
"""
Created on Wed Jul 10 10:22:31 2019

@author: snoone
"""
## "Wind speed","Pressure","Pressure flag",
   ##         "Pressure surface","Station pressure","Station pressure flag","T","RH"
import pandas as pd
 
df = pd.read_csv("test2.txt", usecols = ['Year', 'Month',"Day","Hundredths hour","Longitude","Latitude","Elevation", 
             "Platform ID", "Wind direction"])
#####need to edit this to remove missing/unknown values
#df = df.replace({"16383":"Null","32767":"Null","511":"Null","127":"Null"})
# add source id column and add source id to columns
df["Source_ID"]="Source_ID"
df["Source_ID"] = 245
##add in IFF columns and change the columns names in df to match IFF 
df["Station_name"]="Null"
df["Alias_station_name"]="Null"
df["Source_QC_flag"]="Null"
df['Original_observed_value']="Null"
df['Original_observed_value_units']="Null"
df['Gravity_corrected_by_source']='Null'
df['Homogenization_corrected_by_source']='Null'
df['Report_type_code']='Null'
df['Minute']='00'
df = df.rename(columns=({'Wind direction':'Observed_value'}))
df = df.rename(columns=({'Hundredths hour':'Hour'}))
df = df.rename(columns=({'Platform ID':'Station_ID'}))
df["Hour"]= df["Hour"] /100
#convert wind speed from knots to ms
df["Observed_value"]= df["Observed_value"] /0.514444
df['Observed_value']= round(df['Observed_value'],2)
##reorder teh columns headers
df = df[["Source_ID",'Station_ID',"Station_name","Alias_station_name",  
                                 "Year","Month","Day","Hour","Minute",
                                "Latitude","Longitude","Elevation","Observed_value",
                                "Source_QC_flag","Original_observed_value",
                                "Original_observed_value_units",                                
                                "Report_type_code","Gravity_corrected_by_source",
                                "Homogenization_corrected_by_source"]]
#multiply pressure in mb tenths to mb=hpa need to check what the mb obs is
#df["Pressure"]= df["Pressure"] *100 
df.to_csv("output.csv",index=False)

##### separate the large scv fields by station ID
import csv

with open('output.csv') as fin:    
    csvin = csv.DictReader(fin)

    #csvin.columns = [x.replace(' ', '_') for x in csvin.columns]  
    # Category -> open file lookup
    outputs = {}
    for row in csvin:
        cat = row['Platform ID']
        # Open a new file and write the header
        if cat not in outputs:
            fout = open('{}_Wind_direction_245.csv'.format(cat), "w", newline = "" )
            dw = csv.DictWriter(fout, fieldnames=csvin.fieldnames)
            dw.writeheader()
            outputs[cat] = fout, dw
        # Always write the row
        outputs[cat][1].writerow(row)
    # Close all the files
    for fout, _ in outputs.values():
        fout.close()