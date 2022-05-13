import pytest

from hourly_qff_to_cdm_lite_v1 import *


def test_construct_report_type():
    # ICAO==4, all others ==0
    var_frame = pd.DataFrame() 
    all_frame = pd.DataFrame() 
    id_field = "ID"
    all_frame[id_field] = ["ICAO123456",
                       "AFWA123456",
                       "CMAN123456",
                       "WMO9123456"]

    var_frame = construct_report_type(var_frame, all_frame, id_field)

    assert list(var_frame["report_type"]) == ["4", "0", "0", "0"]


def test_construct_qc_df():

    var_frame = pd.DataFrame() 
    var_frame["primary_station_id"] = ["primary_id"]
    var_frame["report_id"] = ["ICAO123456"]
    var_frame["record_number"] = ["9999"]
    var_frame["qc_method"] = ["1234"]
    var_frame["quality_flag"] = ["-999"]
    var_frame["observed_variable"] = ["000"]
    var_frame["value_significance"] = ["456"]

    qc_frame = construct_qc_df(var_frame)

    assert list(qc_frame.columns) == ["report_id",
                                      "observation_id",
                                      "qc_method",
                                      "quality_flag"]
    assert qc_frame["observation_id"][0] == "primary_id-9999-ICAO123456-000-456"
    assert qc_frame["report_id"][0] == "primary_id-ICAO"
    assert qc_frame["quality_flag"][0] == -999
    assert qc_frame["qc_method"][0] == "1234"

    
