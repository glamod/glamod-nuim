c     Subroutine to place monthly values on common date stamp
c     AJ_Kettle, Nov30/2017
c     Dec5/2017: modified to include totals; total month ppt exported

      SUBROUTINE common_month_variables(f_ndflag,i_ndflag,l_prod,
     +  s_day_date,
     +  f_dayavg_airt_k,f_daytot_ppt_mm,
     +  f_dayavg_wspd_ms,f_dayavg_slpres_hpa,
     +  s_dayavg_airtk_stime,s_dayavg_airtk_timezone,
     +  s_daytot_ppt_stime,s_daytot_ppt_timezone,
     +  s_dayavg_wspd_stime,s_dayavg_wspd_timezone,
     +  s_dayavg_slpres_stime,s_dayavg_slpres_timezone,

     +  l_monrec_common,s_monrec_common_month,s_monrec_common_year,
     +  f_monrec_common_nseconds,
     +  s_monrec_common_stime,s_monrec_common_timezone5,
     +  f_monrec_airt_k,i_monrec_airt_flag,
     +  f_monrec_wspd_ms,i_monrec_wspd_flag,
     +  f_monrec_slpres_hpa,i_monrec_slpres_flag,
     +  f_monrec_ppt_mm,i_monrec_ppt_flag)

c     +  l_monrec_airt,
c     +  s_monrec_airt_month,s_monrec_airt_year,
c     +  f_monrec_airt_k,i_monrec_airt_flag,
c     +  l_monrec_wspd,
c     +  s_monrec_wspd_month,s_monrec_wspd_year,
c     +  f_monrec_wspd_ms,i_monrec_wspd_flag,
c     +  l_monrec_slpres,
c     +  s_monrec_slpres_month,s_monrec_slpres_year,
c     +  f_monrec_slpres_hpa,i_monrec_slpres_flag,
c     +  l_monrec_ppt,
c     +  s_monrec_ppt_month,s_monrec_ppt_year,
c     +  f_monrec_ppt_mm,i_monrec_ppt_flag)

      IMPLICIT NONE
c************************************************************************
      REAL                :: f_ndflag
      INTEGER             :: i_ndflag
      INTEGER             :: l_prod
      CHARACTER(LEN=8)    :: s_day_date(100000)
      REAL                :: f_dayavg_airt_k(100000)
      REAL                :: f_daytot_ppt_mm(100000)
      REAL                :: f_dayavg_wspd_ms(100000)
      REAL                :: f_dayavg_slpres_hpa(100000)

      CHARACTER(LEN=8)    :: s_dayavg_airtk_stime(100000)
      CHARACTER(LEN=5)    :: s_dayavg_airtk_timezone(100000)
      CHARACTER(LEN=8)    :: s_dayavg_wspd_stime(100000)
      CHARACTER(LEN=5)    :: s_dayavg_wspd_timezone(100000)
      CHARACTER(LEN=8)    :: s_dayavg_slpres_stime(100000)
      CHARACTER(LEN=5)    :: s_dayavg_slpres_timezone(100000)
      CHARACTER(LEN=8)    :: s_daytot_ppt_stime(100000)
      CHARACTER(LEN=5)    :: s_daytot_ppt_timezone(100000)
c****
      INTEGER             :: l_monrec_common
      CHARACTER(LEN=2)    :: s_monrec_common_month(5000)
      CHARACTER(LEN=4)    :: s_monrec_common_year(5000)
      REAL                :: f_monrec_common_nseconds(5000)
      CHARACTER(LEN=8)    :: s_monrec_common_stime(5000)
      CHARACTER(LEN=5)    :: s_monrec_common_timezone5(5000)

c      INTEGER             :: l_monrec_airt
c      CHARACTER(LEN=2)    :: s_monrec_airt_month(5000)
c      CHARACTER(LEN=4)    :: s_monrec_airt_year(5000)
      REAL                :: f_monrec_airt_k(5000)
      INTEGER             :: i_monrec_airt_flag(5000)

c      INTEGER             :: l_monrec_wspd
c      CHARACTER(LEN=2)    :: s_monrec_wspd_month(5000)
c      CHARACTER(LEN=4)    :: s_monrec_wspd_year(5000)
      REAL                :: f_monrec_wspd_ms(5000)
      INTEGER             :: i_monrec_wspd_flag(5000)

