c     Subroutine to get lines from triplet files & assemble SN stnconfig
c     AJ_Kettle, 09Sept2019
c     27Mar2020: modified for USAF update

      SUBROUTINE get_lines_append_stnconfig2(
     +  s_date_st,s_time_st,s_zone_st,
     +  s_dir_outfile_iff_netplatdistinct,
     +  s_dir_assemble,
     +  l_stn_rgh,
     +  l_stn,s_filelist)

      IMPLICIT NONE
c************************************************************************
c     Declare variables 

      CHARACTER(LEN=8)    :: s_date_st
      CHARACTER(LEN=10)   :: s_time_st
      CHARACTER(LEN=5)    :: s_zone_st

      CHARACTER(LEN=300)  :: s_dir_outfile_iff_netplatdistinct
      CHARACTER(LEN=300)  :: s_dir_assemble

      INTEGER             :: l_stn_rgh
      INTEGER             :: l_stn

      CHARACTER(LEN=300)  :: s_filelist(l_stn_rgh)
c*****
c     Variables used in subroutine
  
      INTEGER             :: i,j,k,ii,jj,kk

      INTEGER             :: l_cnt_triplet
      INTEGER,PARAMETER   :: l_cnt_rgh=30000
      CHARACTER(LEN=15)   :: s_networktype_single
      CHARACTER(LEN=15)   :: s_platformid_single
      CHARACTER(LEN=2)    :: s_vec_index(l_cnt_rgh)
      CHARACTER(LEN=9)    :: s_vec_latitude(l_cnt_rgh)
      CHARACTER(LEN=9)    :: s_vec_longitude(l_cnt_rgh)
      CHARACTER(LEN=9)    :: s_vec_height(l_cnt_rgh)
      CHARACTER(LEN=7)    :: s_vec_wdir_cnt(l_cnt_rgh)
      CHARACTER(LEN=7)    :: s_vec_wspd_cnt(l_cnt_rgh)
      CHARACTER(LEN=7)    :: s_vec_airt_cnt(l_cnt_rgh)
      CHARACTER(LEN=7)    :: s_vec_dewp_cnt(l_cnt_rgh)
      CHARACTER(LEN=7)    :: s_vec_slp_cnt(l_cnt_rgh)
      CHARACTER(LEN=7)    :: s_vec_stnp_cnt(l_cnt_rgh)

      CHARACTER(LEN=100)  :: s_metasingle_name
      CHARACTER(LEN=15)   :: s_metasingle_cdmlandcode

      CHARACTER(LEN=4)    :: s_vec_year_st(l_cnt_rgh)
      CHARACTER(LEN=4)    :: s_vec_year_en(l_cnt_rgh)
      CHARACTER(LEN=25)   :: s_vec_assemble_varcode(l_cnt_rgh)

      CHARACTER(LEN=300)  :: s_filename

      REAL                :: f_min_lon,f_max_lon,f_min_lat,f_max_lat
c************************************************************************
      print*,'just entered get_lines_append_stnconfig2'

      print*,'s_dir_outfile_iff_netplatdistinct=',
     +  TRIM(s_dir_outfile_iff_netplatdistinct)

      print*,'l_stn=', l_stn
c*****
c     Cycle through station files
      s_filename='stnconfig_auxil_info.dat'
      
      f_min_lon=+1000.0
      f_max_lon=-1000.0
      f_min_lat=+1000.0
      f_max_lat=-1000.0
 
      DO i=1,l_stn

       print*,'stn acc;i=',i

c      Get data from single file
       CALL get_triplet_data_single_file4(
     +   s_dir_outfile_iff_netplatdistinct,s_filelist(i),
     +   l_cnt_rgh,l_cnt_triplet,
     +   s_networktype_single,s_platformid_single,
     +   s_vec_index,
     +   s_vec_latitude,s_vec_longitude,s_vec_height,
     +   s_vec_wdir_cnt,s_vec_wspd_cnt,
     +   s_vec_airt_cnt,s_vec_dewp_cnt,
     +   s_vec_slp_cnt,s_vec_stnp_cnt,
     +   s_metasingle_name,s_metasingle_cdmlandcode,
     +   s_vec_year_st,s_vec_year_en,s_vec_assemble_varcode)

c       print*,'net-plat=',
c     +   TRIM(s_networktype_single)//'-'//TRIM(s_platformid_single)

c      Check running range latitude & longitude
       CALL check_running_latlon(
     +   f_min_lon,f_max_lon,f_min_lat,f_max_lat,
     +   l_cnt_rgh,l_cnt_triplet,s_vec_latitude,s_vec_longitude)

c       STOP 'get_lines_append_stnconfig'

c      Append data to export file
       CALL assemble_triplet_lines_stnconfig2(
     +   s_date_st,s_time_st,s_zone_st,
     +   s_dir_assemble,s_filename,
     +   l_cnt_rgh,l_cnt_triplet,
     +   s_networktype_single,s_platformid_single,
     +   s_vec_index,
     +   s_vec_latitude,s_vec_longitude,s_vec_height,
     +   s_metasingle_name,s_metasingle_cdmlandcode,
     +   s_vec_year_st,s_vec_year_en,s_vec_assemble_varcode)

      ENDDO
c************************************************************************
      print*,'just leaving get_lines_append_stnconfig2'

      RETURN
      END
