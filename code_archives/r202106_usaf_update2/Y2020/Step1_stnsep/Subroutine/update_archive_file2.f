c     Subroutine to create archive file
c     AJ_Kettle, 28Oct2020

      SUBROUTINE update_archive_file2(s_directory_3archive,i_index,
     +   f_loop_time_st,f_loop_time_en,
     +   s_loop_date_st,s_loop_time_st,i_loop_values_st,
     +   s_loop_date_en,s_loop_time_en,i_loop_values_en)

      IMPLICIT NONE
c************************************************************************
c     Declare variables 

      CHARACTER(LEN=300)  :: s_directory_3archive
      INTEGER             :: i_index

      REAL                :: f_loop_time_st,f_loop_time_en
      CHARACTER(LEN=8)    :: s_loop_date_st
      CHARACTER(LEN=10)   :: s_loop_time_st
      INTEGER             :: i_loop_values_st(8)
      CHARACTER(LEN=8)    :: s_loop_date_en
      CHARACTER(LEN=10)   :: s_loop_time_en
      INTEGER             :: i_loop_values_en(8)
c*****
c     Variables used in subroutine

      INTEGER             :: i,j,k,ii,jj,kk
      CHARACTER(LEN=4)    :: s_index 
      CHARACTER(LEN=12)   :: s_filename_base
      CHARACTER(LEN=12)   :: s_filename_full

      CHARACTER(LEN=3)    :: s_filestatus1
      LOGICAL             :: there
      CHARACTER(LEN=300)  :: s_pathandname

      REAL                :: f_clock_st_s
      REAL                :: f_clock_en_s
      REAL                :: f_deltime_clock_s
      REAL                :: f_deltime_cpu_s
      REAL                :: f_deltime_clock_min
      REAL                :: f_deltime_cpu_min

      CHARACTER(LEN=10)   :: s_deltime_clock_min
      CHARACTER(LEN=10)   :: s_deltime_cpu_min
c************************************************************************
c      print*,'just entered update_archive_file'
c*****
      f_clock_st_s=FLOAT(i_loop_values_st(3))*24.0*60.0*60.0+
     +  FLOAT(i_loop_values_st(5))*60.0*60.0+
     +  FLOAT(i_loop_values_st(6))*60.0+
     +  FLOAT(i_loop_values_st(7))
      f_clock_en_s=FLOAT(i_loop_values_en(3))*24.0*60.0*60.0+
     +  FLOAT(i_loop_values_en(5))*60.0*60.0+
     +  FLOAT(i_loop_values_en(6))*60.0+
     +  FLOAT(i_loop_values_en(7))

      f_deltime_clock_s=f_clock_en_s-f_clock_st_s
      f_deltime_cpu_s=f_loop_time_en-f_loop_time_st

      f_deltime_clock_min=f_deltime_clock_s/60.0
      f_deltime_cpu_min  =f_deltime_cpu_s/60.0
c*****
c     Convert to string
      WRITE(s_deltime_clock_min,'(f10.2)') f_deltime_clock_min
      WRITE(s_deltime_cpu_min,'(f10.2)')   f_deltime_cpu_min
c*****
      WRITE(s_index,'(i4)') i_index

c      print*,'i_index=',i_index
c      print*,'s_index=',TRIM(s_index)

c     Compose full name
      IF (i_index.GE.0.AND.i_index.LT.10) THEN
       s_filename_base='000'//ADJUSTL(s_index)
      ENDIF
      IF (i_index.GE.10.AND.i_index.LT.100) THEN
       s_filename_base='00'//ADJUSTL(s_index)
      ENDIF
      IF (i_index.GE.100.AND.i_index.LT.1000) THEN
       s_filename_base='0'//ADJUSTL(s_index)
      ENDIF
      IF (i_index.GE.1000.AND.i_index.LT.10000) THEN
       s_filename_base=ADJUSTL(s_index)
      ENDIF

      s_filename_full='f'//TRIM(s_filename_base)//'.dat'

c      print*,'s_filename_base=',TRIM(s_filename_base)
c      print*,'s_filename_full=',TRIM(s_filename_full)
c*****
      s_pathandname=TRIM(s_directory_3archive)//TRIM(s_filename_full)

      INQUIRE(FILE=TRIM(s_pathandname),
     +  EXIST=there)

      IF (there) THEN
       s_filestatus1='OLD'
      ENDIF
      IF (.NOT.(there)) THEN
       s_filestatus1='NEW'
      ENDIF

c      print*,'s_filestatus1=',s_filestatus1

c     Emergency stop if file is new
      IF (s_filestatus1.EQ.'NEW') THEN 
       STOP 'update_archive_file'
      ENDIF
c*****
c     Update file with end flag
      OPEN(UNIT=2,FILE=TRIM(s_pathandname),
     +  FORM='formatted',STATUS='OLD',ACTION='WRITE',ACCESS='append')
      WRITE(2,1000) 'en'
 1000 FORMAT(t1,a2)

      WRITE(2,1001) 'date/time st=',s_loop_date_st,s_loop_time_st
      WRITE(2,1001) 'date/time en=',s_loop_date_en,s_loop_time_en
 1001 FORMAT(t1,a13,t15,a8,t24,a10)

      WRITE(2,1002) 'dtime CPU=',s_deltime_cpu_min
      WRITE(2,1002) 'dtime clk=',s_deltime_clock_min
 1002 FORMAT(t1,a10,t12,a10)

      CLOSE(UNIT=2)
c*****
c      print*,'just leaving update_archive_file'

c      STOP 'update_archive_file'

      RETURN
      END
