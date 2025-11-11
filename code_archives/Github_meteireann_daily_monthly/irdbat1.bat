::Run batch program to import lists of Ireland day files
::AJ_Kettle, Nov20/2017

echo off

gfortran -c -o ird1.o ird1.f
gfortran -c -o Subroutine\import_list_names.o Subroutine\import_list_names.f
gfortran -c -o Subroutine\readin_metadata.o   Subroutine\readin_metadata.f
gfortran -c -o Subroutine\create_basis_set.o  Subroutine\create_basis_set.f
gfortran -c -o Subroutine\get_daydata.o       Subroutine\get_daydata.f
gfortran -c -o Subroutine\clean_daydata.o     Subroutine\clean_daydata.f
gfortran -c -o Subroutine\convert_var_day.o   Subroutine\convert_var_day.f
gfortran -c -o Subroutine\find_statf_ei_day.o Subroutine\find_statf_ei_day.f
gfortran -c -o Subroutine\calc_mon_value_ei.o Subroutine\calc_mon_value_ei.f
gfortran -c -o Subroutine\calc_mon_total2_ei.o Subroutine\calc_mon_total2_ei.f
gfortran -c -o Subroutine\month_package2.o    Subroutine\month_package2.f
gfortran -c -o Subroutine\month_package3.o    Subroutine\month_package3.f
gfortran -c -o Subroutine\into_subroutine.o   Subroutine\into_subroutine.f
gfortran -c -o Subroutine\find_month_airt2.o  Subroutine\find_month_airt2.f
gfortran -c -o Subroutine\strip_gaps_month.o  Subroutine\strip_gaps_month.f
gfortran -c -o Subroutine\export_archstats.o  Subroutine\export_archstats.f
gfortran -c -o Subroutine\export_header_day2.o Subroutine\export_header_day2.f
gfortran -c -o Subroutine\export_observation_day2.o Subroutine\export_observation_day2.f
gfortran -c -o Subroutine\export_observation_day3.o Subroutine\export_observation_day3.f
gfortran -c -o Subroutine\export_header_month2.o Subroutine\export_header_month2.f
gfortran -c -o Subroutine\export_observation_month2.o Subroutine\export_observation_month2.f
gfortran -c -o Subroutine\export_observation_month3.o Subroutine\export_observation_month3.f

gfortran -o a.exe ird1.o ^
  Subroutine\import_list_names.o Subroutine\readin_metadata.o ^
  Subroutine\create_basis_set.o ^
  Subroutine\get_daydata.o ^
  Subroutine\clean_daydata.o Subroutine\convert_var_day.o ^
  Subroutine\find_statf_ei_day.o ^
  Subroutine\find_month_airt2.o Subroutine\strip_gaps_month.o ^
  Subroutine\calc_mon_value_ei.o Subroutine\calc_mon_total2_ei.o ^
  Subroutine\export_archstats.o ^
  Subroutine\export_header_day2.o Subroutine\export_observation_day2.o ^
  Subroutine\export_observation_day3.o ^
  Subroutine\export_header_month2.o Subroutine\export_observation_month2.o ^
  Subroutine\export_observation_month3.o