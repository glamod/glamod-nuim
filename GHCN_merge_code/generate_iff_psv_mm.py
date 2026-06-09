# -*- coding: utf-8 -*-
"""
Created on Tue Jun  9 09:01:43 2026

@author: mmenne
"""

##generate_iff_psv.py

import os
import re
import csv
import glob
import gc
import sys
import shutil
import math
import pandas as pd
from datetime import datetime, timezone, timedelta
from eccodes import * # Suppress standard ecCodes GTS truncation/length errors

# ==========================================
# --- CONFIGURATION & PATH MANAGEMENT ---
# ==========================================
INPUT_DIR = "/ghcn-hourly/gts_backup"      
BASE_IFF_DIR = "/dataprocess/ghcnh/IFFs"         
METADATA_CSV = "/dataprocess/ghcnh/metadata/usaf-swo-03_20250915_STNMETADATA.csv"

IFF_HEADERS = [
    "Source_ID", "Station_ID", "Station_name", "Alias_station_name", 
    "Year", "Month", "Day", "Hour", "Minute", "Latitude", "Longitude", "Elevation", 
    "Observed_value", "Source_QC_flag", "Original_observed_value", 
    "Original_observed_value_units", "Report_type_code", 
    "Measurement_code_1", "Measurement_code_2"
]

# ==========================================
# --- PRE-COMPILED REGEX PATTERNS ---
# ==========================================
FILE_DATE_PATTERN = re.compile(r'_(\d{4})(\d{2})(\d{2})_')

# METAR Patterns
METAR_STATION_PATTERN = re.compile(r'\b([A-Z0-9]{4})\s+(\d{2})(\d{2})(\d{2})Z\b')
METAR_T_GROUP_PATTERN = re.compile(r'\bT([01])(\d{3})(?:([01])(\d{3}))?\b')
METAR_STD_TEMP_PATTERN = re.compile(r'\b(M?\d{2})/(M?\d{2})?(?:\s|$)')
METAR_WIND_PATTERN = re.compile(r'\b(\d{3}|VRB)(\d{2,3})(?:G(\d{2,3}))?(KT|MPS)\b')
METAR_VIS_PATTERN = re.compile(r'\b(\d+)?\s*(\d+/\d+)?SM\b')
METAR_VIS_INTL_PATTERN = re.compile(r'\b(\d{4})\b')
METAR_ALT_PATTERN = re.compile(r'\b[AQ](\d{4})\b')
METAR_SLP_PATTERN = re.compile(r'\bSLP(\d{3})\b')
METAR_P_PATTERN = re.compile(r'(?:\s|^)P(\d{4})(?:\s|$)') # Hourly Precip
METAR_SNOW_PATTERN = re.compile(r'\b4/(\d{3})\b') # Snow Depth
METAR_P3HR_PATTERN = re.compile(r'\b5([0-8])(\d{3})\b') # Pressure 3hr Change
METAR_MAX_T_PATTERN = re.compile(r'\b1([01])(\d{3})\b') # 6-Hr Max Temp Group
METAR_MIN_T_PATTERN = re.compile(r'\b2([01])(\d{3})\b') # 6-Hr Min Temp Group
METAR_CLOUD_PATTERN = re.compile(r'\b(SKC|CLR|CAVOK|NSC|NCD|VV\d{3}|(?:FEW|SCT|BKN|OVC)\d{3}(?:CB|TCU)?)\b')

# SYNOP Patterns
SYNOP_ID_PATTERN = re.compile(r'\b(\d{5})\b')
SYNOP_T_PATTERN = re.compile(r'\b1([01])(\d{3})\b')
SYNOP_TD_PATTERN = re.compile(r'\b2([01])(\d{3})\b')
SYNOP_P_PATTERN = re.compile(r'\b4(\d{4})\b')
SYNOP_STN_P_PATTERN = re.compile(r'\b3(\d{4})\b') # 3-Group Station Pressure
SYNOP_PRECIP_1HR_PATTERN = re.compile(r'\b6(\d{3})5\b') # 1-Hour Precip (duration t=5)
SYNOP_SNOW_PATTERN = re.compile(r'\b4\d(\d{3})\b') # Snow Depth
SYNOP_P3HR_PATTERN = re.compile(r'\b5([0-8])(\d{3})\b') # Pressure 3hr Change
SYNOP_WX_PATTERN = re.compile(r'\b7(\d{2})(\d|\/)(\d|\/)\b') # Present & Past Weather
SYNOP_NH_PATTERN = re.compile(r'\b[0-4]\d([0-9\/])[0-9\/]{2}\s+([0-9\/])[0-9\/]{4}\b') # iRixhVV Nddff
SYNOP_8_GROUP_PATTERN = re.compile(r'\b8([0-9\/])([0-9\/])([0-9\/])([0-9\/])\b') # 8NhCLCMCH
SYNOP_8_LAYER_PATTERN = re.compile(r'\b8([0-9\/])([0-9\/])([0-9\/]{2}|\/\/)\b') # 8NsCHshs

# ==========================================
# --- TRANSLATION MATRICES ---
# ==========================================

# METAR CLOUD COVER: Maps string to GHCNh Okta Code
CLOUD_COVER_MAP = {
    'SKC': '00', 'CLR': '00', 'CAVOK': '00', 'NSC': '00', 'NCD': '00',
    'FEW': '02', 'SCT': '04', 'BKN': '07', 'OVC': '08', 'VV': '09'
}

# SYNOP CLOUD COVER MAPS
SYNOP_N_OKTA = {'0': '00', '1': '01', '2': '02', '3': '03', '4': '04', '5': '05', '6': '06', '7': '07', '8': '08', '9': '09', '/': '10'}
SYNOP_COVERAGE_MAP = {
    '0': 'CLR:00', '1': 'FEW:01', '2': 'FEW:02', '3': 'SCT:03',
    '4': 'SCT:04', '5': 'BKN:05', '6': 'BKN:06', '7': 'BKN:07',
    '8': 'OVC:08', '9': 'VV:09', '/': 'X:10'
}

# BUFR CLOUD COVER MAP (Includes 15 for Unobservable)
BUFR_OKTA_MAP = {
    0: 'CLR:00', 1: 'FEW:01', 2: 'FEW:02', 3: 'SCT:03',
    4: 'SCT:04', 5: 'BKN:05', 6: 'BKN:06', 7: 'BKN:07',
    8: 'OVC:08', 9: 'VV:09', 15: 'X:10'
}

SYNOP_H_MAP = {
    '0': 30, '1': 75, '2': 150, '3': 250, '4': 450,
    '5': 800, '6': 1250, '7': 1750, '8': 2250, '9': 2500
}

# MW CODES: Maps numeric WMO 4677 codes to abbreviations for SYNOP & BUFR
WMO_4677_TO_ABBR = {
    0: "NONE", 1: "NONE", 2: "NONE", 3: "NONE", 4: "FU", 5: "HZ", 6: "DU", 7: "DU", 8: "DU", 9: "DU",
    10: "BR", 11: "FG", 12: "FG", 13: "VCTS", 14: "VIRGA", 15: "VCSH", 16: "VCSH", 17: "TS", 18: "SQ", 19: "FC",
    20: "DZ", 21: "RA", 22: "SN", 23: "RASN", 24: "FZRA", 25: "SHRA", 26: "SHSN", 27: "SHGR", 28: "FG", 29: "TS",
    30: "DU", 31: "DU", 32: "DU", 33: "DU", 34: "DU", 35: "DU", 36: "DRSN", 37: "DRSN", 38: "BLSN", 39: "BLSN",
    40: "FG", 41: "FG", 42: "FG", 43: "FG", 44: "FG", 45: "FG", 46: "FG", 47: "FG", 48: "FG", 49: "FG",
    50: "DZ", 51: "DZ", 52: "DZ", 53: "DZ", 54: "DZ", 55: "DZ", 56: "FZDZ", 57: "FZDZ", 58: "DZ", 59: "DZ",
    60: "RA", 61: "RA", 62: "RA", 63: "RA", 64: "RA", 65: "RA", 66: "FZRA", 67: "FZRA", 68: "RA", 69: "RA",
    70: "SN", 71: "SN", 72: "SN", 73: "SN", 74: "SN", 75: "SN", 76: "IC", 77: "SG", 78: "SN", 79: "PL",
    80: "SHRA", 81: "SHRA", 82: "SHRA", 83: "SHRASN", 84: "SHRASN", 85: "SHSN", 86: "SHSN", 87: "SH", 88: "SH", 89: "SH", 90: "SH",
    91: "RA", 92: "RA", 93: "SN", 94: "SN", 95: "TS", 96: "TS", 97: "TS", 98: "TS", 99: "TS"
}

