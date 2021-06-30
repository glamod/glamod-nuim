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
import numpy as np

##import all csv files in current dir that need timezone changing to GMT based on hours offset 
os.chdir("D:/EEC_canadian_hourly/test")
extension = 'csv'
all_filenames = [i for i in glob.glob('*.{}'.format(extension))]
#combine all files in the list
df= pd.concat([pd.read_csv(f,delimiter=',') for f in all_filenames])
df1=df
df1["Station_name"]=df1["Station_Name"]
df1["Observed_value"]=df1["1"]
df1["Hour"]="1"
df1["Minute"]="00"
df1["Alias_station_name"]=""
df1["Source_QC_flag"]=""
df1['Original_observed_value_units']="Pa"
df1['Measurement_code_1']=''
df1['Measurement_code_2']=''
df1['Report_type_code']=''
df1['Original_observed_value']=df1["1"]
df1['Observed_value'].replace('', np.nan, inplace=True)
df1.dropna(subset=['Observed_value'], inplace=True)
df1 = df1[["Source_ID",'Station_ID',"Station_name","Alias_station_name",  
                                 "Year","Month","Day","Hour","Minute",
                                "Latitude","Longitude","Elevation","Observed_value",
                                "Source_QC_flag","Original_observed_value",
                                "Original_observed_value_units",                                
                                "Report_type_code","Measurement_code_1",
                                "Measurement_code_2"]]
df2=df
df2["Station_name"]=df["Station_name"]
df2["Observed_value"]=df["2"]
df2["Hour"]="2"
df2["Minute"]="00"
df2["Alias_station_name"]=""
df2["Source_QC_flag"]=""
df2['Original_observed_value_units']="Pa"
df2['Measurement_code_1']=''
df2['Measurement_code_2']=''
df2['Report_type_code']=''
df2['Original_observed_value']=df["2"]
df2['Observed_value'].replace('', np.nan, inplace=True)
df2.dropna(subset=['Observed_value'], inplace=True)
df2 = df2[["Source_ID",'Station_ID',"Station_name","Alias_station_name",  
                                 "Year","Month","Day","Hour","Minute",
                                "Latitude","Longitude","Elevation","Observed_value",
                                "Source_QC_flag","Original_observed_value",
                                "Original_observed_value_units",                                
                                "Report_type_code","Measurement_code_1",
                                "Measurement_code_2"]]
df3=df
df3["Station_name"]=df["Station_name"]
df3["Observed_value"]=df["3"]
df3["Hour"]="3"
df3["Minute"]="00"
df3["Alias_station_name"]=""
df3["Source_QC_flag"]=""
df3['Original_observed_value_units']="Pa"
df3['Measurement_code_1']=''
df3['Measurement_code_2']=''
df3['Report_type_code']=''
df3['Original_observed_value']=df["3"]
df3['Observed_value'].replace('', np.nan, inplace=True)
df3.dropna(subset=['Observed_value'], inplace=True)
df3 = df3[["Source_ID",'Station_ID',"Station_name","Alias_station_name",  
                                 "Year","Month","Day","Hour","Minute",
                                "Latitude","Longitude","Elevation","Observed_value",
                                "Source_QC_flag","Original_observed_value",
                                "Original_observed_value_units",                                
                                "Report_type_code","Measurement_code_1",
                                "Measurement_code_2"]]
df4=df
df4["Station_name"]=df["Station_name"]
df4["Observed_value"]=df["4"]
df4["Hour"]="4"
df4["Minute"]="00"
df4["Alias_station_name"]=""
df4["Source_QC_flag"]=""
df4['Original_observed_value_units']="Pa"
df4['Measurement_code_1']=''
df4['Measurement_code_2']=''
df4['Report_type_code']=''
df4['Original_observed_value']=df["4"]
df4['Observed_value'].replace('', np.nan, inplace=True)
df4.dropna(subset=['Observed_value'], inplace=True)
df4 = df4[["Source_ID",'Station_ID',"Station_name","Alias_station_name",  
                                 "Year","Month","Day","Hour","Minute",
                                "Latitude","Longitude","Elevation","Observed_value",
                                "Source_QC_flag","Original_observed_value",
                                "Original_observed_value_units",                                
                                "Report_type_code","Measurement_code_1",
                                "Measurement_code_2"]]

