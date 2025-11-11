c     Subroutine to get source character from attribution
c     AJ_Kettle, 25Sep2019
c     29Nov2019: modified code to do vertical search

      SUBROUTINE get_source_char_from_attrib3(
     +    i_flag,i_flag_cat2,i_cnt_cat2_allcase,
     +    i_flag_linenumber,s_flag_varname,
     +    l_rgh_lines,l_lines,
     +    s_vec_tmax_c,s_vec_tmin_c,s_vec_tavg_c,
     +    s_vec_prcp_mm,s_vec_snow_mm,s_vec_awnd_ms,
     +    s_vec_tmax_attrib,s_vec_tmin_attrib,
     +    s_vec_tavg_attrib,s_vec_prcp_attrib,
     +    s_vec_snow_attrib,s_vec_awnd_attrib,
     +    s_vec_tmax_sourcelett,s_vec_tmin_sourcelett,
     +    s_vec_tavg_sourcelett,s_vec_prcp_sourcelett,
     +    s_vec_snow_sourcelett,s_vec_awnd_sourcelett,
     +    i_vec_tmax_test2_flag,i_vec_tmin_test2_flag,
     +    i_vec_tavg_test2_flag,i_vec_prcp_test2_flag,
     +    i_vec_snow_test2_flag,i_vec_awnd_test2_flag)

      IMPLICIT NONE
c************************************************************************
c     Variables passed into subroutine

      INTEGER             :: i_flag
      INTEGER             :: i_flag_cat2
      INTEGER             :: i_cnt_cat2_allcase
      INTEGER             :: i_flag_linenumber
      CHARACTER(LEN=4)    :: s_flag_varname

      INTEGER             :: l_rgh_lines
      INTEGER             :: l_lines

      CHARACTER(LEN=10)   :: s_vec_tmax_c(l_rgh_lines)
      CHARACTER(LEN=10)   :: s_vec_tmin_c(l_rgh_lines)
      CHARACTER(LEN=10)   :: s_vec_tavg_c(l_rgh_lines)
      CHARACTER(LEN=10)   :: s_vec_prcp_mm(l_rgh_lines)
      CHARACTER(LEN=10)   :: s_vec_snow_mm(l_rgh_lines)
      CHARACTER(LEN=10)   :: s_vec_awnd_ms(l_rgh_lines)

      CHARACTER(LEN=10)   :: s_vec_tmax_attrib(l_rgh_lines)
      CHARACTER(LEN=10)   :: s_vec_tmin_attrib(l_rgh_lines)
      CHARACTER(LEN=10)   :: s_vec_tavg_attrib(l_rgh_lines)
      CHARACTER(LEN=10)   :: s_vec_prcp_attrib(l_rgh_lines)
      CHARACTER(LEN=10)   :: s_vec_snow_attrib(l_rgh_lines)
      CHARACTER(LEN=10)   :: s_vec_awnd_attrib(l_rgh_lines)

      CHARACTER(LEN=1)    :: s_vec_tmax_sourcelett(l_rgh_lines)
      CHARACTER(LEN=1)    :: s_vec_tmin_sourcelett(l_rgh_lines)
      CHARACTER(LEN=1)    :: s_vec_tavg_sourcelett(l_rgh_lines)
      CHARACTER(LEN=1)    :: s_vec_prcp_sourcelett(l_rgh_lines)
      CHARACTER(LEN=1)    :: s_vec_snow_sourcelett(l_rgh_lines)
      CHARACTER(LEN=1)    :: s_vec_awnd_sourcelett(l_rgh_lines)

      INTEGER             :: i_vec_tmax_test2_flag(l_rgh_lines)
      INTEGER             :: i_vec_tmin_test2_flag(l_rgh_lines)
      INTEGER             :: i_vec_tavg_test2_flag(l_rgh_lines)
      INTEGER             :: i_vec_prcp_test2_flag(l_rgh_lines)
      INTEGER             :: i_vec_snow_test2_flag(l_rgh_lines)
      INTEGER             :: i_vec_awnd_test2_flag(l_rgh_lines)
c*****
c     Variables used within subroutine

      INTEGER             :: i,j,k,ii,jj,kk

      CHARACTER(LEN=10)   :: s_single
      INTEGER             :: i_len
      INTEGER             :: i_comma_cnt
      INTEGER             :: i_comma_pos(5)
      INTEGER             :: i_qc_delsource

      CHARACTER(LEN=4)    :: s_var

      INTEGER             :: i_len_var
      INTEGER             :: i_len_let

      INTEGER             :: i_cnt_sourcelett(l_rgh_lines)
      CHARACTER(LEN=1)    :: s_mat_sourcelett(l_rgh_lines,6)
      CHARACTER(LEN=4)    :: s_mat_variableid(l_rgh_lines,6)

      INTEGER             :: i_cnt_nbad(6)

      CHARACTER(LEN=1)    :: s_extvec_sourcelett(6)

      INTEGER             :: l_distinct_sourcelett
      CHARACTER(LEN=1)    :: s_distinct_sourcelett(6)
