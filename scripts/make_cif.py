from tqdm import tqdm
from pymatgen.core.structure import Structure
from pymatgen.io.cif import CifWriter
from ase.db import connect
import numpy as np
from pymatgen.core.lattice import Lattice
from mendeleev import element

sample_ciffile = '/home/seungwon/workspace/data/c2db/sample_any.cif'
db_file = '/home/seungwon/workspace/data/c2db/c2db-2022-03-27.db'
cif_folder = '/home/seungwon/workspace/data/c2db/cif_files'

def make_cif(model,crystal):
    j = 0
    for i in range(len(crystal)):
        crystal.pop()
    new_crystal = []
    cifs = []
    atoms = row.toatoms()
    cell = atoms.cell
    natoms = row.natoms
    new_crystal = crystal.copy()

    a = cell.lengths()[0]
    b = cell.lengths()[1]
    c = cell.lengths()[2]
    alpha = cell.angles()[0]
    beta = cell.angles()[1]
    gamma = cell.angles()[2]
    new_crystal.lattice= Lattice.from_parameters(a,b,c,alpha,beta,gamma)
    atom_site = []
    for atom in atoms:
        atom_type = element(str(atom.symbol))
        x = atom.position[0]/a
        y = atom.position[1]/b
        z = atom.position[2]/c
        new_crystal.append(atom_type.symbol,[x,y,z])
    cifs = CifWriter(new_crystal)
    return cifs

db = connect(db_file)
rows = db.select('gap>=0')

crystal = Structure.from_file(sample_ciffile)
for row in tqdm(rows):
    cifs = make_cif(row,crystal)
    with open(f'{cif_folder}/{row.uid}.cif','w') as f:
        f.write(str(cifs))
