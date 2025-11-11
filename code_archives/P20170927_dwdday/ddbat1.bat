::Run batch program to import lists of DWD day files
::AJ_Kettle, Sep27/2017

echo off

gfortran -c -o dd1.o dd1.f
gfortran -c -o Subroutine\get_list_compressed_files_dd.o ^
  Subroutine\get_list_compressed_files_dd.f
gfortran -c -o Subroutine\get_info_stns_subday.o ^
  Subroutine\get_info_stns_subday.f
gfortran -c -o Subroutine\get_wigos_number.o ^
  Subroutine\get_wigos_number.f
gfortran -c -o Subroutine\get_geog_metadata_dd.o ^
  Subroutine\get_geog_metadata_dd.f
gfortran -c -o Subroutine\get_day_data_historical1.o ^
  Subroutine\get_day_data_historical1.f
gfortran -c -o Subroutine\convert_data_dwdday.o ^
  Subroutine\convert_data_dwdday.f
gfortran -c -o Subroutine\find_timestamp.o ^
  Subroutine\find_timestamp.f
gfortran -c -o Subroutine\slpres_from_stnpres_dwdday.o ^
  Subroutine\slpres_from_stnpres_dwdday.f
gfortran -c -o Subroutine\identify_complete_months.o ^
  Subroutine\identify_complete_months.f
gfortran -c -o Subroutine\common_month_variables.o ^
  Subroutine\common_month_variables.f
gfortran -c -o Subroutine\calc_monthly_values2.o ^
  Subroutine\calc_monthly_values2.f
gfortran -c -o Subroutine\calc_basic_stats_dd.o ^
  Subroutine\calc_basic_stats_dd.f
gfortran -c -o Subroutine\calc_basic_stats_mon.o ^
  Subroutine\calc_basic_stats_mon.f
gfortran -c -o Subroutine\dwd_day_stat_package.o ^
  Subroutine\dwd_day_stat_package.f
gfortran -c -o Subroutine\dwd_mon_stat_package.o ^
  Subroutine\dwd_mon_stat_package.f
gfortran -c -o Subroutine\count_stn_data_present.o ^
  Subroutine\count_stn_data_present.f
gfortran -c -o Subroutine\sift_sort_export.o ^
  Subroutine\sift_sort_export.f
gfortran -c -o Subroutine\make_hist_lprod_dd.o ^
  Subroutine\make_hist_lprod_dd.f
gfortran -c -o Subroutine\export_hist_recordlength_dd.o ^
  Subroutine\export_hist_recordlength_dd.f
gfortran -c -o Subroutine\export_summary_listsort_dd.o ^
  Subroutine\export_summary_listsort_dd.f
gfortran -c -o Subroutine\export_cnts_stn.o ^
  Subroutine\export_cnts_stn.f
gfortran -c -o Subroutine\export_datafile1.o ^
  Subroutine\export_datafile1.f
gfortran -c -o Subroutine\export_datafile2.o ^
  Subroutine\export_datafile2.f
gfortran -c -o Subroutine\export_datafile3.o ^
  Subroutine\export_datafile3.f 
gfortran -c -o Subroutine\export_datafile4.o ^
  Subroutine\export_datafile4.f 
gfortran -c -o Subroutine\export_tab_sn2a_stndata.o ^
  Subroutine\export_tab_sn2a_stndata.f 
gfortran -c -o Subroutine\export_tab_sn3a_stndata.o ^
  Subroutine\export_tab_sn3a_stndata.f 
gfortran -c -o Subroutine\export_header_production.o ^
  Subroutine\export_header_production.f 
gfortran -c -o Subroutine\export_observation_production.o ^
  Subroutine\export_observation_production.f 
gfortran -c -o Subroutine\export_header_production8.o ^
  Subroutine\export_header_production8.f 
gfortran -c -o Subroutine\export_observation_production8.o ^
  Subroutine\export_observation_production8.f 
gfortran -c -o Subroutine\export_mon_datafile.o ^
  Subroutine\export_mon_datafile.f 
gfortran -c -o Subroutine\export_header_monthly.o ^
  Subroutine\export_header_monthly.f 
gfortran -c -o Subroutine\export_observation_monthly.o ^
  Subroutine\export_observation_monthly.f 

gfortran -o a.exe dd1.o ^
  Subroutine\get_list_compressed_files_dd.o ^
  Subroutine\get_info_stns_subday.o Subroutine\get_wigos_number.o ^
  Subroutine\get_geog_metadata_dd.o ^
  Subroutine\get_day_data_historical1.o ^
  Subroutine\convert_data_dwdday.o Subroutine\slpres_from_stnpres_dwdday.o ^
  Subroutine\find_timestamp.o ^
  Subroutine\identify_complete_months.o ^
  Subroutine\common_month_variables.o Subroutine\calc_monthly_values2.o ^
  Subroutine\calc_basic_stats_dd.o Subroutine\calc_basic_stats_mon.o ^
  Subroutine\dwd_day_stat_package.o Subroutine\dwd_mon_stat_package.o ^
  Subroutine\count_stn_data_present.o ^
  Subroutine\sift_sort_export.o ^
  Subroutine\make_hist_lprod_dd.o ^
  Subroutine\export_hist_recordlength_dd.o Subroutine\export_summary_listsort_dd.o ^
  Subroutine\export_cnts_stn.o ^
  Subroutine\export_mon_datafile.o ^
  Subroutine\export_datafile1.o Subroutine\export_datafile2.o ^
  Subroutine\export_datafile3.o Subroutine\export_datafile4.o ^
  Subroutine\export_header_production.o Subroutine\export_observation_production.o ^
  Subroutine\export_header_production8.o Subroutine\export_observation_production8.o ^
  Subroutine\export_header_monthly.o Subroutine\export_observation_monthly.o ^
  Subroutine\export_tab_sn2a_stndata.o Subroutine\export_tab_sn3a_stndata.o