c     Subroutine to test precision variables
c     AJ_Kettle, 12Dec2018

c     Subroutine called
c      -precision_single_vector1a
c      -precision_single_vector2a
c        -find_hist_dailyprecision2
c      -precision_interpreter_tenths
c      -precision_interpreter_whole

      SUBROUTINE test_precision_variables2(l_timestamp_rgh,l_timestamp,
     +  s_prcp_datavalue,s_tmin_datavalue,s_tmax_datavalue,
     +  s_tavg_datavalue,s_snwd_datavalue,s_snow_datavalue,
     +  s_awnd_datavalue,s_awdr_datavalue,s_wesd_datavalue,

     +  s_prec_empir_prcp_mm,s_prec_empir_tmin_c,s_prec_empir_tmax_c,
     +  s_prec_empir_tavg_c,s_prec_empir_snwd_mm,s_prec_empir_snow_mm,
     +  s_prec_empir_awnd_ms,s_prec_empir_awdr_deg,s_prec_empir_wesd_mm)

      IMPLICIT NONE
c************************************************************************
c     Declare variables passed into program

      INTEGER             :: l_timestamp_rgh
      INTEGER             :: l_timestamp

      CHARACTER(LEN=5)    :: s_prcp_datavalue(l_timestamp_rgh)
      CHARACTER(LEN=5)    :: s_tmin_datavalue(l_timestamp_rgh)
      CHARACTER(LEN=5)    :: s_tmax_datavalue(l_timestamp_rgh)
      CHARACTER(LEN=5)    :: s_tavg_datavalue(l_timestamp_rgh)
      CHARACTER(LEN=5)    :: s_snwd_datavalue(l_timestamp_rgh)
      CHARACTER(LEN=5)    :: s_snow_datavalue(l_timestamp_rgh)
      CHARACTER(LEN=5)    :: s_awnd_datavalue(l_timestamp_rgh)
      CHARACTER(LEN=5)    :: s_awdr_datavalue(l_timestamp_rgh)
      CHARACTER(LEN=5)    :: s_wesd_datavalue(l_timestamp_rgh)

      CHARACTER(LEN=10)   :: s_prec_empir_prcp_mm
      CHARACTER(LEN=10)   :: s_prec_empir_tmin_c
      CHARACTER(LEN=10)   :: s_prec_empir_tmax_c
      CHARACTER(LEN=10)   :: s_prec_empir_tavg_c
      CHARACTER(LEN=10)   :: s_prec_empir_snwd_mm
      CHARACTER(LEN=10)   :: s_prec_empir_snow_mm
      CHARACTER(LEN=10)   :: s_prec_empir_awnd_ms
      CHARACTER(LEN=10)   :: s_prec_empir_awdr_deg
      CHARACTER(LEN=10)   :: s_prec_empir_wesd_mm
c*****
c     Variables used in subroutine      
      INTEGER             :: i,j,k,ii,jj,kk

      INTEGER             :: i_prec_empir_prcp   !tenths
      INTEGER             :: i_prec_empir_tmin   !tenths
      INTEGER             :: i_prec_empir_tmax   !tenths
      INTEGER             :: i_prec_empir_tavg   !tenths
      INTEGER             :: i_prec_empir_snwd   
      INTEGER             :: i_prec_empir_snow
      INTEGER             :: i_prec_empir_awnd   !tenths
      INTEGER             :: i_prec_empir_awdr
      INTEGER             :: i_prec_empir_wesd   !tenths

      INTEGER             :: i_prec_empir_prcp2   !tenths
      INTEGER             :: i_prec_empir_tmin2   !tenths
      INTEGER             :: i_prec_empir_tmax2   !tenths
      INTEGER             :: i_prec_empir_tavg2   !tenths
      INTEGER             :: i_prec_empir_snwd2   
      INTEGER             :: i_prec_empir_snow2
      INTEGER             :: i_prec_empir_awnd2   !tenths
      INTEGER             :: i_prec_empir_awdr2
      INTEGER             :: i_prec_empir_wesd2   !tenths
c************************************************************************
c      print*,'just entered test_precision_variables'

