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
set output 'res/fig2_figure_stoRelaxed_1.ps'
splot 'res/fig2_figure_stoRelaxed.txt' using 1:5:(0.0) t 'Control function w' w l ls 4

