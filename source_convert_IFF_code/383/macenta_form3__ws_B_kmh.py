# -*- coding: utf-8 -*-
"""
Created on Thu Jan 26 12:17:19 2023

@author: snoone
"""

import os   
import glob
import pandas as pd
import csv
OUTDIR = "C:/Users/snoone/Dropbox/OLD_BELGIAN_AFRICAN_DARE_INVENTORY/Kevin_folder_african_inv/checked_forms_clidar_2022/Macenta_Form_3/Macenta_Form_3/ws"
os.chdir("C:/Users/snoone/Dropbox/OLD_BELGIAN_AFRICAN_DARE_INVENTORY/Kevin_folder_african_inv/checked_forms_clidar_2022/Macenta_Form_3/Macenta_Form_3/B")
extension = 'xlsx'
all_filenames = [i for i in glob.glob('*.{}'.format(extension))]


for filename in all_filenames:
    try:
        df = pd.read_excel(filename,skiprows=6, header=None)
        df.columns = ["Day", "min_t", "max_t", "30_t","60_t","p_7","p_12","p_17","wd_7","ws_7","wd_12","ws_12","wd_17","ws_17","rem"]
    #df=df.drop(columns =["8","9","10","11","12","13"])
   
        df1=pd.read_excel(filename,nrows=0)
        df1 = df1.T.reset_index().T.reset_index(drop=True)
        df1.columns =  ["1", "Station_name", "2", "3","4","Month","6","Year","8","9","10","11","12","13","14"]
        df1=df1.drop(columns =["1",  "2", "3","4","6","8","9","10","11","12","13","14"])
        df1.to_csv("header.csv",index=False)
        df["Source_ID"] = "383"
        df["Station_ID"]="383-00002"
        df["Station_name"]="Macenta"
        df["Alias_station_name"]=""
        df["Latitude"]="8.533"
        df["Longitude"]="-9.467"
        df["Elevation"]="544"
        df["Source_QC_flag"]=""
        df["Original_observed_value"]=""
        df['Original_observed_value_units']="KMH"
        df['Report_type_code']=''
        df['Measurement_code_1']=''
        df['Measurement_code_2']='' 
        df2 = pd.read_csv("header.csv",squeeze=True)
        df2 = df2.astype(str)
        df= df2.merge(df, on=['Station_name'])
        df["Minute"]="00"  
        df = df.replace('nt','0', regex=True)
        df = df.replace('NT','0', regex=True)
        df = df.replace('NE','0', regex=True)
        n =3
        df["Station_name"]="Macenta"
## D ropping last n rows using dro
        df.drop(df.tail(n).index,
        inplace = True)
    except:
         continue
    
##extract daily tmin 
    try:
        df_ws=df
        df_ws=df_ws.drop(columns =["min_t", "max_t", "30_t","60_t","p_12","p_17","wd_7","p_7","wd_12","ws_12","wd_17","ws_17","rem"])
        df_ws["Hour"]="8" 
        df_ws= df_ws.rename(columns=({"ws_7":'Observed_value'}))
        df_ws["Original_observed_value"]=df_ws["Observed_value"]
        df_ws["Observed_value"] = pd.to_numeric(df_ws["Observed_value"],errors='coerce')
         # Convert Observed_value from KMH to M/S
        df_ws["Observed_value"] = df_ws["Observed_value"] * (1000 / 3600)
        df_ws = df_ws[["Source_ID",'Station_ID',"Station_name","Alias_station_name",  
                                 "Year","Month","Day","Hour","Minute",
                                "Latitude","Longitude","Elevation","Observed_value",
                                "Source_QC_flag","Original_observed_value",
                                "Original_observed_value_units",                                
                                "Report_type_code","Measurement_code_1",
                                "Measurement_code_2"]]
    except:
         continue
    