c      INTEGER             :: l_monrec_slpres
c      CHARACTER(LEN=2)    :: s_monrec_slpres_month(5000)
c      CHARACTER(LEN=4)    :: s_monrec_slpres_year(5000)
      REAL                :: f_monrec_slpres_hpa(5000)
      INTEGER             :: i_monrec_slpres_flag(5000)

c      INTEGER             :: l_monrec_ppt
c      CHARACTER(LEN=2)    :: s_monrec_ppt_month(5000)
c      CHARACTER(LEN=4)    :: s_monrec_ppt_year(5000)
      REAL                :: f_monrec_ppt_mm(5000)
      INTEGER             :: i_monrec_ppt_flag(5000)
c****
      INTEGER             :: l_monraw_airt
      CHARACTER(LEN=2)    :: s_monraw_airt_month(5000)
      CHARACTER(LEN=4)    :: s_monraw_airt_year(5000)
      REAL                :: f_monraw_airt_k(5000)
      INTEGER             :: i_monraw_airt_flag(5000)
      REAL                :: f_monraw_airt_nseconds(5000)
      CHARACTER(LEN=8)    :: s_monraw_airt_stime(5000)
      CHARACTER(LEN=5)    :: s_monraw_airt_timezone(5000)
      REAL                :: f_monraw_airt_tot_k(5000)

      INTEGER             :: l_monraw_wspd
      CHARACTER(LEN=2)    :: s_monraw_wspd_month(5000)
      CHARACTER(LEN=4)    :: s_monraw_wspd_year(5000)
      REAL                :: f_monraw_wspd_ms(5000)
      INTEGER             :: i_monraw_wspd_flag(5000)
      REAL                :: f_monraw_wspd_nseconds(5000)
      CHARACTER(LEN=8)    :: s_monraw_wspd_stime(5000)
      CHARACTER(LEN=5)    :: s_monraw_wspd_timezone(5000)
      REAL                :: f_monraw_wspd_tot_ms(5000)

      INTEGER             :: l_monraw_slpres
      CHARACTER(LEN=2)    :: s_monraw_slpres_month(5000)
      CHARACTER(LEN=4)    :: s_monraw_slpres_year(5000)
      REAL                :: f_monraw_slpres_hpa(5000)
      INTEGER             :: i_monraw_slpres_flag(5000)
      REAL                :: f_monraw_slpres_nseconds(5000)
      CHARACTER(LEN=8)    :: s_monraw_slpres_stime(5000)
      CHARACTER(LEN=5)    :: s_monraw_slpres_timezone(5000)
      REAL                :: f_monraw_slpres_tot_hpa(5000)

      INTEGER             :: l_monraw_ppt
      CHARACTER(LEN=2)    :: s_monraw_ppt_month(5000)
      CHARACTER(LEN=4)    :: s_monraw_ppt_year(5000)
      REAL                :: f_monraw_ppt_mm(5000)
      INTEGER             :: i_monraw_ppt_flag(5000)
      REAL                :: f_monraw_ppt_nseconds(5000)
      CHARACTER(LEN=8)    :: s_monraw_ppt_stime(5000)
      CHARACTER(LEN=5)    :: s_monraw_ppt_timezone(5000)
      REAL                :: f_monraw_ppt_tot_mm(5000)

      INTEGER             :: ist
      INTEGER             :: ien

      INTEGER             :: ist_vec(4)
      INTEGER             :: ien_vec(4)

      INTEGER             :: i_com_minst
      INTEGER             :: i_com_maxen

      INTEGER             :: i,j,k,ii,jj,kk
