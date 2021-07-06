c     Subroutine to find listing of available source & record numbers (horiz)
c     AJ_Kettle, 02Dec2019

      SUBROUTINE get_mat_altern_sourcenum(l_rgh_lines,l_lines,
     +  s_vec_tmax_c,s_vec_tmin_c,s_vec_tavg_c,
     +  s_vec_prcp_mm,s_vec_snow_mm,s_vec_awnd_ms,
     +  s_vec_tmax_sourcenum,s_vec_tmin_sourcenum,
     +  s_vec_tavg_sourcenum,s_vec_prcp_sourcenum,
     +  s_vec_snow_sourcenum,s_vec_awnd_sourcenum,
     +  s_vec_tmax_recordnum,s_vec_tmin_recordnum,
     +  s_vec_tavg_recordnum,s_vec_prcp_recordnum,
     +  s_vec_snow_recordnum,s_vec_awnd_recordnum,

     +  i_cnt_recordnum,
     +  s_mat_sourcenum,s_mat_recordnum,s_mat_variableid)

      IMPLICIT NONE
c************************************************************************
c     Variables passed into subroutine

      INTEGER             :: l_rgh_lines
      INTEGER             :: l_lines

      CHARACTER(LEN=10)   :: s_vec_tmax_c(l_rgh_lines)
      CHARACTER(LEN=10)   :: s_vec_tmin_c(l_rgh_lines)
      CHARACTER(LEN=10)   :: s_vec_tavg_c(l_rgh_lines)
      CHARACTER(LEN=10)   :: s_vec_prcp_mm(l_rgh_lines)
      CHARACTER(LEN=10)   :: s_vec_snow_mm(l_rgh_lines)
      CHARACTER(LEN=10)   :: s_vec_awnd_ms(l_rgh_lines)

      CHARACTER(LEN=3)    :: s_vec_tmax_sourcenum(l_rgh_lines)
      CHARACTER(LEN=3)    :: s_vec_tmin_sourcenum(l_rgh_lines)
      CHARACTER(LEN=3)    :: s_vec_tavg_sourcenum(l_rgh_lines)
      CHARACTER(LEN=3)    :: s_vec_prcp_sourcenum(l_rgh_lines)
      CHARACTER(LEN=3)    :: s_vec_snow_sourcenum(l_rgh_lines)
      CHARACTER(LEN=3)    :: s_vec_awnd_sourcenum(l_rgh_lines)

      CHARACTER(LEN=2)    :: s_vec_tmax_recordnum(l_rgh_lines)
      CHARACTER(LEN=2)    :: s_vec_tmin_recordnum(l_rgh_lines)
      CHARACTER(LEN=2)    :: s_vec_tavg_recordnum(l_rgh_lines)
      CHARACTER(LEN=2)    :: s_vec_prcp_recordnum(l_rgh_lines)
      CHARACTER(LEN=2)    :: s_vec_snow_recordnum(l_rgh_lines)
      CHARACTER(LEN=2)    :: s_vec_awnd_recordnum(l_rgh_lines)

      INTEGER             :: i_cnt_recordnum(l_rgh_lines)
      CHARACTER(LEN=3)    :: s_mat_sourcenum(l_rgh_lines,6)
      CHARACTER(LEN=2)    :: s_mat_recordnum(l_rgh_lines,6)
      CHARACTER(LEN=4)    :: s_mat_variableid(l_rgh_lines,6)
c*****
c     Variables used in subroutine

      INTEGER             :: i,j,k,ii,jj,kk

      INTEGER             :: i_len_var
      INTEGER             :: i_len_snum
      INTEGER             :: i_len_rnum
c************************************************************************
c      print*,'just entered get_mat_altern_sourcenum'

c     Make listing of available source/record numbers for covering defect
      DO i=1,l_lines

        ii=0

