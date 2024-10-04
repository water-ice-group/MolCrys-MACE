import os
import sys
import numpy as np
from ase.calculators.socketio import SocketClient
from ase.calculators.calculator import Calculator, all_changes
from ase.io import read
from mace.calculators.mace import MACECalculator


mace=MACECalculator('/scratch/snx3000/fdellapi/MolCrys/X23_VASP/models/full_qne/models/REPULSION-2/15_oxalic_acid_beta/MACE_model_swa.model', default_dtype='float64',device='cuda')


atoms=read('POSCAR',0)
atoms.calc = mace


# Create Client
# unix
port = 11111
host = "lJ"
print ("Setting up socket.")
client = SocketClient(unixsocket=host)
print ("Running socket.")
client.run(atoms,use_stress=True)
print ("setting up calculator")
