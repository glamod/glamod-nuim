
# -*- coding: utf-8 -*-
"""
Created on Tue Mar 19 09:02:55 2019

@author: 67135099
"""
##reads all the files in the current working directory, make sure only input files are in folder
import os
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

import pandas as pd
giantListOfDictionaries = []
for currentFile in files:
    with open(currentFile, "r") as theFirstFile:
        for line in theFirstFile:
            field1 = line[0:13]
            field2 = line[18:22]
            field3 = line[22:24]
            field4 = line[24:26]
            field5 = line[26:28]
            field6 = line[28:30]
            field7 = line[40:46]
            field8 = line[46:52]
            field9 = line[52:56]
            field10 = line[64:71]
            field11 = line[71:72]
            field12 = line[89:98]
            field13 = line[98:106]
            field14 = line[169:170]
            field15 = line[347:353]
            field16 = line[354:359]
            field17 = line[369:399]
            field18 = line[369:399]
            field19 = line[316:317]
          

            
            currentDictionary = {"File_name": currentFile,'Station_ID': field1, 
                                 "Year": field2,"Month": field3,"Day": field4,"Hour": field5,"Minute":field6,
                                "Latitude":field7,"Longitude":field8,"Elevation":field9,"Observed_value":field10,
                                "Source_QC_flag":field11,"Original_observed_value":field12,
                                "Original_observed_value_units":field13,
                                "Gravity_corrected_by_source":field14,
                                "Source_ID":field15,
                                "Report_type_code":field16,"Station_name":field17,
                                "Alias_station_name":field18,"Homogenization_corrected_by_source":field19}
          giantListOfDictionaries.append(currentDictionary)
            
#length of file
len(giantListOfDictionaries)


#create a dataframe from dictionary
giantDataFrame = pd.DataFrame(giantListOfDictionaries)
giantDataFrame
#Delete the unwanted first column File name
giantDataFrame=giantDataFrame.drop("File_name",axis=1)

###set order of cloumns headers in dataframe
giantDataFrame=giantDataFrame[["Source_ID",'Station_ID',"Station_name","Alias_station_name",  
                                 "Year","Month","Day","Hour","Minute",
                                "Latitude","Longitude","Elevation","Observed_value",
                                "Source_QC_flag","Original_observed_value",
                                "Original_observed_value_units",
                                "Gravity_corrected_by_source",
                                "Homogenization_corrected_by_source",
                                "Report_type_code"]]
###########################################################################################                                
#replace missing data values in the dataframe with NUlL

giantDataFrame = giantDataFrame.replace({"9999.99":"Null",
                                             "99999":"Null",
                                             "9999999999999":"Null",
                                             "999999999":"Null",
                                             "99999999":"Null"})
##################################################################################
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
giantDataFrame['Latitude'] = giantDataFrame['Latitude'].str.strip()
giantDataFrame['Longitude'] = giantDataFrame['Longitude'].str.strip()
giantDataFrame['Elevation'] = giantDataFrame['Elevation'].str.strip()
giantDataFrame['Observed_value'] = giantDataFrame['Observed_value'].str.strip()
giantDataFrame['Source_QC_flag'] = giantDataFrame['Source_QC_flag'].str.strip()
giantDataFrame['Original_observed_value'] = giantDataFrame['Original_observed_value'].str.strip()
giantDataFrame['Original_observed_value_units'] = giantDataFrame['Original_observed_value_units'].str.strip()
giantDataFrame['Gravity_corrected_by_source'] = giantDataFrame['Gravity_corrected_by_source'].str.strip()
giantDataFrame['Homogenization_corrected_by_source'] = giantDataFrame['Homogenization_corrected_by_source'].str.strip()
giantDataFrame['Report_type_code'] = giantDataFrame['Report_type_code'].str.strip()

########################################################################################################

############################################################
#write one large pipe delimited file with all stations combined if same station named by station_id+ variable name
stationsAsBigList =  giantDataFrame["Station_ID"].tolist()
giantDataFrame.to_csv('liverpool_station_pressure.psv',sep='|',index=False)
############################################################
##write out separate pipe delimited files by station id
#stationsAsBigList =  giantDataFrame["Station_ID"].tolist()
#stationList= list(set(stationsAsBigList))
#for station in stationList:
  #  print(type(station))
   # currentDataFrame = giantDataFrame[giantDataFrame['Station_ID'] == station]
   # currentDataFrame.to_csv(station + "_pressure.csv",sep=",",index=False)


