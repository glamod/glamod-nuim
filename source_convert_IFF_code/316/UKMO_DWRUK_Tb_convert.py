# -*- coding: utf-8 -*-
"""
Created on Fri Dec  6 14:33:25 2019

@author: snoone
"""
# -*- coding: utf-8 -*-
"""
Created on Wed Jul 17 14:22:41 2019

@author: snoone
"""
import os
import glob
import pandas as pd
import csv



#extract the first 11 rows of the header to a df
df = pd.read_csv("DWR_UKMO_DWRUK_LONDON_19000101-19041229_tb.tsv",skiprows=12, sep='\t')
#extract the first 11 rows of the header to a df
df1=pd.read_csv("DWR_UKMO_DWRUK_LONDON_19000101-19041229_tb.tsv", nrows=11,sep='\t', squeeze=True)
df2=df1.iloc[:,0:2]
df2.to_csv("header.csv",index=False)
#extract required values form header
df3 = pd.read_csv("header.csv",index_col='SEF',squeeze=True)
#df1 = pd.concat([pd.read_csv(f,sep='\t',nrows=11,index_col='SEF', squeeze=True) for f in all_filenames])

station_id=df3.ID
station_name=df3.Name
lat=df3.Lat
lon=df3.Lon
Elev=df3.Alt

#change source id to allocated one
df["Source_ID"] = 316
df["Station_ID"]=station_id
df["Station_name"]=station_name
df["Alias_station_name"]="Null"
df["Latitude"]=lat
df["Longitude"]=lon
df["Elevation"]=Elev

df = df.rename(columns=({'Value':'Observed_value'}))
df["Pressure_flag"]="Null"
df["Source_QC_flag"]="Null"
df = df.rename(columns=({'Meta':'Original_observed_value'}))
df['Original_observed_value_units']="F"
df['Report_type_code']='Null'
#check the meta for PGC for gravity corrected 0=no, 1=yes,9=missing
df['Gravity_corrected_by_source']='9'
df['Homogenization_corrected_by_source']='Null'
#divide by 100 pascal to Hpa if needed
df["Observed_value2"]=df["Observed_value"]
del df["Observed_value"]
df = df.rename(columns=({'Observed_value2':'Observed_value'}))
##remove unwnated strings from columns
df['Original_observed_value'] = df['Original_observed_value'].map(lambda x: x.lstrip('orig=').rstrip('F'))


##re-order the headers
df = df[["Source_ID",'Station_ID',"Station_name","Alias_station_name",  
                                 "Year","Month","Day","Hour","Minute",
                                "Latitude","Longitude","Elevation","Observed_value",
                                "Pressure_flag","Source_QC_flag","Original_observed_value",
                                "Original_observed_value_units",                                
                                "Report_type_code","Gravity_corrected_by_source",
                                "Homogenization_corrected_by_source"]]

df.to_csv("output.csv",index=False)


with open('output.csv') as fin:    
    csvin = csv.DictReader(fin)
    #csvin.columns = [x.replace(' ', '_') for x in csvin.columns]  
    # Category -> open file lookup
    outputs = {}
    for row in csvin:
        cat = row['Station_ID']
        # Open a new file and write the header
        if cat not in outputs:
            fout = open ('{}_wet_bulb_temperature_316.psv'.format(cat), "w", newline = "")##change source ID
            dw = csv.DictWriter(fout, fieldnames=csvin.fieldnames,delimiter='|')
            dw.writeheader()
            outputs[cat] = fout, dw
        # Always write the row
        outputs[cat][1].writerow(row)
    # Close all the files
    for fout, _ in outputs.values():
        fout.close()

