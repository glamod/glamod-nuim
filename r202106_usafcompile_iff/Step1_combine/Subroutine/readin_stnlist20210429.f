c     Subroutine to read in filelist
c     AJ_Kettle, 21Apr2021

      SUBROUTINE readin_stnlist20210429(s_filelist,
     +  l_rgh_stn,l_stn2019,s_vec_stnlist)

      IMPLICIT NONE
c************************************************************************
c     Variables passed into subroutine
      CHARACTER(LEN=300)  :: s_filelist
      INTEGER             :: l_rgh_stn
      INTEGER             :: l_stn2019
      CHARACTER(LEN=32)   :: s_vec_stnlist(*)
c*****
c     Variables used within subroutine

      INTEGER             :: i,j,k,ii,jj,kk
      INTEGER             :: io

      CHARACTER(LEN=300)  :: s_pathandname

      CHARACTER(LEN=300)  :: s_linget
c************************************************************************
c      print*,'just entered readin_stnlist'

      s_pathandname=TRIM(s_filelist)

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

        IF (ii.GT.l_rgh_stn) THEN
         print*,'emergency stop: index exceeds vector length' 
         STOP 'readin_stnlist'
        ENDIF

        s_vec_stnlist(ii)=s_linget

       ENDIF
      ENDDO                !end of line-counting loop

100   CONTINUE

      CLOSE(UNIT=2)

      l_stn2019=ii

      print*,'l_stn=',l_stn2019
c*****

c      print*,'just leaving readin_stnlist'

      RETURN
      END
