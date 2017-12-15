c     Subroutine to output variables: minbod/gust/ppt/sundur
c     AJ_Kettle, Oct3/2017

      SUBROUTINE export_datafile3(s_directory_output,s_date,l_zipfile,
     +  s_arch_geog_stnid,
     +  s_arch_geog_hgt_m,s_arch_geog_lat_deg,s_arch_geog_lon_deg,
     +  s_arch_geog_stdate,s_arch_geog_endate,i_arch_lprod,
     +  i_arch_daymin_minbod_ngood,f_arch_daymin_minbod_min_c,
     +  f_arch_daymin_minbod_max_c,f_arch_daymin_minbod_avg_c,
     +  i_arch_daymax_gust_ngood,f_arch_daymax_gust_min_ms,
     +  f_arch_daymax_gust_max_ms,f_arch_daymax_gust_avg_ms,
     +  i_arch_daytot_ppt_ngood,f_arch_daytot_ppt_min_mm,
     +  f_arch_daytot_ppt_max_mm,f_arch_daytot_ppt_avg_mm,
     +  i_arch_daytot_sundur_ngood,f_arch_daytot_sundur_min_h,
     +  f_arch_daytot_sundur_max_h,f_arch_daytot_sundur_avg_h)
 
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

      INTEGER             :: i_arch_daymin_minbod_ngood(1100)
      REAL                :: f_arch_daymin_minbod_ngood(1100)
      REAL                :: f_arch_daymin_minbod_nbad(1100)
      REAL                :: f_arch_daymin_minbod_min_c(1100)
      REAL                :: f_arch_daymin_minbod_max_c(1100)
      REAL                :: f_arch_daymin_minbod_avg_c(1100)
 
      INTEGER             :: i_arch_daymax_gust_ngood(1100)
      REAL                :: f_arch_daymax_gust_ngood(1100)
      REAL                :: f_arch_daymax_gust_nbad(1100)
      REAL                :: f_arch_daymax_gust_min_ms(1100)
      REAL                :: f_arch_daymax_gust_max_ms(1100)
      REAL                :: f_arch_daymax_gust_avg_ms(1100)
 
      INTEGER             :: i_arch_daytot_ppt_ngood(1100)
      REAL                :: f_arch_daytot_ppt_ngood(1100)
      REAL                :: f_arch_daytot_ppt_nbad(1100)
      REAL                :: f_arch_daytot_ppt_min_mm(1100)
      REAL                :: f_arch_daytot_ppt_max_mm(1100)
      REAL                :: f_arch_daytot_ppt_avg_mm(1100)
 
      INTEGER             :: i_arch_daytot_sundur_ngood(1100)
      REAL                :: f_arch_daytot_sundur_ngood(1100)
      REAL                :: f_arch_daytot_sundur_nbad(1100)
      REAL                :: f_arch_daytot_sundur_min_h(1100)
      REAL                :: f_arch_daytot_sundur_max_h(1100)
      REAL                :: f_arch_daytot_sundur_avg_h(1100)

      INTEGER             :: i,j,k
c************************************************************************
      OPEN(UNIT=1,
     +  FILE=TRIM(s_directory_output)//'stats_day_data3.dat',
     +  FORM='formatted',
     +  STATUS='NEW',ACTION='WRITE')

      WRITE(UNIT=1,FMT=3009) 'DWD - Day Historical Data'
      WRITE(UNIT=1,FMT=3009) 'minbod/gust/ppt/sundur   '
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
     +  'MNBOD ','MNBOD ','MNBOD ','MNBOD ',
     +  'GUST  ','GUST  ','GUST  ','GUST  ',
     +  'PPT   ','PPT   ','PPT   ','PPT   ',
     +  'SUNDR ','SUNDR ','SUNDR ','SUNDR '
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
     +  '      ','C     ','C     ','C     ',
     +  '      ','m/s   ','m/s   ','m/s   ',
     +  '      ','mm    ','mm    ','mm    ',
     +  '      ','hour  ','hour  ','hour  '
      WRITE(unit=1,FMT=3025) '+---+',
     +  '+------+','+------+','+------+',
     +  '+------+','+------+','+------+',
     +  '+----+','+----+','+----+','+----+',
     +  '+----+','+----+','+----+','+----+',
     +  '+----+','+----+','+----+','+----+',
     +  '+----+','+----+','+----+','+----+' 
3025  FORMAT(t1,a5,t7,
     +  a8,t16,a8,t25,a8,t34,
     +  a8,t43,a8,t52,a8,t61,
     +  a6,t67,a6,t73,a6,t79,a6,t85,
     +  a6,t91,a6,t97,a6,t103,a6,t109,
     +  a6,t115,a6,t121,a6,t127,a6,t133,
     +  a6,t139,a6,t145,a6,t151,a6)

      DO i=1,l_zipfile

       WRITE(unit=1,FMT=3027) 
     +  s_arch_geog_stnid(i),
     +  s_arch_geog_hgt_m(i),
     +    s_arch_geog_lat_deg(i),s_arch_geog_lon_deg(i),
     +  s_arch_geog_stdate(i),s_arch_geog_endate(i),i_arch_lprod(i),
     +  i_arch_daymin_minbod_ngood(i),f_arch_daymin_minbod_min_c(i),
     +  f_arch_daymin_minbod_max_c(i),f_arch_daymin_minbod_avg_c(i),
     +  i_arch_daymax_gust_ngood(i),f_arch_daymax_gust_min_ms(i),
     +  f_arch_daymax_gust_max_ms(i),f_arch_daymax_gust_avg_ms(i),
     +  i_arch_daytot_ppt_ngood(i),f_arch_daytot_ppt_min_mm(i),
     +  f_arch_daytot_ppt_max_mm(i),f_arch_daytot_ppt_avg_mm(i),
     +  i_arch_daytot_sundur_ngood(i),f_arch_daytot_sundur_min_h(i),
     +  f_arch_daytot_sundur_max_h(i),f_arch_daytot_sundur_avg_h(i)
3027   FORMAT(t1,a5,t7,
     +  a8,t16,a8,t25,a8,t34,
     +  a8,t43,a8,t52,i8,t61,
     +  i6,t67,f6.1,t73,f6.1,t79,f6.2,t85,
     +  i6,t91,f6.1,t97,f6.1,t103,f6.1,t109,
     +  i6,t115,f6.1,t121,f6.1,t127,f6.1,t133,
     +  i6,t139,f6.1,t145,f6.1,t151,f6.1)
      ENDDO

      CLOSE(UNIT=1)

      RETURN
      END
