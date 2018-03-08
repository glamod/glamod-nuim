c     Subroutine to get list of data directories
c     AJ_Kettle, Nov15/2017

      SUBROUTINE import_directory_names2(s_pathandname,
     +  l_nfile,
     +  l_nfile_use,s_filelist)

      IMPLICIT NONE
c************************************************************************
c     Declare variables

      INTEGER             :: i,j,k,ii,jj,kk
      INTEGER             :: io

      CHARACTER(LEN=300)  :: s_pathandname
      INTEGER             :: l_nfile
      INTEGER             :: l_nfile_use
      CHARACTER(LEN=300)  :: s_filelist(l_nfile)

      CHARACTER(LEN=300)  :: s_linget1
c************************************************************************
      print*,'just entered import_directory_names2'
      print*,'s_pathandname=',TRIM(s_pathandname)
      print*,'l_nfile=',l_nfile     

      OPEN(UNIT=1,FILE=s_pathandname,FORM='formatted',
     +  STATUS='OLD',ACTION='READ') 

c     Read lines of data
      ii=1
      DO 
       READ(1,1000,IOSTAT=io) s_linget1
1000   FORMAT(a300)

c       print*,'s_linget1=',TRIM(s_linget1)
   
       IF (io .GT. 0) THEN
        WRITE(*,*) 'Check input. Something went wrong'
        GOTO 100
       ELSE IF (io .LT. 0) THEN 
c        WRITE(*,*) 'end of file reached'
        GOTO 100
       ELSE
        s_filelist(ii)=TRIM(ADJUSTL(s_linget1))
        ii=ii+1
       ENDIF

      ENDDO
100   CONTINUE

      CLOSE(UNIT=1)

      l_nfile_use=ii-1

      print*,'l_nfile=',l_nfile,l_nfile_use
      print*,'s_filelist=',(TRIM(s_filelist(i)),i=1,l_nfile_use)
c************************************************************************
      print*,'just leaving import_directory_names2'

      RETURN
      END