c************************************************************************
      print*,'just entered get_source_char_from_attrib'

c      print*,'s_vec_tmax_c=',(s_vec_tmax_c(i),i=1,l_lines)

      i_flag=0
      i_flag_cat2=0
c*****
c     Call subroutine to get single source letter
      s_var='TMAX'
      CALL get_single_source_char(s_var,l_rgh_lines,l_lines,
     +   s_vec_tmax_attrib,s_vec_tmax_sourcelett)
      s_var='TMIN'
      CALL get_single_source_char(s_var,l_rgh_lines,l_lines,
     +   s_vec_tmin_attrib,s_vec_tmin_sourcelett)

c     TAVG
      s_var='TAVG'
      CALL get_single_source_char2(s_var,l_rgh_lines,l_lines,
     +   s_vec_tavg_attrib,s_vec_tavg_sourcelett)

      s_var='PRCP'
      CALL get_single_source_char(s_var,l_rgh_lines,l_lines,
     +   s_vec_prcp_attrib,s_vec_prcp_sourcelett)
      s_var='SNOW'
      CALL get_single_source_char(s_var,l_rgh_lines,l_lines,
     +   s_vec_snow_attrib,s_vec_snow_sourcelett)

c     AWND
      s_var='AWND'
      CALL get_single_source_char2(s_var,l_rgh_lines,l_lines,
     +   s_vec_awnd_attrib,s_vec_awnd_sourcelett)

c*****
c*****
c     Get list of source letters for each time step
      CALL get_matrix_horiz_search(l_rgh_lines,l_lines,
     +  s_vec_tmax_c,s_vec_tmax_sourcelett,
     +  s_vec_tmin_c,s_vec_tmin_sourcelett,
     +  s_vec_tavg_c,s_vec_tavg_sourcelett,
     +  s_vec_prcp_mm,s_vec_prcp_sourcelett,
     +  s_vec_snow_mm,s_vec_snow_sourcelett,
     +  s_vec_awnd_ms,s_vec_awnd_sourcelett,
     +  i_cnt_sourcelett,
     +  s_mat_sourcelett,s_mat_variableid)

c*****
c*****
c     Initialize count variable
      DO i=1,6 
       i_cnt_nbad(i)=0
      ENDDO

c     Counter for all incidence of category 2 in station
      i_cnt_cat2_allcase=0

c     Confirm that good variable has good letter
      DO i=1,l_lines

c******
c      Initialize all qualifier flags to good
       i_vec_tmax_test2_flag(i)=0
       i_vec_tmin_test2_flag(i)=0
       i_vec_tavg_test2_flag(i)=0
       i_vec_prcp_test2_flag(i)=0
       i_vec_snow_test2_flag(i)=0
       i_vec_awnd_test2_flag(i)=0
c******
c      TMAX
       ii=1
       i_len_var=LEN_TRIM(s_vec_tmax_c(i))
       i_len_let=LEN_TRIM(s_vec_tmax_sourcelett(i))

c      Condition to identify problem
       IF (i_len_var.GT.0.AND.i_len_let.EQ.0) THEN
        i_flag=1
 
        i_flag_linenumber=i
        s_flag_varname='TMAX'

        i_cnt_nbad(ii)=i_cnt_nbad(ii)+1

