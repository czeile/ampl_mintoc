from parse import parse
import numpy as np
import csv

mytol = 1.0

def main(prob, N, listExport):
	if prob == "lotka":	
		if N==100:	
			inputprefix = "optresults/lotka_48000_480/lotkaout"
		elif N==8:
			inputprefix = "optresults/lotka_48000_6000/lotkaout"
		elif N==5:
			inputprefix = "optresults/lotka_48000_9600/lotkaout"
		elif N==4:
			inputprefix = "optresults/lotka_48000_12000/lotkaout"
		elif N==3:
			inputprefix = "optresults/lotka_48000_16000/lotkaout"
		elif N==2:
			inputprefix = "optresults/lotka_48000_24000/lotkaout"
	elif prob == "calcium":
		if N==2:
			inputprefix = "optresults/calcium_48000_24000/calciumout"
		elif N==3:
			inputprefix = "optresults/calcium_48000_16000/calciumout"
		elif N==4:
			inputprefix = "optresults/calcium_48000_12000/calciumout"
		elif N==100:
			inputprefix = "optresults/calcium_48000_480/calciumout"
	
	inputfile = list()
	inputfile.append( inputprefix + "POC1STO1_export" )
	inputfile.append( inputprefix + "POC1STO2_export" )
	inputfile.append( inputprefix + "POC2STO1_export" )
	inputfile.append( inputprefix + "POC2STO2_export" )
	inputfile.append( inputprefix + "POC1SURSTO1_export" )
	inputfile.append( inputprefix + "POC1SURSTO2_export" )
	inputfile.append( inputprefix + "POC2SURSTO1_export" )
	inputfile.append( inputprefix + "POC2SURSTO2_export" )

	itmean = np.zeros(9, dtype=int) 
	itmedian = np.zeros(9, dtype=int) 
	itstd = np.zeros(9, dtype=int) 
	timemean = np.zeros(9, dtype=int) 
	timemedian = np.zeros(9, dtype=int) 
	timestd = np.zeros(9, dtype=int) 
	timeLimit = np.zeros(9, dtype=int) 
	nswmean = np.zeros(9, dtype=int)
	nswmedian = np.zeros(9, dtype=int)
	nswstd = np.zeros(9, dtype=int)
	
	itmean_sto = np.zeros(9, dtype=int) 
	itmedian_sto = np.zeros(9, dtype=int) 
	itstd_sto = np.zeros(9, dtype=int) 
	timemean_sto = np.zeros(9, dtype=int) 
	timemedian_sto = np.zeros(9, dtype=int) 
	timestd_sto = np.zeros(9, dtype=int) 
	timeLimit_sto = np.zeros(9, dtype=int) 
	nswmean_sto = np.zeros(9, dtype=int)
	nswmedian_sto = np.zeros(9, dtype=int)
	nswstd_sto = np.zeros(9, dtype=int)
	
	nswmean_sur = np.zeros(9, dtype=int)
	nswmedian_sur = np.zeros(9, dtype=int)
	nswstd_sur = np.zeros(9, dtype=int)
	
	print("")
	print("")
	print("---")
	print("Problem ", prob, " with N= ", N)
	print("")

	for k in range(8):
		print("")
		if k==0:
			print("Results for POC1STO1")
		elif k==1:
			print("Results for POC1STO2")
		if k==2:
			print("Results for POC2STO1")
		elif k==3:
			print("Results for POC2STO2")
		elif k==4:
			print("Results for POC1SURSTO1")
		elif k==5:
			print("Results for POC1SURSTO2")
		elif k==6:
			print("Results for POC2SURSTO1")
		elif k==7:
			print("Results for POC2SURSTO2")
		print("Reading file ", inputfile[k])
		f = open( inputfile[k]+".dat", "r" )
		#open wi export of POC results
		f_wi = open(inputfile[k]+"_wPOC.csv", "r")
		csvReader = csv.reader(f_wi)
				
		# Prepare Export		
		export = Export("",0,0,0,0,0)
		if (k in {0,1,4,5}):
			version_poc = 1
		else:
			version_poc = 2
		if (k in {0,2,4,6}):
			version_sto = 1
		else:
			version_sto = 2
		if (k<4):
			version_sur = 0
		else:
			version_sur = 1

		# Init variables
		cnt = 0
		myiterations = np.zeros(100) 
		myobj  = np.zeros(100) 
		mytime = np.zeros(100) 
		mynsw = np.zeros(100)

		myobj_sur = np.zeros(100)
		mynsw_sur = -np.ones(100)
		myiterations_sto = np.zeros(100) 
		myobj_sto  = np.zeros(100) 
		mytime_sto = np.zeros(100) 
		mynsw_sto = np.zeros(100)
		
		# Loop through lines of file
		line = f.readline()
		while line:	
			#print(vars(export))
			export = Export(prob,N,version_poc,version_sur,version_sto,cnt+101)
			listExport.append(export)
			### Initialization line
			result = parse( 'Initialization {}', line )
			### Objective function value and time
			line = f.readline()
			result = line.split()
			if result == []:
				export.statusPOC = "Error"
				export.statusSTO = "ErrorPOC"
				continue
			if result[0] == "TimeLimit" or result[0] == "Initialization":
				timeLimit[k] += 1
				export.statusPOC = "TimeLimit"
				export.statusSTO = "TimeLimitPOC"
				cnt += 1
			elif "Maxiter" in result[0]:
				timeLimit[k] += 1
				export.statusPOC = "Maxiter"
				export.statusSTO = "MaxiterPOC"
				line = f.readline()
				line = f.readline()
				if version_sur:
					line = f.readline()
				cnt += 1
			else:
				myobj[cnt] = float(result[0])
				export.objPOC = float(result[0])
				mytime[cnt] = float(result[1])
				export.timePOC = float(result[1])
				mynsw[cnt] = float(result[2])
				export.nswPOC = float(result[2])
				export.statusPOC = "success"
				next_wi = next(csvReader)[:-1]
				# skip some weird lines without values
				while " " in next_wi[0]:
					next_wi = next(csvReader)[:-1]
				export.wi = next_wi
				if version_sur:
					line=f.readline()
					result = line.split()
					if result[0] != "UnknownError":
						myobj_sur[cnt] = float(result[0])
						export.objSUR = float(result[0])
						mynsw_sur[cnt] = float(result[2])
						export.nswSUR = float(result[2])
				line = f.readline()
				result = line.split()
				if result == []:
					export.statusSTO = "Error"
					continue
				if result[0] == "Number":
					timeLimit_sto[k] += 1
					result = parse( 'Number of Iterations....: {}', line )
					export.noIterPOC = int(result[0])
					myiterations[cnt] = int(result[0])
					line = f.readline()
					result = line.split()
					export.statusSTO = result[0]
				else: 
					myobj_sto[cnt] = float(result[0])
					export.objSTO = float(result[0])
					mytime_sto[cnt] = float(result[1]) - mytime[cnt]
					export.timeSTO = float(result[1]) - export.timePOC
					mynsw_sto[cnt] = float(result[2])
					export.nswSTO = float(result[2])
					export.statusSTO = "success"
					### Number of iterations
					line = f.readline()
					result = parse( 'Number of Iterations....: {}', line )
					myiterations[cnt] = int(result[0])
					export.noIterPOC = int(result[0])
					if result[0] != "TimeLimit":
						line = f.readline()
						result = parse( 'Number of Iterations....: {}', line )
						myiterations_sto[cnt] = int(result[0])
						export.noIterSTO = int(result[0])
				cnt += 1
			### Next initialization or EOF
			if "Initialization" not in result[0]:
				line = f.readline()
		# how many iterations in output (useful while waiting for results)
		print("finished ", cnt, " of 100")
		
		# Postprocessing per file
		objvalueList = [0.0]
		objcountList = [0]
		for value in myobj:
			found = 0
			for compval in objvalueList:
				if abs(value - compval) <= mytol:
					objcountList[ objvalueList.index(compval) ] += 1
					found = 1
					break
			if found==0:
				objvalueList.append(value)
				objcountList.append(1)
				
		# Postprocessing per file SUR
		objvalueList_sur = [0.0]
		objcountList_sur = [0]
		for value in myobj_sur:
			found = 0
			for compval in objvalueList_sur:
				if abs(value - compval) <= mytol:
					objcountList_sur[ objvalueList_sur.index(compval) ] += 1
					found = 1
					break
			if found==0:
				objvalueList_sur.append(value)
				objcountList_sur.append(1)

		# Postprocessing per file STO
		objvalueList_sto = [0.0]
		objcountList_sto = [0]
		for value in myobj_sto:
			found = 0
			for compval in objvalueList_sto:
				if abs(value - compval) <= mytol:
					objcountList_sto[ objvalueList_sto.index(compval) ] += 1
					found = 1
					break
			if found==0:
				objvalueList_sto.append(value)
				objcountList_sto.append(1)				

		# sort the two lists
		list1, list2 = (list(t) for t in zip(*sorted(zip(objvalueList, objcountList))))
		print( "POC Objective values (0 = no convergence) ", list1)
		print( "POC Number of occurrences ", list2 )

		# sort the two lists SUR
		list1, list2 = (list(t) for t in zip(*sorted(zip(objvalueList_sur, objcountList_sur))))
		if version_sur:
			print( "SUR: Objective values (0 = no convergence) ", list1)
			print( "SUR: Number of occurrences ", list2 )

		# sort the two lists STO
		list1, list2 = (list(t) for t in zip(*sorted(zip(objvalueList_sto, objcountList_sto))))
		print( "STO: Objective values (0 = no convergence) ", list1)
		print( "STO: Number of occurrences ", list2 )

		if timeLimit[k] > 0:
			print ( "POC TimeLimit:", timeLimit[k] )
		if myiterations[myiterations>0].any() :
			itmean[k]     = int(myiterations[myiterations>0].mean())
			itmedian[k]   = int(np.median(myiterations[myiterations>0]))
			itstd[k]      = int(myiterations[myiterations>0].std())
			timemean[k]   = int(mytime[mytime>0].mean())
			timemedian[k] = int(np.median(mytime[mytime>0]))
			timestd[k]    = int(mytime[mytime>0].std())
			nswmean[k]    = mynsw[mynsw>0].mean()
			nswmedian[k]  = np.median(mynsw[mynsw>0])
			nswstd[k]     = mynsw[mynsw>0].std()
			if version_sur:
				nswmean_sur[k]   = int(mynsw_sur[mynsw_sur>=0].mean())
				nswmedian_sur[k]  = int(np.median(mynsw_sur[mynsw_sur>=0]))
				nswstd_sur[k] = int(mynsw_sur[mynsw_sur>=0].std())

		print ("POC Iterations (mean, median, stddev):", itmean[k], itmedian[k], itstd[k] )
		print ("POC CPU time   (mean, median, stddev):", timemean[k], timemedian[k], timestd[k] )
		print ("POC nsw   (mean, median, stddev):", nswmean[k], nswmedian[k], nswstd[k] )
		if version_sur:
			print ("SUR nsw   (mean, median, stddev):", nswmean_sur[k], nswmedian_sur[k], nswstd_sur[k] )
		
		if timeLimit_sto[k] > 0:
			print ( "STO TimeLimit:", timeLimit_sto[k] )
		if myiterations_sto[myiterations_sto>0].any() :
			itmean_sto[k]     = int(myiterations_sto[myiterations_sto>0].mean())
			itmedian_sto[k]   = int(np.median(myiterations_sto[myiterations_sto>0]))
			itstd_sto[k]      = int(myiterations_sto[myiterations_sto>0].std())
			timemean_sto[k]   = int(mytime_sto[mytime_sto>0].mean())
			timemedian_sto[k] = int(np.median(mytime_sto[mytime_sto>0]))
			timestd_sto[k]    = int(mytime_sto[mytime_sto>0].std())
			nswmean_sto[k]    = int(mynsw_sto[mynsw_sto>0].mean())
			nswmedian_sto[k]  = int(np.median(mynsw_sto[mynsw_sto>0]))
			nswstd_sto[k]     = int(mynsw_sto[mynsw_sto>0].std())

		print ("STO Iterations (mean, median, stddev):", itmean_sto[k], itmedian_sto[k], itstd_sto[k] )
		print ("STO CPU time   (mean, median, stddev):", timemean_sto[k], timemedian_sto[k], timestd_sto[k] )
		print ("STO nsw   (mean, median, stddev):", nswmean_sto[k], nswmedian_sto[k], nswstd_sto[k] )

		f.close()
		f_wi.close()


