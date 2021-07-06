c     Subroutine find cdmqc and cdmqcmethod
c     AJ_Kettle, 11Dec2020

      SUBROUTINE qc_converter(s_qckey_timescale_spec,l_qckey,
     +    s_qckey_sourceflag,s_qckey_c3sflag,s_qckey_timescale,
     +    l_timestamp_rgh,l_timestamp,
     +    s_prcp_qflag,
     +    s_tmin_qflag,s_tmax_qflag,s_tavg_qflag,
     +    s_snwd_qflag,s_snow_qflag, 
     +    s_awnd_qflag,s_awdr_qflag,s_wesd_qflag,
  
     +    s_prcp_cdmqc,s_tmin_cdmqc,s_tmax_cdmqc,
     +    s_tavg_cdmqc,s_snwd_cdmqc,s_snow_cdmqc,
     +    s_awnd_cdmqc,s_awdr_cdmqc,s_wesd_cdmqc,
     +    s_prcp_cdmqcmethod,s_tmin_cdmqcmethod,s_tmax_cdmqcmethod,
     +    s_tavg_cdmqcmethod,s_snwd_cdmqcmethod,s_snow_cdmqcmethod,
     +    s_awnd_cdmqcmethod,s_awdr_cdmqcmethod,s_wesd_cdmqcmethod)

      IMPLICIT NONE
c************************************************************************
      CHARACTER(LEN=300)  :: s_qckey_timescale_spec
      INTEGER             :: l_qckey
      CHARACTER(LEN=2)    :: s_qckey_sourceflag(100)
      CHARACTER(LEN=2)    :: s_qckey_c3sflag(100)
      CHARACTER(LEN=300)  :: s_qckey_timescale(100) 

      INTEGER             :: l_timestamp_rgh
      INTEGER             :: l_timestamp

c     1-char GHCND flag from file (i.e., method)
      CHARACTER(LEN=1)    :: s_prcp_qflag(l_timestamp_rgh)
      CHARACTER(LEN=1)    :: s_tmin_qflag(l_timestamp_rgh)
      CHARACTER(LEN=1)    :: s_tmax_qflag(l_timestamp_rgh)
      CHARACTER(LEN=1)    :: s_tavg_qflag(l_timestamp_rgh)
      CHARACTER(LEN=1)    :: s_snwd_qflag(l_timestamp_rgh)
      CHARACTER(LEN=1)    :: s_snow_qflag(l_timestamp_rgh)
      CHARACTER(LEN=1)    :: s_awnd_qflag(l_timestamp_rgh)
      CHARACTER(LEN=1)    :: s_awdr_qflag(l_timestamp_rgh)
      CHARACTER(LEN=1)    :: s_wesd_qflag(l_timestamp_rgh)

c     1-char qc number flag placed in cdm files 
      CHARACTER(LEN=1)    :: s_prcp_cdmqc(l_timestamp_rgh)
      CHARACTER(LEN=1)    :: s_tmin_cdmqc(l_timestamp_rgh)
      CHARACTER(LEN=1)    :: s_tmax_cdmqc(l_timestamp_rgh)
      CHARACTER(LEN=1)    :: s_tavg_cdmqc(l_timestamp_rgh)
      CHARACTER(LEN=1)    :: s_snwd_cdmqc(l_timestamp_rgh)
      CHARACTER(LEN=1)    :: s_snow_cdmqc(l_timestamp_rgh)
      CHARACTER(LEN=1)    :: s_awnd_cdmqc(l_timestamp_rgh)
      CHARACTER(LEN=1)    :: s_awdr_cdmqc(l_timestamp_rgh)
      CHARACTER(LEN=1)    :: s_wesd_cdmqc(l_timestamp_rgh)

c     
      CHARACTER(LEN=2)    :: s_prcp_cdmqcmethod(l_timestamp_rgh)
      CHARACTER(LEN=2)    :: s_tmin_cdmqcmethod(l_timestamp_rgh)
      CHARACTER(LEN=2)    :: s_tmax_cdmqcmethod(l_timestamp_rgh)
      CHARACTER(LEN=2)    :: s_tavg_cdmqcmethod(l_timestamp_rgh)
      CHARACTER(LEN=2)    :: s_snwd_cdmqcmethod(l_timestamp_rgh)
      CHARACTER(LEN=2)    :: s_snow_cdmqcmethod(l_timestamp_rgh)
      CHARACTER(LEN=2)    :: s_awnd_cdmqcmethod(l_timestamp_rgh)
      CHARACTER(LEN=2)    :: s_awdr_cdmqcmethod(l_timestamp_rgh)
      CHARACTER(LEN=2)    :: s_wesd_cdmqcmethod(l_timestamp_rgh)

      INTEGER             :: i_cnt_qc_prcp
      INTEGER             :: i_cnt_qc_tmin
      INTEGER             :: i_cnt_qc_tmax
      INTEGER             :: i_cnt_qc_tavg
      INTEGER             :: i_cnt_qc_snwd
      INTEGER             :: i_cnt_qc_snow
      INTEGER             :: i_cnt_qc_awnd
      INTEGER             :: i_cnt_qc_awdr
      INTEGER             :: i_cnt_qc_wesd

