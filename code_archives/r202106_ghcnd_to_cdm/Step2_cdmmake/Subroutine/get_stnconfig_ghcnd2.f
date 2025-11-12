c     Subroutine to get vectors of data
c     AJ_Kettle, 16May2019
c     29Mar2020: used for GHCND update
c     12Apr2020: used for gHCND 01May2020 release

      SUBROUTINE get_stnconfig_ghcnd2(s_directory_stnconfig,
     +  s_filename_stnconfig_new,
     +  l_scoutput_rgh,l_scoutput,l_scfield,
     +  s_header,
     +  l_numfield,s_vec_header,s_arch_fields)

      IMPLICIT NONE
c************************************************************************
c     Variables passed into program

      CHARACTER(LEN=300)  :: s_directory_stnconfig
      CHARACTER(LEN=300)  :: s_filename_stnconfig_new

      CHARACTER(LEN=1000) :: s_header

      INTEGER             :: l_scoutput_rgh
      INTEGER             :: l_scoutput
      INTEGER             :: l_scfield

      CHARACTER(LEN=*)    :: s_vec_header(50)
      CHARACTER(LEN=*)    :: s_arch_fields(l_scoutput_rgh,50)
c*****
c     Variables used within program

      INTEGER             :: i,j,k,ii,jj,kk
      INTEGER             :: io

      CHARACTER(LEN=1000) :: s_pathandname
      CHARACTER(LEN=1000) :: s_linget

      INTEGER             :: l_numfield
      CHARACTER(LEN=l_scfield):: s_vec_fields(50)

      INTEGER             :: i_len_header
      INTEGER             :: i_len_line
c************************************************************************
      print*,'just entered get_stnconfig_ghcnd'

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
      CALL get_elements_stnconfig_line2(s_header,
     +  l_numfield,s_vec_header,
     +  l_scfield)

c      print*,'s_header=',TRIM(s_header)
c      print*,'i_len_header=',i_len_header
c      print*,'l_numfield=',l_numfield
c      DO i=1,l_numfield
c       print*,'s_vec_header=',i,TRIM(s_vec_header(i))
c      ENDDO
c      STOP 'get_stnconfig_ghcnd'

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

        IF (ii.GE.l_scoutput_rgh) THEN 
         print*,'emergency stop; too many lines stnconfig file'
         STOP 'get_stnconfig_ghcnd'
        ENDIF

        i_len_line=LEN_TRIM(s_linget)

c       Call subroutine to get pipe-separated fields
        CALL get_elements_stnconfig_line2(s_linget,
     +    l_numfield,s_vec_fields,
     +    l_scfield)

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

c      print*,'ii,l_scoutput=',ii,l_scoutput
c      print*,'l_scoutput_rgh=',l_scoutput_rgh

c      DO i=1,l_numfield
c       print*,i,TRIM(s_vec_header(i))
c      ENDDO

c      print*,'just leaving get_stnconfig_ghcnd'
c      STOP 'get_stnconfig_ghcnd'

      RETURN
      END
