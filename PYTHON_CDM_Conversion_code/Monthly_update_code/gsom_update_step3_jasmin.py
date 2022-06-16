#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Aug 27 09:40:50 2020

@author: snoone
"""
# remove all unwanted files after processing
import os
import glob

files = glob.glob('/gws/nopw/j04/c3s311a_lot2/data/incoming/monthly_gsom_update/out/*.csv')
for f in files:
    os.remove(f)

files = glob.glob('/gws/nopw/j04/c3s311a_lot2/data/incoming/monthly_gsom_update/out2/*.csv')
for f in files:
    os.remove(f)

files = glob.glob('/gws/nopw/j04/c3s311a_lot2/data/incoming/monthly_gsom_update/*.gz')
for f in files:
    os.remove(f)