# -*- coding: utf-8 -*-
"""
Created on Thu Jan 26 12:17:19 2023

@author: snoone
"""

import os   
import glob
import pandas as pd
import csv
OUTDIR4 = "C:/Users/snoone/Dropbox/OLD_BELGIAN_AFRICAN_DARE_INVENTORY/Kevin_folder_african_inv/checked_forms_clidar_2022/Macenta_Form_1/MAcenta_Form_1/dy_evap"
OUTDIR3 = "C:/Users/snoone/Dropbox/OLD_BELGIAN_AFRICAN_DARE_INVENTORY/Kevin_folder_african_inv/checked_forms_clidar_2022/Macenta_Form_1/MAcenta_Form_1/hr_evap"
OUTDIR2 = "C:/Users/snoone/Dropbox/OLD_BELGIAN_AFRICAN_DARE_INVENTORY/Kevin_folder_african_inv/checked_forms_clidar_2022/Macenta_Form_1/MAcenta_Form_1/dy_precip"
OUTDIR = "C:/Users/snoone/Dropbox/OLD_BELGIAN_AFRICAN_DARE_INVENTORY/Kevin_folder_african_inv/checked_forms_clidar_2022/Macenta_Form_1/MAcenta_Form_1/hr_precip"
os.chdir("C:/Users/snoone/Dropbox/OLD_BELGIAN_AFRICAN_DARE_INVENTORY/Kevin_folder_african_inv/checked_forms_clidar_2022/Macenta_Form_1/MAcenta_Form_1/")
extension = 'xlsx'
all_filenames = [i for i in glob.glob('*.{}'.format(extension))]

    
for filename in all_filenames:
    try:
        df = pd.read_excel(filename,skiprows=6, header=None)
        df.columns = ["Day", "precip_17", "precip7", "total_precip","evap_18","evap_7","evap_total","8","9","10","11","12","13"]
        df=df.drop(columns =["8","9","10","11","12","13"])
   
        df1=pd.read_excel(filename,nrows=0)
        df1 = df1.T.reset_index().T.reset_index(drop=True)
        df1.columns =  ["1", "Station_name", "2", "3","4","Month","5","Year","9","10","11","12","13"]
        df1=df1.drop(columns =["1",  "2", "3","4","5","9","10","11","12","13"])
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
        df['Original_observed_value_units']="mm"
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
        n = 3
        df["Station_name"]="Macenta"
 # Dropping last n rows using dro
        df.drop(df.tail(n).index,
        inplace = True)
    except:
       continue
    
    
