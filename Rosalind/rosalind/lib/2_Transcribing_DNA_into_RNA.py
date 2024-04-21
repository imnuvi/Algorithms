
# https://rosalind.info/problems/rna/

with open('./inputs/2_RNA.txt') as f:
    lines = f.readlines()
    for line in lines:
        res = ''.join([i if i != "T" else "U" for i in line.strip() ])
        print(res)