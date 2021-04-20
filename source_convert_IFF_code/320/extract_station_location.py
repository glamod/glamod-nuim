# -*- coding: utf-8 -*-
"""
Created on Wed Jul 10 10:22:31 2019

@author: snoone
"""
     ###extract wind direction from TD-13 large csv files and rename columns to IFF
     
import numpy as np
import os   
import pandas as pd

os.chdir ("C:/Users/snoone/Dropbox/PYTHON_TRAINING/NUS_China_weather/")
 
df = pd.read_csv("data_file_test.csv", usecols = ["longitude",
                                          "latitude","elevation",              
                                          "station"]).astype(str)

# add source id column and add source id to columns
df["combine"] = df["station"] + df["latitude"]
df = df.drop_duplicates(subset=['combine'])
df.to_csv("stations.csv",index=False)





##### separate the large csv file by station ID and save as IFF named Station_Id+variable+Source_ID
