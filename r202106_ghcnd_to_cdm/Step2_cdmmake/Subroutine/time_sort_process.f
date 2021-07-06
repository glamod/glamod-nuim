c     Subroutine to sort sequence here
c     AJ_Kettle, 11May2021

      SUBROUTINE time_sort_process(l_lines_rgh,l_lines,
     +  s_archpre_id,s_archpre_date_yyyymmdd,
     +  s_archpre_element,s_archpre_datavalue,
     +  s_archpre_mflag,s_archpre_qflag,s_archpre_sflag,
     +  s_archpre_obstime,

     +  s_arch_id,s_arch_date_yyyymmdd,
     +  s_arch_element,s_arch_datavalue,
     +  s_arch_mflag,s_arch_qflag,s_arch_sflag,
     +  s_arch_obstime)

      IMPLICIT NONE
c************************************************************************
c     Declare variables 
      INTEGER             :: l_lines_rgh
      INTEGER             :: l_lines

      CHARACTER(LEN=12)   :: s_archpre_id(l_lines_rgh)
      CHARACTER(LEN=8)    :: s_archpre_date_yyyymmdd(l_lines_rgh)
      CHARACTER(LEN=4)    :: s_archpre_element(l_lines_rgh)
      CHARACTER(LEN=5)    :: s_archpre_datavalue(l_lines_rgh)
      CHARACTER(LEN=1)    :: s_archpre_mflag(l_lines_rgh)
      CHARACTER(LEN=1)    :: s_archpre_qflag(l_lines_rgh)
      CHARACTER(LEN=1)    :: s_archpre_sflag(l_lines_rgh)
      CHARACTER(LEN=4)    :: s_archpre_obstime(l_lines_rgh)

      CHARACTER(LEN=12)   :: s_arch_id(l_lines_rgh)
      CHARACTER(LEN=8)    :: s_arch_date_yyyymmdd(l_lines_rgh)
      CHARACTER(LEN=4)    :: s_arch_element(l_lines_rgh)
      CHARACTER(LEN=5)    :: s_arch_datavalue(l_lines_rgh)
      CHARACTER(LEN=1)    :: s_arch_mflag(l_lines_rgh)
      CHARACTER(LEN=1)    :: s_arch_qflag(l_lines_rgh)
      CHARACTER(LEN=1)    :: s_arch_sflag(l_lines_rgh)
      CHARACTER(LEN=4)    :: s_arch_obstime(l_lines_rgh)
c*****
c     Declare variables used in subroutine

      INTEGER             :: i,j,k,ii,jj,kk
c*****
      CHARACTER(LEN=10)   :: s_single

      CHARACTER(LEN=10)   :: s_date_new 
      CHARACTER(LEN=8)    :: s_time_new

      DOUBLE PRECISION    :: d_obs_jtime

      DOUBLE PRECISION    :: d_archpre_jtime(l_lines_rgh)
      INTEGER             :: i_sort(l_lines_rgh)

      DOUBLE PRECISION    :: d_arch_jtime(l_lines_rgh)

      INTEGER             :: i_use
c************************************************************************

      DO i=1,l_lines
       s_single  =s_archpre_date_yyyymmdd(i)
       s_date_new=s_single(7:8)//'/'//s_single(5:6)//'/'//s_single(1:4)
       s_time_new='00:00:00'

       CALL str_to_dt_pvwave3(d_obs_jtime,
     +  s_date_new,s_time_new,2,-1)

       d_archpre_jtime(i)=d_obs_jtime
      ENDDO
c*****
c     Find index of time sorted lines
      CALL sort_doublelist_pvwave2(l_lines,d_archpre_jtime,i_sort)

c      print*,'i_sort=',(i_sort(i),i=1,10)
c      print*,'d_archpre_jtime=',(d_archpre_jtime(i),i=1,10)
c*****
c     Create sorted vectors

      DO i=1,l_lines
       i_use=i_sort(i)

       d_arch_jtime(i)        =d_archpre_jtime(i_use)

       s_arch_id(i)           =s_archpre_id(i_use)
       s_arch_date_yyyymmdd(i)=s_archpre_date_yyyymmdd(i_use)
       s_arch_element(i)      =s_archpre_element(i_use) 
       s_arch_datavalue(i)    =s_archpre_datavalue(i_use)
       s_arch_mflag(i)        =s_archpre_mflag(i_use)
       s_arch_qflag(i)        =s_archpre_qflag(i_use)
       s_arch_sflag(i)        =s_archpre_sflag(i_use)
       s_arch_obstime(i)      =s_archpre_obstime(i_use)

c       print*,'s_arch_date_yyyymmdd=',i,d_arch_jtime(i),
c     +  s_archpre_date_yyyymmdd(i),
c     +  s_arch_date_yyyymmdd(i)

c       CALL SLEEP(1)
      ENDDO
c*****
c      STOP 'time_sort_process'

      RETURN
      END
