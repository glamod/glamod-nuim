#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Jul 17 14:22:41 2019

@author: snoone
"""
import os
import pandas as pd
import numpy as np



os.chdir("D:/Metoe_lux")

df=pd.read_csv("06590_LuxFindel_Hourly_EU_Copernicus_20110101_20201031_v1.csv") 
#df2=pd.read_excel("1953.xlsx",sheet_name="j9") 
df["Source_ID"]="339"
df["Station_ID"]="06590"
df["Alias_station_name"]="Null"
df["Station_name"]="Luxembourg"
df["Latitude"]= "49.6261"
df["Longitude"]= "6.20347"
df["Elevation"]= "376.1"
#split the (GMT)  timestampinto columns 
df['Year'] = df['Year']
df['Month'] = df['Month']
df['Day'] = df['Day']
df['Hour'] = df['Hour']
df['Minute'] = df['Minute']

#df ["Year"]=df["Year"].replace(to_replace=1999,value=1899)
#df = df.drop(columns="Date")
#df["Hour"]="21"
df["Minute"]= "45"
df["Alias_station_name"]=df["Alias_station_name"]
df["Source_QC_flag"]=""
df['Original_observed_value_units']="C"
df['Measurement_code_1']="T1"
df['Measurement_code_2']=''
df['Report_type_code']=''
df["Observed_value"]=df["HT_SY"]
df['Original_observed_value']=df["HT_SY"]
#df.loc[df['21h.4'] == 'Calme', 'Observed_value'] = 0
#df.loc[df['HDD_SY'] == '0', 'Measurement_code_1'] = "WD1"
#df.loc[df['21h.4'] == 'Calme', 'Original_observed_value'] = 0
#df.loc[df['Direccion 14h '] == 'Calme', 'Original_observed_value'] = 0
#df.fillna("NULL",inplace=True)
#df = df.fillna()
##df.drop(df.tail(4).index,inplace=True)
df = df.astype({"Year": int})
df = df.astype({"Month": int})
df = df.astype({"Day": int})
df = df.astype({"Hour": int})

#remove rows with  o obervaed values
df['Observed_value'].replace('', np.nan, inplace=True)
df.dropna(subset=['Observed_value'], inplace=True)

#df['Observed_value']=df["Observed_value"]* 0.514444


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
#df['Original_observed_value']= round(df['Original_observed_value'],1)
#df['Observed_value']= round(df['Observed_value'],2)

os.chdir("D:/Metoe_lux/339/tt")
df.to_csv("06590_temperature_339.psv", index=False, sep="|")

#############################

##
