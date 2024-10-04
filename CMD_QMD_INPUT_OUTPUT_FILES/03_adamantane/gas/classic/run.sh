#!/bin/bash -l
#SBATCH --job-name="mace_md"
#SBATCH --account="s1288"
#SBATCH --time=23:00:30
#SBATCH --nodes=1
#SBATCH --ntasks-per-core=1
#SBATCH --ntasks-per-node=12
#SBATCH --cpus-per-task=1
#SBATCH --partition=normal
#SBATCH --constraint=gpu
#SBATCH --hint=nomultithread

export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK
export CRAY_CUDA_MPS=1

module load daint-gpu


source /users/fdellapi/software/mace-venv/bin/activate

rm /tmp/ipi_*
IPI=/users/fdellapi/software/mace-venv/bin/i-pi

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