df5=df
df5["Station_name"]=df["Station_name"]
df5["Observed_value"]=df["5"]
df5["Hour"]="5"
df5["Minute"]="00"
df5["Alias_station_name"]=""
df5["Source_QC_flag"]=""
df5['Original_observed_value_units']="Pa"
df5['Measurement_code_1']=''
df5['Measurement_code_2']=''
df5['Report_type_code']=''
df5['Original_observed_value']=df["5"]
df5['Observed_value'].replace('', np.nan, inplace=True)
df5.dropna(subset=['Observed_value'], inplace=True)
df5 = df5[["Source_ID",'Station_ID',"Station_name","Alias_station_name",  
                                 "Year","Month","Day","Hour","Minute",
                                "Latitude","Longitude","Elevation","Observed_value",
                                "Source_QC_flag","Original_observed_value",
                                "Original_observed_value_units",                                
                                "Report_type_code","Measurement_code_1",
                                "Measurement_code_2"]]
df6=df
df6["Station_name"]=df["Station_name"]
df6["Observed_value"]=df["6"]
df6["Hour"]="6"
df6["Minute"]="00"
df6["Alias_station_name"]=""
df6["Source_QC_flag"]=""
df6['Original_observed_value_units']="Pa"
df6['Measurement_code_1']=''
df6['Measurement_code_2']=''
df6['Report_type_code']=''
df6['Original_observed_value']=df["6"]
df6['Observed_value'].replace('', np.nan, inplace=True)
df6.dropna(subset=['Observed_value'], inplace=True)
df6 = df6[["Source_ID",'Station_ID',"Station_name","Alias_station_name",  
                                 "Year","Month","Day","Hour","Minute",
                                "Latitude","Longitude","Elevation","Observed_value",
                                "Source_QC_flag","Original_observed_value",
                                "Original_observed_value_units",                                
                                "Report_type_code","Measurement_code_1",
                                "Measurement_code_2"]]
df7=df
df7["Station_name"]=df["Station_name"]
df7["Observed_value"]=df["7"]
df7["Hour"]="7"
df7["Minute"]="00"
df7["Alias_station_name"]=""
df7["Source_QC_flag"]=""
df7['Original_observed_value_units']="Pa"
df7['Measurement_code_1']=''
df7['Measurement_code_2']=''
df7['Report_type_code']=''
df7['Original_observed_value']=df["7"]
df7['Observed_value'].replace('', np.nan, inplace=True)
df7.dropna(subset=['Observed_value'], inplace=True)
df7 = df7[["Source_ID",'Station_ID',"Station_name","Alias_station_name",  
                                 "Year","Month","Day","Hour","Minute",
                                "Latitude","Longitude","Elevation","Observed_value",
                                "Source_QC_flag","Original_observed_value",
                                "Original_observed_value_units",                                
                                "Report_type_code","Measurement_code_1",
                                "Measurement_code_2"]]
df8=df
df8["Station_name"]=df["Station_name"]
df8["Observed_value"]=df["8"]
df8["Hour"]="8"
df8["Minute"]="00"
df8["Alias_station_name"]=""
df8["Source_QC_flag"]=""
df8['Original_observed_value_units']="Pa"
df8['Measurement_code_1']=''
df8['Measurement_code_2']=''
df8['Report_type_code']=''
df8['Original_observed_value']=df["8"]
df7['Observed_value'].replace('', np.nan, inplace=True)
df7.dropna(subset=['Observed_value'], inplace=True)
df8 = df8[["Source_ID",'Station_ID',"Station_name","Alias_station_name",  
                                 "Year","Month","Day","Hour","Minute",
                                "Latitude","Longitude","Elevation","Observed_value",
                                "Source_QC_flag","Original_observed_value",
                                "Original_observed_value_units",                                
                                "Report_type_code","Measurement_code_1",
                                "Measurement_code_2"]] 
 
