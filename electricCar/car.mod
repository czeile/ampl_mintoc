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
param R_bot;
param V_alim;
param R_m;
param K_m;
param L_m;
param r;
param K_r;
param M;
param g;
param K_f;
param rho;
param S;
param C_x;

# Problem specific functions

var x {X,I};         # states. only modify simple bounds, not the dimension

# Note: scaled to  \in {0,1}
var f {k in X,o in 0..no,i in I} = (
	if      (k==1 && o==0) then -(R_m*x[1,i]+K_m*x[2,i]) / L_m - V_alim / L_m
	else if (k==1 && o==1) then 2 * V_alim / L_m
	else if (k==2 && o==0) then K_r^2/(M*r^2) * ( K_m*x[1,i] - r/K_r * ( M*g*K_f + 0.5*rho*S*C_x * x[2,i]^2*r^2 / (K_r^2) ) )
	else if (k==3 && o==0) then x[2,i] * r / K_r
	else if (k==4 && o==0) then R_bot * x[1,i]^2 - x[1,i] * V_alim
	else if (k==4 && o==1) then 2 * x[1,i] * V_alim
	else 0
);

var mayer = x[4,nt]+10000*(x[3,nt] - 100)^2;

var re{k in RE} = (
	if      (k<=nxd)   then x[k,0]  - 0
	else if (k==nxd+1) then x[3,nt] - 100
);

#var con {k in C, i in IC} = (
var con {k in C, i in I} = (
	if      (k==1) then x[1,i] - 150
	else if (k==2) then - x[1,i] - 150
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

var vcon {k in VC, o in 0..no, i in IC} = (
	if      (k==1) then x[1,i]
);

var sw{o in Omega, i in IC diff {nt}, k in 1..nsw} = (
	if      (k==1) then x[1,i] - 0.8
	else if (k==2) then 1.4 - x[1,i]
);

