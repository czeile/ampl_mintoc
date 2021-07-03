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
set title 'Plot 1'
set output 'res/doubletankRelaxed_1.ps'
splot 'res/doubletankRelaxed.txt' using 1:2:(0.0) t 'Prey' w l ls 1, 'res/doubletankRelaxed.txt' using 1:3:(0.0) t 'Predator' w l ls 2, 'res/doubletankRelaxed.txt' using 1:4:(0.0) t 'Fishing control' w l ls 4

set title 'Plot 2'
set output 'res/doubletankRelaxed_2.ps'
splot 'res/doubletankRelaxed_dual.txt' using 1:2:(0.0) t 'Adjoint lambda 1' w l ls 4, 'res/doubletankRelaxed_dual.txt' using 1:3:(0.0) t 'Adjoint lambda 2' w l ls 5

