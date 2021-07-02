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




####################################
### Problem independent formulations

minimize slackobj: slack;

minimize meritobj: du*(-0.5*lagrange[0] - 0.5*lagrange[nt] + sum{i in IC} lagrange[i]) + mayer + 100*max(0,max{i in IC} con[1,i]);

minimize objective: du*(-0.5*lagrange[0] - 0.5*lagrange[nt] + sum{i in IC} lagrange[i]) +  mayer;
subject to

#######
### Dynamics

### ODE with Outer Convexification
	ode{k in X, i in ICOLL, j in JCOLL}:
		x[k,i*ntperel+j] =  ( 
			if      (integrator=="explicitEuler") then x[k,i] + dt * (f[k,0,i]   + sum {o in Omega} w[o,i] * f[k,o,i])
			else if (integrator=="implicitEuler") then x[k,i] + dt * (f[k,0,i+1] + sum {o in Omega} w[o,i] * f[k,o,i+1])
			else if (integrator=="radau3")        then x[k,i*ntperel] + del * ( sum{l in JCOLL} colloc[l,j] * f[k,0,i*ntperel+l] + sum {o in Omega} w[o,i*ntperel] * sum{l in JCOLL} colloc[l,j] * f[k,o,i*ntperel+l])
		);

### Switching Time Optimization a la Gerdts. Including special case of user eliminated SOS1 condition (isSOS=0) and corresponding f=0
	ode_STO {k in X, o in 1..no+(1-isSOS1), i in IU, ii in ICOLLSTO, j in JCOLL}:
		x[k,i*ntperu+(o-1)*nsto+ii*ntperel+j] = (
			if      (integrator=="explicitEuler" && o<=no) then 
				x[k,i*ntperu+(o-1)*nsto+ii] + wi[o,i] * dt*(no+1-isSOS1) * (f[k,0,i*ntperu+(o-1)*nsto+ii] + f[k,o,i*ntperu+(o-1)*nsto+ii])
			else if (integrator=="explicitEuler") then
				x[k,i*ntperu+no*nsto+ii] + (1 - sum{l in Omega} wi[l,i]) * dt*(no+1-isSOS1) * f[k,0,i*ntperu+no*nsto+ii]
			else if (integrator=="implicitEuler" && o<=no) then 
				x[k,i*ntperu+(o-1)*nsto+ii] + wi[o,i] * dt*(no+1-isSOS1) * (f[k,0,i*ntperu+(o-1)*nsto+ii+1] + f[k,o,i*ntperu+(o-1)*nsto+ii+1])
			else if (integrator=="implicitEuler") then
				x[k,i*ntperu+no*nsto+ii] + (1 - sum{l in Omega} wi[l,i]) * dt*(no+1-isSOS1) * f[k,0,i*ntperu+no*nsto+ii+1]
			else if (integrator=="radau3" && o<=no) then 
				x[k,i*ntperu+(o-1)*nsto+ii*ntperel] + wi[o,i] * del*(no+1-isSOS1) * sum{l in JCOLL} colloc[l,j] * ( f[k,0,i*ntperu+(o-1)*nsto+ii*ntperel+l] + f[k,o,i*ntperu+(o-1)*nsto+ii*ntperel+l] )
			else if (integrator=="radau3") then
				x[k,i*ntperu+(o-1)*nsto+ii*ntperel] + (1 - sum{l in Omega} wi[l,i]) * del*(no+1-isSOS1) * sum{l in JCOLL} colloc[l,j] * f[k,0,i*ntperu+(o-1)*nsto+ii*ntperel+l]
		);

############
### Controls
	SOS1 {i in IU}:
		sum{o in Omega} wi[o,i] = 1;

############
### Vanishing / indicator constraints
	v_constraints {k in VC, o in VCO, i in IC}:
		slack >= (
			if      (vstrategy=="OC")   then vcon[k,0,i] + sum{oj in Omega} w[oj,i] * vcon[k,oj,i]
			else if (vstrategy=="bigM") then vcon[k,0,i] + vcon[k,o,i] - BIGM[k,o] * (1-w[o,i])
			else if (vstrategy=="VC")   then w[o,i]*(vcon[k,0,i] + vcon[k,o,i])
		);

############
### Path constraints
	c_constraints {k in C, i in IC}:
		con[k,i] <= 0;

############
### Point constraints
	re_constraints {k in RE}:
		re[k] = 0;

	ri_constraints {k in RI}:
		ri[k] <= 0;

############
### Implicit switching
	sw_constraints{o in Omega, i in IU: nsw >= 1}:
		wi[o,i] = prod{k in 1..nsw} (atan(cswitch*sw[o,i*ntperu,k])/PI + 0.5);

############
### Combinatorial Integral Approximation

minimize controlSlack: eta;

