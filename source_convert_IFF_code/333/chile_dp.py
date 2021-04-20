# -*- coding: utf-8 -*-
"""
Created on Wed Jul 10 10:22:31 2019

@author: snoone
"""
     
import os   
import glob
import pandas as pd
import csv
#chnage path where needed
os.chdir("D:/Chile_met/Hourly_data/ws")
extension = 'csv'
all_filenames = [i for i in glob.glob('*.{}'.format(extension))]
#combine all files in the list
df = pd.concat([pd.read_csv(f,delimiter=';') for f in all_filenames])


# add source id column and add source id to columns
#df["Source_ID"]="Source_ID"
df["Source_ID"] = 333
##add in IFF columns and change the columns names in df to match IFF 
df["Alias_station_name"]="Null"
df["Source_QC_flag"]="Null"
df['Original_observed_value_units']="ms"
df['Gravity_corrected_by_source']='NULL'
df['Homogenization_corrected_by_source']='Null'
df['Report_type_code']='Null'
df['Minute']='00'

df['Station_ID']=df["CodigoNacional"]
df['Station_name']="NUll"
df['Latitude']="Null"
df['Longitude']="Null"
df['Elevation']="Null"
df['Year']="Null"
df['Month']="Null"
df['Day']="Null"
df['Hour']="Null"
df['Observed_value']=df["ff_Valor"]
df['Original_observed_value']="Null"

df['Timestamp']=df["momento"]

###set timestamp format

df['Timestamp'] =  pd.to_datetime(df['Timestamp'], format='%d-%m-%Y' " ""%H:%M:%S") 

df= df[["Source_ID",'Station_ID',"Station_name","Alias_station_name",  
                                 "Year","Month","Day","Hour","Minute",
                                "Latitude","Longitude","Elevation","Observed_value",
                                "Source_QC_flag","Original_observed_value",
                                "Original_observed_value_units",                                
                                "Report_type_code","Gravity_corrected_by_source",
                                "Homogenization_corrected_by_source","Timestamp"]]

##add timestamp to columns separatedYear day hour minute and lose seconds
df['Timestamp'] =  pd.to_datetime(df['Timestamp'], format='%Y-%m-%d' " ""%H:%M:%S")
df['Timestamp'] = df['Timestamp'].dt.tz_localize('Etc/GMT-0').dt.tz_convert('GMT')
df['Year'] = df['Timestamp'].dt.year 
df['Month'] = df['Timestamp'].dt.month 
df['Day'] = df['Timestamp'].dt.day 
df['Hour'] = df['Timestamp'].dt.hour 
df['Minute'] = df['Timestamp'].dt.minute
df['Seconds'] = df['Timestamp'].dt.second
    
##delete unwanted columns 
df = df.drop(columns="Timestamp")
df['Minute']='00'



##add in information from station from stations file


df2=pd.read_csv("D:/Chile_met/Hourly_data/stations.csv")
result = pd.merge(df, df2, on=['Station_ID','Station_ID'])
result['Station_ID2'] = result['Station_ID']
result['Longitude'] = result['Long']
result['Latitude'] = result['Lat']
result['Elevation'] = result['Elev']
result['Station_name'] = result['name']
del result["Station_ID"]

result= result.rename(columns=({'Station_ID2':'Station_ID'}))
#reorder to IFF
result= result[["Source_ID",'Station_ID',"Station_name","Alias_station_name",  
                                 "Year","Month","Day","Hour","Minute",
                                "Latitude","Longitude","Elevation","Observed_value",
                                "Source_QC_flag","Original_observed_value",
                                "Original_observed_value_units",                                
                                "Report_type_code","Gravity_corrected_by_source",
                                "Homogenization_corrected_by_source"]]
####set decimal places to 3 
result.dtypes
result['Station_ID'] = result['Station_ID'].astype(str) 
result['Elevation'] = result['Elevation'].astype(str) 
result.dtypes
result["Latitude"]= round(result["Latitude"],3)
result["Longitude"]= round(result["Longitude"],3)
#result['Observed_value'] = result['Observed_value'].astype(str) 

result.to_csv("output.csv",index=False)



#############separate by station ID to psv from output.Chnage varibale name and path 

with open('output.csv') as fin:  
    
    csvin = csv.DictReader(fin)
    os.chdir("D:/Chile_met/Hourly_data/ws/333/ws")
    outputs = {}
    for row in csvin:
        cat = row['Station_ID']
        # Open a new file and write the header
        if cat not in outputs:
            fout = open ('{}_wind_speed_333.psv'.format(cat), "w", newline = "")
            dw = csv.DictWriter(fout, fieldnames=csvin.fieldnames,delimiter='|')
            dw.writeheader()
            outputs[cat] = fout, dw
        # Always write the row
        outputs[cat][1].writerow(row)
    # Close all the files
    for fout, _ in outputs.values():
        fout.close()
        



