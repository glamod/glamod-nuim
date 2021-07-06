c     Subroutine to export stations not in selection file
c     AJ_Kettle, 15Nov2019

      SUBROUTINE export_test1(s_date_st,s_time_st,s_zone_st,
     +  i_bad_stnconlisting,
     +  s_directory_output_diagnostics,s_filename_test1,
     +  i_index,s_stnname_single)

      IMPLICIT NONE
c************************************************************************
c     Variables passed into subroutine

      CHARACTER(LEN=8)    :: s_date_st
      CHARACTER(LEN=10)   :: s_time_st
      CHARACTER(LEN=5)    :: s_zone_st

      INTEGER             :: i_bad_stnconlisting

      CHARACTER(LEN=300)  :: s_directory_output_diagnostics
      CHARACTER(LEN=300)  :: s_filename_test1

      INTEGER             :: i_index
      CHARACTER(LEN=11)   :: s_stnname_single
c*****
c     Variables used within subroutine

      INTEGER             :: i,j,k,ii,jj,kk

      CHARACTER(LEN=300)  :: s_pathandname
      CHARACTER(LEN=3)    :: s_filestatus1
      LOGICAL             :: there
c************************************************************************
      print*,'export_test1'

      s_pathandname=
     +  TRIM(s_directory_output_diagnostics)//TRIM(s_filename_test1)
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

 1002    FORMAT(a40)
 1006    FORMAT(t1,a9,t11,a8,t20,a10,t31,a5)
 1016    FORMAT(t1,i6,t8,a11)

        WRITE(5,FMT=1002) 'Test 1: listed stn name /w no data file '
        WRITE(5,FMT=1002) '                                        '
        WRITE(5,FMT=1006) 'AJ_Kettle',s_date_st,s_time_st,s_zone_st
        WRITE(5,FMT=1002) '                                        '
        WRITE(5,FMT=1002) 'subroutine: export_test1.f              '
        WRITE(5,FMT=1002) '                                        '

        WRITE(5,FMT=1016) i_index,s_stnname_single

       CLOSE(UNIT=5)

      ENDIF

      IF (s_filestatus1.EQ.'OLD') THEN

       OPEN(UNIT=5,
     +   FILE=TRIM(s_pathandname),
     +   FORM='formatted',
     +   STATUS='OLD',ACTION='WRITE',ACCESS='append')
 
        WRITE(5,FMT=1016) i_index,s_stnname_single

       CLOSE(UNIT=5)
      ENDIF

      print*,'just leaving export_test1'

      RETURN
      END
