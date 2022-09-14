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

set output 'res/fig5_calciumsto2d.tex'
splot 'out/calciumsto2d.txt' using 1:2:3 w pm3d notitle

set xrange [0:1]
set yrange [0:1]

set output 'res/fig5_calciumpoc2d.tex'
splot 'out/calciumpoc2d.txt' using 1:2:3 w pm3d notitle


