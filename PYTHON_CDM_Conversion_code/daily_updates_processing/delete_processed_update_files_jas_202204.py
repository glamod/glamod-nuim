# -*- coding: utf-8 -*-
"""
Created on Wed Mar 23 15:32:21 2022

@author: snoone
"""

# delete processed folder from directory
import os 
import glob

# add parent directory to access daily conversion scripts
sys.path.append("../")
import utils

    
# delete processed .gz from directory
files = glob.glob(f'{utils.DAILY_UPDATE_OUTDIR}/*.gz')
for f in files:
    os.remove(f)
