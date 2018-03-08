c     Subroutine to export stats
c     AJ_Kettle, Nov24/2017

      subroutine export_archstats(s_date,s_directory_output,s_filename,
     +  l_nfile,l_nfile_use,s_filelist,s_arch_stnnum,
     +  f_arch_rain_ngd_mm,f_arch_rain_nbd_mm,    
     +  f_arch_rain_avg_mm,f_arch_rain_min_mm,
     +  f_arch_rain_max_mm,    
     +  f_arch_airt_ngd_k,f_arch_airt_nbd_k,
     +  f_arch_airt_avg_k,f_arch_airt_min_k,
     +  f_arch_airt_max_k)

      IMPLICIT NONE
c************************************************************************
      CHARACTER(LEN=8)    :: s_date
      INTEGER             :: l_nfile
      INTEGER             :: l_nfile_use
      CHARACTER(LEN=300)  :: s_directory_output
      CHARACTER(LEN=300)  :: s_filename

      CHARACTER(LEN=300)  :: s_filelist(l_nfile)
      CHARACTER(LEN=8)    :: s_arch_stnnum(l_nfile) 

      REAL                :: f_arch_rain_ngd_mm(l_nfile)     
      REAL                :: f_arch_rain_nbd_mm(l_nfile)     
      REAL                :: f_arch_rain_avg_mm(l_nfile)     
      REAL                :: f_arch_rain_min_mm(l_nfile)     
      REAL                :: f_arch_rain_max_mm(l_nfile)     

      REAL                :: f_arch_airt_ngd_k(l_nfile)
      REAL                :: f_arch_airt_nbd_k(l_nfile)
      REAL                :: f_arch_airt_avg_k(l_nfile)
      REAL                :: f_arch_airt_min_k(l_nfile)
      REAL                :: f_arch_airt_max_k(l_nfile)

      INTEGER             :: i,j,k,ii,jj,kk
c************************************************************************
      OPEN(UNIT=1,
     +  FILE=TRIM(s_directory_output)//TRIM(s_filename),
     +  FORM='formatted',
     +  STATUS='NEW',ACTION='WRITE')

      WRITE(UNIT=1,FMT=3009) 'Station statistics       '
      WRITE(UNIT=1,FMT=3009) '                         '
3009  FORMAT(a25) 

      WRITE(unit=1,FMT=3029) 'AJ_Kettle ',s_date                          
3029  FORMAT(t1,a10,t12,a8) 
      WRITE(unit=1,FMT=3023) '                                        '

      WRITE(unit=1,FMT=3031) 'N_stns    ',l_nfile_use                          
3031  FORMAT(t1,a10,t12,i4) 
      WRITE(unit=1,FMT=3023) '                                        '  
3023  FORMAT(t1,a40) 

      WRITE(unit=1,FMT=3025) 'Stn_num ',
     +  'Stn_name                      ',
     +  'Rain  ','Rain  ','Rain  ','Rain  ','Rain  ',
     +  'Airt  ','Airt  ','Airt  ','Airt  ','Airt  '
      WRITE(unit=1,FMT=3025) '        ',
     +  '                              ',
     +  'N_good','N_bad ','Averag','Min   ','Max   ',
     +  'N_good','N_bad ','Averag','Min   ','Max   '
      WRITE(unit=1,FMT=3025) '+------+',
     +  '+----------------------------+',
     +  '+----+','+----+','+----+','+----+','+----+',
     +  '+----+','+----+','+----+','+----+','+----+'
3025  FORMAT(t1,a8,
     +  t10,a30,
     +  t41,a6,t48,a6,t55,a6,t62,a6,t69,a6,
     +  t76,a6,t83,a6,t90,a6,t97,a6,t104,a6)

      DO i=1,l_nfile_use
       WRITE(unit=1,FMT=3026) s_arch_stnnum(i),
     +  s_filelist(i),
     +  f_arch_rain_ngd_mm(i),f_arch_rain_nbd_mm(i),    
     +  f_arch_rain_avg_mm(i),f_arch_rain_min_mm(i),
     +  f_arch_rain_max_mm(i),    
     +  f_arch_airt_ngd_k(i),f_arch_airt_nbd_k(i),
     +  f_arch_airt_avg_k(i),f_arch_airt_min_k(i),
     +  f_arch_airt_max_k(i)
3026  FORMAT(t1,a8,
     +  t10,a30,
     +  t41,f6.0,t48,f6.0,t55,f6.2,t62,f6.2,t69,f6.2,
     +  t76,f6.0,t83,f6.0,t90,f6.2,t97,f6.2,t104,f6.2)

      ENDDO

      CLOSE(UNIT=1)
c************************************************************************
      RETURN
      END