import numpy as np
from ase.io import read, write
from mace.calculators.mace import MACECalculator
from ase.constraints import UnitCellFilter
from ase.optimize import QuasiNewton
from ase.spacegroup.symmetrize import FixSymmetry


atom=read('POSCAR_START','0')
path_to_model='/rds/user/fd385/hpc-work/work/MolCrys/PARACETAMOL/FINE-TUNE/2'

model_paths=[]
model_paths.append(str(path_to_model)+'/MACE_model_swa.model')

models=[]
models.append(MACECalculator(model_paths[0], default_dtype='float64',device='cuda'))


conv = 160.21766208 # from eV/A^3 to kbar
for pressure in [0]:
    atoms = atom.copy()
    atoms.calc = models[0]

#    atoms.set_constraint(FixSymmetry(atoms))
    ucf = UnitCellFilter(atoms, scalar_pressure=pressure/conv) # ase wants pressure in eV/A^3
    qn_vc = QuasiNewton(ucf,trajectory='vc.traj')
    qn_vc.run(fmax=10**(-6))


    atoms_fc=atoms.copy()
    atoms_fc.calc=models[0]
    qn_fc=QuasiNewton(atoms_fc,trajectory='fc.traj')
    qn_fc.run(fmax=10**(-7))

    write(images=atoms_fc,format='vasp',filename='POSCAR_'+str(pressure))