# AW CODES: Maps standard METAR strings to (Abbreviation, GHCNh AW Code) Table 5b
METAR_TO_AW_CODE = {
    "BR": ("BR", 10), "FG": ("FG", 30), "FZFG": ("FG", 35), "MIFG": ("FG", 31), "PRFG": ("FG", 31), "VCFG": ("FG", 30),
    "HZ": ("HZ", 4), "FU": ("FU", 5), "VA": ("FU", 5), "DU": ("DU", 7), "SA": ("DU", 7), 
    "BLSN": ("BLSN", 27), "DRSN": ("DRSN", 27), "BLDU": ("DU", 27), "BLSA": ("DU", 27), "PO": ("DU", 7),
    "SS": ("DU", 27), "+SS": ("DU", 27), "DS": ("DU", 27), "+DS": ("DU", 27),
    "-DZ": ("DZ", 51), "DZ": ("DZ", 52), "+DZ": ("DZ", 53),
    "-FZDZ": ("FZDZ", 54), "FZDZ": ("FZDZ", 55), "+FZDZ": ("FZDZ", 56),
    "-RADZ": ("DZ", 57), "RADZ": ("DZ", 58), "+RADZ": ("DZ", 58),
    "-RA": ("RA", 61), "RA": ("RA", 62), "+RA": ("RA", 63),
    "-FZRA": ("FZRA", 64), "FZRA": ("FZRA", 65), "+FZRA": ("FZRA", 66),
    "-SN": ("SN", 71), "SN": ("SN", 72), "+SN": ("SN", 73),
    "-RASN": ("RA", 67), "RASN": ("RA", 68), "+RASN": ("RA", 68),
    "-SG": ("SG", 77), "SG": ("SG", 77), "IC": ("IC", 78), 
    "-PL": ("PL", 74), "PL": ("PL", 75), "+PL": ("PL", 76), "PE": ("PL", 75), 
    "-SHRA": ("SHRA", 81), "SHRA": ("SHRA", 82), "+SHRA": ("SHRA", 83),
    "-SHSN": ("SHSN", 85), "SHSN": ("SHSN", 86), "+SHSN": ("SHSN", 87),
    "-SHRASN": ("SHRA", 81), "SHRASN": ("SHRA", 82), "+SHRASN": ("SHRA", 83),
    "GS": ("SH", 89), "+GS": ("SH", 89), "SHGS": ("SH", 89), 
    "GR": ("SH", 89), "+GR": ("SH", 89), "SHGR": ("SH", 89),
    "TS": ("TS", 90), "VCTS": ("TS", 91),
    "-TSRA": ("TS", 92), "TSRA": ("TS", 92), "+TSRA": ("TS", 95),
    "-TSSN": ("TS", 92), "TSSN": ("TS", 92), "+TSSN": ("TS", 95),
    "TSGR": ("TS-HAIL", 93), "+TSGR": ("TS+HAIL", 96),
    "SQ": ("SQ", 18), "FC": ("+FC", 99), "+FC": ("+FC", 99),
    "VCSH": ("VCSH", 16)
}

# MW CODES: Maps standard METAR strings to Table 5a (Manual)
METAR_TO_MW_CODE = {
    "FG": ("FG", 45), "FZFG": ("FG", 49), "MIFG": ("FG", 12), "PRFG": ("FG", 45), "VCFG": ("FG", 40),
    "HZ": ("HZ", 5), "FU": ("FU", 4), "VA": ("FU", 4), "DU": ("DU", 6), "SA": ("SA", 7), 
    "BLSN": ("BLSN", 38), "DRSN": ("DRSN", 36), "BLDU": ("DU", 30), "BLSA": ("DU", 30), "PO": ("DU", 8),
    "SS": ("DU", 33), "+SS": ("DU", 35), "DS": ("DU", 9), "+DS": ("DU", 35),
    "-DZ": ("DZ", 51), "DZ": ("DZ", 53), "+DZ": ("DZ", 55),
    "-FZDZ": ("FZDZ", 56), "FZDZ": ("FZDZ", 57), "+FZDZ": ("FZDZ", 57),
    "-RADZ": ("DZ", 58), "RADZ": ("DZ", 59), "+RADZ": ("DZ", 59),
    "-RA": ("RA", 61), "RA": ("RA", 63), "+RA": ("RA", 65),
    "-FZRA": ("FZRA", 66), "FZRA": ("FZRA", 67), "+FZRA": ("FZRA", 67),
    "-SN": ("SN", 71), "SN": ("SN", 73), "+SN": ("SN", 75),
    "-RASN": ("RA", 68), "RASN": ("RA", 69), "+RASN": ("RA", 69),
    "-SG": ("SG", 77), "SG": ("SG", 77), "IC": ("IC", 78), 
    "-PL": ("PL", 79), "PL": ("PL", 79), "+PL": ("PL", 79), "PE": ("PL", 79), 
    "-SHRA": ("SHRA", 80), "SHRA": ("SHRA", 81), "+SHRA": ("SHRA", 82),
    "-SHSN": ("SHSN", 85), "SHSN": ("SHSN", 86), "+SHSN": ("SHSN", 87),
    "-SHRASN": ("SHRA", 83), "SHRASN": ("SHRA", 84), "+SHRASN": ("SHRA", 84),
    "GS": ("SH", 87), "+GS": ("SH", 88), "SHGS": ("SH", 87), 
    "GR": ("SH", 89), "+GR": ("SH", 90), "SHGR": ("SH", 89),
    "TS": ("TS", 17), "VCTS": ("TS", 17),
    "-TSRA": ("TS", 95), "TSRA": ("TS", 95), "+TSRA": ("TS", 97),
    "-TSSN": ("TS", 95), "TSSN": ("TS", 95), "+TSSN": ("TS", 97),
    "TSGR": ("TS", 96), "+TSGR": ("TS", 99),
    "SQ": ("SQ", 18), "FC": ("FC", 19), "+FC": ("FC", 19),
    "VCSH": ("VCSH", 16)
}

# AU CODES: Maps standard METAR strings to Table 5c (ASOS/AWOS)
METAR_TO_AU_CODE = {
    "BR": "BR:1", "FG": "FG:2", "FZFG": "FG:2", "MIFG": "FG:2", "PRFG": "FG:2", "VCFG": "FG:2",
    "HZ": "HZ:7", "FU": "FU:3", "VA": "VA:4", "DU": "DU:5", "SA": "SA:6", 
    "BLSN": "BLSN", "DRSN": "DRSN", "PO": "PO:1", "SS": "SS:4", "DS": "DS:5",
    "-DZ": "-DZ:01", "DZ": "DZ:01", "+DZ": "+DZ:01",
    "-FZDZ": "-FZDZ:01", "FZDZ": "FZDZ:01", "+FZDZ": "+FZDZ:01",
    "-RA": "-RA:02", "RA": "RA:02", "+RA": "+RA:02",
    "-FZRA": "-FZRA:02", "FZRA": "FZRA:02", "+FZRA": "+FZRA:02",
    "-SN": "-SN:03", "SN": "SN:03", "+SN": "+SN:03",
    "-SG": "-SG:04", "SG": "SG:04", "IC": "IC:05", 
    "-PL": "-PL:06", "PL": "PL:06", "+PL": "+PL:06", "PE": "PL:06", 
    "-SHRA": "-SHRA:02", "SHRA": "SHRA:02", "+SHRA": "+SHRA:02",
    "-SHSN": "-SHSN:03", "SHSN": "SHSN:03", "+SHSN": "+SHSN:03",
    "GS": "GS:08", "+GS": "+GS:08", "SHGS": "GS:08", 
    "GR": "GR:07", "+GR": "+GR:07", "SHGR": "GR:07",
    "TS": "TS", "VCTS": "VCTS",
    "-TSRA": "-TSRA:02", "TSRA": "TSRA:02", "+TSRA": "+TSRA:02",
    "-TSSN": "-TSSN:03", "TSSN": "TSSN:03", "+TSSN": "+TSSN:03",
    "TSGR": "TSGR:07", "+TSGR": "+TSGR:07",
    "SQ": "SQ:2", "FC": "FC:3", "+FC": "FC:3",
    "VCSH": "VCSH",
    "-UP": "-UP", "UP": "UP", "+UP": "+UP"
}

def load_metadata():
    print("Loading USAF Metadata...")
    df_meta = pd.read_csv(METADATA_CSV, skiprows=1, dtype={'PLATFORMID': str})
    df_meta = df_meta.drop_duplicates(subset=['PLATFORMID'], keep='first')
    return df_meta.set_index('PLATFORMID')[['NAME', 'LAT', 'LON', 'ELEV']].to_dict('index')

