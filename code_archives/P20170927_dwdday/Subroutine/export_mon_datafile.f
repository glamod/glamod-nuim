c     Subroutine to output month statistics
c     AJ_Kettle, Dec1/2017

      SUBROUTINE export_mon_datafile(s_directory_output,s_date,
     +  l_zip_use,
     +  s_arch_geog_stnid,
     +  s_arch_geog_hgt_m,s_arch_geog_lat_deg,s_arch_geog_lon_deg,
     +  i_arch_lmonrec_common,
     +  s_arch_mon_commonmon_st,s_arch_mon_commonmon_en,
     +  s_arch_mon_commonyear_st,s_arch_mon_commonyear_en,
     +  f_arch_mon_airt_ngood,f_arch_mon_airt_nbad,
     +  f_arch_mon_airt_min_k,f_arch_mon_airt_max_k,
     +  f_arch_mon_airt_avg_k,
     +  f_arch_mon_wspd_ngood,f_arch_mon_wspd_nbad,     
     +  f_arch_mon_wspd_min_ms,f_arch_mon_wspd_max_ms,
     +  f_arch_mon_wspd_avg_ms,
     +  f_arch_mon_slpres_ngood,f_arch_mon_slpres_nbad,
     +  f_arch_mon_slpres_min_hpa,f_arch_mon_slpres_max_hpa,
     +  f_arch_mon_slpres_avg_hpa,
     +  f_arch_mon_ppt_ngood,f_arch_mon_ppt_nbad, 
     +  f_arch_mon_ppt_min_mm,f_arch_mon_ppt_max_mm,
     +  f_arch_mon_ppt_avg_mm)

      IMPLICIT NONE
c************************************************************************
      CHARACTER(LEN=200)  :: s_directory_output
      CHARACTER(LEN=8)    :: s_date
      INTEGER             :: l_zip_use

      CHARACTER(LEN=5)    :: s_arch_geog_stnid(1100)
      CHARACTER(LEN=8)    :: s_arch_geog_hgt_m(1100)
      CHARACTER(LEN=8)    :: s_arch_geog_lat_deg(1100)
      CHARACTER(LEN=8)    :: s_arch_geog_lon_deg(1100)

      INTEGER             :: i_arch_lmonrec_common(1100)
      CHARACTER(LEN=2)    :: s_arch_mon_commonmon_st(1100)
      CHARACTER(LEN=2)    :: s_arch_mon_commonmon_en(1100)
      CHARACTER(LEN=4)    :: s_arch_mon_commonyear_st(1100)
      CHARACTER(LEN=4)    :: s_arch_mon_commonyear_en(1100)

      REAL                :: f_arch_mon_airt_ngood(1100)
      REAL                :: f_arch_mon_airt_nbad(1100)
      REAL                :: f_arch_mon_airt_min_k(1100)
      REAL                :: f_arch_mon_airt_max_k(1100)
      REAL                :: f_arch_mon_airt_avg_k(1100)

      REAL                :: f_arch_mon_wspd_ngood(1100)
      REAL                :: f_arch_mon_wspd_nbad(1100)
      REAL                :: f_arch_mon_wspd_min_ms(1100)
      REAL                :: f_arch_mon_wspd_max_ms(1100)
      REAL                :: f_arch_mon_wspd_avg_ms(1100)

      REAL                :: f_arch_mon_slpres_ngood(1100)
      REAL                :: f_arch_mon_slpres_nbad(1100)
      REAL                :: f_arch_mon_slpres_min_hpa(1100)
      REAL                :: f_arch_mon_slpres_max_hpa(1100)
      REAL                :: f_arch_mon_slpres_avg_hpa(1100)

      REAL                :: f_arch_mon_ppt_ngood(1100)
      REAL                :: f_arch_mon_ppt_nbad(1100)
      REAL                :: f_arch_mon_ppt_min_mm(1100)
      REAL                :: f_arch_mon_ppt_max_mm(1100)
      REAL                :: f_arch_mon_ppt_avg_mm(1100)

      INTEGER             :: i,j,k,ii,jj,kk
c************************************************************************
      print*,'just entered export_mon_datafile'

      OPEN(UNIT=1,
     +  FILE=TRIM(s_directory_output)//'stats_mon_data1.dat',
     +  FORM='formatted',
     +  STATUS='NEW',ACTION='WRITE')

      WRITE(UNIT=1,FMT=3009) 'DWD - Mon Historical Data'
      WRITE(UNIT=1,FMT=3009) 'airt/wspd/slpres/ppt     '
      WRITE(UNIT=1,FMT=3009) '                         '
