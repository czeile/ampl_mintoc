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


# Problem specific parameters and variables
param ref{X};
param p{X};


var x {X,I} >= 0;         # states. only modify simple bounds, not the dimension

# Problem specific functions

var f {k in X,o in 0..no,i in I} = (
	if      (k==1 && o==0) then x[2,i] 
	else if (k==2 && o==0) then 9.8*sin(x[5,i])
	else if (k==3 && o==0) then x[4,i]
	else if (k==4 && o==0) then 9.8*cos(x[5,i])-9.8
	else if (k==5 && o==0) then x[6,i]
	else if (k==6 && o==0) then 0
	else if (k==2 && o==1) then sin(x[5,i])/1.3*u[1,i]
	else if (k==4 && o==1) then cos(x[5,i])/1.3*u[1,i]
	else if (k==6 && o==2) then -0.305*u[1,i]/0.0605
	else if (k==6 && o==3) then 0.305*u[1,i]/0.0605
);


var lagrange{i in IC} = 5*u[1,i]^2;

var re{k in RE} = (
	if      (k==1) then x[1,0] - 0
	else if (k==2) then x[2,0] - 0
	else if (k==3) then x[3,0] - 1
	else if (k==4) then x[4,0] - 0
	else if (k==5) then x[5,0] - 0
	else if (k==6) then x[6,0] - 0
);

var mayer = 5*(x[1,nt]-6)^2+5*(x[3,nt]-1)^2+(sin(x[5,nt]*0.5))^2;


var con {k in C, i in IC} = (
	if      (k==1) then u[1,i] - 0.001
	else if (k==2) then -u[1,i] - 0
	else if (k==3) then -x[3,i] - 0
);

# -----------------------------------------
# Unused modeling parts


var ri {k in RI} = (
	if      (k==1) then x[1,0]
);

var xa {k in XA, i in I} = (
	if      (k==1) then x[1,i]
);


var vcon {k in VC, o in 0..no, i in IC} = (
	if      (k==1) then x[1,i]
);
var sw{o in Omega, i in IC diff {nt}, k in 1..nsw} = (
	if      (k==1) then x[1,i]
);
