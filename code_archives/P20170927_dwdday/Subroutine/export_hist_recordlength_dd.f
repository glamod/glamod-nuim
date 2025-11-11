c     Subroutine to export DWD monthly record length      
c     AJ_Kettle, Sept15/2017

      SUBROUTINE export_hist_recordlength_dd(s_date,
     +  s_directory_output,
     +  l_hist_dd,i_xhist_dd,i_yhist_dd,s_xhist_dd_label)

      IMPLICIT NONE
c************************************************************************
      CHARACTER(LEN=200)  :: s_directory_output
      CHARACTER(LEN=8)    :: s_date
      INTEGER             :: l_hist_dd
      INTEGER             :: i_xhist_dd(20),i_yhist_dd(20)
      CHARACTER(LEN=20)   :: s_xhist_dd_label(20)

      INTEGER             :: i,j,k
c************************************************************************
      OPEN(UNIT=1,
     +  FILE=TRIM(s_directory_output)//'histogram_lprod_dd.dat',
     +  FORM='formatted',
     +  STATUS='NEW',ACTION='WRITE')

c     GNUPLOT can not handle header
      GOTO 10

      WRITE(UNIT=1,FMT=3009) 'DWD - Histogram Record Length '
      WRITE(UNIT=1,FMT=3009) '                              '
3009  FORMAT(a30) 

      WRITE(unit=1,FMT=3025) 'AJ_Kettle ',s_date                          
3025  FORMAT(t1,a10,t12,a8) 
      WRITE(unit=1,FMT=3023) '                                        '
3023  FORMAT(t1,a40) 

      WRITE(UNIT=1,FMT=1001) 'HISTOGRAM BIN     ','Count'
      WRITE(UNIT=1,FMT=1001) '+----------------+','+---+'
1001  FORMAT(t1,a18,t20,a5)

10    CONTINUE

      DO i=1,l_hist_dd-1 
       WRITE(UNIT=1,FMT=1002) s_xhist_dd_label(i),i_yhist_dd(i)
1002   FORMAT(t1,a18,t20,i5) 
      ENDDO

      CLOSE(UNIT=1)

      RETURN
      END
