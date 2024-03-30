# https://rosalind.info/problems/dna/



def count_occurrence(line):
    for i in line:
        ac = line.count('A')
        cc = line.count('C')
        gc = line.count('G')
        tc = line.count('T')
    return f"{ac} {cc} {gc} {tc}"

with open('./inputs/1_DNA.txt') as f:
    lines = f.readlines()
    for line in lines:
        print(count_occurrence(line))