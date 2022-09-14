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


# ----------------------------------------------------
# Electric car problem with collocation (implicit Euler)
# (c) Sebastian Sager, Frederic Messine 2013
# ----------------------------------------------------
 
# Parameters
param mysum;
param mycounter;
param myeta;
 
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
param T    > 0;
param nt   > 0;
param ntperu > 0;
param dt := T / (nt-1);
 
set I:= 0..nt;
set U:= 0..nt/ntperu-1;
set UI := 1..ntperu-1;
 
# Variables
var x {I, 0..3};
var w {I} >= -1, <= 1;
 
minimize Mayer: x[nt,3];
 
subject to ODE_current {i in I diff {0}}:
   x[i,0] = x[i-1,0] + dt * ( (w[i-1]*V_alim - R_m*x[i,0] - K_m*x[i,1]) / L_m ) ;
 
subject to ODE_angularvelocity {i in I diff {0}}:
   x[i,1] = x[i-1,1] + dt * ( K_r*K_r/(M*r*r) * ( K_m * x[i,0] - r/K_r * ( M*g*K_f + 0.5*rho*S*C_x * x[i,1]*x[i,1]*r*r / (K_r*K_r) ) ) ) ;
 
subject to ODE_position {i in I diff {0}}:
   x[i,2] = x[i-1,2] + dt * ( x[i,1]*r / K_r ) ;
 
subject to ODE_energyobjective {i in I diff {0}}:
#   x[i,3] = x[i-1,3] + dt * ( w[i-1] * x[i,0] * V_alim + R_bot * w[i-1]*w[i-1]*x[i,0]*x[i,0] ) ;
   x[i,3] = x[i-1,3] + dt * ( w[i-1] * x[i,0] * V_alim + R_bot * x[i,0]*x[i,0] ) ;
 
subject to initialvalues {j in {0..3}}:
   x[0,j] = 0;
 
subject to boundedcurrentU {i in I}:
   x[i,0] <= 150;
 
subject to boundedcurrentL {i in I}:
   x[i,0] >= -150;
 
subject to endvalues:
   x[nt,2] = 100;
 
subject to couple_controls {j in U, i in UI}:
   w[j*ntperu+i] = w[j*ntperu];
 
subject to couple_last_control:
   w[nt] = w[nt-1];
