# -*- coding: utf-8 -*-
"""
Memory-efficient chunked parallel merge of sub_daily Parquet files with deduplication.
Handles very large files safely, minimal RAM per worker.
"""

import os
import pyarrow.parquet as pq
import pyarrow as pa
import pandas as pd
from glob import glob
from concurrent.futures import ProcessPoolExecutor, as_completed
import argparse
import multiprocessing
import re

CHUNK_SIZE = 1_000_000  # rows per batch to limit memory

# ---------------------------------------------------------------------
# Merge one YYYY_MM tag
# ---------------------------------------------------------------------
def merge_tag(tag, files, output_dir, log_dir):
    """
    Merge a single tag efficiently in chunks, deduplicating by row hash.
    """
    final_path = os.path.join(output_dir, f"insitu-observations-surface-land_sub_daily_{tag}.pq")
    duplicate_log_path = None
    rows_written = 0
    seen_hashes = set()
    dup_rows = []

    try:
        writer = None

        for f in files:
            parquet_file = pq.ParquetFile(f)
            for batch in parquet_file.iter_batches(batch_size=CHUNK_SIZE):
                df = pa.Table.from_batches([batch]).to_pandas()
                row_hash = pd.util.hash_pandas_object(df, index=False)
                df["__row_hash__"] = row_hash

                # Identify duplicates
                mask = df["__row_hash__"].isin(seen_hashes)
                if mask.any():
                    dup_rows.append(df.loc[mask].drop(columns="__row_hash__"))

                df_unique = df.loc[~mask].drop(columns="__row_hash__")
                seen_hashes.update(row_hash[~mask])

                # Write incrementally
                if not df_unique.empty:
                
                    # Remove any pandas index
                    df_unique.reset_index(drop=True, inplace=True)
                
                    table = pa.Table.from_pandas(
                        df_unique,
                        preserve_index=False
                    )
                
                    if writer is None:
                        writer = pq.ParquetWriter(
                            final_path,
                            table.schema,
                            use_dictionary=True
                        )
                
                    writer.write_table(table)
                    rows_written += len(df_unique)
                    del table

                del df, df_unique  # free memory

        if writer:
            writer.close()

        # Write duplicate log
        if dup_rows:
            duplicate_log_path = os.path.join(log_dir, f"duplicates_{tag}.csv")
            pd.concat(dup_rows).to_csv(duplicate_log_path, index=False)

        return {
            "tag": tag,
            "rows": rows_written,
            "files": len(files),
            "duplicate_log": duplicate_log_path
        }

    except Exception as e:
        return {
            "tag": tag,
            "error": str(e),
            "files": len(files)
        }

# ---------------------------------------------------------------------
# Main parallel merge function
# ---------------------------------------------------------------------
def merge_final_pq_parallel(parent_input_dir, output_dir, max_workers=None):
    os.makedirs(output_dir, exist_ok=True)
    log_dir = os.path.join(output_dir, "duplicate_logs")
    os.makedirs(log_dir, exist_ok=True)

    # Discover subdirectories
    subdirs = [d for d in glob(os.path.join(parent_input_dir, "*")) if os.path.isdir(d)]
    print(f"Found {len(subdirs)} subdirectories under {parent_input_dir}")

    # Collect all Parquet files
    pq_files = []
    for d in subdirs:
        pq_files.extend(glob(os.path.join(d, "*.pq")))
    print(f"Found {len(pq_files)} Parquet files to merge")

    if not pq_files:
        print("No Parquet files found. Exiting.")
        return

    # Group by YYYY_MM tag
    file_tags = {}
    pattern = re.compile(r"sub_daily_(\d{4}_\d{2})\.pq$")
    for f in pq_files:
        name = os.path.basename(f)
        match = pattern.search(name)
        if match:
            tag = match.group(1)
            file_tags.setdefault(tag, []).append(f)
        else:
            print(f"⚠️ Skipping unrecognized file: {name}")

    print(f"Preparing to merge {len(file_tags)} YYYY_MM tags")

    if max_workers is None:
        max_workers = max(1, multiprocessing.cpu_count() - 2)

    results = []
    failed = []

    with ProcessPoolExecutor(max_workers=max_workers) as executor:
        futures = {executor.submit(merge_tag, tag, files, output_dir, log_dir): tag for tag, files in file_tags.items()}
        for future in as_completed(futures):
            res = future.result()
            if "error" in res:
                failed.append(res)
                print(f"❌ Failed {res['tag']}: {res['error']}")
            else:
                results.append(res)
                msg = f"✅ {res['tag']}: {res['files']} files → {res['rows']} rows"
                if res["duplicate_log"]:
                    msg += " (duplicates logged)"
                print(msg)

    total_rows = sum(r.get("rows", 0) for r in results)
    print("\n🎉 FINAL MERGE COMPLETE")
    print(f"   Total merged rows: {total_rows}")
    print(f"   Output directory: {output_dir}")
    print(f"   Duplicate logs:  {log_dir}")
    
    if failed:
        fail_log = os.path.join(output_dir, "failed_merge_log_sbdy.csv")
        pd.DataFrame(failed).to_csv(fail_log, index=False)
        print(f"⚠️  {len(failed)} tags failed. See {fail_log}")

# ---------------------------------------------------------------------
# CLI
# ---------------------------------------------------------------------
if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Chunked memory-efficient parallel merge of sub_daily Parquet files")
    parser.add_argument("--parent_input_dir", required=True, help="Parent directory with subfolders containing Parquet files")
    parser.add_argument("--output_dir", required=True, help="Directory to write merged Parquet files")
    parser.add_argument("--max_workers", type=int, help="Max parallel workers (default: cores-2)")

    args = parser.parse_args()
    merge_final_pq_parallel(args.parent_input_dir, args.output_dir, args.max_workers)
