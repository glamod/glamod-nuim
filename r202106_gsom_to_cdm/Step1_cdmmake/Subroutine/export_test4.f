c     Subroutine to output line summary for test4 
c     AJ_Kettle, 12Nov2019

      SUBROUTINE export_test4(s_date_st,s_time_st,s_zone_st,
     +    i_bad_recordnumber,
     +    s_directory_output_diagnostics,s_filename_test4,
     +    i_index,s_stnname_single,
     +    i_flag_linenumber,s_flag_varname,
     +    l_collect_cnt,
     +    s_collect_record_number,s_collect_source_id,
     +    l_rgh_lines,l_lines,
     +    s_vec_date,
     +    s_vec_tmax_c,s_vec_tmin_c,s_vec_tavg_c,
     +    s_vec_prcp_mm,s_vec_snow_mm,s_vec_awnd_ms,
     +    s_vec_tmax_attrib,s_vec_tmin_attrib,
     +    s_vec_tavg_attrib,s_vec_prcp_attrib,
     +    s_vec_snow_attrib,s_vec_awnd_attrib,
     +    s_vec_tmax_sourcelett,s_vec_tmin_sourcelett,
     +    s_vec_tavg_sourcelett,s_vec_prcp_sourcelett,
     +    s_vec_snow_sourcelett,s_vec_awnd_sourcelett,
     +    s_vec_tmax_sourcenum,s_vec_tmin_sourcenum,
     +    s_vec_tavg_sourcenum,s_vec_prcp_sourcenum,
     +    s_vec_snow_sourcenum,s_vec_awnd_sourcenum)

      IMPLICIT NONE
c************************************************************************
c     Variables passed into subroutine

      CHARACTER(LEN=8)    :: s_date_st
      CHARACTER(LEN=10)   :: s_time_st
      CHARACTER(LEN=5)    :: s_zone_st

      INTEGER             :: i_bad_recordnumber

      CHARACTER(LEN=300)  :: s_directory_output_diagnostics
      CHARACTER(LEN=300)  :: s_filename_test4

      INTEGER             :: i_index
      CHARACTER(LEN=*)    :: s_stnname_single

      INTEGER             :: i_flag_linenumber
      CHARACTER(LEN=4)    :: s_flag_varname

      INTEGER             :: l_collect_cnt
      CHARACTER(LEN=*)    :: s_collect_record_number(20)
      CHARACTER(LEN=*)    :: s_collect_source_id(20)

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

      CHARACTER(LEN=*)    :: s_vec_tmax_sourcenum(l_rgh_lines)
      CHARACTER(LEN=*)    :: s_vec_tmin_sourcenum(l_rgh_lines)
      CHARACTER(LEN=*)    :: s_vec_tavg_sourcenum(l_rgh_lines)
      CHARACTER(LEN=*)    :: s_vec_prcp_sourcenum(l_rgh_lines)
      CHARACTER(LEN=*)    :: s_vec_snow_sourcenum(l_rgh_lines)
      CHARACTER(LEN=*)    :: s_vec_awnd_sourcenum(l_rgh_lines)
c*****
c     Variables used within subroutine

      INTEGER             :: i,j,k,ii,jj,kk

      CHARACTER(LEN=300)  :: s_pathandname
      CHARACTER(LEN=3)    :: s_filestatus1
      LOGICAL             :: there

      CHARACTER(LEN=50)   :: s_assem_source_id 
      CHARACTER(LEN=50)   :: s_assem_record_number
      INTEGER             :: i_len_source_id
      INTEGER             :: i_len_record_number
c************************************************************************
      print*,'just entered export_test4'

      print*,'s_directory_output_diagnostics=',
     +   s_directory_output_diagnostics
      print*,'s_filename_test4=',s_filename_test4

      print*,'i_index=',i_index
      print*,'s_stnname_single=',TRIM(s_stnname_single)
      print*,'i_flag_linenumber=',i_flag_linenumber
      print*,'s_flag_varname=',s_flag_varname
      print*,'l_collect_cnt=',l_collect_cnt
      print*,'s_collect_record_number=',
     +  (TRIM(s_collect_record_number(i)),i=1,l_collect_cnt)
      print*,'s_collect_source_id=',
     +  (TRIM(s_collect_source_id(i)),i=1,l_collect_cnt)

      s_pathandname=
     +  TRIM(s_directory_output_diagnostics)//TRIM(s_filename_test4)

      print*,'s_pathandname=',TRIM(s_pathandname)
