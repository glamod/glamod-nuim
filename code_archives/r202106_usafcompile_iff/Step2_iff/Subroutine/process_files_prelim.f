c     Subroutine process USAF files to IFF format
c     AJ_Kettle, 11Mar2020

      SUBROUTINE process_files_prelim(
     +  s_date_st,s_time_st,
     +  f_ndflag,d_ndflag,
     +  s_dir_usaf_filelist,
     +  s_dir_outfile_iff_fileaccept, 
     +  s_dir_outfile_iff_netplatdistinct,
     +  s_dir_outfile_iff_netplatdistinct2,
     +  s_dir_outfile_yearstats,
     +  s_dir_outfile_yearstats_sift,
     +  s_dir_outfile_lastfile,
     +  l_stnlist_rgh,l_stnlist,s_vec_stnlist,
     +  l_scinput_rgh,l_scinput,
     +  s_scinput_primary_id,s_scinput_record_number,
     +  s_scinput_secondary_id,s_scinput_station_name,
     +  s_scinput_longitude,s_scinput_latitude,
     +  s_scinput_elevation_m,s_scinput_policy_license,
     +  s_scinput_source_id,
     +  l_scoutput_rgh,l_scoutput,
     +  s_scinput2_primary_id,s_scinput2_record_number,
     +  s_scinput2_secondary_id,s_scinput2_station_name,
     +  s_scinput2_longitude,s_scinput2_latitude,
     +  s_scinput2_elevation_m,s_scinput2_policy_license,
     +  s_scinput2_source_id,
     +  l_rgh_metadata,l_metadata,
     +  s_metadata_platformid,s_metadata_networktype,
     +  s_metadata_name,s_metadata_st,s_metadata_co,
     +  s_metadata_lat,s_metadata_lon,s_metadata_elev,
     +  s_metadata_eq_cdmlandcode)

      IMPLICIT NONE
c************************************************************************
c     Variables passed into subroutine
      CHARACTER(LEN=8)    :: s_date_st
      CHARACTER(LEN=10)   :: s_time_st

      REAL                :: f_ndflag
      DOUBLE PRECISION    :: d_ndflag

      CHARACTER(LEN=300)  :: s_dir_usaf_filelist
      CHARACTER(LEN=300)  :: s_dir_outfile_iff_fileaccept
      CHARACTER(LEN=300)  :: s_dir_outfile_iff_netplatdistinct
      CHARACTER(LEN=300)  :: s_dir_outfile_iff_netplatdistinct2

      CHARACTER(LEN=300)  :: s_dir_outfile_yearstats
      CHARACTER(LEN=300)  :: s_dir_outfile_yearstats_sift
      CHARACTER(LEN=300)  :: s_dir_outfile_lastfile

      INTEGER             :: l_stnlist_rgh
      INTEGER             :: l_stnlist
      CHARACTER(LEN=30)   :: s_vec_stnlist(l_stnlist_rgh) 
c*****
      INTEGER             :: l_scinput_rgh
      INTEGER             :: l_scinput
      CHARACTER(LEN=20)   :: s_scinput_primary_id(l_scinput_rgh)
      CHARACTER(LEN=2)    :: s_scinput_record_number(l_scinput_rgh)
      CHARACTER(LEN=20)   :: s_scinput_secondary_id(l_scinput_rgh)
      CHARACTER(LEN=50)   :: s_scinput_station_name(l_scinput_rgh)
      CHARACTER(LEN=10)   :: s_scinput_longitude(l_scinput_rgh)
      CHARACTER(LEN=10)   :: s_scinput_latitude(l_scinput_rgh)
      CHARACTER(LEN=10)   :: s_scinput_elevation_m(l_scinput_rgh)
      CHARACTER(LEN=1)    :: s_scinput_policy_license(l_scinput_rgh)
      CHARACTER(LEN=3)    :: s_scinput_source_id(l_scinput_rgh)
