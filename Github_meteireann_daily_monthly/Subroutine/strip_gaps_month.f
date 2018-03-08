c     Subroutine to strip gaps in month vector
c     AJ_Kettle, Jan10/2018

      SUBROUTINE strip_gaps_month(l_mlent_mon,f_ndflag,
     +   l_mon_maxdy_c,l_mon_mindy_c,l_mon_maxdy_k,l_mon_mindy_k,
     +   l_mon_rain_mm,
     +   s_monrec_rain_mm_year,s_monrec_rain_mm_month,
     +   f_monrec_rain_mm_nseconds,
     +   s_monrec_rain_mm_stime,s_monrec_rain_mm_timezone5,
     +   f_monrec_max_maxdy_c,f_monrec_min_mindy_c,
     +   f_monrec_max_maxdy_k,f_monrec_min_mindy_k,
     +   f_monrec_tot_rain_mm,
     +   f_monrec_airt_c,f_monrec_airt_k,

     +   l_moncom,
     +   s_moncom_month,s_moncom_year,f_moncom_nseconds,
     +   s_moncom_stime,s_moncom_timezone5,
     +   f_moncom_max_maxdy_c,f_moncom_min_mindy_c,
     +   f_moncom_max_maxdy_k,f_moncom_min_mindy_k,
     +   f_moncom_tot_rain_mm,f_moncom_airt_c,f_moncom_airt_k)

      IMPLICIT NONE
c************************************************************************
      REAL                :: f_ndflag
      INTEGER             :: l_mlent_mon

      INTEGER             :: l_mon_maxdy_c
      INTEGER             :: l_mon_mindy_c
      INTEGER             :: l_mon_maxdy_k
      INTEGER             :: l_mon_mindy_k
      INTEGER             :: l_mon_rain_mm

      CHARACTER(LEN=2)    :: s_monrec_rain_mm_month(l_mlent_mon)
      CHARACTER(LEN=4)    :: s_monrec_rain_mm_year(l_mlent_mon)
      REAL                :: f_monrec_rain_mm_nseconds(l_mlent_mon)
      CHARACTER(LEN=8)    :: s_monrec_rain_mm_stime(l_mlent_mon)
      CHARACTER(LEN=5)    :: s_monrec_rain_mm_timezone5(l_mlent_mon)

      REAL                :: f_monrec_max_maxdy_c(l_mlent_mon)
      REAL                :: f_monrec_min_mindy_c(l_mlent_mon)
      REAL                :: f_monrec_max_maxdy_k(l_mlent_mon)
      REAL                :: f_monrec_min_mindy_k(l_mlent_mon)
      REAL                :: f_monrec_tot_rain_mm(l_mlent_mon)
      REAL                :: f_monrec_airt_c(l_mlent_mon)
      REAL                :: f_monrec_airt_k(l_mlent_mon)

c     Declare common vectors
      CHARACTER(LEN=2)    :: s_moncom_month(l_mlent_mon)
      CHARACTER(LEN=4)    :: s_moncom_year(l_mlent_mon)
      REAL                :: f_moncom_nseconds(l_mlent_mon)
      CHARACTER(LEN=8)    :: s_moncom_stime(l_mlent_mon)
      CHARACTER(LEN=5)    :: s_moncom_timezone5(l_mlent_mon)

      REAL                :: f_moncom_max_maxdy_c(l_mlent_mon)
      REAL                :: f_moncom_min_mindy_c(l_mlent_mon)
      REAL                :: f_moncom_max_maxdy_k(l_mlent_mon)
      REAL                :: f_moncom_min_mindy_k(l_mlent_mon)
      REAL                :: f_moncom_tot_rain_mm(l_mlent_mon)
      REAL                :: f_moncom_airt_c(l_mlent_mon)
      REAL                :: f_moncom_airt_k(l_mlent_mon)

      INTEGER             :: l_moncom

      INTEGER             :: i,j,k,ii,jj,kk
c************************************************************************
c      print*,'just entered strip_gaps_month'

c      print*,l_mon_maxdy_c,l_mon_mindy_c,l_mon_maxdy_k,l_mon_mindy_k,
c     +   l_mon_rain_mm

      ii=1
      jj=1

      DO i=1,l_mon_maxdy_c      
c       print*,'i...',i,f_monrec_max_maxdy_c(i),f_monrec_min_mindy_c(i),
c     +   f_monrec_max_maxdy_k(i),f_monrec_min_mindy_k(i),
c     +   f_monrec_tot_rain_mm(i),
c     +   f_monrec_airt_c(i),f_monrec_airt_k(i) 
c       CALL SLEEP(1)

       IF (f_monrec_max_maxdy_c(i).NE.f_ndflag.OR.
     +     f_monrec_min_mindy_c(i).NE.f_ndflag.OR.
     +     f_monrec_max_maxdy_k(i).NE.f_ndflag.OR.
     +     f_monrec_min_mindy_k(i).NE.f_ndflag.OR.
     +     f_monrec_tot_rain_mm(i).NE.f_ndflag.OR.
     +     f_monrec_airt_c(i)     .NE.f_ndflag.OR.
     +     f_monrec_airt_k(i)     .NE.f_ndflag) THEN 

        s_moncom_month(ii)      =s_monrec_rain_mm_month(i)
        s_moncom_year(ii)       =s_monrec_rain_mm_year(i)
        f_moncom_nseconds(ii)   =f_monrec_rain_mm_nseconds(i)
        s_moncom_stime(ii)      =s_monrec_rain_mm_stime(i)
        s_moncom_timezone5(ii)  =s_monrec_rain_mm_timezone5(i)

        f_moncom_max_maxdy_c(ii)=f_monrec_max_maxdy_c(i)
        f_moncom_min_mindy_c(ii)=f_monrec_min_mindy_c(i)
        f_moncom_max_maxdy_k(ii)=f_monrec_max_maxdy_k(i)
        f_moncom_min_mindy_k(ii)=f_monrec_min_mindy_k(i)
        f_moncom_tot_rain_mm(ii)=f_monrec_tot_rain_mm(i)
        f_moncom_airt_c(ii)     =f_monrec_airt_c(i)
        f_moncom_airt_k(ii)     =f_monrec_airt_k(i)

        ii=ii+1
       ENDIF
       IF (.NOT.(f_monrec_max_maxdy_c(i).NE.f_ndflag.OR.
     +           f_monrec_min_mindy_c(i).NE.f_ndflag.OR.
     +           f_monrec_max_maxdy_k(i).NE.f_ndflag.OR.
     +           f_monrec_min_mindy_k(i).NE.f_ndflag.OR.
     +           f_monrec_tot_rain_mm(i).NE.f_ndflag.OR.
     +           f_monrec_airt_c(i)     .NE.f_ndflag.OR.
     +           f_monrec_airt_k(i)     .NE.f_ndflag)) THEN 
        jj=jj+1
       ENDIF

      ENDDO 

      l_moncom=ii-1

      print*,'ii,jj',ii,jj
      print*,'l_moncom=',l_moncom

c      DO i=1,l_moncom
c       print*,i,
c     +   f_moncom_max_maxdy_c(i),f_moncom_min_mindy_c(i),
c     +   f_moncom_airt_c(i),
c     +   f_moncom_max_maxdy_k(i),f_moncom_min_mindy_k(i),
c     +   f_moncom_airt_k(i),
c     +   f_moncom_tot_rain_mm(i)
c      ENDDO

c      call sleep(10)
c************************************************************************
c      print*,'just leaving strip_gaps_month'

      RETURN
      END