##extract precipip taken at 1700
    try:
        df_precip17=df
        df_precip17=df_precip17.drop(columns =["precip7","total_precip", "evap_18","evap_7","evap_total"])
        df_precip17["Hour"]="18" 
        df_precip17= df_precip17.rename(columns=({'precip_17':'Observed_value'}))
        df_precip17["Original_observed_value"]=df_precip17["Observed_value"]
        df_precip17["Observed_value"] = pd.to_numeric(df_precip17["Observed_value"],errors='coerce')
        #df_precip17["Observed_value"]=df_precip17["Observed_value"]/10

        df_precip17 = df_precip17[["Source_ID",'Station_ID',"Station_name","Alias_station_name",  
                                 "Year","Month","Day","Hour","Minute",
                                "Latitude","Longitude","Elevation","Observed_value",
                                "Source_QC_flag","Original_observed_value",
                                "Original_observed_value_units",                                
                                "Report_type_code","Measurement_code_1",
                                "Measurement_code_2"]]
        
    ##extract precipip taken at 1700
    
        df_precip7=df
        df_precip7=df_precip7.drop(columns =["precip_17","total_precip", "evap_18","evap_7","evap_total"])
        df_precip7["Hour"]="6" 
        df_precip7= df_precip7.rename(columns=({'precip7':'Observed_value'}))
        df_precip7["Original_observed_value"]=df_precip7["Observed_value"]
        df_precip7["Observed_value"] = pd.to_numeric(df_precip7["Observed_value"],errors='coerce')
        #df_precip7["Observed_value"]=df_precip7["Observed_value"]/10

        df_precip7 = df_precip7[["Source_ID",'Station_ID',"Station_name","Alias_station_name",  
                                 "Year","Month","Day","Hour","Minute",
                                "Latitude","Longitude","Elevation","Observed_value",
                                "Source_QC_flag","Original_observed_value",
                                "Original_observed_value_units",                                
                                "Report_type_code","Measurement_code_1",
                                "Measurement_code_2"]]
        merged_precip=pd.concat([df_precip17,df_precip7], axis=0)
        merged_precip=merged_precip.dropna(subset = ['Observed_value'])
    
    #change time zones
        merged_precip["Timestamp2"] = merged_precip["Year"].map(str) + "-" + merged_precip["Month"].map(str)+ "-" + merged_precip["Day"].map(str)  
        merged_precip["Timestamp"] = merged_precip["Timestamp2"].map(str)+ " " + merged_precip["Hour"].map(str)+":"+merged_precip["Minute"].map(str)
        merged_precip= merged_precip.drop(columns=["Timestamp2"])
    
        merged_precip['Timestamp'] =  pd.to_datetime(merged_precip['Timestamp'], format='%Y-%m-%d' " ""%H:%M:%S")
        merged_precip['Timestamp'] = merged_precip['Timestamp'].dt.tz_localize('Etc/GMT-0').dt.tz_convert('GMT')
        merged_precip['Year'] = merged_precip['Timestamp'].dt.year 
        merged_precip['Month'] = merged_precip['Timestamp'].dt.month  
        merged_precip['Day'] = merged_precip['Timestamp'].dt.day 
        merged_precip['Hour'] = merged_precip['Timestamp'].dt.hour 
        merged_precip['Minute'] = merged_precip['Timestamp'].dt.minute
        merged_precip['Seconds'] = merged_precip['Timestamp'].dt.second
    
##delete unwanted columns 
        merged_precip = merged_precip.drop(columns="Timestamp")
        merged_precip['Minute']='00'
    
        merged_precip = merged_precip[["Source_ID",'Station_ID',"Station_name","Alias_station_name",  
                                 "Year","Month","Day","Hour","Minute",
                                "Latitude","Longitude","Elevation","Observed_value",
                                "Source_QC_flag","Original_observed_value",
                                "Original_observed_value_units",                                
                                "Report_type_code","Measurement_code_1",
                                "Measurement_code_2"]]
        merged_precip = merged_precip.astype(str)
        
    

