#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Jul 17 14:22:41 2019

@author: snoone
"""
import os
import pandas as pd




os.chdir("D:/Adelaide_obseravations_1876_97_sbdy")

df=pd.read_excel("Observations_Adelaide_1876_1897.xlsx",skiprows = 3,sheet_name="data") 
#df2=pd.read_excel("1953.xlsx",sheet_name="j9") 
df["Source_ID"]="324"
df["Station_ID"]="adelaide"
df["Alias_station_name"]="Null"
df["Station_name"]="adelaide"
df["Latitude"]= "-34.92"
df["Longitude"]= "138.59"
df["Elevation"]= "42"
df ["Year"]=df["Unnamed: 0"]
df["Month"]=df["Unnamed: 1"]
df["Day"]=df["Unnamed: 2"]
df["Hour"]="21"
df["Minute"]= "00"
df["Alias_station_name"]=df["Alias_station_name"]
df["Source_QC_flag"]="Null"
df['Original_observed_value_units']="InHg"
df['Gravity_corrected_by_source']='Yes'
df['Homogenization_corrected_by_source']='Null'
df['Report_type_code']='Null'
df["Observed_value"]=df["9 p.m..1"]
df['Original_observed_value']=df["9 p.m..1"]
df = df.fillna(0)
##df.drop(df.tail(4).index,inplace=True)
df = df.astype({"Year": int})
df = df.astype({"Month": int})
df = df.astype({"Day": int})
df = df.astype({"Hour": int})
#df = df.astype({"Observed_value": int})
df.dtypes

df['Observed_value']=df["Observed_value"]* 33.86389
df["Timestamp2"] = df["Year"].map(str) + "-" + df["Month"].map(str)+ "-" + df["Day"].map(str)  
df["Timestamp"] = df["Timestamp2"].map(str)+ " " + df["Hour"].map(str)+":"+df["Minute"].map(str) 
#join offset to sttaion id for tiemstamp conversion
df.drop(columns=["Timestamp2"])
df= df[["Source_ID",'Station_ID',"Station_name","Alias_station_name",  
                                 "Year","Month","Day","Hour","Minute",
                                "Latitude","Longitude","Elevation","Observed_value",
                                "Source_QC_flag","Original_observed_value",
                                "Original_observed_value_units",                                
                                "Report_type_code","Gravity_corrected_by_source",
                                "Homogenization_corrected_by_source", "Timestamp"]]
df['Original_observed_value']= round(df['Original_observed_value'],2)
df['Observed_value']= round(df['Observed_value'],1)
os.chdir("D:/Adelaide_obseravations_1876_97_sbdy")
df.to_csv("Adelaide_pressure_21.csv", index=False, sep=",")

#############################