c     Initialize precision tester
      i_prec_empir_prcp=-999   !tenths
      i_prec_empir_tmin=-999   !tenths
      i_prec_empir_tmax=-999   !tenths
      i_prec_empir_tavg=-999   !tenths
      i_prec_empir_snwd=-999   !        (snow depth)
      i_prec_empir_snow=-999   !        (snowfall)
      i_prec_empir_awnd=-999   !tenths
      i_prec_empir_awdr=-999
      i_prec_empir_wesd=-999   !tenths (water equivalent of snow on the ground)

      i_prec_empir_prcp2=-999   !tenths
      i_prec_empir_tmin2=-999   !tenths
      i_prec_empir_tmax2=-999   !tenths
      i_prec_empir_tavg2=-999   !tenths
      i_prec_empir_snwd2=-999   !        (snow depth)
      i_prec_empir_snow2=-999   !        (snowfall)
      i_prec_empir_awnd2=-999   !tenths
      i_prec_empir_awdr2=-999
      i_prec_empir_wesd2=-999   !tenths (water equivalent of snow on the ground)

      s_prec_empir_prcp_mm =''
      s_prec_empir_tmin_c  =''
      s_prec_empir_tmax_c  =''
      s_prec_empir_tavg_c  =''
      s_prec_empir_snwd_mm =''
      s_prec_empir_snow_mm =''
      s_prec_empir_awnd_ms =''
      s_prec_empir_awdr_deg=''
      s_prec_empir_wesd_mm =''
c*****
c     1.PRCP
      CALL precision_single_vector1a(l_timestamp_rgh,l_timestamp,
     +  s_prcp_datavalue,
     +  i_prec_empir_prcp)
      CALL precision_single_vector2a(l_timestamp_rgh,l_timestamp,
     +  s_prcp_datavalue,
     +  i_prec_empir_prcp2)

      CALL precision_interpreter_tenths2(i_prec_empir_prcp2,
     +  s_prec_empir_prcp_mm)

c      print*,'s_prec_empir_prcp_mm=',s_prec_empir_prcp_mm
c      STOP 'test_precision_variables'
c*****
c     2.TMIN
      CALL precision_single_vector1a(l_timestamp_rgh,l_timestamp,
     +  s_tmin_datavalue,
     +  i_prec_empir_tmin)
      CALL precision_single_vector2a(l_timestamp_rgh,l_timestamp,
     +  s_tmin_datavalue,
     +  i_prec_empir_tmin2)

      CALL precision_interpreter_tenths2(i_prec_empir_tmin2,
     +  s_prec_empir_tmin_c)
*****
c     3.TMAX
      CALL precision_single_vector1a(l_timestamp_rgh,l_timestamp,
     +  s_tmax_datavalue,
     +  i_prec_empir_tmax)
      CALL precision_single_vector2a(l_timestamp_rgh,l_timestamp,
     +  s_tmax_datavalue,
     +  i_prec_empir_tmax2)

      CALL precision_interpreter_tenths2(i_prec_empir_tmax2,
     +  s_prec_empir_tmax_c)
c*****
c     4.TAVG
      CALL precision_single_vector1a(l_timestamp_rgh,l_timestamp,
     +  s_tavg_datavalue,
     +  i_prec_empir_tavg)
      CALL precision_single_vector2a(l_timestamp_rgh,l_timestamp,
     +  s_tavg_datavalue,
     +  i_prec_empir_tavg2)

      CALL precision_interpreter_tenths2(i_prec_empir_tavg2,
     +  s_prec_empir_tavg_c)
c*****
c     5.SNWD
      CALL precision_single_vector1a(l_timestamp_rgh,l_timestamp,
     +  s_snwd_datavalue,
     +  i_prec_empir_snwd)
      CALL precision_single_vector2a(l_timestamp_rgh,l_timestamp,
     +  s_snwd_datavalue,
     +  i_prec_empir_snwd2)

      CALL precision_interpreter_whole2(i_prec_empir_snwd2,
     +  s_prec_empir_snwd_mm)
c*****
c     6.SNOW
      CALL precision_single_vector1a(l_timestamp_rgh,l_timestamp,
     +  s_snow_datavalue,
     +  i_prec_empir_snow)
      CALL precision_single_vector2a(l_timestamp_rgh,l_timestamp,
     +  s_snow_datavalue,
     +  i_prec_empir_snow2)

      CALL precision_interpreter_whole2(i_prec_empir_snow2,
     +  s_prec_empir_snow_mm)
c*****
c     7.AWND
      CALL precision_single_vector1a(l_timestamp_rgh,l_timestamp,
     +  s_awnd_datavalue,
     +  i_prec_empir_awnd)
      CALL precision_single_vector2a(l_timestamp_rgh,l_timestamp,
     +  s_awnd_datavalue,
     +  i_prec_empir_awnd2)

      CALL precision_interpreter_tenths2(i_prec_empir_awnd2,
     +  s_prec_empir_awnd_ms)
