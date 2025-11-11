c     Subroutine import filename list
c     AJ_Kettle, 08Jan2020
c     27Apr2020: used for 1May2020 release

      SUBROUTINE import_filename_list(
     +  s_directory_filelist,s_filename,
     +  l_rgh_stn,l_stn,
     +  s_filelist_stations)

      IMPLICIT NONE
c************************************************************************
      INTEGER             :: l_rgh_stn
      INTEGER             :: l_stn
      CHARACTER(LEN=300)  :: s_filelist_stations(l_rgh_stn)

      CHARACTER(LEN=300)  :: s_directory_filelist
      CHARACTER(LEN=300)  :: s_filename
c*****
c     Variables used in subroutine
      INTEGER             :: i,j,k,ii,jj,kk
      INTEGER             :: io

      CHARACTER(LEN=300)  :: s_pathandname
      CHARACTER(LEN=300)  :: s_linget
c************************************************************************
      print*,'just inside import_filename_list'

      s_pathandname=TRIM(s_directory_filelist)//TRIM(s_filename)

      print*,'s_pathandname=',TRIM(s_pathandname)

      ii=0

      OPEN(UNIT=2,FILE=TRIM(s_pathandname),
     +  FORM='formatted',STATUS='OLD',ACTION='READ')     

      DO 

c      Read data line
       READ(2,1002,IOSTAT=io) s_linget
1002   FORMAT(a300)
       IF (io .GT. 0) THEN
        WRITE(*,*) 'Check input. Something went wrong'
        GOTO 100
       ELSE IF (io .LT. 0) THEN 
c        WRITE(*,*) 'end of file reached'
        GOTO 100
       ELSE

        ii=ii+1
        s_filelist_stations(ii)=s_linget

       ENDIF
      ENDDO                !end of line-counting loop

100   CONTINUE

      CLOSE(UNIT=2)

      l_stn=ii

      print*,'l_stn=',l_stn
      print*,'s_filelist_stations=',
     +  (TRIM(s_filelist_stations(i))//'=',i=1,5)

      print*,'just leaving import_filename_list'

      RETURN
      END