minimize controlSlackEta_t: sum {i in IU} eta_t[i];

subject to
	CIAabsp{o in Omega, i in IU}:
		sum {j in 0..i} ( omega[o,j] - alpha[o,j] ) <= eta;

	CIAabsm{o in Omega, i in IU}:
		-sum {j in 0..i} ( omega[o,j] - alpha[o,j] ) <= eta;

	CIAabspReverse{o in Omega, i in IU}:
		sum {j in i..ntu-1} ( omega[o,j] - alpha[o,j] ) <= eta;

	CIAabsmReverse{o in Omega, i in IU}:
		-sum {j in i..ntu-1} ( omega[o,j] - alpha[o,j] ) <= eta;

	omegaSOS1 {i in IU}:
 		sum{o in Omega} omega[o,i] <= 1; # set  '<=' in case of single mode, multimode: '='

############
### Combinatorial Integral Approximation 1-Norm

	CIAabsp1norm{o in Omega, i in IU}:
		sum {j in 0..i} ( omega[o,j] - alpha[o,j] ) <= eta_o[o,i];

	CIAabsm1norm{o in Omega, i in IU}:
		-sum {j in 0..i} ( omega[o,j] - alpha[o,j] ) <= eta_o[o,i];

	CIAabsp1normReverse{o in Omega, i in IU}:
		sum {j in i..ntu-1} ( omega[o,j] - alpha[o,j] ) <= eta_o[o,i];

	CIAabsm1normReverse{o in Omega, i in IU}:
		-sum {j in i..ntu-1} ( omega[o,j] - alpha[o,j] ) <= eta_o[o,i];

 	CIA1linkEtas {i in IU}:
		sum {o in Omega} eta_o[o,i] <= eta;


############
### Scaled CIA max: using only f values for scaling, max norm
	scaledCIA1absp{i in IU, k in X}:
		sum { o in Omega, j in 0..i} dt * ( 0.5*frel[k,o,j*ntperu] + 0.5*frel[k,o,(j+1)*ntperu] + sum {l in 1..ntperu-1} frel[k,o,j*ntperu+l] ) * ( omega[o,j] - alpha[o,j] )  <= eta;

	scaledCIA1absm{i in IU, k in X}:
		 -sum { o in Omega, j in 0..i} dt * ( 0.5*frel[k,o,j*ntperu] + 0.5*frel[k,o,(j+1)*ntperu] + sum {l in 1..ntperu-1} frel[k,o,j*ntperu+l] ) * ( omega[o,j] - alpha[o,j] )  <= eta;
	

############
### Scaled CIA 2: full scaling, also using lambdas, 1-norm in state space
 scaledCIA2linkEtas {i in IU}:
		sum {k in X} eta_x[k,i] <= eta;

	scaledCIA2absp{i in IU, k in X}:
		lambda[k,i] * sum {o in Omega, j in 0..i} dt * ( 0.5*frel[k,o,j*ntperu] + 0.5*frel[k,o,(j+1)*ntperu] + sum {l in 1..ntperu-1} frel[k,o,j*ntperu+l] ) * ( omega[o,j] - alpha[o,j] ) <= eta_x[k,i];

	scaledCIA2absm{i in IU, k in X}:
		- lambda[k,i] * sum {o in Omega, j in 0..i} dt * ( 0.5*frel[k,o,j*ntperu] + 0.5*frel[k,o,(j+1)*ntperu] + sum {l in 1..ntperu-1} frel[k,o,j*ntperu+l] ) * ( omega[o,j] - alpha[o,j] ) <= eta_x[k,i];


####################################
### Specify problems

### NLPs

problem Sim: 
	objective,lagrange,mayer,
	ode,x,xa,f,
#	q,con,c_constraints,
	con,c_constraints,
	re,re_constraints;

problem SimRelVC: 
	slackobj, slack,
	lagrange,mayer,
	ode,x,xa,f,
	re,re_constraints,ri,ri_constraints,
	con,c_constraints,
	vcon,v_constraints;

problem SimSwitch: 
	slackobj,slack,
	lagrange,mayer,
	ode,x,xa,f,
	re,re_constraints,ri,ri_constraints,
	con,c_constraints,
	sw,sw_constraints,w,wi,
	vcon,v_constraints;

problem Init: 
	slackobj,slack,
	lagrange,mayer,
	xa,f,
	re,
	con,
	sw,sw_constraints,w,wi,
	vcon,v_constraints;

problem Fixed: 
	objective,lagrange,mayer,
	ode,x,xa,f,
	re,re_constraints,ri,ri_constraints,
	con,c_constraints,
	vcon,v_constraints,
	q,u,ui;

problem MeritFixed: 
	meritobj,lagrange,mayer,con,
	ode,x,xa,f,
	re,re_constraints,ri,ri_constraints,
	q,u,ui;


