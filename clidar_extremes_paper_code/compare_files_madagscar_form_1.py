# -*- coding: utf-8 -*-
"""
Created on Wed Feb 26 12:40:35 2025

@author: snoone
"""

# -*- coding: utf-8 -*-
"""
Created on Wed Feb 26 12:40:35 2025

@author: snoone
"""
import re
import os
import pandas as pd

SKIP_ROWS = 6
HEADER_ADJUST = 1
ROW_ADJUSTMENT = SKIP_ROWS + HEADER_ADJUST
MAX_ROWS = 37 - SKIP_ROWS  # Limit rows to read after skipping

def normalize_filename(filename):
    """Normalize filenames by converting '01', '02', etc., to '1', '2'."""
    return re.sub(r'(/D)0*(/d+)', r'/1/2', filename)

def list_excel_files(directory):
    """List all Excel files in a given directory."""
    return [f for f in os.listdir(directory) if f.endswith('.xlsx')]

def safe_read_excel(filepath, **kwargs):
    """Safely read an Excel file and handle errors."""
    try:
        return pd.read_excel(filepath, **kwargs)
    except Exception as e:
        print(f"Error reading {filepath}: {e}")
        return None

def read_excel_files(directory, filenames):
    """Read Excel files, process them, and store them in a dictionary."""
    dataframes = {}
    for filename in filenames:
        filepath = os.path.join(directory, filename)

        # Read the Excel file skipping rows and limiting to MAX_ROWS
        df = safe_read_excel(filepath, skiprows=SKIP_ROWS, header=None, nrows=MAX_ROWS)
        if df is not None:
            # Name columns and drop unwanted ones
            df = df.iloc[:, :13]  # Restrict the DataFrame to the first 15 columns
            df.columns = ["Day", "precip_17", "precip7", "total_precip", "evap_18", "evap_7", "evap_total",
                          "8", "9", "10", "11", "12", "13"][:df.shape[1]]
            df = df.drop(columns=[col for col in ["8", "9", "10", "11", "12", "13"] if col in df.columns])
            dataframes[filename] = df

    return dataframes

def compare_files(data1, data2, output_file):
    """Compare dataframes from two directories and write mismatches to a file."""
    mismatched_info = []

    for filename in data1:
        if filename in data2:
            df1 = data1[filename]
            df2 = data2[filename]

            if df1.shape != df2.shape:
                mismatched_info.append(f"File '{filename}': Shapes do not match ({df1.shape} vs {df2.shape})/n")
                continue

            # Compare values and log mismatched rows and columns
            for row in range(df1.shape[0]):
                for col in range(df1.shape[1]):
                    val1 = df1.iat[row, col]
                    val2 = df2.iat[row, col]

                    # Check if both values are NaN; if so, skip this mismatch
                    if pd.isna(val1) and pd.isna(val2):
                        continue

                    # Check specific combinations to skip
                    if (
                        (pd.isna(val1) and val2 in ["NT", "Traces", ".", "Trace"]) or
                        (pd.isna(val2) and val1 in ["NT", "Traces", ".", "Trace"]) or
                        (val1 in ["Traces"] and val2 in ["Trace"]) or
                        (val2 in ["Traces"] and val1 in ["Trace"])or
                        (val1 in ["NT"] and val2 in ["Nt"]) or
                        (val2 in ["NT"] and val1 in ["Nt"])or
                        (val1 in ["NT"] and val2 in ["nt"]) or
                        (val2 in ["NT"] and val1 in ["nt"])
                    ):
                        continue

                    # Log mismatches where values are not equal
                    column_name = df1.columns[col]
                    if val1 != val2:
                        mismatched_info.append(
                            f"File '{filename}': Mismatch at Row {row + 1}, Column {col + 1} ({column_name}) "
                            f"(Value1: {val1}, Value2: {val2})/n"
                        )

    # Write mismatched information to the output file
    if mismatched_info:
        with open(output_file, 'w') as f:
            f.writelines(mismatched_info)
        print(f"Mismatched information written to {output_file}")
    else:
        print("No mismatched rows or columns found.")

def log_unmatched_files(directory1, directory2, unmatched_file):
    """Log filenames that are not matched between two directories."""
    files1 = set(list_excel_files(directory1))
    files2 = set(list_excel_files(directory2))

    unmatched_files = []

    unmatched_files += [f"File '{filename}' not in directory2/n" for filename in files1 if filename not in files2]
    unmatched_files += [f"File '{filename}' not in directory1/n" for filename in files2 if filename not in files1]

    if unmatched_files:
        with open(unmatched_file, 'w') as f:
            f.writelines(unmatched_files)
        print(f"Unmatched filenames written to {unmatched_file}")
    else:
        print("All files match between the directories.")

def main(directory1, directory2, output_file, unmatched_file):
    """Main function to compare Excel files in two directories."""
    files1 = list_excel_files(directory1)
    files2 = list_excel_files(directory2)

    # Find common files between the two directories
    common_files = set(files1).intersection(files2)

    if not common_files:
        print("No common files found in the directories.")
        return

    # Read and process the files from both directories
    data1 = read_excel_files(directory1, common_files)
    data2 = read_excel_files(directory2, common_files)

    # Compare the files and write mismatches to the output file
    compare_files(data1, data2, output_file)

    # Log unmatched filenames to the unmatched_file
    log_unmatched_files(directory1, directory2, unmatched_file)

# Example usage
if __name__ == "__main__":
    directory1 = 'C:/Users/snoone/Dropbox/OLD_BELGIAN_AFRICAN_DARE_INVENTORY/data_for_transcribing_2023/completed_kentucky_data_rescue_2025/completed_forms/file_A/form1'
    directory2 = 'C:/Users/snoone/Dropbox/OLD_BELGIAN_AFRICAN_DARE_INVENTORY/data_for_transcribing_2023/completed_kentucky_data_rescue_2025/completed_forms/file_B/form1'
    output_file = 'C:/Users/snoone/Dropbox/OLD_BELGIAN_AFRICAN_DARE_INVENTORY/data_for_transcribing_2023/completed_kentucky_data_rescue_2025/completed_forms/marolambo_mismatched_form1.txt'
    unmatched_file = 'C:/Users/snoone/Dropbox/OLD_BELGIAN_AFRICAN_DARE_INVENTORY/data_for_transcribing_2023/completed_kentucky_data_rescue_2025/completed_forms/marolambo_unmatched_form1.txt'
    main(directory1, directory2, output_file, unmatched_file)
