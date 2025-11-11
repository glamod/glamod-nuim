c     Subroutine to produce monthly values for 4 parameters
c     AJ_Kettle, Jan9/2018

      SUBROUTINE month_package2(f_ndflag,
     +   l_mlent,l_mlent_mon,l_datalines,
     +   s_vec_date,
     +   f_vec_maxdy_c,f_vec_mindy_c,f_vec_maxdy_k,f_vec_mindy_k,
     +   f_vec_rain_mm)

      IMPLICIT NONE
c************************************************************************
c     input variables
      REAL                :: f_ndflag
      INTEGER             :: l_mlent  
      INTEGER             :: l_mlent_mon
      INTEGER             :: l_datalines
      CHARACTER(LEN=10)   :: s_vec_date(l_mlent)
      REAL                :: f_vec_rain_mm(l_mlent)        
      REAL                :: f_vec_maxdy_c(l_mlent)         
      REAL                :: f_vec_mindy_c(l_mlent)         
      REAL                :: f_vec_maxdy_k(l_mlent)         
      REAL                :: f_vec_mindy_k(l_mlent)         

c     output variables
      INTEGER             :: l_mon_maxdy_c
      CHARACTER(LEN=2)    :: s_monrec_maxdy_c_year(l_mlent_mon)
      CHARACTER(LEN=4)    :: s_monrec_maxdy_c_month(l_mlent_mon)
      REAL                :: f_monrec_maxdy_c_nseconds(l_mlent_mon)
      CHARACTER(LEN=8)    :: s_monrec_maxdy_c_stime(l_mlent_mon)
      CHARACTER(LEN=5)    :: s_monrec_maxdy_c_timezone5(l_mlent_mon)
      REAL                :: f_monrec_avg_maxdy_c(l_mlent_mon)
      REAL                :: f_monrec_tot_maxdy_c(l_mlent_mon)  
      REAL                :: f_monrec_max_maxdy_c(l_mlent_mon)
      REAL                :: f_monrec_min_maxdy_c(l_mlent_mon)
      INTEGER             :: i_monrec_maxdy_c_flag(l_mlent_mon)

      INTEGER             :: l_mon_mindy_c
      CHARACTER(LEN=2)    :: s_monrec_mindy_c_year(l_mlent_mon)
      CHARACTER(LEN=4)    :: s_monrec_mindy_c_month(l_mlent_mon)
      REAL                :: f_monrec_mindy_c_nseconds(l_mlent_mon)
      CHARACTER(LEN=8)    :: s_monrec_mindy_c_stime(l_mlent_mon)
      CHARACTER(LEN=5)    :: s_monrec_mindy_c_timezone5(l_mlent_mon)
      REAL                :: f_monrec_avg_mindy_c(l_mlent_mon)
      REAL                :: f_monrec_tot_mindy_c(l_mlent_mon)  
      REAL                :: f_monrec_max_mindy_c(l_mlent_mon)
      REAL                :: f_monrec_min_mindy_c(l_mlent_mon)
      INTEGER             :: i_monrec_mindy_c_flag(l_mlent_mon)

      INTEGER             :: l_mon_maxdy_k
      CHARACTER(LEN=2)    :: s_monrec_maxdy_k_year(l_mlent_mon)
      CHARACTER(LEN=4)    :: s_monrec_maxdy_k_month(l_mlent_mon)
      REAL                :: f_monrec_maxdy_k_nseconds(l_mlent_mon)
      CHARACTER(LEN=8)    :: s_monrec_maxdy_k_stime(l_mlent_mon)
      CHARACTER(LEN=5)    :: s_monrec_maxdy_k_timezone5(l_mlent_mon)
      REAL                :: f_monrec_avg_maxdy_k(l_mlent_mon)
      REAL                :: f_monrec_tot_maxdy_k(l_mlent_mon)  
      REAL                :: f_monrec_max_maxdy_k(l_mlent_mon)
      REAL                :: f_monrec_min_maxdy_k(l_mlent_mon)
      INTEGER             :: i_monrec_maxdy_k_flag(l_mlent_mon)

      INTEGER             :: l_mon_mindy_k
      CHARACTER(LEN=2)    :: s_monrec_mindy_k_year(l_mlent_mon)
      CHARACTER(LEN=4)    :: s_monrec_mindy_k_month(l_mlent_mon)
      REAL                :: f_monrec_mindy_k_nseconds(l_mlent_mon)
      CHARACTER(LEN=8)    :: s_monrec_mindy_k_stime(l_mlent_mon)
      CHARACTER(LEN=5)    :: s_monrec_mindy_k_timezone5(l_mlent_mon)
      REAL                :: f_monrec_avg_mindy_k(l_mlent_mon)
      REAL                :: f_monrec_tot_mindy_k(l_mlent_mon)  
      REAL                :: f_monrec_max_mindy_k(l_mlent_mon)
      REAL                :: f_monrec_min_mindy_k(l_mlent_mon)
      INTEGER             :: i_monrec_mindy_k_flag(l_mlent_mon)

      INTEGER             :: l_mon_rain_mm
      CHARACTER(LEN=2)    :: s_monrec_rain_mm_month(l_mlent_mon)
      CHARACTER(LEN=4)    :: s_monrec_rain_mm_year(l_mlent_mon)
      REAL                :: f_monrec_rain_mm_nseconds(l_mlent_mon)
      CHARACTER(LEN=8)    :: s_monrec_rain_mm_stime(l_mlent_mon)
      CHARACTER(LEN=5)    :: s_monrec_rain_mm_timezone5(l_mlent_mon)
      REAL                :: f_monrec_avg_rain_mm(l_mlent_mon)
      REAL                :: f_monrec_tot_rain_mm(l_mlent_mon)
      REAL                :: f_monrec_max_rain_mm(l_mlent_mon)
      REAL                :: f_monrec_min_rain_mm(l_mlent_mon)
      INTEGER             :: i_monrec_rain_mm_flag(l_mlent_mon)

