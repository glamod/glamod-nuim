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

def remove_non_ascii(text): 
        return ''.join(i for i in text if ord(i)<128)
    
OUTDIR = "D:/brazil_inmet/DataDaily_A_all_years_IFF/wind_speed"
os.chdir("D:/brazil_inmet/DataDaily_A_all_years_IFF/wind_speed")

extension = 'psv'
all_filenames = [i for i in glob.glob('*.{}'.format(extension))]
for filename in all_filenames:
    df = pd.read_csv(filename, sep='|')
    df2=pd.read_csv("D:/brazil_inmet/inventory/elevation.csv")
    df = df.astype({"Station_ID": str})
    result = pd.merge(df, df2, on=['Station_ID','Station_ID'])
    result['Station_ID2'] = result['Station_ID']
    result['Elevation'] = result['Elev']
    result['Station_name'] = result['Name']
    result['Latitude'] = result["Latitude"].round(3)
    result["Longitude"] = result["Longitude"].round(3)
    result["Elevation"] = result["Elevation"].round(1)
    result['Station_name'] = result['Station_name'].apply(remove_non_ascii)
    del result["Station_ID"]
    result= result.rename(columns=({'Station_ID2':'Station_ID'}))
    df=result[["Source_ID",'Station_ID',"Station_name","Alias_station_name",  
                                 "Year","Month","Day","Hour","Minute",
                                "Latitude","Longitude","Elevation","Observed_value",
                                "Source_QC_flag","Original_observed_value",
                                "Original_observed_value_units",                                
                                "Report_type_code","Measurement_code_1",
                                "Measurement_code_2"]]
    #df.Observed_value = df.Observed_value.apply(int)
    #df.Original_observed_value = df.Original_observed_value.apply(int)
    #df[["Original_observed_value","Observed_value"]] = df[["Original_observed_value","Observed_value"]].apply(pd.to_numeric, errors='coerce')
    #df['Observed_value'] = pd.to_numeric(df['Observed_value'], errors = 'coerce')
    #df['Observed_value'] = df['Observed_value'].fillna(0).astype(int)



    outname = os.path.join(OUTDIR, filename )
    #with open(filename, "w") as outfile:
    df.to_csv(outname, index=False, sep="|",encoding='utf-8')
    