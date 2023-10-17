# -*- coding: utf-8 -*-
"""
Created on Thu Jan 26 12:17:19 2023

@author: snoone
"""

import os   
import glob
import pandas as pd
import csv
OUTDIR = "C:/Users/snoone/Dropbox/OLD_BELGIAN_AFRICAN_DARE_INVENTORY/Kevin_folder_african_inv/checked_forms_clidar_2022/Macenta_Form_3/Macenta_Form_3/slp"
os.chdir("C:/Users/snoone/Dropbox/OLD_BELGIAN_AFRICAN_DARE_INVENTORY/Kevin_folder_african_inv/checked_forms_clidar_2022/Macenta_Form_3/Macenta_Form_3/B/")
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
        df['Original_observed_value_units']="hpa"
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
        df_slp=df
        df_slp=df_slp.drop(columns =["min_t", "max_t", "30_t","60_t","p_12","p_17","wd_7","ws_7","wd_12","ws_12","wd_17","ws_17","rem"])
        df_slp["Hour"]="8" 
        df_slp= df_slp.rename(columns=({"p_7":'Observed_value'}))
        df_slp["Original_observed_value"]=df_slp["Observed_value"]
        df_slp["Observed_value"] = pd.to_numeric(df_slp["Observed_value"],errors='coerce')
        #df_slp["Observed_value"]=df_slp["Observed_value"]/10

        df_slp = df_slp[["Source_ID",'Station_ID',"Station_name","Alias_station_name",  
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
        df_slp2=df
        df_slp2=df_slp2.drop(columns =[ "min_t","max_t","30_t","60_t","p_7","p_17","wd_7","ws_7","wd_12","ws_12","wd_17","ws_17","rem"])
        df_slp2["Hour"]="13" 
        df_slp2= df_slp2.rename(columns=({"p_12":'Observed_value'}))
        df_slp2["Original_observed_value"]=df_slp2["Observed_value"]
        df_slp2["Observed_value"] = pd.to_numeric(df_slp2["Observed_value"],errors='coerce')
        #df_slp2["Observed_value"]=df_slp2["Observed_value"]/10

        df_slp2 = df_slp2[["Source_ID",'Station_ID',"Station_name","Alias_station_name",  
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
        df_slp3=df
        df_slp3=df_slp3.drop(columns =[ "min_t", "max_t", "30_t","60_t","p_7","p_12","wd_7","ws_7","wd_12","ws_12","wd_17","ws_17","rem"])
        df_slp3["Hour"]="18" 
        df_slp3= df_slp3.rename(columns=({"p_17":'Observed_value'}))
        df_slp3["Original_observed_value"]=df_slp3["Observed_value"]
        df_slp3["Observed_value"] = pd.to_numeric(df_slp3["Observed_value"],errors='coerce')
        #df_slp3["Observed_value"]=df_slp3["Observed_value"]/10

        df_slp3 = df_slp3[["Source_ID",'Station_ID',"Station_name","Alias_station_name",  
                                 "Year","Month","Day","Hour","Minute",
                                "Latitude","Longitude","Elevation","Observed_value",
                                "Source_QC_flag","Original_observed_value",
                                "Original_observed_value_units",                                
                                "Report_type_code","Measurement_code_1",
                                "Measurement_code_2"]]

    
       
        merged_slp=pd.concat([df_slp,df_slp2,df_slp3], axis=0)
        merged_slp=merged_slp.dropna(subset = ['Observed_value'])

  
    #change time zones
        merged_slp["Timestamp2"] = merged_slp["Year"].map(str) + "-" + merged_slp["Month"].map(str)+ "-" + merged_slp["Day"].map(str)  
        merged_slp["Timestamp"] = merged_slp["Timestamp2"].map(str)+ " " + merged_slp["Hour"].map(str)+":"+merged_slp["Minute"].map(str)
        merged_slp= merged_slp.drop(columns=["Timestamp2"])
    
        merged_slp['Timestamp'] =  pd.to_datetime(merged_slp['Timestamp'], format='%Y-%m-%d' " ""%H:%M:%S")
        merged_slp['Timestamp'] = merged_slp['Timestamp'].dt.tz_localize('Etc/GMT-0').dt.tz_convert('GMT')
        merged_slp['Year'] = merged_slp['Timestamp'].dt.year 
        merged_slp['Month'] = merged_slp['Timestamp'].dt.month  
        merged_slp['Day'] = merged_slp['Timestamp'].dt.day 
        merged_slp['Hour'] = merged_slp['Timestamp'].dt.hour 
        merged_slp['Minute'] = merged_slp['Timestamp'].dt.minute
        merged_slp['Seconds'] = merged_slp['Timestamp'].dt.second
        
        merged_slp = merged_slp.drop(columns="Timestamp")
        merged_slp['Minute']='00'
        merged_slp = merged_slp.astype(str)
        merged_slp = merged_slp[["Source_ID",'Station_ID',"Station_name","Alias_station_name",  
                                 "Year","Month","Day","Hour","Minute",
                                "Latitude","Longitude","Elevation","Observed_value",
                                "Source_QC_flag","Original_observed_value",
                                "Original_observed_value_units",                                
                                "Report_type_code","Measurement_code_1",
                                "Measurement_code_2"]]
    

#save output file   
        year=merged_slp.iloc[1]["Year"]
        month=merged_slp.iloc[1]["Month"]
        date=(year+"_"+month)
        source_id=merged_slp.iloc[1]["Source_ID"]
        cdm_type=(date+"_station_level_pressure_"+source_id)
     
        a = merged_slp['Station_ID'].unique()
        print (a)
        outname = os.path.join(OUTDIR,cdm_type)
    #with open(filename, "w") as outfile:
        merged_slp.to_csv(outname+".psv", index=False, sep="|")
    except:
         continue
    
    
    
