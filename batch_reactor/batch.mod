#
# This file is part of ampl_mintoc.
#
# Copyright 2021, Sebastian Sager, Manuel Tetschke, Clemens Zeile
# All rights reserved.
#
# This source code is licensed under the BSD-style license found in the
# LICENSE file in the root directory of this source tree. 
#
# ampl_mintoc is free software: you can redistribute it and/or modify
# it under the terms of the BSD-style License
#
# ampl_mintoc is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. 
#



# -------------------------------
# Model: batch reactor model, Mintoc.de, Clemens Zeile 2017
# Outer Convexification version
# -------------------------------


var x {X,I};         # states. only modify simple bounds, not the dimension


# Problem specific functions
# Note: scaled to  \in {0,1}
var f {k in X,o in 0..no,i in I} = (
	if      (k==1 && o==0) then -4000*exp(-2500/298)*x[1,i]^2  
	else if (k==1 && o==1) then -x[1,i]^2*4000*(exp(-2500/398)-exp(-2500/298))
	else if (k==1 && o==2) then -x[1,i]^2*4000*(exp(-2500/350)-exp(-2500/298))
	else if (k==1 && o==3) then -x[1,i]^2*4000*(exp(-2500/450)-exp(-2500/298))
	else if (k==2 && o==0) then 4000*exp(-2500/298)*x[1,i]^2-620000*exp(-5000/298)*x[2,i]
	else if (k==2 && o==1) then x[1,i]^2*4000*(exp(-2500/398)-exp(-2500/298))-x[2,i]*620000*(exp(-5000/398)-exp(-5000/298))
	else if (k==2 && o==2) then x[1,i]^2*4000*(exp(-2500/350)-exp(-2500/298))-x[2,i]*620000*(exp(-5000/350)-exp(-5000/298))
	else if (k==2 && o==3) then x[1,i]^2*4000*(exp(-2500/450)-exp(-2500/298))-x[2,i]*620000*(exp(-5000/450)-exp(-5000/298))
	else if (k==3 && o==0) then cos(x[2,i])  
	else if (k==3 && o==1) then x[1,i]^3
	else 0
);

var mayer = -x[2,nt];# + x[3,nt];
#var lagrange{i in IC} = -x[2,i] *(i/nt) ;

var re{k in RE} = (
	if           (k==1)   then x[1,0]  - 1
	else if      (k==2)   then x[2,0]  - 0
	else if      (k==3)   then x[3,0]  - 0
);



# -----------------------------------------
# Unused modeling parts
#var mayer = 0;
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

var sw{o in Omega, i in IC diff {nt}, k in 1..nsw} = (
	if      (k==1) then x[1,i] - 0.8
	else if (k==2) then 1.4 - x[1,i]
);

