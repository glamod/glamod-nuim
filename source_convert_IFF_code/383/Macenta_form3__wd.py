# -*- coding: utf-8 -*-
"""
Created on Thu Jan 26 12:17:19 2023

@author: snoone
"""

import os   
import glob
import pandas as pd
import csv
OUTDIR = "C:/Users/snoone/Dropbox/OLD_BELGIAN_AFRICAN_DARE_INVENTORY/Kevin_folder_african_inv/checked_forms_clidar_2022/Macenta_Form_3/Macenta_Form_3/wd"
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
        df['Original_observed_value_units']="Cardinal"
        df['Report_type_code']=''
        df['Measurement_code_1']=''
        df['Measurement_code_2']='' 
        df2 = pd.read_csv("header.csv",squeeze=True)
        df2 = df2.astype(str)
        df= df2.merge(df, on=['Station_name'])
        df["Minute"]="00"  
        #df = df.replace('nt','0', regex=True)
        #df = df.replace('NT','0', regex=True)
        #df = df.replace('NE','0', regex=True)
        n =3
        df["Station_name"]="Macenta"
   
## D ropping last n rowd using dro
        df.drop(df.tail(n).index,
        inplace = True)
    except:
         continue
    
##extract daily tmin 
    try:
        df_wd=df
        df_wd=df_wd.drop(columns =["min_t", "max_t", "30_t","60_t","p_7","p_12","p_17","ws_7","wd_12","ws_12","wd_17","ws_17","rem"])
        df_wd["Hour"]="7" 
        df_wd= df_wd.rename(columns=({"wd_7":'Observed_value'}))
        df_wd["Original_observed_value"]=df_wd["Observed_value"]
        #df_wd["Observed_value"] = pd.to_numeric(df_wd["Observed_value"],errors='coerce')
        #df_wd["Observed_value"]=df_wd["Observed_value"]/10

        df_wd = df_wd[["Source_ID",'Station_ID',"Station_name","Alias_station_name",  
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
        df_wd2=df
        df_wd2=df_wd2.drop(columns =["min_t", "max_t", "30_t","60_t","p_7","p_12","p_17","wd_7","ws_7","ws_12","wd_17","ws_17","rem"])
        df_wd2["Hour"]="12" 
        df_wd2= df_wd2.rename(columns=({"wd_12":'Observed_value'}))
        df_wd2["Original_observed_value"]=df_wd2["Observed_value"]
        #df_wd2["Observed_value"] = pd.to_numeric(df_wd2["Observed_value"],errors='coerce')
        #df_wd2["Observed_value"]=df_wd2["Observed_value"]/10

        df_wd2 = df_wd2[["Source_ID",'Station_ID',"Station_name","Alias_station_name",  
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
        df_wd3=df
        df_wd3=df_wd3.drop(columns =[ "min_t", "max_t", "30_t","60_t","p_7","p_12","p_17","wd_7","ws_7","wd_12","ws_12","ws_17","rem"])
        df_wd3["Hour"]="17" 
        df_wd3= df_wd3.rename(columns=({"wd_17":'Observed_value'}))
        df_wd3["Original_observed_value"]=df_wd3["Observed_value"]
        #df_wd3["Observed_value"] = pd.to_numeric(df_wd3["Observed_value"],errors='coerce')
        #df_wd3["Observed_value"]=df_wd3["Observed_value"]/10

        df_wd3 = df_wd3[["Source_ID",'Station_ID',"Station_name","Alias_station_name",  
                                 "Year","Month","Day","Hour","Minute",
                                "Latitude","Longitude","Elevation","Observed_value",
                                "Source_QC_flag","Original_observed_value",
                                "Original_observed_value_units",                                
                                "Report_type_code","Measurement_code_1",
                                "Measurement_code_2"]]

    
       
        merged_wd=pd.concat([df_wd,df_wd2,df_wd3], axis=0)
        merged_wd=merged_wd.dropna(subset = ['Observed_value'])

  
    #change time zones
        merged_wd["Timestamp2"] = merged_wd["Year"].map(str) + "-" + merged_wd["Month"].map(str)+ "-" + merged_wd["Day"].map(str)  
        merged_wd["Timestamp"] = merged_wd["Timestamp2"].map(str)+ " " + merged_wd["Hour"].map(str)+":"+merged_wd["Minute"].map(str)
        merged_wd= merged_wd.drop(columns=["Timestamp2"])
    
        merged_wd['Timestamp'] =  pd.to_datetime(merged_wd['Timestamp'], format='%Y-%m-%d' " ""%H:%M:%S")
        merged_wd['Timestamp'] = merged_wd['Timestamp'].dt.tz_localize('Etc/GMT-0').dt.tz_convert('GMT')
        merged_wd['Year'] = merged_wd['Timestamp'].dt.year 
        merged_wd['Month'] = merged_wd['Timestamp'].dt.month  
        merged_wd['Day'] = merged_wd['Timestamp'].dt.day 
        merged_wd['Hour'] = merged_wd['Timestamp'].dt.hour 
        merged_wd['Minute'] = merged_wd['Timestamp'].dt.minute
        merged_wd['Seconds'] = merged_wd['Timestamp'].dt.second
        
        merged_wd = merged_wd.drop(columns="Timestamp")
        merged_wd['Minute']='00'
        merged_wd = merged_wd.astype(str)
        merged_wd = merged_wd[["Source_ID",'Station_ID',"Station_name","Alias_station_name",  
                                 "Year","Month","Day","Hour","Minute",
                                "Latitude","Longitude","Elevation","Observed_value",
                                "Source_QC_flag","Original_observed_value",
                                "Original_observed_value_units",                                
                                "Report_type_code","Measurement_code_1",
                                "Measurement_code_2"]]
        merged_wd ["Observed_value"]=merged_wd["Observed_value"].replace(to_replace="N",value="0")
        merged_wd ["Observed_value"]=merged_wd["Observed_value"].replace(to_replace="NT",value="0")
        merged_wd ["Observed_value"]=merged_wd["Observed_value"].replace(to_replace="NN",value="0")
        merged_wd ["Observed_value"]=merged_wd["Observed_value"].replace(to_replace="n",value="0")
        merged_wd ["Observed_value"]=merged_wd["Observed_value"].replace(to_replace="NNE",value="22.5")
        merged_wd ["Observed_value"]=merged_wd["Observed_value"].replace(to_replace="NE",value="45")
        merged_wd ["Observed_value"]=merged_wd["Observed_value"].replace(to_replace="ENE",value="67.5")
        merged_wd ["Observed_value"]=merged_wd["Observed_value"].replace(to_replace="E",value="90")
        merged_wd ["Observed_value"]=merged_wd["Observed_value"].replace(to_replace="ESE",value="112")
        merged_wd ["Observed_value"]=merged_wd["Observed_value"].replace(to_replace="SE",value="135")
        merged_wd ["Observed_value"]=merged_wd["Observed_value"].replace(to_replace="SSE",value="157.5")
        merged_wd ["Observed_value"]=merged_wd["Observed_value"].replace(to_replace="S",value="180")
        merged_wd ["Observed_value"]=merged_wd["Observed_value"].replace(to_replace="SSW",value="202.5")
        merged_wd ["Observed_value"]=merged_wd["Observed_value"].replace(to_replace="SW",value="225")
        merged_wd ["Observed_value"]=merged_wd["Observed_value"].replace(to_replace="WSW",value="247.5")
        merged_wd ["Observed_value"]=merged_wd["Observed_value"].replace(to_replace="W",value="270")
        merged_wd ["Observed_value"]=merged_wd["Observed_value"].replace(to_replace="w",value="270")
        merged_wd ["Observed_value"]=merged_wd["Observed_value"].replace(to_replace="e",value="270")
        merged_wd ["Observed_value"]=merged_wd["Observed_value"].replace(to_replace="WE",value="270")
        merged_wd ["Observed_value"]=merged_wd["Observed_value"].replace(to_replace="WNW",value="292.5")
        merged_wd ["Observed_value"]=merged_wd["Observed_value"].replace(to_replace="NW",value="315")
        merged_wd ["Observed_value"]=merged_wd["Observed_value"].replace(to_replace="NNW",value="337.5")
        merged_wd ["Observed_value"]=merged_wd["Observed_value"].replace(to_replace="Calme",value="")
        merged_wd ["Observed_value"]=merged_wd["Observed_value"].replace(to_replace="cal ",value="")
        merged_wd ["Observed_value"]=merged_wd["Observed_value"].replace(to_replace="Cal",value="")
        merged_wd ["Observed_value"]=merged_wd["Observed_value"].replace(to_replace="cal",value="")
        merged_wd ["Observed_value"]=merged_wd["Observed_value"].replace(to_replace="CAL",value="")
        merged_wd ["Observed_value"]=merged_wd["Observed_value"].replace(to_replace="east",value="90")
        merged_wd ["Observed_value"]=merged_wd["Observed_value"].replace(to_replace="E ",value="90")
        merged_wd ["Observed_value"]=merged_wd["Observed_value"].replace(to_replace="se",value="135")
        merged_wd ["Observed_value"]=merged_wd["Observed_value"].replace(to_replace="ne",value="45")
        merged_wd ["Observed_value"]=merged_wd["Observed_value"].replace(to_replace="sw",value="225")
        merged_wd ["Observed_value"]=merged_wd["Observed_value"].replace(to_replace="s",value="180")
        merged_wd ["Observed_value"]=merged_wd["Observed_value"].replace(to_replace="calm",value="")
        merged_wd ["Observed_value"]=merged_wd["Observed_value"].replace(to_replace="calme",value="")
        merged_wd ["Observed_value"]=merged_wd["Observed_value"].replace(to_replace="Calm",value="")
        merged_wd ["Observed_value"]=merged_wd["Observed_value"].replace(to_replace="CALM",value="")
        merged_wd ["Observed_value"]=merged_wd["Observed_value"].replace(to_replace="C",value="")
        merged_wd["Measurement_code_1"]=merged_wd["Original_observed_value"]

        #merged_wd["Observed_value"] = pd.to_numeric(merged_wd["Observed_value"],errors='coerce')
        #merged_wd["Original_observed_value"] = pd.to_numeric(merged_wd["Original_observed_value"],errors='coerce')
        #merged_wd['Observed_value']= round(merged_wd['Observed_value'])
        #merged_wd['Original_observed_value']= round(merged_wd['Original_observed_value'])
    

#save output file   
        year=merged_wd.iloc[1]["Year"]
        month=merged_wd.iloc[1]["Month"]
        date=(year+"_"+month)
        source_id=merged_wd.iloc[1]["Source_ID"]
        cdm_type=(date+"_wind_direction_"+source_id)
     
        a = merged_wd['Station_ID'].unique()
        print (a)
        outname = os.path.join(OUTDIR,cdm_type)
    #with open(filename, "w") as outfile:
        merged_wd.to_csv(outname+".psv", index=False, sep="|")
    except:
         continue
    
    
    

