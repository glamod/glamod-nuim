c     Subroutine to output variables: minbod/gust/ppt/sundur
c     AJ_Kettle, Oct3/2017

      SUBROUTINE export_datafile4(s_directory_output,s_date,l_zipfile,
     +  s_arch_geog_stnid,
     +  s_arch_geog_hgt_m,s_arch_geog_lat_deg,s_arch_geog_lon_deg,
     +  s_arch_geog_stdate,s_arch_geog_endate,i_arch_lprod,
     +  i_arch_daytot_snoacc_ngood,f_arch_daytot_snoacc_min_cm,
     +  f_arch_daytot_snoacc_max_cm,f_arch_daytot_snoacc_avg_cm)

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

      INTEGER             :: i_arch_daytot_snoacc_ngood(1100)
      REAL                :: f_arch_daytot_snoacc_ngood(1100)
      REAL                :: f_arch_daytot_snoacc_nbad(1100)
      REAL                :: f_arch_daytot_snoacc_min_cm(1100)
      REAL                :: f_arch_daytot_snoacc_max_cm(1100)
      REAL                :: f_arch_daytot_snoacc_avg_cm(1100)
 
      INTEGER             :: i,j,k
c************************************************************************
      OPEN(UNIT=1,
     +  FILE=TRIM(s_directory_output)//'stats_day_data4.dat',
     +  FORM='formatted',
     +  STATUS='NEW',ACTION='WRITE')

      WRITE(UNIT=1,FMT=3009) 'DWD - Day Historical Data'
      WRITE(UNIT=1,FMT=3009) 'snoacc                   '
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
     +  'SNOAC ','SNOAC ','SNOAC ','SNOAC '
      WRITE(unit=1,FMT=3025) 'Stnid',
     +  'Height  ','Latitude','Longitud',
     +  'St_date ','En_date ','N_TOTAL ',
     +  'NGOOD ','MIN   ','MAX   ','AVG   ' 
      WRITE(unit=1,FMT=3025) 'Stnid',
     +  'Height  ','Latitude','Longitud',
     +  'St_date ','En_date ','N_TOTAL ',
     +  '      ','cm    ','cm    ','cm    '
      WRITE(unit=1,FMT=3025) '+---+',
     +  '+------+','+------+','+------+',
     +  '+------+','+------+','+------+',
     +  '+----+','+----+','+----+','+----+'

3025  FORMAT(t1,a5,t7,
     +  a8,t16,a8,t25,a8,t34,
     +  a8,t43,a8,t52,a8,t61,
     +  a6,t67,a6,t73,a6,t79,a6,t85)

      DO i=1,l_zipfile
       WRITE(unit=1,FMT=3027) 
     +  s_arch_geog_stnid(i),
     +  s_arch_geog_hgt_m(i),
     +    s_arch_geog_lat_deg(i),s_arch_geog_lon_deg(i),
     +  s_arch_geog_stdate(i),s_arch_geog_endate(i),i_arch_lprod(i),
     +  i_arch_daytot_snoacc_ngood(i),f_arch_daytot_snoacc_min_cm(i),
     +  f_arch_daytot_snoacc_max_cm(i),f_arch_daytot_snoacc_avg_cm(i)

3027   FORMAT(t1,a5,t7,
     +  a8,t16,a8,t25,a8,t34,
     +  a8,t43,a8,t52,i8,t61,
     +  i6,t67,f6.1,t73,f6.1,t79,f6.2,t85)
      ENDDO

      CLOSE(UNIT=1)

      RETURN
      END