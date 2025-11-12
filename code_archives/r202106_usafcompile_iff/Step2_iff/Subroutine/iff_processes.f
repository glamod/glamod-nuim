c     Subroutine to do all IFF processes
c     AJ_Kettle, 28Jun2019
c     06Aug2019: modified index of i_triple_datacnt_good from 20 to l_rgh_datalines
c     27Aug2019: modified from iff_all_processes 

      SUBROUTINE iff_processes(s_date_st,s_time_st,
     +   f_ndflag,d_ndflag,s_networktype,s_platformid,
     +   s_directory_outfile_iff_fileaccept,
     +   s_directory_outfile_iff_netplatdistinct,
     +   s_directory_outfile_iff_netplatdistinct2,
     +   s_metasingle_platformid,s_metasingle_networktype,
     +   s_metasingle_name,s_metasingle_cdmlandcode,
     +   s_metasingle_lat,s_metasingle_lon,s_metasingle_elev,
     +   l_c1,l_c2,l_rgh_datalines,l_data,
     +   s_vec_platformid,s_vec_networktype,
     +   s_vec_ncdc_ob_time,s_vec_reporttypecode,
     +   s_vec_latitude,s_vec_longitude,s_vec_platformheight,
     +   s_vec_winddirection_deg,s_vec_winddirection_qc,
     +   s_vec_windspeed_ms,s_vec_windspeed_qc,
     +   s_vec_airtemperature_c,s_vec_airtemperature_qc,
     +   s_vec_dewpointtemperature_c,s_vec_dewpointtemperature_qc,
     +   s_vec_sealevelpressure_hpa,s_vec_sealevelpressure_qc,
     +   s_vec_stationpressure_hpa,s_vec_stationpressure_qc,
     +   s_vec_date_dd_mm_yyyy,s_vec_time_hh_mm_ss,
     +   f_vec_latitude,f_vec_longitude,f_vec_platformheight,

     +   i_vec_triplet_index,i_0good_1bad_2zero)

      IMPLICIT NONE
c************************************************************************
c     Variables passed into subroutine

      CHARACTER(LEN=8)    :: s_date_st
      CHARACTER(LEN=10)   :: s_time_st

      REAL                :: f_ndflag
      DOUBLE PRECISION    :: d_ndflag

      CHARACTER(LEN=300)  :: s_fileuse
      CHARACTER(LEN=30)   :: s_networktype
      CHARACTER(LEN=30)   :: s_platformid

      CHARACTER(LEN=300)  :: s_directory_outfile_iff_fileaccept
      CHARACTER(LEN=300)  :: s_directory_outfile_iff_netplatdistinct
      CHARACTER(LEN=300)  :: s_directory_outfile_iff_netplatdistinct2

      CHARACTER(LEN=30)   :: s_metasingle_platformid
      CHARACTER(LEN=30)   :: s_metasingle_networktype
      CHARACTER(LEN=100)  :: s_metasingle_name
      CHARACTER(LEN=15)   :: s_metasingle_cdmlandcode
      CHARACTER(LEN=15)   :: s_metasingle_lat
      CHARACTER(LEN=15)   :: s_metasingle_lon
      CHARACTER(LEN=15)   :: s_metasingle_elev

      INTEGER             :: l_c1,l_c2
      INTEGER             :: l_rgh_datalines
      INTEGER             :: l_data

      CHARACTER(LEN=15)   :: s_vec_platformid(l_rgh_datalines)
      CHARACTER(LEN=15)   :: s_vec_networktype(l_rgh_datalines)
      CHARACTER(LEN=14)   :: s_vec_ncdc_ob_time(l_rgh_datalines)
      CHARACTER(LEN=6)    :: s_vec_reporttypecode(l_rgh_datalines)
      CHARACTER(LEN=15)   :: s_vec_latitude(l_rgh_datalines)
      CHARACTER(LEN=15)   :: s_vec_longitude(l_rgh_datalines)
      CHARACTER(LEN=15)   :: s_vec_platformheight(l_rgh_datalines)

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

      CHARACTER(LEN=10)   :: s_vec_date_dd_mm_yyyy(l_rgh_datalines) 
      CHARACTER(LEN=8)    :: s_vec_time_hh_mm_ss(l_rgh_datalines)

      REAL                :: f_vec_latitude(l_rgh_datalines)
      REAL                :: f_vec_longitude(l_rgh_datalines)
      REAL                :: f_vec_platformheight(l_rgh_datalines)

      INTEGER             :: i_vec_triplet_index(l_rgh_datalines)
