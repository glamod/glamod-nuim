# -*- coding: utf-8 -*-
"""
Created on Thu Aug 21 10:53:35 2025

@author: snoone
"""

import os
import glob

DATA_DIR = "C:/Users/snoone/Dropbox/Copernicus_2021/admin/8th_data_release/parquet_r8/pressure/test_files"
files = glob.glob(os.path.join(DATA_DIR, "*.psv*"))  # matches .psv and .psv.gz

total_rows = 0

for f in files:
    if f.endswith(".gz"):
        import gzip
        with gzip.open(f, "rt") as fh:
            rows = sum(1 for _ in fh)
    else:
        with open(f, "r") as fh:
            rows = sum(1 for _ in fh)
    total_rows += rows

print(f"🧮 Total rows across all .psv files: {total_rows}")
