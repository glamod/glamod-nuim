c     Subroutine to test file for segmentation fault
c     AJ_Kettle, 21Jun2020

      SUBROUTINE test_file_segfault(s_file_single,s_stnname_isolated,
     +   s_directory_output_diagnostics_segfault,
     +   s_directory_temp, 
     +   i_flag_segfault)

      IMPLICIT NONE
c************************************************************************
c     Variables passed into subroutine

      CHARACTER(LEN=300)  :: s_file_single
      CHARACTER(LEN=300)  :: s_stnname_isolated
      CHARACTER(LEN=300)  :: s_directory_output_diagnostics_segfault
      CHARACTER(LEN=300)  :: s_directory_temp

      INTEGER             :: i_flag_segfault
c*****
c     Variables used in subroutine

      INTEGER             :: i,j,k,ii,jj,kk
      INTEGER             :: io

      CHARACTER(LEN=300)  :: s_command

      CHARACTER(LEN=300)  :: s_pathandname

      CHARACTER(LEN=1000) :: s_linget
      
c************************************************************************
c      print*,'just entered test_file_segfault'

c      print*,'s_file_single=',TRIM(s_file_single)

      s_command=
     +  'head -n 1 '//TRIM(s_file_single)//' > '//
     +  TRIM(s_directory_temp)//'message.dat'
c      print*,'s_command=',TRIM(s_command) 
      CALL SYSTEM(s_command,io)
c*****
c*****
c     Read in contents of message file
      s_pathandname=TRIM(s_directory_temp)//'message.dat'

c      print*,'s_pathandname=',TRIM(s_pathandname)

      s_linget=''

      OPEN(UNIT=2,FILE=TRIM(s_pathandname),
     +  FORM='formatted',STATUS='OLD',ACTION='READ')

      DO
       READ(2,1000,IOSTAT=io) s_linget
 1000  FORMAT(a1000)

c       print*,'s_linget=',TRIM(s_linget)
c       print*,'len',LEN_TRIM(s_linget)
      
       IF (io .GT. 0) THEN
        print*, 'Check input. Something went wrong'
        GOTO 100
       ELSE IF (io .LT. 0) THEN
        print*, 'end of file reached'
        GOTO 100
       ELSE

       ENDIF
      ENDDO
 100  CONTINUE

      CLOSE(UNIT=2)

c      print*,'s_linget=',TRIM(s_linget)
   
      i_flag_segfault=1       !use 1 as default
      IF (s_linget(1:4).EQ.'Stat') THEN 
       i_flag_segfault=0
      ENDIF

c      print*,'i_flag_segfault=',i_flag_segfault

c      STOP 'test_file_segfault'      
c*****
c     Erase message file
      s_command='rm '//TRIM(s_directory_temp)//'message.dat'
c      print*,'s_command=',TRIM(s_command) 
      CALL SYSTEM(s_command,io)
c*****
c     Write diagnostics file
      IF (i_flag_segfault.EQ.1) THEN 
       print*,'start error write'
       print*,'dir output',
     +   TRIM(s_directory_output_diagnostics_segfault)
       print*,'s_stnname_isolated=',TRIM(s_stnname_isolated)

       s_pathandname=TRIM(s_directory_output_diagnostics_segfault)//
     +  TRIM(s_stnname_isolated)

c      print*,'s_pathandname=',TRIM(s_pathandname)

       OPEN(UNIT=2,FILE=TRIM(s_pathandname),
     +  FORM='formatted',STATUS='NEW',ACTION='WRITE')      
       WRITE(2,1002,IOSTAT=io) 'segfault station    '
 1002  FORMAT(t1,a20)
       CLOSE(UNIT=2)
      ENDIF
c*****
c      print*,'just leaving test_file_segfault'

c      STOP 'test_file_segfault'

      RETURN
      END
