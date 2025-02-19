#!/bin/bash
#SBATCH --account=MICHAELIDES-SL2-GPU
#SBATCH --output=slurm-%a.out
#SBATCH --partition=ampere
#SBATCH --job-name=mnext
#SBATCH --time=00:04:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --gres=gpu:1

# Load libraries
. /etc/profile.d/modules.sh
module purge
module load rhel8/default-amp

# Python
source /rds/user/fd385/hpc-work/software/mace-venv/bin/activate

python -u run-opt-V.py
