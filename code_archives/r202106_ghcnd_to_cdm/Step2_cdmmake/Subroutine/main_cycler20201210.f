c     Subroutine to process daily files
c     AJ_Kettle, 14Apr2020

      SUBROUTINE main_cycler20201210(f_ndflag,
     +  s_date_st,s_time_st,s_zone_st,i_values_st,
     +  s_directory_ghcnd_input,
     +  s_directory_output_lastfile,s_directory_output_receipt,
     +  s_directory_output_errorfile,
     +  s_directory_output_header,s_directory_output_observation,
     +  s_directory_output_lite,
     +  s_directory_output_qc,s_directory_output_receipt_linecount,
     +  l_source_rgh,l_source,
     +  s_source_name,s_source_codeletter,s_source_codenumber,
     +  l_stations_rgh,l_subset,s_stnname,
     +  l_scoutput_rgh,l_scoutput,l_scfield,
     +  l_scoutput_numfield,s_scoutput_vec_header,
     +  s_scoutput_mat_fields,
     +  s_qckey_timescale_spec,l_qckey,
     +  s_qckey_sourceflag,s_qckey_c3sflag,s_qckey_timescale)

      IMPLICIT NONE
c************************************************************************
c     Variables passed into subroutine

      REAL                :: f_ndflag

      CHARACTER(LEN=8)    :: s_date_st
      CHARACTER(LEN=10)   :: s_time_st
      CHARACTER(LEN=5)    :: s_zone_st
      INTEGER             :: i_values_st(8)

      CHARACTER(LEN=300)  :: s_directory_ghcnd_input

      CHARACTER(LEN=300)  :: s_directory_output_lastfile
      CHARACTER(LEN=300)  :: s_directory_output_header
      CHARACTER(LEN=300)  :: s_directory_output_observation
      CHARACTER(LEN=300)  :: s_directory_output_lite
      CHARACTER(LEN=300)  :: s_directory_output_receipt
      CHARACTER(LEN=300)  :: s_directory_output_errorfile
      CHARACTER(LEN=300)  :: s_directory_output_qc
      CHARACTER(LEN=300)  :: s_directory_output_receipt_linecount
c*****
      INTEGER             :: l_source_rgh
      INTEGER             :: l_source
      CHARACTER(LEN=500)  :: s_source_name(l_source_rgh)
      CHARACTER(LEN=1)    :: s_source_codeletter(l_source_rgh)
      CHARACTER(LEN=3)    :: s_source_codenumber(l_source_rgh)
c*****
c     Station subset information
      INTEGER             :: l_stations_rgh
      CHARACTER(LEN=12)   :: s_stnname(l_stations_rgh)
      INTEGER             :: l_subset
c*****
      INTEGER             :: l_scoutput_rgh
      INTEGER             :: l_scoutput
      INTEGER             :: l_scfield
      CHARACTER(LEN=1000) :: s_header
      INTEGER             :: l_scoutput_numfield
      CHARACTER(LEN=l_scfield)::s_scoutput_vec_header(50)
      CHARACTER(LEN=l_scfield)::s_scoutput_mat_fields(l_scoutput_rgh,50)
c*****
      CHARACTER(LEN=300)  :: s_qckey_timescale_spec
      INTEGER             :: l_qckey
      CHARACTER(LEN=2)    :: s_qckey_sourceflag(100)
      CHARACTER(LEN=2)    :: s_qckey_c3sflag(100)
      CHARACTER(LEN=300)  :: s_qckey_timescale(100) 
c***********************************************
c     Variables used within subroutine

      INTEGER             :: i,j,k,ii,jj,kk

      INTEGER             :: i_good
      INTEGER             :: i_bad
      INTEGER             :: ii_cnt_skip1
      INTEGER             :: ii_cnt_skip2

      INTEGER             :: i_flag_skip

      INTEGER             :: i_start

      CHARACTER(LEN=300)  :: s_filename
      CHARACTER(LEN=12)   :: s_stnname_single
c*****
      INTEGER             :: l_collect_cnt

