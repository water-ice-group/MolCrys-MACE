#!/bin/bash
  
# Slurm job options (job-name, compute nodes, job time)
#SBATCH --job-name=pwscf
#SBATCH --time=24:00:00
#SBATCH --nodes=4
#SBATCH --tasks-per-node=128
#SBATCH --cpus-per-task=1

# Replace [budget code] below with your budget code (e.g. t01)
#SBATCH --account=e743
#SBATCH --partition=standard
#SBATCH --qos=standard

# Set the number of threads to 1
#   This prevents any threaded system libraries from automatically 
#   using threading.
export OMP_NUM_THREADS=1

# Launch the parallel job
#   srun picks up the distribution from the sbatch options

export PYTHONUSERBASE=/work/e743/e743/fladp/.local
export PATH=$PYTHONUSERBASE/bin:$PATH
export PYTHONPATH=$PYTHONUSERBASE/lib/python3.9/site-packages:$PYTHONPATH
export PATH=/work/e743/e743/fladp/CODES/n2p2/bin:$PATH

#loading python

module load PrgEnv-gnu
module load cray-python
module load vasp/6


#################################################################################

header=$(head -n 1 POSCAR_START)
cp SPOSCAR POSCAR

if test -f POSCAR.phon 
then 
  echo "POSCAR.phon exist remove before starting batchfile"
  exit 1
fi
cp POSCAR POSCAR.phon 
#
#  loop over all exited ions
#
j=47
# here put the content of the DISP file
for i in \
 " 811 -0.00000000  0.00000000  0.00048077 " \
 "   1 -0.00050295 -0.00000000 -0.00000000 " \
 "   1 -0.00000000 -0.00053745 -0.00000000 " \
 "   1  0.00000000 -0.00000000 -0.00048077 " \
 "  55 -0.00050295 -0.00000000 -0.00000000 " \
 "  55 -0.00000000 -0.00053745 -0.00000000 " \
 "  55  0.00000000 -0.00000000 -0.00048077 " \
 " 109 -0.00050295 -0.00000000 -0.00000000 " \
 " 109 -0.00000000 -0.00053745 -0.00000000 " \
 " 109  0.00000000 -0.00000000 -0.00048077 " \
 " 163 -0.00050295 -0.00000000 -0.00000000 " \
 " 163 -0.00000000 -0.00053745 -0.00000000 " \
 " 163  0.00000000 -0.00000000 -0.00048077 " \
 " 217 -0.00050295 -0.00000000 -0.00000000 " \
 " 217 -0.00000000 -0.00053745 -0.00000000 " \
 " 217  0.00000000 -0.00000000 -0.00048077 " \
 " 271 -0.00050295 -0.00000000 -0.00000000 " \
 " 271 -0.00000000 -0.00053745 -0.00000000 " \
 " 271  0.00000000 -0.00000000 -0.00048077 " \
 " 325 -0.00050295 -0.00000000 -0.00000000 " \
 " 325 -0.00000000 -0.00053745 -0.00000000 " \
 " 325  0.00000000 -0.00000000 -0.00048077 " \
 " 379 -0.00050295 -0.00000000 -0.00000000 " \
 " 379 -0.00000000 -0.00053745 -0.00000000 " \
 " 379  0.00000000 -0.00000000 -0.00048077 " \
 " 433 -0.00050295 -0.00000000 -0.00000000 " \
 " 433 -0.00000000 -0.00053745 -0.00000000 " \
 " 433  0.00000000 -0.00000000 -0.00048077 " \
 " 487 -0.00050295 -0.00000000 -0.00000000 " \
 " 487 -0.00000000 -0.00053745 -0.00000000 " \
 " 487  0.00000000 -0.00000000 -0.00048077 " \
 " 541 -0.00050295 -0.00000000 -0.00000000 " \
 " 541 -0.00000000 -0.00053745 -0.00000000 " \
 " 541  0.00000000 -0.00000000 -0.00048077 " \
 " 595 -0.00050295 -0.00000000 -0.00000000 " \
 " 595 -0.00000000 -0.00053745 -0.00000000 " \
 " 595  0.00000000 -0.00000000 -0.00048077 " \
 " 649 -0.00050295 -0.00000000 -0.00000000 " \
 " 649 -0.00000000 -0.00053745 -0.00000000 " \
 " 649  0.00000000 -0.00000000 -0.00048077 " \
 " 703 -0.00050295 -0.00000000 -0.00000000 " \
 " 703 -0.00000000 -0.00053745 -0.00000000 " \
 " 703  0.00000000 -0.00000000 -0.00048077 " \
 " 757 -0.00050295 -0.00000000 -0.00000000 " \
 " 757 -0.00000000 -0.00053745 -0.00000000 " \
 " 757  0.00000000 -0.00000000 -0.00048077 " \
 " 811 -0.00050295 -0.00000000 -0.00000000 " \
 " 811 -0.00000000 -0.00053745 -0.00000000 " \
 " 811  0.00000000 -0.00000000 -0.00048077 "
do
j=`expr $j + 1`
echo "run number $j"

#
# use awk to displace atoms (somewhat tricky)
#
awk '
/SUBSIT/  { npos = $2 ; 
            x=$3; y=$4 ; z=$5; }
!/SUBSIT/ { line=line+1 
  if (line-7 == npos) {
    printf "%12.9f %12.9f %12.9f\n", $1+x, $2+y, $3+z
  } 
  else if (line > 7) {
    printf "%12.9f %12.9f %12.9f\n", $1, $2, $3
  } 
  else 
    print 
} ' >POSCAR <<!
SUBSIT $i
`cat POSCAR.phon`
!

#########################################################################################################

if test ! -f out_${j}.extxyz
then
# here the call to PWSCF

# Load the VASP module
srun --distribution=block:block --hint=nomultithread vasp_gam

/work/e743/e743/fladp/.local/bin/ase convert OUTCAR out_${j}.extxyz
fi
#
# use awk to extract forces 
#
#
echo $i >DYNMAT.$j
cat out_${j}.extxyz | awk '{if ( NR>2) printf "%14.8f  %14.8f  %14.8f\n",$5,$6,$7  }' >>DYNMAT.$j
done

# restore POSCAR file
mv POSCAR.phon POSCAR

echo $j > FORCES
i=1
while test $i -le $j
do 
cat DYNMAT.$i >> FORCES
i=`expr $i + 1`
done

cp POSCAR_START POSCAR