c*****
c*****
c     Declare variables used in subroutine

      INTEGER             :: i,j,k,ii,jj,kk

      INTEGER             :: ilen
      INTEGER             :: i_tot
c************************************************************************
c      print*,'just entered qc_converter'

c      print*,'l_qckey=',l_qckey

c     PRCP
      CALL resolve_qc_single_param(
     +  s_qckey_timescale_spec,l_qckey,
     +  s_qckey_sourceflag,s_qckey_c3sflag,s_qckey_timescale,
     +  l_timestamp_rgh,l_timestamp,
     +  s_prcp_qflag,

     +  s_prcp_cdmqc,s_prcp_cdmqcmethod,
     +  i_cnt_qc_prcp)

cc     Check 
c      DO i=1,l_timestamp
c       IF (s_prcp_cdmqc(i).NE.'0') THEN
c        print*,'prcp flag',i,
c     +s_prcp_qflag(i)//'='//s_prcp_cdmqc(i)//'='//s_prcp_cdmqcmethod(i)
c       ENDIF
c      ENDDO
c      STOP 'qc_converter'

c     TMIN
      CALL resolve_qc_single_param(
     +  s_qckey_timescale_spec,l_qckey,
     +  s_qckey_sourceflag,s_qckey_c3sflag,s_qckey_timescale,
     +  l_timestamp_rgh,l_timestamp,
     +  s_tmin_qflag,

     +  s_tmin_cdmqc,s_tmin_cdmqcmethod,
     +  i_cnt_qc_tmin)

cc     Check 
c      DO i=1,l_timestamp
c       IF (s_prcp_cdmqc(i).NE.'0') THEN
c        print*,'prcp flag',i,
c     +s_prcp_qflag(i)//'='//s_prcp_cdmqc(i)//'='//s_prcp_cdmqcmethod(i)
c       ENDIF
c      ENDDO
c      STOP 'qc_converter'

c     TMAX
      CALL resolve_qc_single_param(
     +  s_qckey_timescale_spec,l_qckey,
     +  s_qckey_sourceflag,s_qckey_c3sflag,s_qckey_timescale,
     +  l_timestamp_rgh,l_timestamp,
     +  s_tmax_qflag,

     +  s_tmax_cdmqc,s_tmax_cdmqcmethod,
     +  i_cnt_qc_tmax)

cc     Check 
c      DO i=1,l_timestamp
c       IF (s_prcp_cdmqc(i).NE.'0') THEN
c        print*,'prcp flag',i,
c     +s_prcp_qflag(i)//'='//s_prcp_cdmqc(i)//'='//s_prcp_cdmqcmethod(i)
c       ENDIF
c      ENDDO
c      STOP 'qc_converter'

c     TAVG
      CALL resolve_qc_single_param(
     +  s_qckey_timescale_spec,l_qckey,
     +  s_qckey_sourceflag,s_qckey_c3sflag,s_qckey_timescale,
     +  l_timestamp_rgh,l_timestamp,
     +  s_tavg_qflag,

     +  s_tavg_cdmqc,s_tavg_cdmqcmethod,
     +  i_cnt_qc_tavg)

cc     Check 
c      DO i=1,l_timestamp
c       IF (s_prcp_cdmqc(i).NE.'0') THEN
c        print*,'prcp flag',i,
c     +s_prcp_qflag(i)//'='//s_prcp_cdmqc(i)//'='//s_prcp_cdmqcmethod(i)
c       ENDIF
c      ENDDO
c      STOP 'qc_converter'

c     SNWD
      CALL resolve_qc_single_param(
     +  s_qckey_timescale_spec,l_qckey,
     +  s_qckey_sourceflag,s_qckey_c3sflag,s_qckey_timescale,
     +  l_timestamp_rgh,l_timestamp,
     +  s_snwd_qflag,

     +  s_snwd_cdmqc,s_snwd_cdmqcmethod,
     +  i_cnt_qc_snwd)

