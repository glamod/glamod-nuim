#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Subroutines for sub-daily QFF to CDM conversion scripts

@author: rjhd2
"""

import pandas as pd

SOURCE_FLAGS = {
    "0" : "c",
    "6" : "n",
    "7" : "t",
    "A" : "224",
    "c" : "161",
    "n" : "162",
    "t" : "120",
    "A" : "224",
    "a" : "225",
    "B" : "159",
    "b" : "226",
    "C" : "227",
    "D" : "228",
    "E" : "229",
    "F" : "230",
    "G" : "231",
    "H" : "160",
    "I" : "232",
    "K" : "233",
    "M" : "234",
    "N" : "235",
    "Q" : "236",
    "R" : "237",
    "r" : "238",
    "S" : "166",
    "s" : "239",
    "T" : "240",
    "U" : "241",
    "u" : "242",
    "W" : "163",
    "X" : "164",
    "Z" : "165",
    "z" : "243",
    "m" : "196",
}

UNITS = {
    "SNWD" : "715",
    "PRCP" : "710",
    "TMIN" : "5",
    "TMAX" : "5",
    "TAVG" : "5",
    "SNOW" : "710",
    "AWND" : "320",
    "AWDR" : "731",
    "WESD" : "710",
}

HEIGHTS = {
    "SNWD" : "1",
    "PRCP" : "1",
    "TMIN" : "2",
    "TMAX" : "2",
    "TAVG" : "2",
    "SNOW" : "1",
    "AWND" : "10",
    "AWDR" : "10",
    "WESD" : "1",
}

VALUE_SIGNIFICANCE = {
    "SNWD" : "13",
    "PRCP" : "13",
    "TMIN" : "1",
    "TMAX" : "0",
    "TAVG" : "2",
    "SNOW" : "13",
    "AWND" : "2",
    "AWDR" : "2",
    "WESD" : "13",
}

VARIABLE_ID = {
    "SNWD" : "53",
    "PRCP" : "44",
    "TMIN" : "85",
    "TMAX" : "85",
    "TAVG" : "85",
    "SNOW" : "45",
    "AWND" : "107",
    "AWDR" : "106",
    "WESD" : "55",
}

QUALITY_FLAGS = {
    'D' : '1',
    'G' : '1',
    'I' : '1',
    'K' : '1',
    'L' : '1',
    'M' : '1',
    'N' : '1',
    'O' : '1',
    'R' : '1',
    'S' : '1',
    'T' : '1',
    'W' : '1',
    'X' : '1',
    'Z' : '1',
    'H' : '1',
    'P' : '1',
}

def add_data_policy(var_frame, policy_frame):
    """
    Merge in data policy information from another dataframe

    var_frame : `dataframe`
        Dataframe for variable

    policy_frame : `dataframe`
        Dataframe for the data policy
    """

    var_frame = var_frame.astype(str)

    # merge policy frame into var_frame
    var_frame = policy_frame.merge(var_frame, on=['primary_station_id_2'])

    # rename column and remove ".0"
    var_frame['data_policy_licence'] = var_frame['data_policy_licence_x']

    var_frame['data_policy_licence'] = var_frame['data_policy_licence'].astype(str).apply(lambda x: x.replace('.0',''))

    return var_frame
