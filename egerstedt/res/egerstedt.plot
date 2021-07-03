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
set output 'res/egerstedtRelaxed_1.ps'
splot 'res/egerstedtRelaxed.txt' using 1:2:(0.0) t 'x1' w l ls 1, 'res/egerstedtRelaxed.txt' using 1:3:(0.0) t 'x2' w l ls 2, 'res/egerstedtRelaxed.txt' using 1:4:(0.0) t 'w1' w l ls 4, 'res/egerstedtRelaxed.txt' using 1:5:(0.0) t 'w2' w l ls 5, 'res/egerstedtRelaxed.txt' using 1:6:(0.0) t 'w3' w l ls 6

set title 'Plot 2'
set output 'res/egerstedtRelaxed_2.ps'
splot 'res/egerstedtRelaxed_dual.txt' using 1:2:(0.0) t 'Adjoint lambda 1' w l ls 4, 'res/egerstedtRelaxed_dual.txt' using 1:3:(0.0) t 'Adjoint lambda 2' w l ls 5

set title 'Plot 1'
set output 'res/egerstedtCIA_1.ps'
splot 'res/egerstedtCIA.txt' using 1:2:(0.0) t 'x1' w l ls 1, 'res/egerstedtCIA.txt' using 1:3:(0.0) t 'x2' w l ls 2, 'res/egerstedtCIA.txt' using 1:4:(0.0) t 'w1' w l ls 4, 'res/egerstedtCIA.txt' using 1:5:(0.0) t 'w2' w l ls 5, 'res/egerstedtCIA.txt' using 1:6:(0.0) t 'w3' w l ls 6

set title 'Plot 2'
set output 'res/egerstedtCIA_2.ps'
splot 'res/egerstedtCIA_dual.txt' using 1:2:(0.0) t 'Adjoint lambda 1' w l ls 4, 'res/egerstedtCIA_dual.txt' using 1:3:(0.0) t 'Adjoint lambda 2' w l ls 5