#save output file   
        year=merged_precip.iloc[0]["Year"]
        month=merged_precip.iloc[0]["Month"]
        date=(year+"_"+month)
        source_id=merged_precip.iloc[0]["Source_ID"]
        cdm_type=(date+"_precipitation_"+source_id)
     
        a = merged_precip['Station_ID'].unique()
        print (a)
        outname = os.path.join(OUTDIR,cdm_type)
      #with open(filename, "w") as outfile:
        merged_precip.to_csv(outname+".psv", index=False, sep="|")
    except:
       continue
        
    
    
   
    #####extrcat  daily totla precip
    try:
        df_precipdy=df
        df_precipdy=df_precipdy.drop(columns =["precip_17","precip7", "evap_18","evap_7","evap_total"])
        df_precipdy["Hour"]="6" 
        df_precipdy= df_precipdy.rename(columns=({'total_precip':'Observed_value'}))
        df_precipdy["Original_observed_value"]=df_precipdy["Observed_value"]
        df_precipdy["Observed_value"] = pd.to_numeric(df_precipdy["Observed_value"],errors='coerce')
        #df_precipdy["Observed_value"]=df_precipdy["Observed_value"]/10

        merged_precip_dy = df_precipdy[["Source_ID",'Station_ID',"Station_name","Alias_station_name",  
                                 "Year","Month","Day","Hour","Minute",
                                "Latitude","Longitude","Elevation","Observed_value",
                                "Source_QC_flag","Original_observed_value",
                                "Original_observed_value_units",                                
                                "Report_type_code","Measurement_code_1",
                                "Measurement_code_2"]]
        merged_precip_dy=merged_precip_dy.dropna(subset = ['Observed_value'])
    
    
    #change time zones
        merged_precip_dy["Timestamp2"] = merged_precip_dy["Year"].map(str) + "-" + merged_precip_dy["Month"].map(str)+ "-" + merged_precip_dy["Day"].map(str)  
        merged_precip_dy["Timestamp"] = merged_precip_dy["Timestamp2"].map(str)+ " " + merged_precip_dy["Hour"].map(str)+":"+merged_precip_dy["Minute"].map(str)
        merged_precip_dy= merged_precip_dy.drop(columns=["Timestamp2"])
    
        merged_precip_dy['Timestamp'] =  pd.to_datetime(merged_precip_dy['Timestamp'], format='%Y-%m-%d' " ""%H:%M:%S")
        merged_precip_dy['Timestamp'] = merged_precip_dy['Timestamp'].dt.tz_localize('Etc/GMT-0').dt.tz_convert('GMT')
        merged_precip_dy['Year'] = merged_precip_dy['Timestamp'].dt.year 
        merged_precip_dy['Month'] = merged_precip_dy['Timestamp'].dt.month  
        merged_precip_dy['Day'] = merged_precip_dy['Timestamp'].dt.day 
        merged_precip_dy['Hour'] = merged_precip_dy['Timestamp'].dt.hour 
        merged_precip_dy['Minute'] = merged_precip_dy['Timestamp'].dt.minute
        merged_precip_dy['Seconds'] = merged_precip_dy['Timestamp'].dt.second
    
##delete unwanted columns 
        merged_precip_dy = merged_precip_dy.drop(columns="Timestamp")
        merged_precip_dy['Minute']='00'
    
        merged_precip_dy = merged_precip_dy[["Source_ID",'Station_ID',"Station_name","Alias_station_name",  
                                 "Year","Month","Day","Hour","Minute",
                                "Latitude","Longitude","Elevation","Observed_value",
                                "Source_QC_flag","Original_observed_value",
                                "Original_observed_value_units",                                
                                "Report_type_code","Measurement_code_1",
                                "Measurement_code_2"]]
        
        merged_precip_dy = merged_precip_dy.astype(str)
    

