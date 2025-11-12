c     Subroutine to export results from test2 (no source letter)
c     AJ_Kettle, 14Nov2019

      SUBROUTINE export_test2(s_date_st,s_time_st,s_zone_st,
     +    i_bad_sourceletter,
     +    s_directory_output_diagnostics,s_filename_test2,
     +    i_index,s_stnname_single,
     +    i_flag_linenumber,s_flag_varname,
     +    l_rgh_lines,l_lines,
     +    s_vec_date,
     +    s_vec_tmax_c,s_vec_tmin_c,s_vec_tavg_c,
     +    s_vec_prcp_mm,s_vec_snow_mm,s_vec_awnd_ms,
     +    s_vec_tmax_attrib,s_vec_tmin_attrib,
     +    s_vec_tavg_attrib,s_vec_prcp_attrib,
     +    s_vec_snow_attrib,s_vec_awnd_attrib,
     +    s_vec_tmax_sourcelett,s_vec_tmin_sourcelett,
     +    s_vec_tavg_sourcelett,s_vec_prcp_sourcelett,
     +    s_vec_snow_sourcelett,s_vec_awnd_sourcelett)

      IMPLICIT NONE
c************************************************************************
c     Variables passed into subroutine

      CHARACTER(LEN=8)    :: s_date_st
      CHARACTER(LEN=10)   :: s_time_st
      CHARACTER(LEN=5)    :: s_zone_st

      INTEGER             :: i_bad_sourceletter

      CHARACTER(LEN=300)  :: s_directory_output_diagnostics
      CHARACTER(LEN=300)  :: s_filename_test2

      INTEGER             :: i_index
      CHARACTER(LEN=*)    :: s_stnname_single

      INTEGER             :: i_flag_linenumber
      CHARACTER(LEN=4)    :: s_flag_varname

      INTEGER             :: l_rgh_lines
      INTEGER             :: l_lines

      CHARACTER(LEN=*)    :: s_vec_date(l_rgh_lines)

      CHARACTER(LEN=*)    :: s_vec_tmax_c(l_rgh_lines)  !len=10
      CHARACTER(LEN=*)    :: s_vec_tmin_c(l_rgh_lines)
      CHARACTER(LEN=*)    :: s_vec_tavg_c(l_rgh_lines)
      CHARACTER(LEN=*)    :: s_vec_prcp_mm(l_rgh_lines)
      CHARACTER(LEN=*)    :: s_vec_snow_mm(l_rgh_lines)
      CHARACTER(LEN=*)    :: s_vec_awnd_ms(l_rgh_lines)

      CHARACTER(LEN=*)    :: s_vec_tmax_attrib(l_rgh_lines)  !len=10
      CHARACTER(LEN=*)    :: s_vec_tmin_attrib(l_rgh_lines)
      CHARACTER(LEN=*)    :: s_vec_tavg_attrib(l_rgh_lines)
      CHARACTER(LEN=*)    :: s_vec_prcp_attrib(l_rgh_lines)
      CHARACTER(LEN=*)    :: s_vec_snow_attrib(l_rgh_lines)
      CHARACTER(LEN=*)    :: s_vec_awnd_attrib(l_rgh_lines)

      CHARACTER(LEN=*)    :: s_vec_tmax_sourcelett(l_rgh_lines)
      CHARACTER(LEN=*)    :: s_vec_tmin_sourcelett(l_rgh_lines)
      CHARACTER(LEN=*)    :: s_vec_tavg_sourcelett(l_rgh_lines)
      CHARACTER(LEN=*)    :: s_vec_prcp_sourcelett(l_rgh_lines)
      CHARACTER(LEN=*)    :: s_vec_snow_sourcelett(l_rgh_lines)
      CHARACTER(LEN=*)    :: s_vec_awnd_sourcelett(l_rgh_lines)
