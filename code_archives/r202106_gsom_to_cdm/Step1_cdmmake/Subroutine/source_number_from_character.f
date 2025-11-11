c     Subroutine to get source number from source character
c     AJ_Kettle, 30Sep2019

      SUBROUTINE source_number_from_character(i_flag,
     +    l_source_rgh,l_source,
     +    s_source_name,s_source_codeletter,s_source_codenumber,
     +    l_rgh_lines,l_lines,
     +    s_vec_tmax_sourcelett,s_vec_tmin_sourcelett,
     +    s_vec_tavg_sourcelett,s_vec_prcp_sourcelett,
     +    s_vec_snow_sourcelett,s_vec_awnd_sourcelett,
     +    s_vec_tmax_sourcenum,s_vec_tmin_sourcenum,
     +    s_vec_tavg_sourcenum,s_vec_prcp_sourcenum,
     +    s_vec_snow_sourcenum,s_vec_awnd_sourcenum,
     +    s_vec_tmax_attrib,s_vec_tmin_attrib,
     +    s_vec_tavg_attrib,s_vec_prcp_attrib,
     +    s_vec_snow_attrib,s_vec_awnd_attrib,
     +    s_vec_tmax_c,s_vec_tmin_c,s_vec_tavg_c,
     +    s_vec_prcp_mm,s_vec_snow_mm,s_vec_awnd_ms)

      IMPLICIT NONE
c************************************************************************
c     variable for GSOM/GHCND conversion
      INTEGER             :: i_flag

      INTEGER             :: l_source_rgh
      INTEGER             :: l_source
      CHARACTER(LEN=500)  :: s_source_name(l_source_rgh)
      CHARACTER(LEN=1)    :: s_source_codeletter(l_source_rgh)
      CHARACTER(LEN=3)    :: s_source_codenumber(l_source_rgh)

c     Get GHCND source letter
      INTEGER             :: l_rgh_lines
      INTEGER             :: l_lines

      CHARACTER(LEN=1)    :: s_vec_tmax_sourcelett(l_rgh_lines)
      CHARACTER(LEN=1)    :: s_vec_tmin_sourcelett(l_rgh_lines)
      CHARACTER(LEN=1)    :: s_vec_tavg_sourcelett(l_rgh_lines)
      CHARACTER(LEN=1)    :: s_vec_prcp_sourcelett(l_rgh_lines)
      CHARACTER(LEN=1)    :: s_vec_snow_sourcelett(l_rgh_lines)
      CHARACTER(LEN=1)    :: s_vec_awnd_sourcelett(l_rgh_lines)

      CHARACTER(LEN=3)    :: s_vec_tmax_sourcenum(l_rgh_lines)
      CHARACTER(LEN=3)    :: s_vec_tmin_sourcenum(l_rgh_lines)
      CHARACTER(LEN=3)    :: s_vec_tavg_sourcenum(l_rgh_lines)
      CHARACTER(LEN=3)    :: s_vec_prcp_sourcenum(l_rgh_lines)
      CHARACTER(LEN=3)    :: s_vec_snow_sourcenum(l_rgh_lines)
      CHARACTER(LEN=3)    :: s_vec_awnd_sourcenum(l_rgh_lines)

      CHARACTER(LEN=10)   :: s_vec_tmax_attrib(l_rgh_lines)
      CHARACTER(LEN=10)   :: s_vec_tmin_attrib(l_rgh_lines)
      CHARACTER(LEN=10)   :: s_vec_tavg_attrib(l_rgh_lines)
      CHARACTER(LEN=10)   :: s_vec_prcp_attrib(l_rgh_lines)
      CHARACTER(LEN=10)   :: s_vec_snow_attrib(l_rgh_lines)
      CHARACTER(LEN=10)   :: s_vec_awnd_attrib(l_rgh_lines)

      CHARACTER(LEN=10)   :: s_vec_tmax_c(l_rgh_lines)
      CHARACTER(LEN=10)   :: s_vec_tmin_c(l_rgh_lines)
      CHARACTER(LEN=10)   :: s_vec_tavg_c(l_rgh_lines)
      CHARACTER(LEN=10)   :: s_vec_prcp_mm(l_rgh_lines)
      CHARACTER(LEN=10)   :: s_vec_snow_mm(l_rgh_lines)
      CHARACTER(LEN=10)   :: s_vec_awnd_ms(l_rgh_lines)