c************************************************************************
c      Calculate monthly values from daily values
c       CALL calc_monthly_values(l_prod,s_day_date,
c     +   f_dayavg_airt_c,f_daytot_ppt_mm,
c     +   f_dayavg_wspd_ms,f_dayavg_pres_mb)

       CALL calc_monthly_values2(f_ndflag,i_ndflag,
     +   l_prod,s_day_date,f_dayavg_airt_k,
     +   s_dayavg_airtk_stime,s_dayavg_airtk_timezone,
     +   l_monraw_airt,
     +   s_monraw_airt_year,s_monraw_airt_month,
     +   f_monraw_airt_k,i_monraw_airt_flag,
     +   f_monraw_airt_nseconds,
     +   s_monraw_airt_stime,s_monraw_airt_timezone,
     +   f_monraw_airt_tot_k)

       CALL calc_monthly_values2(f_ndflag,i_ndflag,
     +   l_prod,s_day_date,f_dayavg_wspd_ms,
     +   s_dayavg_wspd_stime,s_dayavg_wspd_timezone,
     +   l_monraw_wspd,
     +   s_monraw_wspd_year,s_monraw_wspd_month,
     +   f_monraw_wspd_ms,i_monraw_wspd_flag,
     +   f_monraw_wspd_nseconds,
     +   s_monraw_wspd_stime,s_monraw_wspd_timezone,
     +   f_monraw_wspd_tot_ms)

       CALL calc_monthly_values2(f_ndflag,i_ndflag,
     +   l_prod,s_day_date,f_dayavg_slpres_hpa,
     +   s_dayavg_slpres_stime,s_dayavg_slpres_timezone,
     +   l_monraw_slpres,
     +   s_monraw_slpres_year,s_monraw_slpres_month,
     +   f_monraw_slpres_hpa,i_monraw_slpres_flag,
     +   f_monraw_slpres_nseconds,
     +   s_monraw_slpres_stime,s_monraw_slpres_timezone,
     +   f_monraw_slpres_tot_hpa)

       CALL calc_monthly_values2(f_ndflag,i_ndflag,
     +   l_prod,s_day_date,f_daytot_ppt_mm,
     +   s_daytot_ppt_stime,s_daytot_ppt_timezone,
     +   l_monraw_ppt,
     +   s_monraw_ppt_year,s_monraw_ppt_month,
     +   f_monraw_ppt_mm,i_monraw_ppt_flag,
     +   f_monraw_ppt_nseconds,
     +   s_monraw_ppt_stime,s_monraw_ppt_timezone,
     +   f_monraw_ppt_tot_mm)

c      print*,'l_monraw..',l_monraw_airt,l_monraw_wspd,l_monraw_slpres,
c     +   l_monraw_ppt
c************************************************************************
c      Find earliest common ist; latest common ien (4 possible)

c      Initialize search vectors with ndflag
       DO i=1,4 
        ist_vec(i)=i_ndflag
        ien_vec(i)=i_ndflag
       ENDDO
c****
c      airt
       ii=1
       DO i=1,l_monraw_airt
        IF (f_monraw_airt_k(i).NE.f_ndflag) THEN 
         ist_vec(ii)=i
c         print*,'f_monraw_airt_k=',f_monraw_airt_k(i)
         GOTO 10
        ENDIF
       ENDDO
10     CONTINUE       
c****
c      wspd
       ii=2
       DO i=1,l_monraw_wspd
        IF (f_monraw_wspd_ms(i).NE.f_ndflag) THEN 
         ist_vec(ii)=i
c         print*,'f_monraw_wspd_ms=',f_monraw_wspd_ms(i)
         GOTO 12
        ENDIF
       ENDDO
12     CONTINUE       
c****
c      slpres
       ii=3
       DO i=1,l_monraw_slpres
        IF (f_monraw_slpres_hpa(i).NE.f_ndflag) THEN 
         ist_vec(ii)=i
c         print*,'f_monraw_slpres_hpa=',f_monraw_slpres_hpa(i)
         GOTO 14
        ENDIF
       ENDDO
14     CONTINUE       
c****
c      wspd
       ii=4
       DO i=1,l_monraw_ppt
        IF (f_monraw_ppt_mm(i).NE.f_ndflag) THEN 
         ist_vec(ii)=i
c         print*,'f_monraw_ppt_mm=',f_monraw_ppt_mm(i)
         GOTO 16
        ENDIF
       ENDDO
16     CONTINUE       
c************************************************************************
c      ENDPOINTS
c      airt
       ii=1
       DO i=l_monraw_airt,1,-1
        IF (f_monraw_airt_k(i).NE.f_ndflag) THEN 
         ien_vec(ii)=i
         GOTO 20
        ENDIF
       ENDDO
20     CONTINUE       
c****
c      wspd
       ii=2
       DO i=l_monraw_wspd,1,-1
        IF (f_monraw_wspd_ms(i).NE.f_ndflag) THEN 
         ien_vec(ii)=i
         GOTO 22
        ENDIF
       ENDDO