df9=df
df9["Station_name"]=df["Station_name"]
df9["Observed_value"]=df["9"]
df9["Hour"]="9"
df9["Minute"]="00"
df9["Alias_station_name"]=""
df9["Source_QC_flag"]=""
df9['Original_observed_value_units']="Pa"
df9['Measurement_code_1']=''
df9['Measurement_code_2']=''
df9['Report_type_code']=''
df9['Original_observed_value']=df["9"]
df9['Observed_value'].replace('', np.nan, inplace=True)
df9.dropna(subset=['Observed_value'], inplace=True)
df9 = df9[["Source_ID",'Station_ID',"Station_name","Alias_station_name",  
                                 "Year","Month","Day","Hour","Minute",
                                "Latitude","Longitude","Elevation","Observed_value",
                                "Source_QC_flag","Original_observed_value",
                                "Original_observed_value_units",                                
                                "Report_type_code","Measurement_code_1",
                                "Measurement_code_2"]]                               
df10=df
df10["Station_name"]=df["Station_name"]
df10["Observed_value"]=df["10"]
df10["Hour"]="10"
df10["Minute"]="00"
df10["Alias_station_name"]=""
df10["Source_QC_flag"]=""
df10['Original_observed_value_units']="Pa"
df10['Measurement_code_1']=''
df10['Measurement_code_2']=''
df10['Report_type_code']=''
df10['Original_observed_value']=df["10"]
df10['Observed_value'].replace('', np.nan, inplace=True)
df10.dropna(subset=['Observed_value'], inplace=True)
df10 = df10[["Source_ID",'Station_ID',"Station_name","Alias_station_name",  
                                 "Year","Month","Day","Hour","Minute",
                                "Latitude","Longitude","Elevation","Observed_value",
                                "Source_QC_flag","Original_observed_value",
                                "Original_observed_value_units",                                
                                "Report_type_code","Measurement_code_1",
                                "Measurement_code_2"]] 
df11=df
df11["Station_name"]=df["Station_Name"]
df11["Observed_value"]=df["11"]
df11["Hour"]="11"
df11["Minute"]="00"
df11["Alias_station_name"]=""
df11["Source_QC_flag"]=""
df11['Original_observed_value_units']="Pa"
df11['Measurement_code_1']=''
df11['Measurement_code_2']=''
df11['Report_type_code']=''
df11['Original_observed_value']=df["11"]
df11['Observed_value'].replace('', np.nan, inplace=True)
df11.dropna(subset=['Observed_value'], inplace=True)
df11 = df11[["Source_ID",'Station_ID',"Station_name","Alias_station_name",  
                                 "Year","Month","Day","Hour","Minute",
                                "Latitude","Longitude","Elevation","Observed_value",
                                "Source_QC_flag","Original_observed_value",
                                "Original_observed_value_units",                                
                                "Report_type_code","Measurement_code_1",
                                "Measurement_code_2"]] 
df12=df
df12["Station_name"]=df["Station_Name"]
df12["Observed_value"]=df["12"]
df12["Hour"]="12"
df12["Minute"]="00"
df12["Alias_station_name"]=""
df12["Source_QC_flag"]=""
df12['Original_observed_value_units']="Pa"
df12['Measurement_code_1']=''
df12['Measurement_code_2']=''
df12['Report_type_code']=''
df12['Original_observed_value']=df["12"]
df12['Observed_value'].replace('', np.nan, inplace=True)
df12.dropna(subset=['Observed_value'], inplace=True)
df12 = df12[["Source_ID",'Station_ID',"Station_name","Alias_station_name",  
                                 "Year","Month","Day","Hour","Minute",
                                "Latitude","Longitude","Elevation","Observed_value",
                                "Source_QC_flag","Original_observed_value",
                                "Original_observed_value_units",                                
                                "Report_type_code","Measurement_code_1",
                                "Measurement_code_2"]]
df13=df
df13["Station_name"]=df["Station_Name"]
df13["Observed_value"]=df["13"]
df13["Hour"]="13"
df13["Minute"]="00"
df13["Alias_station_name"]=""
df13["Source_QC_flag"]=""
df13['Measurement_code_1']=''
df13['Measurement_code_2']=''
df13['Report_type_code']=''
df13['Original_observed_value']=df["13"]
df13['Observed_value'].replace('', np.nan, inplace=True)
df13.dropna(subset=['Observed_value'], inplace=True)
df13 = df13[["Source_ID",'Station_ID',"Station_name","Alias_station_name",  
                                 "Year","Month","Day","Hour","Minute",
                                "Latitude","Longitude","Elevation","Observed_value",
                                "Source_QC_flag","Original_observed_value",
                                "Original_observed_value_units",                                
                                "Report_type_code","Measurement_code_1",
                                "Measurement_code_2"]]
