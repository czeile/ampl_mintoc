# Problem specific parameters and variables
set ALLOWED := IU;
param xtilde{X};
param p{X};

# Problem specific functions

var x {X,I} >= 0;         # states. only modify simple bounds, not the dimension

var f {k in X,o in 0..no,i in I} = (
	if      (k==1 && o==0) then x[1,i] - x[1,i]*x[2,i]
	else if (k==2 && o==0) then - x[2,i] + x[1,i]*x[2,i]
	else if (k==1 && o==1) then - x[1,i]*p[1]
	else if (k==2 && o==1) then - x[2,i]*p[2]
	else if (k==3 && o==0) then sum{l in 1..2} (x[l,i] - xtilde[l])^2
	else 0
);

var re{k in RE} = (
	if      (k==1) then x[1,0] - 0.5
	else if (k==2) then x[2,0] - 0.7
	else if (k==3) then x[3,0] - 0.0
);

var sw{o in Omega, i in IC diff {nt}, k in 1..nsw} = (
	if      (k==1) then x[1,i] - 0.8
	else if (k==2) then 1.4 - x[1,i]
);

var mayer = x[3,nt];

# -----------------------------------------
# Unused modeling parts
var lagrange{i in IC} = 0;

var ri {k in RI} = (
	if      (k==1) then x[1,0]
);

var xa {k in XA, i in I} = (
	if      (k==1) then x[1,i]
);

var con {k in C, i in IC} = (
	if      (k==1) then x[1,i]
);

var vcon {k in VC, o in 0..no, i in IC} = (
	if      (k==1) then x[1,i]
);

