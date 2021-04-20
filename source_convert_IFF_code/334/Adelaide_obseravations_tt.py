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
df ["Year"]=df["Year"]
df["Month"]=df["Month"]
df["Day"]=df["Day"]
df["Hour"]="21"
df["Minute"]= "00"
df["Alias_station_name"]=df["Alias_station_name"]
df["Source_QC_flag"]="Null"
df['Original_observed_value_units']="F"
df['Gravity_corrected_by_source']='Null'
df['Homogenization_corrected_by_source']='Null'
df['Report_type_code']='Null'
df["Observed_value"]=df["Wet Bulb 9 p.m."]
df['Original_observed_value']=df["Wet Bulb 9 p.m."]
df = df.fillna(-999)

##df.drop(df.tail(4).index,inplace=True)
df = df.astype({"Year": int})
df = df.astype({"Month": int})
df = df.astype({"Day": int})
df = df.astype({"Hour": int})
#df = df.astype({"Observed_value": int})
df.dtypes
df["Observed_value"]= df["Observed_value"]-32
df["Observed_value"]= df["Observed_value"]*5
df["Observed_value"]= df["Observed_value"]/9

#df = df.astype({"Observed_value": int})
#df = df.astype({"Original_observed_value": int})
df['Observed_value']= round(df['Observed_value'],1)
df[['Observed_value']] = df[['Observed_value']].replace([-572.8], ["Null"])
df[['Original_observed_value']] = df[['Original_observed_value']].replace([-999], ["Null"])

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
df = df[df.Observed_value != "Null"]
#df['Original_observed_value']= round(df['Original_observed_value'],1)


os.chdir("D:/Adelaide_obseravations_1876_97_sbdy/wet_bulb_temperature")
df.to_csv("Adelaide_wet_bulb_temp_21.csv", index=False, sep=",")

#############################

