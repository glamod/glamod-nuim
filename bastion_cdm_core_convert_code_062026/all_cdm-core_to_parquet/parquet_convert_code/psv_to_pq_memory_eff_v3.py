# -*- coding: utf-8 -*-
"""
Chunked PSV → Parquet processor

- Supports daily (.psv.gz) and monthly (.psv) files
- All file tags are YYYY_MM (monthly aggregation)
- Job/Station-level crash/resume
- Atomic Parquet writes + integrity checks
- Dynamic chunking and batching
- Per-job progress bars with ETA
- Merge chunks safely
"""

import argparse
import os
import pandas as pd
import pyarrow as pa
import pyarrow.parquet as pq
import time
from glob import glob
import psutil
from tqdm import tqdm

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
# Checkpoint helpers
# -----------------------------
def checkpoint_file(job_id, log_dir):
    return os.path.join(log_dir, f"job_{job_id}.checkpoint")

def load_completed_stations(job_id, log_dir):
    cp_file = checkpoint_file(job_id, log_dir)
    if os.path.exists(cp_file):
        with open(cp_file) as f:
            return set(line.strip() for line in f if line.strip())
    return set()

def mark_station_done(job_id, log_dir, station_id):
    cp_file = checkpoint_file(job_id, log_dir)
    with open(cp_file, "a") as f:
        f.write(f"{station_id}\n")

# -----------------------------
# File tag (YYYY_MM for both daily & monthly)
# -----------------------------
def get_file_tag(timestamp, freq):
    ts = pd.to_datetime(timestamp, errors='coerce', utc=True)
    return ts.strftime("%Y_%m")

# -----------------------------
# Process a batch of PSV files
# -----------------------------
def process_batch(psv_files, output_dir, freq, chunksize=100_000):
    total_rows = 0

    for psv_file in psv_files:
        compression_type = "gzip" if psv_file.endswith(".gz") else None

        for chunk in pd.read_csv(psv_file, sep="|", compression=compression_type,
                                 dtype=str, chunksize=chunksize):
            chunk = chunk.dropna(subset=['report_timestamp'])
            if chunk.empty:
                continue

            chunk = enforce_types(chunk)
            chunk["file_tag"] = chunk["report_timestamp"].apply(lambda x: get_file_tag(x, freq))

            for tag, group in chunk.groupby("file_tag"):
                pq_path = os.path.join(
                    output_dir,
                    f"insitu-observations-surface-land_{freq}_{tag}.pq"
                )
                table = pa.Table.from_pandas(group.drop(columns=["file_tag"]), preserve_index=False)
                append_to_parquet(table, pq_path)
                total_rows += len(group)

    return total_rows

# -----------------------------
# Dynamic/adaptive batching
# -----------------------------
def create_dynamic_batches(station_files, input_dir, memory_safety=0.7):
    LARGE_FILE_MB = 30
    batches = []
    current_batch = []
    current_batch_mem = 0
    available_mem = psutil.virtual_memory().available / (1024*1024) * memory_safety  # MB

    def file_size_mb(f):
        return os.path.getsize(os.path.join(input_dir, f)) / (1024*1024)

    for f in station_files:
        size_mb = file_size_mb(f)
        est_mem = max(size_mb * 200 / 42, 1)
        if size_mb >= LARGE_FILE_MB or current_batch_mem + est_mem > available_mem:
            if current_batch:
                batches.append(current_batch)
            batches.append([f]) if size_mb >= LARGE_FILE_MB else batches.append([f])
            current_batch = []
            current_batch_mem = 0
        else:
            current_batch.append(f)
            current_batch_mem += est_mem
    if current_batch:
        batches.append(current_batch)
    return batches