c       Get alternative source letters
        CALL find_altern_letter(i,l_lines,l_rgh_lines,
     +   i_cnt_sourcelett,s_mat_sourcelett,
     +   s_vec_tmax_sourcelett,i_vec_tmax_test2_flag,
     +   i_flag_cat2,i_cnt_cat2_allcase)

        print*,'emergency stop; TMAX; no letter'
        print*,'line i,i_len_var,i_len_lett=',i,i_len_var,i_len_let
        print*,'s_vec_tmax_attrib='//TRIM(s_vec_tmax_attrib(i))//'='
        print*,'s_vec_tmax_c',s_vec_tmax_c(i)
        print*,'s_vec_tmax_sourcelett,corre',s_vec_tmax_sourcelett(i)

        print*,'i_cnt_sourcelett=',i_cnt_sourcelett(i)
        print*,'s_mat_sourcelett=',
     +    ('|'//s_mat_sourcelett(i,ii)//'|',ii=1,i_cnt_sourcelett(i))
        print*,'s_mat_variableid=',
     +    ('|'//s_mat_variableid(i,ii)//'|',ii=1,i_cnt_sourcelett(i))

c        STOP 'get_source_char_from_attrib'

c        GOTO 51

       ENDIF

c      TMIN
       ii=2
       i_len_var=LEN_TRIM(s_vec_tmin_c(i))
       i_len_let=LEN_TRIM(s_vec_tmin_sourcelett(i))

       IF (i_len_var.GT.0.AND.i_len_let.EQ.0) THEN 
        i_flag=1

        i_flag_linenumber=i
        s_flag_varname='TMIN'

        i_cnt_nbad(ii)=i_cnt_nbad(ii)+1

c       Get alternative source letters
        CALL find_altern_letter(i,l_lines,l_rgh_lines,
     +   i_cnt_sourcelett,s_mat_sourcelett,
     +   s_vec_tmin_sourcelett,i_vec_tmin_test2_flag,
     +   i_flag_cat2,i_cnt_cat2_allcase)

        print*,'emergency stop; TMIN; no letter'
        print*,'line i,i_len_var,i_len_lett=',i,i_len_var,i_len_let
        print*,'s_vec_tmin_attrib='//TRIM(s_vec_tmin_attrib(i))//'='
        print*,'s_vec_tmin_c',s_vec_tmax_c(i)
        print*,'s_vec_tmin_sourcelett',s_vec_tmin_sourcelett(i)
c        STOP 'get_source_char_from_attrib'

        print*,'i_cnt_sourcelett=',i_cnt_sourcelett(i)
        print*,'s_mat_sourcelett=',
     +    ('|'//s_mat_sourcelett(i,ii)//'|',ii=1,i_cnt_sourcelett(i))
        print*,'s_mat_variableid=',
     +    ('|'//s_mat_variableid(i,ii)//'|',ii=1,i_cnt_sourcelett(i))

c        GOTO 51

       ENDIF

c      TAVG
       ii=3
       i_len_var=LEN_TRIM(s_vec_tavg_c(i))
       i_len_let=LEN_TRIM(s_vec_tavg_sourcelett(i))

       IF (i_len_var.GT.0.AND.i_len_let.EQ.0) THEN 
        i_flag=1

        i_flag_linenumber=i
        s_flag_varname='TAVG'

        i_cnt_nbad(ii)=i_cnt_nbad(ii)+1

c       Get alternative source letters
        CALL find_altern_letter(i,l_lines,l_rgh_lines,
     +   i_cnt_sourcelett,s_mat_sourcelett,
     +   s_vec_tavg_sourcelett,i_vec_tavg_test2_flag,
     +   i_flag_cat2,i_cnt_cat2_allcase)

        print*,'emergency stop; TAVG; no letter'
        print*,'line i,i_len_var,i_len_lett=',i,i_len_var,i_len_let
        print*,'s_vec_tavg_attrib='//TRIM(s_vec_tavg_attrib(i))//'='
        print*,'s_vec_tavg_c',s_vec_tavg_c(i)
        print*,'s_vec_tavg_sourcelett',s_vec_tavg_sourcelett(i)
c        STOP 'get_source_char_from_attrib'

        print*,'i_cnt_sourcelett=',i_cnt_sourcelett(i)
        print*,'s_mat_sourcelett=',
     +    ('|'//s_mat_sourcelett(i,ii)//'|',ii=1,i_cnt_sourcelett(i))
        print*,'s_mat_variableid=',
     +    ('|'//s_mat_variableid(i,ii)//'|',ii=1,i_cnt_sourcelett(i))

c        GOTO 51

       ENDIF

c      PRCP
       ii=4
       i_len_var=LEN_TRIM(s_vec_prcp_mm(i))
       i_len_let=LEN_TRIM(s_vec_prcp_sourcelett(i))

       IF (i_len_var.GT.0.AND.i_len_let.EQ.0) THEN 
        i_flag=1

        i_flag_linenumber=i
        s_flag_varname='PRCP'

        i_cnt_nbad(ii)=i_cnt_nbad(ii)+1

c       Get alternative source letters
        CALL find_altern_letter(i,l_lines,l_rgh_lines,
     +   i_cnt_sourcelett,s_mat_sourcelett,
     +   s_vec_prcp_sourcelett,i_vec_prcp_test2_flag,
     +   i_flag_cat2,i_cnt_cat2_allcase)

        print*,'emergency stop; PRCP; no letter'
        print*,'line i,i_len_var,i_len_lett=',i,i_len_var,i_len_let
        print*,'s_vec_prcp_attrib='//TRIM(s_vec_prcp_attrib(i))//'='
        print*,'s_vec_prcp_mm',s_vec_prcp_mm(i)
        print*,'s_vec_prcp_sourcelett',s_vec_prcp_sourcelett(i)
c        STOP 'get_source_char_from_attrib'

        print*,'i_cnt_sourcelett=',i_cnt_sourcelett(i)
        print*,'s_mat_sourcelett=',
     +    ('|'//s_mat_sourcelett(i,ii)//'|',ii=1,i_cnt_sourcelett(i))
        print*,'s_mat_variableid=',
     +    ('|'//s_mat_variableid(i,ii)//'|',ii=1,i_cnt_sourcelett(i))

c        GOTO 51

       ENDIF

c      SNOW
       ii=5
       i_len_var=LEN_TRIM(s_vec_snow_mm(i))
       i_len_let=LEN_TRIM(s_vec_snow_sourcelett(i))

       IF (i_len_var.GT.0.AND.i_len_let.EQ.0) THEN 
        i_flag=1

        i_flag_linenumber=i
        s_flag_varname='SNOW'

        i_cnt_nbad(ii)=i_cnt_nbad(ii)+1

c       Get alternative source letters
        CALL find_altern_letter(i,l_lines,l_rgh_lines,
     +   i_cnt_sourcelett,s_mat_sourcelett,
     +   s_vec_snow_sourcelett,i_vec_snow_test2_flag,
     +   i_flag_cat2,i_cnt_cat2_allcase)

        print*,'emergency stop; SNOW; no letter'
        print*,'line i,i_len_var,i_len_lett=',i,i_len_var,i_len_let
        print*,'s_vec_snow_attrib='//TRIM(s_vec_snow_attrib(i))//'='
        print*,'s_vec_snow_mm',s_vec_snow_mm(i)
        print*,'s_vec_snow_sourcelett',s_vec_snow_sourcelett(i)
c        STOP 'get_source_char_from_attrib'

        print*,'i_cnt_sourcelett=',i_cnt_sourcelett(i)
        print*,'s_mat_sourcelett=',
     +    ('|'//s_mat_sourcelett(i,ii)//'|',ii=1,i_cnt_sourcelett(i))
        print*,'s_mat_variableid=',
     +    ('|'//s_mat_variableid(i,ii)//'|',ii=1,i_cnt_sourcelett(i))

c        GOTO 51

       ENDIF

c      AWND
       ii=6
       i_len_var=LEN_TRIM(s_vec_awnd_ms(i))
       i_len_let=LEN_TRIM(s_vec_awnd_sourcelett(i))

       IF (i_len_var.GT.0.AND.i_len_let.EQ.0) THEN 
        i_flag=1 

        i_flag_linenumber=i
        s_flag_varname='AWND'

        i_cnt_nbad(ii)=i_cnt_nbad(ii)+1

c       Get alternative source letters
        CALL find_altern_letter(i,l_lines,l_rgh_lines,
     +   i_cnt_sourcelett,s_mat_sourcelett,
     +   s_vec_awnd_sourcelett,i_vec_awnd_test2_flag,
     +   i_flag_cat2,i_cnt_cat2_allcase)

        print*,'emergency stop; AWND; no letter'
        print*,'line i,i_len_var,i_len_lett=',i,i_len_var,i_len_let
        print*,'s_vec_prcp_attrib='//TRIM(s_vec_prcp_attrib(i))//'='
        print*,'s_vec_awnd_ms',s_vec_awnd_ms(i)
        print*,'s_vec_awnd_sourcelett',s_vec_awnd_sourcelett(i)
c        STOP 'get_source_char_from_attrib'

        print*,'i_cnt_sourcelett=',i_cnt_sourcelett(i)
        print*,'s_mat_sourcelett=',
     +    ('|'//s_mat_sourcelett(i,ii)//'|',ii=1,i_cnt_sourcelett(i))
        print*,'s_mat_variableid=',
     +    ('|'//s_mat_variableid(i,ii)//'|',ii=1,i_cnt_sourcelett(i))

c        GOTO 51

       ENDIF

      ENDDO
c*****
      print*,'i_cnt_nbad=',(i_cnt_nbad(ii),ii=1,6)

      print*,'just leaving get_source_char_from_attrib'
c      STOP 'get_source_char_from_attrib'

 51   CONTINUE

      RETURN
      END
