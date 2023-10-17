 # -*- coding: utf-8 -*-
"""
Created on Thu Jan 26 12:17:19 2023

@author: snoone
"""

import os   
import glob
import pandas as pd
import csv
OUTDIR = "C:/Users/snoone/Dropbox/OLD_BELGIAN_AFRICAN_DARE_INVENTORY/Kevin_folder_african_inv/checked_forms_clidar_2022/ANDAPA_Form_2/ANDAPA_Form_2/rh"
os.chdir("C:/Users/snoone/Dropbox/OLD_BELGIAN_AFRICAN_DARE_INVENTORY/Kevin_folder_african_inv/checked_forms_clidar_2022/ANDAPA_Form_2/ANDAPA_Form_2/")
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
        df["Station_ID"]="383-00001"
        df["Station_name"]="Andapa"
        df["Alias_station_name"]=""
        df["Latitude"]="-14.39"
        df["Longitude"]="49.37"
        df["Elevation"]="470"
        df["Source_QC_flag"]=""
        df["Original_observed_value"]=""
        df['Original_observed_value_units']="%"
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
## D ropping last n rows using dro
        df.drop(df.tail(n).index,
        inplace = True)
        df=df.dropna(subset = ['Hstate_7'])
    except:
         continue
    
##extract daily tmin 
    try:
        df_rh=df
        df_rh=df_rh.drop(columns =["max_t", "wbt_7","mean_t","min_t","dbt_12","dbt_7","wbt_12","diff_12","Hstate_12","dbt_17","wbt_17","diff_17","Hstate_17","cld_7","cld_12","cld_17"])
        df_rh["Hour"]="6" 
        df_rh= df_rh.rename(columns=({"Hstate_7":'Observed_value'}))
        df_rh["Original_observed_value"]=df_rh["Observed_value"]
        df_rh["Observed_value"] = pd.to_numeric(df_rh["Observed_value"],errors='coerce')
        #df_rh["Observed_value"]=df_rh["Observed_value"]/10

        df_rh = df_rh[["Source_ID",'Station_ID',"Station_name","Alias_station_name",  
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
        df_rh2=df
        df_rh2=df_rh2.drop(columns =["min_t","wbt_12", "mean_t","max_t","dbt_7","dbt_12","wbt_7","diff_7","Hstate_7","diff_12","dbt_17","wbt_17","diff_17","Hstate_17","cld_7","cld_12","cld_17"])
        df_rh2["Hour"]="12" 
        df_rh2= df_rh2.rename(columns=({"Hstate_12":'Observed_value'}))
        df_rh2["Original_observed_value"]=df_rh2["Observed_value"]
        df_rh2["Observed_value"] = pd.to_numeric(df_rh2["Observed_value"],errors='coerce')
        #df_rh2["Observed_value"]=df_rh2["Observed_value"]/10

        df_rh2 = df_rh2[["Source_ID",'Station_ID',"Station_name","Alias_station_name",  
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
        df_rh3=df
        df_rh3=df_rh3.drop(columns =["max_t", "min_t","wbt_17","mean_t","dbt_7","dbt_17","wbt_7","diff_7","Hstate_7","dbt_12","wbt_12","diff_12","Hstate_12","diff_17","cld_7","cld_12","cld_17"])
        df_rh3["Hour"]="18" 
        df_rh3= df_rh3.rename(columns=({'Hstate_17':'Observed_value'}))
        df_rh3["Original_observed_value"]=df_rh3["Observed_value"]
        df_rh3["Observed_value"] = pd.to_numeric(df_rh3["Observed_value"],errors='coerce')
        #df_rh3["Observed_value"]=df_rh3["Observed_value"]/10

        df_rh3 = df_rh3[["Source_ID",'Station_ID',"Station_name","Alias_station_name",  
                                 "Year","Month","Day","Hour","Minute",
                                "Latitude","Longitude","Elevation","Observed_value",
                                "Source_QC_flag","Original_observed_value",
                                "Original_observed_value_units",                                
                                "Report_type_code","Measurement_code_1",
                                "Measurement_code_2"]]

    
       
        merged_rh=pd.concat([df_rh,df_rh2,df_rh3], axis=0)
        merged_rh=merged_rh.dropna(subset = ['Observed_value'])
        merged_rh=merged_rh.dropna(subset = ['Observed_value'])
  
    #change time zones
        merged_rh["Timestamp2"] = merged_rh["Year"].map(str) + "-" + merged_rh["Month"].map(str)+ "-" + merged_rh["Day"].map(str)  
        merged_rh["Timestamp"] = merged_rh["Timestamp2"].map(str)+ " " + merged_rh["Hour"].map(str)+":"+merged_rh["Minute"].map(str)
        merged_rh= merged_rh.drop(columns=["Timestamp2"])
    
        merged_rh['Timestamp'] =  pd.to_datetime(merged_rh['Timestamp'], format='%Y-%m-%d' " ""%H:%M:%S")
        merged_rh['Timestamp'] = merged_rh['Timestamp'].dt.tz_localize('Etc/GMT-3').dt.tz_convert('GMT')
        merged_rh['Year'] = merged_rh['Timestamp'].dt.year 
        merged_rh['Month'] = merged_rh['Timestamp'].dt.month  
        merged_rh['Day'] = merged_rh['Timestamp'].dt.day 
        merged_rh['Hour'] = merged_rh['Timestamp'].dt.hour 
        merged_rh['Minute'] = merged_rh['Timestamp'].dt.minute
        merged_rh['Seconds'] = merged_rh['Timestamp'].dt.second
        
        merged_rh = merged_rh.drop(columns="Timestamp")
        merged_rh['Minute']='00'
        merged_rh = merged_rh.astype(str)
        merged_rh = merged_rh[["Source_ID",'Station_ID',"Station_name","Alias_station_name",  
                                 "Year","Month","Day","Hour","Minute",
                                "Latitude","Longitude","Elevation","Observed_value",
                                "Source_QC_flag","Original_observed_value",
                                "Original_observed_value_units",                                
                                "Report_type_code","Measurement_code_1",
                                "Measurement_code_2"]]
        #remove decimals
        merged_rh['Observed_value'] = merged_rh['Observed_value'].astype(str).apply(lambda x: x.replace('.0',''))
        merged_rh['Original_observed_value'] = merged_rh['Original_observed_value'].astype(str).apply(lambda x: x.replace('.0',''))

#save output file   
        year=merged_rh.iloc[1]["Year"]
        month=merged_rh.iloc[1]["Month"]
        date=(year+"_"+month)
        source_id=merged_rh.iloc[1]["Source_ID"]
        cdm_type=(date+"_relative_humidity_"+source_id)
     
        a = merged_rh['Station_ID'].unique()
        print (a)
        outname = os.path.join(OUTDIR,cdm_type)
    #with open(filename, "w") as outfile:
        merged_rh.to_csv(outname+".psv", index=False, sep="|")
    except:
         continue
    
    
    
