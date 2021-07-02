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
param x0{X};
param xf{X};
param xi;

# Problem specific functions

var x {X,I};         # states. only modify simple bounds, not the dimension

var f {k in X,o in 0..no,i in I} = (
	if      (k==1 && o==0) then - 0.877*x[1,i] + x[3,i] - 0.088*x[1,i]*x[3,i] + 0.47*x[1,i]^2 - 0.019*x[2,i]^2
	                            - x[1,i]^2*x[3,i] + 3.846*x[1,i]^3 + 0.215*xi - 0.28*x[1,i]^2*xi + 0.47*x[1,i]*xi^2 - 0.63*xi^3
	else if (k==1 && o==1) then - 2 * ( 0.215*xi - 0.28*x[1,i]^2*xi - 0.63*xi^3 )
	else if (k==2 && o==0) then x[3,i]
	else if (k==3 && o==0) then - 4.208*x[1,i] - 0.396*x[3,i] - 0.47*x[1,i]^2 - 3.564*x[1,i]^3
	                            + 20.967*xi - 6.265*x[1,i]^2*xi + 46*x[1,i]*xi^2 - 61.4*xi^3
	else if (k==3 && o==1) then - 2 * ( 20.967*xi - 6.265*x[1,i]^2*xi - 61.4*xi^3 )
	else 0
);

var mayer = sum{k in X} (x[k,nt] - xf[k])^2;

var re{k in RE} = (
	if      (k==1) then x[1,0]  - x0[1]
	else if (k==2) then x[2,0]  - x0[2]
	else if (k==3) then x[3,0]  - x0[3]
);

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

var sw{o in Omega, i in IC diff {nt}, k in 1..nsw} = (
	if      (k==1) then x[1,i] - 0.8
	else if (k==2) then 1.4 - x[1,i]
);


