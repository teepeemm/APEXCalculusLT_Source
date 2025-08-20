#!/bin/bash -l
#-----------------------------------
# David Apostal
# UND Computational Research Center
#
# Timothy Prescott
# UND Math Dept
#
# Submit:
#   sbatch this-file.sh
#
# Check status:
#   squeue | grep [userid]
#   squeue -u $USER
#   squeue -j [jobid]
#-----------------------------------

# use
# git pull origin master
# to make sure the code is up to date

#SBATCH --job-name=books
#SBATCH --partition=talon

# Sets the maximum time the job can run (hh:mm:ss).
#SBATCH --time=24:00:00

# Specifies nodes for the job.
#SBATCH --nodes=1

# Sets the output file name. %x = job-name, %j = job-id
#SBATCH --output=./%x.%j.out.txt
#SBATCH --error=./%x.%j.err.txt

# Job events (mail-type): begin, end, fail, all.
#SBATCH --mail-type=all
#SBATCH --mail-user=timothy.prescott@und.edu

# megabytes needed, default is 5000
#SBATCH --mem 8000

# load required modules here
#module load apptainer
# print the loaded modules
#module list

echo ""
echo "Job started at $(date)"
echo ""

source ~/.venv/bin/activate
#python3 make.py -bc1
#python3 make.py -bc2
python3 make.py --all
exit_code=$?
deactivate

echo ""
echo "Job finished at $(date)"
echo ""

tar czf talon-logs.tar.gz logs/
cd ApexPDFs
tar czf bigpdfs.tar.gz bigpdfs/

if [ "$exit_code" -ne "0" ]; then
    echo "job failed"
    exit "$exit_code"
fi
