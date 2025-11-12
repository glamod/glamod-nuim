::Run batch program to import lists of DWD subdaily files
::AJ_Kettle, Oct17/2017

echo off

gfortran -c -o ds1.o ds1.f
gfortran -c -o Subroutine\getlist_comp_files.o  Subroutine\getlist_comp_files.f
gfortran -c -o Subroutine\get_data_1file.o      Subroutine\get_data_1file.f
gfortran -c -o Subroutine\get_data_2file.o      Subroutine\get_data_2file.f
gfortran -c -o Subroutine\define_basis_stnset.o Subroutine\define_basis_stnset.f
gfortran -c -o Subroutine\get_info_stns.o       Subroutine\get_info_stns.f
gfortran -c -o Subroutine\match_info_basis_set2.o Subroutine\match_info_basis_set2.f
gfortran -c -o Subroutine\calc_basic_stats_sd1.o  Subroutine\calc_basic_stats_sd1.f
gfortran -c -o Subroutine\dwd_subday_stat_pack.o  Subroutine\dwd_subday_stat_pack.f
gfortran -c -o Subroutine\dwd_subday_stat_pack2.o  Subroutine\dwd_subday_stat_pack2.f
gfortran -c -o Subroutine\sift_sort_export_sd.o Subroutine\sift_sort_export_sd.f 
gfortran -c -o Subroutine\export_basis_info.o   Subroutine\export_basis_info.f 
gfortran -c -o Subroutine\convert_variables.o   Subroutine\convert_variables.f 
gfortran -c -o Subroutine\convert_time_utc.o    Subroutine\convert_time_utc.f 

gfortran -c -o Subroutine\find_time_interval.o  Subroutine\find_time_interval.f
gfortran -c -o Subroutine\export_tab_sn1_stndata.o Subroutine\export_tab_sn1_stndata.f
gfortran -c -o Subroutine\export_listsort_sd.o  Subroutine\export_listsort_sd.f 
gfortran -c -o Subroutine\export_format_data.o  Subroutine\export_format_data.f 
gfortran -c -o Subroutine\dewp_from_vpres_stnpres.o Subroutine\dewp_from_vpres_stnpres.f
gfortran -c -o Subroutine\dewfrostp_from_vpres_spres.o Subroutine\dewfrostp_from_vpres_spres.f
gfortran -c -o Subroutine\slpres_from_stnpres.o Subroutine\slpres_from_stnpres.f
gfortran -c -o Subroutine\get_wigos_number_sd.o Subroutine\get_wigos_number_sd.f
gfortran -c -o Subroutine\export_header_subdaily.o Subroutine\export_header_subdaily.f
gfortran -c -o Subroutine\export_header_subdaily1a.o Subroutine\export_header_subdaily1a.f
gfortran -c -o Subroutine\export_header_subdaily2.o Subroutine\export_header_subdaily2.f
gfortran -c -o Subroutine\export_observation_subdaily.o Subroutine\export_observation_subdaily.f
gfortran -c -o Subroutine\export_observation_subdaily2.o Subroutine\export_observation_subdaily2.f

gfortran -o a.exe ds1.o ^
  Subroutine\getlist_comp_files.o ^
  Subroutine\get_data_1file.o Subroutine\get_data_2file.o ^
  Subroutine\define_basis_stnset.o Subroutine\get_info_stns.o ^
  Subroutine\match_info_basis_set2.o Subroutine\calc_basic_stats_sd1.o ^
  Subroutine\dwd_subday_stat_pack.o Subroutine\dwd_subday_stat_pack2.o ^
  Subroutine\sift_sort_export_sd.o Subroutine\export_basis_info.o ^
  Subroutine\convert_variables.o Subroutine\convert_time_utc.o ^
  Subroutine\find_time_interval.o ^
  Subroutine\export_tab_sn1_stndata.o ^
  Subroutine\export_listsort_sd.o ^
  Subroutine\export_format_data.o ^
  Subroutine\dewp_from_vpres_stnpres.o Subroutine\dewfrostp_from_vpres_spres.o ^
  Subroutine\slpres_from_stnpres.o Subroutine\get_wigos_number_sd.o ^
  Subroutine\export_header_subdaily.o Subroutine\export_header_subdaily1a.o ^
  Subroutine\export_header_subdaily2.o ^
  Subroutine\export_observation_subdaily.o Subroutine\export_observation_subdaily2.o
