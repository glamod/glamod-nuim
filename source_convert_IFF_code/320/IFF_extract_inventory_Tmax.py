
#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Aug 14 09:23:45 2019

@author: snoone
"""

import os
import glob
import pandas as pd
import csv

##import all psv files in current dir
os.chdir ("/work/scratch-nompiio/snoone/convert_IFF/YKFeng_NUS_China_324/nuschinaweather/output/maximum_temperature/324")
extension = 'psv'

all_filenames = [i for i in glob.glob('*.{}'.format(extension))]

for filename in all_filenames:
    df = pd.read_csv(filename ,delimiter='|')
    df2= df.iloc[[0],[0,1,2,4,9,10,11]]
    df3= df.iloc[[-1],[4]]
    df3['Year'].values
    df2['End_Year'] = df3["Year"].values
    df2 = df2[["Source_ID",'Station_ID',"Station_name","Latitude","Longitude",
             "Elevation","Year","End_Year"]]
    df2.to_csv("combined.csv",index=False,sep = ',')
    
    #open combined csv and separate and rename files as per by station_id 
    with open('combined.csv') as fin:    
        csvin = csv.DictReader(fin)
        os.chdir ("/work/scratch-nompiio/snoone/convert_IFF/YKFeng_NUS_China_324/nuschinaweather/output/maximum_temperature/inventory")
        #csvin.columns = [x.replace(' ', '_') for x in csvin.columns]  
        # Category -> open file lookup
        outputs = {}
        for row in csvin:
            cat = row['Station_ID']
            # Open a new file and write the header
            if cat not in outputs:
                fout = open ('{}_inventory.csv'.format(cat), "w", newline = "")
                dw = csv.DictWriter(fout, fieldnames=csvin.fieldnames,delimiter=',')
                dw.writeheader()
                outputs[cat] = fout, dw
            # Always write the row
            outputs[cat][1].writerow(row)        # Close all the files
        for fout, _ in outputs.values():
            fout.close()
        
#os.remove('combined.csv')
#os.remove('_inventory.csv')            
os.chdir(os.curdir)
extension = 'csv'
all_filenames = [i for i in glob.glob('*.{}'.format(extension))]
#combine all files in the list
df = pd.concat([pd.read_csv(f,delimiter=',') for f in all_filenames])
#dewpointtemp df['Observed_value']= round(df['Observed_value'],1)
df.to_csv("master_inventory_maxT.csv",index=False)