c************************************************************************
c     String together info from stnconfig

      s_assem_source_id    =''     !Initialize strings with null values 
      s_assem_record_number=''

      DO i=1,l_collect_cnt
       s_assem_source_id=
     +TRIM(s_assem_source_id)//TRIM(s_collect_source_id(i))//'|'
       s_assem_record_number=
     +TRIM(s_assem_record_number)//TRIM(s_collect_record_number(i))//'|'
      ENDDO

      i_len_source_id    =LEN_TRIM(s_assem_source_id)
      i_len_record_number=LEN_TRIM(s_assem_record_number)

      IF (i_len_source_id.GE.50) THEN 
       print*,'emergency stop, i_len_source_id=',i_len_source_id
       STOP 'export_test4'
      ENDIF
      IF (i_len_record_number.GE.50) THEN 
       print*,'emergency stop, i_len_record_number=',i_len_record_number
       STOP 'export_test4'
      ENDIF
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

         WRITE(5,FMT=1002) 'Test 4: source nr not found in stnconfig'
         WRITE(5,FMT=1002) '                                        '
         WRITE(5,FMT=1006) 'AJ_Kettle',s_date_st,s_time_st,s_zone_st
         WRITE(5,FMT=1002) '                                        '
         WRITE(5,FMT=1002) 'subroutine: export_test4.f              '
         WRITE(5,FMT=1002) '                                        '

 1002    FORMAT(a40)
 1006    FORMAT(t1,a9,t11,a8,t20,a10,t31,a5)
 1008    FORMAT(t1,a15,t17,i6)  
 1009    FORMAT(t1,a15,t17,a11)     
 1012    FORMAT(t1,a15,t17,i6) 
 1014    FORMAT(t1,a15,t17,a7) 
 1010    FORMAT(t1,a15,t17,a4) 
 1016    FORMAT(t1,a15,t17,a10) 
 1018    FORMAT(t1,a15,t17,i2)
 1020    FORMAT(t1,a15,t17,a50)

         WRITE(5,FMT=1008) 'Error index=   ',i_bad_recordnumber
         WRITE(5,FMT=1008) 'Station index= ',i_index
         WRITE(5,FMT=1009) 'Station name=  ',TRIM(s_stnname_single)
         WRITE(5,FMT=1012) 'Line number=   ',i_flag_linenumber
         WRITE(5,FMT=1014) 'Date=          ',
     +     s_vec_date(i_flag_linenumber)
         WRITE(5,FMT=1010) 'Variable name= ',s_flag_varname

         IF (TRIM(s_flag_varname).EQ.'TMAX') THEN
          WRITE(5,FMT=1016) 'Variable value=',
     +     s_vec_tmax_c(i_flag_linenumber)
          WRITE(5,FMT=1016) 'Attrib string= ',
     +     s_vec_tmax_attrib(i_flag_linenumber)
          WRITE(5,FMT=1016) 'Source letter= ',
     +     s_vec_tmax_sourcelett(i_flag_linenumber)
          WRITE(5,FMT=1016) 'Source number= ',
     +     s_vec_tmax_sourcenum(i_flag_linenumber)
         ENDIF
         IF (TRIM(s_flag_varname).EQ.'TMIN') THEN
          WRITE(5,FMT=1016) 'Variable value=',
     +     s_vec_tmin_c(i_flag_linenumber)
          WRITE(5,FMT=1016) 'Attrib string= ',
     +     s_vec_tmin_attrib(i_flag_linenumber)
          WRITE(5,FMT=1016) 'Source letter= ',
     +     s_vec_tmin_sourcelett(i_flag_linenumber)
          WRITE(5,FMT=1016) 'Source number= ',
     +     s_vec_tmin_sourcenum(i_flag_linenumber)
         ENDIF
         IF (TRIM(s_flag_varname).EQ.'TAVG') THEN
          WRITE(5,FMT=1016) 'Variable value=',
     +     s_vec_tavg_c(i_flag_linenumber)
          WRITE(5,FMT=1016) 'Attrib string= ',
     +     s_vec_tavg_attrib(i_flag_linenumber)
          WRITE(5,FMT=1016) 'Source letter= ',
     +     s_vec_tavg_sourcelett(i_flag_linenumber)
          WRITE(5,FMT=1016) 'Source number= ',
     +     s_vec_tavg_sourcenum(i_flag_linenumber)
         ENDIF
         IF (TRIM(s_flag_varname).EQ.'PRCP') THEN
          WRITE(5,FMT=1016) 'Variable value=',
     +     s_vec_prcp_mm(i_flag_linenumber)
          WRITE(5,FMT=1016) 'Attrib string= ',
     +     s_vec_prcp_attrib(i_flag_linenumber)
          WRITE(5,FMT=1016) 'Source letter= ',
     +     s_vec_prcp_sourcelett(i_flag_linenumber)
          WRITE(5,FMT=1016) 'Source number= ',
     +     s_vec_prcp_sourcenum(i_flag_linenumber)
         ENDIF
         IF (TRIM(s_flag_varname).EQ.'SNOW') THEN
          WRITE(5,FMT=1016) 'Variable value=',
     +     s_vec_snow_mm(i_flag_linenumber)
          WRITE(5,FMT=1016) 'Attrib string= ',
     +     s_vec_snow_attrib(i_flag_linenumber)
          WRITE(5,FMT=1016) 'Source letter= ',
     +     s_vec_snow_sourcelett(i_flag_linenumber)
          WRITE(5,FMT=1016) 'Source number= ',
     +     s_vec_snow_sourcenum(i_flag_linenumber)
         ENDIF
         IF (TRIM(s_flag_varname).EQ.'AWND') THEN
          WRITE(5,FMT=1016) 'Variable value=',
     +     s_vec_awnd_ms(i_flag_linenumber)
          WRITE(5,FMT=1016) 'Attrib string= ',
     +     s_vec_awnd_attrib(i_flag_linenumber)
          WRITE(5,FMT=1016) 'Source letter= ',
     +     s_vec_awnd_sourcelett(i_flag_linenumber)
          WRITE(5,FMT=1016) 'Source number= ',
     +     s_vec_awnd_sourcenum(i_flag_linenumber)
         ENDIF

         WRITE(5,FMT=1018) 'SClist N_elemnt',l_collect_cnt
         WRITE(5,FMT=1020) 'SClist sourceid',TRIM(s_assem_source_id) 
         WRITE(5,FMT=1020) 'SClist recordnr',TRIM(s_assem_record_number)

         WRITE(5,FMT=1002) '                                        '

       CLOSE(UNIT=5)

      ENDIF