c     Variables originally from stnconfig-read
      CHARACTER(LEN=l_scfield) :: s_collect_primary_id(20)     !20
      CHARACTER(LEN=l_scfield) :: s_collect_record_number(20)  !2
      CHARACTER(LEN=l_scfield) :: s_collect_secondary_id(20)   !20
      CHARACTER(LEN=l_scfield) :: s_collect_station_name(20)   !50
      CHARACTER(LEN=l_scfield) :: s_collect_longitude(20)      !10
      CHARACTER(LEN=l_scfield) :: s_collect_latitude(20)       !10
      CHARACTER(LEN=l_scfield) :: 
     +  s_collect_height_station_above_sea_level(20) !10
      CHARACTER(LEN=l_scfield) :: s_collect_policy_licence(20) !1
      CHARACTER(LEN=l_scfield) :: s_collect_source_id(20)      !3

c     Variables originally from stnconfig-write
      CHARACTER(LEN=l_scfield) :: s_collect_region(20)
      CHARACTER(LEN=l_scfield) :: s_collect_operating_territory(20)
      CHARACTER(LEN=l_scfield) :: s_collect_station_type(20)
      CHARACTER(LEN=l_scfield) :: s_collect_platform_type(20)
      CHARACTER(LEN=l_scfield) :: s_collect_platform_sub_type(20)
      CHARACTER(LEN=l_scfield) ::s_collect_primary_station_id_scheme(20)
      CHARACTER(LEN=l_scfield) :: s_collect_location_accuracy(20)
      CHARACTER(LEN=l_scfield) :: s_collect_location_method(20)
      CHARACTER(LEN=l_scfield) :: s_collect_location_quality(20)
      CHARACTER(LEN=l_scfield) :: s_collect_station_crs(20)
      CHARACTER(LEN=l_scfield) ::
     +    s_collect_height_station_above_local_ground(20)
      CHARACTER(LEN=l_scfield) ::
     +    s_collect_height_station_above_sea_level_acc(20)
      CHARACTER(LEN=l_scfield) :: s_collect_sea_level_datum(20)

c     Archives up to 50 column & 20 lines from stnconfig-write file
      CHARACTER(LEN=l_scfield) :: s_collect_datalines(20,50)

      INTEGER             :: l_collect_distinct
      CHARACTER(LEN=1)    :: s_collect_flagambig(20)
c*****
      CHARACTER(LEN=3)    :: s_filestatus1
c*****
      CHARACTER(LEN=300)  :: s_file_error
c************************************************************************
      print*,'just entered main_cycler20201210'

c      print*,'l_qckey=',l_qckey
c      print*,'s_qckey_timescale_spec=',TRIM(s_qckey_timescale_spec)

c      DO i=1,l_qckey
c       print*,'qc',i,s_qckey_sourceflag(i),s_qckey_c3sflag(i),
c     +   TRIM(s_qckey_timescale(i))
c      ENDDO

c      STOP 'main_cycler20201210'
c************************************************************************
c     Read in last file number
      CALL readin_lastfile_number(s_directory_output_lastfile,
     +  i_start)

      print*,'i_start=',i_start,l_subset
c      STOP 'main_cycler20201210'
c************************************************************************
      ii=0
      i_good=0
      i_bad =0
      ii_cnt_skip1=0
      ii_cnt_skip2=0

      i_flag_skip=0

      DO i=i_start,l_subset   !i_start,l_subset !i_start,l_subset   !i_start,l_subset
       IF (MOD(i,1000).EQ.0) THEN 
        print*,'i,ii=',i,ii,ii_cnt_skip1,ii_cnt_skip2
       ENDIF

c      09Mar2021: changed extension of NCEI station files
       s_filename=TRIM(s_stnname(i))//'.csv'
c       s_filename=TRIM(s_stnname(i))//'.dat'
       s_stnname_single=s_stnname(i) 
 
       print*,'i=',i,TRIM(s_filename),s_stnname_single

