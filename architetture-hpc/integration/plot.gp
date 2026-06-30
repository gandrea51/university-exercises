#!/usr/bin/gnuplot

set terminal postscript eps enhanced color
set size 1,0.75
set autoscale
unset label
set ytic auto
set grid

# Style definitions
set style line 1 lt 1 pt 3 ps 1.3 lw 3 linecolor rgb "red"
set style line 2 lt 1 pt 4 ps 1.3 lw 3 linecolor rgb "blue"
set style line 3 lt 1 pt 5 ps 1.3 lw 3 linecolor rgb "#FF00FF"
set style line 4 lt 1 pt 6 ps 1.3 lw 3 linecolor rgb "orange"

# TIME

set title "Execution Time"
set xlabel "Number of Threads"
set ylabel "Time [sec]"

set output "time.eps"

plot "data.dat" using 2:4 title "Measured Time" ls 3 with linespoints

!convert -flatten time.eps time.png
!/bin/rm time.eps

# SPEEDUP

set title "Relative Speedup"
set xlabel "Number of Threads"
set ylabel "Speedup"
set output "speedup.eps"

A = system("head -n 1 data.dat | awk '{print $4}'")
ideal(x) = x

plot [][1:] ideal(x) title "Ideal Speedup" ls 1 with lines, "data.dat" using 2:(A/$4) title "Measured Speedup" ls 3 with linespoints

!convert -flatten speedup.eps speedup.png
!/bin/rm speedup.eps

# EFFICIENCY

set title "Relative Efficiency"
set xlabel "Number of Threads"
set ylabel "Efficiency"

set output "efficiency.eps"

ideal_eff(x) = 1

plot [][0:1.2] ideal_eff(x) title "Ideal Efficiency" ls 1 with lines, "data.dat" using 2:(A/($4*$2)) title "Measured Efficiency" ls 3 with linespoints

!convert -flatten efficiency.eps efficiency.png
!/bin/rm efficiency.eps