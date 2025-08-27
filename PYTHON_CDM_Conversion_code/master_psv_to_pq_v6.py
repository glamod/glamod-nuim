#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Append-safe PSV → Parquet processor with batch support + logging
"""

import argparse
import os
import pandas as pd
import pyarrow as pa
import pyarrow.parquet as pq
import time
from glob import glob

# -----------------------------
# Schema definition
# -----------------------------
SCHEMA_DTYPES = {
    'station_name': 'string',
    'primary_station_id': 'string',
    'report_id': 'string',
    'observation_id': 'string',
    'longitude': 'float64',
    'latitude': 'float64',
    'height_of_station_above_sea_level': 'float64',
    'report_timestamp': 'datetime64[ns, UTC]',
    'report_meaning_of_time_stamp': 'Int64',
    'report_duration': 'Int64',
    'observed_variable': 'Int64',
    'units': 'Int64',
    'observation_value': 'float64',
    'quality_flag': 'Int64',
    'source_id': 'Int64',
    'data_policy_licence': 'Int64',
    'report_type': 'Int64',
    'value_significance': 'Int64'
}

COLUMN_ORDER = list(SCHEMA_DTYPES.keys())

# -----------------------------
# Helpers
# -----------------------------
def enforce_types(df):
    for col, dtype in SCHEMA_DTYPES.items():
        if col in df.columns:
            if 'datetime64' in dtype:
                df[col] = pd.to_datetime(df[col], errors='coerce', utc=True)
            elif 'float' in dtype:
                df[col] = pd.to_numeric(df[col], errors='coerce')
            elif 'Int64' in dtype:
                df[col] = pd.to_numeric(df[col], errors='coerce').astype('Int64')
            else:
                df[col] = df[col].astype('string')
    return df[[c for c in COLUMN_ORDER if c in df.columns]]

def format_seconds(seconds):
    h = int(seconds // 3600)
    m = int((seconds % 3600) // 60)
    s = int(seconds % 60)
    return f"{h:02d}:{m:02d}:{s:02d}"

def get_file_tag(timestamp, freq):
    ts = pd.to_datetime(timestamp, errors='coerce', utc=True)
    if freq in ['hourly', 'daily']:
        return ts.strftime("%Y_%m")
    elif freq == 'monthly':
        return ts.strftime("%Y")
    else:
        return ts.strftime("%Y_%m")

def append_to_parquet(table, pq_path):
    """Append safely: combine with existing Parquet if exists."""
    for col, dtype in SCHEMA_DTYPES.items():
        if col in table.column_names:
            if dtype == 'float64':
                table = table.set_column(table.schema.get_field_index(col),
                                         col,
                                         table[col].cast(pa.float64()))
            elif dtype == 'Int64':
                table = table.set_column(table.schema.get_field_index(col),
                                         col,
                                         table[col].cast(pa.int64()))
    if os.path.exists(pq_path):
        existing_table = pq.read_table(pq_path)
        combined = pa.concat_tables([existing_table, table], promote=True)
        pq.write_table(combined, pq_path)
    else:
        pq.write_table(table, pq_path)

# -----------------------------
# Batch processor
# -----------------------------
def process_batch(psv_files, output_dir, freq, log_dir):
    total_rows = 0
    failed_rows = []
    os.makedirs(output_dir, exist_ok=True)

    for psv_file in psv_files:
        try:
            df = pd.read_csv(psv_file, sep="|", compression="gzip", dtype=str)
        except Exception as e:
            failed_rows.append({"file": psv_file, "error": str(e)})
            continue

        df = df.dropna(subset=['report_timestamp'])
        if df.empty:
            continue

        df = enforce_types(df)
        df["file_tag"] = df["report_timestamp"].apply(lambda x: get_file_tag(x, freq))

        for tag, group in df.groupby("file_tag"):
            pq_path = os.path.join(output_dir, f"insitu-observations-surface-land_{freq}_{tag}.pq")
            table = pa.Table.from_pandas(group.drop(columns=["file_tag"]), preserve_index=False)
            append_to_parquet(table, pq_path)
            total_rows += len(group)

    # Save failed rows if any
    if failed_rows:
        fail_df = pd.DataFrame(failed_rows)
        fail_path = os.path.join(log_dir, "failed_rows.pq")
        fail_table = pa.Table.from_pandas(fail_df, preserve_index=False)
        append_to_parquet(fail_table, fail_path)

    return total_rows

# -----------------------------
# Main processor
# -----------------------------
def process_all_stations(station_files, input_dir, output_dir, freq, batch_size, log_dir, job_id):
    total_rows = 0
    job_start = time.time()

    for i in range(0, len(station_files), batch_size):
        batch = station_files[i:i+batch_size]
        psv_paths = [os.path.join(input_dir, f) for f in batch]
        total_rows += process_batch(psv_paths, output_dir, freq, log_dir)

    job_elapsed = format_seconds(time.time() - job_start)

    with open(os.path.join(log_dir, "pq_processed_log.txt"), "a") as logf:
        logf.write(f"{job_id}: {total_rows} rows processed in {job_elapsed}\n")

    return total_rows

# -----------------------------
# Merge final Parquet files
# -----------------------------
def merge_chunks(temp_dir, final_dir, freq, log_dir):
    os.makedirs(final_dir, exist_ok=True)
    pq_files = glob(os.path.join(temp_dir, f"*/insitu-observations-surface-land_{freq}_*.pq"))

    file_tags = {}
    for pq_file in pq_files:
        base = os.path.basename(pq_file).split(f"{freq}_")[1].split(".pq")[0]
        file_tags.setdefault(base, []).append(pq_file)

    total_rows = 0
    failed_merges = []

    for tag, files in file_tags.items():
        tables = []
        for f in files:
            try:
                tables.append(pq.read_table(f))
            except Exception as e:
                failed_merges.append({"file": f, "error": str(e)})
                continue
        if not tables:
            continue

        combined = pa.concat_tables(tables, promote=True)
        df = combined.to_pandas()
        df = df[[c for c in COLUMN_ORDER if c in df.columns]]
        combined = pa.Table.from_pandas(df, preserve_index=False)

        final_label = "sub_daily" if freq == "hourly" else freq
        pq.write_table(combined, os.path.join(final_dir, f"insitu-observations-surface-land_{final_label}_{tag}.pq"))

        total_rows += len(df)

    # Save merge logs
    with open(os.path.join(log_dir, "processed_merge_pq.txt"), "w") as f:
        f.write(f"Total merged rows: {total_rows}\n")

    if failed_merges:
        fail_df = pd.DataFrame(failed_merges)
        fail_path = os.path.join(log_dir, "failed_merge_pq.txt")
        fail_df.to_csv(fail_path, index=False)

# -----------------------------
# CLI
# -----------------------------
if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--freq", required=True, choices=["hourly","daily","monthly"])
    parser.add_argument("--input_dir")
    parser.add_argument("--output_dir", required=True)
    parser.add_argument("--station_list_file")
    parser.add_argument("--merge_only", action="store_true")
    parser.add_argument("--final_dir")
    parser.add_argument("--batch_size", type=int, default=50)
    parser.add_argument("--job_id", default="job_xx")

    args = parser.parse_args()

    # Create freq-specific log dir
    log_dir = f"/ichec/work/glamod/land_project_workspace/data/level2/cdm_obs_core/sub_daily_data/r8/{args.freq}_logs"
    os.makedirs(log_dir, exist_ok=True)

    start_time = time.time()

    if args.merge_only:
        merge_chunks(args.output_dir, args.final_dir, args.freq, log_dir)
    else:
        with open(args.station_list_file) as f:
            all_stations = [line.strip() for line in f if line.strip()]

        total_rows_written = process_all_stations(
            all_stations, args.input_dir, args.output_dir, args.freq,
            args.batch_size, log_dir, args.job_id
        )
        print(f"🎉 Done! Total rows written: {total_rows_written}")

    total_elapsed = time.time() - start_time
    print(f"⏱ Total processing time: {format_seconds(total_elapsed)}")
    with open(os.path.join(args.output_dir, "total_runtime.txt"), "w") as f:
        f.write(f"Total processing time: {format_seconds(total_elapsed)} ({round(total_elapsed,2)} sec)\n")
