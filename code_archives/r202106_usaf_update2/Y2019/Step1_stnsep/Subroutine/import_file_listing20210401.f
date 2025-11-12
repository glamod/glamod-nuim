c     Subroutine to get path & file listing
c     AJ_Kettle, 01Apr2021

      SUBROUTINE import_file_listing20210401(
     +  s_directory_filelist,s_name_filelist,
     +  s_directory_dataroot,
     +  l_tar,
     +  s_vec_path,s_vec_name)

      IMPLICIT NONE
c************************************************************************
c     Declare variables passed into program

      CHARACTER(LEN=300)  :: s_directory_filelist 
      CHARACTER(LEN=300)  :: s_name_filelist
      CHARACTER(LEN=300)  :: s_directory_dataroot

      INTEGER             :: l_tar
      CHARACTER(LEN=300)  :: s_vec_path(*)
      CHARACTER(LEN=300)  :: s_vec_name(*)
c*****
c     Variables used inside subroutine

      INTEGER             :: i,j,k,ii,jj,kk
      INTEGER             :: io

      CHARACTER(LEN=300)  :: s_pathandname

      INTEGER             :: l_lines

      INTEGER,PARAMETER   :: l_rgh=2000
      CHARACTER(LEN=300)  :: s_linget
      CHARACTER(LEN=300)  :: s_linsto(l_rgh)

      CHARACTER(LEN=300)  :: s_segment

      INTEGER             :: l_len

      INTEGER             :: i_prevec_tarflag(l_rgh)
      CHARACTER(LEN=300)  :: s_linepath_pre(l_rgh)
      CHARACTER(LEN=300)  :: s_linepath_full(l_rgh)
c************************************************************************
      print *,'just inside import_file_listing'

      s_pathandname=TRIM(s_directory_filelist)//TRIM(s_name_filelist)

c      print*,'s_pathandname=',TRIM(s_pathandname)

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
        s_linsto(ii)=s_linget

       ENDIF
      ENDDO                !end of line-counting loop

100   CONTINUE

      CLOSE(UNIT=2)

      l_lines=ii

c      print*,'l_lines=',l_lines
c*****

      ii=0
      DO i=1,l_lines 
        ii=ii+1
        s_vec_path(ii)=s_directory_dataroot
        s_vec_name(ii)=s_linsto(ii)
      ENDDO

      l_tar=ii

      print*,'s_vec_path=',TRIM(s_vec_path(1))
      print*,'s_vec_name=',TRIM(s_vec_name(1))
c*****
c*****
      print *,'just leaving import_file_listing'

      RETURN
      END
