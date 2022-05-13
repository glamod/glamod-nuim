import pytest
import numpy as np

from hourly_qff_to_cdm_utils import *



def test_construct_extra_ids():

    var_frame = pd.DataFrame() 
    var_name = "temperature"
    all_frame = pd.DataFrame() 
    all_frame[f"{var_name}_Source_Code"] = ["999"]
    all_frame[f"{var_name}_Source_Station_ID"] = ["CMAN123456.0"]

    var_frame = construct_extra_ids(var_frame, all_frame, var_name)

    assert var_frame["source_id"][0] == "999"
    assert var_frame["secondary_id"][0] == "CMAN123456"


def test_extract_qc_info():

    var_frame = pd.DataFrame() 
    var_name = "temperature"
    all_frame = pd.DataFrame() 
    all_frame[f"{var_name}_QC_flag"] = ["999"]

    var_frame = extract_qc_info(var_frame, all_frame, var_name)

    assert var_frame["quality_flag"][0] == 1
    assert var_frame["qc_method"][0] == "999"


def test_overwrite_variable_info_temperature():

    var_frame = pd.DataFrame()
    var_frame["test"] = ["999"]
    var_name = "temperature"

    var_frame = overwrite_variable_info(var_frame, var_name)

    assert var_frame["observation_height_above_station_surface"][0] == "2"
    assert var_frame["units"][0] == "5"
    assert var_frame["observed_variable"][0] == "85"

def test_overwrite_variable_info_dp_temperature():

    var_frame = pd.DataFrame()
    var_frame["test"] = ["999"]
    var_name = "dew_point_temperature"

    var_frame = overwrite_variable_info(var_frame, var_name)

    assert var_frame["observation_height_above_station_surface"][0] == "2"
    assert var_frame["units"][0] == "5"
    assert var_frame["observed_variable"][0] == "36"

def test_overwrite_variable_info_slp():

    var_frame = pd.DataFrame()
    var_frame["test"] = ["999"]
    var_name = "sea_level_pressure"

    var_frame = overwrite_variable_info(var_frame, var_name)

    assert var_frame["observation_height_above_station_surface"][0] == "2"
    assert var_frame["units"][0] == "32"
    assert var_frame["observed_variable"][0] == "58"

def test_overwrite_variable_info_stnlp():

    var_frame = pd.DataFrame()
    var_frame["test"] = ["999"]
    var_name = "station_level_pressure"

    var_frame = overwrite_variable_info(var_frame, var_name)

    assert var_frame["observation_height_above_station_surface"][0] == "2"
    assert var_frame["units"][0] == "32"
    assert var_frame["observed_variable"][0] == "57"

def test_overwrite_variable_info_wind_speed():

    var_frame = pd.DataFrame()
    var_frame["test"] = ["999"]
    var_name = "wind_speed"

    var_frame = overwrite_variable_info(var_frame, var_name)

    assert var_frame["observation_height_above_station_surface"][0] == "10"
    assert var_frame["units"][0] == "731"
    assert var_frame["observed_variable"][0] == "107"

def test_overwrite_variable_info_wind_dir():

    var_frame = pd.DataFrame()
    var_frame["test"] = ["999"]
    var_name = "wind_direction"

    var_frame = overwrite_variable_info(var_frame, var_name)

    assert var_frame["observation_height_above_station_surface"][0] == "10"
    assert var_frame["units"][0] == "320"
    assert var_frame["observed_variable"][0] == "106"


def test_remove_missing_data_rows_temperature():
    var_frame = pd.DataFrame() 
    var_name = "temperature"
    var_frame["observation_value"] = [np.nan, 1, 2, 3, np.nan]
    var_frame["secondary_id"] = [0, 1, np.nan, 3, 4]
    var_frame["source_id"] = ["9", "8", "7", "6", "5"]

    var_frame = remove_missing_data_rows(var_frame, var_name)

    assert var_frame["observation_value"][0] == "-99999"
    assert var_frame["observation_value"][1] == 1.0
    assert var_frame["secondary_id"][2] == "-99999"
    assert var_frame["source_id"][0] == 9
    
def test_remove_missing_data_rows_wind_speed():
    var_frame = pd.DataFrame() 
    var_name = "wind_speed"
    var_frame["observation_value"] = [np.nan, 1, 2, 3, np.nan]
    var_frame["secondary_id"] = [0, 1, np.nan, 3, 4]
    var_frame["source_id"] = ["9", "8", "7", "6", "5"]

    var_frame = remove_missing_data_rows(var_frame, var_name)

    assert var_frame["observation_value"][0] == "-999"
    assert var_frame["observation_value"][1] == 1.0
    assert var_frame["secondary_id"][2] == "-999"
    assert var_frame["source_id"][0] == 9
    

def test_add_data_policy():

    policy_frame = pd.DataFrame()
    policy_frame["primary_station_id_2"] = ["primary_id_2_1", "primary_id_2_2"]
    policy_frame["record_number"] = ["2", "1"]
    policy_frame["data_policy_licence"] = [1.0, 2.0]

    var_frame = pd.DataFrame() 
    var_frame["primary_station_id_2"] = ["primary_id_2_1", "primary_id_2_1"]
    var_frame["observation_value"] = [1, 2]
    var_frame["data_policy_licence"] = ["", ""]

    var_frame = add_data_policy(var_frame, policy_frame)

    assert list(var_frame["data_policy_licence"]) == ["1", "1"]

def test_construct_obs_id():

    var_frame = pd.DataFrame() 
    var_frame["primary_station_id"] = ["primary_id"]
    var_frame["date_time"] = ["2015-08-08 17:00:00+00"]
    var_frame["record_number"] = ["9999"]
    var_frame["observed_variable"] = ["000"]
    var_frame["value_significance"] = ["456"]

    var_frame = construct_obs_id(var_frame)

    assert var_frame["observation_id"][0] == "primary_id-9999-2015-08-08-17:00-000-456"

def test_fix_decimal_places():

    var_frame = pd.DataFrame() 
    var_frame["source_id"] = ["223.0"]
    var_frame["data_policy_licence"] = ["1.0"]

    var_frame = fix_decimal_places(var_frame, do_obs_value=False)

    assert var_frame["source_id"][0] == 223
    assert var_frame["data_policy_licence"][0] == "1"


def test_fix_decimal_places_obs():

    var_frame = pd.DataFrame() 
    var_frame["source_id"] = ["223.0"]
    var_frame["data_policy_licence"] = ["1.0"]
    var_frame["observation_value"] = ["1.2345"]

    var_frame = fix_decimal_places(var_frame)

    assert var_frame["observation_value"][0] == 1.23
    