#save output file   
        year=merged_precip_dy.iloc[0]["Year"]
        month=merged_precip_dy.iloc[0]["Month"]
        date=(year+"_"+month)
        source_id=merged_precip_dy.iloc[0]["Source_ID"]
        cdm_type=(date+"_precipitation_"+source_id)
     
        a = merged_precip_dy['Station_ID'].unique()
        print (a)
        outname = os.path.join(OUTDIR2,cdm_type)
    #with open(filename, "w") as outfile:
        merged_precip_dy.to_csv(outname+".psv", index=False, sep="|")
    except:
         continue
     
     ########################################   
     ##extract evaporation
     #"Day", "precip_17", "precip7", "total_precip","evap_18","evap_7","evap_total",
    try:
        df_evap17=df
        df_evap17=df_evap17.drop(columns =[ "precip_17", "precip7", "total_precip","evap_7","evap_total"])
        df_evap17["Hour"]="18" 
        df_evap17= df_evap17.rename(columns=({'evap_18':'Observed_value'}))
        df_evap17["Original_observed_value"]=df_evap17["Observed_value"]
        df_evap17["Observed_value"] = pd.to_numeric(df_evap17["Observed_value"],errors='coerce')
        #df_evap17["Observed_value"]=df_evap17["Observed_value"]/10

        df_evap17 = df_evap17[["Source_ID",'Station_ID',"Station_name","Alias_station_name",  
                                 "Year","Month","Day","Hour","Minute",
                                "Latitude","Longitude","Elevation","Observed_value",
                                "Source_QC_flag","Original_observed_value",
                                "Original_observed_value_units",                                
                                "Report_type_code","Measurement_code_1",
                                "Measurement_code_2"]]
        
    ##extract precipip taken at 1700
    
        df_evap7=df
        df_evap7=df_evap7.drop(columns =[ "precip_17", "precip7", "total_precip","evap_18","evap_total"])
        df_evap7["Hour"]="6" 
        df_evap7= df_evap7.rename(columns=({'evap_7':'Observed_value'}))
        df_evap7["Original_observed_value"]=df_evap7["Observed_value"]
        df_evap7["Observed_value"] = pd.to_numeric(df_evap7["Observed_value"],errors='coerce')
        #df_evap7["Observed_value"]=df_evap7["Observed_value"]/10

        df_evap7 = df_evap7[["Source_ID",'Station_ID',"Station_name","Alias_station_name",  
                                 "Year","Month","Day","Hour","Minute",
                                "Latitude","Longitude","Elevation","Observed_value",
                                "Source_QC_flag","Original_observed_value",
                                "Original_observed_value_units",                                
                                "Report_type_code","Measurement_code_1",
                                "Measurement_code_2"]]
        merged_evap=pd.concat([df_evap17,df_evap7], axis=0)
        merged_evap=merged_evap.dropna(subset = ['Observed_value'])
    
    #change time zones
        merged_evap["Timestamp2"] = merged_evap["Year"].map(str) + "-" + merged_evap["Month"].map(str)+ "-" + merged_evap["Day"].map(str)  
        merged_evap["Timestamp"] = merged_evap["Timestamp2"].map(str)+ " " + merged_evap["Hour"].map(str)+":"+merged_evap["Minute"].map(str)
        merged_evap= merged_evap.drop(columns=["Timestamp2"])
    
        merged_evap['Timestamp'] =  pd.to_datetime(merged_evap['Timestamp'], format='%Y-%m-%d' " ""%H:%M:%S")
        merged_evap['Timestamp'] = merged_evap['Timestamp'].dt.tz_localize('Etc/GMT-0').dt.tz_convert('GMT')
        merged_evap['Year'] = merged_evap['Timestamp'].dt.year 
        merged_evap['Month'] = merged_evap['Timestamp'].dt.month  
        merged_evap['Day'] = merged_evap['Timestamp'].dt.day 
        merged_evap['Hour'] = merged_evap['Timestamp'].dt.hour 
        merged_evap['Minute'] = merged_evap['Timestamp'].dt.minute
        merged_evap['Seconds'] = merged_evap['Timestamp'].dt.second
    
##delete unwanted columns 
        merged_evap= merged_evap.drop(columns="Timestamp")
        merged_evap['Minute']='00'
    
        merged_evap= merged_evap[["Source_ID",'Station_ID',"Station_name","Alias_station_name",  
                                 "Year","Month","Day","Hour","Minute",
                                "Latitude","Longitude","Elevation","Observed_value",
                                "Source_QC_flag","Original_observed_value",
                                "Original_observed_value_units",                                
                                "Report_type_code","Measurement_code_1",
                                "Measurement_code_2"]]
        merged_evap= merged_evap.astype(str)
        
    

