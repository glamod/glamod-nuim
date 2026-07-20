#!/bin/bash
### Restarts monthly CDM Core conversion jobs across existing tmux sessions by reactivating the virtual environment and rerunning each assigned file subset.
VENV="/ichec/work/glamod/land_project_workspace/code/r8_202508/hourly/muenv/bin/activate"
SCRIPT="monthly_to_cdm_core_v3.py"

for i in {1..6}; do
    SESSION="mnth_${i}"
    INPUT="mnth_ls${i}.txt"

    # Check session exists
    tmux has-session -t "${SESSION}" 2>/dev/null
    if [ $? -ne 0 ]; then
        echo "Session ${SESSION} does not exist — skipping"
        continue
    fi

    # Restart job inside session (kill running process + relaunch)
    tmux send-keys -t "${SESSION}" C-c
    tmux send-keys -t "${SESSION}" "source ${VENV}" C-m
    tmux send-keys -t "${SESSION}" "python ${SCRIPT} --subset ${INPUT}" C-m

    echo "Restarted job in ${SESSION}"
done

echo "All existing sessions updated."
