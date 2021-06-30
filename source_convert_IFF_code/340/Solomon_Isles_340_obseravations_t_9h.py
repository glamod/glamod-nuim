#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Jul 17 14:22:41 2019

@author: snoone
"""
import os
import pandas as pd
import numpy as np



os.chdir("D:/ACRE_ROB_Dropbox/Solomon Islands")

df=pd.read_excel("TULAGI 1909-1941.xlsx",skiprows = 4,sheet_name="1600") 
#df2=pd.read_excel("1953.xlsx",sheet_name="j9") 
df["Source_ID"]="340"
df["Station_ID"]="340-00001"
df["Alias_station_name"]="Null"
df["Station_name"]="Tulagi(Solomon Islands)"
df["Latitude"]= "-9.05"
df["Longitude"]= "160.08"
df["Elevation"]= df["ele"]
#split the (GMT)  timestampinto columns 
df['Year'] = df['year']
df['Month'] = df['month'] 
df['Day'] = df['day']
df["Hour"]="16"
df = df.astype({"Year": int})
df = df.astype({"Month": int})
df = df.astype({"Day": int})
df = df.astype({"Hour": int})
#df ["Year"]=df["Year"].replace(to_replace=1999,value=1899)

df["Minute"]= "00"
df["Alias_station_name"]=df["Alias_station_name"]
df["Source_QC_flag"]=""
df['Original_observed_value_units']="inhg"
df['Measurement_code_1']=''
df['Measurement_code_2']=''
df['Report_type_code']=''
df["Observed_value"]=df["Barometer"]
df['Original_observed_value']=df["Barometer"]
#df.fillna("NULL",inplace=True)
#df = df.fillna()
##df.drop(df.tail(4).index,inplace=True)
#df['Year'].replace('', np.nan, inplace=True)
#df.dropna(subset=['Year'], inplace=True)

#df = df.astype({"Year": int})
#df = df.astype({"Month": int})
##df = df.astype({"Day": int})
#df = df.astype({"Hour": int})

#remove rows with  o obervaed values

df["Observed_value"] = pd.to_numeric(df["Observed_value"],errors='coerce')
#df = df.astype({"Observed_value": int})
#df['Observed_value'].astype(str).astype(int)
#df["Observed_value"]= df["Observed_value"]-32
#df["Observed_value"]= df["Observed_value"]*5
#df["Observed_value"]= df["Observed_value"]/9
df['Observed_value']=df["Observed_value"]* 33.86389
df["Observed_value"]= df["Observed_value"].round(1)
df['Observed_value'].replace('', np.nan, inplace=True)
df.dropna(subset=['Observed_value'], inplace=True)


df["Timestamp2"] = df["Year"].map(str) + "-" + df["Month"].map(str)+ "-" + df["Day"].map(str)  
df["Timestamp"] = df["Timestamp2"].map(str)+ " " + df["Hour"].map(str)+":"+df["Minute"].map(str) 
#join offset to sttaion id for tiemstamp conversion
df.drop(columns=["Timestamp2"])
df= df[["Source_ID",'Station_ID',"Station_name","Alias_station_name",  
                                 "Year","Month","Day","Hour","Minute",
                                "Latitude","Longitude","Elevation","Observed_value",
                                "Source_QC_flag","Original_observed_value",
                                "Original_observed_value_units",                                
                                "Report_type_code","Measurement_code_1",
                                "Measurement_code_2", "Timestamp"]]
#df['Original_observed_value']= round(df['Original_observed_value'],2)
#df['Observed_value']= round(df['Observed_value'])
os.chdir("D:/ACRE_ROB_Dropbox/Solomon Islands/out/slp")
df.to_csv("340-00001_station_level_presssure_16.csv", index=False, sep=",")

#############################
df.dtypes
##
