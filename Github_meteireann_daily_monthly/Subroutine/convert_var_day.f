c     Subroutine to convert variables
c     AJ_Kettle, Dec22/2017

      SUBROUTINE convert_var_day(l_datalines,l_mlent,f_ndflag,
     +   f_vec_maxdy_c,f_vec_mindy_c,
     +   f_vec_maxdy_k,f_vec_mindy_k)

      IMPLICIT NONE
c************************************************************************
c     Declare variables

      INTEGER             :: l_datalines
      INTEGER             :: l_mlent
      REAL                :: f_ndflag

      REAL                :: f_vec_maxdy_c(l_mlent)         
      REAL                :: f_vec_mindy_c(l_mlent)       
      REAL                :: f_vec_maxdy_k(l_mlent)         
      REAL                :: f_vec_mindy_k(l_mlent)    

      INTEGER             :: i,j,k    
c************************************************************************
      DO i=1,l_datalines
c      Initialize variables
       f_vec_maxdy_k(i)=f_ndflag    
       f_vec_mindy_k(i)=f_ndflag

       IF (f_vec_maxdy_c(i).NE.f_ndflag) THEN
        f_vec_maxdy_k(i)=f_vec_maxdy_c(i)+273.15
       ENDIF
       IF (f_vec_mindy_c(i).NE.f_ndflag) THEN
        f_vec_mindy_k(i)=f_vec_mindy_c(i)+273.15
       ENDIF   
      ENDDO
c************************************************************************
      RETURN
      END