df14=df
df14["Station_name"]=df["Station_Name"]
df14["Observed_value"]=df["14"]
df14["Hour"]="14"
df14["Minute"]="00"
df14["Alias_station_name"]=""
df14["Source_QC_flag"]=""
df14['Original_observed_value_units']="Pa"
df14['Measurement_code_1']=''
df14['Measurement_code_2']=''
df14['Report_type_code']=''
df14['Original_observed_value']=df["14"]
df14['Observed_value'].replace('', np.nan, inplace=True)
df14.dropna(subset=['Observed_value'], inplace=True)
df14 = df14[["Source_ID",'Station_ID',"Station_name","Alias_station_name",  
                                 "Year","Month","Day","Hour","Minute",
                                "Latitude","Longitude","Elevation","Observed_value",
                                "Source_QC_flag","Original_observed_value",
                                "Original_observed_value_units",                                
                                "Report_type_code","Measurement_code_1",
                                "Measurement_code_2"]]
df15=df
df15["Station_name"]=df["Station_Name"]
df15["Observed_value"]=df["15"]
df15["Hour"]="15"
df15["Minute"]="00"
df15["Alias_station_name"]=""
df15["Source_QC_flag"]=""
df15['Original_observed_value_units']="Pa"
df15['Measurement_code_1']=''
df15['Measurement_code_2']=''
df15['Report_type_code']=''
df15['Original_observed_value']=df["15"]
df15['Observed_value'].replace('', np.nan, inplace=True)
df15.dropna(subset=['Observed_value'], inplace=True)
df15 = df15[["Source_ID",'Station_ID',"Station_name","Alias_station_name",  
                                 "Year","Month","Day","Hour","Minute",
                                "Latitude","Longitude","Elevation","Observed_value",
                                "Source_QC_flag","Original_observed_value",
                                "Original_observed_value_units",                                
                                "Report_type_code","Measurement_code_1",
                                "Measurement_code_2"]]
df16=df
df16["Station_name"]=df["Station_Name"]
df16["Observed_value"]=df["16"]
df16["Hour"]="16"
df16["Minute"]="00"
df16["Alias_station_name"]=""
df16["Source_QC_flag"]=""
df16['Original_observed_value_units']="Pa"
df16['Measurement_code_1']=''
df16['Measurement_code_2']=''
df16['Report_type_code']=''
df16['Original_observed_value']=df["16"]
df16['Observed_value'].replace('', np.nan, inplace=True)
df16.dropna(subset=['Observed_value'], inplace=True)
df16 = df16[["Source_ID",'Station_ID',"Station_name","Alias_station_name",  
                                 "Year","Month","Day","Hour","Minute",
                                "Latitude","Longitude","Elevation","Observed_value",
                                "Source_QC_flag","Original_observed_value",
                                "Original_observed_value_units",                                
                                "Report_type_code","Measurement_code_1",
                                "Measurement_code_2"]]
df17=df
df17["Station_name"]=df1["Station_Name"]
df17["Observed_value"]=df1["17"]
df17["Hour"]="17"
df17["Minute"]="00"
df17["Alias_station_name"]=""
df17["Source_QC_flag"]=""
df17['Original_observed_value_units']="Pa"
df17['Measurement_code_1']=''
df17['Measurement_code_2']=''
df17['Report_type_code']=''
df17['Original_observed_value']=df1["17"]
df17['Observed_value'].replace('', np.nan, inplace=True)
df17.dropna(subset=['Observed_value'], inplace=True)
df17 = df17[["Source_ID",'Station_ID',"Station_name","Alias_station_name",  
                                 "Year","Month","Day","Hour","Minute",
                                "Latitude","Longitude","Elevation","Observed_value",
                                "Source_QC_flag","Original_observed_value",
                                "Original_observed_value_units",                                
                                "Report_type_code","Measurement_code_1",
                                "Measurement_code_2"]]
