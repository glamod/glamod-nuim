#Plot distribution of German subdaily stns
#AJ_Kettle, Nov1/2017

set term png
set output "g_plot_map_germany_stnloc_subday.png"

set xrange [5.0:16.0]
set yrange [47:56.0]
set title "Distribution of DWD Subdaily stations"
set xlabel "Longitude"
set ylabel "Latitude"

plot 'C:/Users/akettle/Work/Practice/Gnu_practice/World_map2/world_50m.txt' \
   with lines linestyle 1 lw 1 lt rgb "black" notitle, \
   "../Data_middle/export_basis_info.txt" \
   every ::1 using 7:6 lt rgb "red" notitle

unset output
#**********************************
#Cumulative number of lines in files

set term png
set output "stats_summary_list_sd_sort.png"

set title  "Sorted Number of Lines in Files"
set xlabel "Sorted Record Index"
set ylabel "Number of Lines"

set xrange [0:82]
set yrange [0:170000]

set key ins vert left top

plot '..\Data_middle\stats_summary_list_sd_sort.dat' \
  every ::1 using 7 with lines notitle

unset output
#**********************************
#1.Cumulative record of subday pres

set term png
set output "g_plot_sort_subday_pres.png"

set title  "Sorted Subday Pressure"
set xlabel "Sorted Record Index"
set ylabel "Pressure (hPa)"

set xrange [0:82]
set yrange [850:1060]

set key ins vert left top

plot '..\Data_middle\statsort_subday_pres.txt' \
  every ::9 using 1 with lines title 'Average',\
  '..\Data_middle\statsort_subday_pres.txt' \
  every ::9 using 2 with lines title 'Minimum',\
  '..\Data_middle\statsort_subday_pres.txt' \
  every ::9 using 3 with lines title 'Maximum'

unset output
#**********************************
#2.Cumulative record of subday airt

set term png
set output "g_plot_sort_subday_airt.png"

set title  "Sorted Subday Air Temperature"
set xlabel "Sorted Record Index"
set ylabel "Air Temperature (C)"

set xrange [0:82]
set yrange [-40:50]

set key ins vert left top

plot '..\Data_middle\statsort_subday_airt.txt' \
  every ::9 using 1 with lines title 'Average',\
  '..\Data_middle\statsort_subday_airt.txt' \
  every ::9 using 2 with lines title 'Minimum',\
  '..\Data_middle\statsort_subday_airt.txt' \
  every ::9 using 3 with lines title 'Maximum'

unset output
#**********************************
#3.Cumulative record of subday wetb

set term png
set output "g_plot_sort_subday_wetb.png"

set title  "Sorted Subday Wet Bulb Temperature"
set xlabel "Sorted Record Index"
set ylabel "Wet Bulb Temperature (C)"

set xrange [0:82]
set yrange [-40:50]

set key ins vert left top

plot '..\Data_middle\statsort_subday_wetb.txt' \
  every ::9 using 1 with lines title 'Average',\
  '..\Data_middle\statsort_subday_wetb.txt' \
  every ::9 using 2 with lines title 'Minimum',\
  '..\Data_middle\statsort_subday_wetb.txt' \
  every ::9 using 3 with lines title 'Maximum'

unset output
#**********************************