# --- CLEANUP TOOL ---
def clean_target_sources(sources_to_clean):
    """Surgically wipes out specific Source_ID directories before a fresh run."""
    print(f"\n--- Wiping old test data for sources: {sources_to_clean} ---")
    for source in sources_to_clean:
        search_pattern = os.path.join(BASE_IFF_DIR, "*", "*", str(source))
        target_dirs = glob.glob(search_pattern)
        
        for directory in target_dirs:
            try:
                shutil.rmtree(directory)
                print(f"  --> Removed: {directory}")
            except Exception as e:
                print(f"  --> Error removing {directory}: {e}")
    print("--- Cleanup complete ---\n")

# --- UNIVERSAL QC BOUNDS CHECK ---
def apply_qc_bounds(vars_dict):
    """Flags variables with '3' if they exceed physical or climatological limits."""
    bounds = {
        'temperature': (-90.0, 60.0),
        'dew_point_temperature': (-90.0, 60.0),
        'wet_bulb_temperature': (-90.0, 60.0),
        'relative_humidity': (0.0, 100.0),
        'wind_direction': (0, 360),
        'wind_speed': (0.0, 150.0),
        'wind_gust': (0.0, 150.0),
        'visibility': (0.0, 160.0), 
        'sea_level_pressure': (800.0, 1150.0),
        'station_level_pressure': (300.0, 1150.0), 
        'altimeter': (800.0, 1150.0),
        'precipitation': (0.0, 400.0), 
        'snow_depth': (0.0, 15000.0),  
        'pressure_3hr_change': (-100.0, 100.0)
    }
    
    for var_name, limits in bounds.items():
        if var_name in vars_dict:
            val = bounds_check_val = vars_dict[var_name]['val']
            if isinstance(bounds_check_val, (int, float)):
                if not (limits[0] <= bounds_check_val <= limits[1]):
                    vars_dict[var_name]['qc_flag'] = '3'


# --- DERIVED VARIABLES & HELPERS ---

def calc_hshs_meters(hshs_str):
    if hshs_str == '//': return None
    try:
        val = int(hshs_str)
        if val <= 50: return val * 30
        if 56 <= val <= 79: return (val - 50) * 300
        if 80 <= val <= 89: return (val - 80) * 1500 + 9000
        if val == 90: return 30
        if val == 91: return 50
        if val == 92: return 100
        if val == 93: return 200
        if val == 94: return 300
        if val == 95: return 600
        if val == 96: return 1000
        if val == 97: return 1500
        if val == 98: return 2000
        if val == 99: return 2500
    except ValueError:
        return None
    return None

def derive_humidity_and_wetbulb(vars_dict):
    """Calculates RH and Wet Bulb based strictly on observed values."""
    t_dict = vars_dict.get('temperature')
    td_dict = vars_dict.get('dew_point_temperature')
    sp_dict = vars_dict.get('station_level_pressure')

    if t_dict and td_dict:
        t_c = t_dict['val']
        td_c = td_dict['val']
        
        try:
            e_sat = 6.112 * math.exp((17.67 * t_c) / (t_c + 243.5))
            e_act = 6.112 * math.exp((17.67 * td_c) / (td_c + 243.5))
            rh_val = round((e_act / e_sat) * 100.0)
            
            vars_dict['relative_humidity'] = {
                'val': rh_val,
                'orig_val': rh_val,
                'orig_unit': '%',
                'meas_code_1': 'D',
                'qc_flag': ''
            }
        except Exception:
            pass
            
        if sp_dict and sp_dict['val'] != '':
            try:
                sp_hpa = sp_dict['val']
                t_f = round((t_c * 9/5) + 32)
                td_f = round((td_c * 9/5) + 32)
                sp_inhg = round(sp_hpa * 0.02953, 2) 
                
                a = (t_f - td_f) * 0.1
                b = a - 1.0
                c = a**2
                
                if t_f < 0:
                    wb_f = t_f - (0.034 * a - 0.006 * c) * (0.6 * (t_f + td_f) - 2.0 * sp_inhg + 108.0)
                else:
                    wb_f = t_f - (0.034 * a - 0.00072 * a * b) * (t_f + td_f - 2.0 * sp_inhg + 108.0)
                
                wb_c = round((wb_f - 32) * 5/9, 1)
                
                vars_dict['wet_bulb_temperature'] = {
                    'val': wb_c,
                    'orig_val': wb_c,
                    'orig_unit': 'C',
                    'meas_code_1': 'D',
                    'qc_flag': '' 
                }
            except Exception:
                pass

def get_bufr_array(bufr_handle, key):
    """Safely extracts variable-length sequence arrays from BUFR without crashing."""
    try:
        if codes_is_defined(bufr_handle, key):
            arr = codes_get_array(bufr_handle, key)
            return [None if x in (CODES_MISSING_DOUBLE, CODES_MISSING_LONG) else x for x in arr]
    except Exception:
        pass
    return []

# --- PARSING FUNCTIONS ---

