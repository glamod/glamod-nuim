#!/bin/bash
set -euo pipefail

# activate environment
source /ichec/work/glamod/land_project_workspace/code/r8_202508/hourly/muenv/bin/activate

# run jobs in parallel (20 at a time)
cat dec_fix.txt | parallel --jobs 10 python  fix_pressure_decimal_parrallel_use.py {}