c       TMAX
        i_len_var=LEN_TRIM(s_vec_tmax_c(i))
        i_len_snum=LEN_TRIM( s_vec_tmax_sourcenum(i))
        i_len_rnum=LEN_TRIM( s_vec_tmax_recordnum(i))
        IF (i_len_var.GT.0.AND.i_len_rnum.GT.0.AND.i_len_snum.GT.0) THEN
         ii=ii+1
         s_mat_sourcenum(i,ii)=s_vec_tmax_sourcenum(i)
         s_mat_recordnum(i,ii)=s_vec_tmax_recordnum(i)
         s_mat_variableid(i,ii)='TMAX'
        ENDIF
c       TMIN
        i_len_var=LEN_TRIM(s_vec_tmin_c(i))
        i_len_snum=LEN_TRIM( s_vec_tmin_sourcenum(i))
        i_len_rnum=LEN_TRIM( s_vec_tmin_recordnum(i))
        IF (i_len_var.GT.0.AND.i_len_rnum.GT.0.AND.i_len_snum.GT.0) THEN
         ii=ii+1
         s_mat_sourcenum(i,ii)=s_vec_tmin_sourcenum(i)
         s_mat_recordnum(i,ii)=s_vec_tmin_recordnum(i)
         s_mat_variableid(i,ii)='TMIN'
        ENDIF
c       TAVG
        i_len_var=LEN_TRIM(s_vec_tavg_c(i))
        i_len_snum=LEN_TRIM( s_vec_tavg_sourcenum(i))
        i_len_rnum=LEN_TRIM( s_vec_tavg_recordnum(i))
        IF (i_len_var.GT.0.AND.i_len_rnum.GT.0.AND.i_len_snum.GT.0) THEN
         ii=ii+1
         s_mat_sourcenum(i,ii)=s_vec_tavg_sourcenum(i)
         s_mat_recordnum(i,ii)=s_vec_tavg_recordnum(i)
         s_mat_variableid(i,ii)='TAVG'
        ENDIF
c       PRCP
        i_len_var=LEN_TRIM(s_vec_prcp_mm(i))
        i_len_snum=LEN_TRIM( s_vec_prcp_sourcenum(i))
        i_len_rnum=LEN_TRIM( s_vec_prcp_recordnum(i))
        IF (i_len_var.GT.0.AND.i_len_rnum.GT.0.AND.i_len_snum.GT.0) THEN
         ii=ii+1
         s_mat_sourcenum(i,ii)=s_vec_prcp_sourcenum(i)
         s_mat_recordnum(i,ii)=s_vec_prcp_recordnum(i)
         s_mat_variableid(i,ii)='PRCP'
        ENDIF
c       SNOW
        i_len_var=LEN_TRIM(s_vec_snow_mm(i))
        i_len_snum=LEN_TRIM( s_vec_snow_sourcenum(i))
        i_len_rnum=LEN_TRIM( s_vec_snow_recordnum(i))
        IF (i_len_var.GT.0.AND.i_len_rnum.GT.0.AND.i_len_snum.GT.0) THEN
         ii=ii+1
         s_mat_sourcenum(i,ii)=s_vec_snow_sourcenum(i)
         s_mat_recordnum(i,ii)=s_vec_snow_recordnum(i)
         s_mat_variableid(i,ii)='SNOW'
        ENDIF
c       AWND
        i_len_var=LEN_TRIM(s_vec_awnd_ms(i))
        i_len_snum=LEN_TRIM( s_vec_awnd_sourcenum(i))
        i_len_rnum=LEN_TRIM( s_vec_awnd_recordnum(i))
        IF (i_len_var.GT.0.AND.i_len_rnum.GT.0.AND.i_len_snum.GT.0) THEN
         ii=ii+1
         s_mat_sourcenum(i,ii)=s_vec_awnd_sourcenum(i)
         s_mat_recordnum(i,ii)=s_vec_awnd_recordnum(i)
         s_mat_variableid(i,ii)='AWND'
        ENDIF

        i_cnt_recordnum(i)=ii

      ENDDO

c      print*,'s_vec_tmax_sourcenum(i)'

c      print*,'just leaving get_mat_altern_sourcenum'
c      STOP 'get_mat_altern_sourcenum'

      RETURN
      END
