c     Subroutine to make single IFF file
c     AJ_Kettle, 28Jun2018
c     06Aug2019: modified index of i_triple_datacnt_good from 20 to l_rgh_datalines
c     18Mar2020: used for USAF update

      SUBROUTINE make_iff_file_singlevar(i_0good_1bad_2zero,
     +   s_directory_outfile_iff_use,
     +   s_networktype,s_platformid,
     +   s_paramname,s_paramunit,
     +   s_metasingle_name,
     +   l_c1,l_c2,l_rgh_datalines,l_data,
     +   s_vec_platformid,s_vec_networktype,
     +   s_vec_ncdc_ob_time,s_vec_reporttypecode,
     +   s_vec_latitude,s_vec_longitude,s_vec_platformheight,
     +   s_vec_windspeed_ms,s_vec_windspeed_qc,
     +   s_vec_date_dd_mm_yyyy,s_vec_time_hh_mm_ss,
     +   i_vec_triplet_index,
     +   i_triplediff_cnt,i_triple_datacnt_good,
     +   s_st_date_dd_mm_yyyy,s_st_time_hh_mm_ss,
     +   s_en_date_dd_mm_yyyy,s_en_time_hh_mm_ss)

      IMPLICIT NONE
c************************************************************************
c     Declare variables 

      INTEGER             :: i_0good_1bad_2zero

      CHARACTER(LEN=300)  :: s_directory_outfile_iff_use
      CHARACTER(LEN=300)  :: s_directory_outfile_iff_netplatdistinct

      CHARACTER(LEN=300)  :: s_fileuse
      CHARACTER(LEN=30)   :: s_networktype
      CHARACTER(LEN=30)   :: s_platformid

      CHARACTER(LEN=50)   :: s_paramname
      CHARACTER(LEN=50)   :: s_paramunit

      CHARACTER(LEN=100)  :: s_metasingle_name

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

      CHARACTER(LEN=l_c1) :: s_vec_windspeed_ms(l_rgh_datalines)
      CHARACTER(LEN=l_c2) :: s_vec_windspeed_qc(l_rgh_datalines)

      CHARACTER(LEN=10)   :: s_vec_date_dd_mm_yyyy(l_rgh_datalines) 
      CHARACTER(LEN=8)    :: s_vec_time_hh_mm_ss(l_rgh_datalines)

      INTEGER             :: i_vec_triplet_index(l_rgh_datalines)
      INTEGER             :: i_triplediff_cnt
      INTEGER             :: i_triple_datacnt_good(l_rgh_datalines) !(20)

      CHARACTER(LEN=10)   :: s_st_date_dd_mm_yyyy 
      CHARACTER(LEN=8)    :: s_st_time_hh_mm_ss
      CHARACTER(LEN=10)   :: s_en_date_dd_mm_yyyy 
      CHARACTER(LEN=8)    :: s_en_time_hh_mm_ss
c*****
c     Variables used within subroutine

      INTEGER             :: i,j,k,ii,jj,kk

      CHARACTER(LEN=100)  :: s_vec_iffparams(19)

      CHARACTER(LEN=100)  :: s_source_id                   !1
      CHARACTER(LEN=100)  :: s_station_id                  !2
      CHARACTER(LEN=100)  :: s_name                        !3  
      CHARACTER(LEN=100)  :: s_alias_station_name          !4
      CHARACTER(LEN=100)  :: s_year                        !5
      CHARACTER(LEN=100)  :: s_month                       !6
      CHARACTER(LEN=100)  :: s_day                         !7
      CHARACTER(LEN=100)  :: s_hour                        !8
      CHARACTER(LEN=100)  :: s_minute                      !9
      CHARACTER(LEN=100)  :: s_latitude                    !10
      CHARACTER(LEN=100)  :: s_longitude                   !11
      CHARACTER(LEN=100)  :: s_elevation                   !12
      CHARACTER(LEN=100)  :: s_observed_value              !13
      CHARACTER(LEN=100)  :: s_source_qc_flag              !14
      CHARACTER(LEN=100)  :: s_original_observed           !15
      CHARACTER(LEN=100)  :: s_original_observed_units     !16
      CHARACTER(LEN=100)  :: s_report_type_code            !17
      CHARACTER(LEN=100)  :: s_gravity_corrected_by_source !18
      CHARACTER(LEN=100)  :: s_homogenization              !19

      INTEGER             :: ii_good,ii_bad

c************************************************************************
c      print*,'just entered make_iff_file_singlevar'

c      print*,'i_triplediff_cnt=',i_triplediff_cnt
c      print*,'s_vec_windspeed_ms',(s_vec_windspeed_ms(i),i=1,10)

c     Cycle through all triplet elements
      DO i=1,i_triplediff_cnt

c      Find number of good points
       CALL find_number_good(i,
     +   l_rgh_datalines,l_data,l_c1,
     +   i_vec_triplet_index,s_vec_windspeed_ms,
     +   ii_good,ii_bad)

c      Archive counts of good data for each triplet
       i_triple_datacnt_good(i)=ii_good

c       print*,'ii_good=',ii_good

c      Export data if ii_good>0
       IF (ii_good.GT.0) THEN 

c       Call subroutine to export 1 file
        CALL iff_write_file(i,i_0good_1bad_2zero,
     +   s_directory_outfile_iff_use,s_networktype,s_platformid,
     +   s_paramname,s_paramunit,
     +   s_metasingle_name,
     +   l_c1,l_c2,l_rgh_datalines,l_data,
     +   s_vec_platformid,s_vec_networktype,
     +   s_vec_ncdc_ob_time,s_vec_reporttypecode,
     +   s_vec_latitude,s_vec_longitude,s_vec_platformheight,
     +   s_vec_windspeed_ms,s_vec_windspeed_qc,
     +   s_vec_date_dd_mm_yyyy,s_vec_time_hh_mm_ss,
     +   i_vec_triplet_index,
     +   i_triplediff_cnt,
     +   s_st_date_dd_mm_yyyy,s_st_time_hh_mm_ss,
     +   s_en_date_dd_mm_yyyy,s_en_time_hh_mm_ss)

       ENDIF

      ENDDO

c      print*,'just leaving make_iff_file_singlevar'

      RETURN
      END