c*****
c     Case of old file
      IF (s_filestatus1.EQ.'OLD') THEN 

        OPEN(UNIT=5,
     +   FILE=TRIM(s_pathandname),
     +   FORM='formatted',
     +   STATUS='OLD',ACTION='WRITE',ACCESS='append')

         WRITE(5,FMT=1008) 'Error index=   ',i_bad_recordnumber
         WRITE(5,FMT=1008) 'Station index= ',i_index
         WRITE(5,FMT=1009) 'Station name=  ',TRIM(s_stnname_single)
         WRITE(5,FMT=1012) 'Line number=   ',i_flag_linenumber
         WRITE(5,FMT=1014) 'Date=          ',
     +     s_vec_date(i_flag_linenumber)
         WRITE(5,FMT=1010) 'Variable name= ',s_flag_varname

         IF (TRIM(s_flag_varname).EQ.'TMAX') THEN
          WRITE(5,FMT=1016) 'Variable value=',
     +     s_vec_tmax_c(i_flag_linenumber)
          WRITE(5,FMT=1016) 'Attrib string= ',
     +     s_vec_tmax_attrib(i_flag_linenumber)
          WRITE(5,FMT=1016) 'Source letter= ',
     +     s_vec_tmax_sourcelett(i_flag_linenumber)
          WRITE(5,FMT=1016) 'Source number= ',
     +     s_vec_tmax_sourcenum(i_flag_linenumber)
         ENDIF
         IF (TRIM(s_flag_varname).EQ.'TMIN') THEN
          WRITE(5,FMT=1016) 'Variable value=',
     +     s_vec_tmin_c(i_flag_linenumber)
          WRITE(5,FMT=1016) 'Attrib string= ',
     +     s_vec_tmin_attrib(i_flag_linenumber)
          WRITE(5,FMT=1016) 'Source letter= ',
     +     s_vec_tmin_sourcelett(i_flag_linenumber)
          WRITE(5,FMT=1016) 'Source number= ',
     +     s_vec_tmin_sourcenum(i_flag_linenumber)
         ENDIF
         IF (TRIM(s_flag_varname).EQ.'TAVG') THEN
          WRITE(5,FMT=1016) 'Variable value=',
     +     s_vec_tavg_c(i_flag_linenumber)
          WRITE(5,FMT=1016) 'Attrib string= ',
     +     s_vec_tavg_attrib(i_flag_linenumber)
          WRITE(5,FMT=1016) 'Source letter= ',
     +     s_vec_tavg_sourcelett(i_flag_linenumber)
          WRITE(5,FMT=1016) 'Source number= ',
     +     s_vec_tavg_sourcenum(i_flag_linenumber)
         ENDIF
         IF (TRIM(s_flag_varname).EQ.'PRCP') THEN
          WRITE(5,FMT=1016) 'Variable value=',
     +     s_vec_prcp_mm(i_flag_linenumber)
          WRITE(5,FMT=1016) 'Attrib string= ',
     +     s_vec_prcp_attrib(i_flag_linenumber)
          WRITE(5,FMT=1016) 'Source letter= ',
     +     s_vec_prcp_sourcelett(i_flag_linenumber)
          WRITE(5,FMT=1016) 'Source number= ',
     +     s_vec_prcp_sourcenum(i_flag_linenumber)
         ENDIF
         IF (TRIM(s_flag_varname).EQ.'SNOW') THEN
          WRITE(5,FMT=1016) 'Variable value=',
     +     s_vec_snow_mm(i_flag_linenumber)
          WRITE(5,FMT=1016) 'Attrib string= ',
     +     s_vec_snow_attrib(i_flag_linenumber)
          WRITE(5,FMT=1016) 'Source letter= ',
     +     s_vec_snow_sourcelett(i_flag_linenumber)
          WRITE(5,FMT=1016) 'Source number= ',
     +     s_vec_snow_sourcenum(i_flag_linenumber)
         ENDIF
         IF (TRIM(s_flag_varname).EQ.'AWND') THEN
          WRITE(5,FMT=1016) 'Variable value=',
     +     s_vec_awnd_ms(i_flag_linenumber)
          WRITE(5,FMT=1016) 'Attrib string= ',
     +     s_vec_awnd_attrib(i_flag_linenumber)
          WRITE(5,FMT=1016) 'Source letter= ',
     +     s_vec_awnd_sourcelett(i_flag_linenumber)
          WRITE(5,FMT=1016) 'Source number= ',
     +     s_vec_awnd_sourcenum(i_flag_linenumber)
         ENDIF

         WRITE(5,FMT=1018) 'SClist N_elemnt',l_collect_cnt
         WRITE(5,FMT=1020) 'SClist sourceid',TRIM(s_assem_source_id) 
         WRITE(5,FMT=1020) 'SClist recordnr',TRIM(s_assem_record_number)

         WRITE(5,FMT=1002) '                                        '

       CLOSE(UNIT=5)

      ENDIF
c*****
      print*,'just leaving export_test4'

c      STOP 'export_test4'

      RETURN
      END
