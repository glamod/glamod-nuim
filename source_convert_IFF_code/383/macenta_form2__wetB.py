# -*- coding: utf-8 -*-
"""
Created on Thu Jan 26 12:17:19 2023

@author: snoone
"""

import os   
import glob
import pandas as pd
import csv
OUTDIR = "C:/Users/snoone/Dropbox/OLD_BELGIAN_AFRICAN_DARE_INVENTORY/Kevin_folder_african_inv/checked_forms_clidar_2022/Macenta_Form_2/wetB"
os.chdir("C:/Users/snoone/Dropbox/OLD_BELGIAN_AFRICAN_DARE_INVENTORY/Kevin_folder_african_inv/checked_forms_clidar_2022/Macenta_Form_2/")
extension = 'xlsx'
all_filenames = [i for i in glob.glob('*.{}'.format(extension))]


for filename in all_filenames:
    try:
        df = pd.read_excel(filename,skiprows=6, header=None)
        df.columns = ["Day", "min_t", "max_t", "mean_t","dbt_7","wbt_7","diff_7","Hstate_7","dbt_12","wbt_12","diff_12","Hstate_12","dbt_17","wbt_17","diff_17","Hstate_17","cld_7","cld_12","cld_17"]
    #df=df.drop(columns =["8","9","10","11","12","13"])
   
        df1=pd.read_excel(filename,nrows=0)
        df1 = df1.T.reset_index().T.reset_index(drop=True)
        df1.columns =  ["1", "Station_name", "2", "3","4","Month","6","Year","8","9","10","11","12","13","14","15","16","17","18"]
        df1=df1.drop(columns =["1",  "2", "3","4","6","8","9","10","11","12","13","14","15","16","17","18"])
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
        df['Original_observed_value_units']="c"
        df['Report_type_code']=''
        df['Measurement_code_1']=''
        df['Measurement_code_2']='' 
        df2 = pd.read_csv("header.csv",squeeze=True)
        df2 = df2.astype(str)
        df= df2.merge(df, on=['Station_name'])
        df["Minute"]="00"  
        df = df.replace('nt','0', regex=True)
        df = df.replace('NT','0', regex=True)
        n = 3
        df["Station_name"]="Macenta"
## D ropping last n rows using dro
        df.drop(df.tail(n).index,
        inplace = True)
        df=df.dropna(subset = ['wbt_7'])
    except:
         continue
    
