#Plot distribution of German stns
#AJ_Kettle, Oct10/2017

set term png
set output "g_plot_map_germany_stnloc_day.png"

set xrange [5.0:16.0]
set yrange [47:56.0]
set title "Distribution of DWD Daily stations"
set xlabel "Longitude"
set ylabel "Latitude"

plot 'C:/Users/akettle/Work/Practice/Gnu_practice/World_map2/world_50m.txt' \
   with lines linestyle 1 lw 1 lt rgb "black" notitle, \
   "../Data_middle/stats_day_data1.dat" \
   every ::1 using 4:3 lt rgb "red" notitle

unset output
#**********************************
#Cumulative number of lines in files

set term png
set output "g_plot_daysort_nlines.png"

set title  "Sorted Number of Lines in Files"
set xlabel "Sorted Record Index"
set ylabel "Number of Lines"

set xrange [0:1100]
set yrange [0:85000]

set key ins vert left top

plot '..\Data_middle\stats_summary_list_daysort.dat' \
  every ::1 using 7 with lines notitle

unset output
#**********************************
#1.Cumulative record of dayavg_airt

set term png
set output "g_plot_sort_dayavg_airt.png"

set title  "Sorted Daily Average Air Temperature"
set xlabel "Sorted Record Index"
set ylabel "Air Temperature (C)"

set xrange [0:1059]
set yrange [-30:50]

set key ins vert left top

plot '..\Data_middle\statsort_day_dayavg_airt.txt' \
  every ::9 using 1 with lines title 'Average',\
  '..\Data_middle\statsort_day_dayavg_airt.txt' \
  every ::9 using 2 with lines title 'Minimum',\
  '..\Data_middle\statsort_day_dayavg_airt.txt' \
  every ::9 using 3 with lines title 'Maximum'

unset output
#**********************************
#2.Cumulative record of dayavg_vapprs

set term png
set output "g_plot_sort_dayavg_vapprs.png"

set title  "Sorted Daily Average Vapor Pressure"
set xlabel "Sorted Record Index"
set ylabel "Vapour Pressure (hPa)"

set xrange [0:1059]
set yrange [0:45]

set key ins vert left top

plot '..\Data_middle\statsort_day_dayavg_vapprs.txt' \
  every ::9 using 1 with lines title 'Average',\
  '..\Data_middle\statsort_day_dayavg_vapprs.txt' \
  every ::9 using 2 with lines title 'Minimum',\
  '..\Data_middle\statsort_day_dayavg_vapprs.txt' \
  every ::9 using 3 with lines title 'Maximum'

unset output
#**********************************
#3.Cumulative record of dayavg_ccov

set term png
set output "g_plot_sort_dayavg_ccov.png"

set title  "Sorted Daily Average Cloud Cover"
set xlabel "Sorted Record Index"
set ylabel "Cloud Cover (okta)"

set xrange [0:1059]
set yrange [-1:11]

set key ins vert left top

plot '..\Data_middle\statsort_day_dayavg_ccov.txt' \
  every ::9 using 1 with lines title 'Average',\
  '..\Data_middle\statsort_day_dayavg_ccov.txt' \
  every ::9 using 2 with lines title 'Minimum',\
  '..\Data_middle\statsort_day_dayavg_ccov.txt' \
  every ::9 using 3 with lines title 'Maximum'

unset output
#**********************************
#4.Cumulative record of dayavg_pres

set term png
set output "g_plot_sort_dayavg_pres.png"

set title  "Sorted Daily Average Atmospheric Pressure at Station Level"
set xlabel "Sorted Record Index"
set ylabel "Atmospheric Pressure (hPa)"

set xrange [0:1059]
set yrange [750:1080]

set key ins vert right top

plot '..\Data_middle\statsort_day_dayavg_pres.txt' \
  every ::9 using 1 with lines title 'Average',\
  '..\Data_middle\statsort_day_dayavg_pres.txt' \
  every ::9 using 2 with lines title 'Minimum',\
  '..\Data_middle\statsort_day_dayavg_pres.txt' \
  every ::9 using 3 with lines title 'Maximum'

unset output
#**********************************
#5.Cumulative record of dayavg_relh

set term png
set output "g_plot_sort_dayavg_relh.png"

set title  "Sorted Daily Average Relative Humidity"
set xlabel "Sorted Record Index"
set ylabel "Relative Humidity (%)"

set xrange [0:1059]
set yrange [-5:125]

set key ins vert left top

plot '..\Data_middle\statsort_day_dayavg_relh.txt' \
  every ::9 using 1 with lines title 'Average',\
  '..\Data_middle\statsort_day_dayavg_relh.txt' \
  every ::9 using 2 with lines title 'Minimum',\
  '..\Data_middle\statsort_day_dayavg_relh.txt' \
  every ::9 using 3 with lines title 'Maximum'

unset output
#**********************************
#6.Cumulative record of dayavg_wspd

set term png
set output "g_plot_sort_dayavg_wspd.png"

set title  "Sorted Daily Average Wind Speed"
set xlabel "Sorted Record Index"
set ylabel "Wind Speed (m/s)"

set xrange [0:1059]
set yrange [-2:45]

set key ins vert right top

plot '..\Data_middle\statsort_day_dayavg_wspd.txt' \
  every ::9 using 1 with lines title 'Average',\
  '..\Data_middle\statsort_day_dayavg_wspd.txt' \
  every ::9 using 2 with lines title 'Minimum',\
  '..\Data_middle\statsort_day_dayavg_wspd.txt' \
  every ::9 using 3 with lines title 'Maximum'

