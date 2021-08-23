c     Subroutine to output receipt file for stnconfig file
c     AJ_Kettle, 29Aug2019
c     16Mar2020: used for USAF update

      SUBROUTINE export_triplet_info5(s_date_st,s_time_st,
     +   i_0good_1bad_2zero,
     +   s_directory_outfile_iff_netplatdistinct,
     +   s_networktype,s_platformid, 
     +   s_metasingle_platformid,s_metasingle_networktype,
     +   s_metasingle_name,s_metasingle_cdmlandcode,
     +   s_metasingle_lat,s_metasingle_lon,s_metasingle_elev,
     +   i_triplediff_cnt,i_triplediff_numobs,
     +   f_triplediff_lat,f_triplediff_lon,f_triplediff_plathght,
     +   l_c1,l_c2,l_rgh_datalines,l_data,
     +   s_vec_date_dd_mm_yyyy,s_vec_time_hh_mm_ss,
     +   i_vec_triplet_index,
     +   s_vec_winddirection_deg,s_vec_winddirection_qc,
     +   s_vec_windspeed_ms,s_vec_windspeed_qc,
     +   s_vec_airtemperature_c,s_vec_airtemperature_qc,
     +   s_vec_dewpointtemperature_c,s_vec_dewpointtemperature_qc,
     +   s_vec_sealevelpressure_hpa,s_vec_sealevelpressure_qc,
     +   s_vec_stationpressure_hpa,s_vec_stationpressure_qc)

      IMPLICIT NONE
c************************************************************************
c     Declare variables 

      CHARACTER(LEN=8)    :: s_date_st
      CHARACTER(LEN=10)   :: s_time_st

      INTEGER             :: i_0good_1bad_2zero

      CHARACTER(LEN=300)  :: s_directory_outfile_iff_netplatdistinct

      CHARACTER(LEN=30)   :: s_networktype
      CHARACTER(LEN=30)   :: s_platformid

      CHARACTER(LEN=30)   :: s_metasingle_platformid
      CHARACTER(LEN=30)   :: s_metasingle_networktype
      CHARACTER(LEN=100)  :: s_metasingle_name
      CHARACTER(LEN=15)   :: s_metasingle_cdmlandcode
      CHARACTER(LEN=15)   :: s_metasingle_lat
      CHARACTER(LEN=15)   :: s_metasingle_lon
      CHARACTER(LEN=15)   :: s_metasingle_elev

      INTEGER             :: i_triplediff_cnt
      INTEGER             :: i_triplediff_numobs(l_rgh_datalines)
      REAL                :: f_triplediff_lat(l_rgh_datalines)
      REAL                :: f_triplediff_lon(l_rgh_datalines)
      REAL                :: f_triplediff_plathght(l_rgh_datalines)

      INTEGER             :: l_c1
      INTEGER             :: l_c2 
      INTEGER             :: l_rgh_datalines
      INTEGER             :: l_data

      CHARACTER(LEN=10)   :: s_vec_date_dd_mm_yyyy(l_rgh_datalines) 
      CHARACTER(LEN=8)    :: s_vec_time_hh_mm_ss(l_rgh_datalines)

      INTEGER             :: i_vec_triplet_index(l_rgh_datalines)

      CHARACTER(LEN=l_c1) :: s_vec_winddirection_deg(l_rgh_datalines)
      CHARACTER(LEN=l_c2) :: s_vec_winddirection_qc(l_rgh_datalines)
      CHARACTER(LEN=l_c1) :: s_vec_windspeed_ms(l_rgh_datalines)
      CHARACTER(LEN=l_c2) :: s_vec_windspeed_qc(l_rgh_datalines)
      CHARACTER(LEN=l_c1) :: s_vec_airtemperature_c(l_rgh_datalines)
      CHARACTER(LEN=l_c2) :: s_vec_airtemperature_qc(l_rgh_datalines)
      CHARACTER(LEN=l_c1)::s_vec_dewpointtemperature_c(l_rgh_datalines)
      CHARACTER(LEN=l_c2)::s_vec_dewpointtemperature_qc(l_rgh_datalines)
      CHARACTER(LEN=l_c1) :: s_vec_sealevelpressure_hpa(l_rgh_datalines)
      CHARACTER(LEN=l_c2) :: s_vec_sealevelpressure_qc(l_rgh_datalines)
      CHARACTER(LEN=l_c1) :: s_vec_stationpressure_hpa(l_rgh_datalines)
      CHARACTER(LEN=l_c2) :: s_vec_stationpressure_qc(l_rgh_datalines)
c*****
c     Variables used in subroutine

      INTEGER             :: i,j,k,ii,jj,kk