def parse_metar_file(filepath, meta_dict):
    local_obs = {}
    file_date_match = FILE_DATE_PATTERN.search(filepath)
    if not file_date_match: return local_obs
    
    f_year, f_month, f_day = int(file_date_match.group(1)), int(file_date_match.group(2)), int(file_date_match.group(3))
    
    with open(filepath, 'r', encoding='utf-8', errors='ignore') as f:
        for line in f:
            match = METAR_STATION_PATTERN.search(line)
            if not match: continue
            
            station, d_str, h_str, m_str = match.groups()
            
            # --- STRICT METADATA FILTER ---
            if station not in meta_dict:
                continue
                
            m_int = int(m_str)
            is_routine_time = (45 <= m_int <= 59) or (m_int == 0)
            report_type = "FM16" if ("SPECI" in line or not is_routine_time) else "FM15"
            
            obs_y, obs_m, obs_d = f_year, f_month, int(d_str)
            if obs_d > 25 and f_day < 5:
                obs_m -= 1
                if obs_m == 0: obs_m, obs_y = 12, obs_y - 1
            elif obs_d < 5 and f_day > 25:
                obs_m += 1
                if obs_m == 13: obs_m, obs_y = 1, obs_y + 1

            # --- CALENDAR & FUTURE VALIDATION GUARD ---
            try:
                obs_dt = datetime(obs_y, obs_m, obs_d)
                file_dt = datetime(f_year, f_month, f_day)
                
                if obs_dt > file_dt + timedelta(days=1):
                    obs_m -= 1
                    if obs_m == 0: obs_m, obs_y = 12, obs_y - 1
                    obs_dt = datetime(obs_y, obs_m, obs_d)
                    
            except ValueError:
                continue 
            # ---------------------------------
            
            vars_dict = {}
            # --- FIX: Scrub multi-line carriage returns from METAR remarks ---
            clean_rem = line.strip().replace('"', '').replace('|', ' ').replace('\n', ' ').replace('\r', ' ')
            vars_dict['REM'] = {'val': clean_rem, 'orig_val': '', 'orig_unit': 'text'}
            
            t_exact_match = METAR_T_GROUP_PATTERN.search(line)
            if t_exact_match:
                sign_t, val_t, sign_td, val_td = t_exact_match.groups()
                calc_t = -(float(val_t) / 10.0) if sign_t == '1' else (float(val_t) / 10.0)
                vars_dict['temperature'] = {'val': calc_t, 'orig_val': calc_t, 'orig_unit': 'C'}
                if val_td:
                    calc_td = -(float(val_td) / 10.0) if sign_td == '1' else (float(val_td) / 10.0)
                    vars_dict['dew_point_temperature'] = {'val': calc_td, 'orig_val': calc_td, 'orig_unit': 'C'}
            else:
                t_match = METAR_STD_TEMP_PATTERN.search(line)
                if t_match:
                    t_str_raw, td_str_raw = t_match.groups()
                    t_val = float(t_str_raw.replace('M', '-'))
                    vars_dict['temperature'] = {'val': t_val, 'orig_val': t_val, 'orig_unit': 'C'}
                    if td_str_raw:
                        td_val = float(td_str_raw.replace('M', '-'))
                        vars_dict['dew_point_temperature'] = {'val': td_val, 'orig_val': td_val, 'orig_unit': 'C'}

            wind_match = METAR_WIND_PATTERN.search(line)
            if wind_match:
                dir_str, spd_str, gust_str, unit = wind_match.groups()
                if dir_str != 'VRB': 
                    vars_dict['wind_direction'] = {'val': int(dir_str), 'orig_val': int(dir_str), 'orig_unit': 'deg'}
                spd = float(spd_str)
                vars_dict['wind_speed'] = {'val': round(spd * 0.51444, 1) if unit == 'KT' else round(spd, 1), 'orig_val': spd, 'orig_unit': unit}
                if gust_str:
                    gust = float(gust_str)
                    vars_dict['wind_gust'] = {'val': round(gust * 0.51444, 1) if unit == 'KT' else round(gust, 1), 'orig_val': gust, 'orig_unit': unit}

            vis_match = METAR_VIS_PATTERN.search(line)
            vis_intl_match = METAR_VIS_INTL_PATTERN.search(line)
            
            if vis_match and (vis_match.group(1) or vis_match.group(2)):
                whole = float(vis_match.group(1)) if vis_match.group(1) else 0.0
                frac = 0.0
                if vis_match.group(2):
                    num, den = vis_match.group(2).split('/')
                    frac = float(num) / float(den)
                total_sm = whole + frac
                vars_dict['visibility'] = {'val': round(total_sm * 1.60934, 2), 'orig_val': total_sm, 'orig_unit': 'SM'}
            elif vis_intl_match and not wind_match:
                vis_meters = float(vis_intl_match.group(1))
                if vis_meters == 9999:
                    vars_dict['visibility'] = {'val': 10.0, 'orig_val': 9999, 'orig_unit': 'm'} 
                else:
                    vars_dict['visibility'] = {'val': round(vis_meters / 1000.0, 2), 'orig_val': vis_meters, 'orig_unit': 'm'}

            alt_match = METAR_ALT_PATTERN.search(line)
            if alt_match:
                indicator = alt_match.group(0)[0]
                orig_p = float(alt_match.group(1))
                if indicator == 'A':
                    orig_p_inhg = orig_p / 100.0
                    calc_p = round(orig_p_inhg * 33.8639, 1)
                    vars_dict['altimeter'] = {'val': calc_p, 'orig_val': orig_p_inhg, 'orig_unit': 'inHg'}
                else: 
                    vars_dict['altimeter'] = {'val': orig_p, 'orig_val': orig_p, 'orig_unit': 'hPa'}
                    calc_p = orig_p

                # --- DERIVE STATION LEVEL PRESSURE FROM ALTIMETER (ISA EQUATION) ---
                station_meta = meta_dict.get(station, {})
                elev_str = station_meta.get('ELEV', '')
                try:
                    z = float(elev_str) if elev_str else 0.0
                    stn_p = calc_p * ((288.15 - 0.0065 * z) / 288.15) ** 5.25588
                    
                    vars_dict['station_level_pressure'] = {
                        'val': round(stn_p, 1), 
                        'orig_val': round(stn_p, 1), 
                        'orig_unit': 'hPa',
                        'meas_code_1': 'D',  # 'D' flag for Derived/Calculated
                        'qc_flag': ''
                    }
                except Exception:
                    pass

            slp_match = METAR_SLP_PATTERN.search(line)
            if slp_match:
                slp_val = float(slp_match.group(1)) / 10.0
                calc_slp = round(slp_val + 1000 if slp_val < 50.0 else slp_val + 900, 1)
                vars_dict['sea_level_pressure'] = {'val': calc_slp, 'orig_val': slp_val, 'orig_unit': 'hPa'}

            p_match = METAR_P_PATTERN.search(line)
            if p_match:
                p_val_raw = int(p_match.group(1))
                if p_val_raw == 0:
                    p_val_mm = 0.0
                    meas_code = 'T'
                else:
                    p_val_mm = round((p_val_raw / 100.0) * 25.4, 1)
                    meas_code = ''
                
                vars_dict['precipitation'] = {
                    'val': p_val_mm,
                    'orig_val': p_val_raw,
                    'orig_unit': 'hundredths_in',
                    'meas_code_1': meas_code,
                    'qc_flag': ''
                }

            snow_match = METAR_SNOW_PATTERN.search(line)
            if snow_match:
                snow_in = int(snow_match.group(1))
                snow_mm = round(snow_in * 25.4, 1)
                vars_dict['snow_depth'] = {
                    'val': snow_mm, 'orig_val': snow_in, 'orig_unit': 'in',
                    'meas_code_1': '', 'qc_flag': ''
                }
                
            p3_match = METAR_P3HR_PATTERN.search(line)
            if p3_match:
                tendency_code = p3_match.group(1)
                ppp_raw = float(p3_match.group(2)) / 10.0
                vars_dict['pressure_3hr_change'] = {
                    'val': ppp_raw, 'orig_val': ppp_raw, 'orig_unit': 'hPa',
                    'meas_code_1': tendency_code, 'qc_flag': ''
                }

            # --- PARSE HIDDEN U.S. SYNOPTIC GROUPS FROM METAR REMARKS ---
            max_t_match = METAR_MAX_T_PATTERN.search(line)
            if max_t_match:
                sign, val = max_t_match.groups()
                calc_max_t = -(float(val) / 10.0) if sign == '1' else (float(val) / 10.0)
                vars_dict['maximum_temperature'] = {
                    'val': calc_max_t, 'orig_val': calc_max_t, 'orig_unit': 'C',
                    'meas_code_1': '', 'qc_flag': ''
                }
                
            min_t_match = METAR_MIN_T_PATTERN.search(line)
            if min_t_match:
                sign, val = min_t_match.groups()
                calc_min_t = -(float(val) / 10.0) if sign == '1' else (float(val) / 10.0)
                vars_dict['minimum_temperature'] = {
                    'val': calc_min_t, 'orig_val': calc_min_t, 'orig_unit': 'C',
                    'meas_code_1': '', 'qc_flag': ''
                }

            # Present Weather (METAR pres_wx_AW, MW, AU)
            wx_count = 1
            for token in line.split():
                matched = False
                
                # AW Mapping (Table 5b)
                if token in METAR_TO_AW_CODE:
                    abbr, code = METAR_TO_AW_CODE[token]
                    vars_dict[f'pres_wx_AW{wx_count}'] = {
                        'val': f"{abbr}:{code:02d}", 'orig_val': f"{abbr}:{code:02d}", 'orig_unit': 'code',
                        'meas_code_1': '', 'qc_flag': ''
                    }
                    matched = True
                    
                # MW Mapping (Table 5a)
                if token in METAR_TO_MW_CODE:
                    abbr, code = METAR_TO_MW_CODE[token]
                    vars_dict[f'pres_wx_MW{wx_count}'] = {
                        'val': f"{abbr}:{code:02d}", 'orig_val': f"{abbr}:{code:02d}", 'orig_unit': 'code',
                        'meas_code_1': '', 'qc_flag': ''
                    }
                    matched = True

                # AU Mapping (Table 5c)
                if token in METAR_TO_AU_CODE:
                    val_str = METAR_TO_AU_CODE[token] 
                    vars_dict[f'pres_wx_AU{wx_count}'] = {
                        'val': val_str, 'orig_val': val_str, 'orig_unit': 'code',
                        'meas_code_1': '', 'qc_flag': ''
                    }
                    matched = True
                
                if matched:
                    wx_count += 1
                if wx_count > 3: break 

            # --- CLOUD COVER & CEILING LOGIC ---
            is_us_can = station.startswith(('K', 'C', 'P')) # Route K, C, P to summation arrays
            
            cloud_matches = METAR_CLOUD_PATTERN.findall(line)
            layer_idx = 1
            ceiling_found = False
            
            for cloud_group in cloud_matches:
                if layer_idx > 4: break
                
                if cloud_group in ['SKC', 'CLR', 'CAVOK', 'NSC', 'NCD']:
                    cov_str = 'CLR'
                    cov_code = '00'
                    ht_m = None
                    cld_type = ':'
                    
                    if cloud_group == 'CAVOK':
                        vars_dict['ceiling_height'] = {
                            'val': 22000, 'orig_val': 'CAVOK', 'orig_unit': 'text', 
                            'meas_code_1': ';Y', 'qc_flag': ''
                        }
                        ceiling_found = True
                        
                else:
                    if cloud_group.startswith('VV'):
                        cov_str = 'VV'
                        cov_code = '09'
                        ht_ft = int(cloud_group[2:5]) * 100
                        cld_type = ':'
                    else:
                        cov_str = cloud_group[:3] 
                        cov_code = CLOUD_COVER_MAP.get(cov_str, '09')
                        ht_ft = int(cloud_group[3:6]) * 100
                        
                        cld_type = ':'
                        if 'CB' in cloud_group: cld_type = '09:'
                        elif 'TCU' in cloud_group: cld_type = '12:'
                        
                    ht_m = round(ht_ft * 0.3048)
                    
                    # Ceiling logic (first BKN, OVC, or VV is ceiling)
                    if not ceiling_found and cov_str in ['BKN', 'OVC', 'VV']:
                        vars_dict['ceiling_height'] = {
                            'val': ht_m, 'orig_val': ht_ft, 'orig_unit': 'ft', 
                            'meas_code_1': 'M;', 'qc_flag': ''
                        } 
                        ceiling_found = True

                # Route to Summation (US/Can) or Discrete Layer (International)
                if is_us_can:
                    # Drop the duplicated Code 2 (U.S. METARs don't report in octas explicitly)
                    cov_val = f"{cov_str}:{cov_code};" if cov_str != 'CLR' else "CLR:00;"
                    
                    vars_dict[f'sky_cover_summation_{layer_idx}'] = {
                        'val': cov_val, 'orig_val': cloud_group, 'orig_unit': 'text', 
                        'meas_code_1': '', 'qc_flag': ''
                    }                       
                    if ht_m is not None:
                        vars_dict[f'sky_cover_summation_baseht_{layer_idx}'] = {
                            'val': ht_m, 'orig_val': ht_ft, 'orig_unit': 'ft', 
                            'meas_code_1': cld_type, 'qc_flag': ''
                        }
                else:
                    cov_val = f"{cov_str}:{cov_code}"
                    vars_dict[f'sky_cover_layer_{layer_idx}'] = {
                        'val': cov_val, 'orig_val': cloud_group, 'orig_unit': 'text', 
                        'meas_code_1': '', 'qc_flag': ''
                    }
                    if ht_m is not None:
                        vars_dict[f'sky_cover_layer_baseht_{layer_idx}'] = {
                            'val': ht_m, 'orig_val': ht_ft, 'orig_unit': 'ft', 
                            'meas_code_1': cld_type, 'qc_flag': ''
                        }
                        
                layer_idx += 1

            derive_humidity_and_wetbulb(vars_dict)
            apply_qc_bounds(vars_dict)

            dedup_key = f"METAR_{station}_{obs_d:02d}_{h_str}_{m_str}"
            local_obs[dedup_key] = {
                'Station_ID': f"ICAO-{station}", 'raw_id': station, 'Source_ID': 413, 
                'Report_type_code': report_type, 'Measurement_code_2': '',
                'Year': obs_y, 'Month': obs_m, 'Day': obs_d, 'Hour': int(h_str), 'Minute': m_int,
                'variables': vars_dict
            }

            # --- DUAL-ROUTING ENGINE: CLONE METAR SYNOPTIC HOURS TO SOURCE 412 ---
            # If the METAR contains traditional synoptic remark groups, trigger an automatic 412 broadcast
            has_synoptic_remarks = 'pressure_3hr_change' in vars_dict or 'maximum_temperature' in vars_dict or 'minimum_temperature' in vars_dict
            
            if has_synoptic_remarks:
                syn_dedup_key = f"SYN_METAR_{station}_{obs_d:02d}_{h_str}_{m_str}"
                
                # Perform a deep copy of the variable dictionary to safely decouple the streams
                syn_vars = {k: v.copy() for k, v in vars_dict.items() if v is not None}
                
                local_obs[syn_dedup_key] = {
                    'Station_ID': f"ICAO-{station}", 'raw_id': station, 'Source_ID': 412, 
                    'Report_type_code': 'FM12', 'Measurement_code_2': 'METAR_SYN',
                    'Year': obs_y, 'Month': obs_m, 'Day': obs_d, 'Hour': int(h_str), 'Minute': m_int,
                    'variables': syn_vars
                }

    return local_obs

