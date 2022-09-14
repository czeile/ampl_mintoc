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
param xtilde {1..4};
param k1;
param k2;
param k3;
param K4;
param k5;
param K6;
param k7;
param k8;
param K9;
param k10;
param K11;
param k12;
param k13;
param k14;
param K15;
param k16;
param K17;
param p17;
param p18;
param p1;
set ALLOWED;

# Problem specific functions

var x {X,I} >= 0;         # states. only modify simple bounds, not the dimension

var f {k in X,o in 0..no,i in I} = (
	if      (k==1 && o==0) then k1+k2*x[1,i]-((k3*x[1,i]*x[2,i])/(x[1,i]+K4))-((k5*x[1,i]*x[3,i])/(x[1,i]+K6))
	else if (k==2 && o==0) then k7*x[1,i] - ((k8*x[2,i])/(x[2,i]+K9))
	else if (k==3 && o==0) then (k10*x[2,i]*x[3,i]*x[4,i])/(x[4,i]+K11) + p18*k12*x[2,i] + k13*x[1,i] - (k14*x[3,i])/(1.0*x[3,i]+K15) - (k16*x[3,i])/(x[3,i]+K17) + x[4,i]/10
	else if (k==4 && o==0) then -(k10*x[2,i]*x[3,i]*x[4,i])/(x[4,i]+K11)+(k16*x[3,i])/(x[3,i]+K17)-x[4,i]/10
	else if (k==3 && o==1) then + (k14*x[3,i])/(1.0*x[3,i]+K15) - (k14*x[3,i])/(1.3*x[3,i]+K15)
#	else if (k==5 && o==0) then sum{k in 1..4} (x[k,i]-xtilde[k])^2
	else if (k==5 && o==0) then (x[1,i]-xtilde[1])^2+(x[2,i]-xtilde[2])^2+(x[3,i]-xtilde[3])^2+(x[4,i]-xtilde[4])^2
);

var mayer = x[5,nt] + p1 * sum{i in IU} wi[1,i] / (nt/ntperu);

var re{k in RE} = (
	if      (k==1) then x[1,0] - 0.03966
	else if (k==2) then x[2,0] - 1.09799
	else if (k==3) then x[3,0] - 0.00142
	else if (k==4) then x[4,0] - 1.65431
	else if (k==5) then x[5,0] - 0.0
);




# -----------------------------------------
# Unused modeling parts
#var mayer = 0;
var lagrange{i in IC} = 0; # sum {k in X} (x[k,i]-xtilde[k])^2;

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
	if      (k==1) then x[1,i]
);
