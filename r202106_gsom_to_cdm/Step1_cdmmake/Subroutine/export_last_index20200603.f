c     Subroutine to export index of finished file
c     AJ_Kettle, 22Mar2019
c     03Jun2020: modified for gsom processing

      SUBROUTINE export_last_index20200603(
     +   s_directory_lastfile,i,ii,
     +   i_values_st,
     +   i_bad_stnconlisting,i_bad_sourceletter,i_bad_newletter,
     +   i_bad_recordnumber,i_bad_cdmmaker)

c      SUBROUTINE export_last_index(s_directory_lastfile,i,ii,
c     +   ii_cnt_skip1,ii_cnt_skip2,i_values_st)

      IMPLICIT NONE
c************************************************************************
c     Variables passed into program

      CHARACTER(LEN=300)  :: s_directory_lastfile
      INTEGER             :: i
      INTEGER             :: ii
      INTEGER             :: ii_cnt_skip1
      INTEGER             :: ii_cnt_skip2

      INTEGER             :: i_values_st(8)

      INTEGER             :: i_bad_stnconlisting
      INTEGER             :: i_bad_sourceletter
      INTEGER             :: i_bad_newletter
      INTEGER             :: i_bad_recordnumber
      INTEGER             :: i_bad_cdmmaker
c*****
c     Variables used within subroutine

      LOGICAL             :: there
      INTEGER             :: io
      CHARACTER(LEN=300)  :: s_command

      CHARACTER(LEN=8)    :: s_date_en
      CHARACTER(LEN=10)   :: s_time_en
      CHARACTER(LEN=5)    :: s_zone_en
      INTEGER             :: i_values_en(8)

      REAL                :: f_clock_st_s,f_clock_en_s
c************************************************************************
c      print*,'just inside export_last_index'

c     Find date & time
      CALL DATE_AND_TIME(s_date_en,s_time_en,s_zone_en,i_values_en)
c************************************************************************
c     Find start & end clock times
      f_clock_st_s=FLOAT(i_values_st(3))*24.0*60.0*60.0+
     +  FLOAT(i_values_st(5))*60.0*60.0+FLOAT(i_values_st(6))*60.0+
     +  FLOAT(i_values_st(7))
      f_clock_en_s=FLOAT(i_values_en(3))*24.0*60.0*60.0+
     +  FLOAT(i_values_en(5))*60.0*60.0+FLOAT(i_values_en(6))*60.0+
     +  FLOAT(i_values_en(7))
c************************************************************************
cc     Inquire if file exists
c      INQUIRE(FILE=TRIM(s_directory_lastfile)//'lastfile.dat',
c     +  EXIST=there)

cc     Erase old index archive file
c      IF (there) THEN
cc      UNIX
c       s_command='rm '//TRIM(s_directory_lastfile)//'lastfile.dat'
cc      MSDOS
cc      s_command='del /Q '//TRIM(s_directory_out3)//'lastfile.dat'
cc       print*,'s_command',TRIM(s_command)
c       CALL SYSTEM(s_command,io)
c      ENDIF

c      OPEN(UNIT=2,FILE=TRIM(s_directory_lastfile)//'lastfile.dat',
c     +  FORM='formatted',STATUS='NEW',ACTION='WRITE')      

c       WRITE(2,1000,IOSTAT=io) 'i= ',i
c       WRITE(2,1000,IOSTAT=io) 'ii=',ii
c1000   FORMAT(t1,a3,t5,i7)

c      CLOSE(UNIT=2)
c************************************************************************
      OPEN(UNIT=2,FILE=TRIM(s_directory_lastfile)//'lastfile.dat',
     +  FORM='formatted',STATUS='REPLACE',ACTION='WRITE')      

       WRITE(2,1000,IOSTAT=io) 'i= ',i
       WRITE(2,1000,IOSTAT=io) 'ii=',ii

       WRITE(2,1001,IOSTAT=io) 'T1:stnconf',i_bad_stnconlisting
       WRITE(2,1001,IOSTAT=io) 'T2:srclett',i_bad_sourceletter
       WRITE(2,1001,IOSTAT=io) 'T3:newlett',i_bad_newletter
       WRITE(2,1001,IOSTAT=io) 'T4:rcrdnum',i_bad_recordnumber
       WRITE(2,1001,IOSTAT=io) 'T5:cdmmake',i_bad_cdmmaker

       WRITE(2,1002,IOSTAT=io) 'date/time=',s_date_en,s_time_en
       WRITE(2,1004,IOSTAT=io) 'clock time=',
     +  (f_clock_en_s-f_clock_st_s)/3600.0,'h'

1000  FORMAT(t1,a3,t5,i7)
1001  FORMAT(t1,a10,t12,i5)
1002  FORMAT(t1,a10,t12,a8,t21,a10)
1004  FORMAT(t1,a11,t13,f8.4,t22,a1)

      CLOSE(UNIT=2)
c************************************************************************
c      print*,'just leaving export_last_index'
c      STOP 'export_last_index'

      RETURN
      END
