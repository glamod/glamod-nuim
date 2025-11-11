c     Subroutine to set qcmethod code
c     AJ_Kettle, 05Feb2021

      SUBROUTINE set_qcmethod_code(s_qckey_timescale_spec,l_qckey,
     +    s_qckey_sourceflag,s_qckey_c3sflag,s_qckey_timescale,
     +    l_rgh_lines,l_lines,
     +    s_vec_tmax_qc,s_vec_tmin_qc,s_vec_tavg_qc,
     +    s_vec_prcp_qc,s_vec_snow_qc,s_vec_awnd_qc,
     +    s_vec_tmax_qc_ncepcode,s_vec_tmin_qc_ncepcode,
     +    s_vec_tavg_qc_ncepcode,s_vec_prcp_qc_ncepcode,
     +    s_vec_snow_qc_ncepcode,s_vec_awnd_qc_ncepcode,

     +    s_vec_tmax_qc_cdmqcmethod,s_vec_tmin_qc_cdmqcmethod,
     +    s_vec_tavg_qc_cdmqcmethod,s_vec_prcp_qc_cdmqcmethod,
     +    s_vec_snow_qc_cdmqcmethod,s_vec_awnd_qc_cdmqcmethod)

c************************************************************************
c     09Dec2020: qc_key information
      CHARACTER(LEN=300)  :: s_qckey_timescale_spec
      INTEGER             :: l_qckey
      CHARACTER(LEN=2)    :: s_qckey_sourceflag(100)
      CHARACTER(LEN=2)    :: s_qckey_c3sflag(100)
      CHARACTER(LEN=300)  :: s_qckey_timescale(100) 

      INTEGER             :: l_rgh_lines
      INTEGER             :: l_lines

c     Variables to assess qc
      CHARACTER(LEN=*)    :: s_vec_tmax_qc(l_rgh_lines)
      CHARACTER(LEN=*)    :: s_vec_tmin_qc(l_rgh_lines)
      CHARACTER(LEN=*)    :: s_vec_tavg_qc(l_rgh_lines)
      CHARACTER(LEN=*)    :: s_vec_prcp_qc(l_rgh_lines)
      CHARACTER(LEN=*)    :: s_vec_snow_qc(l_rgh_lines)
      CHARACTER(LEN=*)    :: s_vec_awnd_qc(l_rgh_lines)

      CHARACTER(LEN=*)    :: s_vec_tmax_qc_ncepcode(l_rgh_lines)
      CHARACTER(LEN=*)    :: s_vec_tmin_qc_ncepcode(l_rgh_lines)
      CHARACTER(LEN=*)    :: s_vec_tavg_qc_ncepcode(l_rgh_lines)
      CHARACTER(LEN=*)    :: s_vec_prcp_qc_ncepcode(l_rgh_lines)
      CHARACTER(LEN=*)    :: s_vec_snow_qc_ncepcode(l_rgh_lines)
      CHARACTER(LEN=*)    :: s_vec_awnd_qc_ncepcode(l_rgh_lines)

      CHARACTER(LEN=*)    :: s_vec_tmax_qc_cdmqcmethod(l_rgh_lines)
      CHARACTER(LEN=*)    :: s_vec_tmin_qc_cdmqcmethod(l_rgh_lines)
      CHARACTER(LEN=*)    :: s_vec_tavg_qc_cdmqcmethod(l_rgh_lines)
      CHARACTER(LEN=*)    :: s_vec_prcp_qc_cdmqcmethod(l_rgh_lines)
      CHARACTER(LEN=*)    :: s_vec_snow_qc_cdmqcmethod(l_rgh_lines)
      CHARACTER(LEN=*)    :: s_vec_awnd_qc_cdmqcmethod(l_rgh_lines)
c*****
c*****
c     Variables used within subroutine

      INTEGER             :: i,j,k,ii,jj,kk

      INTEGER             :: i_cnt_qc_tmax
c************************************************************************

c      print*,'s_qckey_timescale_spec=',TRIM(s_qckey_timescale_spec)
c      print*,'l_qckey=',l_qckey
c      print*,'s_qckey_sourceflag=',
c     +  (TRIM(s_qckey_sourceflag(i)),i=1,l_qckey)
c      print*,'s_qckey_c3sflag=',
c     +  (TRIM(s_qckey_c3sflag(i)),i=1,l_qckey)
c      print*,'s_qckey_timescale=',
c     +  (TRIM(s_qckey_timescale(i)),i=1,l_qckey)

c     TMAX
      CALL resolve_qc_single_param20210205(
     +  s_qckey_timescale_spec,l_qckey,
     +  s_qckey_sourceflag,s_qckey_c3sflag,s_qckey_timescale,
     +  l_rgh_lines,l_lines,
     +  s_vec_tmax_qc,s_vec_tmax_qc_ncepcode,

     +  s_vec_tmax_qc_cdmqcmethod,
     +  i_cnt_qc_tmax)

c     TMIN
      CALL resolve_qc_single_param20210205(
     +  s_qckey_timescale_spec,l_qckey,
     +  s_qckey_sourceflag,s_qckey_c3sflag,s_qckey_timescale,
     +  l_rgh_lines,l_lines,
     +  s_vec_tmin_qc,s_vec_tmin_qc_ncepcode,

     +  s_vec_tmin_qc_cdmqcmethod,
     +  i_cnt_qc_tmin)

c     TAVG
      CALL resolve_qc_single_param20210205(
     +  s_qckey_timescale_spec,l_qckey,
     +  s_qckey_sourceflag,s_qckey_c3sflag,s_qckey_timescale,
     +  l_rgh_lines,l_lines,
     +  s_vec_tavg_qc,s_vec_tavg_qc_ncepcode,

     +  s_vec_tavg_qc_cdmqcmethod,
     +  i_cnt_qc_tavg)

c     PRCP
      CALL resolve_qc_single_param20210205(
     +  s_qckey_timescale_spec,l_qckey,
     +  s_qckey_sourceflag,s_qckey_c3sflag,s_qckey_timescale,
     +  l_rgh_lines,l_lines,
     +  s_vec_prcp_qc,s_vec_prcp_qc_ncepcode,

     +  s_vec_prcp_qc_cdmqcmethod,
     +  i_cnt_qc_prcp)

c     SNOW
      CALL resolve_qc_single_param20210205(
     +  s_qckey_timescale_spec,l_qckey,
     +  s_qckey_sourceflag,s_qckey_c3sflag,s_qckey_timescale,
     +  l_rgh_lines,l_lines,
     +  s_vec_snow_qc,s_vec_snow_qc_ncepcode,

     +  s_vec_snow_qc_cdmqcmethod,
     +  i_cnt_qc_snow)

c     AWND
      CALL resolve_qc_single_param20210205(
     +  s_qckey_timescale_spec,l_qckey,
     +  s_qckey_sourceflag,s_qckey_c3sflag,s_qckey_timescale,
     +  l_rgh_lines,l_lines,
     +  s_vec_awnd_qc,s_vec_awnd_qc_ncepcode,

     +  s_vec_awnd_qc_cdmqcmethod,
     +  i_cnt_qc_awnd)

c      STOP 'set_qcmethod_code'

      RETURN
      END