c*****
      INTEGER             :: l_scoutput_rgh
      INTEGER             :: l_scoutput
      CHARACTER(LEN=20)   :: s_scinput2_primary_id(l_scoutput_rgh)
      CHARACTER(LEN=2)    :: s_scinput2_record_number(l_scoutput_rgh)
      CHARACTER(LEN=20)   :: s_scinput2_secondary_id(l_scoutput_rgh)
      CHARACTER(LEN=50)   :: s_scinput2_station_name(l_scoutput_rgh)
      CHARACTER(LEN=10)   :: s_scinput2_longitude(l_scoutput_rgh)
      CHARACTER(LEN=10)   :: s_scinput2_latitude(l_scoutput_rgh)
      CHARACTER(LEN=10)   :: s_scinput2_elevation_m(l_scoutput_rgh)
      CHARACTER(LEN=1)    :: s_scinput2_policy_license(l_scoutput_rgh)
      CHARACTER(LEN=3)    :: s_scinput2_source_id(l_scoutput_rgh)
c*****
c     Metadata variables
      INTEGER             :: l_rgh_metadata
      INTEGER             :: l_metadata
      CHARACTER(LEN=30)   :: s_metadata_platformid(l_rgh_metadata)
      CHARACTER(LEN=30)   :: s_metadata_networktype(l_rgh_metadata)
      CHARACTER(LEN=100)  :: s_metadata_name(l_rgh_metadata)
      CHARACTER(LEN=15)   :: s_metadata_st(l_rgh_metadata)
      CHARACTER(LEN=15)   :: s_metadata_co(l_rgh_metadata)
      CHARACTER(LEN=15)   :: s_metadata_lat(l_rgh_metadata)
      CHARACTER(LEN=15)   :: s_metadata_lon(l_rgh_metadata)
      CHARACTER(LEN=15)   :: s_metadata_elev(l_rgh_metadata)

      CHARACTER(LEN=15)   :: s_metadata_eq_cdmlandcode(l_rgh_metadata)
c*****
c     Variables used within subroutine

      INTEGER             :: i,j,k,ii,jj,kk
      INTEGER             :: io

      CHARACTER(LEN=30)   :: s_name_single
      CHARACTER(LEN=30)   :: s_networktype
      CHARACTER(LEN=30)   :: s_platformid
      CHARACTER(LEN=30)   :: s_netplat_use

c     Station config1 info
      CHARACTER(LEN=20)   :: s_scsingle_primary_id
      CHARACTER(LEN=50)   :: s_scsingle_station_name
      CHARACTER(LEN=10)   :: s_scsingle_longitude
      CHARACTER(LEN=10)   :: s_scsingle_latitude
      CHARACTER(LEN=10)   :: s_scsingle_elevation_m

      CHARACTER(LEN=20)   :: s_scsingle2_primary_id
      CHARACTER(LEN=50)   :: s_scsingle2_station_name
      CHARACTER(LEN=10)   :: s_scsingle2_longitude
      CHARACTER(LEN=10)   :: s_scsingle2_latitude
      CHARACTER(LEN=10)   :: s_scsingle2_elevation_m

      INTEGER             :: l_occur1,l_occur2
c*****
      INTEGER             :: i_linelength_min
      INTEGER             :: i_linelength_max
      INTEGER             :: i_commacnt_min
      INTEGER             :: i_commacnt_max

      INTEGER             :: l_data

      INTEGER,PARAMETER   :: l_c1=10   !normal geophys data   (10)
      INTEGER,PARAMETER   :: l_c2=1    !quality control       (1)

      INTEGER, PARAMETER  :: l_rgh_datalines=4000000
      INTEGER, PARAMETER  :: l_rgh_char=4000

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

      REAL                :: f_vec_latitude(l_rgh_datalines)
      REAL                :: f_vec_longitude(l_rgh_datalines)
      REAL                :: f_vec_platformheight(l_rgh_datalines)
      REAL                :: f_vec_winddirection_deg(l_rgh_datalines)
      REAL                :: f_vec_windspeed_ms(l_rgh_datalines)
      REAL                :: f_vec_sealevelpressure_hpa(l_rgh_datalines)
      REAL                :: f_vec_stationpressure_hpa(l_rgh_datalines)

      INTEGER             :: i_vec_triplet_index(l_rgh_datalines)