c*****
c     Variables used within subroutine
      INTEGER             :: i,j,k,ii,jj,kk

      INTEGER             :: i_triplediff_cnt
      INTEGER             :: i_triplediff_numobs(l_rgh_datalines)
      REAL                :: f_triplediff_lat(l_rgh_datalines)
      REAL                :: f_triplediff_lon(l_rgh_datalines)
      REAL                :: f_triplediff_plathght(l_rgh_datalines)
      INTEGER             :: i_triplediff_nswitch
      CHARACTER(LEN=15)   :: s_triplediff_lat(l_rgh_datalines)
      CHARACTER(LEN=15)   :: s_triplediff_lon(l_rgh_datalines)
      CHARACTER(LEN=15)   :: s_triplediff_plathght(l_rgh_datalines)

      INTEGER             :: i_triple_datacnt_good_wdir(l_rgh_datalines)
      INTEGER             :: i_triple_datacnt_good_wspd(l_rgh_datalines)
      INTEGER             :: i_triple_datacnt_good_airt(l_rgh_datalines)
      INTEGER             :: i_triple_datacnt_good_dewp(l_rgh_datalines)
      INTEGER             :: i_triple_datacnt_good_slp(l_rgh_datalines)
      INTEGER             :: i_triple_datacnt_good_stnp(l_rgh_datalines)

      REAL                :: f_max_distance_span_km
      REAL                :: f_threshold
      INTEGER             :: i_0good_1bad_2zero
c*****
c*****
      CHARACTER(LEN=10)   :: s_wdir_st_date_dd_mm_yyyy 
      CHARACTER(LEN=8)    :: s_wdir_st_time_hh_mm_ss
      CHARACTER(LEN=10)   :: s_wdir_en_date_dd_mm_yyyy 
      CHARACTER(LEN=8)    :: s_wdir_en_time_hh_mm_ss

      CHARACTER(LEN=10)   :: s_wspd_st_date_dd_mm_yyyy 
      CHARACTER(LEN=8)    :: s_wspd_st_time_hh_mm_ss
      CHARACTER(LEN=10)   :: s_wspd_en_date_dd_mm_yyyy 
      CHARACTER(LEN=8)    :: s_wspd_en_time_hh_mm_ss

      CHARACTER(LEN=10)   :: s_airt_st_date_dd_mm_yyyy 
      CHARACTER(LEN=8)    :: s_airt_st_time_hh_mm_ss
      CHARACTER(LEN=10)   :: s_airt_en_date_dd_mm_yyyy 
      CHARACTER(LEN=8)    :: s_airt_en_time_hh_mm_ss

      CHARACTER(LEN=10)   :: s_dewp_st_date_dd_mm_yyyy 
      CHARACTER(LEN=8)    :: s_dewp_st_time_hh_mm_ss
      CHARACTER(LEN=10)   :: s_dewp_en_date_dd_mm_yyyy 
      CHARACTER(LEN=8)    :: s_dewp_en_time_hh_mm_ss

      CHARACTER(LEN=10)   :: s_slp_st_date_dd_mm_yyyy 
      CHARACTER(LEN=8)    :: s_slp_st_time_hh_mm_ss
      CHARACTER(LEN=10)   :: s_slp_en_date_dd_mm_yyyy 
      CHARACTER(LEN=8)    :: s_slp_en_time_hh_mm_ss

      CHARACTER(LEN=10)   :: s_stnp_st_date_dd_mm_yyyy 
      CHARACTER(LEN=8)    :: s_stnp_st_time_hh_mm_ss
      CHARACTER(LEN=10)   :: s_stnp_en_date_dd_mm_yyyy 
      CHARACTER(LEN=8)    :: s_stnp_en_time_hh_mm_ss