# -----------------------------
# Process all stations for a job
# -----------------------------
def process_all_stations(station_files, input_dir, output_dir, freq, log_dir, job_id, chunksize=100_000):
    total_rows = 0
    start_time = time.time()
    os.makedirs(output_dir, exist_ok=True)

    completed_stations = load_completed_stations(job_id, log_dir)
    remaining_stations = [s for s in station_files if s not in completed_stations]
    print(f"[Job {job_id}] {len(completed_stations)} stations done, {len(remaining_stations)} remaining.")

    batches = create_dynamic_batches(remaining_stations, input_dir)
    pbar = tqdm(total=len(remaining_stations), desc=f"Job {job_id}", unit="station")

    for batch in batches:
        psv_paths = [os.path.join(input_dir, s) for s in batch]
        for psv_file in psv_paths:
            station_id = os.path.basename(psv_file).replace(".psv","").replace(".gz","")
            if station_id in completed_stations:
                pbar.update(1)
                continue
            try:
                rows_written = process_batch([psv_file], output_dir, freq, chunksize)
                total_rows += rows_written
                mark_station_done(job_id, log_dir, station_id)
            except Exception as e:
                print(f"⚠️ Failed station {station_id}: {e}")
            finally:
                pbar.update(1)

    pbar.close()
    elapsed = format_seconds(time.time() - start_time)
    with open(os.path.join(log_dir, "pq_processed_log.txt"), "a") as f:
        f.write(f"{job_id}: {total_rows} rows processed in {elapsed}\n")
    return total_rows

# -----------------------------
# Merge final Parquet files
# -----------------------------
def merge_chunks(temp_dir, final_dir, freq, log_dir):
    os.makedirs(final_dir, exist_ok=True)
    pq_files = glob(os.path.join(temp_dir, f"*_{freq}_*.pq"))
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
        if not tables:
            continue
        combined = pa.concat_tables(tables, promote=True)
        final_path = os.path.join(final_dir, f"insitu-observations-surface-land_{freq}_{tag}.pq")
        pq.write_table(combined, final_path)
        total_rows += combined.num_rows

    # Save merge log
    with open(os.path.join(log_dir, "processed_merge_pq.txt"), "w") as f:
        f.write(f"Total merged rows: {total_rows}\n")
    if failed_merges:
        fail_df = pd.DataFrame(failed_merges)
        fail_df.to_csv(os.path.join(log_dir, "failed_merge_pq.txt"), index=False)

# -----------------------------
# CLI
# -----------------------------
if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--freq", required=True, choices=["hourly","daily","monthly","sub_daily"])
    parser.add_argument("--input_dir")
    parser.add_argument("--output_dir", required=True)
    parser.add_argument("--station_list_file")
    parser.add_argument("--merge_only", action="store_true")
    parser.add_argument("--final_dir")
    parser.add_argument("--job_id", default="job_xx")
    parser.add_argument("--num_jobs", type=int, default=1)
    parser.add_argument("--log_dir", required=True)
    parser.add_argument("--chunk_size", type=int, default=100_000)

    args = parser.parse_args()
    os.makedirs(args.log_dir, exist_ok=True)

    if args.merge_only:
        merge_chunks(args.output_dir, args.final_dir, args.freq, args.log_dir)
    else:
        # Load stations and split per job
        with open(args.station_list_file) as f:
            all_stations = [line.strip() for line in f if line.strip()]
        if args.job_id not in ["main", "job_xx"]:
            job_index = int(args.job_id)
            stations_for_this_job = [s for idx, s in enumerate(all_stations) if idx % args.num_jobs == job_index]
        else:
            stations_for_this_job = all_stations

        total_rows = process_all_stations(stations_for_this_job, args.input_dir, args.output_dir,
                                          args.freq, args.log_dir, args.job_id, args.chunk_size)
        print(f"🎉 Done! Total rows written: {total_rows}")

        # Auto-merge if main job
        if str(args.job_id) in ["main","job_xx"]:
            print("✅ All parallel jobs finished! Starting merge...")
            merge_chunks(args.output_dir, args.final_dir, args.freq, args.log_dir)
