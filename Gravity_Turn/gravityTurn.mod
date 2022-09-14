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
# Data: Gravity Turn Maneuver, Mintoc.de
# free final time here fixed
# -------------------------------
# Problem specific parameters and variables
param m_0;
param m_1;
param I_sp;
param F_max;
param c_d;
param A;
param g_0;
param r_0;
param H;
param rho_0;
param beta_hat;
param v_hat;
param h_hat;
param T_min;
param T_max;
param epsilon_grav;


var x {X,I};         # states. only modify simple bounds, not the dimension

# Problem specific functions
# Note: scaled to  \in {0,1}
var f {k in X,o in 0..no,i in I} = (
	if      (k==1 && o==1) then -F_max/(I_sp*g_0)  
	else if (k==2 && o==0) then (F_max-0.5*rho_0*exp(-x[4,i]/H)*A*c_d*x[2,i]^2)/x[1,i]-g_0*(r_0/(r_0+x[4,i]))^2*cos(x[3,i]) 
	else if (k==3 && o==0) then g_0*(r_0/(r_0+x[4,i]))^2*sin(x[3,i])/x[2,i]- sin(x[3,i])*x[2,i]/(r_0+x[4,i])
	else if (k==4 && o==0) then x[2,i]*cos(x[3,i])
	else if (k==5 && o==0) then x[2,i]*sin(x[3,i])/(r_0+x[4,i])
	else 0
);

var mayer = m_0-x[1,nt];

var re{k in RE} = (
	if      (k==1)   then x[1,0]  - m_0
	else if (k==2) then x[2,0] - epsilon_grav
	else if (k==3) then x[4,0] - 0
	else if (k==4) then x[5,0] - 0
	else if (k==5) then x[3,nt] - beta_hat
	else if (k==6) then x[2,nt] - v_hat
	else if (k==7) then x[4,nt] - h_hat
);

#var con {k in C, i in IC} = (
var con {k in C, i in I} = (
	if      (k==1) then x[3,0] - PI/2
	else if (k==2) then - x[3,0] - 0
	else if (k==3) then   x[1,i] - m_0
	else if (k==4) then  - x[1,i] - m_1
	else if (k==5) then  - x[2,i] - epsilon_grav
	else if (k==6) then   x[3,i] - PI
	else if (k==7) then  - x[3,i] - 0
	else if (k==8) then  - x[4,i] - 0
	else if (k==9) then  - x[5,i] - 0
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

