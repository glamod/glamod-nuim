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
from numpy import nan

pd.options.mode.chained_assignment = None  # default='warn'

OUTDIR = ""
os.chdir("C:/Users/snoone/Dropbox/Hungarian_hourly/hourly/recent/test")
extension = 'csv'
all_filenames = [i for i in glob.glob('*.{}'.format(extension))]
for filename in all_filenames:
    df = pd.read_csv(filename,  sep=';',skiprows = 4, skipinitialspace = True)

    
    
    df["Source_ID"]="370"
    df["Station_ID"]=df["StationNumber"]
    df["Alias_station_name"]=""
    df["Observed_value"]=df["p"]
    df["Source_QC_flag"]=""
    df['Original_observed_value']=""
    df['Original_observed_value_units']="Hpa"
    df['Report_type_code']='0'
    df['Measurement_code_1']=''
    df['Measurement_code_2']=''
    df["Date"]=df["Time"].map(str) 
    df['Year'] = df['Date'].map(lambda x: x[0:4])
    df['Month'] = df['Date'].map(lambda x: x[4:6])
    df['Day'] = df['Date'].map(lambda x: x[6:8])
    df['Hour'] = df['Date'].map(lambda x: x[8:11])
    df["Hour"] = df["Hour"].astype(int)/10
    df["Minute"]="0"
    df['Hour'] = df['Hour'].astype(float).astype(int)
    df["Timestamp2"] = df["Year"].map(str) + "-" + df["Month"].map(str)+ "-" + df["Day"].map(str)  
    df["Timestamp"] = df["Timestamp2"].map(str)+ " " + df["Hour"].map(str)+":"+df["Minute"].map(str)
    df.drop(columns=["Timestamp2"])
    
    #split the (GMT)  timestampinto columns
    
    df['Timestamp'] =  pd.to_datetime(df['Timestamp'], format='%Y-%m-%d' " ""%H:%M:%S")
    df['Timestamp'] = df['Timestamp'].dt.tz_localize('Etc/GMT-2').dt.tz_convert('GMT')
    df['Year'] = df['Timestamp'].dt.year 
    df['Month'] = df['Timestamp'].dt.month 
    df['Day'] = df['Timestamp'].dt.day 
    df['Hour'] = df['Timestamp'].dt.hour 
    df['Minute'] = df['Timestamp'].dt.minute
    df['Seconds'] = df['Timestamp'].dt.second
    

    
    df2=pd.read_csv("D:/Hungarian_hourly/stations.csv")
    df2 = df2.astype(str) 
    df= df.astype(str)
    df_merged = df.merge(df2, on=['Station_ID'])
    df_merged['Hour'] = df_merged['Hour'].astype(float).astype(int)
   ## set_up_template for all variables
    df_temp = df_merged.copy()
    
    df_slp= df_merged[["Source_ID",'Station_ID',"Station_name","Alias_station_name",  
                                 "Year","Month","Day","Hour","Minute",
                                "Latitude","Longitude","Elevation","Observed_value",
                                "Source_QC_flag","Original_observed_value",
                                "Original_observed_value_units",                                
                                "Report_type_code","Measurement_code_1",
                                "Measurement_code_2"]]
    
    df_slp['Hour'] = df_merged['Hour'].astype(float).astype(int)
    #df_slp.drop(df_slp.index[df_slp['Observed_value'] == '-999'], inplace=True)
    #df["Observed_value"] = pd.to_numeric(df["Observed_value"],errors='coerce')
    #df["Observed_value"]= df["Observed_value"].round(2)
    ##write out each .csv with station ID+ variable+sourceID in name
    id=df_slp['Station_ID'].iloc[0]
    id2 = str(id)
    outname = os.path.join("C:/Users/snoone/Dropbox/Hungarian_hourly/hourly/historical/slp", id2)
    df_slp.to_csv(outname+"_station_level_pressure_370b.psv", index=False, sep="|")
       
    # extract mslp from df_temp
    del df_temp["Observed_value"]
    df_temp["Observed_value"]=df_temp["p0"] 
    df_temp['Original_observed_value_units']="Hpa"
    
    df_mslp= df_temp[["Source_ID",'Station_ID',"Station_name","Alias_station_name",  
                                 "Year","Month","Day","Hour","Minute",
                                "Latitude","Longitude","Elevation","Observed_value",
                                "Source_QC_flag","Original_observed_value",
                                "Original_observed_value_units",                                
                                "Report_type_code","Measurement_code_1",
                                "Measurement_code_2"]]
    #df_mslp.drop(df_mslp.index[df_mslp['Observed_value'] == '-999'], inplace=True)
    id=df_mslp['Station_ID'].iloc[0]
    id2 = str(id)
    outname = os.path.join("C:/Users/snoone/Dropbox/Hungarian_hourly/hourly/historical/mslp", id2)
    df_mslp.to_csv(outname+"_sea_level_pressure_370b.psv", index=False, sep="|")
    
    # extract temperature from df_temp
    del df_temp["Observed_value"]
    df_temp["Observed_value"]=df_temp["t"]
    df_temp['Original_observed_value_units']="C"
    
    df_t= df_temp[["Source_ID",'Station_ID',"Station_name","Alias_station_name",  
                                 "Year","Month","Day","Hour","Minute",
                                "Latitude","Longitude","Elevation","Observed_value",
                                "Source_QC_flag","Original_observed_value",
                                "Original_observed_value_units",                                
                                "Report_type_code","Measurement_code_1",
                                "Measurement_code_2"]]
   # df_t.drop(df_t.index[df_t['Observed_value'] == '-999'], inplace=True)
    id=df_t['Station_ID'].iloc[0]
    id2 = str(id)
    outname = os.path.join("C:/Users/snoone/Dropbox/Hungarian_hourly/hourly/historical/temp", id2)
    df_t.to_csv(outname+"_temperature_370b.psv", index=False, sep="|")
    
    # extract precip from df_temp
    del df_temp["Observed_value"]
    df_temp["Observed_value"]=df_temp["r"] 
    df_temp['Original_observed_value_units']="mm"
    
    df_precip= df_temp[["Source_ID",'Station_ID',"Station_name","Alias_station_name",  
                                 "Year","Month","Day","Hour","Minute",
                                "Latitude","Longitude","Elevation","Observed_value",
                                "Source_QC_flag","Original_observed_value",
                                "Original_observed_value_units",                                
                                "Report_type_code","Measurement_code_1",
                                "Measurement_code_2"]]
   # df_precip.drop(df_precip.index[df_precip['Observed_value'] == '-999'], inplace=True)
    id=df_precip['Station_ID'].iloc[0]
    id2 = str(id)
    outname = os.path.join("C:/Users/snoone/Dropbox/Hungarian_hourly/hourly/historical/precip", id2)
    df_precip.to_csv(outname+"_precipitation_370b.psv", index=False, sep="|")
    
    # extract Rh from df_temp
    del df_temp["Observed_value"]
    df_temp["Observed_value"]=df_temp["u"] 
    df_temp['Original_observed_value_units']="%"
    
    df_rh= df_temp[["Source_ID",'Station_ID',"Station_name","Alias_station_name",  
                                 "Year","Month","Day","Hour","Minute",
                                "Latitude","Longitude","Elevation","Observed_value",
                                "Source_QC_flag","Original_observed_value",
                                "Original_observed_value_units",                                
                                "Report_type_code","Measurement_code_1",
                                "Measurement_code_2"]]
    #df_rh.drop(df_rh.index[df_rh['Observed_value'] == '-999'], inplace=True)
    id=df_rh['Station_ID'].iloc[0]
    id2 = str(id)
    outname = os.path.join("C:/Users/snoone/Dropbox/Hungarian_hourly/hourly/historical/RH", id2)
    df_rh.to_csv(outname+"_relative_humidity_370b.psv", index=False, sep="|")
    
     # extract wind_Speed from df_temp
    del df_temp["Observed_value"]
    df_temp["Observed_value"]=df_temp["f"] 
    df_temp['Original_observed_value_units']="m/s"
    
    df_ws= df_temp[["Source_ID",'Station_ID',"Station_name","Alias_station_name",  
                                 "Year","Month","Day","Hour","Minute",
                                "Latitude","Longitude","Elevation","Observed_value",
                                "Source_QC_flag","Original_observed_value",
                                "Original_observed_value_units",                                
                                "Report_type_code","Measurement_code_1",
                                "Measurement_code_2"]]
    #df_ws.drop(df_ws.index[df_ws['Observed_value'] == '-999'], inplace=True)
    id=df_ws['Station_ID'].iloc[0]
    id2 = str(id)
    outname = os.path.join("C:/Users/snoone/Dropbox/Hungarian_hourly/hourly/historical/ws", id2)
    df_ws.to_csv(outname+"_wind_speed_370b.psv", index=False, sep="|")
    
    # extract wind_Direction from df_temp
    del df_temp["Observed_value"]
    df_temp["Observed_value"]=df_temp["fd"] 
    df_temp['Original_observed_value_units']="deg"
    
    df_wd= df_temp[["Source_ID",'Station_ID',"Station_name","Alias_station_name",  
                                 "Year","Month","Day","Hour","Minute",
                                "Latitude","Longitude","Elevation","Observed_value",
                                "Source_QC_flag","Original_observed_value",
                                "Original_observed_value_units",                                
                                "Report_type_code","Measurement_code_1",
                                "Measurement_code_2"]]
   # df_wd.drop(df_wd.index[df_wd['Observed_value'] == '-999'], inplace=True)
    id=df_wd['Station_ID'].iloc[0]
    id2 = str(id)
    outname = os.path.join("C:/Users/snoone/Dropbox/Hungarian_hourly/hourly/historical/wd", id2)
    df_wd.to_csv(outname+"_wind_direction_370b.psv", index=False, sep="|")
    
    # extract visibility from df_temp
    del df_temp["Observed_value"]
    df_temp["Observed_value"]=df_temp["v"] 
    df_temp['Original_observed_value_units']="m"
    
    df_vis= df_temp[["Source_ID",'Station_ID',"Station_name","Alias_station_name",  
                                 "Year","Month","Day","Hour","Minute",
                                "Latitude","Longitude","Elevation","Observed_value",
                                "Source_QC_flag","Original_observed_value",
                                "Original_observed_value_units",                                
                                "Report_type_code","Measurement_code_1",
                                "Measurement_code_2"]]
    #df_vis.drop(df_vis.index[df_vis['Observed_value'] == '-999'], inplace=True)
    id=df_vis['Station_ID'].iloc[0]
    id2 = str(id)
    outname = os.path.join("C:/Users/snoone/Dropbox/Hungarian_hourly/hourly/historical/vis", id2)
    df_vis.to_csv(outname+"_visibilty_370b.psv", index=False, sep="|")
           
           
