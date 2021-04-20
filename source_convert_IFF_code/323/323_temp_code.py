# -*- coding: utf-8 -*-
"""
Created on Wed Jul 10 10:22:31 2019

@author: snoone
"""
     
import os   
import glob
import pandas as pd
import csv

os.chdir("D:/Indian_stationdata_187578_1884_188990/data_converted/Temp")
extension = 'csv'
all_filenames = [i for i in glob.glob('*.{}'.format(extension))]
#combine all files in the list
df = pd.concat([pd.read_csv(f,delimiter=',') for f in all_filenames])


# add source id column and add source id to columns
df["Source_ID"]="Source_ID"
df["Source_ID"] = 323
##add in IFF columns and change the columns names in df to match IFF 
df["Alias_station_name"]="Null"
df["Source_QC_flag"]="Null"
df['Original_observed_value_units']="F"
df['Gravity_corrected_by_source']='NULL'
df['Homogenization_corrected_by_source']='Null'
df['Report_type_code']='Null'
df['Minute']='00'

df['Original_observed_value']=df["Observed_value"]



#convert values if needed or preform calculations on values e.g pressure, temp 
#and wind speed #a

df["Observed_value"]= df["Observed_value"]-32
df["Observed_value"]= df["Observed_value"]*5
df["Observed_value"]= df["Observed_value"]/9

#round convcerted values to 2 decimal places if needed
df['Original_observed_value']= round(df['Original_observed_value'],2)
df['Observed_value']= round(df['Observed_value'],1)
##reorder the columns headers
df = df.astype(str)


df.dtypes

df["Timestamp2"] = df["Year"].map(str) + "-" + df["Month"].map(str)+ "-" + df["Day"].map(str)  
df["Timestamp"] = df["Timestamp2"].map(str)+ " " + df["Hour"].map(str)+":"+df["Minute"].map(str) 
#join offset to sttaion id for tiemstamp conversion



#df.to_csv("output.csv",index=False)


#import pandas as pd
#df1=pd.read_csv("output.csv")

df= df.astype(str)
df.dtypes
#match up columns in output with station name files and add station names NB diff 
#sources for smame station with diff ids



#reorder to IFF
df= df[["Source_ID",'Station_ID',"Station_name","Alias_station_name",  
                                 "Year","Month","Day","Hour","Minute",
                                "Latitude","Longitude","Elevation","Observed_value",
                                "Source_QC_flag","Original_observed_value",
                                "Original_observed_value_units",                                
                                "Report_type_code","Gravity_corrected_by_source",
                                "Homogenization_corrected_by_source", "Timestamp"]]
df.to_csv("output.csv",index=False)

#############separate by obseravtion flag 0=mb 1=mb no hundreths digits
with open('output.csv') as fin:    
    csvin = csv.DictReader(fin)
    os.chdir("D:/Indian_stationdata_187578_1884_188990/data_converted/Temp/IFF")
    #csvin.columns = [x.replace(' ', '_') for x in csvin.columns]  
    # Category -> open file lookup
    outputs = {}
    for row in csvin:
        cat = row['Station_ID']
        # Open a new file and write the header
        if cat not in outputs:
            fout = open ('{}_temperature_323.psv'.format(cat), "w", newline = "")
            dw = csv.DictWriter(fout, fieldnames=csvin.fieldnames,delimiter='|')
            dw.writeheader()
            outputs[cat] = fout, dw
        # Always write the row
        outputs[cat][1].writerow(row)
    # Close all the files
    for fout, _ in outputs.values():
        fout.close()
        



##### separate the large csv file by station ID and save as IFF named Station_Id+variable+Source_ID
