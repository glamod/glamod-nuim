c     Subroutine to export information for basis stn set
c     AJ_Kettle, Nov.1/2017

      SUBROUTINE export_basis_info(s_directory_output,s_filename1,
     +  s_date,l_file_basis,
     +  s_basis_stke,s_basis_stid,s_basis_stdate,s_basis_endate,
     +  s_basis_hght,s_basis_lat,s_basis_lon,
     +  s_basis_stnname,s_basis_bundesland)

      IMPLICIT NONE
c************************************************************************
      CHARACTER(LEN=8)    :: s_date
      CHARACTER(LEN=300)  :: s_directory_output
      CHARACTER(LEN=300)  :: s_filename1
      INTEGER             :: l_file_basis

      CHARACTER(LEN=5)    :: s_basis_stke(100)
      CHARACTER(LEN=5)    :: s_basis_stid(100)
      CHARACTER(LEN=8)    :: s_basis_stdate(100)
      CHARACTER(LEN=8)    :: s_basis_endate(100)
      CHARACTER(LEN=9)    :: s_basis_hght(100)
      CHARACTER(LEN=10)   :: s_basis_lat(100)
      CHARACTER(LEN=10)   :: s_basis_lon(100)
      CHARACTER(LEN=25)   :: s_basis_stnname(100)
      CHARACTER(LEN=25)   :: s_basis_bundesland(100)

      CHARACTER(LEN=300)  :: s_pathandname1
 
      INTEGER             :: i,j,k,ii,jj,kk
c************************************************************************
      s_pathandname1=TRIM(s_directory_output)//TRIM(s_filename1)

      print*,'s_filename1=',TRIM(s_filename1)
      print*,'s_pathandname1=',s_pathandname1

      OPEN(UNIT=1,
     +  FILE=s_pathandname1,
     +  FORM='formatted',
     +  STATUS='NEW',ACTION='WRITE')

      WRITE(UNIT=1,FMT=3009) 'DWD - sifted/sorted data '
      WRITE(UNIT=1,FMT=3009) '                         '
3009  FORMAT(a25) 

      WRITE(unit=1,FMT=3029) 'AJ_Kettle ',s_date                          
3029  FORMAT(t1,a10,t12,a8) 
      WRITE(unit=1,FMT=3009) '                                        '

      WRITE(unit=1,FMT=3025) 'Kenn ','Iden ','St_date ',
     +  'En_date ','Hght     ','Latitude  ','Longitude '
      WRITE(unit=1,FMT=3025) '+---+','+---+','+------+',
     +  '+------+','+-------+','+--------+','+--------+',
     +  '+-----------------------+','+-----------------------+'
3025  FORMAT(t1,a5,t7,a5,t13,
     +  a8,t22,a8,t31,a9,t41,a10,t52,a10,
     +  t63,a25,t88,a25)

      DO i=1,l_file_basis
       WRITE(unit=1,FMT=3025) 
     +  s_basis_stke(i),s_basis_stid(i),s_basis_stdate(i),
     +  s_basis_endate(i),s_basis_hght(i),s_basis_lat(i),s_basis_lon(i),
     +  s_basis_stnname(i),s_basis_bundesland(i)
c3027   FORMAT(t1,f8.2,t9,f8.2,t17,f8.2,t25,f8.0,t33,f8.0)
      ENDDO

      CLOSE(UNIT=1)
c************************************************************************
      RETURN
      END