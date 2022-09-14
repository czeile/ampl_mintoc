# attention: need to modify sim1d.run for STO3
#set terminal postscript eps color
set terminal epslatex
set style line 6 dashtype 1 linewidth 4 linecolor rgb 'black'
set style line 2 dashtype 2 linewidth 4 linecolor rgb 'black'
set style line 1 dashtype 3 linewidth 4 linecolor rgb 'black'
set style line 5 dashtype 4 linewidth 4 linecolor rgb 'black'
set style line 3 dashtype 5 linewidth 4 linecolor rgb 'black'
set style line 4 dashtype 6 linewidth 4 linecolor rgb 'black'
set style line 7 dashtype 1 linewidth 4 linecolor rgb 'grey'

set xrange [0:1]

set output 'res/fig6_lotkasim1d.tex'
plot 'out/lotkasto1d_1.txt' using 1:2 w l ls 1 t "STO 1", 'out/lotkasto1d_2.txt' using 1:2 w l ls 2 t "STO 2", 'out/lotkasto1d_3.txt' using 1:2 w l ls 3 t "STO 3", 'out/lotkasto1d_4.txt' using 1:2 w l ls 4 t "STO 4", 'out/lotkasto1d_8.txt' using 1:2 w l ls 5 t "STO 8", 'out/lotkasto1d_16.txt' using 1:2 w l ls 6 t "STO 16", 'out/lotkapoc1d.txt' using 1:2 w l ls 7 t "POC"

#set key bottom left
set key inside 
set key at 0.29,3000
set output 'res/fig6_calciumsim1d.tex'
plot 'out/calciumsto1d_16.txt' using 1:2 w l ls 1 t "STO 16", 'out/calciumsto1d_32.txt' using 1:2 w l ls 2 t "STO 32", 'out/calciumsto1d_64.txt' using 1:2 w l ls 5 t "STO 64", 'out/calciumsto1d_128.txt' using 1:2 w l ls 6 t "STO 128", 'out/calciumpoc1d.txt' using 1:2 w l ls 7 t "POC"


