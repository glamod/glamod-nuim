import os
import pyarrow as pa
import pyarrow.parquet as pq
import pandas as pd

CHUNK_DIR = "/ichec/work/glamod/land_project_workspace/data/level2/cdm_obs_core/daily_data/r8.1/final_merged_pq/all"

# Target schema
SCHEMA = {
    'station_name': pa.string(),
    'primary_station_id': pa.string(),
    'report_id': pa.string(),
    'observation_id': pa.string(),
    'longitude': pa.float64(),
    'latitude': pa.float64(),
    'height_of_station_above_sea_level': pa.float64(),
    'report_timestamp': pa.timestamp('ns', tz='UTC'),
    'report_meaning_of_time_stamp': pa.int64(),
    'report_duration': pa.int64(),
    'observed_variable': pa.int64(),
    'units': pa.int64(),
    'observation_value': pa.float64(),
    'quality_flag': pa.int64(),
    'source_id': pa.int64(),
    'data_policy_licence': pa.int64(),
    'report_type': pa.int64(),
    'value_significance': pa.int64()
}

def safe_cast(column, typ):
    """Convert column to target type safely."""
    if pa.types.is_integer(typ):
        return pa.array([int(float(x)) if x not in (None, '', 'nan') else None for x in column])
    elif pa.types.is_floating(typ):
        return pa.array([float(x) if x not in (None, '', 'nan') else None for x in column])
    elif pa.types.is_timestamp(typ):
        # Convert using pandas.to_datetime, then to pyarrow array
        return pa.array(pd.to_datetime(column, errors='coerce', utc=True), type=typ)
    else:
        return pa.array([str(x) if x is not None else None for x in column])

def fix_table(table):
    cols = table.column_names
    # Add missing columns with None
    for col, typ in SCHEMA.items():
        if col not in cols:
            table = table.append_column(col, pa.array([None]*table.num_rows, type=typ))
    
    # Reorder columns to match schema
    table = table.select(list(SCHEMA.keys()))
    
    # Cast columns safely
    arrays = [safe_cast(table[col], typ) for col, typ in SCHEMA.items()]
    return pa.Table.from_arrays(arrays, names=list(SCHEMA.keys()))

# Process all chunk files
chunk_files = [os.path.join(CHUNK_DIR, f) for f in os.listdir(CHUNK_DIR) if f.endswith(".pq")]

for f in chunk_files:
    try:
        t = pq.read_table(f)
        t_fixed = fix_table(t)
        pq.write_table(t_fixed, f)
        print(f"✅ Fixed schema: {f}")
    except Exception as e:
        print(f"❌ Failed to fix {f}: {e}")
