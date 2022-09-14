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
# Model: Oil Shale Pyrolysis model, Mintoc.de, Clemens Zeile 2017
# Outer Convexification version
# -------------------------------

var x {X,I} >= 0;         # states. only modify simple bounds, not the dimension

# Problem specific parameters and variables
param a_1;
param a_2;
param a_3;
param a_4;
param a_5;
param b_1;
param b_2;
param b_3;
param b_4;
param b_5;
param R_oil;

# Problem specific functions
# Note: scaled to  \in {0,1}
var f {k in X,o in 0..no,i in I} = (
	if      (k==1 && o==0) 	then -a_1*exp(-b_1/(698.15*R_oil))*x[1,i]-(a_3*exp(-b_3/(698.15*R_oil))+a_4*exp(-b_4/(698.15*R_oil))+a_5*exp(-b_5/(698.15*R_oil)))*x[1,i]*x[2,i]
	else if (k==1 && o==1) then -a_1*exp(-b_1/(748.15*R_oil))*x[1,i]-(a_3*exp(-b_3/(748.15*R_oil))+a_4*exp(-b_4/(748.15*R_oil))+a_5*exp(-b_5/(748.15*R_oil)))*x[1,i]*x[2,i]-(-a_1*exp(-b_1/(698.15*R_oil))*x[1,i]-(a_3*exp(-b_3/(698.15*R_oil))+a_4*exp(-b_4/(698.15*R_oil))+a_5*exp(-b_5/(698.15*R_oil)))*x[1,i]*x[2,i])
	else if (k==1 && o==2) then -(-a_1*exp(-b_1/(748.15*R_oil))*x[1,i]-(a_3*exp(-b_3/(748.15*R_oil))+a_4*exp(-b_4/(748.15*R_oil))+a_5*exp(-b_5/(748.15*R_oil)))*x[1,i]*x[2,i])
	else if (k==2 && o==0) then a_1*exp(-b_1/(698.15*R_oil))*x[1,i]-a_2*exp(-b_2/(698.15*R_oil))*x[2,i]+a_3*exp(-b_3/(698.15*R_oil))*x[1,i]*x[2,i]  
	else if (k==2 && o==1) then a_1*exp(-b_1/(748.15*R_oil))*x[1,i]-a_2*exp(-b_2/(748.15*R_oil))*x[2,i]+a_3*exp(-b_3/(748.15*R_oil))*x[1,i]*x[2,i]-(a_1*exp(-b_1/(698.15*R_oil))*x[1,i]-a_2*exp(-b_2/(698.15*R_oil))*x[2,i]+a_3*exp(-b_3/(698.15*R_oil))*x[1,i]*x[2,i])  
	else if (k==2 && o==2) then -(a_1*exp(-b_1/(748.15*R_oil))*x[1,i]-a_2*exp(-b_2/(748.15*R_oil))*x[2,i]+a_3*exp(-b_3/(748.15*R_oil))*x[1,i]*x[2,i])
	else 0
);

#var mayer = -x[2,nt];

var lagrange{i in IC} = (x[2,i]-0.1)^2;

var re{k in RE} = (
	if           (k==1)   then x[1,0]  - 1
	else if      (k==2)   then x[2,0]  - 0
);



# -----------------------------------------
# Unused modeling parts

#var lagrange{i in IC} = 0;

var mayer = 0;

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