c*****
c     Variables used within subroutine

      INTEGER             :: i,j,k,ii,jj,kk

      CHARACTER(LEN=300)  :: s_pathandname
      CHARACTER(LEN=3)    :: s_filestatus1
      LOGICAL             :: there

c************************************************************************
      print*,'just entered export_test2'

c      print*,'s_directory_output_diagnostics=',
c     +   s_directory_output_diagnostics
c      print*,'s_filename_test2=',s_filename_test2

c      print*,'i_index=',i_index
c      print*,'s_stnname_single=',TRIM(s_stnname_single)
c      print*,'i_flag_linenumber=',i_flag_linenumber
c      print*,'s_flag_varname=',s_flag_varname

      s_pathandname=
     +  TRIM(s_directory_output_diagnostics)//TRIM(s_filename_test2)
c************************************************************************
      INQUIRE(FILE=TRIM(s_pathandname),
     +   EXIST=there)
      IF (there) THEN
        s_filestatus1='OLD'
      ENDIF
      IF (.NOT.(there)) THEN
        s_filestatus1='NEW'
      ENDIF
c************************************************************************
c     Case of new file
      IF (s_filestatus1.EQ.'NEW') THEN 

        OPEN(UNIT=5,
     +   FILE=TRIM(s_pathandname),
     +   FORM='formatted',
     +   STATUS='NEW',ACTION='WRITE')

         WRITE(5,FMT=1002) 'Test 2: no NOAA source letter           '
         WRITE(5,FMT=1002) '                                        '
         WRITE(5,FMT=1006) 'AJ_Kettle',s_date_st,s_time_st,s_zone_st
         WRITE(5,FMT=1002) '                                        '
         WRITE(5,FMT=1002) 'subroutine: export_test2.f              '
         WRITE(5,FMT=1002) '                                        '

 1002    FORMAT(a40)
 1006    FORMAT(t1,a9,t11,a8,t20,a10,t31,a5)

         WRITE(5,FMT=1008) 'Error index=   ',i_bad_sourceletter
         WRITE(5,FMT=1008) 'Station index= ',i_index
 1008    FORMAT(t1,a15,t17,i6)  
         WRITE(5,FMT=1009) 'Station name=  ',TRIM(s_stnname_single)
 1009    FORMAT(t1,a15,t17,a11)     
         WRITE(5,FMT=1010) 'Variable name= ',s_flag_varname
 1010    FORMAT(t1,a15,t17,a4) 
         WRITE(5,FMT=1012) 'Line number=   ',i_flag_linenumber
 1012    FORMAT(t1,a15,t17,i6) 
         WRITE(5,FMT=1014) 'Date=          ',
     +     s_vec_date(i_flag_linenumber)
 1014    FORMAT(t1,a15,t17,a7) 

c        TMAX
         IF (TRIM(s_flag_varname).EQ.'TMAX') THEN
          WRITE(5,FMT=1016) 'Variable value=',
     +     '<'//TRIM(s_vec_tmax_c(i_flag_linenumber))//'>'
          WRITE(5,FMT=1016) 'Attrib string= ',
     +     '<'//TRIM(s_vec_tmax_attrib(i_flag_linenumber))//'>'
          WRITE(5,FMT=1016) 'Source letter= ',
     +     '<'//TRIM(s_vec_tmax_sourcelett(i_flag_linenumber))//'>'
         ENDIF
c        TMIN
         IF (TRIM(s_flag_varname).EQ.'TMIN') THEN
          WRITE(5,FMT=1016) 'Variable value=',
     +     '<'//TRIM(s_vec_tmin_c(i_flag_linenumber))//'>'
          WRITE(5,FMT=1016) 'Attrib string= ',
     +     '<'//TRIM(s_vec_tmin_attrib(i_flag_linenumber))//'>'
          WRITE(5,FMT=1016) 'Source letter= ',
     +     '<'//TRIM(s_vec_tmin_sourcelett(i_flag_linenumber))//'>'
         ENDIF
