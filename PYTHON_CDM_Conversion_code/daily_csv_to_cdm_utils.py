#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Subroutines for sub-daily QFF to CDM conversion scripts

@author: rjhd2
"""
import numpy as np
import pandas as pd

VARIABLE_NAMES = ["SNWD", "PRCP", "TMIN", "TMAX", "TAVG", "SNOW", "AWND", "AWDR", "WESD"]


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
    "AWND" : "731",
    "AWDR" : "320",
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
    "SNWD" : "12",
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

QC_METHODS = {
        "D" : "16,",
        "H" : "30,",
        "G" : "17,",
        "I" : "18,",
        "K" : "19,",
        "M" : "20,",
        "N" : "22,",
        "O" : "23,",
        "R" : "24,",
        "S" : "25,",
        "T" : "26,",
        "W" : "27,",
        "X" : "28,",
        "V" : "12,",
        "Z" : "29,",
        "P" : "30,",

}

ORIGINAL_UNITS = {
    "SNWD" : "715",
    "PRCP" : "710",
    "TMIN" : "350",
    "TMAX" : "350",
    "TAVG" : "350",
    "SNOW" : "710",
    "AWND" : "320",
    "AWDR" : "731",
    "WESD" : "710",
}

CONVERSION_FLAGS = {
    "SNWD" : "2",
    "PRCP" : "2",
    "TMIN" : "0",
    "TMAX" : "0",
    "TAVG" : "0",
    "SNOW" : "2",
    "AWND" : "2",
    "AWDR" : "2",
    "WESD" : "2",
}

NUMERICAL_PRECISION = {
    "SNWD" : "1",
    "PRCP" : "0.1",
    "TMIN" : "0.01",
    "TMAX" : "0.01",
    "TAVG" : "0.01",
    "SNOW" : "0.1",
    "AWND" : "0.1",
    "AWDR" : "0.1",
    "WESD" : "0.1",
}

ORIGINAL_PRECISION = {
    "SNWD" : "1",
    "PRCP" : "0.1",
    "TMIN" : "0.1",
    "TMAX" : "0.1",
    "TAVG" : "0.1",
    "SNOW" : "0.1",
    "AWND" : "0.1",
    "AWDR" : "1",
    "WESD" : "0.1",
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


def convert_values(var_frame, var_name, field_name, kelvin=False):
    """
    Convert values to CDM compliant form

    var_frame : `dataframe`
        Dataframe for variable

    var_name : `str`
        Name of variable

    field_name : `str`
        Name of dataframe field to work on

    kelvin : `bool`
        To convert temperatures to Kelvin or not
    """

    if var_name == "PRCP":
        var_frame[field_name] = np.where(var_frame['observed_variable'] == "PRCP",
                                         var_frame[field_name] / 10,
                                         var_frame[field_name]).round(2)

    elif var_name == "SNWD":
        var_frame[field_name] = np.where(var_frame['observed_variable'] == "SNWD",
                                         var_frame[field_name] / 10,
                                         var_frame[field_name]).round(2)

    elif var_name == "TMIN":
        if kelvin:
            var_frame[field_name] = np.where(var_frame['observed_variable'] == "TMIN",
                                             var_frame[field_name] / 10 + 273.15,
                                             var_frame[field_name]).round(2)
        else:
            var_frame[field_name] = np.where(var_frame['observed_variable'] == "TMIN",
                                             var_frame[field_name] / 10,
                                             var_frame[field_name]).round(2)

    elif var_name == "TMAX":
        if kelvin:
            var_frame[field_name] = np.where(var_frame['observed_variable'] == "TMAX",
                                             var_frame[field_name] / 10 + 273.15,
                                             var_frame[field_name]).round(2)
        else:
            var_frame[field_name] = np.where(var_frame['observed_variable'] == "TMAX",
                                             var_frame[field_name] / 10,
                                             var_frame[field_name]).round(2)
    elif var_name == "TAVG":
        if kelvin:
            var_frame[field_name] = np.where(var_frame['observed_variable'] == "TAVG",
                                             var_frame[field_name] / 10 + 273.15,
                                             var_frame[field_name]).round(2)
        else:
            var_frame[field_name] = np.where(var_frame['observed_variable'] == "TAVG",
                                             var_frame[field_name] / 10,
                                             var_frame[field_name]).round(2)
    elif var_name == "SNOW":
        var_frame[field_name] = np.where(var_frame['observed_variable'] == 'SNOW',
                                         var_frame[field_name] / 10,
                                         var_frame[field_name]).round(2)
    elif var_name == "WESD":
        var_frame[field_name] = np.where(var_frame['observed_variable'] == 'WESD',
                                         var_frame[field_name] / 10,
                                         var_frame[field_name]).round(2)  
    elif var_name == "AWND":
        pass

    elif var_name == "AWDR":
        pass
    else:
        print(f"Invalid variable name {var_name}")


    return var_frame
