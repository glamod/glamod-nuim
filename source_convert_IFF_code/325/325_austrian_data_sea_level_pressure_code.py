# -*- coding: utf-8 -*-
"""
Created on Wed Jul 10 10:22:31 2019

@author: snoone
"""
     
import os   
import glob
import pandas as pd
import csv

os.chdir("D:/Austrain_pressure_data/data")
extension = 'csv'
all_filenames = [i for i in glob.glob('*.{}'.format(extension))]
#combine all files in the list
df = pd.concat([pd.read_csv(f,delimiter=',') for f in all_filenames])


# add source id column and add source id to columns
df["Source_ID"]="Source_ID"
df["Source_ID"] = 325
##add in IFF columns and change the columns names in df to match IFF 
df["Alias_station_name"]="Null"
df["Source_QC_flag"]="NULL"
df['Original_observed_value_units']="Hpa"
df['Gravity_corrected_by_source']='NULL'
df['Homogenization_corrected_by_source']='Null'
df['Report_type_code']='Null'

df ["Original_observed_value"]="NULL"
df = df.rename(columns=({'ID':'Station_ID'}))
df = df.rename(columns=({'name':'Station_name'}))
df = df.rename(columns=({'year':'Year'}))
df = df.rename(columns=({'month':'Month'}))
df = df.rename(columns=({'day':'Day'}))
df = df.rename(columns=({'hour':'Hour'}))##change
df['Minute']='00'
df = df.rename(columns=({'press_06':'Observed_value'}))#change
df = df.rename(columns=({"lat":"Latitude"}))
df = df.rename(columns=({"long":"Longitude"}))
df = df.rename(columns=({"elevation":"Elevation"}))
df.fillna("NULL",inplace=True)

df= df[["Source_ID",'Station_ID',"Station_name","Alias_station_name",  
                                 "Year","Month","Day","Hour","Minute",
                                "Latitude","Longitude","Elevation","Observed_value",
                                "Source_QC_flag","Original_observed_value",
                                "Original_observed_value_units",                                
                                "Report_type_code","Gravity_corrected_by_source",
                                "Homogenization_corrected_by_source"]]

os.chdir("D:/Austrain_pressure_data/data")
extension = 'csv'
all_filenames = [i for i in glob.glob('*.{}'.format(extension))]
#combine all files in the list
df1 = pd.concat([pd.read_csv(f,delimiter=',') for f in all_filenames])
# add source id column and add source id to columns
df1["Source_ID"]="Source_ID"
df1["Source_ID"] = 325
##add in IFF columns and change the columns names in df1 to match IFF 
df1["Alias_station_name"]="Null"
df1["Source_QC_flag"]="NULL"
df1['Original_observed_value_units']="Hpa"
df1['Gravity_corrected_by_source']='NULL'
df1['Homogenization_corrected_by_source']='Null'
df1['Report_type_code']='Null'

df1 ["Original_observed_value"]="NULL"
df1 = df1.rename(columns=({'ID':'Station_ID'}))
df1 = df1.rename(columns=({'name':'Station_name'}))
df1 = df1.rename(columns=({'year':'Year'}))
df1 = df1.rename(columns=({'month':'Month'}))
df1 = df1.rename(columns=({'day':'Day'}))
df1 = df1.rename(columns=({'hour2':'Hour'}))##change
df1['Minute']='00'
df1 = df1.rename(columns=({'press_13':'Observed_value'}))#change
df1 = df1.rename(columns=({"lat":"Latitude"}))
df1 = df1.rename(columns=({"long":"Longitude"}))
df1 = df1.rename(columns=({"elevation":"Elevation"}))
df1.fillna("NULL",inplace=True)
df1= df1[["Source_ID",'Station_ID',"Station_name","Alias_station_name",  
                                 "Year","Month","Day","Hour","Minute",
                                "Latitude","Longitude","Elevation","Observed_value",
                                "Source_QC_flag","Original_observed_value",
                                "Original_observed_value_units",                                
                                "Report_type_code","Gravity_corrected_by_source",
                                "Homogenization_corrected_by_source"]]

os.chdir("D:/Austrain_pressure_data/data")
extension = 'csv'
all_filenames = [i for i in glob.glob('*.{}'.format(extension))]
#combine all files in the list
df2 = pd.concat([pd.read_csv(f,delimiter=',') for f in all_filenames])

# add source id column and add source id to columns
df2["Source_ID"]="Source_ID"
df2["Source_ID"] = 325
##add in IFF columns and change the columns names in df2 to match IFF 
df2["Alias_station_name"]="Null"
df2["Source_QC_flag"]="NULL"
df2['Original_observed_value_units']="Hpa"
df2['Gravity_corrected_by_source']='NULL'
df2['Homogenization_corrected_by_source']='Null'
df2['Report_type_code']='Null'

df2 ["Original_observed_value"]="NULL"
df2 = df2.rename(columns=({'ID':'Station_ID'}))
df2 = df2.rename(columns=({'name':'Station_name'}))
df2 = df2.rename(columns=({'year':'Year'}))
df2 = df2.rename(columns=({'month':'Month'}))
df2 = df2.rename(columns=({'day':'Day'}))
df2 = df2.rename(columns=({'hour3':'Hour'}))##change
df2['Minute']='00'
df2 = df2.rename(columns=({'press_18':'Observed_value'}))#change
df2 = df2.rename(columns=({"lat":"Latitude"}))
df2 = df2.rename(columns=({"long":"Longitude"}))
df2 = df2.rename(columns=({"elevation":"Elevation"}))
df2.fillna("NULL",inplace=True)
df2= df2[["Source_ID",'Station_ID',"Station_name","Alias_station_name",  
                                 "Year","Month","Day","Hour","Minute",
                                "Latitude","Longitude","Elevation","Observed_value",
                                "Source_QC_flag","Original_observed_value",
                                "Original_observed_value_units",                                
                                "Report_type_code","Gravity_corrected_by_source",
                                "Homogenization_corrected_by_source"]]


df4=pd.concat([df, df1, df2],ignore_index=True)

df4.to_csv("output.csv",index=False)



#reorder to IFF



#############separate by obseravtion flag 0=mb 1=mb no hundreths digits
with open('output.csv') as fin:    
    csvin = csv.DictReader(fin)
    os.chdir("D:/Austrain_pressure_data/data/IFF")
    #csvin.columns = [x.replace(' ', '_') for x in csvin.columns]  
    # Category -> open file lookup
    outputs = {}
    for row in csvin:
        cat = row['Station_ID']
        # Open a new file and write the header
        if cat not in outputs:
            fout = open ('{}_station_level_pressure_325.psv'.format(cat), "w", newline = "")
            dw = csv.DictWriter(fout, fieldnames=csvin.fieldnames,delimiter='|')
            dw.writeheader()
            outputs[cat] = fout, dw
        # Always write the row
        outputs[cat][1].writerow(row)
    # Close all the files
    for fout, _ in outputs.values():
        fout.close()
        



##### separate the large csv file by station ID and save as IFF named Station_Id+variable+Source_ID
