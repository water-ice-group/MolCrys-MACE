import re
import sys
import numpy as np
from ase.io import read, write
from mace.calculators.mace import MACECalculator

path_to_model='/scratch/snx3000/fdellapi/MolCrys/X23_VASP/models/full_qne/models/REPULSION-2/01_cyclohexanedione'
model_paths=[]
model_paths.append(str(path_to_model)+'/MACE_model_swa.model')
models=[]
models.append(MACECalculator(model_paths[0], default_dtype='float64',device='cuda'))

DISP=sys.argv[1:]
DISP = [float(value) for value in DISP]

atoms=read('POSCAR.phon','0')
atoms.calc=models[0]

forces=atoms.get_forces()


with open('FORCES','a') as f:
	f.write("%d  %2.8lf  %2.8lf  %2.8lf\n"%(DISP[0],DISP[1],DISP[2],DISP[3]))
	for i in range(len(forces)):
		f.write("   %12.8lf    %12.8lf    %12.8lf\n"%(forces[i,0],forces[i,1],forces[i,2]))
f.close()
