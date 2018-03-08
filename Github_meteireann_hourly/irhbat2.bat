::Run batch program to import lists of Ireland day files
::AJ_Kettle, Nov20/2017

echo off

gfortran -c -o ir2.o ir2.f
gfortran -c -o Subroutine\import_directory_names2.o Subroutine\import_directory_names2.f
gfortran -c -o Subroutine\readin_metadata_subday.o  Subroutine\readin_metadata_subday.f
gfortran -c -o Subroutine\create_basis_set_subday.o Subroutine\create_basis_set_subday.f
gfortran -c -o Subroutine\get_data2.o               Subroutine\get_data2.f
gfortran -c -o Subroutine\convert_variables_subday.o Subroutine\convert_variables_subday.f 
gfortran -c -o Subroutine\find_statf_ei_hour2.o     Subroutine\find_statf_ei_hour2.f
gfortran -c -o Subroutine\export_header_subday2.o   Subroutine\export_header_subday2.f
gfortran -c -o Subroutine\export_observation_subday2.o Subroutine\export_observation_subday2.f
gfortran -c -o Subroutine\export_observation_subday3.o Subroutine\export_observation_subday3.f

gfortran -o a.exe ir2.o ^
  Subroutine\import_directory_names2.o ^
  Subroutine\readin_metadata_subday.o Subroutine\create_basis_set_subday.o ^
  Subroutine\get_data2.o Subroutine\convert_variables_subday.o ^
  Subroutine\find_statf_ei_hour2.o ^
  Subroutine\export_header_subday2.o Subroutine\export_observation_subday2.o
