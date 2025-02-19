import os
import sys
import numpy as np
from ase.calculators.socketio import SocketClient
from ase.calculators.calculator import Calculator, all_changes
from ase.io import read
from mace.calculators.mace import MACECalculator


mace=MACECalculator('/rds/user/fd385/hpc-work/work/MolCrys/ASPIRIN/FINE-TUNE/2/MACE_model_swa.model', default_dtype='float64',device='cuda')


atoms=read('POSCAR',0)
atoms.calc = mace


# Create Client
# unix
port = 11111
host = "DH"
print ("Setting up socket.")
client = SocketClient(unixsocket=host)
print ("Running socket.")
client.run(atoms,use_stress=True)
print ("setting up calculator")
