c     Subroutine to resolve qc info
c     AJ_Kettle, 14Dec2020
c     01Feb2021: slave designations for variables passed into subroutine

      SUBROUTINE resolve_qc_single_param(
     +  s_qckey_timescale_spec,l_qckey,
     +  s_qckey_sourceflag,s_qckey_c3sflag,s_qckey_timescale,
     +  l_timestamp_rgh,l_timestamp,
     +  s_prcp_qflag,

     +  s_prcp_cdmqc,s_prcp_cdmqcmethod,
     +  i_cnt_qc)

      IMPLICIT NONE
c************************************************************************
c     Variables passed into subroutine

      CHARACTER(LEN=300)  :: s_qckey_timescale_spec
      INTEGER             :: l_qckey
      CHARACTER(LEN=*)    :: s_qckey_sourceflag(100)             !2
      CHARACTER(LEN=*)    :: s_qckey_c3sflag(100)                !2
      CHARACTER(LEN=300)  :: s_qckey_timescale(100) 

      INTEGER             :: l_timestamp_rgh
      INTEGER             :: l_timestamp

      CHARACTER(LEN=*)    :: s_prcp_qflag(l_timestamp_rgh)       !1

      CHARACTER(LEN=*)    :: s_prcp_cdmqc(l_timestamp_rgh)       !1
      CHARACTER(LEN=*)    :: s_prcp_cdmqcmethod(l_timestamp_rgh) !2

      INTEGER             :: i_cnt_qc
c******
c     Variables used in subroutine
      INTEGER             :: i,j,k,ii,jj,kk

      INTEGER             :: ilen
c************************************************************************
      ii=0

      DO i=1,l_timestamp

c      Initialize
       s_prcp_cdmqc(i)='0'
       s_prcp_cdmqcmethod(i)=''

       ilen=LEN_TRIM(s_prcp_qflag(i))

c      act if something in source qc field
       IF (ilen.GT.0) THEN
        s_prcp_cdmqc(i)='1'

c        print*,'problem identified',i,ilen,s_prcp_qflag(i)
c        print*,'s_qckey_timescale_spec=',TRIM(s_qckey_timescale_spec)

        DO j=1,l_qckey
c        Match time scales
         IF (TRIM(s_qckey_timescale(j)).EQ.TRIM(s_qckey_timescale_spec))
     +     THEN
c        comparing 1 & 2 element string
         IF (TRIM(s_prcp_qflag(i)).EQ.TRIM(s_qckey_sourceflag(j))) THEN
c          print*,'match found'
          ii=ii+1
          s_prcp_cdmqcmethod(i)=TRIM(ADJUSTL(s_qckey_c3sflag(j)))   !both length 2
          GOTO 10
         ENDIF
         ENDIF
        ENDDO

        print*,'problem: qc flag info not found',
     +    '='//TRIM(s_prcp_qflag(i))//'='

        DO j=1,l_qckey
         print*,'j=',j,'='//TRIM(s_qckey_sourceflag(j))//'='
        ENDDO

        STOP 'qc_converter'

 10     CONTINUE
       ENDIF

      ENDDO

      i_cnt_qc=ii

c      print*,'ii=',ii,l_timestamp

      RETURN
      END
