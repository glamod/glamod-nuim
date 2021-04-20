#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Jul 10 10:22:31 2019

@author: snoone
"""
     ###extract wind direction from TD-13 large csv files and rename columns to IFF

import os   
import pandas as pd

os.chdir ("/work/scratch-nompiio/snoone/convert_IFF/YKFeng_NUS_China_324/nuschinaweather/data/")
 
 
df = pd.read_csv("wthr-19121951-annotated.csv", usecols = ["longitude",
                                          "latitude","elevation",              
                                          "station"]).astype(str)

df["combine"] = df["station"] + df["latitude"]
df = df.drop_duplicates(subset=['station'])
# add source id column and add source id to columns

os.chdir ("/work/scratch-nompiio/snoone/convert_IFF/YKFeng_NUS_China_324/nuschinaweather/")
df.to_csv("stations.csv",index=False)





##### separate the large csv file by station ID and save as IFF named Station_Id+variable+Source_ID