def parse_synop_file(filepath, meta_dict):
    local_obs = {}
    file_date_match = FILE_DATE_PATTERN.search(filepath)
    if not file_date_match: return local_obs
    
    f_year, f_month, f_day = int(file_date_match.group(1)), int(file_date_match.group(2)), int(file_date_match.group(3))
    
    with open(filepath, 'r', encoding='utf-8', errors='ignore') as f:
        bulletins = f.read().split("AAXX ")
        for bulletin in bulletins[1:]:
            tokens = bulletin.split()
            if not tokens: continue
            date_group = tokens[0]
            
            if len(date_group) >= 4 and date_group[:4].isdigit():
                b_day, b_hour = int(date_group[:2]), int(date_group[2:4])
                
                obs_y, obs_m, obs_d = f_year, f_month, b_day
                if obs_d > 25 and f_day < 5:
                    obs_m -= 1
                    if obs_m == 0: obs_m, obs_y = 12, obs_y - 1
                elif obs_d < 5 and f_day > 25:
                    obs_m += 1
                    if obs_m == 13: obs_m, obs_y = 1, obs_y + 1

                # --- CALENDAR & FUTURE VALIDATION GUARD ---
                try:
                    obs_dt = datetime(obs_y, obs_m, obs_d)
                    file_dt = datetime(f_year, f_month, f_day)
                    
                    if obs_dt > file_dt + timedelta(days=1):
                        obs_m -= 1
                        if obs_m == 0: obs_m, obs_y = 12, obs_y - 1
                        obs_dt = datetime(obs_y, obs_m, obs_d)
                        
                except ValueError:
                    continue 
                # ---------------------------------
                
                reports = bulletin.split('=')
                for report in reports:
                    clean = report.strip()
                    if clean.startswith(date_group): clean = clean[len(date_group):].strip()
                    
                    id_match = SYNOP_ID_PATTERN.search(clean)
                    if not id_match: continue
                    station = id_match.group(1)
                    
                    # --- STRICT METADATA FILTER ---
                    if station not in meta_dict:
                        continue
                    
                    vars_dict = {}
                    
                    # Fetch station elevation early for WMO rules checking
                    station_meta = meta_dict.get(station, {})
                    elev_str = station_meta.get('ELEV', '')
                    try:
                        station_elev = float(elev_str) if elev_str else 0.0
                    except ValueError:
                        station_elev = 0.0

                    parts = re.split(r'\b(?:333|444|555)\b', clean, maxsplit=1)
                    section_1 = parts[0]
                    section_3 = ""
                    if len(parts) > 1:
                        section_3 = parts[1]
                    
                    # --- FIX: Scrub multi-line carriage returns from SYNOP remarks ---
                    clean_rem = clean.replace('"', '').replace('|', ' ').replace('\n', ' ').replace('\r', ' ')
                    vars_dict['REM'] = {'val': clean_rem, 'orig_val': '', 'orig_unit': 'text'}
                    
                    section_1_tokens = section_1.split()
                    safe_section_1 = " ".join(section_1_tokens[3:]) if len(section_1_tokens) > 3 else section_1
                    
                    clean_tokens = clean.split()
                    safe_clean = " ".join(clean_tokens[3:]) if len(clean_tokens) > 3 else clean

                    for t_match in SYNOP_T_PATTERN.finditer(safe_section_1):
                        if t_match.group(0) != station:
                            sign, val = t_match.groups()
                            t_val = -(float(val) / 10.0) if sign == '1' else (float(val) / 10.0)
                            vars_dict['temperature'] = {'val': t_val, 'orig_val': t_val, 'orig_unit': 'C'}
                            break
                        
                    for td_match in SYNOP_TD_PATTERN.finditer(safe_section_1):
                        if td_match.group(0) != station:
                            sign, val = td_match.groups()
                            td_val = -(float(val) / 10.0) if sign == '1' else (float(val) / 10.0)
                            vars_dict['dew_point_temperature'] = {'val': td_val, 'orig_val': td_val, 'orig_unit': 'C'}
                            break
                        
                    for p_match in SYNOP_P_PATTERN.finditer(safe_section_1):
                        if p_match.group(0) != station:
                            # Apply WMO FM-12 High Altitude SLP exclusion rule
                            if station_elev > 500.0:
                                break 
                            orig_p = float(p_match.group(1)) / 10.0
                            calc_p = round(orig_p + 1000 if orig_p < 500 else orig_p, 1)
                            vars_dict['sea_level_pressure'] = {'val': calc_p, 'orig_val': orig_p, 'orig_unit': 'hPa'}
                            break

                    # --- ADDED: Station Level Pressure Parser ---
                    for stn_p_match in SYNOP_STN_P_PATTERN.finditer(safe_section_1):
                        if stn_p_match.group(0) != station:
                            orig_stn_p = float(stn_p_match.group(1)) / 10.0
                            calc_stn_p = round(orig_stn_p + 1000 if orig_stn_p < 500 else orig_stn_p, 1)
                            vars_dict['station_level_pressure'] = {'val': calc_stn_p, 'orig_val': orig_stn_p, 'orig_unit': 'hPa'}
                            break
                    # --------------------------------------------

                    for precip_match in SYNOP_PRECIP_1HR_PATTERN.finditer(safe_clean):
                        if precip_match.group(0) != station:
                            rrr = int(precip_match.group(1))
                            if rrr == 990:
                                p_val_mm = 0.0
                                meas_code = 'T'
                            elif 991 <= rrr <= 999:
                                p_val_mm = (rrr - 990) / 10.0
                                meas_code = ''
                            else:
                                p_val_mm = float(rrr)
                                meas_code = ''
                                
                            vars_dict['precipitation'] = {
                                'val': p_val_mm, 'orig_val': rrr, 'orig_unit': 'code_table_3590',
                                'meas_code_1': meas_code, 'qc_flag': ''
                            }
                            break

                    for p3_match in SYNOP_P3HR_PATTERN.finditer(safe_section_1):
                        if p3_match.group(0) != station:
                            tendency_code = p3_match.group(1)
                            ppp_raw = float(p3_match.group(2)) / 10.0
                            vars_dict['pressure_3hr_change'] = {
                                'val': ppp_raw, 'orig_val': ppp_raw, 'orig_unit': 'hPa',
                                'meas_code_1': tendency_code, 'qc_flag': ''
                            }
                            break

                    for wx_match in SYNOP_WX_PATTERN.finditer(safe_section_1):
                        if wx_match.group(0) != station:
                            ww_code = int(wx_match.group(1))
                            if ww_code > 0: 
                                abbr = WMO_4677_TO_ABBR.get(ww_code, 'UNK')
                                val_str = f"{abbr}:{ww_code:02d}"
                                vars_dict['pres_wx_MW1'] = {
                                    'val': val_str, 'orig_val': val_str, 'orig_unit': 'code',
                                    'meas_code_1': '', 'qc_flag': ''
                                }
                            break

                    # --- SYNOP CLOUD COVER LOGIC ---
                    
                    # 1. Mandatory N & h (sky_condition & baseht setup)
                    n_code = ""
                    h_code = ""
                    for nh_match in SYNOP_NH_PATTERN.finditer(section_1):
                        if nh_match.group(0) != station:
                            h_char, n_char = nh_match.groups()
                            n_code = SYNOP_N_OKTA.get(n_char, "")
                            if h_char in SYNOP_H_MAP: h_code = SYNOP_H_MAP[h_char]
                            break

                    # 2. General Cloud Group 8NhCLCMCH
                    nh_okta = ""
                    cl = cm = ch = "/"
                    for group8_match in SYNOP_8_GROUP_PATTERN.finditer(safe_section_1):
                        if group8_match.group(0) != station:
                            nh_char, cl, cm, ch = group8_match.groups()
                            nh_okta = SYNOP_N_OKTA.get(nh_char, "")
                            break

                    # Assign sky_condition (Total ;; Lowest)
                    if n_code or nh_okta:
                        vars_dict['sky_condition'] = {
                            'val': f"{n_code};;{nh_okta}", 'orig_val': f"{n_code};;{nh_okta}", 'orig_unit': 'code',
                            'meas_code_1': '', 'qc_flag': ''
                        }
                    
                    # Assign sky_condition_baseht
                    cl_str = f"0{cl}:" if cl != '/' else ":"
                    cm_str = f"0{cm}:" if cm != '/' else ":"
                    ch_str = f"0{ch}:" if ch != '/' else ":"
                    meas_str = f"{cl_str};{cm_str};{ch_str}"
                    
                    if h_code != "":
                        vars_dict['sky_condition_baseht'] = {
                            'val': h_code, 'orig_val': h_code, 'orig_unit': 'm',
                            'meas_code_1': meas_str, 'qc_flag': ''
                        }
                    elif meas_str != ":;:;:":
                        vars_dict['sky_condition_baseht'] = {
                            'val': '', 'orig_val': '', 'orig_unit': '',
                            'meas_code_1': meas_str, 'qc_flag': ''
                        }

                    # 3. Section 3 Discrete Layers (8NsCHshs) -> sky_cover_layer_[1-4]
                    if section_3:
                        layer_idx = 1
                        for layer_match in SYNOP_8_LAYER_PATTERN.finditer(section_3):
                            if layer_match.group(0) == station: continue
                            if layer_idx > 4: break
                            ns_char, c_char, hshs_str = layer_match.groups()
                            
                            cov_str = SYNOP_COVERAGE_MAP.get(ns_char, 'X:10')
                            vars_dict[f'sky_cover_layer_{layer_idx}'] = {
                                'val': cov_str, 'orig_val': ns_char, 'orig_unit': 'code',
                                'meas_code_1': '', 'qc_flag': ''
                            }
                            
                            hshs_m = calc_hshs_meters(hshs_str)
                            c_type = f"0{c_char}:" if c_char != '/' else ":"
                            
                            if hshs_m is not None:
                                vars_dict[f'sky_cover_layer_baseht_{layer_idx}'] = {
                                    'val': hshs_m, 'orig_val': hshs_str, 'orig_unit': 'code',
                                    'meas_code_1': c_type, 'qc_flag': ''
                                }
                            elif c_type != ":":
                                vars_dict[f'sky_cover_layer_baseht_{layer_idx}'] = {
                                    'val': '', 'orig_val': '', 'orig_unit': '',
                                    'meas_code_1': c_type, 'qc_flag': ''
                                }
                            layer_idx += 1

                        for snow_match in SYNOP_SNOW_PATTERN.finditer(section_3):
                            if snow_match.group(0) != station:
                                snow_cm = int(snow_match.group(1))
                                if snow_cm == 997:
                                    vars_dict['snow_depth'] = {
                                        'val': 0.0, 'orig_val': snow_cm, 'orig_unit': 'code_table_3889',
                                        'meas_code_1': 'T', 'qc_flag': ''
                                    }
                                elif snow_cm < 997:
                                    vars_dict['snow_depth'] = {
                                        'val': float(snow_cm * 10), 'orig_val': snow_cm, 'orig_unit': 'cm',
                                        'meas_code_1': '', 'qc_flag': ''
                                    }
                                break
                    
                    derive_humidity_and_wetbulb(vars_dict)
                    apply_qc_bounds(vars_dict)

                    dedup_key = f"SYNOP_{station}_{obs_d:02d}_{b_hour:02d}_00"
                    local_obs[dedup_key] = {
                        'Station_ID': f"WMO-{station}", 'raw_id': station,
                        'Source_ID': 412, 'Report_type_code': 'FM12', 'Measurement_code_2': 'TAC',
                        'Year': obs_y, 'Month': obs_m, 'Day': obs_d, 'Hour': b_hour, 'Minute': 0,
                        'variables': vars_dict
                    }
    return local_obs

