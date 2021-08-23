c     Subroutine to read in list of filenames
c     AJ_Kettle, 29Jan2020

      SUBROUTINE readin_filename_list(l_filelist,s_vec_filelist)

      IMPLICIT NONE
c************************************************************************
c     Declare variables 

      INTEGER             :: l_filelist
      CHARACTER(LEN=300)  :: s_vec_filelist(2000)
c*****
c     Variables used in subroutine

      INTEGER             :: i,j,k,ii,jj,kk
      INTEGER             :: io

      CHARACTER(LEN=300)  :: s_linget
      CHARACTER(LEN=300)  :: s_pathandname
c************************************************************************
      print*,'just entered readin_filename_list'

      s_pathandname='z_filelist.dat'

      OPEN(UNIT=1,FILE=s_pathandname,FORM='formatted',
     +  STATUS='OLD',ACTION='READ')      

      ii=0

      DO                         !start loop for all lines in file

c      Read data line
       READ(1,1002,IOSTAT=io) s_linget
1002   FORMAT(a4000)           !changed from 3400 to 4000

       IF (io .GT. 0) THEN
        WRITE(*,*) 'Check input. Something went wrong'
        GOTO 100
       ELSE IF (io .LT. 0) THEN 
        WRITE(*,*) 'end of file reached'
        GOTO 100
       ELSE

c       Line counter
        ii=ii+1
        s_vec_filelist(ii)=s_linget

       ENDIF      !main reading condition

      ENDDO

 100  CONTINUE

      CLOSE(UNIT=1)
c*****
      l_filelist=ii

      print*,'l_filelist=',l_filelist
      print*,'s_vec_filelist=',TRIM(s_vec_filelist(1))

      print*,'just leaving readin_filename_list'

      RETURN
      END
