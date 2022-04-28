# -*- coding: utf-8 -*-
"""
Created on Wed Mar 23 15:32:21 2022

@author: snoone
"""

# delete processed folder from directory
import os 
import glob

    
# delete processed .gz from directory
files = glob.glob('/gws/nopw/j04/c3s311a_lot2/data/level0/land/daily_data_processing/ghcnd_diff_updates/*.gz')
for f in files:
    os.remove(f)
