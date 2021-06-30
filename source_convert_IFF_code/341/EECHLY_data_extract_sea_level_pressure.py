
# -*- coding: utf-8 -*-
"""
Created on Tue Mar 19 09:02:55 2019

@author: 67135099
"""
##reads all the files in the current working directory, make sure only input files are in folder
import os

import pandas as pd

os.chdir("D:/EEC_canadian_hourly/ccrp.tor.ec.gc.ca/NAS_ClimateData_FlatFiles/HLY/HLY01/1953")
files = [ f for f in os.listdir( os.curdir ) if os.path.isfile(f) ]
files
firstFile = files[0]
firstFile

####################################################################################################
#Now we can combine all of the data from all of the files into a single data frame


giantListOfDictionaries = []
for currentFile in files:
    with open(currentFile, "r") as theFirstFile:
        for line in theFirstFile:
            field1 = line[0:7]
            field2 = line[7:11]
            field3 = line[11:13]
            field4 = line[13:15]
            field5 = line[15:18]
            field6 = line[18:25]
            field7 = line[25:32]
            field8 = line[32:39]
            field9 = line[39:46]
            field10 = line[46:53]
            field11= line[53:60]
            field12 = line[60:67]
            field13 = line[67:74]
            field14 = line[74:81]
            field15 = line[81:88]
            field16 = line[88:95]
            field17 = line[95:102]
            field18 = line[102:109]
            field19 = line[109:116]
            field20 = line[116:123]
            field21 = line[123:130]
            field22 = line[130:137]
            field23 = line[137:144]
            field24= line[144:151]
            field25 = line[151:158]
            field26 = line[158:165]
            field27 = line[165:172]
            field28 = line[172:179]
            field29 = line[179:186]
            
            
          

            
            currentDictionary = {"File_name": currentFile,'Station_ID': field1, 
                                 "Year": field2,"Month": field3,"Day": field4,"Variable": field5,"1":field6,
                                "2":field7,"3":field8,"4":field9,"5":field10,"6":field11,"7":field12,"8":field13
                                ,"9":field14,"10":field15,"11":field16,"12":field17,"13":field18,"14":field19,"15":field20
                                ,"16":field21,"17":field22,"18":field23,"19":field24,"20":field25,"21":field26,"22":field27
                                ,"23":field28,"00":field29}
            giantListOfDictionaries.append(currentDictionary)
            
            




#create a dataframe from dictionary
df = pd.DataFrame(giantListOfDictionaries)


#Delete the unwanted first column File name
df=df.drop("File_name",axis=1)
df1=df.loc[df["Variable"] == "073"] 
##add_source_id  
df1["Source_ID"] = "341"
df1["Elevation"] = "-9999"
df1 = df1.reindex(columns=['Station_ID', "Year","Month","Day","Variable","1",
                                "2","3","4","5","6","7","8","9","10","11","12","13","14","15",
                                "16","17","18","19","20","21","22","23","00"])

df1["Elevation"] = "-9999"

#merge with station details files
#######################
df2=pd.read_csv("Stations.csv")
df1 = df1.astype(str) 
df2 = df2.astype(str)

#match up columns in output with station name files and add station names NB diff 
#sources for smame station with diff ids
result = df2.merge(df1, on=['Station_ID'])
result['Station_ID2'] = result['Station_ID']
del result ["Station_ID"]
result= result.rename(columns=({'Station_ID2':'Station_ID'}))

result["Source_ID"] = "341"

result["Elevation"] = "-9999"
result = result.replace({"-99999M":"",})


#result.to_csv("mslp_1953.csv",index=False)
################################################################################

##write out separate pipe delimited files by station id to working directory namd by station_id+ variable name+sourceid need to change with each new source
os.chdir(r"D:/EEC_canadian_hourly/2000_10/mslp")
cats = sorted(result['Station_ID'].unique())
for cat in cats:
    outfilename = cat + "_sea_level_pressure_2009.csv"
    print(outfilename)
    result[result["Station_ID"] == cat].to_csv(outfilename,sep=',',index=False)


