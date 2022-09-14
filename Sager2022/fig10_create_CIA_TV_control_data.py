#### Script to convert ampl_mintoc output control data into a specific format for a file to be read in CIA_TV runs

import pandas as pd
import matplotlib.pyplot as plt

data = pd.read_csv('fig10_lotkaRelaxed_w.txt', sep=" ", header = None)
data = pd.DataFrame(data)
print(data)
numpy_array = data.values

N = 100
Poc_var = 2
Inst_no = 101

with open('fig10_Saved_Controls_lotka_CIA_TV.txt', 'w') as f:
	f.write(repr(N))
	f.write("\n")
	f.write(repr(Poc_var))
	f.write("\n")
	f.write(repr(Inst_no))
	f.write("\n")
	for i in range(numpy_array.shape[0]):
		if (i % 2 == 0) and (i < N*2):
			f.write(repr(numpy_array[i][2]) + ' ')
			#print(i)
