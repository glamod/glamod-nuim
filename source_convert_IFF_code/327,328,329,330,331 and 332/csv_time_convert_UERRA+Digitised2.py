# -*- coding: utf-8 -*-
"""
Created on Wed Jul 17 14:22:41 2019

@author: snoone
"""
import os
import glob
import pandas as pd
import csv
import datetime
import numpy as np

##import all csv files in  dir that need timezone changing to GMT based on hours offset 


OUTDIR = "D:/ERACLIM/ERACLIM_multiple sources/Chile/1/out/years/ws/bad"
os.chdir("D:/ERACLIM/ERACLIM_multiple sources/Chile/1/out/years/ws/bad")
extension = 'psv'
all_filenames = [i for i in glob.glob('*.{}'.format(extension))]
for filename in all_filenames:
    df = pd.read_csv(filename, sep='|')
    #split the (GMT)  timestampinto columns
    df['Timestamp'] =  pd.to_datetime(df['Timestamp'], format='%Y/%m/%d' " ""%H:%M")
    df['Timestamp'] = df['Timestamp'].dt.tz_localize('Etc/GMT+3').dt.tz_convert('GMT')
    df['Year'] = df['Timestamp'].dt.year 
    df['Month'] = df['Timestamp'].dt.month 
    df['Day'] = df['Timestamp'].dt.day 
    df['Hour'] = df['Timestamp'].dt.hour 
    df['Minute'] = df['Timestamp'].dt.minute 
    ##delete unwanted columns 
    df = df.drop(columns="Timestamp")
    #df['Minute']='00'
    #df=df.replace({-99.9:"Null"})                                          

    df = df[["Source_ID",'Station_ID',"Station_name","Alias_station_name",  
                                 "Year","Month","Day","Hour","Minute",
                                "Latitude","Longitude","Elevation","Observed_value",
                                "Source_QC_flag","Original_observed_value",
                                "Original_observed_value_units",                                
                                "Report_type_code","Gravity_corrected_by_source",
                                "Homogenization_corrected_by_source"]]
    outname = os.path.join(OUTDIR, filename)
    #with open(filename, "w") as outfile:
    df.to_csv(outname, index=False, sep="|")
        






