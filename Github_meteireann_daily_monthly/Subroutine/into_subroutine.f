c     Subroutine to run nested subroutine
c     AJ_Kettle, Jan9/2018

      SUBROUTINE into_subroutine(f_ndflag,
     +   l_mlent,l_mlent_mon,l_datalines,
     +   s_vec_date,
     +   f_vec_maxdy_c)

      IMPLICIT NONE
c************************************************************************
c     input variables
      REAL                :: f_ndflag
      INTEGER             :: l_mlent  
      INTEGER             :: l_mlent_mon
      INTEGER             :: l_datalines
      CHARACTER(LEN=10)   :: s_vec_date(l_mlent)
c      REAL                :: f_vec_rain_mm(l_mlent)        
      REAL                :: f_vec_maxdy_c(l_mlent)         
c      REAL                :: f_vec_mindy_c(l_mlent)         
c      REAL                :: f_vec_maxdy_k(l_mlent)         
c      REAL                :: f_vec_mindy_k(l_mlent)  

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
c************************************************************************
      print*,'just inside into_subroutine'

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

c************************************************************************
      RETURN
      END