c     internal variables
      INTEGER             :: i,j,k,ii,jj,kk
      INTEGER             :: ii1,ii1b,ii2,ii2b

c      INTEGER             :: l_mon_airt_c
c      CHARACTER(LEN=2)    :: s_monrec_airt_c_year(l_mlent_mon)
c      CHARACTER(LEN=4)    :: s_monrec_airt_c_month(l_mlent_mon)
c      REAL                :: f_monrec_airt_c_nseconds(l_mlent_mon)
c      CHARACTER(LEN=8)    :: s_monrec_airt_c_stime(l_mlent_mon)
c      CHARACTER(LEN=5)    :: s_monrec_airt_c_timezone5(l_mlent_mon)
c      REAL                :: f_monrec_avg_airt_c(l_mlent_mon)
c      INTEGER             :: i_monrec_airt_c_flag(l_mlent_mon)

c      INTEGER             :: l_mon_airt_k
c      CHARACTER(LEN=2)    :: s_monrec_airt_k_year(l_mlent_mon)
c      CHARACTER(LEN=4)    :: s_monrec_airt_k_month(l_mlent_mon)
c      REAL                :: f_monrec_airt_k_nseconds(l_mlent_mon)
c      CHARACTER(LEN=8)    :: s_monrec_airt_k_stime(l_mlent_mon)
c      CHARACTER(LEN=5)    :: s_monrec_airt_k_timezone5(l_mlent_mon)
c      REAL                :: f_monrec_avg_airt_k(l_mlent_mon)
c      INTEGER             :: i_monrec_airt_k_flag(l_mlent_mon)
c************************************************************************
      print*,'just inside month_package.f'

c      airt_c_max
       CALL calc_mon_total2_ei(f_ndflag,
     +   l_mlent,l_mlent_mon,l_datalines,
     +   s_vec_date,f_vec_maxdy_c,
     +   l_mon_maxdy_c,
     +   s_monrec_maxdy_c_year,s_monrec_maxdy_c_month,
     +   f_monrec_maxdy_c_nseconds,
     +   s_monrec_maxdy_c_stime,s_monrec_maxdy_c_timezone5,
     +   f_monrec_avg_maxdy_c,f_monrec_tot_maxdy_c,  
     +   f_monrec_max_maxdy_c,f_monrec_min_maxdy_c,
     +   i_monrec_maxdy_c_flag)

c      airt_c_min
       CALL calc_mon_total2_ei(f_ndflag,
     +   l_mlent,l_mlent_mon,l_datalines,
     +   s_vec_date,f_vec_mindy_c,
     +   l_mon_mindy_c,
     +   s_monrec_mindy_c_year,s_monrec_mindy_c_month,
     +   f_monrec_mindy_c_nseconds,
     +   s_monrec_mindy_c_stime,s_monrec_mindy_c_timezone5,
     +   f_monrec_avg_mindy_c,f_monrec_tot_mindy_c,  
     +   f_monrec_max_mindy_c,f_monrec_min_mindy_c,
     +   i_monrec_mindy_c_flag)

c      airt_k_max
       CALL calc_mon_total2_ei(f_ndflag,
     +   l_mlent,l_mlent_mon,l_datalines,
     +   s_vec_date,f_vec_maxdy_k,
     +   l_mon_maxdy_k,
     +   s_monrec_maxdy_k_year,s_monrec_maxdy_k_month,
     +   f_monrec_maxdy_k_nseconds,
     +   s_monrec_maxdy_k_stime,s_monrec_maxdy_k_timezone5,
     +   f_monrec_avg_maxdy_k,f_monrec_tot_maxdy_k,  
     +   f_monrec_max_maxdy_k,f_monrec_min_maxdy_k,
     +   i_monrec_maxdy_k_flag)

c      airt_k_min
       CALL calc_mon_total2_ei(f_ndflag,
     +   l_mlent,l_mlent_mon,l_datalines,
     +   s_vec_date,f_vec_mindy_k,
     +   l_mon_mindy_k,
     +   s_monrec_mindy_k_year,s_monrec_mindy_k_month,
     +   f_monrec_mindy_k_nseconds,
     +   s_monrec_mindy_k_stime,s_monrec_mindy_k_timezone5,
     +   f_monrec_avg_mindy_k,f_monrec_tot_mindy_k,  
     +   f_monrec_max_mindy_k,f_monrec_min_mindy_k,
     +   i_monrec_mindy_k_flag)

c      Rain_mm
       CALL calc_mon_total2_ei(f_ndflag,
     +   l_mlent,l_mlent_mon,l_datalines,
     +   s_vec_date,f_vec_rain_mm,
     +   l_mon_rain_mm,
     +   s_monrec_rain_mm_year,s_monrec_rain_mm_month,
     +   f_monrec_rain_mm_nseconds,
     +   s_monrec_rain_mm_stime,s_monrec_rain_mm_timezone5,
     +   f_monrec_avg_rain_mm,f_monrec_tot_rain_mm,  
     +   f_monrec_max_rain_mm,f_monrec_min_rain_mm,
     +   i_monrec_rain_mm_flag)
c************************************************************************

c************************************************************************
      print*,'just leaving month_package'

      RETURN
      END