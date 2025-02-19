#!/bin/bash

#SBATCH --job-name=iPI-MD
#SBATCH --nodes=2
#SBATCH --tasks-per-node=128
#SBATCH --cpus-per-task=1
#SBATCH --time=24:00:00

# Replace [budget code] below with your project code (e.g. t01)
#SBATCH --account=e865
#SBATCH --partition=standard
#SBATCH --qos=standard



# Avoid any unintentional OpenMP threading by setting OMP_NUM_THREADS
export OMP_NUM_THREADS=1

# Load the VASP module
module load vasp/6/6.4.1-vtst

# Avoid any unintentional OpenMP threading by setting OMP_NUM_THREADS
export OMP_NUM_THREADS=1


#loading python
module load cray-python


#################################################################################

# Load ASE
export PYTHONUSERBASE=/work/e865/e865/fdellapia1/.local
export PATH=$PYTHONUSERBASE/bin:$PATH
export PYTHONPATH=$PYTHONUSERBASE/lib/python3.9/site-packages:$PYTHONPATH


ase=/work/e865/e865/fdellapia1/.local/bin/ase

#################################################################################

srun --distribution=block:block --hint=nomultithread vasp_std

