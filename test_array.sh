#!/bin/bash
#SBATCH --job-name=test_job_array
#SBATCH --array=1-3
 
echo “Hello World! I am task $SLURM_ARRAY_TASK_ID of the job array”
sleep 5