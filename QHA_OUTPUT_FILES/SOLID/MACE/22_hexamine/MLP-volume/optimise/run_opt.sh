#!/bin/bash -l
#SBATCH --job-name="mace_md"
#SBATCH --account="s1288"
#SBATCH --time=00:30:00
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

which python 

python run-optimize.py
