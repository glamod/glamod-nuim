# -*- coding: utf-8 -*-
"""
Created on Wed Jul 10 10:22:31 2019

@author: snoone
"""
 
     
import pandas as pd
import numpy as np
import csv

##DO NOT USE YET STILL SOMEISSUES WITH THE DAAT VALUES

df = pd.read_csv("header.csv", usecols = ['Year', 'Month',"Day",
                                          "Hour (LST)","Greenwich offset",
                                          "Longitude",
                                          "Latitude","Elevation",              
                                          "Station number","Dew point temperature"])

# add source id column and add source id to columns
df["Source_ID"]="Source_ID"
df["Source_ID"] = 244
##add in IFF columns and change the columns names in df to match IFF 
df["Alias_station_name"]="Null"
df["Source_QC_flag"]="Null"
df['Original_observed_value']="Null"
df['Original_observed_value_units']="F_tenths"
df['Gravity_corrected_by_source']='Null'
df['Homogenization_corrected_by_source']='Null'
df['Report_type_code']='Null'
df['Minute'] ='00'
df = df.rename(columns=({'Greenwich offset':'Greenwich_offset'}))
df = df.rename(columns=({'Dew point temperature':'Observed_value'}))
df = df.rename(columns=({'Hour (LST)':'Hour'}))
df = df.rename(columns=({'Station number':'Station_ID'}))

#convert values if needed or preform calculations on values e.g pressure, temp 
#and wind speed #
df['Original_observed_value']=df["Observed_value"]
#df["Observed_value"]= df["Observed_value"]/10
df['Observed_value2'] = np.where(df['Observed_value']>=200,200,100)
df['Observed_value3'] = df['Observed_value'] - df['Observed_value2'] 
df["Observed_value4"]= df["Observed_value3"]-32
df["Observed_value5"]= df["Observed_value4"]*5
df["Observed_value6"]= df["Observed_value5"]/9
#df['Observed_value3'] = np.where(df['Observed_value2']>=50,+900,+1000)
#df['Observed_value4'] = df['Observed_value3'] + df['Observed_value2'] 
del df["Observed_value2"]
#del df["Observed_value3"]
del df["Observed_value4"]
del df["Observed_value"]
df["Original_observed_value"]= df["Observed_value3"]
df = df.rename(columns=({'Observed_value6':'Observed_value'}))

#round convcerted values to 2 decimal places if needed
df['Observed_value']= round(df['Observed_value'],1)
###concanate date columns to adjust for time zone
df["Timestamp2"] = df["Year"].map(str) + "-" + df["Month"].map(str)+ "-" + df["Day"].map(str)  
df["Timestamp"] = df["Timestamp2"].map(str)+ " " + df["Hour"].map(str)+":"+df["Minute"].map(str) 
#join offset to sttaion id for tiemstamp conversion
df["Station_ID2"] = df["Station_ID"].map(str)+ "_" + df["Greenwich_offset"].map(str)
##reorder the columns headers
df = df[["Source_ID",'Station_ID',"Alias_station_name",  
                                 "Year","Month","Day","Hour","Minute",
                                "Latitude","Longitude","Elevation","Observed_value",
                                "Source_QC_flag","Original_observed_value",
                                "Original_observed_value_units",                                
                                "Report_type_code","Gravity_corrected_by_source",
                                "Homogenization_corrected_by_source","Timestamp",'Station_ID2']]
#convert timestamp
#from datetime import datetime
#from pytz import timezone
#date_str = ["Timestamp"]


#replace missing value codes
#df=df.replace ({1023:"Null"})
#df = df.replace ({526.28:"Null"})

#multiply pressure in mb tenths to mb=hpa need to check what the mb obs is
#df["Pressure"]= df["Pressure"] *100 
df.to_csv("output.csv",index=False)

### vlook up station_id from output.csv file and populate station names from  station_names.csv files
##not working!! 
import pandas as pd
df1=pd.read_csv("output.csv", low_memory=False)
df2=pd.read_csv("Station_name.csv")
df2 = df2.astype(str) 
df1 = df1.astype(str)
df1.dtypes
#match up columns in output with station name files and add station names NB diff 
#sources for smame station with diff ids
result = df1.merge(df2, on=['Station_ID'])

#result['Station_ID2'] = result['Deck'] + result['Station_ID']
#del result["Deck"]
#del result ["Station_ID"]
#result= result.rename(columns=({'Station_ID2':'Station_ID'}))
#reorder to IFF
result= result[["Source_ID",'Station_ID',"Station_name","Alias_station_name",  
                                 "Year","Month","Day","Hour","Minute",
                                "Latitude","Longitude","Elevation","Observed_value",
                                "Source_QC_flag","Original_observed_value",
                                "Original_observed_value_units",                                
                                "Report_type_code","Gravity_corrected_by_source",
                                "Homogenization_corrected_by_source","Timestamp",'Station_ID2']]


result.to_csv("output2.csv",index=False)



##### separate the large csv file by station ID+UTC offset and save as IFF named Station_Id+variable+Source_ID
import csv

with open('output2.csv') as fin:    
    csvin = csv.DictReader(fin)

    #csvin.columns = [x.replace(' ', '_') for x in csvin.columns]  
    # Category -> open file lookup
    outputs = {}
    for row in csvin:
        cat = row['Station_ID2']
        # Open a new file and write the header
        if cat not in outputs:
            fout = open ('{}_dew_point_temperature_244.psv'.format(cat), "w", newline = "")
            dw = csv.DictWriter(fout, fieldnames=csvin.fieldnames,delimiter='|')
            dw.writeheader()
            outputs[cat] = fout, dw
        # Always write the row
        outputs[cat][1].writerow(row)
    # Close all the files
    for fout, _ in outputs.values():
        fout.close()