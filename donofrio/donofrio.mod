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
# Model: D'Onofrio chemotherapy model, Mintoc.de, Clemens Zeile 2017
# Outer Convexification formulation
# -------------------------------

# Problem specific parameters and variables
param zeta;
param b;
param mu;
param d;
param G;
param F;
param eta_dono;
param u_0_max;
param x_2_max;
param x_0_0;
param x_1_0;
param x_2_0;
param x_3_0;
param u_1_max;
param x_3_max;
param alpha_dono;


var x {X,I} >= 0;         # states. only modify simple bounds, not the dimension

# Problem specific functions
# Note: scaled to  \in {0,1}
var f {k in X,o in 0..no,i in I} = (
	if      (k==1 && o==0) then -zeta*x[1,i]*log(x[1,i]/x[2,i])  
	else if (k==1 && o==1) then 0
	else if (k==1 && o==2) then -F*x[1,i]*u_1_max
	else if (k==1 && o==3) then -F*x[1,i]*u_1_max
	else if (k==1 && o==4) then 0
	else if (k==2 && o==0) then b*x[1,i]-mu*x[2,i]-d*(x[1,i])^(2/3)*x[2,i] 
	else if (k==2 && o==1) then -G*x[2,i]*u_0_max
	else if (k==2 && o==2) then -eta_dono*x[2,i]*u_1_max
	else if (k==2 && o==3) then -G*x[2,i]*u_0_max-eta_dono*x[2,i]*u_1_max
	else if (k==2 && o==4) then 0
	else if (k==3 && o==0) then 0
	else if (k==3 && o==1) then u_0_max
	else if (k==3 && o==3) then u_0_max
	else if (k==4 && o==2) then u_1_max
	else if (k==4 && o==3) then u_1_max
	else 0
);

var mayer = x[1,nt];

var lagrange{i in IC} = alpha_dono * (wi[1,i]^2+wi[3,i]^2);

var re{k in RE} = (
	if           (k==1)   then x[1,0]  - x_0_0
	else if      (k==2)   then x[2,0]  - x_1_0
	else if      (k==3)   then x[3,0]  - x_2_0
	else if      (k==4)   then x[4,0]  - x_3_0
);

var con {k in C, i in IC} = (
	if      (k==1) then x[3,i] - x_2_max
	else if     (k==2) then x[4,i] - x_3_max
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
	if      (k==1) then x[1,i] - 0.8
	else if (k==2) then 1.4 - x[1,i]
);

