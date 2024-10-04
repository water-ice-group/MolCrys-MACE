from ase.io import read, write 
from ase.build import make_supercell, find_optimal_cell_shape, sort



atoms = read('POSCAR_unit_cell')

r = find_optimal_cell_shape(atoms.cell, 4, 'sc')

atoms = make_supercell(atoms, r)

atoms = sort(atoms)
write(images=atoms,filename='POSCAR', format='vasp')
