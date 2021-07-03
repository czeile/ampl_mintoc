# Automatically generated gnuplot file
set terminal postscript eps color
set style line 1 dashtype 1 linewidth 4 linecolor rgb 'grey'
set style line 2 dashtype 2 linewidth 4 linecolor rgb 'grey'
set style line 3 dashtype 3 linewidth 4 linecolor rgb 'grey'
set style line 4 dashtype 1 linewidth 4 linecolor rgb 'black'
set style line 5 dashtype 2 linewidth 4 linecolor rgb 'black'
set style line 6 dashtype 3 linewidth 4 linecolor rgb 'black'

set pm3d map corners2color c1
unset colorbox
set palette gray negative

set xlabel 't'
set title 'Calcium problem'
set output 'res/calciumRelaxed_1.ps'
splot 'res/calciumRelaxed.txt' using 1:2:(0.0) t 'x1' w l ls 1, 'res/calciumRelaxed.txt' using 1:3:(0.0) t 'x2' w l ls 2, 'res/calciumRelaxed.txt' using 1:4:(0.0) t 'x3' w l ls 3, 'res/calciumRelaxed.txt' using 1:5:(0.0) t 'x4' w l ls 1

set title 'Plot 2'
set output 'res/calciumRelaxed_2.ps'
splot 1