c      Get info from stn_config file
       CALL get_singles_stnconfig_v5(s_stnname_single,
     +  l_scoutput_rgh,l_scoutput,l_scfield,l_scoutput_numfield,
     +  s_scoutput_vec_header,s_scoutput_mat_fields,

     +  l_collect_cnt,
     +  s_collect_primary_id,s_collect_record_number,
     +  s_collect_secondary_id,s_collect_station_name,
     +  s_collect_longitude,s_collect_latitude,
     +  s_collect_height_station_above_sea_level,
     +  s_collect_policy_licence,s_collect_source_id,

     +  s_collect_region,s_collect_operating_territory,
     +  s_collect_station_type,s_collect_platform_type,
     +  s_collect_platform_sub_type,s_collect_primary_station_id_scheme,
     +  s_collect_location_accuracy,s_collect_location_method,
     +  s_collect_location_quality,s_collect_station_crs,
     +  s_collect_height_station_above_local_ground,
     +  s_collect_height_station_above_sea_level_acc,
     +  s_collect_sea_level_datum,

     +  s_collect_datalines,

     +  l_collect_distinct,
     +  s_collect_flagambig)

c       print*,'l_collect_cnt=',l_collect_cnt
c       print*,'s_collect_primary_id=',
c     +   (s_collect_primary_id(j),j=1,l_collect_cnt)
c       print*,'s_collect_source_id=',
c     +   (s_collect_source_id(j),j=1,l_collect_cnt)
c       print*,'s_collect_record_number=',
c     +   (s_collect_record_number(j),j=1,l_collect_cnt)

c       l_collect_cnt=0

c      Skip analysis if l_collect_cnt=0; not stnconfig information
       IF (l_collect_cnt.EQ.0) THEN
        s_file_error='errorfile_stnconfig.dat'
        CALL export_errorfile(
     +    s_directory_output_errorfile,s_file_error,s_stnname(i))
 
        ii_cnt_skip1=ii_cnt_skip1+1
        GOTO 100
       ENDIF

c      Get vectors of data & output CDM file
c      10Dec2020: modification to pass through qc information
       CALL input_output_single_station20201210(f_ndflag,
     +    s_date_st,s_time_st,s_zone_st,
     +    s_directory_ghcnd_input,
     +    s_directory_output_header,s_directory_output_observation,
     +    s_directory_output_lite,
     +    s_directory_output_receipt,
     +    s_directory_output_qc,s_directory_output_receipt_linecount,
     +    s_filename,s_stnname_single,
     +    l_source_rgh,l_source,
     +    s_source_name,s_source_codeletter,s_source_codenumber,
     +    l_collect_cnt,
     +    s_collect_primary_id,s_collect_record_number,
     +    s_collect_secondary_id,s_collect_station_name,
     +    s_collect_longitude,s_collect_latitude,
     +    s_collect_height_station_above_sea_level,
     +    s_collect_policy_licence,s_collect_source_id,

     +  s_collect_region,s_collect_operating_territory,
     +  s_collect_station_type,s_collect_platform_type,
     +  s_collect_platform_sub_type,s_collect_primary_station_id_scheme,
     +  s_collect_location_accuracy,s_collect_location_method,
     +  s_collect_location_quality,s_collect_station_crs,
     +  s_collect_height_station_above_local_ground,
     +  s_collect_height_station_above_sea_level_acc,
     +  s_collect_sea_level_datum,

     +  s_collect_datalines,s_scoutput_vec_header,l_scoutput_numfield,

     +    l_collect_distinct,
     +    s_collect_flagambig,

     +    s_filestatus1,i_flag_skip,
     +  s_qckey_timescale_spec,l_qckey,
     +  s_qckey_sourceflag,s_qckey_c3sflag,s_qckey_timescale)

       ii=ii+1

       IF (i_flag_skip.EQ.1) THEN

        s_file_error='errorfile_recordnumber.dat'
        CALL export_errorfile(
     +    s_directory_output_errorfile,s_file_error,s_stnname(i))

        ii_cnt_skip2=ii_cnt_skip2+1
       ENDIF

 100   CONTINUE

c      Export index of finished file
       CALL export_last_index(s_directory_output_lastfile,i,ii,
     +   ii_cnt_skip1,ii_cnt_skip2,i_values_st)

       print*,'interim i_flag_skip=',i_flag_skip

      ENDDO

      print*,'i_flag_skip=',i_flag_skip
      print*,'ii_cnt_skip1,ii_cnt_skip2=',ii_cnt_skip1,ii_cnt_skip2
c************************************************************************

      print*,'just leaving main_cycler'

      RETURN
      END
