
#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Jul 17 14:22:41 2019

@author: snoone
"""
import os
import glob
import pandas as pd
import csv

#OUTDIR = "/gws/nopw/j04/c3s311a_lot2/data/level1/land/level1a_sub_daily_data/dew_point_temperature/245_fix"
#os.chdir("/gws/nopw/j04/c3s311a_lot2/data/level1/land/level1a_sub_daily_data/dew_point_temperature/245")
OUTDIR = "D:/CHIMES/daily/pressure_mean/out"
os.chdir("D:/CHIMES/daily/pressure_mean/")
extension = 'tsv'
all_filenames = [i for i in glob.glob('*.{}'.format(extension))]


for filename in all_filenames:
    df=pd.read_csv(filename, sep='\t',skiprows=12)
    df1=pd.read_csv(filename,sep='\t', squeeze=True,nrows=11,)
    df2=df1.iloc[:,0:2]
    df2.to_csv("header.csv",index=False)
    df3 = pd.read_csv("header.csv",index_col='SEF',squeeze=True)
    station_id=df3.ID
    station_name=df3.Name
    lat=df3.Lat
    lon=df3.Lon
    Elev=df3.Alt
    df["Source_ID"] = 324
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
    df['Original_observed_value_units']="inHg"
    df['Report_type_code']='Null'
    df['Gravity_corrected_by_source']='0'
    df['Homogenization_corrected_by_source']='Null'
    df["Observed_value2"]=df["Observed_value"]
    del df["Observed_value"]
    df = df.rename(columns=({'Observed_value2':'Observed_value'}))
    df['Original_observed_value'] = df['Original_observed_value'].map(lambda x: x.lstrip('PGC=N|orig=').rstrip('inHg'))
        #reorder headings
    df = df[["Source_ID",'Station_ID',"Station_name","Alias_station_name",  
                                 "Year","Month","Day","Hour","Minute",
                                "Latitude","Longitude","Elevation","Observed_value",
                                "Pressure_flag","Source_QC_flag","Original_observed_value",
                                "Original_observed_value_units",                                
                                "Report_type_code","Gravity_corrected_by_source",
                                "Homogenization_corrected_by_source"]]
    
    
    outname = os.path.join(OUTDIR, filename)
    #with open(filename, "w") as outfile:
    df.to_csv(outname, index=False, sep="|")



##combine and rename files by station id
import os
import glob
import pandas as pd
import csv

##import all psv files in current dir
os.chdir("D:/CHIMES/daily/pressure_mean/out")
extension = 'tsv'
all_filenames = [i for i in glob.glob('*.{}'.format(extension))]
#combine all files in the list
df = pd.concat([pd.read_csv(f,delimiter='|') for f in all_filenames])
#dewpointtemp df['Observed_value']= round(df['Observed_value'],1)
df.to_csv("combined.csv",index=False)

with open('combined.csv') as fin:    
    csvin = csv.DictReader(fin)
    #csvin.columns = [x.replace(' ', '_') for x in csvin.columns]  
    # Category -> open file lookup
    outputs = {}
    for row in csvin:
        cat = row['Station_ID']
        # Open a new file and write the header
        if cat not in outputs:
            fout = open ('{}_station_level_pressure_324.psv'.format(cat), "w", newline = "")
            dw = csv.DictWriter(fout, fieldnames=csvin.fieldnames,delimiter='|')
            dw.writeheader()
            outputs[cat] = fout, dw
        # Always write the row
        outputs[cat][1].writerow(row)
    # Close all the files
    for fout, _ in outputs.values():
        fout.close()