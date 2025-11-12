c     Subroutine to find monthly avg temperature
c     AJ_Kettle, Jan9/2018

      SUBROUTINE find_month_airt2(l_mlent_mon,f_ndflag,
     +   l_mon_maxdy_c,l_mon_mindy_c,l_mon_maxdy_k,l_mon_mindy_k,
     +   f_monrec_avg_maxdy_c,f_monrec_avg_mindy_c,
     +   f_monrec_avg_maxdy_k,f_monrec_avg_mindy_k,
     +   f_monrec_airt_c,f_monrec_airt_k)

      IMPLICIT NONE
c************************************************************************
      REAL                :: f_ndflag
      INTEGER             :: l_mlent_mon

      INTEGER             :: l_mon_maxdy_c
      INTEGER             :: l_mon_mindy_c
      INTEGER             :: l_mon_maxdy_k
      INTEGER             :: l_mon_mindy_k

      REAL                :: f_monrec_avg_maxdy_c(l_mlent_mon)
      REAL                :: f_monrec_avg_mindy_c(l_mlent_mon)
      REAL                :: f_monrec_avg_maxdy_k(l_mlent_mon)
      REAL                :: f_monrec_avg_mindy_k(l_mlent_mon)

      REAL                :: f_monrec_airt_c(l_mlent_mon)
      REAL                :: f_monrec_airt_k(l_mlent_mon)

      INTEGER             :: i,j,k,ii,jj,kk
      INTEGER             :: ii1,ii2,ii3,ii4
c************************************************************************
c      print*,'just inside find_month_airt2'
c      print*,'f_ndflag=',f_ndflag
c      print*,'l_mlent_mon=',l_mlent_mon
c      print*,'.',l_mon_maxdy_c,l_mon_mindy_c,l_mon_maxdy_k,l_mon_mindy_k

c     Check number of good in each vector
      ii1=0
      ii2=0
      ii3=0
      ii4=0
      DO i=1,l_mon_maxdy_c
       IF (f_monrec_avg_maxdy_c(i).NE.f_ndflag) THEN 
        ii1=ii1+1
       ENDIF
       IF (f_monrec_avg_maxdy_k(i).NE.f_ndflag) THEN 
        ii2=ii2+1
       ENDIF

       IF (f_monrec_avg_mindy_c(i).NE.f_ndflag) THEN 
        ii3=ii3+1
       ENDIF
       IF (f_monrec_avg_mindy_k(i).NE.f_ndflag) THEN 
        ii4=ii4+1
       ENDIF
      ENDDO      

c      print*,'ii1...',ii1,ii2,ii3,ii4

      IF (ii1.NE.ii2) THEN 
       print*,'emergency stop, find_month_airt2, mismatch ii1,ii2'
      ENDIF
      IF (ii3.NE.ii4) THEN 
       print*,'emergency stop, find_month_airt2, mismatch ii3,ii4'
      ENDIF
c************************************************************************
c     Calculate avg temperature

      DO i=1,l_mon_maxdy_c
       f_monrec_airt_c(i)=f_ndflag
       IF (f_monrec_avg_maxdy_c(i).NE.f_ndflag.AND. 
     +     f_monrec_avg_mindy_c(i).NE.f_ndflag) THEN 
        f_monrec_airt_c(i)= 
     +     0.5*(f_monrec_avg_maxdy_c(i)+f_monrec_avg_mindy_c(i))
       ENDIF    
      ENDDO

      DO i=1,l_mon_maxdy_k
       f_monrec_airt_k(i)=f_ndflag
       IF (f_monrec_avg_maxdy_k(i).NE.f_ndflag.AND. 
     +     f_monrec_avg_mindy_k(i).NE.f_ndflag) THEN 
        f_monrec_airt_k(i)= 
     +     0.5*(f_monrec_avg_maxdy_k(i)+f_monrec_avg_mindy_k(i))
       ENDIF

c       print*,'f_monrec_airt_k...',i,    
      ENDDO
c************************************************************************
c      print*,'just leaving find_month_airt2'

      RETURN
      END