df18=df
df18["Station_name"]=df["Station_Name"]
df18["Observed_value"]=df["18"]
df18["Hour"]="18"
df18["Minute"]="00"
df18["Alias_station_name"]=""
df18["Source_QC_flag"]=""
df18['Original_observed_value_units']="Pa"
df18['Measurement_code_1']=''
df18['Measurement_code_2']=''
df18['Report_type_code']=''
df18['Original_observed_value']=df["18"]
df16['Observed_value'].replace('', np.nan, inplace=True)
df18.dropna(subset=['Observed_value'], inplace=True)
df18 = df18[["Source_ID",'Station_ID',"Station_name","Alias_station_name",  
                                 "Year","Month","Day","Hour","Minute",
                                "Latitude","Longitude","Elevation","Observed_value",
                                "Source_QC_flag","Original_observed_value",
                                "Original_observed_value_units",                                
                                "Report_type_code","Measurement_code_1",
                                "Measurement_code_2"]]
df19=df
df19["Station_name"]=df["Station_Name"]
df19["Observed_value"]=df["19"]
df19["Hour"]="19"
df19["Minute"]="00"
df19["Alias_station_name"]=""
df19["Source_QC_flag"]=""
df19['Original_observed_value_units']="Pa"
df19['Measurement_code_1']=''
df19['Measurement_code_2']=''
df19['Report_type_code']=''
df19['Original_observed_value']=df["19"]
df19['Observed_value'].replace('', np.nan, inplace=True)
df19.dropna(subset=['Observed_value'], inplace=True)
df19 = df19[["Source_ID",'Station_ID',"Station_name","Alias_station_name",  
                                 "Year","Month","Day","Hour","Minute",
                                "Latitude","Longitude","Elevation","Observed_value",
                                "Source_QC_flag","Original_observed_value",
                                "Original_observed_value_units",                                
                                "Report_type_code","Measurement_code_1",
                                "Measurement_code_2"]]
df20=df
df20["Station_name"]=df["Station_Name"]
df20["Observed_value"]=df["20"]
df20["Hour"]="20"
df20["Minute"]="00"
df20["Alias_station_name"]=""
df20["Source_QC_flag"]=""
df20['Original_observed_value_units']="Pa"
df20['Measurement_code_1']=''
df20['Measurement_code_2']=''
df20['Report_type_code']=''
df20['Original_observed_value']=df["20"]
df20['Observed_value'].replace('', np.nan, inplace=True)
df20.dropna(subset=['Observed_value'], inplace=True)
df20 = df20[["Source_ID",'Station_ID',"Station_name","Alias_station_name",  
                                 "Year","Month","Day","Hour","Minute",
                                "Latitude","Longitude","Elevation","Observed_value",
                                "Source_QC_flag","Original_observed_value",
                                "Original_observed_value_units",                                
                                "Report_type_code","Measurement_code_1",
                                "Measurement_code_2"]]
df21=df
df21["Station_name"]=df["Station_Name"]
df21["Observed_value"]=df["21"]
df21["Hour"]="21"
df21["Minute"]="00"
df21["Alias_station_name"]=""
df21["Source_QC_flag"]=""
df21['Original_observed_value_units']="Pa"
df21['Measurement_code_1']=''
df21['Measurement_code_2']=''
df21['Report_type_code']=''
df21['Original_observed_value']=df["21"]
df21['Observed_value'].replace('', np.nan, inplace=True)
df21.dropna(subset=['Observed_value'], inplace=True)
df21 = df21[["Source_ID",'Station_ID',"Station_name","Alias_station_name",  
                                 "Year","Month","Day","Hour","Minute",
                                "Latitude","Longitude","Elevation","Observed_value",
                                "Source_QC_flag","Original_observed_value",
                                "Original_observed_value_units",                                
                                "Report_type_code","Measurement_code_1",
                                "Measurement_code_2"]]
df22=df
df22["Station_name"]=df["Station_Name"]
df22["Observed_value"]=df["22"]
df22["Hour"]="22"
df22["Minute"]="00"
df22["Alias_station_name"]=""
df22["Source_QC_flag"]=""
df22['Original_observed_value_units']="Pa"
df22['Measurement_code_1']=''
df22['Measurement_code_2']=''
df22['Report_type_code']=''
df22['Original_observed_value']=df["22"]
df22['Observed_value'].replace('', np.nan, inplace=True)
df22.dropna(subset=['Observed_value'], inplace=True)
df22 = df22[["Source_ID",'Station_ID',"Station_name","Alias_station_name",  
                                 "Year","Month","Day","Hour","Minute",
                                "Latitude","Longitude","Elevation","Observed_value",
                                "Source_QC_flag","Original_observed_value",
                                "Original_observed_value_units",                                
                                "Report_type_code","Measurement_code_1",
                                "Measurement_code_2"]]
