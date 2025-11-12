c     Subroutine to create summary list
c     AJ_Kettle, Oct06/2017

      SUBROUTINE export_listsort_sd(s_directory_output,s_filename1,
     +  s_date,
     +  l_mstn,l_file_use,
     +  s_basis_stke,s_basis_stid,s_basis_stdate,s_basis_endate,
     +  s_basis_hght,s_basis_lat,s_basis_lon,
     +  i_arch_j_sd)  

      IMPLICIT NONE
c************************************************************************
      CHARACTER(LEN=300)  :: s_directory_output
      CHARACTER(LEN=300)  :: s_filename1
      CHARACTER(LEN=8)    :: s_date

      INTEGER             :: l_mstn
      INTEGER             :: l_file_use
      CHARACTER(LEN=5)    :: s_basis_stke(100)
      CHARACTER(LEN=5)    :: s_basis_stid(100)
      CHARACTER(LEN=8)    :: s_basis_stdate(100)
      CHARACTER(LEN=8)    :: s_basis_endate(100)
      CHARACTER(LEN=9)    :: s_basis_hght(100)
      CHARACTER(LEN=10)   :: s_basis_lat(100)
      CHARACTER(LEN=10)   :: s_basis_lon(100)
      INTEGER             :: i_arch_j_sd(100)

      CHARACTER(LEN=300)  :: s_pathandname1
 
      INTEGER             :: i,j,k,ii,jj,kk

      INTEGER             :: i_sortorder(100)

      CHARACTER(LEN=5)    :: s_sort_basis_stke(100)
      CHARACTER(LEN=5)    :: s_sort_basis_stid(100)
      CHARACTER(LEN=8)    :: s_sort_basis_stdate(100)
      CHARACTER(LEN=8)    :: s_sort_basis_endate(100)
      CHARACTER(LEN=9)    :: s_sort_basis_hght(100)
      CHARACTER(LEN=10)   :: s_sort_basis_lat(100)
      CHARACTER(LEN=10)   :: s_sort_basis_lon(100)
      INTEGER             :: i_sort_arch_j_sd(100)

c************************************************************************
      s_pathandname1=TRIM(s_directory_output)//TRIM(s_filename1)

      print*,'l_file_use',l_file_use
      print*,'i_arch_j_sd',(i_arch_j_sd(i),i=1,10)
c************************************************************************
c     Find sorted list
      CALL sort_like_pwave_integer(l_file_use,i_arch_j_sd,
     +  i_sortorder)

c      print*,'i_sortorder=',(i_sortorder(i),i=1,10)

      DO i=1,l_file_use 
       s_sort_basis_stke(i)    =s_basis_stke(i_sortorder(i))
       s_sort_basis_stid(i)    =s_basis_stid(i_sortorder(i))
       s_sort_basis_stdate(i)  =s_basis_stdate(i_sortorder(i))
       s_sort_basis_endate(i)  =s_basis_endate(i_sortorder(i))
       s_sort_basis_hght(i)    =s_basis_hght(i_sortorder(i))
       s_sort_basis_lat(i)     =s_basis_lat(i_sortorder(i))
       s_sort_basis_lon(i)     =s_basis_lon(i_sortorder(i))
       i_sort_arch_j_sd(i)     =i_arch_j_sd(i_sortorder(i))
      ENDDO
c************************************************************************
      OPEN(UNIT=1,
     +  FILE=TRIM(s_pathandname1),
     +  FORM='formatted',
     +  STATUS='NEW',ACTION='WRITE')

      WRITE(UNIT=1,FMT=3009) 'DWD - stnlist info sorted'
      WRITE(UNIT=1,FMT=3009) '                         '
3009  FORMAT(a25) 

      WRITE(unit=1,FMT=3029) 'AJ_Kettle ',s_date                          
3029  FORMAT(t1,a10,t12,a8) 
      WRITE(unit=1,FMT=3023) '                                        '

      WRITE(unit=1,FMT=3031) 'N_stns    ',l_file_use                          
3031  FORMAT(t1,a10,t12,i4) 
      WRITE(unit=1,FMT=3023) '                                        '  
3023  FORMAT(t1,a40) 

      WRITE(unit=1,FMT=3025) 'Stnum','St_date ','En_date ',
     +  'Hght_m  ','Lat_deg ','Lon_deg ','N_lines '
      WRITE(unit=1,FMT=3025) '+---+','+------+','+------+',
     +  '+-------+','+------+','+------+','+------+'
3025  FORMAT(t1,a5,t7,a8,t16,a8,t25,a9,t35,a8,t44,a8,t53,a8)

      DO i=1,l_file_use
       WRITE(unit=1,FMT=3027) 
     +   s_sort_basis_stid(i),
     +   s_sort_basis_stdate(i),s_sort_basis_endate(i),
     +   s_sort_basis_hght(i),
     +   s_sort_basis_lat(i),s_sort_basis_lon(i),
     +   i_sort_arch_j_sd(i)
3027   FORMAT(t1,a5,t7,a8,t16,a8,t25,a9,t35,a8,t44,a8,t53,i8)
      ENDDO

      CLOSE(UNIT=1)
c************************************************************************
      RETURN
      END