def safe_get(bufr_handle, key):
    try:
        if codes_is_defined(bufr_handle, key):
            val = codes_get(bufr_handle, key)
            if val in (CODES_MISSING_DOUBLE, CODES_MISSING_LONG): return None
            return val
        return None
    except KeyValueNotFoundError: return None

def parse_bufr_file(filepath, meta_dict):
    local_obs = {}
    file_date_match = FILE_DATE_PATTERN.search(filepath)
    if not file_date_match: return local_obs
    
    f_year, f_month, f_day = int(file_date_match.group(1)), int(file_date_match.group(2)), int(file_date_match.group(3))
    
    with open(filepath, 'rb') as f:
        while True:
            bufr_handle = codes_bufr_new_from_file(f)
            if bufr_handle is None: break
            try:
                codes_set(bufr_handle, 'unpack', 1)
                num_subsets = safe_get(bufr_handle, 'numberOfSubsets') or 1
                
                for i in range(1, num_subsets + 1):
                    obs_day = safe_get(bufr_handle, f'#{i}#typicalDay') or safe_get(bufr_handle, 'typicalDay')
                    obs_hour = safe_get(bufr_handle, f'#{i}#typicalHour') or safe_get(bufr_handle, 'typicalHour')
                    obs_min = safe_get(bufr_handle, f'#{i}#typicalMinute') or safe_get(bufr_handle, 'typicalMinute')
                    
                    if obs_day is None or obs_hour is None: continue

                    # --- NEW BUFR NATIVE TIMESTAMP EXTRACTION ---
                    obs_year = safe_get(bufr_handle, f'#{i}#typicalYear') or safe_get(bufr_handle, 'typicalYear')
                    obs_month = safe_get(bufr_handle, f'#{i}#typicalMonth') or safe_get(bufr_handle, 'typicalMonth')
                    
                    if obs_year is not None and obs_month is not None:
                        # Trust the native BUFR payload completely, but fix 2-digit hardware years
                        obs_y = int(obs_year)
                        if obs_y < 100:
                            obs_y += 2000
                            
                        obs_m, obs_d = int(obs_month), int(obs_day)
                    else:
                        # Fallback to the file date + rollover logic for legacy files
                        obs_y, obs_m, obs_d = f_year, f_month, int(obs_day)
                        if obs_d > 25 and f_day < 5:
                            obs_m -= 1
                            if obs_m == 0: obs_m, obs_y = 12, obs_y - 1
                        elif obs_d < 5 and f_day > 25:
                            obs_m += 1
                            if obs_m == 13: obs_m, obs_y = 1, obs_y + 1

                    # --- CALENDAR & FUTURE VALIDATION GUARD ---
                    try:
                        obs_dt = datetime(obs_y, obs_m, obs_d)
                        file_dt = datetime(f_year, f_month, f_day)
                        
                        if obs_dt > file_dt + timedelta(days=1):
                            obs_m -= 1
                            if obs_m == 0: obs_m, obs_y = 12, obs_y - 1
                            obs_dt = datetime(obs_y, obs_m, obs_d)
                            
                    except ValueError:
                        continue 
                    # ---------------------------------
                    
                    block = safe_get(bufr_handle, f'#{i}#blockNumber')
                    station_num = safe_get(bufr_handle, f'#{i}#stationNumber')
                    
                    if block is not None and station_num is not None:
                        station = f"{int(block):02d}{int(station_num):03d}"
                    else:
                        alt_id = safe_get(bufr_handle, f'#{i}#shipOrMobileLandStationIdentifier')
                        station = str(alt_id).strip() if alt_id else None
                        
                    if not station: continue
                    
                    # --- STRICT METADATA FILTER ---
                    if station not in meta_dict:
                        continue
                        
                    vars_dict = {}
                    
                    vars_dict['REM'] = {'val': 'BUFR_BINARY_RECORD', 'orig_val': '', 'orig_unit': 'text'}
                    
                    temp_k = safe_get(bufr_handle, f'#{i}#airTemperature')
                    if temp_k is not None and temp_k > 100.0: 
                        calc_t = round(temp_k - 273.15, 2)
                        vars_dict['temperature'] = {'val': calc_t, 'orig_val': temp_k, 'orig_unit': 'K'}
                        
                    dew_k = safe_get(bufr_handle, f'#{i}#dewpointTemperature')
                    if dew_k is not None and dew_k > 100.0: 
                        calc_td = round(dew_k - 273.15, 2)
                        vars_dict['dew_point_temperature'] = {'val': calc_td, 'orig_val': dew_k, 'orig_unit': 'K'}
                        
                    wdir = safe_get(bufr_handle, f'#{i}#windDirection')
                    if wdir is not None and wdir <= 360: 
                        vars_dict['wind_direction'] = {'val': int(round(float(wdir))), 'orig_val': float(wdir), 'orig_unit': 'deg'}
                    
                    wspd = safe_get(bufr_handle, f'#{i}#windSpeed')
                    if wspd is not None and wspd < 150.0: 
                        vars_dict['wind_speed'] = {'val': round(float(wspd), 1), 'orig_val': float(wspd), 'orig_unit': 'm/s'}
                    
                    wgust = safe_get(bufr_handle, f'#{i}#windGusts')
                    if wgust is not None and wgust < 150.0:
                        vars_dict['wind_gust'] = {'val': round(float(wgust), 1), 'orig_val': float(wgust), 'orig_unit': 'm/s'}
                    
                    vis_m = safe_get(bufr_handle, f'#{i}#horizontalVisibility')
                    if vis_m is not None: vars_dict['visibility'] = {'val': round(float(vis_m) / 1000.0, 2), 'orig_val': float(vis_m), 'orig_unit': 'm'}

                    pressure_pa = safe_get(bufr_handle, f'#{i}#pressureReducedToMeanSeaLevel')
                    if pressure_pa is not None and 10000.0 < pressure_pa < 115000.0: 
                        vars_dict['sea_level_pressure'] = {'val': round(pressure_pa / 100.0, 2), 'orig_val': pressure_pa, 'orig_unit': 'Pa'}
                    
                    stn_pressure_pa = safe_get(bufr_handle, f'#{i}#nonCoordinatePressure') 
                    if stn_pressure_pa is not None and 10000.0 < stn_pressure_pa < 115000.0: 
                        vars_dict['station_level_pressure'] = {'val': round(stn_pressure_pa / 100.0, 2), 'orig_val': stn_pressure_pa, 'orig_unit': 'Pa'}

                    alt_setting_pa = safe_get(bufr_handle, f'#{i}#altimeterSetting')
                    if alt_setting_pa is not None and alt_setting_pa > 10000.0: 
                        vars_dict['altimeter'] = {'val': round(alt_setting_pa / 100.0, 2), 'orig_val': alt_setting_pa, 'orig_unit': 'Pa'}

                    precip_1hr_kgm2 = safe_get(bufr_handle, f'#{i}#totalPrecipitationPast1Hour')
                    if precip_1hr_kgm2 is not None:
                        p_val_raw = round(float(precip_1hr_kgm2), 1)
                        if p_val_raw == -0.1:
                            vars_dict['precipitation'] = {
                                'val': 0.0, 'orig_val': precip_1hr_kgm2, 'orig_unit': 'kg/m2',
                                'meas_code_1': 'T', 'qc_flag': ''
                            }
                        elif p_val_raw >= 0.0:
                            meas_code = 'T' if (0 < p_val_raw < 0.1) else '' 
                            vars_dict['precipitation'] = {
                                'val': p_val_raw, 'orig_val': precip_1hr_kgm2, 'orig_unit': 'kg/m2',
                                'meas_code_1': meas_code, 'qc_flag': ''
                            }

                    snow_m = safe_get(bufr_handle, f'#{i}#totalSnowDepth')
                    if snow_m is not None:
                        rounded_snow = round(snow_m, 2)
                        if rounded_snow == -0.01:
                            vars_dict['snow_depth'] = {
                                'val': 0.0, 'orig_val': snow_m, 'orig_unit': 'm',
                                'meas_code_1': 'T', 'qc_flag': ''
                            }
                        elif rounded_snow == -0.02:
                            vars_dict['snow_depth'] = {
                                'val': 0.0, 'orig_val': snow_m, 'orig_unit': 'm',
                                'meas_code_1': 'P', 'qc_flag': '' 
                            }
                        elif 0.0 <= snow_m < 15.0:
                            vars_dict['snow_depth'] = {
                                'val': round(float(snow_m) * 1000.0, 1), 'orig_val': snow_m, 'orig_unit': 'm',
                                'meas_code_1': '', 'qc_flag': ''
                            }
                        
                    tendency = safe_get(bufr_handle, f'#{i}#3HourPressureChange')
                    tend_code = safe_get(bufr_handle, f'#{i}#pressureTendency')
                    if tendency is not None:
                        vars_dict['pressure_3hr_change'] = {
                            'val': round(float(tendency) / 100.0, 1), 'orig_val': tendency, 'orig_unit': 'Pa',
                            'meas_code_1': str(int(tend_code)) if tend_code is not None else '', 'qc_flag': ''
                        }

                    ww_code_raw = safe_get(bufr_handle, f'#{i}#presentWeather')
                    if ww_code_raw is not None:
                        try:
                            ww_code = int(ww_code_raw)
                            if 0 < ww_code < 100: 
                                abbr = WMO_4677_TO_ABBR.get(ww_code, 'UNK')
                                val_str = f"{abbr}:{ww_code:02d}"
                                vars_dict['pres_wx_MW1'] = {
                                    'val': val_str, 'orig_val': val_str, 'orig_unit': 'code',
                                    'meas_code_1': '', 'qc_flag': ''
                                }
                        except ValueError:
                            pass

                    # --- BUFR CLOUD EXTRACTION ---
                    
                    # 1. Total Cloud Cover (Okta mapping for sky_condition)
                    tcc = safe_get(bufr_handle, f'#{i}#totalCloudCover')
                    if tcc is not None:
                        tcc_val = int(tcc)
                        tcc_str = ""
                        if 0 <= tcc_val <= 8: tcc_str = f"0{tcc_val}"
                        elif tcc_val == 9: tcc_str = "09"
                        elif tcc_val == 15: tcc_str = "10"
                        
                        if tcc_str:
                            vars_dict['sky_condition'] = {
                                'val': f"{tcc_str};;", 'orig_val': tcc_val, 'orig_unit': 'code',
                                'meas_code_1': '', 'qc_flag': ''
                            }

                    # 2. Discrete Cloud Sequences (Only safe if 1 report per file to avoid array drift)
                    if num_subsets == 1:
                        amts = get_bufr_array(bufr_handle, 'cloudAmount')
                        bases = get_bufr_array(bufr_handle, 'heightOfBaseOfCloud')
                        types = get_bufr_array(bufr_handle, 'cloudType')
                        
                        # Populate sky_condition_baseht from the lowest reported base
                        if bases and bases[0] is not None and bases[0] < 30000.0:
                            vars_dict['sky_condition_baseht'] = {
                                'val': round(bases[0]), 'orig_val': bases[0], 'orig_unit': 'm',
                                'meas_code_1': '', 'qc_flag': ''
                            }

                        # Loop and zip the discrete layer arrays (Up to 4 layers)
                        for layer_idx in range(1, 5):
                            idx = layer_idx - 1
                            amt = amts[idx] if idx < len(amts) else None
                            base = bases[idx] if idx < len(bases) else None
                            ctype = types[idx] if idx < len(types) else None
                            
                            if amt is not None:
                                amt_val = int(amt)
                                cov_str = BUFR_OKTA_MAP.get(amt_val)
                                if cov_str:
                                    vars_dict[f'sky_cover_layer_{layer_idx}'] = {
                                        'val': cov_str, 'orig_val': amt_val, 'orig_unit': 'code',
                                        'meas_code_1': '', 'qc_flag': ''
                                    }
                            
                            if base is not None and base < 30000.0: # Cap unreasonable leak values
                                ctype_str = f"0{int(ctype)}:" if ctype is not None else ":"
                                vars_dict[f'sky_cover_layer_baseht_{layer_idx}'] = {
                                    'val': round(base), 'orig_val': base, 'orig_unit': 'm',
                                    'meas_code_1': ctype_str, 'qc_flag': ''
                                }

                    derive_humidity_and_wetbulb(vars_dict)
                    apply_qc_bounds(vars_dict)

                    minute = int(obs_min) if obs_min is not None else 0
                    
                    dedup_key = f"BUFR_{station}_{obs_d:02d}_{int(obs_hour):02d}_{minute:02d}"
                    local_obs[dedup_key] = {
                        'Station_ID': f"WMO-{station}", 'raw_id': station, 'Source_ID': 412, 
                        'Report_type_code': 'FM12', 'Measurement_code_2': 'BUFR',
                        'Year': obs_y, 'Month': obs_m, 'Day': obs_d, 'Hour': int(obs_hour), 'Minute': minute,
                        'variables': vars_dict
                    }
            except Exception as e: 
                pass
            finally: 
                codes_release(bufr_handle)
    return local_obs