df23=df
df23["Station_name"]=df["Station_Name"]
df23["Observed_value"]=df["23"]
df23["Hour"]="23"
df23["Minute"]="00"
df23["Alias_station_name"]=""
df23["Source_QC_flag"]=""
df23['Original_observed_value_units']="Pa"
df23['Measurement_code_1']=''
df23['Measurement_code_2']=''
df23['Report_type_code']=''
df23['Original_observed_value']=df["23"]
df23['Observed_value'].replace('', np.nan, inplace=True)
df23.dropna(subset=['Observed_value'], inplace=True)
df23 = df23[["Source_ID",'Station_ID',"Station_name","Alias_station_name",  
                                 "Year","Month","Day","Hour","Minute",
                                "Latitude","Longitude","Elevation","Observed_value",
                                "Source_QC_flag","Original_observed_value",
                                "Original_observed_value_units",                                
                                "Report_type_code","Measurement_code_1",
                                "Measurement_code_2"]]

df24=df
df24["Station_name"]=df["Station_Name"]
df24["Observed_value"]=df["0"]
df24["Hour"]="24"
df24["Minute"]="00"
df24["Alias_station_name"]=""
df24["Source_QC_flag"]=""
df24['Original_observed_value_units']="Pa"
df24['Measurement_code_1']=''
df24['Measurement_code_2']=''
df24['Report_type_code']=''
df24['Original_observed_value']=df["0"]
df14['Observed_value'].replace('', np.nan, inplace=True)
df14.dropna(subset=['Observed_value'], inplace=True)
df24 = df24[["Source_ID",'Station_ID',"Station_name","Alias_station_name",  
                                 "Year","Month","Day","Hour","Minute",
                                "Latitude","Longitude","Elevation","Observed_value",
                                "Source_QC_flag","Original_observed_value",
                                "Original_observed_value_units",                                
                                "Report_type_code","Measurement_code_1",
                                "Measurement_code_2"]]

del df
#concatanate all dfs together
df_final=pd.concat([df1,df2,df3,df4,df5,df6,df7,df8,df9,df10,df11,df12,df13,df14,df15,df16,
           df17,df18,df19,df20,df21,df22,df23,df24], axis=0)
#remve all dfs
del df1,df2,df3,df4,df5,df6,df7,df8,df9,df10,df11,df12,df13,df14,df15,df16
del df17,df18,df19,df20,df21,df22,df23,df24
#chnage observae dvalue to a numeric value 
df_final["Observed_value"] = pd.to_numeric(df_final["Observed_value"],errors='coerce')

##divide Pa by ten to give Hpa
df_final['Observed_value']=df_final["Observed_value"]/ 10
df_final["Observed_value"]= df_final["Observed_value"].round(1)

#change lat,long, to numeric then set decimal places
df_final["Latitude"] = pd.to_numeric(df_final["Latitude"],errors='coerce')
df_final["Longitude"] = pd.to_numeric(df_final["Longitude"],errors='coerce')
df_final["Latitude"]= df_final["Latitude"].round(3)
df_final["Longitude"]= df_final["Longitude"].round(3)
df_final["Elevation"]= df_final["Elevation"].round(3)    
df_final["Original_observed_value"]= df_final["Original_observed_value"].round(2)  
                              


df_final.to_csv("combined.csv",index=False)

##separate combined to separate files based on a column 

with open('combined.csv') as fin:    
    csvin = csv.DictReader(fin)
        #csvin.columns = [x.replace(' ', '_') for x in csvin.columns]  
    # Category -> open file lookup
    outputs = {}
    for row in csvin:
        cat = row['Station_ID']
        os.chdir("D:/EEC_canadian_hourly/test/out")
        # Open a new file and write the header
        if cat not in outputs:
            fout = open ('{}_sea_level_pressure_341.psv'.format(cat), "w", newline = "")
            dw = csv.DictWriter(fout, fieldnames=csvin.fieldnames,delimiter='|')
            dw.writeheader()
            outputs[cat] = fout, dw
        # Always write the row
        outputs[cat][1].writerow(row)
    # Close all the files
    for fout, _ in outputs.values():
        fout.close()

##