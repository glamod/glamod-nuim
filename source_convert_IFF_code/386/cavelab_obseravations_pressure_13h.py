#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Jul 17 14:22:41 2019

@author: snoone
"""
import os
import pandas as pd
import numpy as np



os.chdir("D:/Cavelab_data")

##extract pressure 8am
df=pd.read_excel("Congo-Eala(1908-1952).xlsx",skiprows = 3,sheet_name="QC",header=None)
df.columns = ["Date", "pres_8", "height_8", "barom_8","pres_13", "height_13", "barom_13","pres_18", "height_18", "barom_18","maxtemp_8","mintemp_8",
              "maxtemp_13","mintemp_13","maxtemp_18","mintemp_18"]
df2=df
#df=df.drop(columns =["8","9","10","11","12","13"]) 
#df2=pd.read_excel("1953.xlsx",sheet_name="j9") 
df["Source_ID"]="386"
df["Station_ID"]="386-00001"
df["Alias_station_name"]="Null"
df["Station_name"]="Eala"
df["Latitude"]= "0.06666"
df["Longitude"]= "18.2833"
df["Elevation"]= ""
#split the (GMT)  timestampinto columns 
df['Year'] = df['Date'].dt.year 
df['Month'] = df['Date'].dt.month 
df['Day'] = df['Date'].dt.day 
df['Hour'] = df['Date'].dt.hour 
df['Minute'] = df['Date'].dt.minute 
df = df.drop(columns="Date")
df["Hour"]="13"
df["Minute"]= "00"
df["Alias_station_name"]=df["Alias_station_name"]
df["Source_QC_flag"]=""
df['Original_observed_value_units']="hpa"
df['Measurement_code_1']=''
df['Measurement_code_2']=''
df['Report_type_code']=''
df["Observed_value"]=df["pres_13"]
df['Original_observed_value']=df["pres_13"]
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

df['Observed_value']=df["Observed_value"]+900
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
df['Original_observed_value']= round(df['Original_observed_value'],2)
df['Observed_value']= round(df['Observed_value'],1)
os.chdir("D:/Cavelab_data/slp/1")
df.to_csv("386-00001_station_level_pressure_13h.csv", index=False, sep=",")

#############################
df=df2
df["Source_ID"]="386"
df["Station_ID"]="386-00001"
df["Alias_station_name"]="Null"
df["Station_name"]="Eala"
df["Latitude"]= "0.06666"
df["Longitude"]= "18.2833"
df["Elevation"]= ""
#split the (GMT)  timestampinto columns 
df['Year'] = df['Date'].dt.year 
df['Month'] = df['Date'].dt.month 
df['Day'] = df['Date'].dt.day 
df['Hour'] = df['Date'].dt.hour 
df['Minute'] = df['Date'].dt.minute 
df = df.drop(columns="Date")
df["Hour"]="8"
df["Minute"]= "00"
df["Alias_station_name"]=df["Alias_station_name"]
df["Source_QC_flag"]=""
df['Original_observed_value_units']="c"
df['Measurement_code_1']=''
df['Measurement_code_2']=''
df['Report_type_code']=''
df["Observed_value"]=df["maxtemp_13"]
df['Original_observed_value']=df["maxtemp_13"]
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
df["Timestamp2"] = df["Year"].map(str) + "-" + df["Month"].map(str)+ "-" + df["Day"].map(str)  
df["Timestamp"] = df["Timestamp2"].map(str)+ " " + df["Hour"].map(str)+":"+df["Minute"].map(str)
df= df.drop(columns=["Timestamp2"])

df['Timestamp'] =  pd.to_datetime(df['Timestamp'], format='%Y-%m-%d' " ""%H:%M:%S")
df['Timestamp'] = df['Timestamp'].dt.tz_localize('Etc/GMT-1').dt.tz_convert('GMT')
df['Year'] = df['Timestamp'].dt.year 
df['Month'] = df['Timestamp'].dt.month  
df['Day'] = df['Timestamp'].dt.day 
df['Hour'] = df['Timestamp'].dt.hour 
df['Minute'] = df['Timestamp'].dt.minute
df['Seconds'] = df['Timestamp'].dt.second

##delete unwanted columns 
df = df.drop(columns="Timestamp")
df['Minute']='00'
df= df[["Source_ID",'Station_ID',"Station_name","Alias_station_name",  
                                 "Year","Month","Day","Hour","Minute",
                                "Latitude","Longitude","Elevation","Observed_value",
                                "Source_QC_flag","Original_observed_value",
                                "Original_observed_value_units",                                
                                "Report_type_code","Measurement_code_1",
                                "Measurement_code_2"]]
df['Original_observed_value']= round(df['Original_observed_value'],2)
df['Observed_value']= round(df['Observed_value'],1)
os.chdir("D:/Cavelab_data/temp/mx")
df.to_csv("386-00001_maximum_temperature_13h.csv", index=False, sep=",")

#####################################
df=df2
df["Source_ID"]="386"
df["Station_ID"]="386-00001"
df["Alias_station_name"]="Null"
df["Station_name"]="Eala"
df["Latitude"]= "0.06666"
df["Longitude"]= "18.2833"
df["Elevation"]= ""
#split the (GMT)  timestampinto columns 
df['Year'] = df['Date'].dt.year 
df['Month'] = df['Date'].dt.month 
df['Day'] = df['Date'].dt.day 
df['Hour'] = df['Date'].dt.hour 
df['Minute'] = df['Date'].dt.minute 
df = df.drop(columns="Date")
df["Hour"]="8"
df["Minute"]= "00"
df["Alias_station_name"]=df["Alias_station_name"]
df["Source_QC_flag"]=""
df['Original_observed_value_units']="c"
df['Measurement_code_1']=''
df['Measurement_code_2']=''
df['Report_type_code']=''
df["Observed_value"]=df["mintemp_13"]
df['Original_observed_value']=df["mintemp_13"]
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
df["Timestamp2"] = df["Year"].map(str) + "-" + df["Month"].map(str)+ "-" + df["Day"].map(str)  
df["Timestamp"] = df["Timestamp2"].map(str)+ " " + df["Hour"].map(str)+":"+df["Minute"].map(str)
df= df.drop(columns=["Timestamp2"])

df['Timestamp'] =  pd.to_datetime(df['Timestamp'], format='%Y-%m-%d' " ""%H:%M:%S")
df['Timestamp'] = df['Timestamp'].dt.tz_localize('Etc/GMT-1').dt.tz_convert('GMT')
df['Year'] = df['Timestamp'].dt.year 
df['Month'] = df['Timestamp'].dt.month  
df['Day'] = df['Timestamp'].dt.day 
df['Hour'] = df['Timestamp'].dt.hour 
df['Minute'] = df['Timestamp'].dt.minute
df['Seconds'] = df['Timestamp'].dt.second

##delete unwanted columns 
df = df.drop(columns="Timestamp")
df['Minute']='00'
df= df[["Source_ID",'Station_ID',"Station_name","Alias_station_name",  
                                 "Year","Month","Day","Hour","Minute",
                                "Latitude","Longitude","Elevation","Observed_value",
                                "Source_QC_flag","Original_observed_value",
                                "Original_observed_value_units",                                
                                "Report_type_code","Measurement_code_1",
                                "Measurement_code_2"]]
df['Original_observed_value']= round(df['Original_observed_value'],2)
df['Observed_value']= round(df['Observed_value'],1)
os.chdir("D:/Cavelab_data/temp/mn")
df.to_csv("386-00001_minimum_temperature_13h.csv", index=False, sep=",")


