c     Subroutine to get QC flag from attributes     
c     AJ_Kettle, 12Nov 2018

c     subroutine structure
c     get_qc_from_attrib
c     -qc_checker

      SUBROUTINE get_qc_from_attrib20210204(l_rgh_lines,l_lines,
     +    s_vec_tmax_attrib,s_vec_tmin_attrib,s_vec_tavg_attrib,
     +    s_vec_prcp_attrib,s_vec_snow_attrib,s_vec_awnd_attrib,
     +    s_vec_tmax_qc,s_vec_tmin_qc,s_vec_tavg_qc,
     +    s_vec_prcp_qc,s_vec_snow_qc,s_vec_awnd_qc,

     +    s_vec_tmax_qc_ncepcode,s_vec_tmin_qc_ncepcode,
     +    s_vec_tavg_qc_ncepcode,s_vec_prcp_qc_ncepcode,
     +    s_vec_snow_qc_ncepcode,s_vec_awnd_qc_ncepcode)

      IMPLICIT NONE
c************************************************************************
c     Variables passed into program

      INTEGER             :: l_rgh_lines
      INTEGER             :: l_lines
      CHARACTER(LEN=10)   :: s_vec_tmax_attrib(l_rgh_lines)
      CHARACTER(LEN=10)   :: s_vec_tmin_attrib(l_rgh_lines)
      CHARACTER(LEN=10)   :: s_vec_tavg_attrib(l_rgh_lines)
      CHARACTER(LEN=10)   :: s_vec_prcp_attrib(l_rgh_lines)
      CHARACTER(LEN=10)   :: s_vec_snow_attrib(l_rgh_lines)
      CHARACTER(LEN=10)   :: s_vec_awnd_attrib(l_rgh_lines)

      CHARACTER(LEN=1)    :: s_vec_tmax_qc(l_rgh_lines)
      CHARACTER(LEN=1)    :: s_vec_tmin_qc(l_rgh_lines)
      CHARACTER(LEN=1)    :: s_vec_tavg_qc(l_rgh_lines)
      CHARACTER(LEN=1)    :: s_vec_prcp_qc(l_rgh_lines)
      CHARACTER(LEN=1)    :: s_vec_snow_qc(l_rgh_lines)
      CHARACTER(LEN=1)    :: s_vec_awnd_qc(l_rgh_lines)

      CHARACTER(LEN=1)    :: s_vec_tmax_qc_ncepcode(l_rgh_lines)
      CHARACTER(LEN=1)    :: s_vec_tmin_qc_ncepcode(l_rgh_lines)
      CHARACTER(LEN=1)    :: s_vec_tavg_qc_ncepcode(l_rgh_lines)
      CHARACTER(LEN=1)    :: s_vec_prcp_qc_ncepcode(l_rgh_lines)
      CHARACTER(LEN=1)    :: s_vec_snow_qc_ncepcode(l_rgh_lines)
      CHARACTER(LEN=1)    :: s_vec_awnd_qc_ncepcode(l_rgh_lines)

c      INTEGER             :: i_len
c      INTEGER             :: i_comma_pos(5)
c      INTEGER             :: i_comma_cnt

c      CHARACTER(LEN=10)   :: s_single

      INTEGER             :: i,j,k,ii,jj,kk

c      INTEGER             :: i_qc_delchar
c************************************************************************
c      print*,'just entered get_qc_from_attrib'

c      print*,'s_vec_tmax_attrib='//s_vec_tmax_attrib(1)//'='
c      print*,'s_vec_tmin_attrib='//s_vec_tmin_attrib(1)//'='
c      print*,'s_vec_tavg_attrib='//s_vec_tavg_attrib(1)//'='
c      print*,'s_vec_prcp_attrib='//s_vec_prcp_attrib(1)//'='
c      print*,'s_vec_snow_attrib='//s_vec_snow_attrib(1)//'='
c      print*,'s_vec_awnd_attrib='//s_vec_awnd_attrib(1)//'='
c*****
c     TMAX - QC checker package
c     from gsom_doc.doc: attribute structure: a,M,Q,S
c     a=number of days from 1-5 missing or flagged
c     M=GHCND dataset measurement flag
c     Q=QHCND dataset quality measurement flag
c     s=GHCND dataset source code
c     use pass=0 as default; any QC flag means fail=1
      CALL qc_checker20210204(l_rgh_lines,l_lines,s_vec_tmax_attrib,
     +  s_vec_tmax_qc,
     +  s_vec_tmax_qc_ncepcode)

c     TMIN - QC checker package
c     from gsom_doc.doc: attribute structure: a,M,Q,S
c     a=number of days from 1-5 missing or flagged
c     M=GHCND dataset measurement flag
c     Q=QHCND dataset quality measurement flag
c     s=GHCND dataset source code
c     use pass=0 as default; any QC flag means fail=1
      CALL qc_checker20210204(l_rgh_lines,l_lines,s_vec_tmin_attrib,
     +  s_vec_tmin_qc,
     +  s_vec_tmin_qc_ncepcode)

c     TAVG hardwire with missing flag
c     from gsom_doc.doc: attribute structure: a,S
c     a=number of days missing from 1-5
c     S=GHCND Dataset source code
      DO i=1,l_lines 
       s_vec_tavg_qc(i)='3'   !flagged as missing because no explicit flag
       s_vec_tavg_qc_ncepcode(i)='' !blank value
      ENDDO

c     PRCP - QC checker package
c     from gsom_doc.doc: attribute structure: a,M,Q,S
c     a=number of days from 1-5 missing or flagged
c     M=GHCND dataset measurement flag
c     Q=QHCND dataset quality measurement flag
c     s=GHCND dataset source code
c     use pass=0 as default; any QC flag means fail=1
      CALL qc_checker20210204(l_rgh_lines,l_lines,s_vec_prcp_attrib,
     +  s_vec_prcp_qc,
     +  s_vec_prcp_qc_ncepcode)

c     SNOW - QC checker package
c     from gsom_doc.doc: attribute structure: a,M,Q,S
c     a=number of days from 1-5 missing or flagged
c     M=GHCND dataset measurement flag
c     Q=QHCND dataset quality measurement flag
c     s=GHCND dataset source code
c     use pass=0 as default; any QC flag means fail=1
      CALL qc_checker20210204(l_rgh_lines,l_lines,s_vec_snow_attrib,
     +  s_vec_snow_qc,
     +  s_vec_snow_qc_ncepcode)

c     AWND hardwire with missing flag
c     from gsom_doc.doc: attribute structure: a,S
c     a=number of days missing from 1-5
c     S=GHCND Dataset source code
      DO i=1,l_lines 
       s_vec_awnd_qc(i)='3'
       s_vec_awnd_qc_ncepcode(i)='' !blank value
      ENDDO
c*****
c      print*,'l_lines=',l_lines
c      print*,'s_vec_tmax_qc=',(s_vec_tmax_qc(i),i=1,l_lines)
c      print*,'s_vec_tmin_qc=',(s_vec_tmin_qc(i),i=1,l_lines)
c      print*,'s_vec_tavg_qc=',(s_vec_tavg_qc(i),i=1,l_lines)
c      print*,'s_vec_prcp_qc=',(s_vec_prcp_qc(i),i=1,l_lines)
c      print*,'s_vec_snow_qc=',(s_vec_snow_qc(i),i=1,l_lines)
c      print*,'s_vec_awnd_qc=',(s_vec_awnd_qc(i),i=1,l_lines)
c************************************************************************
c      print*,'just leaving get_qc_from_attrib'
c      STOP 'get_qc_from_attrib'

      RETURN
      END