c     Time processor
      DOUBLE PRECISION    :: d_vec_jtime(l_rgh_datalines)
      CHARACTER(LEN=10)   :: s_vec_date_dd_mm_yyyy(l_rgh_datalines) 
      CHARACTER(LEN=8)    :: s_vec_time_hh_mm_ss(l_rgh_datalines)

c     Metadata variables
      CHARACTER(LEN=30)   :: s_metasingle_platformid
      CHARACTER(LEN=30)   :: s_metasingle_networktype
      CHARACTER(LEN=100)  :: s_metasingle_name
      CHARACTER(LEN=15)   :: s_metasingle_st
      CHARACTER(LEN=15)   :: s_metasingle_co
      CHARACTER(LEN=15)   :: s_metasingle_lat
      CHARACTER(LEN=15)   :: s_metasingle_lon
      CHARACTER(LEN=15)   :: s_metasingle_elev

      CHARACTER(LEN=15)   :: s_metasingle_cdmlandcode

      CHARACTER(LEN=300)  :: s_filename

      CHARACTER(LEN=20)   :: s_last_netplat
      INTEGER             :: i_lastindex
      INTEGER             :: i_start

      INTEGER             :: i_0good_1bad_2zero
      INTEGER             :: i_cnt_good
c************************************************************************
      print*,'just entered process_files_prelim'

c      print*,'s_vec_stnlist=',(TRIM(s_vec_stnlist(i)),i=1,20)

      print*,'s_scinput_primary_id,1=',
     +  (TRIM(s_scinput_primary_id(i)),i=1,20)
      print*,'s_scinput_primary_id,2=',
     +  (TRIM(s_scinput2_primary_id(i)),i=1,20)
c*****
c     Readin last index
      CALL readin_lastfile_index(s_dir_outfile_lastfile,
     +  s_last_netplat,i_lastindex,i_start)

c      print*,'s_last_netplat=',TRIM(s_last_netplat)
c      print*,'i_lastindex=',i_lastindex
c      print*,'i_start=',i_start
c      STOP 'process_files_prelim'
c*****
c     Cycle through station list
      i_cnt_good=0

      DO i=i_start,l_stnlist
       print*,'i...',i,TRIM(s_vec_stnlist(i))
  
c      Get networktype & platformid for single station
       s_name_single=s_vec_stnlist(i)
       CALL get_netplat(s_name_single,
     +  s_networktype,s_platformid)

       print*,'s_networktype,s_platformid=',
     +   TRIM(s_networktype)//'-'//TRIM(s_platformid)

       IF (TRIM(s_networktype).EQ.'WMO'.OR.
     +     TRIM(s_networktype).EQ.'ICAO'.OR.
     +     TRIM(s_networktype).EQ.'AFWA') THEN

c      Get station configuration info for single station
c      NOTE: using station config file as selection criterion
       s_netplat_use=TRIM(s_networktype)//'_'//TRIM(s_platformid)
       CALL get_stnconfig_singlestn2(s_netplat_use,
     +  l_scinput_rgh,l_scinput,
     +  s_scinput_primary_id,s_scinput_station_name,
     +  s_scinput_longitude,s_scinput_latitude,s_scinput_elevation_m,

     +  s_scsingle_primary_id,s_scsingle_station_name,
     +  s_scsingle_longitude,s_scsingle_latitude,s_scsingle_elevation_m,
     +  l_occur1)

c       CALL get_stnconfig_singlestn2(s_netplat_use,
c     +  l_scoutput_rgh,l_scoutput,
c     +  s_scinput2_primary_id,s_scinput2_station_name,
c     +  s_scinput2_longitude,s_scinput2_latitude,s_scinput2_elevation_m,

c     +  s_scsingle2_primary_id,s_scsingle2_station_name,
c     +  s_scsingle2_longitude,s_scsingle2_latitude,
c     +  s_scsingle2_elevation_m,
c     +  l_occur2)

