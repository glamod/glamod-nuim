# -*- coding: utf-8 -*-
"""
Created on Wed Jul 10 10:22:31 2019

@author: snoone
"""
import numpy as np     
import os   
import glob
import pandas as pd
import csv

os.chdir("D:/UERRA_multiple source_sub_daily/UERRA_sub_daily/UERRA_C3_D1.6_digitiseddata_2017-05-30/UERRA_C3_D1.6_digitiseddata_2017-05-30/out/pp/174")
extension = 'csv'
all_filenames = [i for i in glob.glob('*.{}'.format(extension))]
#combine all files in the list
df = pd.concat([pd.read_csv(f,delimiter=',') for f in all_filenames])


# add source id column and add source id to columns
df["Source_ID"]="Source_ID"
df["Source_ID"] = 174
##add in IFF columns and change the columns names in df to match IFF 
df["Alias_station_name"]="Null"
df["Source_QC_flag"]="Null"
df['Original_observed_value_units']="Hpa"
df['Gravity_corrected_by_source']='NULL'
df['Homogenization_corrected_by_source']='Null'
df['Report_type_code']='Null'
df['Minute']='00'

df['Station_ID']=df["stationid"]
df['Station_name']=df["stationname"]
df['Latitude']=df["latitude"]
df['Longitude']=df["longitude"]
df['Elevation']=df["altitude"]
df['Year']=df["year"]
df['Month']=df["month"]
df['Day']=df["day"]
df['Hour']=df["hour"]
df['Observed_value']=df["convalue"]
df['Original_observed_value']=df["V3value"]


#round convcerted values to 2 decimal places if needed
#df['Original_observed_value']= round(df['Original_observed_value'],2)
#df['Observed_value']= round(df['Observed_value'],1)
##reorder the columns headers
df[['Hour']] = df[['Hour']].replace([100, 200, 300,400,500,600,700,800,900,1000,1100,1200,1300,1400,1500,
  1600,1700,1800,1900,2000,2100,2200,2300], [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,22,21,22,23])

#df.fillna(0)

#df['Year'] = df['Year'].astype(np.int64)
#df.dtypes
#cols = ["Year","Day", "Month","Hour"]
#df[cols] = df[cols].apply(pd.to_numeric, errors='coerce', axis=1)
#df[["Year","Day", "Month","Hour"]] = df[["Year","Day", "Month","Hour"]].apply(pd.to_numeric, errors='coerce')



df= df[["Source_ID",'Station_ID',"Station_name","Alias_station_name",  
                                 "Year","Month","Day","Hour","Minute",
                                "Latitude","Longitude","Elevation","Observed_value",
                                "Source_QC_flag","Original_observed_value",
                                "Original_observed_value_units",                                
                                "Report_type_code","Gravity_corrected_by_source",
                                "Homogenization_corrected_by_source"]]

df.dtypes

df["Timestamp2"] = df["Year"].map(str) + "-" + df["Month"].map(str)+ "-" + df["Day"].map(str)  
df["Timestamp"] = df["Timestamp2"].map(str)+ " " + df["Hour"].map(str)+":"+df["Minute"].map(str) 
#join offset to sttaion id for tiemstamp conversion
df.drop(columns=["Timestamp2"])
df= df[["Source_ID",'Station_ID',"Station_name","Alias_station_name",  
                                 "Year","Month","Day","Hour","Minute",
                                "Latitude","Longitude","Elevation","Observed_value",
                                "Source_QC_flag","Original_observed_value",
                                "Original_observed_value_units",                                
                                "Report_type_code","Gravity_corrected_by_source",
                                "Homogenization_corrected_by_source", "Timestamp"]]


#df.dtypes
#match up columns in output with station name files and add station names NB diff 
#sources for smame station with diff ids


#reorder to IFF



df.to_csv("output.csv",index=False)

#############separate by obseravtion flag 0=mb 1=mb no hundreths digits
os.chdir("D:/UERRA_multiple source_sub_daily/UERRA_sub_daily/UERRA_C3_D1.6_digitiseddata_2017-05-30/UERRA_C3_D1.6_digitiseddata_2017-05-30/out/pp/174")
with open('output.csv') as fin:    
    csvin = csv.DictReader(fin)
    os.chdir("D:/UERRA_multiple source_sub_daily/UERRA_sub_daily/UERRA_C3_D1.6_digitiseddata_2017-05-30/UERRA_C3_D1.6_digitiseddata_2017-05-30/out/pp/174/IFF")
    #csvin.columns = [x.replace(' ', '_') for x in csvin.columns]  
    # Category -> open file lookup
    outputs = {}
    for row in csvin:
        cat = row['Station_ID']
        # Open a new file and write the header
        if cat not in outputs:
            fout = open ('{}_sea_level_pressure_174.psv'.format(cat), "w", newline = "")
            dw = csv.DictWriter(fout, fieldnames=csvin.fieldnames,delimiter='|')
            dw.writeheader()
            outputs[cat] = fout, dw
        # Always write the row
        outputs[cat][1].writerow(row)
    # Close all the files
    for fout, _ in outputs.values():
        fout.close()
        



##### separate the large csv file by station ID and save as IFF named Station_Id+variable+Source_ID