#save output file   
        year=merged_evap.iloc[0]["Year"]
        month=merged_evap.iloc[0]["Month"]
        date=(year+"_"+month)
        source_id=merged_evap.iloc[0]["Source_ID"]
        cdm_type=(date+"_evaporation_"+source_id)
     
        a = merged_evap['Station_ID'].unique()
        print (a)
        outname = os.path.join(OUTDIR3,cdm_type)
      #with open(filename, "w") as outfile:
        merged_evap.to_csv(outname+".psv", index=False, sep="|")
    except:
        continue
   ###daily evap extract
    try:
        df_evapdy=df
        df_evapdy=df_evapdy.drop(columns =["precip_17","precip7", "evap_18","evap_7"])
        df_evapdy["Hour"]="6" 
        df_evapdy= df_evapdy.rename(columns=({'evap_total':'Observed_value'}))
        df_evapdy["Original_observed_value"]=df_evapdy["Observed_value"]
        df_evapdy["Observed_value"] = pd.to_numeric(df_evapdy["Observed_value"],errors='coerce')
        #df_evapdy["Observed_value"]=df_evapdy["Observed_value"]/10

        merged_evap_dy = df_evapdy[["Source_ID",'Station_ID',"Station_name","Alias_station_name",  
                                 "Year","Month","Day","Hour","Minute",
                                "Latitude","Longitude","Elevation","Observed_value",
                                "Source_QC_flag","Original_observed_value",
                                "Original_observed_value_units",                                
                                "Report_type_code","Measurement_code_1",
                                "Measurement_code_2"]]
        merged_evap_dy=merged_evap_dy.dropna(subset = ['Observed_value'])
    
    
    #change time zones
        merged_evap_dy["Timestamp2"] = merged_evap_dy["Year"].map(str) + "-" + merged_evap_dy["Month"].map(str)+ "-" + merged_evap_dy["Day"].map(str)  
        merged_evap_dy["Timestamp"] = merged_evap_dy["Timestamp2"].map(str)+ " " + merged_evap_dy["Hour"].map(str)+":"+merged_evap_dy["Minute"].map(str)
        merged_evap_dy= merged_evap_dy.drop(columns=["Timestamp2"])
    
        merged_evap_dy['Timestamp'] =  pd.to_datetime(merged_evap_dy['Timestamp'], format='%Y-%m-%d' " ""%H:%M:%S")
        merged_evap_dy['Timestamp'] = merged_evap_dy['Timestamp'].dt.tz_localize('Etc/GMT-0').dt.tz_convert('GMT')
        merged_evap_dy['Year'] = merged_evap_dy['Timestamp'].dt.year 
        merged_evap_dy['Month'] = merged_evap_dy['Timestamp'].dt.month  
        merged_evap_dy['Day'] = merged_evap_dy['Timestamp'].dt.day 
        merged_evap_dy['Hour'] = merged_evap_dy['Timestamp'].dt.hour 
        merged_evap_dy['Minute'] = merged_evap_dy['Timestamp'].dt.minute
        merged_evap_dy['Seconds'] = merged_evap_dy['Timestamp'].dt.second
    
##delete unwanted columns 
        merged_evap_dy = merged_evap_dy.drop(columns="Timestamp")
        merged_evap_dy['Minute']='00'
    
        merged_evap_dy = merged_evap_dy[["Source_ID",'Station_ID',"Station_name","Alias_station_name",  
                                 "Year","Month","Day","Hour","Minute",
                                "Latitude","Longitude","Elevation","Observed_value",
                                "Source_QC_flag","Original_observed_value",
                                "Original_observed_value_units",                                
                                "Report_type_code","Measurement_code_1",
                                "Measurement_code_2"]]
        
        merged_evap_dy = merged_evap_dy.astype(str)
    

#save output file   
        year=merged_evap_dy.iloc[0]["Year"]
        month=merged_evap_dy.iloc[0]["Month"]
        date=(year+"_"+month)
        source_id=merged_evap_dy.iloc[0]["Source_ID"]
        cdm_type=(date+"_evaporation_"+source_id)
     
        a = merged_evap_dy['Station_ID'].unique()
        print (a)
        outname = os.path.join(OUTDIR4,cdm_type)
    #with open(filename, "w") as outfile:
        merged_evap_dy.to_csv(outname+".psv", index=False, sep="|")
    except:
         continue

        


        
    
    
    
    