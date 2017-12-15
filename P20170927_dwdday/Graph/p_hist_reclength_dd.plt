#Program to make histogram of station record lengths
#AJ_Kettle, Sep15/2017

set term png
set output "g_hist_reclength_dd.png"

set xtics rotate out

set style data histogram

#give bars a plain fill pattern
set style fill solid border

set style histogram

set title  "Histogram of Station Record Duration - DWD Daily"
set ylabel "Number of cases"

plot '..\Data_middle\histogram_lprod_dd.dat' using 2:xticlabels(1) notitle

unset output