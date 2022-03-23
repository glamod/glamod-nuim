# -*- coding: utf-8 -*-
"""
Created on Wed Mar 23 15:32:21 2022

@author: snoone
"""

# delete processed folder from directory
import os 
import shutil
import glob
import pandas as pd
last_f=pd.read_csv("C:/Users/snoone/Dropbox/PYTHON_TRAINING/NEW_diff_ghcnd_ftp_download/output/last_file.txt","sep=\t", header = None)
# remove unwanted text from the last_f to ceraet the details of the untarred dircetrpy where the  new insert.csv file exists
# need to write that recognises a new daily update directory exists and contimues to process 
last_f.columns=["file"]
filename= last_f[["file"]]
last_f["file"] = last_f["file"].str[:36]
filename["file"] = filename["file"].str[:36]
filename["file"] = filename["file"].str[16:]
filename=filename.iloc[0]["file"]
last_f = last_f.iloc[0]["file"]
dir_path = "C:/Users/snoone/Dropbox/PYTHON_TRAINING/NEW_diff_ghcnd_ftp_download/output/"+last_f

try:
    shutil.rmtree(dir_path)
except OSError as e:
    print("Error: %s : %s" % (dir_path, e.strerror))
    
# delete processed .gz from directory
files = glob.glob('C:/Users/snoone/Dropbox/PYTHON_TRAINING/NEW_diff_ghcnd_ftp_download/output/*.gz')
for f in files:
    os.remove(f)
