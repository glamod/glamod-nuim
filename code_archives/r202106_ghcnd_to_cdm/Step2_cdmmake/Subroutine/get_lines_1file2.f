c     Subroutine to get data vectors from 1 file
c     AJ_Kettle, 03Dec2018

      SUBROUTINE get_lines_1file2(s_pathandname,l_lines_rgh,l_lines,
     +  s_arch_id,s_arch_date_yyyymmdd,s_arch_element,s_arch_datavalue,
     +  s_arch_mflag,s_arch_qflag,s_arch_sflag,s_arch_obstime)

      IMPLICIT NONE
c************************************************************************
c     Declare variables passed into program

      CHARACTER(LEN=300)  :: s_pathandname

      INTEGER             :: l_lines_rgh
      INTEGER             :: l_lines

      CHARACTER(LEN=12)   :: s_arch_id(l_lines_rgh)
      CHARACTER(LEN=8)    :: s_arch_date_yyyymmdd(l_lines_rgh)
      CHARACTER(LEN=4)    :: s_arch_element(l_lines_rgh)
      CHARACTER(LEN=5)    :: s_arch_datavalue(l_lines_rgh)
      CHARACTER(LEN=1)    :: s_arch_mflag(l_lines_rgh)
      CHARACTER(LEN=1)    :: s_arch_qflag(l_lines_rgh)
      CHARACTER(LEN=1)    :: s_arch_sflag(l_lines_rgh)
      CHARACTER(LEN=4)    :: s_arch_obstime(l_lines_rgh)

c*****
c     Variables used in subroutine

      INTEGER             :: i,j,k,ii,jj,kk
      INTEGER             :: io

      CHARACTER(LEN=50)   :: s_linget

      INTEGER             :: i_len 
      INTEGER             :: i_len_max,i_len_min

      CHARACTER(LEN=12)   :: s_sing_id
      CHARACTER(LEN=8)    :: s_sing_date_yyyymmdd
      CHARACTER(LEN=4)    :: s_sing_element
      CHARACTER(LEN=5)    :: s_sing_datavalue
      CHARACTER(LEN=1)    :: s_sing_mflag 
      CHARACTER(LEN=1)    :: s_sing_qflag
      CHARACTER(LEN=1)    :: s_sing_sflag
      CHARACTER(LEN=4)    :: s_sing_obstime

c************************************************************************
c      print*,'just entered get_lines_1file'

      OPEN(UNIT=1,FILE=TRIM(s_pathandname),FORM='formatted',
     +   STATUS='OLD',ACTION='READ')      

      ii=0
      i_len_max=0
      i_len_min=100

      DO 
c      Read data line
       READ(1,1002,IOSTAT=io) s_linget
1002   FORMAT(a50)
       IF (io .GT. 0) THEN
        WRITE(*,*) 'Check input. Something went wrong'
        GOTO 100
       ELSE IF (io .LT. 0) THEN 
c        WRITE(*,*) 'end of file reached'
        GOTO 100
       ELSE
        ii=ii+1

        IF (ii.GE.l_lines_rgh) THEN 
         STOP 'get_lines_1file2; ii GE l_lines_rgh'
        ENDIF

        i_len=LEN_TRIM(s_linget)
        i_len_max=MAX(i_len,i_len_max)
        i_len_min=MIN(i_len,i_len_min)

        IF (i_len.GE.50) THEN 
         STOP 'get_lines_1file; data line too long'
        ENDIF

c       Extract vectors from daily lines
        CALL get_fields_from_ghcnd_line2(s_linget,
     +   s_sing_id,s_sing_date_yyyymmdd,s_sing_element,s_sing_datavalue,
     +   s_sing_mflag,s_sing_qflag,s_sing_sflag,s_sing_obstime)

c        print*,'s_linget=',TRIM(s_linget)
c        PRINT*,'line elements',
c     +   s_sing_id,s_sing_date_yyyymmdd,s_sing_element,s_sing_datavalue,
c     +   s_sing_mflag,s_sing_qflag,s_sing_sflag,s_sing_obstime

c        STOP 'get_lines_1file2'
c        CALL SLEEP(1)

c       Archive values from lines
        s_arch_id(ii)           =s_sing_id
        s_arch_date_yyyymmdd(ii)=s_sing_date_yyyymmdd
        s_arch_element(ii)      =s_sing_element
        s_arch_datavalue(ii)    =s_sing_datavalue
        s_arch_mflag(ii)        =s_sing_mflag
        s_arch_qflag(ii)        =s_sing_qflag
        s_arch_sflag(ii)        =s_sing_sflag
        s_arch_obstime(ii)      =s_sing_obstime

       ENDIF
      ENDDO
100   CONTINUE

      CLOSE(UNIT=1)

      l_lines=ii

c*****
c     Crash program if l_lines greater than array size
      IF (l_lines.GT.l_lines_rgh) THEN
       print*,'l_lines over limit'
       STOP 'get_lines_1file2'
      ENDIF
c*****
c      print*,'l_lines=',l_lines
c      print*,'i_len_max,i_len_min=',i_len_max,i_len_min

c      print*,'just leaving get_lines_1file'      

      RETURN
      END
