c     Subroutine to get record_number from source_number
c     AJ_Kettle, 01Oct2019
c     25Nov2019: modified procedure for qc modification flags

      SUBROUTINE record_number_from_source_number3(
     +    i_flag,i_flag_cat4,i_cnt_cat4_allcase,
     +    i_flag_linenumber,s_flag_varname,
     +    l_scshort,
     +    s_scshort_record_number,s_scshort_source_id,
     +    s_scshort_data_policy_licence,
     +    l_rgh_lines,l_lines,
     +    s_vec_tmax_c,s_vec_tmin_c,s_vec_tavg_c,
     +    s_vec_prcp_mm,s_vec_snow_mm,s_vec_awnd_ms,
     +    s_vec_tmax_sourcenum,s_vec_tmin_sourcenum,
     +    s_vec_tavg_sourcenum,s_vec_prcp_sourcenum,
     +    s_vec_snow_sourcenum,s_vec_awnd_sourcenum,

     +    s_vec_tmax_recordnum,s_vec_tmin_recordnum,
     +    s_vec_tavg_recordnum,s_vec_prcp_recordnum,
     +    s_vec_snow_recordnum,s_vec_awnd_recordnum,
     +    i_vec_tmax_qcmod_flag,i_vec_tmin_qcmod_flag,
     +    i_vec_tavg_qcmod_flag,i_vec_prcp_qcmod_flag,
     +    i_vec_snow_qcmod_flag,i_vec_awnd_qcmod_flag)

      IMPLICIT NONE
c************************************************************************
      INTEGER             :: i_flag
      INTEGER             :: i_flag_cat4
      INTEGER             :: i_cnt_cat4_allcase
      INTEGER             :: i_flag_linenumber
      CHARACTER(LEN=4)    :: s_flag_varname

      INTEGER             :: l_scshort
      CHARACTER(LEN=*)    :: s_scshort_record_number(20)
      CHARACTER(LEN=*)    :: s_scshort_data_policy_licence(20)
      CHARACTER(LEN=*)    :: s_scshort_source_id(20)

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

      INTEGER             :: i_vec_tmax_qcmod_flag(l_rgh_lines)
      INTEGER             :: i_vec_tmin_qcmod_flag(l_rgh_lines)
      INTEGER             :: i_vec_tavg_qcmod_flag(l_rgh_lines)
      INTEGER             :: i_vec_prcp_qcmod_flag(l_rgh_lines)
      INTEGER             :: i_vec_snow_qcmod_flag(l_rgh_lines)
      INTEGER             :: i_vec_awnd_qcmod_flag(l_rgh_lines)
c*****
c     Variables from used in subroutine

      INTEGER             :: i,j,k,ii,jj,kk

c     variables for listing of available source numbers
      INTEGER             :: i_len_var
      INTEGER             :: i_len_snum
      INTEGER             :: i_len_rnum
      INTEGER             :: i_cnt_recordnum(l_rgh_lines)
      CHARACTER(LEN=3)    :: s_mat_sourcenum(l_rgh_lines,6)
      CHARACTER(LEN=2)    :: s_mat_recordnum(l_rgh_lines,6)
      CHARACTER(LEN=4)    :: s_mat_variableid(l_rgh_lines,6)

      INTEGER             :: i_flag_tmax
      INTEGER             :: i_flag_tmin
      INTEGER             :: i_flag_tavg
      INTEGER             :: i_flag_prcp
      INTEGER             :: i_flag_snow
      INTEGER             :: i_flag_awnd

      INTEGER             :: i_tot_tmax_qcmod
      INTEGER             :: i_tot_tmin_qcmod
      INTEGER             :: i_tot_tavg_qcmod
      INTEGER             :: i_tot_prcp_qcmod
      INTEGER             :: i_tot_snow_qcmod
      INTEGER             :: i_tot_awnd_qcmod

      CHARACTER(LEN=4)    :: s_var_name

      INTEGER             :: i_qcmod_new
      CHARACTER(LEN=2)    :: i_recordnum_new
c************************************************************************
      print*,'just entered record_number_from_source_number3'

