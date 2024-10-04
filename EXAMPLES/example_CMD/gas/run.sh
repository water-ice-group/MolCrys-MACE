
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

python3 run-ase.py
