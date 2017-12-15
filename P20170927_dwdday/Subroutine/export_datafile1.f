c     Subroutine to export data file1
c     AJ_Kettle, Oct.2/2017

      SUBROUTINE export_datafile1(s_directory_output,s_date,l_zipfile,
     +  s_arch_geog_stnid,
     +  s_arch_geog_hgt_m,s_arch_geog_lat_deg,s_arch_geog_lon_deg,
     +  s_arch_geog_stdate,s_arch_geog_endate,i_arch_lprod,
     +  i_arch_dayavg_airt_ngood,f_arch_dayavg_airt_min_c,
     +  f_arch_dayavg_airt_max_c,f_arch_dayavg_airt_avg_c,
     +  i_arch_dayavg_vapprs_ngood,f_arch_dayavg_vapprs_min_mb,
     +  f_arch_dayavg_vapprs_max_mb,f_arch_dayavg_vapprs_avg_mb,
     +  i_arch_dayavg_ccov_ngood,f_arch_dayavg_ccov_min_okta,
     +  f_arch_dayavg_ccov_max_okta,f_arch_dayavg_ccov_avg_okta,
     +  i_arch_dayavg_pres_ngood,f_arch_dayavg_pres_min_mb,
     +  f_arch_dayavg_pres_max_mb,f_arch_dayavg_pres_avg_mb)
 
      IMPLICIT NONE
c************************************************************************
      CHARACTER(LEN=200)  :: s_directory_output
      CHARACTER(LEN=8)    :: s_date
      INTEGER             :: l_zipfile

      INTEGER             :: i_arch_lprod(1100)
      CHARACTER(LEN=5)    :: s_arch_geog_stnid(1100)
      CHARACTER(LEN=8)    :: s_arch_geog_hgt_m(1100)
      CHARACTER(LEN=8)    :: s_arch_geog_lat_deg(1100)
      CHARACTER(LEN=8)    :: s_arch_geog_lon_deg(1100)
      CHARACTER(LEN=8)    :: s_arch_geog_stdate(1100)
      CHARACTER(LEN=8)    :: s_arch_geog_endate(1100)

      INTEGER             :: i_arch_dayavg_airt_ngood(1100)
      REAL                :: f_arch_dayavg_airt_ngood(1100)
      REAL                :: f_arch_dayavg_airt_nbad(1100)
      REAL                :: f_arch_dayavg_airt_min_c(1100)
      REAL                :: f_arch_dayavg_airt_max_c(1100)
      REAL                :: f_arch_dayavg_airt_avg_c(1100)

      INTEGER             :: i_arch_dayavg_vapprs_ngood(1100)
      REAL                :: f_arch_dayavg_vapprs_ngood(1100)
      REAL                :: f_arch_dayavg_vapprs_nbad(1100)
      REAL                :: f_arch_dayavg_vapprs_min_mb(1100)
      REAL                :: f_arch_dayavg_vapprs_max_mb(1100)
      REAL                :: f_arch_dayavg_vapprs_avg_mb(1100)

      INTEGER             :: i_arch_dayavg_ccov_ngood(1100)
      REAL                :: f_arch_dayavg_ccov_ngood(1100)
      REAL                :: f_arch_dayavg_ccov_nbad(1100)
      REAL                :: f_arch_dayavg_ccov_min_okta(1100)
      REAL                :: f_arch_dayavg_ccov_max_okta(1100)
      REAL                :: f_arch_dayavg_ccov_avg_okta(1100)

      INTEGER             :: i_arch_dayavg_pres_ngood(1100)
      REAL                :: f_arch_dayavg_pres_ngood(1100)
      REAL                :: f_arch_dayavg_pres_nbad(1100)
      REAL                :: f_arch_dayavg_pres_min_mb(1100)
      REAL                :: f_arch_dayavg_pres_max_mb(1100)
      REAL                :: f_arch_dayavg_pres_avg_mb(1100) 

      INTEGER             :: i,j,k
c************************************************************************

      OPEN(UNIT=1,
     +  FILE=TRIM(s_directory_output)//'stats_day_data1.dat',
     +  FORM='formatted',
     +  STATUS='NEW',ACTION='WRITE')

      WRITE(UNIT=1,FMT=3009) 'DWD - Day Historical Data'
      WRITE(UNIT=1,FMT=3009) 'airt/vapprs/ccov/pres    '
      WRITE(UNIT=1,FMT=3009) '                         '
      WRITE(UNIT=1,FMT=3009) '                         '
