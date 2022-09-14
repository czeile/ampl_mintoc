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


#######################
### Dimensions and sets
param nxd    >= 0;         # differential states
param nxa    >= 0;         # algebraic states
param nu     >= 0;         # continuous controls
param nq     >= 0;         # control values
param no     >= 0;         # disjunctive modes (binary controls)
param nvc    >= 0;         # vanishing constraints per mode
param nc     >= 0;         # path constraints
param nre    >= 0;         # point equality constraints
param nri    >= 0;         # point inequality constraints
param isSOS1 >= 0;         # Is a SOS1 condition present in the model?
param nplots >= 0;         # How many plot postscript files?
param nsw    >= 0;         # switch function: 0 none, 1 open interval, 2 closed interval

set X     := 1..nxd;
set XA    := 1..nxa;
set U     := 1..nu;
set Q     := 1..nq;
set Omega := 1..no;
set C     := 1..nc;
set VC    := 1..nvc;
set RE    := 1..nre;
set RI    := 1..nri;
set PLOT  := 1..nplots;

# Internally set, depending on chosen method
param nvco >= 0;
set VCO   := 1..nvco;

#######################
### Time discretization
param nt      > 0;          # number of grid points for differential equations
param ntperu  > 0;          # number of grid points per control interval
param ntperel > 0;          # number of grid points per collocation interval
param ntu    := nt/ntperu;  # number of control intervals
param nel    := nt/ntperel; # number of collocation intervals
param nsto   := ntperu/(no+1-isSOS1); # number of steps in STO optimization per mode
set I        := 0..nt;      # grid for differential equations
set IU       := 0..ntu-1;   # grid for piecewise constant controls
set IC       := 0..nt by ntperu;     # grid for evaluation of controls
set ICOLL    := 0..nel-1;   # coarse collocation grid
set ICOLLSTO := 0..nsto/ntperel-1;  # coarse collocation grid on each model stage in STO formulation
set JCOLL    := 1..ntperel; # fine collocation grid
param ix{i in I}  := (
	if      (i<nt)  then (i div ntperu)
	else if (i==nt) then ((nt-1) div ntperu)
);

#######################
### Algorithmic variables
param BIGM{VC, Omega};      #for big M relaxations
param mysum;
param dummyMilpSolve;	    #for Resolve in MILPSolve
param mys{Omega};
param myidx;
param myfeasibilityMax;
param myfeasibilityAvg;
param myval;
param smoothing;
param ti;
param mywval;
param ref_x {X,I};
param colloc{JCOLL,JCOLL};   # Factors for Radau collocation
param PI;
param filename symbolic;
param tempvar symbolic;
param maxplot >= 0;          # maximum number of plotted entries
param plottedbefore;
param referencestored;       # has a reference solution been stored?
param opttype symbolic;

#######################
### Branch and Bound variables

param Nmax > 0;					## Nmax: Maximum number of branch and bound tree nodes (subproblems) we can treat
param bestGlobalUpper;				## Best integral solutions (upper bound) obtained so far from all subproblems
set   open_problems ordered;			## Set of indices of open subproblems
param Inext > 0;				## Index of next free subproblem, must stay below Nmax
param Ibest;                                    ## Index of the best subproblem so far
param Iter;
param Iprob > 0;				## Index of current subproblem, must stay below Nmax
param x_BB {I, 1..3, 1..Nmax} >= 0;

## Local variables used during the solution of a subproblem and the setup of the new subproblems
param omega_BB{i in Omega, j in 0..ntu, k in 1..Nmax};	## Integer controls
param d_BB{j in 1..Nmax};				## Depth resp. time point
param theta{i in 1..Nmax};			## Relaxed solutions (lower bounds) obtained from the subproblems
set theta_argmin ordered;			## Used to find node with smallest theta
set theta_d_argmin ordered;			## Used to find deepest node of these with smallest theta



#######################
### User settings
param mode symbolic;
param filename_base symbolic;
param filename_ext symbolic;
param integrator symbolic;
param milpsolver symbolic;
param nlpsolver symbolic;
param minlpsolver symbolic;
param vstrategy symbolic;

param plotx{1..maxplot} >= 0, <= nplots;  # Plot to which postscript file?
param plotxa{1..maxplot} >= 0, <= nplots; # Plot to which postscript file?
param plotu{1..maxplot} >= 0, <= nplots;  # Plot to which postscript file?
param plotw{1..maxplot} >= 0, <= nplots;  # Plot to which postscript file?
param plotcon{1..maxplot} >= 0, <= nplots;  
param plotvc{1..maxplot,1..maxplot} >= 0, <= nplots; 
param plotrefx{1..maxplot} >= 0, <= nplots;
param plotlambda{1..maxplot} >= 0, <= nplots;
param plotsos >= 0, <= nplots;
param plotrefxnorm >= 0, <= nplots;  # Normed difference of x-trajectories, different norms
param plotetax{1..maxplot} >= 0, <= nplots;  

param plotx_name{1..maxplot} symbolic;
param plotxa_name{1..maxplot} symbolic;
param plotu_name{1..maxplot} symbolic;
param plotw_name{1..maxplot} symbolic;
param plotcon_name{1..maxplot} symbolic;
param plotvc_name{1..maxplot, 1..maxplot} symbolic;
param plotrefx_name{1..maxplot} symbolic;
param plotrefxnorm_name symbolic;
param plotlambda_name{1..maxplot} symbolic;
param plotfrel_name{1..maxplot, 1..maxplot} symbolic;
param plotetax_name{1..maxplot} symbolic;

param plotsos_name symbolic;
param plot_xlabel symbolic;
param plot_title{1..maxplot} symbolic;

#############
### Variables (variables xa, f, con, vcon, ... defined in user.mod)
#var x {X,I};      # x now defined in user.mod file to allow inclusion of simple bounds
var vconIC {VC,IC} <= 0;
var ui {U,IU};
var q {Q};
var wi {Omega,IU} binary >= 0 <= 1;
var slack >= 0;

var T >= 0;           # horizon length
var dt  = T / nt;     # increment on fine grid
var du  = T / ntu;    # increment on control grid
var del = T / nel;    # increment on collocation grid

### Substituted variables that can be used for convenience on fine time grid
var u {k in U, i in I} = ui[k,ix[i]];
var w {o in Omega, i in I} = wi[o,ix[i]];

#############
### Implicit switching variables and parameters
param cswitch;

############
### Combinatorial Integral Approximation
var eta >= 0.0;            # Slack objective
var omega {Omega,IU} binary;
param alpha {Omega,IU};
param lambda {X, IU};
param frel{X,0..no,I};
var eta_x{X, IU} >= 0.0;            # Reformulation of absolute values, for CIA3 necessary for all k and i
var eta_o{Omega, IU} >= 0.0;        # Reformulation of absolute values, for CIA1norm necessary for all o and i
var eta_t{IU} >= 0.0;            # Reformulation of accumulated epsilon error over time.
param sigma_max;			# Total variation parameter, maximum number of allowed switches
var sigma{o in Omega, i in 0..ntu-2} binary;  # variable to track switches

