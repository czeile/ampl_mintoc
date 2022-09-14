# Sets
set CHEMO;
param nchemo;
param nPatients;
param curPatient;
set PATIENTS := 0..nPatients;
param cycleoffset;

# Constants
param k10;
param k12;
param k21;
param V1;
param MM;
param kcirc;
param BSA;

# Parameters
param Base {PATIENTS};
param gamma {PATIENTS};
param ktr {PATIENTS};
param slope {PATIENTS};
param xprol0 {PATIENTS};
param xtrans0 {PATIENTS};
param xcirc0 {PATIENTS};

param curBase;
param curgamma;
param curktr;
param curslope;
param curxprol0;
param curxtrans0;
param curxcirc0;

# Patient-specific
param finalDosage {PATIENTS};
param dosage;

# Algorithmic
param curi;
param tin;
param tout;

# Problem specific functions

var x {X,I};         # states. only modify simple bounds, not the dimension

var f {k in X,o in 0..no,i in I} = (
#	if      (k==1 && o==0) then curktr*x[1,i]*( ( curBase/x[3,i] )^curgamma  - 1.0) - ( curslope*log(1.0+x[4,i]*V1*MM) )*x[1,i]
	if      (k==1 && o==0) then curktr/(1+log(1+5e-2*x[4,i]^2))*x[1,i]*( (1-(curslope*log(1.0+x[4,i]*V1*MM)))*( curBase/x[3,i] )^curgamma  - 1.0)
	else if (k==2 && o==0) then curktr/(1+log(1+5e-2*x[4,i]^2))*( x[1,i]- x[2,i] )
	else if (k==3 && o==0) then curktr/(1+log(1+5e-2*x[4,i]^2))*x[2,i] - kcirc*x[3,i]
	else if (k==4 && o==0) then k21*x[5,i] - k10*x[4,i] - k12*x[4,i]
	else if (k==5 && o==0) then k12*x[4,i] - k21*x[5,i]
	else if (k==4 && o==1) then dosage*BSA*24.0
	else 0
);

var lagrange{i in IC} = 0; #(
#	if (i > 10*24*3*20 && i <= 22*24*3*20) then - x[3,i]
#	else                              0
#);

var mayer = - q[1];

var re{k in RE} = (
	if      (k==1) then x[1,0] - curxprol0
	else if (k==2) then x[2,0] - curxtrans0
	else if (k==3) then x[3,0] - curxcirc0
	else if (k==4) then x[4,0] - 0
	else if (k==5) then x[5,0] - 0
	else if (k==6) then nchemo - sum{i in IU} wi[1,i]
);

#var re{k in RE} = (
#	if      (k==1) then x[1,0] - (curBase*kcirc)/curktr
#	else if (k==2) then x[2,0] - (curBase*kcirc)/curktr
#	else if (k==3) then x[3,0] - curBase
#	else if (k==4) then x[4,0] - 0
#	else if (k==5) then x[5,0] - 0
#	else if (k==6) then nchemo - sum{i in IU} wi[1,i]
#);

var ri {k in RI} = (
	if      (k == card(IU)+1) then - wi[1,32] + 1
	else if (k-1 in CHEMO) then wi[1,k-1] - 1
	else                        wi[1,k-1] - 0
#	if      (k==1) then - q[1] + 800
#	else if (k==2) then   q[1] - 1200
);

var con {k in C, i in IC} = (
	if			(i <= 30*24*ntperu) then 0
	else if      (k==1) then - x[3,i] + q[1]
);

# -----------------------------------------
# Unused modeling parts

var xa {k in XA, i in I} = (
	if      (k==1) then x[1,i]
);

var vcon {k in VC, o in 0..no, i in IC} = (
	if      (k==1) then x[1,i]
);

var sw{o in Omega, i in IC diff {nt}, k in 1..nsw} = (
	if      (k==1) then x[1,i] - 0.8
	else if (k==2) then 1.4 - x[1,i]
);