22     CONTINUE       
c****
c      slpres
       ii=3
       DO i=l_monraw_slpres,1,-1
        IF (f_monraw_slpres_hpa(i).NE.f_ndflag) THEN 
         ien_vec(ii)=i
         GOTO 24
        ENDIF
       ENDDO
24     CONTINUE       
c****
c      wspd
       ii=4
       DO i=l_monraw_ppt,1,-1
        IF (f_monraw_ppt_mm(i).NE.f_ndflag) THEN 
         ien_vec(ii)=i
         GOTO 26
        ENDIF
       ENDDO
26     CONTINUE       
c************************************************************************
c     Find common index for start & end month

c      print*,'ist_vec=',(ist_vec(i),i=1,4)
c      print*,'ien_vec=',(ien_vec(i),i=1,4)

c     Find common min_ist
      i_com_minst=10000
      DO i=1,4
       IF (ist_vec(i).NE.i_ndflag) THEN 
        i_com_minst=MIN(i_com_minst,ist_vec(i))
       ENDIF
      ENDDO

      i_com_maxen=0
      DO i=1,4
       IF (ien_vec(i).NE.i_ndflag) THEN 
        i_com_maxen=MAX(i_com_maxen,ien_vec(i))
       ENDIF
      ENDDO

c      print*,'i_com_minst,i_com_maxen=',i_com_minst,i_com_maxen
c************************************************************************
c     Extract clipped datasets

      ii=0
      jj=0

      DO i=i_com_minst,i_com_maxen
      jj=jj+1

      IF (LEN_TRIM(s_monraw_airt_stime(i)).GT.0) THEN
       ii=ii+1
c       l_monrec_common=l_monrec_common+1
       s_monrec_common_month(ii)    =s_monraw_airt_month(i)
       s_monrec_common_year(ii)     =s_monraw_airt_year(i)
       f_monrec_common_nseconds(ii) =f_monraw_airt_nseconds(i)
       s_monrec_common_stime(ii)    =s_monraw_airt_stime(i)
       s_monrec_common_timezone5(ii)=s_monraw_airt_timezone(i)

c       IF (LEN_TRIM(s_monraw_airt_stime(i)).EQ.0) THEN
c        print*,'i=',i,s_monraw_airt_stime(i),s_monraw_wspd_stime(i),
c     +    s_monraw_slpres_stime(i),s_monraw_ppt_stime(i)
c        call sleep(1)
c       ENDIF

       f_monrec_airt_k(ii)      =f_monraw_airt_k(i)
       i_monrec_airt_flag(ii)   =i_monraw_airt_flag(i)
       f_monrec_wspd_ms(ii)     =f_monraw_wspd_ms(i)
       i_monrec_wspd_flag(ii)   =i_monraw_wspd_flag(i)
       f_monrec_slpres_hpa(ii)  =f_monraw_slpres_hpa(i)
       i_monrec_slpres_flag(ii) =i_monraw_slpres_flag(i)
       f_monrec_ppt_mm(ii)      =f_monraw_ppt_tot_mm(i)
       i_monrec_ppt_flag(ii)    =i_monraw_ppt_flag(i)
      ENDIF
      ENDDO

      l_monrec_common=ii

c      print*,'l_monrec_common=',l_monrec_common
c      print*,'ii,jj=',ii,jj
c      CALL SLEEP(5)
c************************************************************************
c     Test time & timezone for gaps
c      DO i=1,l_monrec_common
c       IF (LEN_TRIM(s_monrec_common_stime(i)).EQ.0) THEN
c        print*,'emergency stop stime not filled',i,l_monrec_common
c        CALL SLEEP(1)
c       ENDIF
c      ENDDO
c************************************************************************
c      print*,'f_monrec_airt_k=',    (f_monrec_airt_k(i),i=1,10)
c      print*,'f_monrec_wspd_ms=',   (f_monrec_wspd_ms(i),i=1,10)
c      print*,'f_monrec_slpres_hpa=',(f_monrec_slpres_hpa(i),i=1,10)
c      print*,'f_monrec_ppt_mm=',    (f_monrec_ppt_mm(i),i=1,10)
c      print*,'n_seconds',(f_monrec_common_nseconds(i),i=1,10)
c      CALL SLEEP(5)

      RETURN
      END
