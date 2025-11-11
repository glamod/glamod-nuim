c     Subroutine to export linecounts
c     AJ_Kettle, 27Apr2021

      SUBROUTINE export_stnlist_linecount(s_date_st,s_time_st,
     +  s_directory_diagnostics,s_file_linecount,
     +  s_single_stn,l_vec_lines,
     +  l_amal)

      IMPLICIT NONE
c************************************************************************
c     Variables passed into subroutine

      CHARACTER(LEN=8)    :: s_date_st
      CHARACTER(LEN=10)   :: s_time_st

      CHARACTER(LEN=300)  :: s_directory_diagnostics
      CHARACTER(LEN=300)  :: s_file_linecount
      CHARACTER(LEN=32)   :: s_single_stn
      INTEGER             :: l_vec_lines(3)

      INTEGER             :: l_amal
c*****
c     Variables used in subroutine
      INTEGER             :: i,j,k,ii,jj,kk
      INTEGER             :: io

      CHARACTER(LEN=300)  :: s_pathandname

      LOGICAL             :: there
      CHARACTER(LEN=3)    :: s_filestatus1

      CHARACTER(LEN=32)   :: s_single_stn_strip
      INTEGER             :: i_len
c************************************************************************

c*****
      i_len=LEN_TRIM(s_single_stn)
      s_single_stn_strip=s_single_stn(1:i_len-4)
c*****
      s_pathandname=
     +  TRIM(s_directory_diagnostics)//TRIM(s_file_linecount)
c*****
c     Find if file already exists
      INQUIRE(FILE=TRIM(s_pathandname),
     +  EXIST=there)

      IF (there) THEN
       s_filestatus1='OLD'
      ENDIF
      IF (.NOT.(there)) THEN
       s_filestatus1='NEW'
      ENDIF
c*****
c     Place header line here for new file
      IF (s_filestatus1.EQ.'NEW') THEN 

      OPEN(UNIT=2,
     +  FILE=TRIM(s_pathandname),
     +  FORM='formatted',
     +  STATUS='REPLACE',ACTION='WRITE')

      WRITE(2,1000) 'Station listing with source file year   '
      WRITE(2,1000) '                                        '
      WRITE(2,1002) s_date_st,s_time_st
      WRITE(2,1000) '                                        '
      WRITE(2,1000) 'subdirectory:export_stnlist_linecount.f '
      WRITE(2,1000) '                                        '
      WRITE(2,1003) 'N_stns= ',l_amal
      WRITE(2,1000) '                                        '

 1000 FORMAT(t1,a40)
 1002 FORMAT(t1,a8,t10,a6)
 1003 FORMAT(t1,a8,t10,i6)

      WRITE(2,1004) 'Station Netplat ','Count ','Count ','Count '
      WRITE(2,1004) '                ','2019  ','2020  ','2021  '
      WRITE(2,1004) '+--------------+','+----+','+----+','+----+'
 1004 FORMAT(t1,a16,t18,a6,t25,a6,t32,a6)

      CLOSE(UNIT=2)
      ENDIF
c*****
c     Output data line to old file

      OPEN(UNIT=2,
     +  FILE=TRIM(s_pathandname),
     +  FORM='formatted',
     +  STATUS='OLD',ACTION='WRITE',ACCESS='APPEND')

      WRITE(2,1006) ADJUSTL(s_single_stn_strip),
     +  l_vec_lines(1),
     +  l_vec_lines(2),
     +  l_vec_lines(3)
 1006 FORMAT(t1,a16,t18,i6,t25,i6,t32,i6)

      CLOSE(UNIT=2)
c*****

      RETURN
      END
