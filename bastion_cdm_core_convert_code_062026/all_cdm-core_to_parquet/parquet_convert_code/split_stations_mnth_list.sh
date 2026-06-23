#split into 5 files:

#!/bin/bash

INPUT="monthly_station_list.txt"
OUTPUT_PREFIX="monthly_station_list"
FILES=("A" "B" "C" "D" "E")

# Shuffle all lines randomly and save to a temp file
shuf "$INPUT" > "${INPUT}.shuf"

# Count total lines
TOTAL_LINES=$(wc -l < "${INPUT}.shuf")
LINES_PER_FILE=$(( (TOTAL_LINES + 4) / 5 ))  # round up to distribute evenly

# Split into 5 files
split -l $LINES_PER_FILE -d -a 1 "${INPUT}.shuf" "${OUTPUT_PREFIX}_tmp_"

# Rename split files to desired labels
for i in {0..4}; do
    mv "${OUTPUT_PREFIX}_tmp_$i" "${OUTPUT_PREFIX}_${FILES[$i]}.txt"
    echo "Created ${OUTPUT_PREFIX}_${FILES[$i]}.txt"
done

# Remove temp shuffled file
rm "${INPUT}.shuf"
####