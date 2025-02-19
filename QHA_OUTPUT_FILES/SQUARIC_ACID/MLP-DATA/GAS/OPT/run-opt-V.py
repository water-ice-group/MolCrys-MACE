import numpy as np
from ase.io import read, write
from mace.calculators.mace import MACECalculator
from ase.constraints import UnitCellFilter
from ase.optimize import QuasiNewton
from ase.spacegroup.symmetrize import FixSymmetry


atom=read('POSCAR_START','0')
path_to_model='/rds/user/fd385/hpc-work/work/MolCrys/SQUARIC_ACID/FINE-TUNE/2'

model_paths=[]
model_paths.append(str(path_to_model)+'/MACE_model_swa.model')

models=[]
models.append(MACECalculator(model_paths[0], default_dtype='float64',device='cuda'))


conv = 160.21766208 # from eV/A^3 to kbar

atoms_fc=atom.copy()
atoms_fc.calc=models[0]
qn_fc=QuasiNewton(atoms_fc,trajectory='fc.traj')
qn_fc.run(fmax=10**(-8))

write(images=atoms_fc,format='vasp',filename='POSCAR')