# --- WRITING & FLUSHING ---

def write_iff_psv(obs_list, meta_dict):
    if not obs_list: 
        return 
    
    file_buffers = {}
    
    for obs in obs_list:
        raw_id = obs['raw_id']
        meta = meta_dict.get(raw_id, {})
        
        base_row = {
            "Source_ID": obs['Source_ID'], "Station_ID": obs['Station_ID'],
            "Station_name": meta.get('NAME', ''), "Alias_station_name": "",
            "Year": obs['Year'], "Month": f"{obs['Month']:02d}", "Day": f"{obs['Day']:02d}",
            "Hour": f"{obs['Hour']:02d}", "Minute": f"{obs['Minute']:02d}",
            "Latitude": meta.get('LAT', ''), "Longitude": meta.get('LON', ''), "Elevation": meta.get('ELEV', ''),
            "Source_QC_flag": "", "Original_observed_value": "", "Original_observed_value_units": "",
            "Report_type_code": obs['Report_type_code'], "Measurement_code_1": "", "Measurement_code_2": obs['Measurement_code_2']
        }
        
        for var_name, var_data in obs['variables'].items():
            if var_data is None or var_data['val'] == '': continue
            
            dir_path = os.path.join(BASE_IFF_DIR, var_name, str(obs['Year']), str(obs['Source_ID']))
            
            if dir_path not in file_buffers:
                os.makedirs(dir_path, exist_ok=True)
            
            filename = f"{obs['Station_ID']}-{var_name}-{obs['Source_ID']}.psv"
            filepath = os.path.join(dir_path, filename)
            
            if filepath not in file_buffers:
                file_buffers[filepath] = []
            
            base_row["Observed_value"] = var_data['val']
            base_row["Original_observed_value"] = var_data['orig_val']
            base_row["Original_observed_value_units"] = var_data['orig_unit']
            base_row["Measurement_code_1"] = var_data.get('meas_code_1', '')
            base_row["Source_QC_flag"] = var_data.get('qc_flag', '')
            
            file_buffers[filepath].append(dict(base_row))
            
    for filepath, rows in file_buffers.items():
        file_exists = os.path.isfile(filepath) and os.path.getsize(filepath) > 0
        
        with open(filepath, 'a', newline='', encoding='utf-8') as f:
            writer = csv.DictWriter(f, fieldnames=IFF_HEADERS, delimiter='|')
            if not file_exists:
                writer.writeheader()
            writer.writerows(rows)