class Export:
	prob = ""
	N = 0
	vPOC = -1
	vSUR = -1
	vSTO = -1
	instance=-1
	statusPOC = ""
	statusSTO = ""
	statusSUR = ""
	timePOC = -1
	noIterPOC = -1
	timeSUR = -1
	noIterPOC = -1
	objPOC = -1
	objSUR = -1
	objSTO = -1
	nswPOC = -1
	nswSUR = -1
	nswSTO = -1
	timeSTO = -1
	noIterSTO = -1
	wi = np.zeros(N)
	
	def __init__(self,prob,N,vPOC,vSUR,vSTO,instance):
		self.prob = prob
		self.N = N
		self.vPOC = vPOC
		self.vSUR = vSUR
		self.vSTO = vSTO
		self.instance = instance
		self.statusPOC = "none"
		self.statusSTO = "none"
		statusSUR = ""
		self.timePOC = ''
		self.noIterPOC = ''
		self.timeSUR = ''
		self.noIterPOC = ''
		self.objPOC = ''
		self.objSUR = ''
		self.objSTO = ''
		self.nswPOC = ''
		self.nswSUR = ''
		self.nswSTO = ''
		self.timeSTO = ''
		self.noIterSTO = ''
		self.wi = ''
	

if __name__=="__main__":
	listExport = list()
	main("calcium",2, listExport)
	main("calcium",3, listExport)
	main("calcium",4, listExport)
	main("calcium",100, listExport)
	fexp = open("wi_export_calcium.dat","w")
	wiList = []
	wiCountList = []
	for exp in listExport:
		if len(wiList)==0:
			if exp.vSUR==1 and exp.vSTO==1 and exp.statusPOC == "success":			
				wiList.append(exp)
				wiCountList.append(1)
		else:
			found = 0
			if exp.vSUR==1 and exp.vSTO==1 and exp.statusPOC == "success":
				for compval in (x for x in wiList if x.N==exp.N):		
					if max(abs(np.array(exp.wi,dtype=float) - np.array(compval.wi,dtype=float))) < 1e-4:
						wiCountList[wiList.index(compval)] += 1
						found = 1
						break
				if found==0:
					wiList.append(exp)
					wiCountList.append(1)
	for exp in wiList:
		fexp.write(str(exp.N) + "\n")
		fexp.write(str(exp.vPOC) + "\n")
		fexp.write(str(exp.instance) + "\n")
		fexp.write(str(wiCountList[wiList.index(exp)]) + "\n")
		fexp.write(str(exp.objPOC) + "\n")
		fexp.writelines(exp.wi)
		fexp.write("\n")	
	fexp.close()
	
	#export everything into csv file
	with open('calcium_csv_export.csv','w') as csvfile:
		csvwriter = csv.writer(csvfile)
		csvwriter.writerow(listExport[1].__dict__.keys())
		for exp in listExport:
			csvwriter.writerow(exp.__dict__.values())
		

