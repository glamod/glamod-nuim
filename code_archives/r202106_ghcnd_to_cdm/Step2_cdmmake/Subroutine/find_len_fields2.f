c     Subroutine to check valid entries in each field
c     AJ_Kettle, 06Dec2018

      SUBROUTINE find_len_fields2(l_lines_rgh,l_lines,
     +  s_arch_id,s_arch_date_yyyymmdd,s_arch_element,s_arch_datavalue,
     +  s_arch_mflag,s_arch_qflag,s_arch_sflag,s_arch_obstime)

      IMPLICIT NONE
c************************************************************************
c     Declare variables passed into program

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
c     Variables used within program

      INTEGER             :: i,j,k,ii,jj,kk

      INTEGER             :: i_len_datavalue
      INTEGER             :: i_lenmin_datavalue
      INTEGER             :: i_lenmax_datavalue

      INTEGER             :: i_len_mflag
      INTEGER             :: i_lenmin_mflag
      INTEGER             :: i_lenmax_mflag

      INTEGER             :: i_len_qflag
      INTEGER             :: i_lenmin_qflag
      INTEGER             :: i_lenmax_qflag

      INTEGER             :: i_len_sflag
      INTEGER             :: i_lenmin_sflag
      INTEGER             :: i_lenmax_sflag

      INTEGER             :: i_len_obstime
      INTEGER             :: i_lenmin_obstime
      INTEGER             :: i_lenmax_obstime
c************************************************************************
c      print*,'just inside find_len_fields'

      i_lenmin_datavalue=10
      i_lenmax_datavalue=0

      i_lenmin_mflag=10
      i_lenmax_mflag=0

      i_lenmin_qflag=10
      i_lenmax_qflag=0

      i_lenmin_sflag=10
      i_lenmax_sflag=0

      i_lenmin_obstime=10
      i_lenmax_obstime=0

      DO i=1,l_lines
       i_len_datavalue   =LEN_TRIM(s_arch_datavalue(i))
       i_lenmin_datavalue=MIN(i_lenmin_datavalue,i_len_datavalue)
       i_lenmax_datavalue=MAX(i_lenmax_datavalue,i_len_datavalue)

       i_len_mflag       =LEN_TRIM(s_arch_mflag(i))
       i_lenmin_mflag    =MIN(i_lenmin_mflag,i_len_mflag)
       i_lenmax_mflag    =MAX(i_lenmax_mflag,i_len_mflag)
 
       i_len_qflag       =LEN_TRIM(s_arch_qflag(i))
       i_lenmin_qflag    =MIN(i_lenmin_qflag,i_len_qflag)
       i_lenmax_qflag    =MAX(i_lenmax_qflag,i_len_qflag)

       i_len_sflag       =LEN_TRIM(s_arch_sflag(i))
       i_lenmin_sflag    =MIN(i_lenmin_sflag,i_len_sflag)
       i_lenmax_sflag    =MAX(i_lenmax_sflag,i_len_sflag)

       i_len_obstime     =LEN_TRIM(s_arch_obstime(i))
       i_lenmin_obstime  =MIN(i_lenmin_obstime,i_len_obstime)
       i_lenmax_obstime  =MAX(i_lenmax_obstime,i_len_obstime)
      ENDDO

c     Case of zero-length sflag
      IF (i_lenmin_sflag.EQ.0) THEN 
       STOP 'find_len_field; zero-length i_lenmin_sflag'
      ENDIF
c********************************************************
      GOTO 10

c     Test specific elements
      DO i=1,l_lines
       IF (s_arch_element(i).EQ.'TMIN') THEN 
        IF (TRIM(s_arch_datavalue(i)).EQ.'932') THEN
         print*,'TMIN FAILURE 932'
         print*,'i',i
         print*,'id',s_arch_id(i)
         print*,'date',s_arch_date_yyyymmdd(i)
         print*,'element',s_arch_element(i)
         print*,'datavalue',s_arch_datavalue(i)
         print*,'mflag',s_arch_mflag(i)
         print*,'qflag',s_arch_qflag(i)
         print*,'sflag',s_arch_sflag(i)
         print*,'obstime',s_arch_obstime(i)

         STOP 'find_len_field; specific value look'
        ENDIF
       ENDIF 
      ENDDO

 10   CONTINUE

c      IF (i_lenmax_obstime.GT.0) THEN 
c       print*,'i_lenmax_obstime=',i_lenmax_obstime
c       STOP 'find_len_fields'
c      ENDIF

c      print*,'just leaving find_len_fields'

c      STOP 'find_len_fields'

      RETURN
      END