c*****
      CHARACTER(LEN=50)   :: s_paramname
      CHARACTER(LEN=50)   :: s_paramunit
c************************************************************************
      print*,'just entered iff_processes'

c      print*,'s_directory_outfile_iff_fileaccept=',
c     +  TRIM(s_directory_outfile_iff_fileaccept)
c      print*,'s_directory_outfile_iff_netplatdistinct=',
c     +  TRIM(s_directory_outfile_iff_netplatdistinct)

c      print*,'l_c1,l_c2=',l_c1,l_c2
c      print*,'l_data=',l_data

c      print*,'s_vec_ncdc_ob_time=',(TRIM(s_vec_ncdc_ob_time(i)),i=1,5)
c      print*,'s_vec_date_dd_mm_yyyy=',
c     +  (TRIM(s_vec_date_dd_mm_yyyy(i)),i=1,5) 
c      print*,'s_vec_time_hh_mm_ss=',
c     +  (TRIM(s_vec_time_hh_mm_ss(i)),i=1,5)

c     Find distinct lat-lon-hgt
c      CALL find_distinct_triplet_latlonhgt(f_ndflag,
c     +  l_rgh_datalines,l_data,
c     +  f_vec_latitude,f_vec_longitude,f_vec_platformheight,

c     +  i_triplediff_cnt,i_triplediff_numobs,
c     +  f_triplediff_lat,f_triplediff_lon,f_triplediff_plathght,
c     +  i_triplediff_nswitch, 
c     +  i_vec_triplet_index)

      CALL find_distinct_triplet_latlonhgt2(f_ndflag,
     +  l_rgh_datalines,l_data,
     +  f_vec_latitude,f_vec_longitude,f_vec_platformheight,
     +  s_vec_latitude,s_vec_longitude,s_vec_platformheight,

     +  i_triplediff_cnt,i_triplediff_numobs,
     +  f_triplediff_lat,f_triplediff_lon,f_triplediff_plathght,
     +  s_triplediff_lat,s_triplediff_lon,s_triplediff_plathght,
     +  i_triplediff_nswitch, 
     +  i_vec_triplet_index)
c*****
c      GOTO 10

c     Crash program any lat/lon is zero
      DO i=1,i_triplediff_cnt
       IF (f_triplediff_lat(i).EQ.0.0.OR.
     +     f_triplediff_lon(i).EQ.0.0) THEN 

        i_0good_1bad_2zero=2

c        print*,'f_triplediff_lat/lon(i)=',
c     +    f_triplediff_lat(i),f_triplediff_lon(i)

c        print*,'i_triplediff_cnt=',i_triplediff_cnt
c        print*,'f_triplediff_lat=',
c     +    (f_triplediff_lat(j),j=1,i_triplediff_cnt)
c        print*,'f_triplediff_lon=',
c     +    (f_triplediff_lon(j),j=1,i_triplediff_cnt)

c        print*,'s_triplediff_lat=',
c     +    (s_triplediff_lat(j),j=1,i_triplediff_cnt)
c        print*,'s_triplediff_lon=',
c     +    (s_triplediff_lon(j),j=1,i_triplediff_cnt)

c        STOP 'iff_processes, lat condition'

        GOTO 20

       ENDIF
      ENDDO

 10   CONTINUE
c*****
c     Find max-distance span
      CALL find_max_distance_span(l_rgh_datalines,
     +  i_triplediff_cnt,f_triplediff_lat,f_triplediff_lon,
     +  f_max_distance_span_km)
c*****
c     Decide on export directory
      f_threshold=40.0
