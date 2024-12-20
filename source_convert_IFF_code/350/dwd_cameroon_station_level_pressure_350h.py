
# -*- coding: utf-8 -*-
"""
Created on Tue Mar 19 09:02:55 2019

@author: 67135099
"""
##reads all the files in the current working directory, make sure only input files are in folde
import os
import glob
import pandas as pd
import csv

#import numpy as np     
os.chdir(r"D:/Other_Sub_Daily_Data_inventory_pending/Cameroon_dwd/data_cameroon/hh") 
files = [ f for f in os.listdir( os.curdir ) if os.path.isfile(f) ]
files
firstFile = files[0]
firstFile

#Checks all the files structure that all of the lines in the file are of length 403
##################################################################################################
count = 0
maxLength = 0

minLength = 100000
with open(firstFile, "r") as theFirstFile:
    for line in theFirstFile:
        count +=1
        if len(line) < minLength:
            minLength = len(line)
        if len(line) > maxLength:
            maxLength = len(line)
    print("Count =", count)
    print("Max = ", maxLength)
    print("Min = ", minLength)
 #Now going to extract some data from the file and see what is there. 
##################################################################################################### 

########################################################################################################
#Now we can combine all of the data from all of the files into a single data frame

giantListOfDictionaries = []
for currentFile in files:
    with open(currentFile, "r") as theFirstFile:
        for line in theFirstFile:
            field1 = line[21:29]
            field2 = line[54:58]
            field3 = line[58:60]
            field4 = line[60:62]
            field5 = line[63:65]
            field6 = line[66:68]
            field7 = "NULL"
            field8 = "NULL"
            field9 = line[47:51]
            field10 = line[73:78]
            field11 = line[79:80]
            field12 = line[73:78]
            field13 = "NULL"
            field14 = "NULL"
            field15 = "350"
            field16 = "NULL"
            field17 = line[0:20]
            field18 = "NULL"
            field19 = "NULL"
          

            
            currentDictionary = {"File_name": currentFile,'Station_ID': field1, 
                                 "Year": field2,"Month": field3,"Day": field4,"Hour": field5,"Minute":field6,
                                "Latitude":field7,"Longitude":field8,"Elevation":field9,"Observed_value":field10,
                                "Source_QC_flag":field11,"Original_observed_value":field12,
                                "Original_observed_value_units":field13,
                                "Measurement_code_2":field14,
                                "Source_ID":field15,
                                "Report_type_code":field16,"Station_name":field17,
                                "Alias_station_name":field18,"Measurement_code_1":field19}
            giantListOfDictionaries.append(currentDictionary)
            
#length of file
len(giantListOfDictionaries)


#create a dataframe from dictionary
giantDataFrame = pd.DataFrame(giantListOfDictionaries)
#giantDataFrame = giantDataFrame.replace({"9999":" "})
##giantDataFrame
#Delete the unwanted first column File name
#giantDataFrame=giantDataFrame.drop("File_name",axis=1)

giantDataFrame.to_csv("errors.csv",index=False)
###########################################################################################                                
#replace missing data values in the dataframe with NUlL
giantDataFrame['Observed_value'] = pd.to_numeric(giantDataFrame['Observed_value'], errors='coerce')
giantDataFrame = giantDataFrame.drop([giantDataFrame.index[0]])

#giantDataFrame = giantDataFrame.replace({"9999.99":" ",
                                            # "9999":" ",
                                            # "9999999999999":" ",
                                            # "999999999":" ",
                                            # "99999999":" ",
                                             #"999":" ","9999.9":" "})

giantDataFrame['Observed_value'] = giantDataFrame['Observed_value']/10
###concanate date columns to adjust for time zone
#giantDataFrame["Timestamp2"] = giantDataFrame["Year"].map(str) + "-" + giantDataFrame["Month"].map(str)+ "-" + giantDataFrame["Day"].map(str)  
#giantDataFrame["Timestamp"] = giantDataFrame["Timestamp2"].map(str)+ " " + giantDataFrame["Hour"].map(str)+":"+giantDataFrame["Minute"].map(str) 

########################################################################################
##add in lat/long from a list matchinh station ids
os.chdir(r"D:/Other_Sub_Daily_Data_inventory_pending/Cameroon_dwd/")
stn_list = pd.read_csv("station_list.csv")
giantDataFrame=giantDataFrame.merge(stn_list, on='Station_ID', how='left')
giantDataFrame=giantDataFrame.drop("Latitude_x",axis=1)
giantDataFrame=giantDataFrame.drop("Longitude_x",axis=1)
giantDataFrame=giantDataFrame.drop("Elevation_x",axis=1)
giantDataFrame["Longitude"] = giantDataFrame["Longitude_y"]
giantDataFrame["Latitude"] = giantDataFrame["Latitude_y"]
giantDataFrame["Elevation"] = giantDataFrame["Elevation_y"]

##################################################################################
###set order of cloumns headers in dataframe
giantDataFrame=giantDataFrame[["Source_ID",'Station_ID',"Station_name","Alias_station_name",  
                                 "Year","Month","Day","Hour","Minute",
                                "Latitude","Longitude","Elevation","Observed_value",
                                "Source_QC_flag","Original_observed_value",
                                "Original_observed_value_units","Report_type_code",
                                "Measurement_code_1",
                                "Measurement_code_2"
                                ]]