# --- POST-PROCESSING SORT & DEDUP ---

def post_process_files(year_str):
    print("\nRunning final cleanup: Sorting and deduplicating updated station files...")
    
    target_sources = ['412', '413']
    psv_files = []
    
    for source in target_sources:
        search_pattern = os.path.join(BASE_IFF_DIR, "*", year_str, source, "*.psv")
        psv_files.extend(glob.glob(search_pattern))
        
    total_files = len(psv_files)
    if total_files == 0:
        print("  --> No PSV files found in target directories to post-process.")
        return
        
    print(f"Found {total_files} target files to sort and clean...")
    
    for count, fp in enumerate(psv_files, 1):
        try:
            df = pd.read_csv(fp, sep='|', dtype=str)
            
            if df.empty:
                continue

            required_cols = ['Year', 'Month', 'Day', 'Hour', 'Minute']
            if not all(col in df.columns for col in required_cols):
                print(f"  --> Skipping {fp}: Missing required headers.")
                continue

            df.drop_duplicates(subset=required_cols, keep='last', inplace=True)
            
            sort_cols = []
            for col in required_cols:
                sort_col = f'_{col}_num'
                df[sort_col] = pd.to_numeric(df[col], errors='coerce')
                sort_cols.append(sort_col)
                
            df.sort_values(by=sort_cols, inplace=True)
            df.drop(columns=sort_cols, inplace=True)
            
            df.to_csv(fp, sep='|', index=False)
            
            del df
            
            if count % 500 == 0:
                gc.collect()
                print(f"  ...sorted and cleaned {count}/{total_files} files")
                
        except Exception as e:
            print(f"  --> Error post-processing {fp}: {e}")
            
    print(f"Successfully sorted and cleaned {total_files} target station files.")

# --- MAIN EXECUTOR ---

def main():
    if len(sys.argv) > 1 and sys.argv[1] == "--clean":
        clean_target_sources(['412', '413'])
        
    print("Starting Sequential IFF Processing (Batch & Flush Architecture)...")
    
    try:
        meta_dict = load_metadata()
    except FileNotFoundError:
        print(f"Warning: Metadata file {METADATA_CSV} not found.")
        meta_dict = {}

    obs_dict = {}

    metar_files = sorted(glob.glob(os.path.join(INPUT_DIR, "*METAR*")))
    synop_files = sorted(glob.glob(os.path.join(INPUT_DIR, "*SYNOP*")))
    bufr_files = sorted(glob.glob(os.path.join(INPUT_DIR, "*.bin")) + glob.glob(os.path.join(INPUT_DIR, "*.bufr")))

    if metar_files:
        print(f"\nExtracting data from {len(metar_files)} METAR files (Chronological)...")
        for count, fp in enumerate(metar_files, 1):
            obs_dict.update(parse_metar_file(fp, meta_dict))
            if count % 50 == 0: 
                write_iff_psv(list(obs_dict.values()), meta_dict)
                obs_dict.clear() 
                print(f"  ...processed and flushed {count}/{len(metar_files)} METARs")
        write_iff_psv(list(obs_dict.values()), meta_dict)
        obs_dict.clear()

    if synop_files:
        print(f"\nExtracting data from {len(synop_files)} SYNOP files (Chronological)...")
        for count, fp in enumerate(synop_files, 1):
            obs_dict.update(parse_synop_file(fp, meta_dict))
            if count % 50 == 0: 
                write_iff_psv(list(obs_dict.values()), meta_dict)
                obs_dict.clear() 
                print(f"  ...processed and flushed {count}/{len(synop_files)} SYNOPs")
        write_iff_psv(list(obs_dict.values()), meta_dict)
        obs_dict.clear()

    if bufr_files:
        print(f"\nExtracting data from {len(bufr_files)} BUFR files (Chronological & Instant Flush)...")
        for count, fp in enumerate(bufr_files, 1):
            
            print(f"  -> Reading {os.path.basename(fp)} ({count}/{len(bufr_files)})...")
            
            try:
                parsed_data = parse_bufr_file(fp, meta_dict)
                obs_dict.update(parsed_data)
            except Exception as e:
                print(f"  *** Failed to parse {os.path.basename(fp)}: {e}")
                continue
            
            write_iff_psv(list(obs_dict.values()), meta_dict)
            obs_dict.clear() 

    current_year_str = datetime.now(timezone.utc).strftime('%Y')
    
    post_process_files(current_year_str)
    
    print("\nProcessing completely finished!")

if __name__ == "__main__":
    main()