c      print*,'l_scshort=',l_scshort
c      print*,'s_scshort_source_id',
c     +   ('='//TRIM(s_scshort_source_id(j))//'=',j=1,l_scshort)
c      print*,'s_scshort_record_number',
c     +   ('='//TRIM(s_scshort_record_number(j))//'=',j=1,l_scshort)
c*****
      i_flag_cat4=0
c*****
c     Initialize variables
      DO i=1,l_rgh_lines

c      Initialize record number to blank
       s_vec_tmax_recordnum(i)=''
       s_vec_tmin_recordnum(i)=''
       s_vec_tavg_recordnum(i)=''
       s_vec_prcp_recordnum(i)=''
       s_vec_snow_recordnum(i)=''
       s_vec_awnd_recordnum(i)=''

c      Initialize qcmod flags to good
       i_vec_tmax_qcmod_flag(i)=0
       i_vec_tmin_qcmod_flag(i)=0
       i_vec_tavg_qcmod_flag(i)=0
       i_vec_prcp_qcmod_flag(i)=0
       i_vec_snow_qcmod_flag(i)=0
       i_vec_awnd_qcmod_flag(i)=0

      ENDDO

c     TMAX analysis
      s_var_name='TMAX'
      CALL find_record_number_single3(s_var_name,
     +  i_flag_tmax,i_flag_linenumber,
     +  l_rgh_lines,l_lines,s_vec_tmax_c,s_vec_tmax_sourcenum,
     +  l_scshort,s_scshort_source_id,s_scshort_record_number,
     +  s_vec_tmax_recordnum,i_vec_tmax_qcmod_flag)
c      CALL find_record_number_single2(s_var_name,
c     +  i_flag,i_flag_linenumber,
c     +  l_rgh_lines,l_lines,s_vec_tmax_c,s_vec_tmax_sourcenum,
c     +  l_scshort,s_scshort_source_id,s_scshort_record_number,
c     +  s_vec_tmax_recordnum)

c     Exit condition
      IF (i_flag_tmax.EQ.1) THEN 
       s_flag_varname=s_var_name

c       GOTO 10
      ENDIF

c     TMIN analysis
      s_var_name='TMIN'
      CALL find_record_number_single3(s_var_name,
     +  i_flag_tmin,i_flag_linenumber,
     +  l_rgh_lines,l_lines,s_vec_tmin_c,s_vec_tmin_sourcenum,
     +  l_scshort,s_scshort_source_id,s_scshort_record_number,
     +  s_vec_tmin_recordnum,i_vec_tmin_qcmod_flag)
c      CALL find_record_number_single2(s_var_name,
c     +  i_flag,i_flag_linenumber,
c     +  l_rgh_lines,l_lines,s_vec_tmin_c,s_vec_tmin_sourcenum,
c     +  l_scshort,s_scshort_source_id,s_scshort_record_number,
c     +  s_vec_tmin_recordnum)

c     Exit condition
      IF (i_flag_tmin.EQ.1) THEN
       s_flag_varname=s_var_name 
c       GOTO 10
      ENDIF

c     TAVG analysis
      s_var_name='TAVG'
      CALL find_record_number_single3(s_var_name,
     +  i_flag_tavg,i_flag_linenumber,
     +  l_rgh_lines,l_lines,s_vec_tavg_c,s_vec_tavg_sourcenum,
     +  l_scshort,s_scshort_source_id,s_scshort_record_number,
     +  s_vec_tavg_recordnum,i_vec_tavg_qcmod_flag)
c      CALL find_record_number_single2(s_var_name,
c     +  i_flag,i_flag_linenumber,
c     +  l_rgh_lines,l_lines,s_vec_tavg_c,s_vec_tavg_sourcenum,
c     +  l_scshort,s_scshort_source_id,s_scshort_record_number,
c     +  s_vec_tavg_recordnum)

c     Exit condition
      IF (i_flag_tavg.EQ.1) THEN 
       s_flag_varname=s_var_name
c       GOTO 10
      ENDIF

c     PRCP analysis
      s_var_name='PRCP'
      CALL find_record_number_single3(s_var_name,
     +  i_flag_prcp,i_flag_linenumber,
     +  l_rgh_lines,l_lines,s_vec_prcp_mm,s_vec_prcp_sourcenum,
     +  l_scshort,s_scshort_source_id,s_scshort_record_number,
     +  s_vec_prcp_recordnum,i_vec_prcp_qcmod_flag)
c      CALL find_record_number_single2(s_var_name,
c     +  i_flag,i_flag_linenumber,
c     +  l_rgh_lines,l_lines,s_vec_prcp_mm,s_vec_prcp_sourcenum,
c     +  l_scshort,s_scshort_source_id,s_scshort_record_number,
c     +  s_vec_prcp_recordnum)

c     Exit condition
      IF (i_flag_prcp.EQ.1) THEN 
       s_flag_varname=s_var_name
c       GOTO 10
      ENDIF

c     SNOW analysis
      s_var_name='SNOW'
      CALL find_record_number_single3(s_var_name,
     +  i_flag_snow,i_flag_linenumber,
     +  l_rgh_lines,l_lines,s_vec_snow_mm,s_vec_snow_sourcenum,
     +  l_scshort,s_scshort_source_id,s_scshort_record_number,
     +  s_vec_snow_recordnum,i_vec_snow_qcmod_flag)
c      CALL find_record_number_single2(s_var_name,
c     +  i_flag,i_flag_linenumber,
c     +  l_rgh_lines,l_lines,s_vec_snow_mm,s_vec_snow_sourcenum,
c     +  l_scshort,s_scshort_source_id,s_scshort_record_number,
c     +  s_vec_snow_recordnum)

c     Exit condition
      IF (i_flag_snow.EQ.1) THEN 
       s_flag_varname=s_var_name
c       GOTO 10
      ENDIF

c     AWND analysis
      s_var_name='AWND'
      CALL find_record_number_single3(s_var_name,
     +  i_flag_awnd,i_flag_linenumber,
     +  l_rgh_lines,l_lines,s_vec_awnd_ms,s_vec_awnd_sourcenum,
     +  l_scshort,s_scshort_source_id,s_scshort_record_number,
     +  s_vec_awnd_recordnum,i_vec_awnd_qcmod_flag)
c      CALL find_record_number_single2(s_var_name,
c     +  i_flag,i_flag_linenumber,
c     +  l_rgh_lines,l_lines,s_vec_awnd_ms,s_vec_awnd_sourcenum,
c     +  l_scshort,s_scshort_source_id,s_scshort_record_number,
c     +  s_vec_awnd_recordnum)

c     Exit condition
      IF (i_flag_awnd.EQ.1) THEN 
       s_flag_varname=s_var_name
c       GOTO 10
      ENDIF

 10   CONTINUE

c*****
c     Segment to correct bad data

      i_cnt_cat4_allcase=0

c     Condition if any of flags set
      IF (i_flag_tmax+i_flag_tmin+i_flag_tavg+
     +    i_flag_prcp+i_flag_snow+i_flag_awnd.GT.1) THEN
       i_flag=1

       print*,'starting record number correction case'

c      Count number of flags
       i_tot_tmax_qcmod=0
       i_tot_tmin_qcmod=0
       i_tot_tavg_qcmod=0
       i_tot_prcp_qcmod=0
       i_tot_snow_qcmod=0
       i_tot_awnd_qcmod=0

       DO i=1,l_lines
        i_tot_tmax_qcmod=i_tot_tmax_qcmod+i_vec_tmax_qcmod_flag(i)
        i_tot_tmin_qcmod=i_tot_tmin_qcmod+i_vec_tmin_qcmod_flag(i)
        i_tot_tavg_qcmod=i_tot_tavg_qcmod+i_vec_tavg_qcmod_flag(i)
        i_tot_prcp_qcmod=i_tot_prcp_qcmod+i_vec_prcp_qcmod_flag(i)
        i_tot_snow_qcmod=i_tot_snow_qcmod+i_vec_snow_qcmod_flag(i)
        i_tot_awnd_qcmod=i_tot_awnd_qcmod+i_vec_awnd_qcmod_flag(i)
       ENDDO

       print*,'flags=',i_flag_tmax,i_flag_tmin,i_flag_tavg,
     +   i_flag_prcp,i_flag_snow,i_flag_awnd

       print*,'i_tot_tmax_qcmod=',i_tot_tmax_qcmod
       print*,'i_tot_tmin_qcmod=',i_tot_tmin_qcmod
       print*,'i_tot_tavg_qcmod=',i_tot_tavg_qcmod
       print*,'i_tot_prcp_qcmod=',i_tot_prcp_qcmod
       print*,'i_tot_snow_qcmod=',i_tot_snow_qcmod
       print*,'i_tot_awnd_qcmod=',i_tot_awnd_qcmod

c      Find listing of available 
       CALL get_mat_altern_sourcenum(l_rgh_lines,l_lines,
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

       GOTO 20

c      Check problem - TMAX
       IF (i_tot_tmax_qcmod.GT.0) THEN 
        CALL fix_record_number(l_rgh_lines,l_lines, 
     +   i_vec_tmax_qcmod_flag,i_cnt_recordnum,s_mat_recordnum,
     +   s_vec_tmax_recordnum)
       ENDIF
c      Check problem - TMIN
       IF (i_tot_tmin_qcmod.GT.0) THEN 
        CALL fix_record_number(l_rgh_lines,l_lines, 
     +   i_vec_tmin_qcmod_flag,i_cnt_recordnum,s_mat_recordnum,
     +   s_vec_tmin_recordnum)
       ENDIF
c      Check problem - TAVG
       IF (i_tot_tavg_qcmod.GT.0) THEN 
        CALL fix_record_number(l_rgh_lines,l_lines, 
     +   i_vec_tavg_qcmod_flag,i_cnt_recordnum,s_mat_recordnum,
     +   s_vec_tavg_recordnum)
       ENDIF
c      Check problem - PRCP
       IF (i_tot_prcp_qcmod.GT.0) THEN 
        CALL fix_record_number(l_rgh_lines,l_lines, 
     +   i_vec_prcp_qcmod_flag,i_cnt_recordnum,s_mat_recordnum,
     +   s_vec_prcp_recordnum)
       ENDIF
c      Check problem - SNOW
       IF (i_tot_snow_qcmod.GT.0) THEN 
        CALL fix_record_number(l_rgh_lines,l_lines, 
     +   i_vec_snow_qcmod_flag,i_cnt_recordnum,s_mat_recordnum,
     +   s_vec_snow_recordnum)
       ENDIF
c      Check problem - AWND
       IF (i_tot_awnd_qcmod.GT.0) THEN 
        CALL fix_record_number(l_rgh_lines,l_lines, 
     +   i_vec_awnd_qcmod_flag,i_cnt_recordnum,s_mat_recordnum,
     +   s_vec_awnd_recordnum)
       ENDIF

 20    CONTINUE

c      Fix Datzilla
c      TMAX
       IF (i_tot_tmax_qcmod.GT.0) THEN 
       CALL fix_datzilla(l_rgh_lines,l_lines, 
     +  s_vec_tmax_sourcenum,s_vec_tmax_recordnum,
     +  i_vec_tmax_qcmod_flag,
     +  i_cnt_recordnum,s_mat_sourcenum,s_mat_recordnum,
     +  i_flag_cat4,i_cnt_cat4_allcase)
       ENDIF
c      TMIN
       IF (i_tot_tmin_qcmod.GT.0) THEN 
       CALL fix_datzilla(l_rgh_lines,l_lines, 
     +  s_vec_tmin_sourcenum,s_vec_tmin_recordnum,
     +  i_vec_tmin_qcmod_flag,
     +  i_cnt_recordnum,s_mat_sourcenum,s_mat_recordnum,
     +  i_flag_cat4,i_cnt_cat4_allcase)
       ENDIF
c      TAVG
       IF (i_tot_tavg_qcmod.GT.0) THEN 
       CALL fix_datzilla(l_rgh_lines,l_lines, 
     +  s_vec_tavg_sourcenum,s_vec_tavg_recordnum,
     +  i_vec_tavg_qcmod_flag,
     +  i_cnt_recordnum,s_mat_sourcenum,s_mat_recordnum,
     +  i_flag_cat4,i_cnt_cat4_allcase)
       ENDIF
c      PRCP
       IF (i_tot_prcp_qcmod.GT.0) THEN 
       CALL fix_datzilla(l_rgh_lines,l_lines, 
     +  s_vec_prcp_sourcenum,s_vec_prcp_recordnum,
     +  i_vec_prcp_qcmod_flag,
     +  i_cnt_recordnum,s_mat_sourcenum,s_mat_recordnum,
     +  i_flag_cat4,i_cnt_cat4_allcase)
       ENDIF
c      SNOW
       IF (i_tot_snow_qcmod.GT.0) THEN 
       CALL fix_datzilla(l_rgh_lines,l_lines, 
     +  s_vec_snow_sourcenum,s_vec_snow_recordnum,
     +  i_vec_snow_qcmod_flag,
     +  i_cnt_recordnum,s_mat_sourcenum,s_mat_recordnum,
     +  i_flag_cat4,i_cnt_cat4_allcase)
       ENDIF
c      AWND
       IF (i_tot_awnd_qcmod.GT.0) THEN 
       CALL fix_datzilla(l_rgh_lines,l_lines, 
     +  s_vec_awnd_sourcenum,s_vec_awnd_recordnum,
     +  i_vec_awnd_qcmod_flag,
     +  i_cnt_recordnum,s_mat_sourcenum,s_mat_recordnum,
     +  i_flag_cat4,i_cnt_cat4_allcase)
       ENDIF

      ENDIF
c*****
      print*,'i_flag_cat4=',i_flag_cat4

      print*,'just leaving record_number_from_source_number2'
c      STOP 'record_number_from_source_number3'

      RETURN
      END
