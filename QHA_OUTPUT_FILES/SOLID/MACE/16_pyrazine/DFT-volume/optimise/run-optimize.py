import numpy as np
from ase.io import read, write
from mace.calculators.mace import MACECalculator
from ase.constraints import UnitCellFilter
from ase.optimize import QuasiNewton

atoms=read('POSCAR_START','0')
path_to_model='/scratch/snx3000/fdellapi/MolCrys/X23_VASP/models/full_qne/models/REPULSION-2/16_pyrazine'

model_paths=[]
model_paths.append(str(path_to_model)+'/MACE_model_swa.model')

models=[]
models.append(MACECalculator(model_paths[0], default_dtype='float64',device='cuda'))

atoms.calc=models[0]


atoms_fc=atoms.copy()
atoms_fc.calc=models[0]
qn_fc=QuasiNewton(atoms_fc,trajectory='fc.traj')
qn_fc.run(fmax=10**(-5))

write(images=atoms_fc,format='vasp',filename='POSCAR')
