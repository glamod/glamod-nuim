# -*- coding: utf-8 -*-
"""
Created on Tue Jul 19 17:00:23 2022

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
os.chdir("D:/Russian stations(Barometer-Temperature)/Russian stations(Barometer-Temperature)/form1/test")
extension = 'xlsx'
all_filenames = [i for i in glob.glob('*.{}'.format(extension))]
for filename in all_filenames:
    dft= pd.read_excel(filename,sheet_name="data",skiprows = 1)
    dft_out= pd.DataFrame()
  
    try:
        col_list0 = ["0am"]
        dft0=pd.read_excel(filename,sheet_name="data",skiprows = 1,usecols=col_list0)
        dft0.rename(columns = {'0am':'Observed_value'}, inplace = True)
        dft0["Date"]=dft["Date"]
        dft0["Station_name"]=dft["Station_name"]
        dft0["Year"]=dft["Year"]
        dft0["Hour"]="0"
        dft0=dft0.dropna()
        dft0=dft0.dropna(axis=0)
        dft_out = dft_out.append(dft0)
    except:
        pass
    
    try:
        col_list2 = ["1am"]
        dft1=pd.read_excel(filename,sheet_name="data",skiprows = 1,usecols=col_list1)
        dft1.rename(columns = {'1am':'Observed_value'}, inplace = True)
        dft1["Date"]=dft["Date"]
        dft1["Station_name"]=dft["Station_name"]
        dft1["Year"]=dft["Year"]
        dft1["Hour"]="1"
        dft1=dft1.dropna()
        dft1=dft1.dropna(axis=0)
        dft_out = dft_out.append(dft1)
              
    except:
        pass
    
    try:
        col_list2 = ["2am"]
        dft2=pd.read_excel(filename,sheet_name="data",skiprows = 1,usecols=col_list2)
        dft2.rename(columns = {'2am':'Observed_value'}, inplace = True)
        dft2["Date"]=dft["Date"]
        dft2["Station_name"]=dft["Station_name"]
        dft2["Year"]=dft["Year"]
        dft2["Hour"]="2"
        dft2=dft2.dropna()
        dft2=dft2.dropna(axis=0)
        dft_out = dft_out.append(dft2)
              
    except:
        pass
    
    try:
        col_list3 = ["3am"]
        dft3=pd.read_excel(filename,sheet_name="data",skiprows = 1,usecols=col_list3)
        dft3.rename(columns = {'3am':'Observed_value'}, inplace = True)
        dft3["Date"]=dft["Date"]
        dft3["Station_name"]=dft["Station_name"]
        dft3["Year"]=dft["Year"]
        dft3["Hour"]="3"
        dft3=dft3.dropna()
        dft3=dft3.dropna(axis=0)
        dft_out = dft_out.append(dft3)
              
    except:
        pass
    
    try:
        col_list4 = ["4am"]
        dft4=pd.read_excel(filename,sheet_name="data",skiprows = 1,usecols=col_list4)
        dft4.rename(columns = {'4am':'Observed_value'}, inplace = True)
        dft4["Date"]=dft["Date"]
        dft4["Station_name"]=dft["Station_name"]
        dft4["Year"]=dft["Year"]
        dft4["Hour"]="4"
        dft4=dft4.dropna()
        dft4=dft4.dropna(axis=0)
        dft_out = dft_out.append(dft4)
              
    except:
        pass
    
    try:
        col_list5 = ["5am"]
        dft5=pd.read_excel(filename,sheet_name="data",skiprows = 1,usecols=col_list5)
        dft5.rename(columns = {'5am':'Observed_value'}, inplace = True)
        dft5["Date"]=dft["Date"]
        dft5["Station_name"]=dft["Station_name"]
        dft5["Year"]=dft["Year"]
        dft5["Hour"]="5"
        dft5=dft5.dropna()
        dft5=dft5.dropna(axis=0)
        dft_out = dft_out.append(dft5)
              
    except:
        pass
    
    try:
        col_list6 = ["6am"]
        dft6=pd.read_excel(filename,sheet_name="data",skiprows = 1,usecols=col_list6)
        dft6.rename(columns = {'6am':'Observed_value'}, inplace = True)
        dft6["Date"]=dft["Date"]
        dft6["Station_name"]=dft["Station_name"]
        dft6["Year"]=dft["Year"]
        dft6["Hour"]="6"
        dft6=dft6.dropna()
        dft6=dft6.dropna(axis=0)
        dft_out = dft_out.append(dft6)
              
    except:
        pass
    
    try:
        col_list7 = ["7am"]
        dft7=pd.read_excel(filename,sheet_name="data",skiprows = 1,usecols=col_list7)
        dft7.rename(columns = {'7am':'Observed_value'}, inplace = True)
        dft7["Date"]=dft["Date"]
        dft7["Station_name"]=dft["Station_name"]
        dft7["Year"]=dft["Year"]
        dft7["Hour"]="7"
        dft7=dft7.dropna()
        dft7=dft7.dropna(axis=0)
        dft_out = dft_out.append(dft7)
              
    except:
        pass
    
    try:
        col_list8 = ["8am"]
        dft8=pd.read_excel(filename,sheet_name="data",skiprows = 1,usecols=col_list8)
        dft8.rename(columns = {'8am':'Observed_value'}, inplace = True)
        dft8["Date"]=dft["Date"]
        dft8["Station_name"]=dft["Station_name"]
        dft8["Year"]=dft["Year"]
        dft8["Hour"]="8"
        dft8=dft8.dropna()
        dft8=dft8.dropna(axis=0)
        dft_out = dft_out.append(dft8)
              
    except:
        pass
    
    try:
        col_list9 = ["9am"]
        dft9=pd.read_excel(filename,sheet_name="data",skiprows = 1,usecols=col_list9)
        dft9.rename(columns = {'9am':'Observed_value'}, inplace = True)
        dft9["Date"]=dft["Date"]
        dft9["Station_name"]=dft["Station_name"]
        dft9["Year"]=dft["Year"]
        dft9["Hour"]="9"
        dft9=dft9.dropna()
        dft9=dft9.dropna(axis=0)
        dft_out = dft_out.append(dft9)
              
    except:
        pass
    
    try:
        col_list10 = ["10am"]
        dft10=pd.read_excel(filename,sheet_name="data",skiprows = 1,usecols=col_list10)
        dft10.rename(columns = {'10am':'Observed_value'}, inplace = True)
        dft10["Date"]=dft["Date"]
        dft10["Station_name"]=dft["Station_name"]
        dft10["Year"]=dft["Year"]
        dft10["Hour"]="10"
        dft10=dft10.dropna()
        dft10=dft10.dropna(axis=0)
        dft_out = dft_out.append(dft9)
              
    except:
        pass
    
    try:
        col_list11 = ["11am"]
        dft11=pd.read_excel(filename,sheet_name="data",skiprows = 1,usecols=col_list11)
        dft11.rename(columns = {'11am':'Observed_value'}, inplace = True)
        dft11["Date"]=dft["Date"]
        dft11["Station_name"]=dft["Station_name"]
        dft11["Year"]=dft["Year"]
        dft11["Hour"]="11"
        dft11=dft11.dropna()
        dft11=dft11.dropna(axis=0)
              
    except:
        pass
    
    try:
        col_list12 = ["12pm"]
        dft12=pd.read_excel(filename,sheet_name="data",skiprows = 1,usecols=col_list12)
        dft12.rename(columns = {'12pm':'Observed_value'}, inplace = True)
        dft12["Date"]=dft["Date"]
        dft12["Station_name"]=dft["Station_name"]
        dft12["Year"]=dft["Year"]
        dft12["Hour"]="12"
        dft12=dft12.dropna()
        dft12=dft12.dropna(axis=0)
              
    except:
        pass
    
    try:
        col_list13 = ["1pm"]
        dft13=pd.read_excel(filename,sheet_name="data",skiprows = 1,usecols=col_list13)
        dft13.rename(columns = {'1pm':'Observed_value'}, inplace = True)
        dft13["Date"]=dft["Date"]
        dft13["Station_name"]=dft["Station_name"]
        dft13["Year"]=dft["Year"]
        dft13["Hour"]="13"
        dft13=dft13.dropna()
        dft13=dft13.dropna(axis=0)
              
    except:
        pass
    
    try:
        col_list14 = ["2pm"]
        dft14=pd.read_excel(filename,sheet_name="data",skiprows = 1,usecols=col_list14)
        dft14.rename(columns = {'2pm':'Observed_value'}, inplace = True)
        dft14["Date"]=dft["Date"]
        dft14["Station_name"]=dft["Station_name"]
        dft14["Year"]=dft["Year"]
        dft14["Hour"]="14"
        dft14=dft14.dropna()
        dft14=dft14.dropna(axis=0)
              
    except:
        pass
    
    try:
        col_list15 = ["3pm"]
        dft15=pd.read_excel(filename,sheet_name="data",skiprows = 1,usecols=col_list15)
        dft15.rename(columns = {'3pm':'Observed_value'}, inplace = True)
        dft15["Date"]=dft["Date"]
        dft15["Station_name"]=dft["Station_name"]
        dft15["Year"]=dft["Year"]
        dft15["Hour"]="15"
        dft15=dft15.dropna()
        dft15=dft15.dropna(axis=0)
              
    except:
        pass
    
    try:
        col_list16 = ["4pm"]
        dft16=pd.read_excel(filename,sheet_name="data",skiprows = 1,usecols=col_list16)
        dft16.rename(columns = {'4pm':'Observed_value'}, inplace = True)
        dft16["Date"]=dft["Date"]
        dft16["Station_name"]=dft["Station_name"]
        dft16["Year"]=dft["Year"]
        dft16["Hour"]="16"
        dft16=dft16.dropna()
        dft16=dft16.dropna(axis=0)
              
    except:
        pass

    try:
        col_list17 = ["5pm"]
        dft17=pd.read_excel(filename,sheet_name="data",skiprows = 1,usecols=col_list17)
        dft17.rename(columns = {'5pm':'Observed_value'}, inplace = True)
        dft17["Date"]=dft["Date"]
        dft17["Station_name"]=dft["Station_name"]
        dft17["Year"]=dft["Year"]
        dft17["Hour"]="17"
        dft17=dft17.dropna()
        dft17=dft17.dropna(axis=0)
              
    except:
        pass
    
    try:
        col_list18 = ["6pm"]
        dft18=pd.read_excel(filename,sheet_name="data",skiprows = 1,usecols=col_list18)
        dft18.rename(columns = {'6pm':'Observed_value'}, inplace = True)
        dft18["Date"]=dft["Date"]
        dft18["Station_name"]=dft["Station_name"]
        dft18["Year"]=dft["Year"]
        dft18["Hour"]="18"
        dft18=dft18.dropna()
        dft18=dft18.dropna(axis=0)
              
    except:
        pass
    try:
        col_list19 = ["7pm"]
        dft19=pd.read_excel(filename,sheet_name="data",skiprows = 1,usecols=col_list19)
        dft19.rename(columns = {'7pm':"observed_value"}, inplace = True)
        dft19["Date"]=dft["Date"]
        dft19["Station_name"]=dft["Station_name"]
        dft19["Year"]=dft["Year"]
        dft19["Hour"]="19"
        dft19=dft19.dropna()
        dft19=dft19.dropna(axis=0)
              
    except:
        pass

    try:
        col_list20 = ["8pm"]
        dft20=pd.read_excel(filename,sheet_name="data",skiprows = 1,usecols=col_list20)
        dft20.rename(columns = {'8pm':'Observed_value'}, inplace = True)
        dft20["Date"]=dft["Date"]
        dft20["Station_name"]=dft["Station_name"]
        dft20["Year"]=dft["Year"]
        dft20["Hour"]="20"
        dft20=dft20.dropna()
        dft20=dft20.dropna(axis=0)
              
    except:
        pass
    
    try:
        col_list21 = ["9pm"]
        dft21=pd.read_excel(filename,sheet_name="data",skiprows = 1,usecols=col_list21)
        dft21.rename(columns = {'9pm':'Observed_value'}, inplace = True)
        dft21["Date"]=dft["Date"]
        dft21["Station_name"]=dft["Station_name"]
        dft21["Year"]=dft["Year"]
        dft21["Hour"]="21"
        dft21=dft21.dropna()
        dft21=dft21.dropna(axis=0)
              
    except:
        pass
    
    try:
        col_list22 = ["10pm"]
        dft22=pd.read_excel(filename,sheet_name="data",skiprows = 1,usecols=col_list22)
        dft22.rename(columns = {'10pm':'Observed_value'}, inplace = True)
        dft22["Date"]=dft["Date"]
        dft22["Station_name"]=dft["Station_name"]
        dft22["Year"]=dft["Year"]
        dft22["Hour"]="22"
        dft22=dft22.dropna()
        dft22=dft22.dropna(axis=0)
              
    except:
        pass
    
    try:
        col_list23 = ["11pm"]
        dft23=pd.read_excel(filename,sheet_name="data",skiprows = 1,usecols=col_list23)
        dft23.rename(columns = {'11pm':'Observed_value'}, inplace = True)
        dft23["Date"]=dft["Date"]
        dft23["Station_name"]=dft["Station_name"]
        dft23["Year"]=dft["Year"]
        dft23["Hour"]="23"
        dft23=dft23.dropna()
        dft23=dft23.dropna(axis=0)
              
    except:
        pass
del dft   
sheets=[]    
for var in dir():
    if isinstance(locals()[var], pd.core.frame.DataFrame)  and var[0]!='_':
        sheets.append(var)    
    
sheets
dft_out = pd.DataFrame()

for df in sheets:
    dft_out = dft_out.append(df)
    
df = pd.concat(sheets)

frames = [dft0,dft1,dft2,dft3,dft4,dft5,dft6,dft7,dft8,dft9,dft10,dft11,dft12,dft13,dft14,dft15,dft16,dft17,dft18,dft19,dft20,dft21,dft22,dft23]
dft_out=pd.concat(sheets)






   
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    df= df[["Source_ID",'Station_ID',"Station_name","Alias_station_name",  
                                 "Year","Month","Day","Hour","Minute",
                                "Latitude","Longitude","Elevation","Observed_value",
                                "Source_QC_flag","Original_observed_value",
                                "Original_observed_value_units",                                
                                "Report_type_code","Measurement_code_1",
                                "Measurement_code_2",]]
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    df1["Source_ID"]="371"
    df1["Alias_station_name"]=""
    df1["Observed_value"]=df1["7am"]
    df1["Source_QC_flag"]=""
    df1['Original_observed_value']=""
    df1['Original_observed_value_units']="Hg_mm"
    df1['Report_type_code']='0'
    df1['Measurement_code_1']=''
    df1['Measurement_code_2']=''
    df1['Observed_value']=df1["Observed_value"]/25.4 * 33.86389
    df['Month']
    df['Day'] 
    df['Hour'] 
    df["Hour"] = 
    df["Minute"]="0"
    df['Hour'] = df['Hour'].astype(float).astype(int)
    df["Timestamp2"] = df["Year"].map(str) + "-" + df["Month"].map(str)+ "-" + df["Day"].map(str)  
    df["Timestamp"] = df["Timestamp2"].map(str)+ " " + df["Hour"].map(str)+":"+df["Minute"].map(str)
    df.drop(columns=["Timestamp2"])
    df['Timestamp'] =  pd.to_datetime(df['Timestamp'], format='%Y-%m-%d' " ""%H:%M:%S")
    df['Timestamp'] = df['Timestamp'].dt.tz_localize('Etc/GMT-2').dt.tz_convert('GMT')
    df['Year'] = df['Timestamp'].dt.year 
    df['Month'] = df['Timestamp'].dt.month 
    df['Day'] = df['Timestamp'].dt.day 
    df['Hour'] = df['Timestamp'].dt.hour 
    df['Minute'] = df['Timestamp'].dt.minute
    df['Seconds'] = df['Timestamp'].dt.second
    
    df2=pd.read_csv("xxx)
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
    
    