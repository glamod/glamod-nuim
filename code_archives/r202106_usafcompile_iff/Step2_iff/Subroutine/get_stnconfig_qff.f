c     Subroutine to get vectors of data
c     AJ_Kettle, 16May2019
c     27Nov2019: subroutine modified for qff program
c     11Mar2020: used for USAF update program

      SUBROUTINE get_stnconfig_qff(s_directory_stnconfig,
     +  s_filename_stnconfig_new,
     +  l_scoutput_rgh,l_scoutput,ilen,
     +  l_numfield,s_vec_header,s_arch_fields)

      IMPLICIT NONE
c************************************************************************
c     Variables passed into program

      CHARACTER(LEN=300)  :: s_directory_stnconfig
      CHARACTER(LEN=300)  :: s_filename_stnconfig_new

      INTEGER             :: l_scoutput_rgh
      INTEGER             :: l_scoutput
      INTEGER             :: ilen

      CHARACTER(LEN=1000) :: s_header

      INTEGER             :: l_numfield
      CHARACTER(LEN=ilen) :: s_vec_header(50)
      CHARACTER(LEN=ilen) :: s_arch_fields(l_scoutput_rgh,50)
c*****
c     Variables used within program

      INTEGER             :: i,j,k,ii,jj,kk
      INTEGER             :: io

      CHARACTER(LEN=1000) :: s_pathandname
      CHARACTER(LEN=1000) :: s_linget

      CHARACTER(LEN=ilen)  :: s_vec_fields(50)

      INTEGER             :: i_len_header
      INTEGER             :: i_len_line
c************************************************************************
      print*,'just entered get_stnconfig_qff'

      s_pathandname=
     +  TRIM(s_directory_stnconfig)//TRIM(s_filename_stnconfig_new)

      ii=0
      jj=0

      OPEN(UNIT=5,
     +  FILE=TRIM(s_pathandname),
     +  FORM='formatted',
     +  STATUS='OLD',ACTION='READ')

      READ(5,1000,IOSTAT=io) s_header
 
      i_len_header=LEN_TRIM(s_header)

c     Call subroutine to get pipe-separated fields
      CALL get_elements_stnconfig_line(s_header,
     +  l_numfield,s_vec_header)

c      print*,'s_header=',TRIM(s_header)
c      print*,'i_len_header=',i_len_header
c      STOP 'get_stnconfig_write'

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
         print*,'emergency stop; stnconfig data lines exceeds limit' 
         STOP 'get_stnconfig_qff'
        ENDIF

        i_len_line=LEN_TRIM(s_linget)

c       Call subroutine to get pipe-separated fields
        CALL get_elements_stnconfig_line(s_linget,
     +    l_numfield,s_vec_fields)

c       Archive fields
        DO j=1,l_numfield
         s_arch_fields(ii,j)=s_vec_fields(j)
        ENDDO

        IF (i_len_line.GT.1000) THEN 
         print*,'emergency stop line length over range'
         STOP 'get_stnconfig_write'
        ENDIF

       ENDIF
      ENDDO
 100  CONTINUE
      CLOSE(UNIT=5)

      l_scoutput=ii

      print*,'l_numfield=',l_numfield
      print*,'s_vec_header=',(TRIM(s_vec_header(i))//'|',i=1,l_numfield)
      print*,'ii,l_scoutput=',ii,l_scoutput
      print*,'l_scoutput_rgh=',l_scoutput_rgh

c      DO i=1,l_numfield
c       print*,i,TRIM(s_vec_header(i))
c      ENDDO

      print*,'just leaving get_stnconfig_qff'

c      STOP 'get_stnconfig_qff'

      RETURN
      END
