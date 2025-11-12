c     Subroutine to get archive & start index
c     AJ_Kettle, 28Jan2020

      SUBROUTINE get_archive_decide_start(s_directory_3archive,i_start)

      IMPLICIT NONE
c************************************************************************
c     Declare variables 

      CHARACTER(LEN=300)  :: s_directory_3archive
      INTEGER             :: i_start
c*****
c     Variables used in subroutine

      INTEGER             :: i,j,k,ii,jj,kk
      INTEGER             :: io

      CHARACTER(LEN=300)  :: s_command

      CHARACTER(LEN=300)  :: s_vec_filelist(2000)
      INTEGER             :: l_filelist

      CHARACTER(LEN=300)  :: s_pathandname

      INTEGER             :: i_vec_index(2000)
      INTEGER             :: i_vec_flagst(2000)
      INTEGER             :: i_vec_flagen(2000)

c************************************************************************
      print*,'just entered get_archive_decide_start'

c     Get listing of archive files
      s_pathandname=TRIM(s_directory_3archive)//'*.*'
      print*,'s_pathandname=',TRIM(s_pathandname)

      s_command=
     +  'ls '//TRIM(s_pathandname)//' > z_filelist.dat'
      print*,'s_command=',TRIM(s_command) 
      CALL SYSTEM(s_command,io)
c*****
c     Read in list of file names

      CALL readin_filename_list(l_filelist,s_vec_filelist)

      print*,'l_filelist=',l_filelist
      print*,'s_vec_filelist=',
     +  (TRIM(s_vec_filelist(i)),i=1,1)
c*****
c     Read in files to see if 1 or 2 elements present

      CALL readin_archive_elements(l_filelist,s_vec_filelist,
     +  i_vec_index,i_vec_flagst,i_vec_flagen)
c*****
c     Get i_start

      i_start=-999

c     Condition if no existing archives
      IF (l_filelist.EQ.0) THEN
       i_start=1
       print*,'condition1'
       GOTO 10
      ENDIF

c     Condition of incomplete file
      DO i=1,l_filelist
       IF (i_vec_flagst(i).EQ.1.AND.i_vec_flagen(i).EQ.0) THEN
        i_start=i_vec_index(i)
        print*,'condition2'
        GOTO 10
       ENDIF
      ENDDO

c     Condition for complete file
      i_start=i_vec_index(l_filelist)+1
      print*,'condition3'

 10   CONTINUE

      print*,'i_start=',i_start
c*****
      print*,'just leaving get_archive_decide_start'

c      STOP 'get_archive_decide_start'

      RETURN
      END