c*****
c     Variables used within subroutine

      INTEGER             :: i,j,k,ii,jj,kk
      CHARACTER(LEN=4)    :: s_varname 
c************************************************************************
c      print*,'just entered source_number_from_character'

      i_flag=0     !initialize bad data flag

c*****
      s_varname='TMAX'
      CALL source_number_from_character_single(i_flag,s_varname,
     +  l_rgh_lines,l_lines,s_vec_tmax_sourcelett,
     +  s_vec_tmax_attrib,s_vec_tmax_c,
     +  l_source_rgh,l_source,s_source_codeletter,s_source_codenumber,

     +  s_vec_tmax_sourcenum)

c     Exit analysis condition
      IF (i_flag.EQ.1) THEN 
       GOTO 52
      ENDIF
c*****
      s_varname='TMIN'
      CALL source_number_from_character_single(i_flag,s_varname,
     +  l_rgh_lines,l_lines,s_vec_tmin_sourcelett,
     +  s_vec_tmin_attrib,s_vec_tmin_c,
     +  l_source_rgh,l_source,s_source_codeletter,s_source_codenumber,

     +  s_vec_tmin_sourcenum)

c     Exit analysis condition
      IF (i_flag.EQ.1) THEN 
       GOTO 52
      ENDIF
c*****
      s_varname='TAVG'
      CALL source_number_from_character_single(i_flag,s_varname,
     +  l_rgh_lines,l_lines,s_vec_tavg_sourcelett,
     +  s_vec_tavg_attrib,s_vec_tavg_c,
     +  l_source_rgh,l_source,s_source_codeletter,s_source_codenumber,

     +  s_vec_tavg_sourcenum)

c     Exit analysis condition
      IF (i_flag.EQ.1) THEN 
       GOTO 52
      ENDIF
c*****
      s_varname='PRCP'
      CALL source_number_from_character_single(i_flag,s_varname,
     +  l_rgh_lines,l_lines,s_vec_prcp_sourcelett,
     +  s_vec_prcp_attrib,s_vec_prcp_mm,
     +  l_source_rgh,l_source,s_source_codeletter,s_source_codenumber,

     +  s_vec_prcp_sourcenum)

c     Exit analysis condition
      IF (i_flag.EQ.1) THEN 
       GOTO 52
      ENDIF
c*****
      s_varname='SNOW'
      CALL source_number_from_character_single(i_flag,s_varname,
     +  l_rgh_lines,l_lines,s_vec_snow_sourcelett,
     +  s_vec_snow_attrib,s_vec_snow_mm,
     +  l_source_rgh,l_source,s_source_codeletter,s_source_codenumber,

     +  s_vec_snow_sourcenum)

c     Exit analysis condition
      IF (i_flag.EQ.1) THEN 
       GOTO 52
      ENDIF
c*****
      s_varname='AWND'
      CALL source_number_from_character_single(i_flag,s_varname,
     +  l_rgh_lines,l_lines,s_vec_awnd_sourcelett,
     +  s_vec_awnd_attrib,s_vec_awnd_ms,
     +  l_source_rgh,l_source,s_source_codeletter,s_source_codenumber,

     +  s_vec_awnd_sourcenum)

c     Exit analysis condition
      IF (i_flag.EQ.1) THEN 
       GOTO 52
      ENDIF
c*****
 52   CONTINUE

c      print*,'s_vec_tmax_sourcenum=',
c     +  (s_vec_tmax_sourcenum(i),i=1,l_lines)
c      print*,'s_vec_tmin_sourcenum=',
c     +  (s_vec_tmin_sourcenum(i),i=1,l_lines)
c      print*,'s_vec_tavg_sourcenum=',
c     +  (s_vec_tavg_sourcenum(i),i=1,l_lines)
c      print*,'s_vec_prcp_sourcenum=',
c     +  (s_vec_prcp_sourcenum(i),i=1,l_lines)
c      print*,'s_vec_snow_sourcenum=',
c     +  (s_vec_snow_sourcenum(i),i=1,l_lines)
c      print*,'s_vec_awnd_sourcenum=',
c     +  (s_vec_awnd_sourcenum(i),i=1,l_lines)

c      print*,'just leaving source_number_from_character'
c      STOP 'source_number_from_character'

      RETURN
      END
