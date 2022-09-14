#set terminal postscript eps color
set terminal epslatex color

#set contour base
set pm3d 

#set pm3d map corners2color c1
#unset colorbox
set palette gray
#set palette gray negative
#set palette defined(0 "blue",2 "yellow",3 "green",4 "pink",5 "cyan")
#set view 35,45

#set isosamples 1000

set xrange [0:1]
set yrange [0:1]
set xlabel '$w_{1}$'
set ylabel '$w_{2}$'

set zrange [5:25]

set output 'res/fig4_lotkasto2d.tex'
splot 'out/lotkasto2d.txt' using 1:2:3 w pm3d notitle

#set title 'Objective function for Partial Outer Convexification'
set output 'res/fig4_lotkapoc2d.tex'
splot 'out/lotkapoc2d.txt' using 1:2:3 w pm3d notitle