##extract daily tmax taken 
    try:
        df_ws2=df
        df_ws2=df_ws2.drop(columns =[ "min_t","max_t","30_t","60_t","p_7","p_17","wd_7","ws_7","wd_12","p_12","wd_17","ws_17","rem"])
        df_ws2["Hour"]="12" 
        df_ws2= df_ws2.rename(columns=({"ws_12":'Observed_value'}))
        df_ws2["Original_observed_value"]=df_ws2["Observed_value"]
        df_ws2["Observed_value"] = pd.to_numeric(df_ws2["Observed_value"],errors='coerce')
        # Convert Observed_value from KMH to M/S
        df_ws2["Observed_value"] = df_ws2["Observed_value"] * (1000 / 3600)
        df_ws2 = df_ws2[["Source_ID",'Station_ID',"Station_name","Alias_station_name",  
                                 "Year","Month","Day","Hour","Minute",
                                "Latitude","Longitude","Elevation","Observed_value",
                                "Source_QC_flag","Original_observed_value",
                                "Original_observed_value_units",                                
                                "Report_type_code","Measurement_code_1",
                                "Measurement_code_2"]]
    
    except:
         continue
     
        ##extract daily tmean taken 
    try:
        df_ws3=df
        df_ws3=df_ws3.drop(columns =[ "min_t", "max_t", "30_t","60_t","p_7","p_12","wd_7","ws_7","wd_12","ws_12","wd_17","p_17","rem"])
        df_ws3["Hour"]="18" 
        df_ws3= df_ws3.rename(columns=({"ws_17":'Observed_value'}))
        df_ws3["Original_observed_value"]=df_ws3["Observed_value"]
        df_ws3["Observed_value"] = pd.to_numeric(df_ws3["Observed_value"],errors='coerce')
        # Convert Observed_value from KMH to M/S
        df_ws3["Observed_value"] = df_ws3["Observed_value"] * (1000 / 3600)
        df_ws3 = df_ws3[["Source_ID",'Station_ID',"Station_name","Alias_station_name",  
                                 "Year","Month","Day","Hour","Minute",
                                "Latitude","Longitude","Elevation","Observed_value",
                                "Source_QC_flag","Original_observed_value",
                                "Original_observed_value_units",                                
                                "Report_type_code","Measurement_code_1",
                                "Measurement_code_2"]]

    
       
        merged_ws=pd.concat([df_ws,df_ws2,df_ws3], axis=0)
        merged_ws=merged_ws.dropna(subset = ['Observed_value'])

  
    #change time zones
        merged_ws["Timestamp2"] = merged_ws["Year"].map(str) + "-" + merged_ws["Month"].map(str)+ "-" + merged_ws["Day"].map(str)  
        merged_ws["Timestamp"] = merged_ws["Timestamp2"].map(str)+ " " + merged_ws["Hour"].map(str)+":"+merged_ws["Minute"].map(str)
        merged_ws= merged_ws.drop(columns=["Timestamp2"])
    
        merged_ws['Timestamp'] =  pd.to_datetime(merged_ws['Timestamp'], format='%Y-%m-%d' " ""%H:%M:%S")
        merged_ws['Timestamp'] = merged_ws['Timestamp'].dt.tz_localize('Etc/GMT-0').dt.tz_convert('GMT')
        merged_ws['Year'] = merged_ws['Timestamp'].dt.year 
        merged_ws['Month'] = merged_ws['Timestamp'].dt.month  
        merged_ws['Day'] = merged_ws['Timestamp'].dt.day 
        merged_ws['Hour'] = merged_ws['Timestamp'].dt.hour 
        merged_ws['Minute'] = merged_ws['Timestamp'].dt.minute
        merged_ws['Seconds'] = merged_ws['Timestamp'].dt.second
        
        merged_ws = merged_ws.drop(columns="Timestamp")
        merged_ws['Minute']='00'
        merged_ws = merged_ws.astype(str)
        merged_ws = merged_ws[["Source_ID",'Station_ID',"Station_name","Alias_station_name",  
                                 "Year","Month","Day","Hour","Minute",
                                "Latitude","Longitude","Elevation","Observed_value",
                                "Source_QC_flag","Original_observed_value",
                                "Original_observed_value_units",                                
                                "Report_type_code","Measurement_code_1",
                                "Measurement_code_2"]]
        
        # Rounding the observed values to 1 decimal place
        merged_ws["Observed_value"] = pd.to_numeric(merged_ws["Observed_value"], errors='coerce')
        merged_ws["Observed_value"] = merged_ws["Observed_value"].round(2)
        
        merged_ws["Original_observed_value"] = pd.to_numeric(merged_ws["Original_observed_value"], errors='coerce')
        merged_ws["Original_observed_value"] = merged_ws["Original_observed_value"].round(2)
        merged_ws.loc[merged_ws["Observed_value"] == 0, "Measurement_code_1"] = "C"
    

#save output file   
        year=merged_ws.iloc[1]["Year"]
        month=merged_ws.iloc[1]["Month"]
        date=(year+"_"+month)
        source_id=merged_ws.iloc[1]["Source_ID"]
        cdm_type=(date+"_wind_speed_"+source_id)
     
        a = merged_ws['Station_ID'].unique()
        print (a)
        outname = os.path.join(OUTDIR,cdm_type)
    #with open(filename, "w") as outfile:
        merged_ws.to_csv(outname+".psv", index=False, sep="|")
    except:
         continue
    
    
    

