# -*- coding: utf-8 -*-
"""
Created on Thu Jan 26 12:17:19 2023

@author: snoone
"""

import os   
import glob
import pandas as pd
import csv
OUTDIR = "C:/Users/snoone/Dropbox/OLD_BELGIAN_AFRICAN_DARE_INVENTORY/Kevin_folder_african_inv/checked_forms_clidar_2022/ANDAPA_Form_2/ANDAPA_Form_2/cld"
os.chdir("C:/Users/snoone/Dropbox/OLD_BELGIAN_AFRICAN_DARE_INVENTORY/Kevin_folder_african_inv/checked_forms_clidar_2022/ANDAPA_Form_2/ANDAPA_Form_2/1958")
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
        df['Original_observed_value_units']="octas"
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
        n =4
## D ropping last n rows using dro
        df.drop(df.tail(n).index,
        inplace = True)
        df=df.dropna(subset = ['cld_7'])
    except:
         continue
    
##extract daily tmin 
    try:
        df_cl=df
        df_cl=df_cl.drop(columns =["max_t", "wbt_7","Hstate_7","mean_t","min_t","dbt_12","dbt_7","wbt_12","diff_12","Hstate_12","dbt_17","wbt_17","diff_17","Hstate_17","cld_12","cld_17"])
        df_cl["Hour"]="7" 
        df_cl= df_cl.rename(columns=({"cld_7":'Observed_value'}))
        df_cl["Original_observed_value"]=df_cl["Observed_value"]
        df_cl["Observed_value"] = pd.to_numeric(df_cl["Observed_value"],errors='coerce')
        #df_cl["Observed_value"]=df_cl["Observed_value"]/10

        df_cl = df_cl[["Source_ID",'Station_ID',"Station_name","Alias_station_name",  
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
        df_cl2=df
        df_cl2=df_cl2.drop(columns =["min_t","wbt_12", "mean_t","max_t","dbt_7","Hstate_12","dbt_12","wbt_7","diff_7","Hstate_7","diff_12","dbt_17","wbt_17","diff_17","Hstate_17","cld_7","cld_17"])
        df_cl2["Hour"]="12" 
        df_cl2= df_cl2.rename(columns=({"cld_12":'Observed_value'}))
        df_cl2["Original_observed_value"]=df_cl2["Observed_value"]
        df_cl2["Observed_value"] = pd.to_numeric(df_cl2["Observed_value"],errors='coerce')
        #df_cl2["Observed_value"]=df_cl2["Observed_value"]/10

        df_cl2 = df_cl2[["Source_ID",'Station_ID',"Station_name","Alias_station_name",  
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
        df_cl3=df
        df_cl3=df_cl3.drop(columns =["max_t", "min_t","wbt_17","Hstate_17","mean_t","dbt_7","dbt_17","wbt_7","diff_7","Hstate_7","dbt_12","wbt_12","diff_12","Hstate_12","diff_17","cld_7","cld_12",])
        df_cl3["Hour"]="18" 
        df_cl3= df_cl3.rename(columns=({"cld_17":'Observed_value'}))
        df_cl3["Original_observed_value"]=df_cl3["Observed_value"]
        df_cl3["Observed_value"] = pd.to_numeric(df_cl3["Observed_value"],errors='coerce')
        #df_cl3["Observed_value"]=df_cl3["Observed_value"]/10

        df_cl3 = df_cl3[["Source_ID",'Station_ID',"Station_name","Alias_station_name",  
                                 "Year","Month","Day","Hour","Minute",
                                "Latitude","Longitude","Elevation","Observed_value",
                                "Source_QC_flag","Original_observed_value",
                                "Original_observed_value_units",                                
                                "Report_type_code","Measurement_code_1",
                                "Measurement_code_2"]]

    
       
        merged_cl=pd.concat([df_cl,df_cl2,df_cl3], axis=0)
        merged_cl=merged_cl.dropna(subset = ['Observed_value'])
        merged_cl=merged_cl.dropna(subset = ['Observed_value'])
  
    #change time zones
        merged_cl["Timestamp2"] = merged_cl["Year"].map(str) + "-" + merged_cl["Month"].map(str)+ "-" + merged_cl["Day"].map(str)  
        merged_cl["Timestamp"] = merged_cl["Timestamp2"].map(str)+ " " + merged_cl["Hour"].map(str)+":"+merged_cl["Minute"].map(str)
        merged_cl= merged_cl.drop(columns=["Timestamp2"])
    
        merged_cl['Timestamp'] =  pd.to_datetime(merged_cl['Timestamp'], format='%Y-%m-%d' " ""%H:%M:%S")
        merged_cl['Timestamp'] = merged_cl['Timestamp'].dt.tz_localize('Etc/GMT-3').dt.tz_convert('GMT')
        merged_cl['Year'] = merged_cl['Timestamp'].dt.year 
        merged_cl['Month'] = merged_cl['Timestamp'].dt.month  
        merged_cl['Day'] = merged_cl['Timestamp'].dt.day 
        merged_cl['Hour'] = merged_cl['Timestamp'].dt.hour 
        merged_cl['Minute'] = merged_cl['Timestamp'].dt.minute
        merged_cl['Seconds'] = merged_cl['Timestamp'].dt.second
        
        merged_cl = merged_cl.drop(columns="Timestamp")
        merged_cl['Minute']='00'
        merged_cl = merged_cl.astype(str)
        merged_cl = merged_cl[["Source_ID",'Station_ID',"Station_name","Alias_station_name",  
                                 "Year","Month","Day","Hour","Minute",
                                "Latitude","Longitude","Elevation","Observed_value",
                                "Source_QC_flag","Original_observed_value",
                                "Original_observed_value_units",                                
                                "Report_type_code","Measurement_code_1",
                                "Measurement_code_2"]]
        merged_cl['Observed_value'] = merged_cl['Observed_value'].astype(str).apply(lambda x: x.replace('.0',''))
        merged_cl['Original_observed_value'] = merged_cl['Original_observed_value'].astype(str).apply(lambda x: x.replace('.0',''))
    

#save output file   
        year=merged_cl.iloc[1]["Year"]
        month=merged_cl.iloc[1]["Month"]
        date=(year+"_"+month)
        source_id=merged_cl.iloc[1]["Source_ID"]
        cdm_type=(date+"_cloud_cover_"+source_id)
     
        a = merged_cl['Station_ID'].unique()
        print (a)
        outname = os.path.join(OUTDIR,cdm_type)
    #with open(filename, "w") as outfile:
        merged_cl.to_csv(outname+".psv", index=False, sep="|")
    except:
         continue
    
    
    