c*****
c     8.AWDR
      CALL precision_single_vector1a(l_timestamp_rgh,l_timestamp,
     +  s_awdr_datavalue,
     +  i_prec_empir_awdr)
      CALL precision_single_vector2a(l_timestamp_rgh,l_timestamp,
     +  s_awdr_datavalue,
     +  i_prec_empir_awdr2)

      CALL precision_interpreter_whole2(i_prec_empir_awdr2,
     +  s_prec_empir_awdr_deg)
c*****
c     9.WESD
      CALL precision_single_vector1a(l_timestamp_rgh,l_timestamp,
     +  s_wesd_datavalue,
     +  i_prec_empir_wesd)
      CALL precision_single_vector2a(l_timestamp_rgh,l_timestamp,
     +  s_wesd_datavalue,
     +  i_prec_empir_wesd2)

      CALL precision_interpreter_tenths2(i_prec_empir_wesd2,
     +  s_prec_empir_wesd_mm)
c*****
      GOTO 10

      print*,'data values'
      print*,'prcp=',(s_prcp_datavalue(i),i=1,20)
      print*,'tmin=',(s_tmin_datavalue(i),i=1,20)
      print*,'tmax=',(s_tmax_datavalue(i),i=1,20)
      print*,'tavg=',(s_tavg_datavalue(i),i=1,20)
      print*,'snwd=',(s_snwd_datavalue(i),i=1,20)
      print*,'snow=',(s_snow_datavalue(i),i=1,20)
      print*,'awnd=',(s_awnd_datavalue(i),i=1,20)
      print*,'awdr=',(s_awdr_datavalue(i),i=1,20)
      print*,'wesd=',(s_wesd_datavalue(i),i=1,20)

      print*,'i_prec_empir index1'
      print*,'prcp=',i_prec_empir_prcp,s_prec_empir_prcp_mm
      print*,'tmin=',i_prec_empir_tmin,s_prec_empir_tmin_c
      print*,'tmax=',i_prec_empir_tmax,s_prec_empir_tmax_c
      print*,'tavg=',i_prec_empir_tavg,s_prec_empir_tavg_c
      print*,'snwd=',i_prec_empir_snwd,s_prec_empir_snwd_mm
      print*,'snow=',i_prec_empir_snow,s_prec_empir_snow_mm
      print*,'awnd=',i_prec_empir_awnd,s_prec_empir_awnd_ms
      print*,'awdr=',i_prec_empir_awdr,s_prec_empir_awdr_deg
      print*,'wesd=',i_prec_empir_wesd,s_prec_empir_wesd_mm

      print*,'i_prec_empir index1/2'
      print*,'prcp=',i_prec_empir_prcp,i_prec_empir_prcp2
      print*,'tmin=',i_prec_empir_tmin,i_prec_empir_tmin2
      print*,'tmax=',i_prec_empir_tmax,i_prec_empir_tmax2
      print*,'tavg=',i_prec_empir_tavg,i_prec_empir_tavg2
      print*,'snwd=',i_prec_empir_snwd,i_prec_empir_snwd2
      print*,'snow=',i_prec_empir_snow,i_prec_empir_snow2
      print*,'awnd=',i_prec_empir_awnd,i_prec_empir_awnd2
      print*,'awdr=',i_prec_empir_awdr,i_prec_empir_awdr2
      print*,'wesd=',i_prec_empir_wesd,i_prec_empir_wesd2

      print*,'interpreted precision'
      print*,'prcp=',s_prec_empir_prcp_mm
      print*,'tmin=',s_prec_empir_tmin_c
      print*,'tmax=',s_prec_empir_tmax_c
      print*,'tavg=',s_prec_empir_tavg_c
      print*,'snwd=',s_prec_empir_snwd_mm
      print*,'snow=',s_prec_empir_snow_mm
      print*,'awnd=',s_prec_empir_awnd_ms
      print*,'awdr=',s_prec_empir_awdr_deg
      print*,'wesd=',s_prec_empir_wesd_mm

      print*,'just leaving test_precision_variables'

 10   CONTINUE

c      print*,'call sleep(1)'
c      CALL SLEEP(1)

c      STOP 'test_precision_variables'

      RETURN
      END
