c     Subroutine to create summary list
c     AJ_Kettle, Oct06/2017

      SUBROUTINE export_summary_listsort_dd(s_directory_output,s_date,
     +  l_zip_use,s_stnnum,
     +  s_arch_dayrec_stdate,s_arch_dayrec_endate,
     +  s_arch_geog_hgt_m,s_arch_geog_lat_deg,s_arch_geog_lon_deg,
     +  i_arch_lprod)

      IMPLICIT NONE
c************************************************************************
      CHARACTER(LEN=200)  :: s_directory_output
      CHARACTER(LEN=8)    :: s_date
      INTEGER             :: l_zip_use

      CHARACTER(LEN=5)    :: s_stnnum(1100)
      CHARACTER(LEN=8)    :: s_arch_dayrec_stdate(1100)
      CHARACTER(LEN=8)    :: s_arch_dayrec_endate(1100)
      CHARACTER(LEN=8)    :: s_arch_geog_hgt_m(1100)  
      CHARACTER(LEN=8)    :: s_arch_geog_lat_deg(1100)
      CHARACTER(LEN=8)    :: s_arch_geog_lon_deg(1100)
      INTEGER             :: i_arch_lprod(1100)

      CHARACTER(LEN=5)    :: s_sort_stnnum(1100)
      CHARACTER(LEN=8)    :: s_sort_dayrec_stdate(1100)
      CHARACTER(LEN=8)    :: s_sort_dayrec_endate(1100)
      CHARACTER(LEN=8)    :: s_sort_geog_hgt_m(1100)  
      CHARACTER(LEN=8)    :: s_sort_geog_lat_deg(1100)
      CHARACTER(LEN=8)    :: s_sort_geog_lon_deg(1100)
      INTEGER             :: i_sort_lprod(1100)

      INTEGER             :: i_sortorder(1100)

      INTEGER             :: i,j,k
c************************************************************************
c      print*,'s_directory_output=',s_directory_output
c************************************************************************
c     Find sorted list
      CALL sort_like_pwave_integer(l_zip_use,i_arch_lprod,
     +  i_sortorder)

      DO i=1,l_zip_use 
       s_sort_stnnum(i)        =s_stnnum(i_sortorder(i))
       s_sort_dayrec_stdate(i) =s_arch_dayrec_stdate(i_sortorder(i))
       s_sort_dayrec_endate(i) =s_arch_dayrec_endate(i_sortorder(i))
       s_sort_geog_hgt_m(i)    =s_arch_geog_hgt_m(i_sortorder(i))
       s_sort_geog_lat_deg(i)  =s_arch_geog_lat_deg(i_sortorder(i))
       s_sort_geog_lon_deg(i)  =s_arch_geog_lon_deg(i_sortorder(i))
       i_sort_lprod(i)         =i_arch_lprod(i_sortorder(i))
      ENDDO
c************************************************************************
      OPEN(UNIT=1,
     +  FILE=TRIM(s_directory_output)//'stats_summary_list_daysort.dat',
     +  FORM='formatted',
     +  STATUS='NEW',ACTION='WRITE')

      WRITE(UNIT=1,FMT=3009) 'DWD - stnlist info sorted'
      WRITE(UNIT=1,FMT=3009) '                         '
3009  FORMAT(a25) 

      WRITE(unit=1,FMT=3029) 'AJ_Kettle ',s_date                          
3029  FORMAT(t1,a10,t12,a8) 
      WRITE(unit=1,FMT=3023) '                                        '

      WRITE(unit=1,FMT=3031) 'N_stns    ',l_zip_use                          
3031  FORMAT(t1,a10,t12,i4) 
      WRITE(unit=1,FMT=3023) '                                        '  
3023  FORMAT(t1,a40) 

      WRITE(unit=1,FMT=3025) 'Stnum','St_date ','En_date ',
     +  'Hght_m  ','Lat_deg ','Lon_deg ','N_lines '
      WRITE(unit=1,FMT=3025) '+---+','+------+','+------+',
     +  '+------+','+------+','+------+','+------+'
3025  FORMAT(t1,a5,t7,a8,t16,a8,t25,a8,t34,a8,t43,a8,t52,a8)

      DO i=1,l_zip_use
       WRITE(unit=1,FMT=3027) s_sort_stnnum(i),
     +  s_sort_dayrec_stdate(i),s_sort_dayrec_endate(i),
     +  s_sort_geog_hgt_m(i),
     +  s_sort_geog_lat_deg(i),s_sort_geog_lon_deg(i), 
     +  i_sort_lprod(i)
3027   FORMAT(t1,a5,t7,a8,t16,a8,t25,a8,t34,a8,t43,a8,t52,i8)
      ENDDO

      CLOSE(UNIT=1)
c************************************************************************
      RETURN
      END
