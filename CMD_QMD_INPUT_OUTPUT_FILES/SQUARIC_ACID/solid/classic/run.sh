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
