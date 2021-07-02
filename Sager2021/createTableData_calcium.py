from parse import parse
import numpy as np

mytol = 1.0

def main(prob, N):
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
	inputfile.append( inputprefix + "STO1.dat" )
	inputfile.append( inputprefix + "STO2.dat" )
	inputfile.append( inputprefix + "POC1.dat" )
	inputfile.append( inputprefix + "POC2.dat" )

	itmean = np.zeros(5, dtype=int) 
	itmedian = np.zeros(5, dtype=int) 
	itstd = np.zeros(5, dtype=int) 
	timemean = np.zeros(5, dtype=int) 
	timemedian = np.zeros(5, dtype=int) 
	timestd = np.zeros(5, dtype=int) 
	timeLimit = np.zeros(5, dtype=int) 
	
	print("")
	print("")
	print("--------------------------------------------------")
	print("Problem ", prob, " with N= ", N)
	print("")

	for k in range(4):
		print("")
		if k==0:
			print("Results for STOa")
		elif k==1:
			print("Results for STOb")
		elif k==2:
			print("Results for POCa")
		elif k==3:
			print("Results for POCb")
		print("Reading file ", inputfile[k])
		f = open( inputfile[k], "r" )

		# Init variables
		cnt = 0
		myiterations = np.zeros(100) 
		myobj  = np.zeros(100) 
		mytime = np.zeros(100) 

		# Loop through lines of file
		line = f.readline()
		while line:
			### Initialization line
			result = parse( 'Initialization {}', line )
			### Objective function value and time
			line = f.readline()
			result = line.split()
			if result == []:
				continue
			if result[0] == "TimeLimit":
				timeLimit[k] += 1
			elif "Maxiter" in result[0]:
				timeLimit[k] += 1
				line = f.readline()   # read additional number of iterations line to discard it
			elif "Initialization" in result[0]:
				timeLimit[k] += 1
			elif "Number" in result[0]:
				timeLimit[k] += 1
			else:
				myobj[cnt] = float(result[0])
				mytime[cnt] = float(result[1])
				if k==4:
					line = f.readline()
					result = line.split()
					myobj[cnt] = float(result[0])
					mytime[cnt] += float(result[1])
				### Number of iterations
				line = f.readline()
				result = parse( 'Number of Iterations....: {}', line )
				myiterations[cnt] = int(result[0])
				if k==4:
					line = f.readline()
					result = parse( 'Number of Iterations....: {}', line )
					myiterations[cnt] += int(result[0])
				cnt += 1
			### Next initialization or EOF
			if "Initialization" not in result[0]:
				line = f.readline()

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
				

		# sort the two lists
		list1, list2 = (list(t) for t in zip(*sorted(zip(objvalueList, objcountList))))
		print( "Objective values (0 = no convergence) ", list1)
		print( "Number of occurrences ", list2 )

		if timeLimit[k] > 0:
			print ( "TimeLimit:", timeLimit[k] )
		if myiterations[myiterations>0].any() :
			itmean[k]     = int(myiterations[myiterations>0].mean())
			itmedian[k]   = int(np.median(myiterations[myiterations>0]))
			itstd[k]      = int(myiterations[myiterations>0].std())
			timemean[k]   = int(mytime[mytime>0].mean())
			timemedian[k] = int(np.median(mytime[mytime>0]))
			timestd[k]    = int(mytime[mytime>0].std())

		print ("Iterations (mean, median, stddev):", itmean[k], itmedian[k], itstd[k] )
		print ("CPU time   (mean, median, stddev):", timemean[k], timemedian[k], timestd[k] )

		f.close()


if __name__=="__main__":
	main("calcium",2)
	main("calcium",3)
	main("calcium",4)
	main("calcium",100)