###########################################################station_pressure
df1=df.loc[df["Variable"] == "077"] 
##add_source_id  
df1["Source_ID"] = "341"
df1["Elevation"] = "-9999"
df1 = df1.reindex(columns=['Station_ID', "Year","Month","Day","Variable","1",
                                "2","3","4","5","6","7","8","9","10","11","12","13","14","15",
                                "16","17","18","19","20","21","22","23","00"])

df1["Elevation"] = "-9999"

#merge with station details files
df2=pd.read_csv("D:/EEC_canadian_hourly/ccrp.tor.ec.gc.ca/NAS_ClimateData_FlatFiles/HLY/HLY01/1953/Stations.csv")
df1 = df1.astype(str) 
df2 = df2.astype(str)

#match up columns in output with station name files and add station names NB diff 
#sources for smame station with diff ids
result = df2.merge(df1, on=['Station_ID'])
result['Station_ID2'] = result['Station_ID']
del result ["Station_ID"]
result= result.rename(columns=({'Station_ID2':'Station_ID'}))

result["Source_ID"] = "341"

result["Elevation"] = "-9999"
result = result.replace({"-99999M":"",})


##write out separate pipe delimited files by station id to working directory namd by station_id+ variable name+sourceid need to change with each new source
os.chdir(r"D:/EEC_canadian_hourly/2000_10/slp")
cats = sorted(result['Station_ID'].unique())
for cat in cats:
    outfilename = cat + "_station_pressure_2009.csv"
    print(outfilename)
    result[result["Station_ID"] == cat].to_csv(outfilename,sep=',',index=False)
    

###########################################################wind_speed
df1=df.loc[df["Variable"] == "076"] 
##add_source_id  
df1["Source_ID"] = "341"
df1["Elevation"] = "-9999"
df1 = df1.reindex(columns=['Station_ID', "Year","Month","Day","Variable","1",
                                "2","3","4","5","6","7","8","9","10","11","12","13","14","15",
                                "16","17","18","19","20","21","22","23","00"])

df1["Elevation"] = "-9999"

#merge with station details files

df2=pd.read_csv("D:/EEC_canadian_hourly/ccrp.tor.ec.gc.ca/NAS_ClimateData_FlatFiles/HLY/HLY01/1953/Stations.csv")
df1 = df1.astype(str) 
df2 = df2.astype(str)

#match up columns in output with station name files and add station names NB diff 
#sources for smame station with diff ids
result = df2.merge(df1, on=['Station_ID'])
result['Station_ID2'] = result['Station_ID']
del result ["Station_ID"]
result= result.rename(columns=({'Station_ID2':'Station_ID'}))

result["Source_ID"] = "341"

result["Elevation"] = "-9999"
result = result.replace({"-99999M":"",})

##write out separate pipe delimited files by station id to working directory namd by station_id+ variable name+sourceid need to change with each new source
os.chdir(r"D:/EEC_canadian_hourly/2000_10/ws")
cats = sorted(result['Station_ID'].unique())
for cat in cats:
    outfilename = cat + "_wind_speed_2009.csv"
    print(outfilename)
    result[result["Station_ID"] == cat].to_csv(outfilename,sep=',',index=False)
###########################################################dew_poeint_temperature
df1=df.loc[df["Variable"] == "074"] 
##add_source_id  
df1["Source_ID"] = "341"
df1["Elevation"] = "-9999"
df1 = df1.reindex(columns=['Station_ID', "Year","Month","Day","Variable","1",
                                "2","3","4","5","6","7","8","9","10","11","12","13","14","15",
                                "16","17","18","19","20","21","22","23","00"])

df1["Elevation"] = "-9999"

#merge with station details files
df2=pd.read_csv("D:/EEC_canadian_hourly/ccrp.tor.ec.gc.ca/NAS_ClimateData_FlatFiles/HLY/HLY01/1953/Stations.csv")
df1 = df1.astype(str) 
df2 = df2.astype(str)

