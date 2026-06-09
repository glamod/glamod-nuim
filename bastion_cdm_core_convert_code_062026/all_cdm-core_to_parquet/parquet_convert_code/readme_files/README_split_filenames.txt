# Station List Shuffling and Splitting

This workflow provides two equivalent methods (Bash and Python) to randomly shuffle a station list and split it into 5 balanced files.

------------------------------------------------------------
INPUT
------------------------------------------------------------

Both scripts use the same input file:

sub_daily_station_list.txt

Each line represents one station ID.

------------------------------------------------------------
BASH VERSION
------------------------------------------------------------

Purpose:
- Shuffle station list randomly
- Split into 5 roughly equal files
- Rename outputs A–E

Steps:
1. Shuffle file using `shuf`
2. Count total lines
3. Compute lines per file (rounded up)
4. Split into temporary files
5. Rename outputs
6. Remove temporary shuffled file

Output files:

sub_daily_station_list_A.txt
sub_daily_station_list_B.txt
sub_daily_station_list_C.txt
sub_daily_station_list_D.txt
sub_daily_station_list_E.txt

Notes:
- Uses system `shuf` for randomness
- Ensures even distribution

------------------------------------------------------------
PYTHON VERSION
------------------------------------------------------------

Purpose:
Equivalent implementation using Python (pandas + numpy)

Steps:
1. Load station list using pandas
2. Shuffle randomly (reproducible)
3. Split into 5 equal parts using numpy.array_split
4. Save each part to file

Key features:
- Reproducible shuffle using random_state=42
- Even splitting with np.array_split
- No headers or index in output

Output files:

sub_daily_station_list_A.txt
sub_daily_station_list_B.txt
sub_daily_station_list_C.txt
sub_daily_station_list_D.txt
sub_daily_station_list_E.txt

------------------------------------------------------------
BASH vs PYTHON
------------------------------------------------------------

Bash:
- Uses shuf + split
- Fast and lightweight
- Not reproducible by default

Python:
- Uses pandas + numpy
- Reproducible results
- More flexible and controlled

------------------------------------------------------------
RUNNING

Bash:
bash split_stations.sh

Python:
python split_stations.py