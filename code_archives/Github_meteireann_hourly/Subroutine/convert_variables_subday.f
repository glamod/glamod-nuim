c     Subroutine to convert variables
c     AJ_Kettle, Dec25/2017

      SUBROUTINE convert_variables_subday(f_ndflag,
     +    l_mlent,l_datalines,
     +    f_vec_airt_c,f_vec_wspd_kt,
     +    f_vec_airt_k,f_vec_wspd_ms)

      IMPLICIT NONE
c************************************************************************
c     Declare variables

      INTEGER             :: i,j,k,ii,jj,kk
      REAL                :: f_ndflag
      INTEGER             :: l_mlent
      INTEGER             :: l_datalines

      REAL                :: f_vec_airt_c(l_mlent)
      REAL                :: f_vec_wspd_kt(l_mlent)
      REAL                :: f_vec_airt_k(l_mlent)
      REAL                :: f_vec_wspd_ms(l_mlent)
c************************************************************************
      DO i=1,l_datalines
       f_vec_airt_k(i) =f_ndflag
       f_vec_wspd_ms(i)=f_ndflag

       IF (f_vec_airt_c(i).NE.f_ndflag) THEN
        f_vec_airt_k(i)=273.15+f_vec_airt_c(i)
       ENDIF

       IF (f_vec_wspd_kt(i).NE.f_ndflag) THEN
        f_vec_wspd_ms(i)=0.514444*f_vec_wspd_kt(i)
       ENDIF
      ENDDO
c************************************************************************
      RETURN
      END