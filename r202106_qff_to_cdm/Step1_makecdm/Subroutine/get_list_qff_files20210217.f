c     Subroutine make list of qff files & read in vector
c     AJ_Kettle, 18Nov2019

      SUBROUTINE get_list_qff_files20210217(s_directory_file_source,
     +  s_directory_data_middle,s_qff_filelist,
     +  l_rgh_files,l_files,s_vec_files)

      IMPLICIT NONE
c************************************************************************
c     Declare variables 

      CHARACTER(LEN=300)  :: s_directory_file_source
      CHARACTER(LEN=300)  :: s_directory_data_middle
      CHARACTER(LEN=300)  :: s_qff_filelist

      INTEGER             :: l_rgh_files
      INTEGER             :: l_files
      CHARACTER(LEN=300)  :: s_vec_files(l_rgh_files)
c*****
c     Variablees used in subroutine

      INTEGER             :: i,j,k,ii,jj,kk

      CHARACTER(LEN=300)  :: s_command
      INTEGER             :: io

      CHARACTER(LEN=300)  :: s_pathandname

      CHARACTER(LEN=300)  :: s_linget
c************************************************************************
c      print*,'just entered get_list_qff_files'

c      s_command=
c     +  'ls '//TRIM(s_directory_file_source)//'*.* > '//
c     +  TRIM(s_directory_data_middle)//s_qff_filelist
c      print*,'s_command=',TRIM(s_command)
c      CALL SYSTEM(s_command,io)
c*****
c     Input list of names into vector

      s_pathandname=
     +  TRIM(s_directory_data_middle)//TRIM(s_qff_filelist)

      print*,'s_pathandname=',TRIM(s_pathandname)

      OPEN(UNIT=2,FILE=TRIM(s_pathandname),
     +  FORM='formatted',STATUS='OLD',ACTION='READ')

c     Read header
      READ(2,1000,IOSTAT=io) s_linget

      ii=0

      DO
       READ(2,1000,IOSTAT=io) s_linget
 1000  FORMAT(a300)

c       print*,'s_linget=',TRIM(s_linget)
c       print*,'len',LEN_TRIM(s_linget)
      
       IF (io .GT. 0) THEN
        print*, 'Check input. Something went wrong'
        GOTO 100
       ELSE IF (io .LT. 0) THEN
        print*, 'end of file reached'
        GOTO 100
       ELSE

        ii=ii+1

        s_vec_files(ii)=
     +    TRIM(s_directory_file_source)//
     +    TRIM(ADJUSTL(s_linget))//'.qff'

       ENDIF
      ENDDO
 100  CONTINUE

      CLOSE(UNIT=2)

c      print*,'ii=',ii
c      print*,'s_vec_files=',s_vec_files(1)

      l_files=ii

c      print*,'s_vec_files=',(s_vec_files(i),i=1,10)

c      print*,'just leaving get_list_qff_files'

      RETURN
      END
