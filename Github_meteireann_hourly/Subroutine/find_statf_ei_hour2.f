c     Subroutine to find integer stats
c     AJ_Kettle, Nov16/2017

      SUBROUTINE find_statf_ei_hour2(l_mlent,l_datalines,f_vec_data,
     +  f_ndflag, 
     +  f_stat_data_ngd,f_stat_data_nbd,
     +  f_stat_data_avg,
     +  f_stat_data_min,f_stat_data_max)

      IMPLICIT NONE
c************************************************************************
c     Declare variables

      INTEGER             :: l_datalines
      INTEGER             :: l_mlent
      REAL                :: f_vec_data(l_mlent)

      INTEGER             :: i,j,k,ii,jj,kk

      REAL                :: f_stat_data_ngd
      REAL                :: f_stat_data_nbd
      REAL                :: f_stat_data_avg
      REAL                :: f_stat_data_min
      REAL                :: f_stat_data_max

      REAL                :: f_accum1
      REAL                :: f_accum2

      REAL                :: f_ndflag
c************************************************************************
      ii=0
      jj=0
      f_accum1=0.0
      f_accum2=0.0
      f_stat_data_min=10000
      f_stat_data_max=-10000

      DO i=1,l_datalines
       IF (f_vec_data(i).NE.f_ndflag) THEN 
        ii=ii+1
        f_accum1=f_accum1+f_vec_data(i)
        f_accum2=f_accum2+1.0
        f_stat_data_min=MIN(f_stat_data_min,f_vec_data(i))
        f_stat_data_max=MAX(f_stat_data_max,f_vec_data(i))
       ENDIF
       IF (f_vec_data(i).LT.0.0) THEN 
        jj=jj+1
       ENDIF
      ENDDO

      f_stat_data_avg=f_accum1/f_accum2
      f_stat_data_ngd=FLOAT(ii)
      f_stat_data_nbd=FLOAT(jj)
c************************************************************************
      RETURN
      END