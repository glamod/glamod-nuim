#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Subroutines for sub-daily QFF to CDM conversion scripts

@author: rjhd2
"""

import pandas as pd

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