##extract daily tmin 
    try:
        df_wbt=df
        df_wbt=df_wbt.drop(columns =["max_t", "mean_t","min_t","Hstate_7","dbt_12","dbt_7","wbt_12","diff_12","Hstate_12","dbt_17","wbt_17","diff_17","Hstate_17","cld_7","cld_12","cld_17"])
        df_wbt["Hour"]="7" 
        df_wbt= df_wbt.rename(columns=({"wbt_7":'Observed_value'}))
        df_wbt["Original_observed_value"]=df_wbt["Observed_value"]
        df_wbt["Observed_value"] = pd.to_numeric(df_wbt["Observed_value"],errors='coerce')
        #df_wbt["Observed_value"]=df_wbt["Observed_value"]

        df_wbt = df_wbt[["Source_ID",'Station_ID',"Station_name","Alias_station_name",  
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
        df_wbt2=df
        df_wbt2=df_wbt2.drop(columns =["min_t", "mean_t","max_t","dbt_7","dbt_12","wbt_7","diff_7","Hstate_7","diff_12","Hstate_12","dbt_17","wbt_17","diff_17","Hstate_17","cld_7","cld_12","cld_17"])
        df_wbt2["Hour"]="12" 
        df_wbt2= df_wbt2.rename(columns=({"wbt_12":'Observed_value'}))
        df_wbt2["Original_observed_value"]=df_wbt2["Observed_value"]
        df_wbt2["Observed_value"] = pd.to_numeric(df_wbt2["Observed_value"],errors='coerce')
        #df_wbt2["Observed_value"]=df_wbt2["Observed_value"]

        df_wbt2 = df_wbt2[["Source_ID",'Station_ID',"Station_name","Alias_station_name",  
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
        df_wbt3=df
        df_wbt3=df_wbt3.drop(columns =["max_t", "min_t","mean_t","dbt_7","dbt_17","wbt_7","diff_7","Hstate_7","dbt_12","wbt_12","diff_12","Hstate_12","diff_17","Hstate_17","cld_7","cld_12","cld_17"])
        df_wbt3["Hour"]="18" 
        df_wbt3= df_wbt3.rename(columns=({'wbt_17':'Observed_value'}))
        df_wbt3["Original_observed_value"]=df_wbt3["Observed_value"]
        df_wbt3["Observed_value"] = pd.to_numeric(df_wbt3["Observed_value"],errors='coerce')
        #df_wbt3["Observed_value"]=df_wbt3["Observed_value"]

        df_wbt3 = df_wbt3[["Source_ID",'Station_ID',"Station_name","Alias_station_name",  
                                 "Year","Month","Day","Hour","Minute",
                                "Latitude","Longitude","Elevation","Observed_value",
                                "Source_QC_flag","Original_observed_value",
                                "Original_observed_value_units",                                
                                "Report_type_code","Measurement_code_1",
                                "Measurement_code_2"]]
  
        
        merged_wbt=pd.concat([df_wbt,df_wbt2,df_wbt3], axis=0)
        merged_wbt=merged_wbt.dropna(subset = ['Observed_value'])
        
            #change time zones
        merged_wbt["Timestamp2"] = merged_wbt["Year"].map(str) + "-" + merged_wbt["Month"].map(str)+ "-" + merged_wbt["Day"].map(str)  
        merged_wbt["Timestamp"] = merged_wbt["Timestamp2"].map(str)+ " " + merged_wbt["Hour"].map(str)+":"+merged_wbt["Minute"].map(str)
        merged_wbt= merged_wbt.drop(columns=["Timestamp2"])
    
        merged_wbt['Timestamp'] =  pd.to_datetime(merged_wbt['Timestamp'], format='%Y-%m-%d' " ""%H:%M:%S")
        merged_wbt['Timestamp'] = merged_wbt['Timestamp'].dt.tz_localize('Etc/GMT-0').dt.tz_convert('GMT')
        merged_wbt['Year'] = merged_wbt['Timestamp'].dt.year 
        merged_wbt['Month'] = merged_wbt['Timestamp'].dt.month  
        merged_wbt['Day'] = merged_wbt['Timestamp'].dt.day 
        merged_wbt['Hour'] = merged_wbt['Timestamp'].dt.hour 
        merged_wbt['Minute'] = merged_wbt['Timestamp'].dt.minute
        merged_wbt['Seconds'] = merged_wbt['Timestamp'].dt.second
        

    
##delete unwanted columns 
        merged_wbt = merged_wbt.drop(columns="Timestamp")
        merged_wbt['Minute']='00'
        merged_wbt = merged_wbt.astype(str)
        merged_wbt = merged_wbt[["Source_ID",'Station_ID',"Station_name","Alias_station_name",  
                                 "Year","Month","Day","Hour","Minute",
                                "Latitude","Longitude","Elevation","Observed_value",
                                "Source_QC_flag","Original_observed_value",
                                "Original_observed_value_units",                                
                                "Report_type_code","Measurement_code_1",
                                "Measurement_code_2"]]
    

#save output file   
        
        year=merged_wbt.iloc[1]["Year"]
        month=merged_wbt.iloc[1]["Month"]
        date=(year+"_"+month)
        source_id=merged_wbt.iloc[1]["Source_ID"]
        cdm_type=(date+"_wet_bulb_temperature_"+source_id)
     
        a = merged_wbt['Station_ID'].unique()
        print (a)
        outname = os.path.join(OUTDIR,cdm_type)
    #with open(filename, "w") as outfile:
        merged_wbt.to_csv(outname+".psv", index=False, sep="|")
    except:
         continue
    
    
    
