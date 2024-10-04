#!/bin/bash

#SBATCH --job-name=iPI-MD
#SBATCH --nodes=1
#SBATCH --tasks-per-node=128
#SBATCH --cpus-per-task=1
#SBATCH --time=12:00:00

# Replace [budget code] below with your project code (e.g. t01)
#SBATCH --account=e89-camc
#SBATCH --partition=standard
#SBATCH --qos=standard


# Load the VASP module
module load vasp/6/6.4.1-vtst

# Avoid any unintentional OpenMP threading by setting OMP_NUM_THREADS
export OMP_NUM_THREADS=1

# Launch the code.

srun --distribution=block:block --hint=nomultithread vasp_std
# Load the VASP module
module load vasp/6/6.4.1-vtst

# Avoid any unintentional OpenMP threading by setting OMP_NUM_THREADS
export OMP_NUM_THREADS=1


ase=/work/e89/e89/fd385/.local/bin/ase

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
j=0
# here put the content of the DISP file
for i in \
 "   1  0.00040000  0.00000000  0.00000000 " \
 "   1  0.00000000  0.00040000  0.00000000 " \
 "   1  0.00000000  0.00000000  0.00040000 " \
 "   2  0.00040000  0.00000000  0.00000000 " \
 "   2  0.00000000  0.00040000  0.00000000 " \
 "   2  0.00000000  0.00000000  0.00040000 " \
 "   1 -0.00040000  0.00000000  0.00000000 " \
 "   1  0.00000000 -0.00040000  0.00000000 " \
 "   1  0.00000000  0.00000000 -0.00040000 " \
 "   2 -0.00040000  0.00000000  0.00000000 " \
 "   2  0.00000000 -0.00040000  0.00000000 " \
 "   2  0.00000000  0.00000000 -0.00040000 "
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


ase convert OUTCAR out_${j}.extxyz
cp OUTCAR OUTCAR.${j}

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
