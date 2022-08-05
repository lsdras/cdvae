import os
from tqdm import tqdm
import pandas as pd
from ase.db import connect

db_file = '/home/seungwon/workspace/data/c2db/c2db-2022-03-27.db'
cif_folder = '/home/seungwon/workspace/data/c2db/cif_files'
output_path = "/home/seungwon/workspace/data/c2db/data.csv"

temp2 = None
db = connect(db_file)
rows = db.select('gap>=0')
i = 0
for row in rows:
    if row.natoms > 20:
        continue
    if row.uid == 'Br2Cs2-a9677b59b7ce' or row.uid == 'I2Rb2-11be6212a512':
        continue
    with open(f'{cif_folder}/{row.uid}.cif','r') as f:
        cif = f.read()
        bandgap = row.gap
        uid = row.uid
        workfunction = row.workfunction
        temp = [(uid,bandgap,workfunction,cif)]
        temp_df = pd.DataFrame(temp, index=[i], columns=['material_id','band_gap','workfunction','cif'])
        temp2 = pd.concat([temp2,temp_df])
        i += 1
print(i)

temp2.to_csv(output_path)
