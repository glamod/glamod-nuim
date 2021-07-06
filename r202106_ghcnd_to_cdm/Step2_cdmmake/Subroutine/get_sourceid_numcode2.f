c     Call subroutine to get source_id number code
c     AJ_Kettle, 09Dec2018

      SUBROUTINE get_sourceid_numcode2(l_timestamp_rgh,l_timestamp,
     +    s_prcp_sflag,s_tmin_sflag,s_tmax_sflag,
     +    s_tavg_sflag,s_snwd_sflag,s_snow_sflag,
     +    s_awnd_sflag,s_awdr_sflag,s_wesd_sflag,
     +    l_source_rgh,l_source,
     +    s_source_codeletter,s_source_codenumber,

     +    s_prcp_sourceid,s_tmin_sourceid,s_tmax_sourceid,
     +    s_tavg_sourceid,s_snwd_sourceid,s_snow_sourceid,
     +    s_awnd_sourceid,s_awdr_sourceid,s_wesd_sourceid)

      IMPLICIT NONE
c************************************************************************
c     Declare variables passed into program

      INTEGER             :: l_timestamp_rgh
      INTEGER             :: l_timestamp

      CHARACTER(LEN=1)    :: s_prcp_sflag(l_timestamp_rgh)
      CHARACTER(LEN=1)    :: s_tmin_sflag(l_timestamp_rgh)
      CHARACTER(LEN=1)    :: s_tmax_sflag(l_timestamp_rgh)
      CHARACTER(LEN=1)    :: s_tavg_sflag(l_timestamp_rgh)
      CHARACTER(LEN=1)    :: s_snwd_sflag(l_timestamp_rgh)
      CHARACTER(LEN=1)    :: s_snow_sflag(l_timestamp_rgh)
      CHARACTER(LEN=1)    :: s_awnd_sflag(l_timestamp_rgh)
      CHARACTER(LEN=1)    :: s_awdr_sflag(l_timestamp_rgh)
      CHARACTER(LEN=1)    :: s_wesd_sflag(l_timestamp_rgh)

      INTEGER             :: l_source_rgh
      INTEGER             :: l_source
      CHARACTER(LEN=1)    :: s_source_codeletter(l_source_rgh)
      CHARACTER(LEN=3)    :: s_source_codenumber(l_source_rgh)

      CHARACTER(LEN=3)    :: s_prcp_sourceid(l_timestamp_rgh)
      CHARACTER(LEN=3)    :: s_tmin_sourceid(l_timestamp_rgh)
      CHARACTER(LEN=3)    :: s_tmax_sourceid(l_timestamp_rgh)
      CHARACTER(LEN=3)    :: s_tavg_sourceid(l_timestamp_rgh)
      CHARACTER(LEN=3)    :: s_snwd_sourceid(l_timestamp_rgh)
      CHARACTER(LEN=3)    :: s_snow_sourceid(l_timestamp_rgh)
      CHARACTER(LEN=3)    :: s_awnd_sourceid(l_timestamp_rgh)
      CHARACTER(LEN=3)    :: s_awdr_sourceid(l_timestamp_rgh)
      CHARACTER(LEN=3)    :: s_wesd_sourceid(l_timestamp_rgh)
c*****
c     Variables used in subroutine
      INTEGER             :: i,j,k,ii,jj,kk
c************************************************************************
c      print*,'just entered get_sourceid_numcode'

c     1.prcp: Get sourceid for single variable
      CALL get_source_id_single2(l_source_rgh,l_source,
     +  s_source_codeletter,s_source_codenumber,
     +  l_timestamp_rgh,l_timestamp,s_prcp_sflag, 
     +  s_prcp_sourceid)

c     2.tmin: Get sourceid for single variable
      CALL get_source_id_single2(l_source_rgh,l_source,
     +  s_source_codeletter,s_source_codenumber,
     +  l_timestamp_rgh,l_timestamp,s_tmin_sflag, 
     +  s_tmin_sourceid)

c     3.tmax: Get sourceid for single variable
      CALL get_source_id_single2(l_source_rgh,l_source,
     +  s_source_codeletter,s_source_codenumber,
     +  l_timestamp_rgh,l_timestamp,s_tmax_sflag, 
     +  s_tmax_sourceid)

c     4.tavg: Get sourceid for single variable
      CALL get_source_id_single2(l_source_rgh,l_source,
     +  s_source_codeletter,s_source_codenumber,
     +  l_timestamp_rgh,l_timestamp,s_tavg_sflag, 
     +  s_tavg_sourceid)

c     5.snwd: Get sourceid for single variable
      CALL get_source_id_single2(l_source_rgh,l_source,
     +  s_source_codeletter,s_source_codenumber,
     +  l_timestamp_rgh,l_timestamp,s_snwd_sflag, 
     +  s_snwd_sourceid)

c     6.snow: Get sourceid for single variable
      CALL get_source_id_single2(l_source_rgh,l_source,
     +  s_source_codeletter,s_source_codenumber,
     +  l_timestamp_rgh,l_timestamp,s_snow_sflag, 
     +  s_snow_sourceid)

c     7.awnd: Get sourceid for single variable
      CALL get_source_id_single2(l_source_rgh,l_source,
     +  s_source_codeletter,s_source_codenumber,
     +  l_timestamp_rgh,l_timestamp,s_awnd_sflag, 
     +  s_awnd_sourceid)

c     8.awdr: Get sourceid for single variable
      CALL get_source_id_single2(l_source_rgh,l_source,
     +  s_source_codeletter,s_source_codenumber,
     +  l_timestamp_rgh,l_timestamp,s_awdr_sflag, 
     +  s_awdr_sourceid)

c     9.wesd: Get sourceid for single variable
      CALL get_source_id_single2(l_source_rgh,l_source,
     +  s_source_codeletter,s_source_codenumber,
     +  l_timestamp_rgh,l_timestamp,s_wesd_sflag, 
     +  s_wesd_sourceid)

c      print*,'prcp sourceid=',(s_prcp_sourceid(i),i=1,5)
c      print*,'tmin_sourceid=',(s_tmin_sourceid(i),i=1,5)
c      CHARACTER(LEN=3)    :: s_tmax_sourceid
c      CHARACTER(LEN=3)    :: s_tavg_sourceid
c      CHARACTER(LEN=3)    :: s_snwd_sourceid
c      CHARACTER(LEN=3)    :: s_snow_sourceid
c      CHARACTER(LEN=3)    :: s_awnd_sourceid
c      CHARACTER(LEN=3)    :: s_awdr_sourceid(l_timestamp_rgh)
c      CHARACTER(LEN=3)    :: s_wesd_sourceid(l_timestamp_rgh)

c      print*,'just leaving get_sourceid_numcode2'
c      STOP 'get_sourceid_numcode2'

      RETURN
      END
