import sys
import ase
from ase.io import iread, write
from ase.build import make_supercell
import numpy as np

def print_ipi_xyz(libatomfilename, outfilename):
    """
    Reads an atoms object and prints 
    out an i-PI formatted xyz file.
    """
    
    f = open(outfilename, 'w')

    for i, atoms in enumerate(iread(libatomfilename)):

      #P = np.eye(3)
      #P[0,0] = 1
      #P[1,1] = 1
      #atoms = make_supercell(atoms, P)

      nat = atoms.get_global_number_of_atoms()
      s = atoms.get_chemical_symbols()
      q = atoms.get_positions()
      q.reshape((nat,3))
      h = atoms.get_cell()
      h = tuple(h.flatten())
      print(nat, file=f)
      print("# CELL(GENH): %10.5f %10.5f %10.5f %10.5f %10.5f %10.5f %10.5f %10.5f %10.5f positions{angstrom} cell{angstrom}" % h, file=f)
      for i in range(nat):
          print("%10s %20.10e %20.10e %20.10e" % (s[i], q[i][0], q[i][1], q[i][2]), file=f)
    f.close()


args = sys.argv[1:]
print_ipi_xyz(args[0], args[1])