c     Accept condition
      IF (f_max_distance_span_km.LE.f_threshold) THEN
       i_0good_1bad_2zero=0
      ENDIF
c     Reject condition
      IF (f_max_distance_span_km.GT.f_threshold) THEN
       i_0good_1bad_2zero=1
      ENDIF

 20   CONTINUE
c*****
c     Get key stats from vectors without producing IFF files
      CALL export_triplet_info5(s_date_st,s_time_st,
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
c*****
c     Make N-files for single variable

      s_paramname='wind_direction'
      s_paramunit='degrees'
      CALL make_iff_file_singlevar(i_0good_1bad_2zero,
     +   s_directory_outfile_iff_fileaccept,s_networktype,s_platformid,
     +   s_paramname,s_paramunit,
     +   s_metasingle_name,
     +   l_c1,l_c2,l_rgh_datalines,l_data,
     +   s_vec_platformid,s_vec_networktype,
     +   s_vec_ncdc_ob_time,s_vec_reporttypecode,
     +   s_vec_latitude,s_vec_longitude,s_vec_platformheight,
     +   s_vec_winddirection_deg,s_vec_winddirection_qc,
     +   s_vec_date_dd_mm_yyyy,s_vec_time_hh_mm_ss,
     +   i_vec_triplet_index,
     +   i_triplediff_cnt,i_triple_datacnt_good_wdir,
     +   s_wdir_st_date_dd_mm_yyyy,s_wdir_st_time_hh_mm_ss,
     +   s_wdir_en_date_dd_mm_yyyy,s_wdir_en_time_hh_mm_ss)

      s_paramname='wind_speed'
      s_paramunit='meters per second'
      CALL make_iff_file_singlevar(i_0good_1bad_2zero,
     +   s_directory_outfile_iff_fileaccept,s_networktype,s_platformid,
     +   s_paramname,s_paramunit,
     +   s_metasingle_name,
     +   l_c1,l_c2,l_rgh_datalines,l_data,
     +   s_vec_platformid,s_vec_networktype,
     +   s_vec_ncdc_ob_time,s_vec_reporttypecode,
     +   s_vec_latitude,s_vec_longitude,s_vec_platformheight,
     +   s_vec_windspeed_ms,s_vec_windspeed_qc,
     +   s_vec_date_dd_mm_yyyy,s_vec_time_hh_mm_ss,
     +   i_vec_triplet_index,
     +   i_triplediff_cnt,i_triple_datacnt_good_wspd,
     +   s_wspd_st_date_dd_mm_yyyy,s_wspd_st_time_hh_mm_ss,
     +   s_wspd_en_date_dd_mm_yyyy,s_wspd_en_time_hh_mm_ss)

      s_paramname='temperature'      !'air_temperature'
      s_paramunit='degrees C'
      CALL make_iff_file_singlevar(i_0good_1bad_2zero,
     +   s_directory_outfile_iff_fileaccept,s_networktype,s_platformid,
     +   s_paramname,s_paramunit,
     +   s_metasingle_name,
     +   l_c1,l_c2,l_rgh_datalines,l_data,
     +   s_vec_platformid,s_vec_networktype,
     +   s_vec_ncdc_ob_time,s_vec_reporttypecode,
     +   s_vec_latitude,s_vec_longitude,s_vec_platformheight,
     +   s_vec_airtemperature_c,s_vec_airtemperature_qc,
     +   s_vec_date_dd_mm_yyyy,s_vec_time_hh_mm_ss,
     +   i_vec_triplet_index,
     +   i_triplediff_cnt,i_triple_datacnt_good_airt,
     +   s_airt_st_date_dd_mm_yyyy,s_airt_st_time_hh_mm_ss,
     +   s_airt_en_date_dd_mm_yyyy,s_airt_en_time_hh_mm_ss)

      s_paramname='dew_point_temperature'
      s_paramunit='degrees C'
      CALL make_iff_file_singlevar(i_0good_1bad_2zero,
     +   s_directory_outfile_iff_fileaccept,s_networktype,s_platformid,
     +   s_paramname,s_paramunit,
     +   s_metasingle_name,
     +   l_c1,l_c2,l_rgh_datalines,l_data,
     +   s_vec_platformid,s_vec_networktype,
     +   s_vec_ncdc_ob_time,s_vec_reporttypecode,
     +   s_vec_latitude,s_vec_longitude,s_vec_platformheight,
     +   s_vec_dewpointtemperature_c,s_vec_dewpointtemperature_qc,
     +   s_vec_date_dd_mm_yyyy,s_vec_time_hh_mm_ss,
     +   i_vec_triplet_index,
     +   i_triplediff_cnt,i_triple_datacnt_good_dewp,
     +   s_dewp_st_date_dd_mm_yyyy,s_dewp_st_time_hh_mm_ss,
     +   s_dewp_en_date_dd_mm_yyyy,s_dewp_en_time_hh_mm_ss)

      s_paramname='sea_level_pressure'
      s_paramunit='hPa hectopascals'
      CALL make_iff_file_singlevar(i_0good_1bad_2zero,
     +   s_directory_outfile_iff_fileaccept,s_networktype,s_platformid,
     +   s_paramname,s_paramunit,
     +   s_metasingle_name,
     +   l_c1,l_c2,l_rgh_datalines,l_data,
     +   s_vec_platformid,s_vec_networktype,
     +   s_vec_ncdc_ob_time,s_vec_reporttypecode,
     +   s_vec_latitude,s_vec_longitude,s_vec_platformheight,
     +   s_vec_sealevelpressure_hpa,s_vec_sealevelpressure_qc,
     +   s_vec_date_dd_mm_yyyy,s_vec_time_hh_mm_ss,
     +   i_vec_triplet_index,
     +   i_triplediff_cnt,i_triple_datacnt_good_slp,
     +   s_slp_st_date_dd_mm_yyyy,s_slp_st_time_hh_mm_ss,
     +   s_slp_en_date_dd_mm_yyyy,s_slp_en_time_hh_mm_ss)

      s_paramname='station_level_pressure'
      s_paramunit='hPa hectopascals'
      CALL make_iff_file_singlevar(i_0good_1bad_2zero,
     +   s_directory_outfile_iff_fileaccept,s_networktype,s_platformid,
     +   s_paramname,s_paramunit,
     +   s_metasingle_name,
     +   l_c1,l_c2,l_rgh_datalines,l_data,
     +   s_vec_platformid,s_vec_networktype,
     +   s_vec_ncdc_ob_time,s_vec_reporttypecode,
     +   s_vec_latitude,s_vec_longitude,s_vec_platformheight,
     +   s_vec_stationpressure_hpa,s_vec_stationpressure_qc,
     +   s_vec_date_dd_mm_yyyy,s_vec_time_hh_mm_ss,
     +   i_vec_triplet_index,
     +   i_triplediff_cnt,i_triple_datacnt_good_stnp,
     +   s_stnp_st_date_dd_mm_yyyy,s_stnp_st_time_hh_mm_ss,
     +   s_stnp_en_date_dd_mm_yyyy,s_stnp_en_time_hh_mm_ss)
c*****
c     segment used to produce receipt files for July2019 IFF files
      CALL export_triplet_info(i_0good_1bad_2zero,
     +   l_rgh_datalines,l_data,
     +   s_directory_outfile_iff_netplatdistinct2,
     +   s_networktype,s_platformid, 
     +   i_triplediff_cnt,i_triplediff_numobs,
     +   f_triplediff_lat,f_triplediff_lon,f_triplediff_plathght,
     +   i_triple_datacnt_good_wdir,i_triple_datacnt_good_wspd,
     +   i_triple_datacnt_good_airt,i_triple_datacnt_good_dewp,
     +   i_triple_datacnt_good_slp,i_triple_datacnt_good_stnp)
c*****
      print*,'just leaving iff_processes'

c      STOP 'iff_processes'

      RETURN
      END