3009  FORMAT(a25) 

      WRITE(unit=1,FMT=3029) 'AJ_Kettle ',s_date                          
3029  FORMAT(t1,a10,t12,a8) 
      WRITE(unit=1,FMT=3023) '                                        '
3023  FORMAT(t1,a40) 

      WRITE(unit=1,FMT=3025) 'Stnid',
     +  'Height','Latitude','Longitud',
     +  'St_date ','En_date ','N_TOTAL ',
     +  'AIRT','AIRT','AIRT  ','AIRT  ','AIRT  ',
     +  'WSPD','WSPD','WSPD  ','WSPD  ','WSPD  ',
     +  'SLPR','SLPR','SLPRES','SLPRES','SLPRES',
     +  'PPT ','PPT ','PPT   ','PPT   ','PPT   '
      WRITE(unit=1,FMT=3025) 'Stnid',
     +  'Height','Latitude','Longitud',
     +  'St_date','En_date','NTOT',
     +  'NGO0','NBAD','MIN   ','MAX   ','AVG   ',
     +  'NGO0','NBAD','MIN   ','MAX   ','AVG   ',
     +  'NGO0','NBAD','MIN   ','MAX   ','AVG   ',
     +  'NGO0','NBAD','MIN   ','MAX   ','AVG   ' 
      WRITE(unit=1,FMT=3025) '+---+',
     +  '+----+','+------+','+------+',
     +  '+-----+','+-----+','+--+',
     +  '+--+','+--+','+----+','+----+','+----+',
     +  '+--+','+--+','+----+','+----+','+----+',
     +  '+--+','+--+','+----+','+----+','+----+',
     +  '+--+','+--+','+----+','+----+','+----+' 
3025  FORMAT(t1,a5,t7,
     +  a6,t14,a8,t23,a8,t32,
     +  a7,t40,a7,t48,a4,t53,
     +  a4,t58,a4,t63,a6,t70,a6,t77,a6,t84,
     +  a4,t90,a4,t95,a6,t102,a6,t109,a6,t116,
     +  a4,t121,a4,t126,a6,t133,a6,t140,a6,t147,
     +  a4,t152,a4,t157,a6,t164,a6,t171,a6,t178)

      DO i=1,l_zip_use

             WRITE(unit=1,FMT=3027) 
     +  s_arch_geog_stnid(i),
     +  s_arch_geog_hgt_m(i),
     +    s_arch_geog_lat_deg(i),s_arch_geog_lon_deg(i),
     +  s_arch_mon_commonyear_st(i)//'/'//s_arch_mon_commonmon_st(i),
     +    s_arch_mon_commonyear_en(i)//'/'//s_arch_mon_commonmon_en(i),
     +    i_arch_lmonrec_common(i),
     +  NINT(f_arch_mon_airt_ngood(i)),NINT(f_arch_mon_airt_nbad(i)),
     +    f_arch_mon_airt_min_k(i),f_arch_mon_airt_max_k(i),
     +    f_arch_mon_airt_avg_k(i),    
     +  NINT(f_arch_mon_wspd_ngood(i)),NINT(f_arch_mon_wspd_nbad(i)),
     +    f_arch_mon_wspd_min_ms(i),f_arch_mon_wspd_max_ms(i),
     +    f_arch_mon_wspd_avg_ms(i),
     + NINT(f_arch_mon_slpres_ngood(i)),NINT(f_arch_mon_slpres_nbad(i)),
     +    f_arch_mon_slpres_min_hpa(i),f_arch_mon_slpres_max_hpa(i),
     +    f_arch_mon_slpres_avg_hpa(i),   
     +  NINT(f_arch_mon_ppt_ngood(i)),NINT(f_arch_mon_ppt_nbad(i)),
     +    f_arch_mon_ppt_min_mm(i),f_arch_mon_ppt_max_mm(i),
     +    f_arch_mon_ppt_avg_mm(i)
3027   FORMAT(t1,a5,t7,
     +  a6,t14,a8,t23,a8,t32,
     +  a7,t40,a7,t48,i4,t53,

     +  i4,t58,i4,t63,f6.2,t70,f6.2,t77,f6.2,t84,
     +  i4,t90, i4,t95, f6.1,t102,f6.1,t109,f6.1,t116,
     +  i4,t121,i4,t126,f6.1,t133,f6.1,t140,f6.1,t147,
     +  i4,t152,i4,t157,f6.1,t164,f6.1,t171,f6.1)
      ENDDO

      CLOSE(unit=1)
c************************************************************************
      print*,'just leaving export_mon_datafile'

      RETURN
      END