c        TAVG
         IF (TRIM(s_flag_varname).EQ.'TAVG') THEN
          WRITE(5,FMT=1016) 'Variable value=',
     +     '<'//TRIM(s_vec_tavg_c(i_flag_linenumber))//'>'
          WRITE(5,FMT=1016) 'Attrib string= ',
     +     '<'//TRIM(s_vec_tavg_attrib(i_flag_linenumber))//'>'
          WRITE(5,FMT=1016) 'Source letter= ',
     +     '<'//TRIM(s_vec_tavg_sourcelett(i_flag_linenumber))//'>'
         ENDIF
c        PRCP
         IF (TRIM(s_flag_varname).EQ.'PRCP') THEN
          WRITE(5,FMT=1016) 'Variable value=',
     +     '<'//TRIM(s_vec_prcp_mm(i_flag_linenumber))//'>'
          WRITE(5,FMT=1016) 'Attrib string= ',
     +     '<'//TRIM(s_vec_prcp_attrib(i_flag_linenumber))//'>'
          WRITE(5,FMT=1016) 'Source letter= ',
     +     '<'//TRIM(s_vec_prcp_sourcelett(i_flag_linenumber))//'>'
         ENDIF
c        SNOW
         IF (TRIM(s_flag_varname).EQ.'SNOW') THEN
          WRITE(5,FMT=1016) 'Variable value=',
     +     '<'//TRIM(s_vec_snow_mm(i_flag_linenumber))//'>'
          WRITE(5,FMT=1016) 'Attrib string= ',
     +     '<'//TRIM(s_vec_snow_attrib(i_flag_linenumber))//'>'
          WRITE(5,FMT=1016) 'Source letter= ',
     +     '<'//TRIM(s_vec_snow_sourcelett(i_flag_linenumber))//'>'
         ENDIF
c        AWND
         IF (TRIM(s_flag_varname).EQ.'AWND') THEN
          WRITE(5,FMT=1016) 'Variable value=',
     +     '<'//TRIM(s_vec_awnd_ms(i_flag_linenumber))//'>'
          WRITE(5,FMT=1016) 'Attrib string= ',
     +     '<'//TRIM(s_vec_awnd_attrib(i_flag_linenumber))//'>'
          WRITE(5,FMT=1016) 'Source letter= ',
     +     '<'//TRIM(s_vec_awnd_ms(i_flag_linenumber))//'>'
         ENDIF

1016     FORMAT(t1,a15,t17,a10) 
         WRITE(5,FMT=1002) '                                        '

       CLOSE(UNIT=5)

      ENDIF

c     Case of old file
      IF (s_filestatus1.EQ.'OLD') THEN 

        OPEN(UNIT=5,
     +   FILE=TRIM(s_pathandname),
     +   FORM='formatted',
     +   STATUS='OLD',ACTION='WRITE',ACCESS='append')

c 1002    FORMAT(a40)
c 1006    FORMAT(t1,a9,t11,a8,t20,a10,t31,a5)

         WRITE(5,FMT=1008) 'Error index=   ',i_bad_sourceletter
         WRITE(5,FMT=1008) 'Station index= ',i_index
c 1008    FORMAT(t1,a15,t17,i6)  
         WRITE(5,FMT=1009) 'Station name=  ',TRIM(s_stnname_single)
c 1009    FORMAT(t1,a15,t17,a11)     
         WRITE(5,FMT=1010) 'Variable name= ',s_flag_varname
c 1010    FORMAT(t1,a15,t17,a4) 
         WRITE(5,FMT=1012) 'Line number=   ',i_flag_linenumber
c 1012    FORMAT(t1,a15,t17,i6) 
         WRITE(5,FMT=1014) 'Date=          ',
     +     s_vec_date(i_flag_linenumber)
c 1014    FORMAT(t1,a15,t17,a7) 