#match up columns in output with station name files and add station names NB diff 
#sources for smame station with diff ids
result = df2.merge(df1, on=['Station_ID'])
result['Station_ID2'] = result['Station_ID']
del result ["Station_ID"]
result= result.rename(columns=({'Station_ID2':'Station_ID'}))

result["Source_ID"] = "341"

result["Elevation"] = "-9999"
result = result.replace({"-99999M":"",})

##write out separate pipe delimited files by station id to working directory namd by station_id+ variable name+sourceid need to change with each new source
os.chdir(r"D:/EEC_canadian_hourly/2000_10/dpt")
cats = sorted(result['Station_ID'].unique())
for cat in cats:
    outfilename = cat + "_dew_point_temperature_2009.csv"
    print(outfilename)
    result[result["Station_ID"] == cat].to_csv(outfilename,sep=',',index=False)
###########################################################temperature
df1=df.loc[df["Variable"] == "078"] 
##add_source_id  
df1["Source_ID"] = "341"
df1["Elevation"] = "-9999"
df1 = df1.reindex(columns=['Station_ID', "Year","Month","Day","Variable","1",
                                "2","3","4","5","6","7","8","9","10","11","12","13","14","15",
                                "16","17","18","19","20","21","22","23","00"])

df1["Elevation"] = "-9999"

#merge with station details files

df2=pd.read_csv("D:/EEC_canadian_hourly/ccrp.tor.ec.gc.ca/NAS_ClimateData_FlatFiles/HLY/HLY01/1953/Stations.csv")
df1 = df1.astype(str) 
df2 = df2.astype(str)

#match up columns in output with station name files and add station names NB diff 
#sources for smame station with diff ids
result = df2.merge(df1, on=['Station_ID'])
result['Station_ID2'] = result['Station_ID']
del result ["Station_ID"]
result= result.rename(columns=({'Station_ID2':'Station_ID'}))

result["Source_ID"] = "341"

result["Elevation"] = "-9999"
result = result.replace({"-99999M":"",})

##write out separate pipe delimited files by station id to working directory namd by station_id+ variable name+sourceid need to change with each new source
os.chdir(r"D:/EEC_canadian_hourly/2000_10/tt")
cats = sorted(result['Station_ID'].unique())
for cat in cats:
    outfilename = cat + "_temperature_2009.csv"
    print(outfilename)
    result[result["Station_ID"] == cat].to_csv(outfilename,sep=',',index=False)    

###########################################################relative_humidity
df1=df.loc[df["Variable"] == "080"] 
##add_source_id  
df1["Source_ID"] = "341"
df1["Elevation"] = "-9999"
df1 = df1.reindex(columns=['Station_ID', "Year","Month","Day","Variable","1",
                                "2","3","4","5","6","7","8","9","10","11","12","13","14","15",
                                "16","17","18","19","20","21","22","23","00"])

df1["Elevation"] = "-9999"
#merge with station details files

df2=pd.read_csv("D:/EEC_canadian_hourly/ccrp.tor.ec.gc.ca/NAS_ClimateData_FlatFiles/HLY/HLY01/1953/Stations.csv")
df1 = df1.astype(str) 
df2 = df2.astype(str)

#match up columns in output with station name files and add station names NB diff 
#sources for smame station with diff ids
result = df2.merge(df1, on=['Station_ID'])
result['Station_ID2'] = result['Station_ID']
del result ["Station_ID"]
result= result.rename(columns=({'Station_ID2':'Station_ID'}))

result["Source_ID"] = "341"

result["Elevation"] = "-9999"
result = result.replace({"-99999M":"",})

##write out separate pipe delimited files by station id to working directory namd by station_id+ variable name+sourceid need to change with each new source
os.chdir(r"D:/EEC_canadian_hourly/2000_10/rh")
cats = sorted(result['Station_ID'].unique())
for cat in cats:
    outfilename = cat + "_relative_humidity_2009.csv"
    print(outfilename)
    result[result["Station_ID"] == cat].to_csv(outfilename,sep=',',index=False)    


