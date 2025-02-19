#!/bin/bash
#SBATCH --account=MICHAELIDES-SL2-GPU
#SBATCH --output=slurm.out
#SBATCH --partition=ampere
#SBATCH --job-name=runphon
#SBATCH --time=23:00:30
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --gres=gpu:1

# Load libraries
. /etc/profile.d/modules.sh
module purge
module load rhel8/default-amp

# Python
source /rds/user/fd385/hpc-work/software/mace-venv/bin/activate

# Print start time
echo "Script started at: $(date)"

which python 

rm /tmp/ipi_*
IPI=/rds/user/fd385/hpc-work/software/mace-venv/bin/i-pi

if ! [ -f "simulation.chk" ]; then
python3 $IPI input.xml > log.i-pi &
else
python3 $IPI simulation.chk > log.i-pi &
fi

sleep 20

echo "Running main simulation script."

timeout 82800 python3 run-ase.py

echo "Running check and resubmit script."
python3 check_and_resubmit.py >> output_checking_completeness