c        TMAX
         IF (TRIM(s_flag_varname).EQ.'TMAX') THEN
          WRITE(5,FMT=1016) 'Variable value=',
     +     '<'//TRIM(s_vec_tmax_c(i_flag_linenumber))//'>'
          WRITE(5,FMT=1016) 'Attrib string= ',
     +     '<'//TRIM(s_vec_tmax_attrib(i_flag_linenumber))//'>'
          WRITE(5,FMT=1016) 'Source letter= ',
     +     '<'//TRIM(s_vec_tmax_sourcelett(i_flag_linenumber))//'>'
         ENDIF
c        TMIN
         IF (TRIM(s_flag_varname).EQ.'TMIN') THEN
          WRITE(5,FMT=1016) 'Variable value=',
     +     '<'//TRIM(s_vec_tmin_c(i_flag_linenumber))//'>'
          WRITE(5,FMT=1016) 'Attrib string= ',
     +     '<'//TRIM(s_vec_tmin_attrib(i_flag_linenumber))//'>'
          WRITE(5,FMT=1016) 'Source letter= ',
     +     '<'//TRIM(s_vec_tmin_sourcelett(i_flag_linenumber))//'>'
         ENDIF
c        TAVG
         IF (TRIM(s_flag_varname).EQ.'TAVG') THEN
          WRITE(5,FMT=1016) 'Variable value=',
     +     '<'//TRIM(s_vec_tavg_c(i_flag_linenumber))//'>'
          WRITE(5,FMT=1016) 'Attrib string= ',
     +     '<'//TRIM(s_vec_tavg_attrib(i_flag_linenumber))//'>'
          WRITE(5,FMT=1016) 'Source letter= ',
     +     '<'//TRIM(s_vec_tavg_sourcelett(i_flag_linenumber))//'>'
         ENDIF
c        PRCP
         IF (TRIM(s_flag_varname).EQ.'PRCP') THEN
          WRITE(5,FMT=1016) 'Variable value=',
     +     '<'//TRIM(s_vec_prcp_mm(i_flag_linenumber))//'>'
          WRITE(5,FMT=1016) 'Attrib string= ',
     +     '<'//TRIM(s_vec_prcp_attrib(i_flag_linenumber))//'>'
          WRITE(5,FMT=1016) 'Source letter= ',
     +     '<'//TRIM(s_vec_prcp_sourcelett(i_flag_linenumber))//'>'
         ENDIF
c        SNOW
         IF (TRIM(s_flag_varname).EQ.'SNOW') THEN
          WRITE(5,FMT=1016) 'Variable value=',
     +     '<'//TRIM(s_vec_snow_mm(i_flag_linenumber))//'>'
          WRITE(5,FMT=1016) 'Attrib string= ',
     +     '<'//TRIM(s_vec_snow_attrib(i_flag_linenumber))//'>'
          WRITE(5,FMT=1016) 'Source letter= ',
     +     '<'//TRIM(s_vec_snow_sourcelett(i_flag_linenumber))//'>'
         ENDIF
c        AWND
         IF (TRIM(s_flag_varname).EQ.'AWND') THEN
          WRITE(5,FMT=1016) 'Variable value=',
     +     '<'//TRIM(s_vec_awnd_ms(i_flag_linenumber))//'>'
          WRITE(5,FMT=1016) 'Attrib string= ',
     +     '<'//TRIM(s_vec_awnd_attrib(i_flag_linenumber))//'>'
          WRITE(5,FMT=1016) 'Source letter= ',
     +     '<'//TRIM(s_vec_awnd_ms(i_flag_linenumber))//'>'
         ENDIF

c1016     FORMAT(t1,a15,t17,a10) 
         WRITE(5,FMT=1002) '                                        '

       CLOSE(UNIT=5)

      ENDIF

c************************************************************************

      print*,'just leaving export_test2'

      RETURN
      END
