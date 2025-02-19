from mace.calculators import MACECalculator
from ase.io import read
from ase.thermochemistry import CrystalThermo, HarmonicThermo
from ase.vibrations import Vibrations
from mace.calculators import mace_mp
from ase.phonons import Phonons
from ase.optimize import QuasiNewton
import numpy as np
from mace.calculators.mace import MACECalculator
import os
import shutil
import math


def get_vib_gas(atoms,delta,T):

    vib = Vibrations(atoms,delta=delta)

    # Check if the directory exists
    if os.path.exists('vib') and os.path.isdir('vib'):
    # Delete the directory
        shutil.rmtree('vib')

    vib.run()
    epsilon = vib.get_energies()
    print('number of modes: ',len(epsilon))
    print('number of real modes: ',len(np.real(epsilon)))
    kb = 8.6173303 * 10**(-5) #  eV/K
    zpe = np.sum(np.real(epsilon))/2.

    a = atoms.get_global_number_of_atoms()
    dof =  3*a - 6
    threshold = 1 / 1000 # threshold in eV
    harm = 0
    harm_full = 0
    n = 0
    for i in range(len(np.real(epsilon))):
        if(np.real(epsilon[i])>=threshold):
            n += 1
            harm += np.real(epsilon[i])/ ( np.exp( np.real(epsilon[i])/(kb*T) ) -1)
    harm_full = np.nansum(np.real(epsilon[-dof:])/( np.exp( np.real(epsilon[-dof:])/(kb*T) ) -1))
    print('summed over :', n)
    print(' vibrations at ', T,' K')
    print(vib.summary())
    print('HARM contribution: ',T, zpe + harm, zpe+harm_full)

    
    with open("frequency_vibrational_modes", "w") as file:
        for value in epsilon:
            if np.isreal(value):
                file.write(f"0 {value.real}\n")
            else:
                file.write(f"1 {value.imag}\n")

    return zpe + harm_full






atoms = read('POSCAR')
mace = MACECalculator('/rds/user/fd385/hpc-work/work/MolCrys/SQUARIC_ACID/FINE-TUNE/2/MACE_model_swa.model', default_dtype='float64',device='cuda')
atoms.calc = mace


e  = []
delta = 0.008
for T1 in np.arange(10,310,10):
    a = get_vib_gas(atoms,delta=delta,T=T1)
    e.append([T1,a])
e = np.array(e)

print(e)

# Create the filename using the value of 'delta'
filename = f"Evib_{delta}"

# Write the array 'e' to the file
with open(filename, 'w') as file:
    for item in e:
        file.write(f"{item}\n")