c      Get station metadata for single station
       CALL get_metadata_singlestn(s_networktype,s_platformid,
     +  l_rgh_metadata,l_metadata,
     +  s_metadata_platformid,s_metadata_networktype,
     +  s_metadata_name,s_metadata_st,s_metadata_co,
     +  s_metadata_lat,s_metadata_lon,s_metadata_elev,
     +  s_metadata_eq_cdmlandcode,

     +  s_metasingle_platformid,s_metasingle_networktype,
     +  s_metasingle_name,s_metasingle_st,s_metasingle_co,
     +  s_metasingle_lat,s_metasingle_lon,s_metasingle_elev,
     +  s_metasingle_cdmlandcode)

c       IF (l_occur1.GT.1) THEN 
c        print*,'l_occur1/2=',l_occur1,l_occur2
c        STOP 'process_files_prelim'
c       ENDIF

c      call subroutine to get data strings & float conversions
       CALL process_single_file5(
     +   s_dir_usaf_filelist,s_vec_stnlist(i),
     +   f_ndflag,
     +   l_rgh_datalines,l_rgh_char,
     +   i_linelength_min,i_linelength_max,
     +   i_commacnt_min,i_commacnt_max,

     +   l_data,l_c1,l_c2,
     +   s_vec_platformid,s_vec_networktype,
     +   s_vec_ncdc_ob_time,s_vec_reporttypecode,
     +   s_vec_latitude,s_vec_longitude,s_vec_platformheight,
     +   s_vec_winddirection_deg,s_vec_winddirection_qc,
     +   s_vec_windspeed_ms,s_vec_windspeed_qc,
     +   s_vec_airtemperature_c,s_vec_airtemperature_qc,
     +   s_vec_dewpointtemperature_c,s_vec_dewpointtemperature_qc,
     +   s_vec_sealevelpressure_hpa,s_vec_sealevelpressure_qc,
     +   s_vec_stationpressure_hpa,s_vec_stationpressure_qc,
     +   f_vec_latitude,f_vec_longitude,f_vec_platformheight,
     +   f_vec_windspeed_ms,
     +   f_vec_sealevelpressure_hpa,f_vec_stationpressure_hpa)

c      Call subroutine to run time_processor
       CALL time_processor(l_rgh_datalines,l_data,s_vec_ncdc_ob_time,
     +   d_vec_jtime,s_vec_date_dd_mm_yyyy,s_vec_time_hh_mm_ss)
 
c      this subroutine outputs info except for data-length vector of reportid
       CALL iff_processes(s_date_st,s_time_st,
     +   f_ndflag,d_ndflag,s_networktype,s_platformid,
     +   s_dir_outfile_iff_fileaccept,
     +   s_dir_outfile_iff_netplatdistinct,
     +   s_dir_outfile_iff_netplatdistinct2,
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

        IF (i_0good_1bad_2zero.EQ.0) THEN 
         i_cnt_good=i_cnt_good+1
         print*,'i_cnt_good=',i_cnt_good
        ENDIF

       ENDIF   !close condition to process afwa, icao, wmo stations

c      Call subroutine to find max wspd in each year
       CALL find_max_year_wspd4(f_ndflag,
     +  s_dir_outfile_yearstats,
     +  s_dir_outfile_yearstats_sift,
     +  s_vec_networktype(1),s_vec_platformid(1),
     +  l_rgh_datalines,l_data,
     +  d_vec_jtime,s_vec_date_dd_mm_yyyy,s_vec_time_hh_mm_ss,
     +  f_vec_windspeed_ms,
     +  i_vec_triplet_index,
     +  s_metasingle_platformid,s_metasingle_networktype,
     +  s_metasingle_name,s_metasingle_st,s_metasingle_co,
     +  s_metasingle_lat,s_metasingle_lon,s_metasingle_elev)

c       STOP 'process_files_prelim'

c       CALL SLEEP(1)

c      SEQUENTIAL PROCESS: Write out last file index
c      (in case program crashes, this defines starting point)
        s_filename='lastfile.dat'
        CALL export_last_index(s_dir_outfile_lastfile,
     +   s_filename,s_networktype,s_platformid,i)

      ENDDO
c*****

      print*,'just leaving process_files_prelim'

      RETURN
      END
