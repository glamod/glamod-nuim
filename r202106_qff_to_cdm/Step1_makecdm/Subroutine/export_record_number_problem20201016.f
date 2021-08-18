c     Subroutine to export problem record number
c     AJ_Kettle, 17Jun2020

      SUBROUTINE export_record_number_problem20201016(
     +  s_directory_output_diagnostics,s_stnname_isolated,
     +  s_var_name,s_single_airt_c,s_single_airt_sourcenum,
     +  l_cc_rgh,l_collect_cnt,
     +  s_collect_source_id,s_collect_record_number,
     +  i_flag_linenumber)

      IMPLICIT NONE
c************************************************************************
c     Variables passed into subroutine

      CHARACTER(LEN=*)    :: s_directory_output_diagnostics
      CHARACTER(LEN=*)    :: s_stnname_isolated

      CHARACTER(LEN=*)    :: s_var_name
      CHARACTER(LEN=*)    :: s_single_airt_c
      CHARACTER(LEN=*)    :: s_single_airt_sourcenum

      INTEGER             :: l_cc_rgh
      INTEGER             :: l_collect_cnt
      CHARACTER(LEN=*)    :: s_collect_source_id(l_cc_rgh)
      CHARACTER(LEN=*)    :: s_collect_record_number(l_cc_rgh)

      INTEGER             :: i_flag_linenumber
c*****
c     Variables from used in subroutine

      INTEGER             :: i,j,k,ii,jj,kk

      CHARACTER(LEN=300)  :: s_pathandname

      LOGICAL             :: there
      CHARACTER(LEN=300)  :: s_filestatus1
c************************************************************************
      print*,'just entered export_record_number_problem'

      s_pathandname=
     +  TRIM(s_directory_output_diagnostics)//TRIM(s_stnname_isolated)

      print*,'s_pathandname=',TRIM(s_pathandname)
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

         WRITE(5,FMT=1002) 'Export record number problem            '
         WRITE(5,FMT=1002) '                                        '
         WRITE(5,FMT=1002) 'subrout: export_record_number_problem.f '
         WRITE(5,FMT=1002) '                                        '

         WRITE(5,FMT=1004) 'Variable Name:      ',ADJUSTL(s_var_name)
         WRITE(5,FMT=1004) 'Variable Value:     ',
     +      ADJUSTL(TRIM(s_single_airt_c))
         WRITE(5,FMT=1004) 'Presented Sourceid: ',
     +      ADJUSTL(s_single_airt_sourcenum)
         WRITE(5,FMT=1005) 'Line number:        ',i_flag_linenumber 
         WRITE(5,FMT=1002) 'Stnconfig list sourceid/recordnumbers   '
         WRITE(5,FMT=1006) 'N_record:',l_collect_cnt
         DO i=1,l_collect_cnt
          WRITE(5,FMT=1008) 
     +       i,s_collect_source_id(i),s_collect_record_number(i)
         ENDDO
         WRITE(5,FMT=1002) '                                        '

 1002    FORMAT(a40)
 1004    FORMAT(t1,a20,t22,a15)
 1005    FORMAT(t1,a20,t22,i6)
 1006    FORMAT(t1,a9,t11,i3)
 1008    FORMAT(t1,i3,t5,a3,t9,a3)

       CLOSE(UNIT=5)
      ENDIF
c*****
c     Case of old file
      IF (s_filestatus1.EQ.'OLD') THEN 

       OPEN(UNIT=5,
     +   FILE=TRIM(s_pathandname),
     +   FORM='formatted',
     +   STATUS='OLD',ACTION='WRITE',ACCESS='append')

         WRITE(5,FMT=1004) 'Variable Name:      ',ADJUSTL(s_var_name)
         WRITE(5,FMT=1004) 'Variable Value:     ',
     +      ADJUSTL(TRIM(s_single_airt_c))
         WRITE(5,FMT=1004) 'Presented Sourceid: ',
     +      ADJUSTL(s_single_airt_sourcenum)
         WRITE(5,FMT=1002) 'Stnconfig list sourceid/recordnumbers   '
         WRITE(5,FMT=1006) 'N_record:',l_collect_cnt
         DO i=1,l_collect_cnt
          WRITE(5,FMT=1008) 
     +       i,s_collect_source_id(i),s_collect_record_number(i)
         ENDDO
         WRITE(5,FMT=1002) '                                        '

       CLOSE(UNIT=5)
      ENDIF
c*****
      print*,'just leaving export_record_number_problem'

      RETURN
      END
