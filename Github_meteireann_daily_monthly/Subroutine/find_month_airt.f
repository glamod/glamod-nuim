c     Subroutine to find monthly avg temperature
c     AJ_Kettle, Jan9/2018

      SUBROUTINE find_month_airt(l_mlent_mon,
     +   l_mon_maxdy_c,
     +   s_monrec_maxdy_c_year,s_monrec_maxdy_c_month,
     +   f_monrec_maxdy_c_nseconds,
     +   s_monrec_maxdy_c_stime,s_monrec_maxdy_c_timezone5,
     +   f_monrec_avg_maxdy_c,
     +   i_monrec_maxdy_c_flag,
     +   l_mon_mindy_c,
     +   s_monrec_mindy_c_year,s_monrec_mindy_c_month,
     +   f_monrec_mindy_c_nseconds,
     +   s_monrec_mindy_c_stime,s_monrec_mindy_c_timezone5,
     +   f_monrec_avg_mindy_c,
     +   i_monrec_mindy_c_flag, 

     +   l_mon_airt_c,
     +   s_monrec_airt_c_year,s_monrec_airt_c_month,
     +   f_monrec_airt_c_nseconds,
     +   s_monrec_airt_c_stime,s_monrec_mindy_c_timezone5,
     +   f_monrec_avg_airt_c,
     +   i_monrec_airt_c_flag)

      IMPLICIT NONE
c************************************************************************
      INTEGER             :: l_mlent_mon

      INTEGER             :: l_mon_maxdy_c
      CHARACTER(LEN=2)    :: s_monrec_maxdy_c_year(l_mlent_mon)
      CHARACTER(LEN=4)    :: s_monrec_maxdy_c_month(l_mlent_mon)
      REAL                :: f_monrec_maxdy_c_nseconds(l_mlent_mon)
      CHARACTER(LEN=8)    :: s_monrec_maxdy_c_stime(l_mlent_mon)
      CHARACTER(LEN=5)    :: s_monrec_maxdy_c_timezone5(l_mlent_mon)
      REAL                :: f_monrec_avg_maxdy_c(l_mlent_mon)
      INTEGER             :: i_monrec_maxdy_c_flag(l_mlent_mon)

      INTEGER             :: l_mon_mindy_c
      CHARACTER(LEN=2)    :: s_monrec_mindy_c_year(l_mlent_mon)
      CHARACTER(LEN=4)    :: s_monrec_mindy_c_month(l_mlent_mon)
      REAL                :: f_monrec_mindy_c_nseconds(l_mlent_mon)
      CHARACTER(LEN=8)    :: s_monrec_mindy_c_stime(l_mlent_mon)
      CHARACTER(LEN=5)    :: s_monrec_mindy_c_timezone5(l_mlent_mon)
      REAL                :: f_monrec_avg_mindy_c(l_mlent_mon)
      INTEGER             :: i_monrec_mindy_c_flag(l_mlent_mon)

      INTEGER             :: l_mon_airt_c
      CHARACTER(LEN=2)    :: s_monrec_airt_c_year(l_mlent_mon)
      CHARACTER(LEN=4)    :: s_monrec_airt_c_month(l_mlent_mon)
      REAL                :: f_monrec_airt_c_nseconds(l_mlent_mon)
      CHARACTER(LEN=8)    :: s_monrec_airt_c_stime(l_mlent_mon)
      CHARACTER(LEN=5)    :: s_monrec_airt_c_timezone5(l_mlent_mon)
      REAL                :: f_monrec_avg_airt_c(l_mlent_mon)
      INTEGER             :: i_monrec_airt_c_flag(l_mlent_mon)
c************************************************************************
      print*,'just inside find_month_airt'
      print*,'l_mon_maxdy_c...',l_mon_maxdy_c,l_mon_mindy_c



c************************************************************************
      print*,'just leaving find_month_airt'

      RETURN
      END