cc     Check 
c      DO i=1,l_timestamp
c       IF (s_prcp_cdmqc(i).NE.'0') THEN
c        print*,'prcp flag',i,
c     +s_prcp_qflag(i)//'='//s_prcp_cdmqc(i)//'='//s_prcp_cdmqcmethod(i)
c       ENDIF
c      ENDDO
c      STOP 'qc_converter'

c     SNOW
      CALL resolve_qc_single_param(
     +  s_qckey_timescale_spec,l_qckey,
     +  s_qckey_sourceflag,s_qckey_c3sflag,s_qckey_timescale,
     +  l_timestamp_rgh,l_timestamp,
     +  s_snow_qflag,

     +  s_snow_cdmqc,s_snow_cdmqcmethod,
     +  i_cnt_qc_snow)

cc     Check 
c      DO i=1,l_timestamp
c       IF (s_prcp_cdmqc(i).NE.'0') THEN
c        print*,'prcp flag',i,
c     +s_prcp_qflag(i)//'='//s_prcp_cdmqc(i)//'='//s_prcp_cdmqcmethod(i)
c       ENDIF
c      ENDDO
c      STOP 'qc_converter'

c     AWND
      CALL resolve_qc_single_param(
     +  s_qckey_timescale_spec,l_qckey,
     +  s_qckey_sourceflag,s_qckey_c3sflag,s_qckey_timescale,
     +  l_timestamp_rgh,l_timestamp,
     +  s_awnd_qflag,

     +  s_awnd_cdmqc,s_awnd_cdmqcmethod,
     +  i_cnt_qc_awnd)

cc     Check 
c      DO i=1,l_timestamp
c       IF (s_prcp_cdmqc(i).NE.'0') THEN
c        print*,'prcp flag',i,
c     +s_prcp_qflag(i)//'='//s_prcp_cdmqc(i)//'='//s_prcp_cdmqcmethod(i)
c       ENDIF
c      ENDDO
c      STOP 'qc_converter'

c     AWDR
      CALL resolve_qc_single_param(
     +  s_qckey_timescale_spec,l_qckey,
     +  s_qckey_sourceflag,s_qckey_c3sflag,s_qckey_timescale,
     +  l_timestamp_rgh,l_timestamp,
     +  s_awdr_qflag,

     +  s_awdr_cdmqc,s_awdr_cdmqcmethod,
     +  i_cnt_qc_awdr)

cc     Check 
c      DO i=1,l_timestamp
c       IF (s_prcp_cdmqc(i).NE.'0') THEN
c        print*,'prcp flag',i,
c     +s_prcp_qflag(i)//'='//s_prcp_cdmqc(i)//'='//s_prcp_cdmqcmethod(i)
c       ENDIF
c      ENDDO
c      STOP 'qc_converter'

c     WESD
      CALL resolve_qc_single_param(
     +  s_qckey_timescale_spec,l_qckey,
     +  s_qckey_sourceflag,s_qckey_c3sflag,s_qckey_timescale,
     +  l_timestamp_rgh,l_timestamp,
     +  s_wesd_qflag,

     +  s_wesd_cdmqc,s_wesd_cdmqcmethod,
     +  i_cnt_qc_wesd)

c     print results if any qc flags found
      i_tot=i_cnt_qc_prcp+i_cnt_qc_tmin+i_cnt_qc_tmax+
     +      i_cnt_qc_tavg+i_cnt_qc_snwd+i_cnt_qc_snow+
     +      i_cnt_qc_awnd+i_cnt_qc_awdr+i_cnt_qc_wesd
      IF (i_tot.GT.0) THEN 
       print*,'i_cnt_qc=',
     +  i_cnt_qc_prcp,i_cnt_qc_tmin,i_cnt_qc_tmax,
     +  i_cnt_qc_tavg,i_cnt_qc_snwd,i_cnt_qc_snow,
     +  i_cnt_qc_awnd,i_cnt_qc_awdr,i_cnt_qc_wesd
c       STOP 'qc_converter'
      ENDIF

c     Check 
c      DO i=1,l_timestamp
c       IF (s_prcp_cdmqc(i).NE.'0') THEN
c        print*,'prcp flag',i,
c     +s_prcp_qflag(i)//'='//s_prcp_cdmqc(i)//'='//s_prcp_cdmqcmethod(i)
c       ENDIF
c      ENDDO

c      STOP 'qc_converter'

      RETURN
      END