#####################################################################
##'''strip leading and trailing space in each column'''
giantDataFrame['Source_ID'] = giantDataFrame['Source_ID'].str.strip() 
giantDataFrame['Station_ID'] = giantDataFrame['Station_ID'].str.strip()                                          
giantDataFrame['Station_name'] = giantDataFrame['Station_name'].str.strip()
giantDataFrame['Alias_station_name'] = giantDataFrame['Alias_station_name'].str.strip()
giantDataFrame['Year'] = giantDataFrame['Year'].str.strip()
giantDataFrame['Month'] = giantDataFrame['Month'].str.strip()
giantDataFrame['Day'] = giantDataFrame['Day'].str.strip()
giantDataFrame['Hour'] = giantDataFrame['Hour'].str.strip()
giantDataFrame['Minute'] = giantDataFrame['Minute'].str.strip()
#giantDataFrame['Latitude'] = giantDataFrame['Latitude'].str.strip()
#giantDataFrame['Longitude'] = giantDataFrame['Longitude'].str.strip()
#giantDataFrame['Elevation'] = giantDataFrame['Elevation'].str.strip()
#giantDataFrame['Observed_value'] = giantDataFrame['Observed_value'].str.strip()
giantDataFrame['Source_QC_flag'] = giantDataFrame['Source_QC_flag'].str.strip()
giantDataFrame['Original_observed_value'] = giantDataFrame['Original_observed_value'].str.strip()
giantDataFrame['Original_observed_value_units'] = giantDataFrame['Original_observed_value_units'].str.strip()
giantDataFrame['Measurement_code_1'] = giantDataFrame['Measurement_code_1'].str.strip()
giantDataFrame['Measurement_code_2'] = giantDataFrame['Measurement_code_2'].str.strip()
giantDataFrame['Report_type_code'] = giantDataFrame['Report_type_code'].str.strip()
giantDataFrame.dropna(subset=['Observed_value'], inplace=True)
#giantDataFrame['Observed_value'] = giantDataFrame['Observed_value'].astype(int)

######################################################################################################## timezone to GMT
giantDataFrame["Timestamp2"] = giantDataFrame["Year"].map(str) + "-" + giantDataFrame["Month"].map(str)+ "-" + giantDataFrame["Day"].map(str)  
giantDataFrame["Timestamp"] = giantDataFrame["Timestamp2"].map(str)+ " " + giantDataFrame["Hour"].map(str)+":"+giantDataFrame["Minute"].map(str) 
#join offset to sttaion id for tiemstamp conversion
giantDataFrame.drop(columns=["Timestamp2"])
giantDataFrame= giantDataFrame[["Source_ID",'Station_ID',"Station_name","Alias_station_name",  
                                 "Year","Month","Day","Hour","Minute",
                                "Latitude","Longitude","Elevation","Observed_value",
                                "Source_QC_flag","Original_observed_value",
                                "Original_observed_value_units",                                
                                "Report_type_code","Measurement_code_1",
                                "Measurement_code_2", "Timestamp"]]
giantDataFrame['Timestamp'] =  pd.to_datetime(giantDataFrame['Timestamp'], format='%Y/%m/%d' " ""%H:%M")
giantDataFrame['Timestamp'] = giantDataFrame['Timestamp'].dt.tz_localize('Etc/GMT+1').dt.tz_convert('GMT')

#split the (GMT)  timestampinto columns 
giantDataFrame['Year'] = giantDataFrame['Timestamp'].dt.year 
giantDataFrame['Month'] = giantDataFrame['Timestamp'].dt.month 
giantDataFrame['Day'] = giantDataFrame['Timestamp'].dt.day 
giantDataFrame['Hour'] = giantDataFrame['Timestamp'].dt.hour 
giantDataFrame['Minute'] = giantDataFrame['Timestamp'].dt.minute 
##delete unwanted columns 
giantDataFrame = giantDataFrame.drop(columns="Timestamp")

##round values

giantDataFrame['Year']= round(giantDataFrame['Year'])
giantDataFrame['Month']= round(giantDataFrame['Month'])
giantDataFrame['Day']= round(giantDataFrame["Day"])
giantDataFrame['Hour']= round(giantDataFrame['Hour'])
giantDataFrame['Minute']= round(giantDataFrame['Minute'])
giantDataFrame['Minute']= "00"

giantDataFrame = giantDataFrame[["Source_ID",'Station_ID',"Station_name","Alias_station_name",  
                                 "Year","Month","Day","Hour","Minute",
                                "Latitude","Longitude","Elevation","Observed_value",
                                "Source_QC_flag","Original_observed_value",
                                "Original_observed_value_units",                                
                                "Report_type_code","Measurement_code_1",
                                "Measurement_code_2"]]
giantDataFrame['Elevation'] = giantDataFrame['Elevation'].astype(int)
############################################################
#write one large pipe delimited file with all stations combined if same station named by station_id+ variable name
 
#stationsAsBigList =  giantDataFrame["Station_ID"].tolist()
#.to_csv('CHN01000_station_level_pressure_321.psv',sep='|',index=False)
##CHANGE OUTPUT FOLDR AND OUTPUT FILE NAME
####################to csv by unique staion id
os.chdir(r"D:/Other_Sub_Daily_Data_inventory_pending/Cameroon_dwd/IFF/station_level_pressure/") 
cats = sorted(giantDataFrame['Station_ID'].unique())
for cat in cats:
    outfilename = cat + "_station_level_pressure_350_h.psv"
    print(outfilename)
    giantDataFrame[giantDataFrame["Station_ID"] == cat].to_csv(outfilename,sep='|',index=False)
############################################################
##write out separate pipe delimited files by station id
#stationsAsBigList =  giantDataFrame["Station_ID"].tolist()
#stationList= list(set(stationsAsBigList))
#for station in stationList:
  #  print(type(station))
   # currentDataFrame = giantDataFrame[giantDataFrame['Station_ID'] == station]
   # currentDataFrame.to_csv(station + "_pressure.csv",sep=",",index=False)
#giantDataFrame2 = giantDataFrame[["Station_ID","Station_name",  
                                #  "Year","Month","Day",]]

#giantDataFrame2.to_csv("errors.csv",index=False)