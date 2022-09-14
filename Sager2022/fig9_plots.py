# -*- coding: utf-8 -*-
"""
Spyder Editor

This is a temporary script file.
"""

import os 
import pandas as pd
import matplotlib.pyplot as plt
import matplotlib.gridspec as gridspec
import seaborn as sns
import math
from random import randint
#legend manually created
import matplotlib.patches as mpatches

def getMaskForDF(df, columnName, listOfValues, strictSearch=False):
    if strictSearch:
        mask = df[columnName].astype(str).str.match('|'.join(listOfValues), case=False)
    else:   
        mask = df[columnName].astype(str).str.contains('|'.join(listOfValues), case=False)
    return mask


def getSubsetOfDF(df, columnName, listOfValues):
    return df[df[columnName].isin(listOfValues)]


def setNumAx(versPOC,versSUR,versSTO,N,idx_x, idx_y,colors,allobjvalues):
	df2 = df[getMaskForDF(df, 'vPOC', [versPOC], True)][getMaskForDF(df, 'vSUR', [versSUR], True)][getMaskForDF(df, 'vSTO', [versSTO], True)][getMaskForDF(df, 'N', [N], True)]
	#subset = df2['objSTO'].round(2).value_counts().sort_index()
	subset = df2['objSTO'].round(0).value_counts().sort_index()
	objvalues = subset.index.tolist()
	count = subset.tolist()
	#append values which did not converge
	objvalues=['no success']+objvalues
	count= [100-sum(count)]+count
	left=0
	gs_sub = gridspec.GridSpecFromSubplotSpec(2,1,subplot_spec=gs[idx_x, idx_y], hspace=0,height_ratios=[0.8,0.2])
	ax = gs_sub.subplots(sharex=True)
	for i in range(len(objvalues)):
		obj_idx = allobjvalues.index(objvalues[i])
		ax[0].barh(1,count[i], left=left, label=objvalues[i],color=colors[obj_idx])
		axLine, axLabel = ax[0].get_legend_handles_labels()
		lines.extend([line for line, label in zip(axLine, axLabel) if label not in labels] )
		labels.extend([label for label in axLabel if label not in labels])
		left = left + count[i]
	ax[1].barh(0,100*(df2['noIterSTO'].median()/max_iter), left=0, color='black')
#	ax[0].legend(ncol=3, bbox_to_anchor=(0, -0.9),loc='upper left', fontsize=8)
	if versPOC == '1':
		poc_paper_name = 'a'
	else:
		poc_paper_name = 'b'
	if versSTO == '1':
		sto_paper_name = 'a'
	else:
		sto_paper_name = 'b'		
	ax[0].set_title('N=' + N + ', POC' + poc_paper_name + ', STO' + sto_paper_name )
	ax[0].set_xlim(right=100)
	# Add a legend and informative axis label
	ax[0].set(ylabel="",yticks=[])
	ax[1].set(ylabel="", xlabel="%",yticks=[])
	
	
	
	
#os.chdir("/home/tetschke/mercurial/MATHOPT/DEVELOP/ampl_mintoc_publish/SUR_conv")

df = pd.read_csv('calcium_csv_export.csv')

maskPOC1= getMaskForDF(df, 'vPOC', ['1'], True)
maskPOC2= getMaskForDF(df, 'vPOC', ['2'], True)
maskSUR1= getMaskForDF(df, 'vSUR', ['1'], True)
maskSUR0= getMaskForDF(df, 'vSUR', ['0'], True)
maskSTO1= getMaskForDF(df, 'vSTO', ['1'], True)
maskSTO2= getMaskForDF(df, 'vSTO', ['2'], True)

maskN2=getMaskForDF(df, 'N', ['2'], True)
maskN3=getMaskForDF(df, 'N', ['3'], True)
maskN4=getMaskForDF(df, 'N', ['4'], True)
maskN100=getMaskForDF(df, 'N', ['100'], True)

maskOptPOC = getMaskForDF(df, 'statusPOC', ['success'])
maskOptSTO = getMaskForDF(df, 'statusSTO', ['success'])


# find maximum of medians of iterations
max_iter = 0
allobjvalues = []
for N in ['2','3','4','100']:
	for poc in ['1','2']:
		#for sur in {'0','1'}:
		for sto in ['1','2']:
			df2 = df[getMaskForDF(df, 'vPOC', [poc], True)][getMaskForDF(df, 'vSUR', ['0'], True)][getMaskForDF(df, 'vSTO', [sto], True)][getMaskForDF(df, 'N', [N], True)]
			subset = df2['objSTO'].round(0).value_counts().sort_index()
			allobjvalues = list(set(allobjvalues + subset.index.tolist()))
			max_iter = max(max_iter, df2['noIterSTO'].median())


#fig = plt.figure(figsize=(18,18), constrained_layout=True)
fig = plt.figure(figsize=(24,16), constrained_layout=True)
gs = fig.add_gridspec(5,4,hspace=0.8,height_ratios=[1,1,1,1,0.2])

allobjvalues.sort()
allobjvalues = ['no success'] + allobjvalues
colors = []
for i in range(len(allobjvalues)):
# random method
	colors.append('#%06X' % randint(0, 0xFFFFFF))
# equidistant method
#	colors.append('#%06X' % ((i+1)*int(0xFFFFFF/len(allobjvalues))))

# specific colors for 20 categories (with integer rounding)
colors = ['#000000','#0B31A5','#0641C8','#0050EB','#0078ED','#46B3F3','#004B50','#326633','#478F48','#33AE81','#107C10','#0AAC00','#57B956','#99E472','#73B761','#71C0A7','#FFC86C','#F1C716','#FCB714','#FFA500']


print(allobjvalues)
print(colors)



lines = []
labels = []
index_subplotx = -1
for N in ['2','3','4','100']:
	index_subplotx += 1 
	index_subploty = -1
	for poc in ['1','2']:
		#for sur in {'0','1'}:
		for sto in ['1','2']:			
			index_subploty += 1
			setNumAx(poc,'0',sto,N,index_subplotx, index_subploty,colors,allobjvalues)


labels,lines = zip(*sorted(zip(labels,lines)))
#plt.legend(lines,labels,loc="upper left", bbox_to_anchor=[-3.6, -1.5], ncol=12, shadow=True, title="Legend", fancybox=True)
plt.legend(lines,labels,loc="upper left", bbox_to_anchor=[-2.7, -1.5], ncol=10, shadow=True, title="Legend", fancybox=True)
plt.tight_layout()
plt.savefig("res/Fig_calcium_export.pdf", bbox_inches="tight")
#plt.show()
