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
# Model: hanging chain model, Mintoc.de, Clemens Zeile 2017
# Outer Convexification version
# -------------------------------


var x {X,I};         # states. only modify simple bounds, not the dimension


# Problem specific functions
# Note: scaled to  \in {0,1}
var f {k in X,o in 0..no,i in I} = (
	if (k==1 && o==1) then 20
	else if (k==1 && o==2) then 0
	else if (k==1 && o==3) then -10  
	else if (k==1 && o==3) then -5  
	else if (k==2 && o==1) then x[1,i]*(401)^(1/2)
	else if (k==2 && o==2) then x[1,i]
	else if (k==2 && o==3) then x[1,i]*(101)^(1/2)
	else if (k==2 && o==4) then x[1,i]*(26)^(1/2)
	else if (k==3 && o==1) then (401)^(1/2)
	else if (k==3 && o==2) then 1
	else if (k==3 && o==3) then (101)^(1/2) 
	else if (k==3 && o==4) then (26)^(1/2) 
	else 0
);

var mayer = x[2,nt];

var mayermerit = x[2,nt]+10*((x[1,nt]-3)^2+(x[3,nt]-4)^2);
	


var re{k in RE} = (
	if           (k==1)   then x[1,0]  - 1
	else if      (k==2)   then x[2,0]  - 0
	else if      (k==3)   then x[3,0]  - 0
	else if      (k==4)   then x[1,nt]  - 3
	else if      (k==5)   then x[3,nt]  - 4
);

var con {k in C, i in I} = (
	if      (k==1) then x[1,i] - 10
	else if (k==2) then - x[1,i] 
	else if (k==3) then x[2,i] - 10
	else if (k==4) then - x[2,i] 
	else if (k==5) then x[3,i] - 10
	else if (k==6) then - x[3,i] 
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