problem Relaxed: 
	objective,lagrange,mayer,
	ode,x,xa,f,
	re,re_constraints,ri,ri_constraints,
	con,c_constraints,
	vcon,v_constraints,
#	vconIC_spec,vconIC,
	q,u,ui,
	w,wi,SOS1;

problem Implicit: 
	objective,lagrange,mayer,
	ode,x,xa,f,
	re,re_constraints,ri,ri_constraints,
	con,c_constraints,
	vcon,v_constraints,
	sw,sw_constraints,
#	implicit_velocityL,implicit_velocityU,
	q,u,ui,
	w,wi; #,SOS1;

problem SimSTO: 
	objective,lagrange,mayer,
	ode_STO,x,xa,f,
	re,re_constraints;

problem STO: 
	objective,lagrange,mayer,
	ode_STO,x,xa,f,
	re,re_constraints,ri,ri_constraints,
	con,c_constraints,
	vcon,v_constraints,
	q,u,ui,
	w,wi,SOS1;

### MILPs

problem milpCIA:        controlSlack,CIAabsp,CIAabsm,omegaSOS1,eta,omega;

problem milpCIAReverse:    controlSlack,CIAabspReverse,CIAabsmReverse,omegaSOS1,eta,omega;

problem milpCIA1norm:        controlSlack,CIAabsp1norm,CIAabsm1norm,omegaSOS1,CIA1linkEtas,eta,eta_o,omega;

problem milpCIA1normReverse:    controlSlack,CIAabsp1normReverse,CIAabsm1normReverse,omegaSOS1,CIA1linkEtas,eta,eta_o,omega;

problem milpScaledCIAmax: controlSlack,scaledCIA1absp,scaledCIA1absm,omegaSOS1,eta,omega;

####

problem milpScaledCIA2: controlSlack,scaledCIA2linkEtas,scaledCIA2absp,scaledCIA2absm,omegaSOS1,eta,eta_x,omega;

problem SimulateCIA:        controlSlack,CIAabsp,CIAabsm,omegaSOS1,eta;

####################################
### Set default values

data;

let filename_base := "trajectory";
let filename_ext := "Relaxed";
let mode := "Relaxed";
let opttype := "NLP";
let integrator := "implicitEuler";
let milpsolver := "gurobi";
let nlpsolver := "ipopt";
let minlpsolver := "knitro";
let vstrategy := "OC";
let isSOS1 := 0;

### Algorithmic values
let cswitch := 500;

### Default dimensions are all 0
let nxd:=0;
let no :=0;
let nxa:=0;
let nu :=0;
let nq :=0;
let nre:=0;
let nri:=0;
let nc :=0;
let nvc:=0;
let nsw:=0;
### Other constants
let PI := 3.1415926538;


### Plotting defaults
let maxplot := 20;
let nplots := 1;
let plottedbefore := 0; 
let referencestored := 0;
let plot_xlabel := "t";
for {k in 1..maxplot} { let plot_title[k] := ("Plot " & k); }

for {k in 1..maxplot} { let plotx[k] := 1; }
for {k in 1..maxplot} { let plotxa[k] := 0; }
for {k in 1..maxplot} { let plotu[k] := 1; }
for {k in 1..maxplot} { let plotw[k] := 1; }
for {k in 1..maxplot} { let plotcon[k] := 0; }
for {k in 1..maxplot, oj in 1..maxplot} { let plotvc[k,oj] := 0; }
for {k in 1..maxplot} { let plotrefx[k] := 0; }
for {k in 1..maxplot} { let plotlambda[k] := 0; }
for {k in 1..maxplot} { let plotetax[k] := 0; }
let plotrefxnorm := 0; 
let plotsos := 0;

for {k in 1..maxplot} { let plotx_name[k] := ("x" & k); }
for {k in 1..maxplot} { let plotxa_name[k] := ("xa" & k); }
for {k in 1..maxplot} { let plotu_name[k] := ("u" & k); }
for {k in 1..maxplot} { let plotw_name[k] := ("w" & k); }
for {k in 1..maxplot} { let plotcon_name[k] := ("Constraint " & k); }
for {k in 1..maxplot, oj in 1..maxplot} { let plotvc_name[k,oj] := ("VC " & k & " Mode " & oj); }
for {k in 1..maxplot} { let plotrefx_name[k] := ("Difference of x" & k & " to ref"); }
for {k in 1..maxplot, oj in 1..maxplot} { let plotfrel_name[k,oj] := ("x " & k & " Mode " & oj); }
for {k in 1..maxplot} { let plotlambda_name[k] := ("Adjoint lambda " & k); }
for {k in 1..maxplot} { let plotetax_name[k] := ("eta_x value for state " & k); }

let plotrefxnorm_name := ("Normed Difference of "); 
let plotsos_name := "SOS1 entries";

