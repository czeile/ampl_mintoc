set terminal epslatex
set style line 2 dashtype 1 linewidth 4 linecolor rgb 'grey'
set style line 1 dashtype 3 linewidth 4 linecolor rgb 'black'

set pm3d map corners2color c1
unset colorbox
set palette gray negative
 
#set xrange [0.:1.15]
#set yrange [-0.:1.1]
#set xtics (0,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1.0,1.1)
#set size ratio 0.4
set xlabel 'Number of intervals $N$'

set key top left

set logscale x 2
set title '$ R^* $ for \eqref{opt_lotka}'
set output 'res/fig7_lotkaNcr.tex'
set yrange [0:1]
plot 'out/lotkaNcr.txt' using 1:2 t 'POC' w lp ls 2, 'out/lotkaNcr.txt' using 1:3 t 'STO' w lp ls 1

#set logscale y 10
set title '$ R^* $ for \eqref{opt_calcium}'
set output 'fig7_calciumNcr.tex'
set yrange [0:1]
plot 'out/calciumNcr.txt' using 1:2 t 'POC' w lp ls 2, 'out/calciumNcr.txt' using 1:3 t 'STO' w lp ls 1

