how to submit jobs for pq aggregation

./master_parallel_submit.sh sub-daily
./master_parallel_submit.sh daily
./master_parallel_submit.sh monthly

tmux new -s pq_run        # create a new tmux session named pq_run
./master_parallel_submit.sh sub-daily   # run your script inside tmux
# Press Ctrl+b then d to detach and leave it running
tmux attach -t pq_run     # reattach later to check progress


Master bash script:

Splits station list

Runs Python processing in parallel

Logs output for each job

Merges final Parquet files

Creates a summary log

tmux + nohup:

Run the script in a persistent session

Can safely disconnect without killing jobs

Background log file captures stdout/stderr

Output:

Each frequency has its own temp folder per job.

Final Parquet files go into the final output folder.

Logs are stored in *_logs folder.


