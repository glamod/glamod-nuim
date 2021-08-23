c     Subroutine to read in triplet list
c     AJ_Kettle,10Jul2019
c     26Mar2020: adapted for USAF update

      SUBROUTINE read_in_triplet_list2(s_filename,
     +  l_stn_rgh,l_stn,s_filelist)

      IMPLICIT NONE
c************************************************************************
c     Declare variables 

      INTEGER             :: l_stn_rgh

      CHARACTER(LEN=300)  :: s_filename
      INTEGER             :: l_stn
      CHARACTER(LEN=300)  :: s_filelist(l_stn_rgh)
c*****
      INTEGER             :: i,j,k,ii,jj,kk
      INTEGER             :: io

      CHARACTER(LEN=300)  :: s_pathandname
      CHARACTER(LEN=300)  :: s_linget
c************************************************************************
      print*,'just entered read_in_triplet_list2'

      s_pathandname=TRIM(s_filename)

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
        s_filelist(ii)=s_linget

       ENDIF
      ENDDO                !end of line-counting loop

100   CONTINUE

      CLOSE(UNIT=2)

      l_stn=ii

      print*,'l_stn=',l_stn
      print*,'s_filelist first=',TRIM(s_filelist(1))
      print*,'s_filelist last=', TRIM(s_filelist(l_stn))

      print*,'just leaving read_in_triplet_list2'

c      STOP 'read_in_triplet_list2'

      RETURN
      END