c     WDIR
      INTEGER            :: i_triplet_datacnt_good_wdir(l_rgh_datalines)
      INTEGER             :: i_triplet_datacnt_bad_wdir(l_rgh_datalines)
      CHARACTER(LEN=4)    :: s_triplet_st_year_wdir(l_rgh_datalines)
      CHARACTER(LEN=4)    :: s_triplet_en_year_wdir(l_rgh_datalines)     

c     WSPD
      INTEGER            :: i_triplet_datacnt_good_wspd(l_rgh_datalines)
      INTEGER             :: i_triplet_datacnt_bad_wspd(l_rgh_datalines)
      CHARACTER(LEN=4)    :: s_triplet_st_year_wspd(l_rgh_datalines)
      CHARACTER(LEN=4)    :: s_triplet_en_year_wspd(l_rgh_datalines)   

c     AIRT
      INTEGER            :: i_triplet_datacnt_good_airt(l_rgh_datalines)
      INTEGER             :: i_triplet_datacnt_bad_airt(l_rgh_datalines)
      CHARACTER(LEN=4)    :: s_triplet_st_year_airt(l_rgh_datalines)
      CHARACTER(LEN=4)    :: s_triplet_en_year_airt(l_rgh_datalines)

c     DEWP
      INTEGER            :: i_triplet_datacnt_good_dewp(l_rgh_datalines)
      INTEGER             :: i_triplet_datacnt_bad_dewp(l_rgh_datalines)
      CHARACTER(LEN=4)    :: s_triplet_st_year_dewp(l_rgh_datalines)
      CHARACTER(LEN=4)    :: s_triplet_en_year_dewp(l_rgh_datalines)   

c     SLP
      INTEGER            :: i_triplet_datacnt_good_slp(l_rgh_datalines)
      INTEGER             :: i_triplet_datacnt_bad_slp(l_rgh_datalines)
      CHARACTER(LEN=4)    :: s_triplet_st_year_slp(l_rgh_datalines)
      CHARACTER(LEN=4)    :: s_triplet_en_year_slp(l_rgh_datalines)   

c     STNP
      INTEGER            :: i_triplet_datacnt_good_stnp(l_rgh_datalines)
      INTEGER             :: i_triplet_datacnt_bad_stnp(l_rgh_datalines)
      CHARACTER(LEN=4)    :: s_triplet_st_year_stnp(l_rgh_datalines)
      CHARACTER(LEN=4)    :: s_triplet_en_year_stnp(l_rgh_datalines)   

      CHARACTER(LEN=4)    :: s_year_st_g6(l_rgh_datalines)
      CHARACTER(LEN=4)    :: s_year_en_g6(l_rgh_datalines)
      CHARACTER(LEN=30)   :: s_assemble_varcode(l_rgh_datalines)    

      INTEGER             :: i_label
c************************************************************************
c      print*,'just entered export_triplet_info5'

c     wdir
      i_label=1
      CALL get_key_stats_singlevar(i_label,
     +   l_c1,l_c2,l_rgh_datalines,l_data,
     +   i_triplediff_cnt, 
     +   s_vec_winddirection_deg,s_vec_winddirection_qc,
     +   s_vec_date_dd_mm_yyyy,s_vec_time_hh_mm_ss,
     +   i_vec_triplet_index,

     +   i_triplet_datacnt_good_wdir,i_triplet_datacnt_bad_wdir,
     +   s_triplet_st_year_wdir,s_triplet_en_year_wdir)  

c     wspd
      i_label=2
      CALL get_key_stats_singlevar(i_label,
     +   l_c1,l_c2,l_rgh_datalines,l_data,
     +   i_triplediff_cnt, 
     +   s_vec_windspeed_ms,s_vec_windspeed_qc,
     +   s_vec_date_dd_mm_yyyy,s_vec_time_hh_mm_ss,
     +   i_vec_triplet_index,

     +   i_triplet_datacnt_good_wspd,i_triplet_datacnt_bad_wspd,
     +   s_triplet_st_year_wspd,s_triplet_en_year_wspd)  

c     airtemperature
      i_label=3
      CALL get_key_stats_singlevar(i_label,
     +   l_c1,l_c2,l_rgh_datalines,l_data,
     +   i_triplediff_cnt, 
     +   s_vec_airtemperature_c,s_vec_airtemperature_qc,
     +   s_vec_date_dd_mm_yyyy,s_vec_time_hh_mm_ss,
     +   i_vec_triplet_index,

     +   i_triplet_datacnt_good_airt,i_triplet_datacnt_bad_airt,
     +   s_triplet_st_year_airt,s_triplet_en_year_airt)  

