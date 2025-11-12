c     Subroutine to get lines from triplet files & assemble SN stnconfig
c     AJ_Kettle, 09Sept2019
c     27Mar2020: modified for USAF update

      SUBROUTINE get_lines_append_stnconfig_new(
     +  s_date_st,s_time_st,s_zone_st,
     +  s_dir_outfile_iff_netplatdistinct,
     +  s_dir_assemble,
     +  l_stn_rgh,
     +  l_stn,s_filelist,
     +  l_iffuniq,s_vec_iffuniq_netplat)

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

      INTEGER             :: l_iffuniq
      CHARACTER(LEN=*)    :: s_vec_iffuniq_netplat(l_stn_rgh) !32
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

      CHARACTER(LEN=32)   :: s_net_rec
      CHARACTER(LEN=32)   :: s_plat_rec 
      CHARACTER(LEN=32)   :: s_net_file
      CHARACTER(LEN=32)   :: s_plat_file 

      CHARACTER(LEN=32)   :: s_single_filelist
      CHARACTER(LEN=300)  :: s_single_receipt
      INTEGER             :: i_len

      REAL                :: f_min_lon,f_max_lon,f_min_lat,f_max_lat

      INTEGER             :: i_testgood
      INTEGER             :: i_cnt_pos
      INTEGER             :: j_use
c************************************************************************
      print*,'just entered get_lines_append_stnconfig2'

      print*,'s_dir_outfile_iff_netplatdistinct=',
     +  TRIM(s_dir_outfile_iff_netplatdistinct)

      print*,'l_stn=', l_stn

      print*,'s_filelist=',TRIM(s_filelist(1))

      print*,'l_iffuniq',l_iffuniq
      print*,'s_vec_iffuniq_netplat',TRIM(s_vec_iffuniq_netplat(1))

c      STOP 'get_lines_append_stnconfig20210604'
c*****
c     Cycle through station files
      s_filename='stnconfig_auxil_info.dat'
      
      f_min_lon=+1000.0
      f_max_lon=-1000.0
      f_min_lat=+1000.0
      f_max_lat=-1000.0
 
      i_cnt_pos=0

c     Cycle through unique station files
      DO i=1,l_iffuniq
       s_single_filelist=TRIM(s_vec_iffuniq_netplat(i))

        s_single_filelist=TRIM(s_vec_iffuniq_netplat(i))

        i_len=LEN_TRIM(s_single_filelist)
         IF (s_single_filelist(1:1).EQ.'A') THEN 
          s_net_file =s_single_filelist(1:4)
          s_plat_file=s_single_filelist(5:i_len)
          GOTO 20
         ENDIF
         IF (s_single_filelist(1:1).EQ.'C') THEN 
          s_net_file =s_single_filelist(1:5)
          s_plat_file=s_single_filelist(6:i_len)
          GOTO 20
         ENDIF
         IF (s_single_filelist(1:1).EQ.'I') THEN 
          s_net_file =s_single_filelist(1:4)
          s_plat_file=s_single_filelist(5:i_len)
          GOTO 20
         ENDIF
         IF (s_single_filelist(1:1).EQ.'W') THEN 
          s_net_file =s_single_filelist(1:3)
          s_plat_file=s_single_filelist(4:i_len)
          GOTO 20
         ENDIF
         print*,'no netplat found filelist',TRIM(s_single_filelist)
         STOP 'get_lines_append_stnconfig20210604'
 20      CONTINUE

c       print*,'np receipt='//TRIM(s_net_rec)//'='//TRIM(s_plat_rec)//'='

c      Cycle through receipt files
       i_testgood=0     !set to bad
       DO j=1,l_stn     !cycle through receipt files

c      get separated netplat for receipt
       s_single_receipt=s_filelist(j)
       i_len=LEN_TRIM(s_single_receipt)
       IF (s_single_receipt(1:1).EQ.'A') THEN 
        s_net_rec =s_single_receipt(1:4)
        s_plat_rec=s_single_receipt(6:i_len-4)
        GOTO 10
       ENDIF
       IF (s_single_receipt(1:1).EQ.'C') THEN 
        s_net_rec =s_single_receipt(1:5)
        s_plat_rec=s_single_receipt(7:i_len-4)
        GOTO 10
       ENDIF
       IF (s_single_receipt(1:1).EQ.'I') THEN 
        s_net_rec =s_single_receipt(1:4)
        s_plat_rec=s_single_receipt(6:i_len-4)
        GOTO 10
       ENDIF
       IF (s_single_receipt(1:1).EQ.'W') THEN 
        s_net_rec =s_single_receipt(1:3)
        s_plat_rec=s_single_receipt(5:i_len-4)
        GOTO 10
       ENDIF
       print*,'no netplat receipt found',TRIM(s_single_receipt)
 10    CONTINUE

c        Compare file net-plot with receipt net-plat
         IF (TRIM(s_net_rec).EQ.TRIM(s_net_file).AND.
     +       TRIM(s_plat_rec).EQ.TRIM(s_plat_file)) THEN 
          j_use=j
          i_testgood=1
          i_cnt_pos=i_cnt_pos+1
          GOTO 25
         ENDIF
c        print*,'np file='//TRIM(s_net_file)//'='//TRIM(s_plat_file)//'='
c        print*,'s_single_filelist=',TRIM(s_single_filelist)
c        STOP 'get_lines_append_stnconfig20210604'
       ENDDO

       print*,'very bad='//TRIM(s_single_filelist)//'='
       STOP 'get_lines_append_stnconfig20210604'

 25    CONTINUE

c       GOTO 30

       print*,'stn acc;i=',i

c      Get data from single file
       CALL get_triplet_data_single_file4(
     +   s_dir_outfile_iff_netplatdistinct,s_filelist(j_use),
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

 30    CONTINUE

      ENDDO

      print*,'i_cnt_pos=',i_cnt_pos
c************************************************************************
      print*,'just leaving get_lines_append_stnconfig2'

      RETURN
      END
