c     Subroutine to read in list of the compressed files
c     AJ_Kettle, Sep11/2017

      SUBROUTINE get_list_compressed_files_dd(s_pathandname,
     +  l_zipfile,s_zipfiles,s_stnnum,s_stdate,s_endate)

      IMPLICIT NONE
c************************************************************************
      CHARACTER(LEN=200)  :: s_pathandname

      INTEGER             :: i,j,k,ii,jj,kk
      INTEGER             :: io      
      CHARACTER(LEN=300)  :: s_linget2

      INTEGER             :: l_zipfile
      CHARACTER(LEN=300)  :: s_zipfiles(1100)
      CHARACTER(LEN=5)    :: s_stnnum(1100)
      CHARACTER(LEN=8)    :: s_stdate(1100),s_endate(1100)
c************************************************************************
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
        s_zipfiles(ii)=TRIM(ADJUSTL(s_linget2))

        s_stnnum(ii)=s_linget2(12:16)
        s_stdate(ii)=s_linget2(18:25)
        s_endate(ii)=s_linget2(27:34)

c        print*,'ii...',ii,s_stnnum(ii),s_stdate(ii),s_endate(ii)
c        CALL SLEEP(1)

        ii=ii+1
       ENDIF

      ENDDO
100   CONTINUE

      CLOSE(UNIT=1)

      l_zipfile=ii-1

c      DO i=1,500   !l_zipfile
c       print*,'s_stdate...=',s_stdate(i),s_endate(i)
c      ENDDO
c      CALL SLEEP(20)
c      DO i=500,l_zipfile
c       print*,'s_stdate...=',s_stdate(i),s_endate(i)
c      ENDDO

c      print*,'l_file=',l_file
c      print*,'s_lindat=',(s_lindat(i),i=1,5)

      RETURN
      END