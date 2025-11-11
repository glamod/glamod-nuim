c     Subroutine to get list of compressed files
c     AJ_Kettle, Oct17/2017

      SUBROUTINE getlist_comp_files(s_pathandname,
     +  l_zipfile_co,s_zipfiles_co,s_stnnum_co)

      IMPLICIT NONE
c************************************************************************
      CHARACTER(LEN=300)  :: s_pathandname

      INTEGER             :: i,j,k,ii,jj,kk
      INTEGER             :: io      
      CHARACTER(LEN=300)  :: s_linget2

      INTEGER             :: l_zipfile_co
      CHARACTER(LEN=300)  :: s_zipfiles_co(100)
      CHARACTER(LEN=5)    :: s_stnnum_co(100)
c************************************************************************
      print*,'getlist_comp_files'

      OPEN(UNIT=1,FILE=s_pathandname,FORM='formatted',
     +  STATUS='OLD',ACTION='READ') 

c     Read lines of data
      ii=1
      DO 
       READ(1,1000,IOSTAT=io) s_linget2
1000   FORMAT(a300)
   
       IF (io .GT. 0) THEN
        WRITE(*,*) 'Check input. Something went wrong'
        GOTO 100
       ELSE IF (io .LT. 0) THEN 
        WRITE(*,*) 'end of file reached'
        GOTO 100
       ELSE
        s_zipfiles_co(ii)=TRIM(ADJUSTL(s_linget2))
        s_stnnum_co(ii)=s_linget2(4:9)

c        print*,'ii...',ii,s_stnnum(ii),s_stdate(ii),s_endate(ii)
c        CALL SLEEP(1)

        ii=ii+1
       ENDIF

      ENDDO
100   CONTINUE

      CLOSE(UNIT=1)

      l_zipfile_co=ii-1

c      print*,'l_zipfile_co=',l_zipfile_co
c************************************************************************
      RETURN
      END