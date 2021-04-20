# -*- coding: utf-8 -*-
"""
Created on Thu Sep 10 11:24:30 2020

@author: snoone
"""



import os
import glob
import pandas as pd
import csv



os.chdir("D:/Adelaide_obseravations_1876_97_sbdy/IFF/wetb")
extension = 'psv'
all_filenames = [i for i in glob.glob('*.{}'.format(extension))]
#combine all files in the list
df = pd.concat([pd.read_csv(f,delimiter='|') for f in all_filenames])
df["Source_ID"] = 334
df["Station_ID"] = "334-00001"
#all_filenames = [i for i in glob.glob('*.{}'.format(extension))]
#for filename in all_filenames:
    #df = pd.read_csv(filename, sep='|')
     
    
df.to_csv("output.csv",index=False)

#############separate by obseravtion flag 0=mb 1=mb no hundreths digits

with open('output.csv') as fin:    
    csvin = csv.DictReader(fin)
    os.chdir("D:/Adelaide_obseravations_1876_97_sbdy/IFF/wetb")
    #csvin.columns = [x.replace(' ', '_') for x in csvin.columns]  
    # Category -> open file lookup
    outputs = {}
    for row in csvin:
        cat = row['Station_ID']
        # Open a new file and write the header
        if cat not in outputs:
            fout = open ('{}_wet_bulb_temperature_334.psv'.format(cat), "w", newline = "")
            dw = csv.DictWriter(fout, fieldnames=csvin.fieldnames,delimiter='|')
            dw.writeheader()
            outputs[cat] = fout, dw
        # Always write the row
        outputs[cat][1].writerow(row)
    # Close all the files
    for fout, _ in outputs.values():
        fout.close()
        