3009  FORMAT(a25) 

      WRITE(unit=1,FMT=3029) 'AJ_Kettle ',s_date                          
3029  FORMAT(t1,a10,t12,a8) 
      WRITE(unit=1,FMT=3023) '                                        '
3023  FORMAT(t1,a40) 

      WRITE(unit=1,FMT=3025) 'Stnid',
     +  'Height  ','Latitude','Longitud',
     +  'St_date ','En_date ','N_TOTAL ',
     +  'AIRT  ','AIRT  ','AIRT  ','AIRT  ',
     +  'VPPRS ','VPPRS ','VPPRS ','VPPRS ',
     +  'CCOV  ','CCOV  ','CCOV  ','CCOV  ',
     +  'PRES  ','PRES  ','PRES  ','PRES  '
      WRITE(unit=1,FMT=3025) 'Stnid',
     +  'Height  ','Latitude','Longitud',
     +  'St_date ','En_date ','N_TOTAL ',
     +  'NGOOD ','MIN   ','MAX   ','AVG   ',
     +  'NGOOD ','MIN   ','MAX   ','AVG   ',
     +  'NGOOD ','MIN   ','MAX   ','AVG   ',
     +  'NGOOD ','MIN   ','MAX   ','AVG   ' 
      WRITE(unit=1,FMT=3025) 'Stnid',
     +  'Height  ','Latitude','Longitud',
     +  'St_date ','En_date ','N_TOTAL ',
     +  '      ','DEG_C ','DEG_C ','DEG_C ',
     +  '      ','hPa   ','hPa   ','hPa   ',
     +  '      ','OKTA  ','OKTA  ','OKTA  ',
     +  '      ','hPa   ','hPa   ','hPa   '
      WRITE(unit=1,FMT=3025) '+---+',
     +  '+------+','+------+','+------+',
     +  '+------+','+------+','+------+',
     +  '+----+','+----+','+----+','+----+',
     +  '+----+','+----+','+----+','+----+',
     +  '+----+','+----+','+----+','+----+',
     +  '+----+','+-----+','+-----+','+-----+' 

3025  FORMAT(t1,a5,t7,
     +  a8,t16,a8,t25,a8,t34,
     +  a8,t43,a8,t52,a8,t61,
     +  a6,t67,a6,t73,a6,t79,a6,t85,
     +  a6,t91,a6,t97,a6,t103,a6,t109,
     +  a6,t115,a6,t121,a6,t127,a6,t133,
     +  a6,t139,a7,t146,a7,t153,a7,t157)

      DO i=1,l_zipfile

       WRITE(unit=1,FMT=3027) 
     +  s_arch_geog_stnid(i),
     +  s_arch_geog_hgt_m(i),
     +    s_arch_geog_lat_deg(i),s_arch_geog_lon_deg(i),
     +  s_arch_geog_stdate(i),s_arch_geog_endate(i),i_arch_lprod(i),
     +  i_arch_dayavg_airt_ngood(i),f_arch_dayavg_airt_min_c(i),
     +  f_arch_dayavg_airt_max_c(i),f_arch_dayavg_airt_avg_c(i),
     +  i_arch_dayavg_vapprs_ngood(i),f_arch_dayavg_vapprs_min_mb(i),
     +  f_arch_dayavg_vapprs_max_mb(i),f_arch_dayavg_vapprs_avg_mb(i),
     +  i_arch_dayavg_ccov_ngood(i),f_arch_dayavg_ccov_min_okta(i),
     +  f_arch_dayavg_ccov_max_okta(i),f_arch_dayavg_ccov_avg_okta(i),
     +  i_arch_dayavg_pres_ngood(i),f_arch_dayavg_pres_min_mb(i),
     +  f_arch_dayavg_pres_max_mb(i),f_arch_dayavg_pres_avg_mb(i)
3027   FORMAT(t1,a5,t7,
     +  a8,t16,a8,t25,a8,t34,
     +  a8,t43,a8,t52,i8,t61,
     +  i6,t67,f6.1,t73,f6.1,t79,f6.2,t85,
     +  i6,t91,f6.2,t97,f6.2,t103,f6.2,t109,
     +  i6,t115,f6.2,t121,f6.2,t127,f6.2,t133,
     +  i6,t139,f7.1,t146,f7.1,t153,f7.1)
      ENDDO

      CLOSE(unit=1)

      RETURN
      END