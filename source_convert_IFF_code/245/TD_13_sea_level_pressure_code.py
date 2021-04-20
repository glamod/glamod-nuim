# -*- coding: utf-8 -*-
"""
Created on Wed Jul 10 10:22:31 2019

@author: snoone
"""
     
     
import pandas as pd
 
df = pd.read_csv("Y90117.csv", usecols = ['Year', 'Month',"Day",
                                          "Hundredths hour","Longitude",
                                          "Latitude","Elevation",              
                                          "Platform ID", "Pressure","Pressure flag"])

# add source id column and add source id to columns
df["Source_ID"]="Source_ID"
df["Source_ID"] = 245
##add in IFF columns and change the columns names in df to match IFF 
df["Alias_station_name"]="Null"
df["Source_QC_flag"]="Null"
df['Original_observed_value']="Null"
df['Original_observed_value_units']="mb"
df['Gravity_corrected_by_source']='Null'
df['Homogenization_corrected_by_source']='Null'
df['Report_type_code']='Null'
df['Minute']='00'
df = df.rename(columns=({'Pressure':'Observed_value'}))
df = df.rename(columns=({'Pressure flag':'Pressure_flag'}))
df = df.rename(columns=({'Hundredths hour':'Hour'}))
df = df.rename(columns=({'Platform ID':'Station_ID'}))
df["Hour"]= df["Hour"] //100
df['Original_observed_value']=df["Observed_value"]
#convert values if needed or preform calculations on values e.g pressure, temp 
#and wind speed #

#df["Observed_value"]= df["Observed_value"]-32
#df["Observed_value"]= df["Observed_value"]*5
#df["Observed_value"]= df["Observed_value"]/9

#round convcerted values to 2 decimal places if needed
df['Observed_value']= round(df['Observed_value'],2)
##reorder the columns headers
df = df[["Source_ID",'Station_ID',"Alias_station_name",  
                                 "Year","Month","Day","Hour","Minute",
                                "Latitude","Longitude","Elevation","Observed_value",
                                "Pressure_flag","Source_QC_flag","Original_observed_value",
                                "Original_observed_value_units",                                
                                "Report_type_code","Gravity_corrected_by_source",
                                "Homogenization_corrected_by_source"]]
#replace missing value codes
df=df.replace ({16383:"Null"})
#df=df.replace ({266.11:"Null"})
#multiply pressure in mb tenths to mb=hpa need to check what the mb obs is
#df["Pressure"]= df["Pressure"] *100 
df.to_csv("output.csv",index=False)

### vlook up station_id from output.csv file and populate station names from  station_names.csv files
##not working!! 
import pandas as pd
df1=pd.read_csv("output.csv", low_memory=False)
df2=pd.read_csv("station_names.csv")
df2 = df2.astype(str) 
df1 = df1.astype(str)
df1.dtypes
#match up columns in output with station name files and add station names NB diff 
#sources for smame station with diff ids
result = df1.merge(df2, on=['Station_ID',"Latitude","Longitude"])

result['Station_ID2'] = result['Deck'] + result['Station_ID']
del result["Deck"]
del result ["Station_ID"]
result= result.rename(columns=({'Station_ID2':'Station_ID'}))
#reorder to IFF
result= result[["Source_ID",'Station_ID',"Station_name","Alias_station_name",  
                                 "Year","Month","Day","Hour","Minute",
                                "Latitude","Longitude","Elevation","Observed_value",
                                "Pressure_flag",
                                "Source_QC_flag","Original_observed_value",
                                "Original_observed_value_units",                                
                                "Report_type_code","Gravity_corrected_by_source",
                                "Homogenization_corrected_by_source"]]
result.to_csv("output2.csv",index=False)

#############separate by obseravtion flag 0=mb 1=mb no bhundreths digits
import csv

with open('output2.csv') as fin:    
    csvin = csv.DictReader(fin)

    #csvin.columns = [x.replace(' ', '_') for x in csvin.columns]  
    # Category -> open file lookup
    outputs = {}
    for row in csvin:
        cat = row['Pressure_flag']
        # Open a new file and write the header
        if cat not in outputs:
            fout = open ('{}_output3.csv'.format(cat), "w", newline = "")
            dw = csv.DictWriter(fout, fieldnames=csvin.fieldnames,delimiter=',')
            dw.writeheader()
            outputs[cat] = fout, dw
        # Always write the row
        outputs[cat][1].writerow(row)
    # Close all the files
    for fout, _ in outputs.values():
        fout.close() 
        
### remove the Pressure flag column
df3 = pd.read_csv("0_output3.csv", low_memory=False)
del df3["Pressure_flag"]   
df3.to_csv("0_output4.csv",index=False)


##### separate the large csv file by station ID and save as IFF named Station_Id+variable+Source_ID
import csv

with open('0_output4.csv') as fin:    
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