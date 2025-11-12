c     Subroutine to get vectors of data
c     AJ_Kettle, 16May2019
c     27Nov2019: subroutine modified for qff program
c     07Oct2020: subroutine used for 20q4 project

      SUBROUTINE get_stnconfig_qff20210714(s_directory_stnconfig,
     +  s_filename_stnconfig_new,
     +  l_scoutput_rgh,l_scoutput,ilen,
     +  l_numfield,s_vec_header,
     +  s_vec_stnconfig_lines,
     +  s_header,s_scoutput_searchname)

      IMPLICIT NONE
c************************************************************************
c     Variables passed into program

      CHARACTER(LEN=300)  :: s_directory_stnconfig
      CHARACTER(LEN=300)  :: s_filename_stnconfig_new

      INTEGER             :: l_scoutput_rgh
      INTEGER             :: l_scoutput
      INTEGER             :: ilen

      CHARACTER(LEN=*)    :: s_vec_stnconfig_lines(l_scoutput_rgh) !1000
      CHARACTER(LEN=*)    :: s_header                              !1000
      CHARACTER(LEN=*)    :: s_scoutput_searchname(l_scoutput_rgh) !16

      INTEGER             :: l_numfield
      CHARACTER(LEN=ilen) :: s_vec_header(50)
c      CHARACTER(LEN=ilen) :: s_arch_fields(l_scoutput_rgh,50)
c*****
c     Variables used within program

      INTEGER             :: i,j,k,ii,jj,kk
      INTEGER             :: io

      CHARACTER(LEN=1000) :: s_pathandname
      CHARACTER(LEN=1000) :: s_linget

      CHARACTER(LEN=ilen)  :: s_vec_fields(50)

      INTEGER             :: i_len_header
      INTEGER             :: i_len_line

      INTEGER             :: ii_err
      INTEGER             :: ii_good
      INTEGER             :: i_runmax
c************************************************************************
      print*,'just entered get_stnconfig_qff'

      s_pathandname=
     +  TRIM(s_directory_stnconfig)//TRIM(s_filename_stnconfig_new)

      ii=0
      jj=0
      ii_err=0
      ii_good=0
      i_runmax=0

      OPEN(UNIT=5,
     +  FILE=TRIM(s_pathandname),
     +  FORM='formatted',
     +  STATUS='OLD',ACTION='READ')

      READ(5,1000,IOSTAT=io) s_header
 
      i_len_header=LEN_TRIM(s_header)

c     Call subroutine to get pipe-separated fields
      CALL get_elements_stnconfig_line20201008(s_header,
     +  l_numfield,s_vec_header)

c      print*,'s_header=',TRIM(s_header)
c      print*,'i_len_header=',i_len_header

      DO 
       READ(5,1000,IOSTAT=io) s_linget   
 1000  FORMAT(a1000)

       IF (io .GT. 0) THEN
        WRITE(*,*) 'Check input. Something went wrong'
        GOTO 100
       ELSE IF (io .LT. 0) THEN
        WRITE(*,*) 'end of file reached'
        GOTO 100
       ELSE
        ii=ii+1

c       Crash condition if too many lines
        IF (ii.GT.l_scoutput_rgh) THEN
         print*,'ii=',ii,l_scoutput_rgh
         print*,'stnconfig data lines exceeds limit' 
         STOP 'get_stnconfig_qff20210714'
        ENDIF

        i_len_line=LEN_TRIM(s_linget)

        IF (i_len_line.GT.1000) THEN 
         print*,'emergency stop line length over range'
         STOP 'get_stnconfig_qff20210714'
        ENDIF

c       Call subroutine to get pipe-separated fields
        CALL get_elements_stnconfig_line20201008(s_linget,
     +    l_numfield,s_vec_fields)

c       Store info only iff 16 char not exceeded
        IF (LEN_TRIM(s_vec_fields(1)).LE.16) THEN
         ii_good=ii_good+1

c        Store full line
         s_vec_stnconfig_lines(ii_good)=s_linget

c        Store first field for searching
         s_scoutput_searchname(ii_good)=s_vec_fields(1)
        ENDIF

c       Verify first element 11 characters
        IF (LEN_TRIM(s_vec_fields(1)).GT.16) THEN
         print*,'emergency stop, 1st element over 16 char'
         print*,'LEN_TRIM(s_vec_fields(1))',LEN_TRIM(s_vec_fields(1))
         print*,'(s_vec_fields(1))',(s_vec_fields(1))

         i_runmax=MAX(i_runmax,LEN_TRIM(s_vec_fields(1)))

         ii_err=ii_err+1
c         STOP 'get_stnconfig_qff20210713'
        ENDIF

c        print*,'ii...',ii,s_scoutput_searchname(ii)
c        CALL SLEEP (1)

c        IF (TRIM(s_vec_fields(1)).EQ.'AAI0000TNCA') THEN 
c         print*,'s_linget=',TRIM(s_linget)
c         print*,'s_vec_stnconfig_lines=',TRIM(s_vec_stnconfig_lines(ii))
c         print*,'field49=',TRIM(s_vec_fields(49))
c         print*,'i_len_line=',i_len_line
c        ENDIF

c       Archive fields
c        DO j=1,l_numfield
c         s_arch_fields(ii,j)=s_vec_fields(j)
c        ENDDO


       ENDIF
      ENDDO
 100  CONTINUE
      CLOSE(UNIT=5)

      l_scoutput=ii_good  !ii

      print*,'l_numfield=',l_numfield
      print*,'s_vec_header=',(TRIM(s_vec_header(i))//'|',i=1,l_numfield)
      print*,'ii,l_scoutput=',ii,l_scoutput
      print*,'l_scoutput_rgh=',l_scoutput_rgh

c      DO i=1,l_numfield
c       print*,i,TRIM(s_vec_header(i))
c      ENDDO

c      print*,'just leaving get_stnconfig_qff'

      print*,'ii...=',ii,ii_good,ii_err
      print*,'i_runmax=',i_runmax

c      STOP 'get_stnconfig_qff20210714'

      RETURN
      END
