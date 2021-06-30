#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Jul 17 14:22:41 2019

@author: snoone
"""
import os
import pandas as pd
import numpy as np



os.chdir("D:/African _stations_late19thC_338")

df=pd.read_excel("Porto-Novo1899-1900.xlsx",skiprows = 1,sheet_name="data") 
#df2=pd.read_excel("1953.xlsx",sheet_name="j9") 
df["Source_ID"]="338"
df["Station_ID"]="338-00003"
df["Alias_station_name"]="Null"
df["Station_name"]="Porto-Novo (Benin)"
df["Latitude"]= "6.49"
df["Longitude"]= "2.62"
df["Elevation"]= "20"
#split the (GMT)  timestampinto columns 
df['Year'] = df['Date'].dt.year 
df['Month'] = df['Date'].dt.month 
df['Day'] = df['Date'].dt.day 
df['Hour'] = df['Date'].dt.hour 
df['Minute'] = df['Date'].dt.minute
df = df.astype({"Year": int})
df = df.astype({"Month": int})
df = df.astype({"Day": int})
df = df.astype({"Hour": int})
df ["Year"]=df["Year"].replace(to_replace=1999,value=1899)
df = df.drop(columns="Date")
df["Hour"]="21"
df["Minute"]= "00"
df["Alias_station_name"]=df["Alias_station_name"]
df["Source_QC_flag"]=""
df['Original_observed_value_units']="perc"
df['Measurement_code_1']=''
df['Measurement_code_2']=''
df['Report_type_code']=''
df["Observed_value"]=df["21h.3"]
df['Original_observed_value']=df["21h.3"]
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

#df['Observed_value']=df["Observed_value"]* 1.33322
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
df['Observed_value']= round(df['Observed_value'])
os.chdir("D:/African _stations_late19thC_338/338/RH/3")
df.to_csv("338-00003_rh_21h.csv", index=False, sep=",")

#############################

##