c     dewpointtemperature
      i_label=4
      CALL get_key_stats_singlevar(i_label,
     +   l_c1,l_c2,l_rgh_datalines,l_data,
     +   i_triplediff_cnt, 
     +   s_vec_dewpointtemperature_c,s_vec_dewpointtemperature_qc,
     +   s_vec_date_dd_mm_yyyy,s_vec_time_hh_mm_ss,
     +   i_vec_triplet_index,

     +   i_triplet_datacnt_good_dewp,i_triplet_datacnt_bad_dewp,
     +   s_triplet_st_year_dewp,s_triplet_en_year_dewp)  

c     slp
      i_label=5
      CALL get_key_stats_singlevar(i_label,
     +   l_c1,l_c2,l_rgh_datalines,l_data,
     +   i_triplediff_cnt, 
     +   s_vec_sealevelpressure_hpa,s_vec_sealevelpressure_qc,
     +   s_vec_date_dd_mm_yyyy,s_vec_time_hh_mm_ss,
     +   i_vec_triplet_index,

     +   i_triplet_datacnt_good_slp,i_triplet_datacnt_bad_slp,
     +   s_triplet_st_year_slp,s_triplet_en_year_slp)  

c     stnp
      i_label=6
      CALL get_key_stats_singlevar(i_label,
     +   l_c1,l_c2,l_rgh_datalines,l_data,
     +   i_triplediff_cnt, 
     +   s_vec_stationpressure_hpa,s_vec_stationpressure_qc,
     +   s_vec_date_dd_mm_yyyy,s_vec_time_hh_mm_ss,
     +   i_vec_triplet_index,

     +   i_triplet_datacnt_good_stnp,i_triplet_datacnt_bad_stnp,
     +   s_triplet_st_year_stnp,s_triplet_en_year_stnp)  
c*****
c     Get start/end year of 6variables from netplat

      CALL get_startend_from_6var3(
     +  l_rgh_datalines,i_triplediff_cnt,
     +  i_triplet_datacnt_good_wdir,i_triplet_datacnt_good_wspd,
     +  i_triplet_datacnt_good_airt,i_triplet_datacnt_good_dewp,
     +  i_triplet_datacnt_good_slp,i_triplet_datacnt_good_stnp,
     +  s_triplet_st_year_wdir,s_triplet_en_year_wdir, 
     +  s_triplet_st_year_wspd,s_triplet_en_year_wspd, 
     +  s_triplet_st_year_airt,s_triplet_en_year_airt, 
     +  s_triplet_st_year_dewp,s_triplet_en_year_dewp, 
     +  s_triplet_st_year_slp,s_triplet_en_year_slp, 
     +  s_triplet_st_year_stnp,s_triplet_en_year_stnp,
     +  s_year_st_g6,s_year_en_g6,
     +  s_assemble_varcode)
c*****
c     Get start/end year of 6variables from netplat

      CALL get_startend_from_6var3(
     +  l_rgh_datalines,i_triplediff_cnt,
     +  i_triplet_datacnt_good_wdir,i_triplet_datacnt_good_wspd,
     +  i_triplet_datacnt_good_airt,i_triplet_datacnt_good_dewp,
     +  i_triplet_datacnt_good_slp,i_triplet_datacnt_good_stnp,
     +  s_triplet_st_year_wdir,s_triplet_en_year_wdir, 
     +  s_triplet_st_year_wspd,s_triplet_en_year_wspd, 
     +  s_triplet_st_year_airt,s_triplet_en_year_airt, 
     +  s_triplet_st_year_dewp,s_triplet_en_year_dewp, 
     +  s_triplet_st_year_slp,s_triplet_en_year_slp, 
     +  s_triplet_st_year_stnp,s_triplet_en_year_stnp,
     +  s_year_st_g6,s_year_en_g6,
     +  s_assemble_varcode)
c*****
c     Make receipt file

c      print*,'output...',TRIM(s_directory_outfile_iff_netplatdistinct)

      CALL make_iff_receipt_file2(s_date_st,s_time_st,
     +  i_0good_1bad_2zero,
     +  s_directory_outfile_iff_netplatdistinct,
     +  s_networktype,s_platformid,
     +  s_metasingle_platformid,s_metasingle_networktype,
     +  s_metasingle_name,s_metasingle_cdmlandcode,
     +  s_metasingle_lat,s_metasingle_lon,s_metasingle_elev,
     +  l_rgh_datalines,l_data,
     +  i_triplediff_cnt,i_triplediff_numobs,
     +  f_triplediff_lat,f_triplediff_lon,f_triplediff_plathght,
     +  i_triplet_datacnt_good_wdir,i_triplet_datacnt_good_wspd,
     +  i_triplet_datacnt_good_airt,i_triplet_datacnt_good_dewp,
     +  i_triplet_datacnt_good_slp,i_triplet_datacnt_good_stnp,
     +  s_year_st_g6,s_year_en_g6,
     +  s_assemble_varcode)
c*****
c*****
c      print*,'just leaving export_triplet_info5'
c      STOP 'export_triplet_info4'

      RETURN
      END
