#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Jul 17 14:22:41 2019

@author: snoone
"""
import os
import glob
import pandas as pd

def remove_non_ascii(text): 
        return ''.join(i for i in text if ord(i)<128)

OUTDIR = "D:/brazil_inmet/DataA_all_years_IFF/wind_direction/"
os.chdir("D:/brazil_inmet/DataA/odd/2019")
extension = 'csv'
all_filenames = [i for i in glob.glob('*{}'.format(extension))]
for filename in all_filenames:
    df = pd.read_csv(filename, delimiter=';',skiprows = 8,decimal=',',engine='python')
    ##get sttaion_ID from header
    df1=pd.read_csv(filename,sep=';', squeeze=True, nrows = 7,decimal=',',engine='python')
    df2=df1.iloc[:,0:2]
    df2 = df2.replace({"CODIGO (WMO):":"ID",})
    df2.to_csv("D:/brazil_inmet/inventory/header.csv",index=False)
    ##bad names hedaers odd 2021/19/20
  
    #f3 = pd.read_csv("D:/brazil_inmet/inventory/header.csv",index_col="REGIAO:",squeeze=True)#odd
    df3 = pd.read_csv("D:/brazil_inmet/inventory/header.csv",index_col="REGI?O:",squeeze=True)#2019
    #df3 = pd.read_csv("D:/brazil_inmet/inventory/header.csv",index_col="REGIÃO:",squeeze=True)
    station_id=df3.ID
    
    #df3 = pd.read_csv("header.csv",index_col="REGIÃO:",squeeze=True)
    df["Station_ID"]=station_id
    df["Source_ID"]="342"
    df["Alias_station_name"]=""
    df['Minute'] = "0"
    df["Source_QC_flag"]=""
    df["Original_observed_value_units"] = "Deg"
    df['Report_type_code'] = ""
    df['Measurement_code_1'] = ""
    df['Measurement_code_2'] = ""
   #df[['Year',"Month", "Day"]] = df['DATA (YYYY-MM-DD)'].str.split('-',expand=True)
    df[['Year',"Month", "Day"]] = df['Data'].str.split('/',expand=True)#odd
    #df[["Hour","zeros"]] = df["HORA (UTC)"].str.split(':',expand=True)
    df[['Hour',"zeros"]] = df['Hora UTC'].str.split(' ',expand=True)#2019 odd
    #df['Hour'] = df['HORA (UTC)']
    df["Original_observed_value"] = df["VENTO, DIREÇÃO HORARIA (gr) (° (gr))"]
    df["Observed_value"] = df["VENTO, DIREÇÃO HORARIA (gr) (° (gr))"]
    df = df.astype({"Hour": int})
    df["Hour"]=df["Hour"]/100 #odd and 2019
    #df["Hour"]=df["Hour"]
    df = df[df.Observed_value != -999]
    df.dropna(subset = ["Observed_value"], inplace=True)
    
    df2=pd.read_csv("D:/brazil_inmet/inventory/elevation.csv")
    result = pd.merge(df, df2, on=['Station_ID','Station_ID'])
    result['Station_ID2'] = result['Station_ID']
    result['Elevation'] = result['Elev']
    result['Latitude'] = result["Lat"].round(3)
    result["Longitude"] = result["Long"].round(3)
    result["Elevation"] = result["Elevation"].round(1)
    result['Station_name'] = result['Name']
    result['Station_name'] = result['Station_name'].apply(remove_non_ascii)
    del result["Station_ID"]
    result= result.rename(columns=({'Station_ID2':'Station_ID'}))
    df3=result[["Source_ID",'Station_ID',"Station_name","Alias_station_name",  
                                 "Year","Month","Day","Hour","Minute",
                                "Latitude","Longitude","Elevation","Observed_value",
                                "Source_QC_flag","Original_observed_value",
                                "Original_observed_value_units",                                
                                "Report_type_code","Measurement_code_1",
                                "Measurement_code_2"]]
    df3 = df3[df3.Observed_value != -9999]
    df3.dropna(subset = ["Observed_value"], inplace=True)
    df3 = df3.astype({"Hour": int})
    #df3["Hour"]=df3["Hour"]/100


   
   
    outname = os.path.join(OUTDIR, filename)
    #with open(filename, "w") as outfile:
    df3.to_csv(outname+"_wind_direction_342.psv", index=False, sep="|")
   
