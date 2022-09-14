# import numpy  as np
# import matplotlib.pyplot as plt
# data = np.loadtxt('res_CIA_TV_lotka.txt')


# x = data[1:, 5]
# y = data[1:, 4]
# plt.plot(x, y,'r--')
# plt.show()


import pandas as pd
import matplotlib.pyplot as plt

data = pd.read_csv('fig10_res_CIA_TV_lotka.txt', sep=" ")
data = pd.DataFrame(data)

data_sur = pd.read_csv('fig10_res_SUR_conv_lotka.txt', sep=" ")
data_sur = pd.DataFrame(data_sur)
data_sur_sel_N =  data_sur[data_sur["N"] == 100] 
data_sur_sel1 = data_sur_sel_N[data_sur_sel_N["Iter_k"]<1]
data_sur_sel2 = data_sur_sel_N[data_sur_sel_N["Iter_k"]==1]
data_sur_sel3 = data_sur_sel_N[data_sur_sel_N["Iter_k"]==2]
data_sur_sel4 = data_sur_sel_N[data_sur_sel_N["Iter_k"]==3]
#print(data)

POC_Objective = 1.34488  #obtained from Table 2
relativ_objective = 0
#POC_nsw = 13.3 


STO_Objective = 1.34568 #obtained from Table 2
STO_nsw = 148   #obtained from ampl run with STO and using the printOutput.run script


fig = plt.figure()
ax1 = fig.add_subplot(111)

plt.title("Objective and switching values for different approaches")
plt.xlabel('Number of switches')
plt.ylabel('(MIOCP) objective value deviation from POC solution in %')

ax1.scatter(data['nsw'], (data['Sim_Obj']-POC_Objective)/POC_Objective*100, s=10, c='b', marker="s", label='CIA with TV constraint')
ax1.scatter(data_sur_sel1['nsw'], (data_sur_sel1['Sim_Obj']-POC_Objective)/POC_Objective*100, s=10, c='lightsalmon', marker="o", label='SUR with refined intervals, k=0')
ax1.scatter(data_sur_sel2['nsw'], (data_sur_sel2['Sim_Obj']-POC_Objective)/POC_Objective*100, s=10, c='orange', marker="o", label='SUR with refined intervals, k=1')
ax1.scatter(data_sur_sel3['nsw'], (data_sur_sel3['Sim_Obj']-POC_Objective)/POC_Objective*100, s=10, c='red', marker="o", label='SUR with refined intervals, k=2')
ax1.scatter(data_sur_sel4['nsw'], (data_sur_sel4['Sim_Obj']-POC_Objective)/POC_Objective*100, s=10, c='darkred', marker="o", label='SUR with refined intervals, k=3')
#ax1.scatter(POC_nsw, POC_Objective, s=10, c='g', marker="^", label='POC solution')
ax1.axhline(y = relativ_objective, color = 'g', linestyle = '-.', label='(P-POC) solution')
ax1.scatter(STO_nsw, (STO_Objective-POC_Objective)/POC_Objective*100, s=10, c='k', marker="*", label='(P-STO) solution')

plt.legend(loc='upper right');

plt.savefig("out/figure10.pdf", format="pdf", bbox_inches="tight")
#plt.show() 
