c     Subroutine to read in subset
c     AJ_Kettle, Oct31/2018

      SUBROUTINE readin_subset(
     +  s_directory_ancilldata,s_filename_ghcnd_subset,
     +  l_lines_rgh,l_subset,s_stnname)

      IMPLICIT NONE
c************************************************************************
c     Variables passed into subroutine

      CHARACTER(LEN=300)  :: s_directory_ancilldata
      CHARACTER(LEN=300)  :: s_filename_ghcnd_subset
c*****
c     Variables used within program

      INTEGER             :: i,j,k,ii,jj,kk
      INTEGER             :: io

      CHARACTER(LEN=300)  :: s_pathandname
      INTEGER             :: l_subset

      CHARACTER(LEN=12)   :: s_linget
      INTEGER             :: i_lenmin
      INTEGER             :: i_lenmax

      INTEGER             :: l_lines_rgh
      CHARACTER(LEN=12)   :: s_stnname(l_lines_rgh)
c************************************************************************
c      print*,'just entered readin_subset'

      s_pathandname=
     +  TRIM(s_directory_ancilldata)//TRIM(s_filename_ghcnd_subset)

c     Read in lines
      ii=0
      i_lenmin=30
      i_lenmax=0

      OPEN(UNIT=1,FILE=TRIM(s_pathandname),FORM='formatted',
     +  STATUS='OLD',ACTION='READ')      

c     Read in header
      READ(1,1002,IOSTAT=io) s_linget

c     Initialize maximum counter
      ii     =0

      DO 
c      Read data line
       READ(1,1002,IOSTAT=io) s_linget
1002   FORMAT(a12)
       IF (io .GT. 0) THEN
        WRITE(*,*) 'Check input. Something went wrong'
        GOTO 100
       ELSE IF (io .LT. 0) THEN 
c        WRITE(*,*) 'end of file reached'
        GOTO 100
       ELSE
        ii=ii+1

        s_stnname(ii)=s_linget

c        IF (ii.EQ.19994) THEN     

        i_lenmin=MIN(i_lenmin,LEN_TRIM(s_linget))
        i_lenmax=MAX(i_lenmax,LEN_TRIM(s_linget))
 
       ENDIF
      ENDDO
100   CONTINUE

      CLOSE(UNIT=1)

      l_subset=ii

c      print*,'l_subset=',l_subset
c      print*,'i_lenmin,i_lenmax=',i_lenmin,i_lenmax

c      print*,'s_stnname=',s_stnname(1)
c************************************************************************
c      print*,'just leaving readin_subset'

      RETURN
      END