unset output
#**********************************
#7.Cumulative record of daymax_airt

set term png
set output "g_plot_sort_daymax_airt.png"

set title  "Sorted Daily Maximum Air Temperature"
set xlabel "Sorted Record Index"
set ylabel "Air Temperature (C)"

set xrange [0:1059]
set yrange [-25:55]

set key ins vert left top

plot '..\Data_middle\statsort_day_daymax_airt.txt' \
  every ::9 using 1 with lines title 'Average',\
  '..\Data_middle\statsort_day_daymax_airt.txt' \
  every ::9 using 2 with lines title 'Minimum',\
  '..\Data_middle\statsort_day_daymax_airt.txt' \
  every ::9 using 3 with lines title 'Maximum'

unset output
#**********************************
#8.Cumulative record of daymin_airt

set term png
set output "g_plot_sort_daymin_airt.png"

set title  "Sorted Daily Minimum Air Temperature"
set xlabel "Sorted Record Index"
set ylabel "Air Temperature (C)"

set xrange [0:1059]
set yrange [-40:40]

set key ins vert left top

plot '..\Data_middle\statsort_day_daymin_airt.txt' \
  every ::9 using 1 with lines title 'Average',\
  '..\Data_middle\statsort_day_daymin_airt.txt' \
  every ::9 using 2 with lines title 'Minimum',\
  '..\Data_middle\statsort_day_daymin_airt.txt' \
  every ::9 using 3 with lines title 'Maximum'

unset output
#**********************************
#9.Cumulative record of daymin_minbod

set term png
set output "g_plot_sort_daymin_minbod.png"

set title  "Sorted Daily Minimum Near Surface Air Temperature"
set xlabel "Sorted Record Index"
set ylabel "Air Temperature (C)"

set xrange [0:1059]
set yrange [-40:55]

set key ins vert left top

plot '..\Data_middle\statsort_day_daymin_minbod.txt' \
  every ::9 using 1 with lines title 'Average',\
  '..\Data_middle\statsort_day_daymin_minbod.txt' \
  every ::9 using 2 with lines title 'Minimum',\
  '..\Data_middle\statsort_day_daymin_minbod.txt' \
  every ::9 using 3 with lines title 'Maximum'

unset output
#**********************************
#10.Cumulative record of daymax_gust

set term png
set output "g_plot_sort_daymax_gust.png"

set title  "Sorted Daily Maximum Gust"
set xlabel "Sorted Record Index"
set ylabel "Wind Speed (m/s)"

set xrange [0:1059]
set yrange [0:140]

set key ins vert right top

plot '..\Data_middle\statsort_day_daymax_gust.txt' \
  every ::9 using 1 with lines title 'Average',\
  '..\Data_middle\statsort_day_daymax_gust.txt' \
  every ::9 using 2 with lines title 'Minimum',\
  '..\Data_middle\statsort_day_daymax_gust.txt' \
  every ::9 using 3 with lines title 'Maximum'

unset output
#**********************************
#11.Cumulative record of daytot_ppt

set term png
set output "g_plot_sort_daytot_ppt.png"

set title  "Sorted Daily Total Precipitation"
set xlabel "Sorted Record Index"
set ylabel "Precipitation (mm)"

set xrange [0:1059]
set yrange [-5:320]

set key ins vert left top

plot '..\Data_middle\statsort_day_daytot_ppt.txt' \
  every ::9 using 1 with lines title 'Average',\
  '..\Data_middle\statsort_day_daytot_ppt.txt' \
  every ::9 using 2 with lines title 'Minimum',\
  '..\Data_middle\statsort_day_daytot_ppt.txt' \
  every ::9 using 3 with lines title 'Maximum'

unset output
#**********************************
#12.Cumulative record of daytot_sundur

set term png
set output "g_plot_sort_daytot_sundur.png"

set title  "Sorted Daily Total Sunshine Duration"
set xlabel "Sorted Record Index"
set ylabel "Sunshine Duration (h)"

set xrange [0:1059]
set yrange [-1:24]

set key ins vert right top

plot '..\Data_middle\statsort_day_daytot_sundur.txt' \
  every ::9 using 1 with lines title 'Average',\
  '..\Data_middle\statsort_day_daytot_sundur.txt' \
  every ::9 using 2 with lines title 'Minimum',\
  '..\Data_middle\statsort_day_daytot_sundur.txt' \
  every ::9 using 3 with lines title 'Maximum'

unset output
#**********************************
#13.Cumulative record of daytot_snoacc

set term png
set output "g_plot_sort_daytot_snoacc.png"

set title  "Sorted Daily Total Snow Accumulation"
set xlabel "Sorted Record Index"
set ylabel "Snow Accumulation (cm)"

set xrange [0:1059]
set yrange [-1:800]

set key ins vert left top

plot '..\Data_middle\statsort_day_daytot_snoacc.txt' \
  every ::9 using 1 with lines title 'Average',\
  '..\Data_middle\statsort_day_daytot_snoacc.txt' \
  every ::9 using 2 with lines title 'Minimum',\
  '..\Data_middle\statsort_day_daytot_snoacc.txt' \
  every ::9 using 3 with lines title 'Maximum'

unset output
#**********************************



