c     Subroutine to identify complete months in record
c     AJ_Kettle, Nov09/2017

      SUBROUTINE calc_mon_total2_ei(l_mlent,l_mlent_mon,l_datalines,
     +   s_vec_date,f_vec_rain_mm,
     +   l_mon,
     +   s_monrec_year,s_monrec_month,
     +   f_monrec_common_nseconds,
     +   s_monrec_common_stime,s_monrec_common_timezone5,
     +   f_monrec_value,f_monrec_total,
     +   f_monrec_max,f_monrec_min, 
     +   i_monrec_flag)

      IMPLICIT NONE
c************************************************************************
      INTEGER             :: l_mlent
      INTEGER             :: l_mlent_mon
      INTEGER             :: l_datalines
      CHARACTER(LEN=10)   :: s_vec_date(l_mlent)
      CHARACTER(LEN=8)    :: s_vec_time(l_mlent)
      REAL                :: f_vec_rain_mm(l_mlent) 

      INTEGER             :: l_mon
      CHARACTER(LEN=2)    :: s_monrec_month(l_mlent_mon)
      CHARACTER(LEN=4)    :: s_monrec_year(l_mlent_mon)
      REAL                :: f_monrec_common_nseconds(l_mlent_mon)
      CHARACTER(LEN=8)    :: s_monrec_common_stime(l_mlent_mon)
      CHARACTER(LEN=5)    :: s_monrec_common_timezone5(l_mlent_mon)

      REAL                :: f_monrec_value(l_mlent_mon)
      REAL                :: f_monrec_total(l_mlent_mon)
      REAL                :: f_monrec_max(l_mlent_mon)
      REAL                :: f_monrec_min(l_mlent_mon)
      INTEGER             :: i_monrec_flag(l_mlent_mon)

      INTEGER             :: n_monthdays_expect(12)
      INTEGER             :: n_monthdays_expect2(12)

      INTEGER             :: ii1,ii2,ii3
      INTEGER             :: i_refyear
      INTEGER             :: i_vec_year(300)
      REAL                :: f_vec_year(300)
      REAL                :: f_result
      INTEGER             :: i_matrix_monthdays(300,12)
      REAL                :: f_matrix_nseconds(300,12)

      CHARACTER(LEN=4)    :: s_day_year(l_mlent)
      CHARACTER(LEN=2)    :: s_day_month(l_mlent)
      CHARACTER(LEN=2)    :: s_day_day(l_mlent)
      REAL                :: f_day_year(l_mlent)
      REAL                :: f_day_month(l_mlent)
      REAL                :: f_day_day(l_mlent)
      INTEGER             :: i_day_year(l_mlent)
      INTEGER             :: i_day_month(l_mlent)
      INTEGER             :: i_day_day(l_mlent)

      CHARACTER(LEN=10)    :: s_date_single

      CHARACTER(LEN=2)    :: s_test2 
      CHARACTER(LEN=4)    :: s_test4 
      REAL                :: f_test
      INTEGER             :: i_test

      CHARACTER(LEN=2)    :: s_name_month(12)
      CHARACTER(LEN=4)    :: s_name_year(300)

      INTEGER             :: i,j,k,ii,jj,kk

      REAL                :: f_matrix_integrator(300,12)
      REAL                :: f_matrix_max(300,12)
      REAL                :: f_matrix_min(300,12)

      REAL                :: f_matrix_truedaycnt(300,12)
      REAL                :: f_matrix_average(300,12)
      INTEGER             :: i_matrix_truedaycnt(300,12)
      INTEGER             :: i_matrix_monthflag(300,12)

      INTEGER             :: i_loc_year
      INTEGER             :: i_loc_month

      INTEGER             :: l_cnt_month
      INTEGER             :: l_cnt_month_bad
      INTEGER             :: l_cnt_month_good

      INTEGER             :: i_vec_day(31)
      INTEGER             :: i_vec_delday(31)
      INTEGER             :: i_delday_max

c************************************************************************
      print*,'just inside calc_mon_total2_ei'
c      print*,'l_mlent',l_mlent
c      print*,'s_vec_date first=',(s_vec_date(i),i=1,10)
c      print*,'s_vec_date last=', 
c     +  (s_vec_date(i),i=l_datalines-10,l_datalines)

c      print*,'dayavg_values=',(f_dayavg_airt_c(i),i=1,10)
c      CALL SLEEP(10)

c     Declare expected number of days in each month

      n_monthdays_expect(1)=31
      n_monthdays_expect(2)=28
      n_monthdays_expect(3)=31
      n_monthdays_expect(4)=30
      n_monthdays_expect(5)=31
      n_monthdays_expect(6)=30
      n_monthdays_expect(7)=31
      n_monthdays_expect(8)=31
      n_monthdays_expect(9)=30
      n_monthdays_expect(10)=31
      n_monthdays_expect(11)=30
      n_monthdays_expect(12)=31

      n_monthdays_expect2(1)=31
      n_monthdays_expect2(2)=29
      n_monthdays_expect2(3)=31
      n_monthdays_expect2(4)=30
      n_monthdays_expect2(5)=31
      n_monthdays_expect2(6)=30
      n_monthdays_expect2(7)=31
      n_monthdays_expect2(8)=31
      n_monthdays_expect2(9)=30
      n_monthdays_expect2(10)=31
      n_monthdays_expect2(11)=30
      n_monthdays_expect2(12)=31

      ii1=0
      ii2=0
      ii3=0

      i_refyear=300

      DO i=1,i_refyear
       i_vec_year(i)=1750+(i-1)
       f_vec_year(i)=1750.0+(i-1.0)

       f_result=MODULO(f_vec_year(i),4.0)
c       print*,'f_result=',f_result

c      Ordinary years 
       IF (f_result.NE.0.0) THEN 
        DO j=1,12
         i_matrix_monthdays(i,j)=n_monthdays_expect(j)
        ENDDO
        ii1=ii1+1
       ENDIF

c      Leap year condition
       IF (f_result.EQ.0.0) THEN 
        DO j=1,12
         i_matrix_monthdays(i,j)=n_monthdays_expect2(j)
        ENDDO
        ii2=ii2+1
       ENDIF

c      Hard wire century years
       IF (i_vec_year(i).EQ.1800.OR.i_vec_year(i).EQ.1900) THEN
        DO j=1,12
         i_matrix_monthdays(i,j)=n_monthdays_expect(j)
        ENDDO
        ii3=ii3+1
       ENDIF
      ENDDO

c      print*,'i_vec_year=',(i_vec_year(i),i=1,5)
c      print*,'f_vec_year=',(f_vec_year(i),i=1,5)
c      print*,'ii1,ii2,ii3=',ii1,ii2,ii3
c************************************************************************
c     Find theoretical seconds
      DO j=1,300
       DO k=1,12 
        f_matrix_nseconds(j,k)=FLOAT(i_matrix_monthdays(j,k))*24*60*60.0
       ENDDO
      ENDDO
c************************************************************************
c     Create string of month/year string
      DO i=1,i_refyear
        i_test=i_vec_year(i) 
        WRITE(s_test4,'(i4)') i_test
        s_name_year(i)=TRIM(s_test4)   
      ENDDO

      DO j=1,12 
       IF (j.LT.10) THEN
        i_test=j
        WRITE(s_test2,'(i2)') i_test
        s_name_month(j)='0'//TRIM(ADJUSTL(s_test2))
       ENDIF
       IF (j.GE.10) THEN
        i_test=j
        WRITE(s_test2,'(i2)') i_test
        s_name_month(j)=TRIM(s_test2)
       ENDIF
      ENDDO

c      print*,'s_name_year=',(s_name_year(i),i=1,10)
c      print*,'s_name_month=',(s_name_month(i),i=1,12)
c      CALL SLEEP(5)
c************************************************************************
c     Extract component fields of date
      DO i=1,l_datalines      !cycle through length of file
       s_date_single=s_vec_date(i)

       s_day_year(i) =s_date_single(1:4)
       s_day_month(i)=s_date_single(6:7)
       s_day_day(i)  =s_date_single(9:10)
c******
c      Convert string to float 
       s_test4=s_day_year(i)
       READ(s_test4,*) f_test
       f_day_year(i)=f_test

       s_test2=s_day_month(i)
       READ(s_test2,*) f_test
       f_day_month(i)=f_test

       s_test2=s_day_day(i)
       READ(s_test2,*) f_test
       f_day_day(i)=f_test
c******
c      Convert string to integer 
       s_test4=s_day_year(i)
       READ(s_test4,*) i_test
       i_day_year(i)=i_test

       s_test2=s_day_month(i)
       READ(s_test2,*) i_test
       i_day_month(i)=i_test

       s_test2=s_day_day(i)
       READ(s_test2,*) i_test
       i_day_day(i)=i_test

c       print*,'ssss',s_day_year(i),s_day_month(i),s_day_day(i)
c       call sleep(1)
c******
      ENDDO

c      print*,'f_day_year=',(f_day_year(i),i=1,10)
c************************************************************************
c     Count days on standard matrix

c     Initial i_matrix_truedaycnt
      DO j=1,300
       DO k=1,12 
        f_matrix_integrator(j,k)=0.0
        f_matrix_max(j,k)       =0.0
        f_matrix_min(j,k)       =0.0

        f_matrix_truedaycnt(j,k)=0.0
        i_matrix_truedaycnt(j,k)=0
       ENDDO
      ENDDO

c     Increment counter
c      print*,'l_datalines=',l_datalines
c      print*,'i_day_year=',i_day_year(1),i_day_year(l_datalines)
c      print*,'i_day_month=',i_day_month(1),i_day_month(l_datalines)

      DO i=1,l_datalines       !cycle through length of file
       i_loc_year =i_day_year(i)-1750+1
       i_loc_month=i_day_month(i)

c      Increment counter only in good data situation
       IF (f_vec_rain_mm(i).NE.-999.0) THEN 

        f_matrix_integrator(i_loc_year,i_loc_month)=
     +    f_matrix_integrator(i_loc_year,i_loc_month)+
     +    f_vec_rain_mm(i)
        f_matrix_truedaycnt(i_loc_year,i_loc_month)=
     +    f_matrix_truedaycnt(i_loc_year,i_loc_month)+1.0
        i_matrix_truedaycnt(i_loc_year,i_loc_month)= 
     +    i_matrix_truedaycnt(i_loc_year,i_loc_month)+1

c       Test to see if month counter exceeded
        IF (i_matrix_truedaycnt(i_loc_year,i_loc_month).GT.31) THEN 
         print*,'emergency stop at point a',i_loc_year,i_loc_month
        ENDIF
        IF (i_matrix_truedaycnt(i_loc_year,i_loc_month).GT.
     +      i_matrix_monthdays(i_loc_year,i_loc_month)) THEN 
         print*,'emergency stop at point b, month days exceeded',i,
     +    i_day_year(i),i_day_month(i),
     +    i_matrix_truedaycnt(i_loc_year,i_loc_month)
         print*,'i_loc_year,i_loc_month=',i_loc_year,i_loc_month
         CALL SLEEP(5)
        ENDIF

       ENDIF                           !data test condition
      ENDDO                            !close l_datalines counter
c************************************************************************
c     Count number of months with deficient days
      l_cnt_month     =0
      l_cnt_month_bad =0
      l_cnt_month_good=0
      DO j=1,300
       DO k=1,12 
c       Initialize to -9 for no data
        i_matrix_monthflag(j,k)=-9
c       Initialize month average to -999.0
        f_matrix_average(j,k)=-999.0

c       Verify that month counter not over 31
        IF (i_matrix_truedaycnt(j,k).GT.31) THEN
         print*,'emergency stop, month days exceeded',j,k,
     +     i_matrix_truedaycnt(j,k)
c         CALL SLEEP(5)
        ENDIF

c       Check if number of days complete
        IF (i_matrix_truedaycnt(j,k).GT.0) THEN
         l_cnt_month=l_cnt_month+1

         IF (i_matrix_truedaycnt(j,k).EQ.i_matrix_monthdays(j,k)) THEN
          i_matrix_monthflag(j,k)=0

c         Calculate average
          IF (f_matrix_truedaycnt(j,k).GT.0.0) THEN
           f_matrix_average(j,k)=
     +       f_matrix_integrator(j,k)/f_matrix_truedaycnt(j,k)
          ENDIF
          IF (f_matrix_truedaycnt(j,k).EQ.0.0) THEN
           f_matrix_average(j,k)=-999.0
          ENDIF

          l_cnt_month_good=l_cnt_month_good+1
         ENDIF 
         IF (i_matrix_truedaycnt(j,k).LT.i_matrix_monthdays(j,k)) THEN
          l_cnt_month_bad =l_cnt_month_bad+1

c         Check if number of missing days > 5  : set FLAG=3 & exit condition
          IF (i_matrix_monthdays(j,k)-i_matrix_truedaycnt(j,k)
     +        .GT.5) THEN
           i_matrix_monthflag(j,k)=3
           GOTO 17
          ENDIF
c*****
c         Cycle through l_prod to extract these month-days
          ii=1
          DO i=1,l_datalines
           i_loc_year =i_day_year(i)-1750+1
           i_loc_month=i_day_month(i)
           IF (j.EQ.i_loc_year.AND.k.EQ.i_loc_month) THEN
            i_vec_day(ii)=i_day_day(i)
            ii=ii+1
           ENDIF
          ENDDO

c         Find consecutive separations in day vector
          i_delday_max=0.0     !Initialize separation finder
          DO i=1,ii-1
           i_vec_delday(i)=i_vec_day(i+1)-i_vec_day(i)
           i_delday_max=MAX(i_delday_max,i_vec_delday(i))
          ENDDO 

c         Set bad flag if more than 3 missing consecutive days: set FLAG=2
          IF (i_delday_max.GT.3) THEN 
           i_matrix_monthflag(j,k)=2
           GOTO 17
          ENDIF  
          IF (i_delday_max.LE.3) THEN 
           i_matrix_monthflag(j,k)=1

c         Calculate average if < 3 consecutive lost days
          IF (f_matrix_truedaycnt(j,k).GT.0.0) THEN
           f_matrix_average(j,k)=
     +       f_matrix_integrator(j,k)/f_matrix_truedaycnt(j,k)
          ENDIF
          IF (f_matrix_truedaycnt(j,k).EQ.0.0) THEN
           f_matrix_average(j,k)=-999.0
          ENDIF

           GOTO 17
          ENDIF  
c*****
         ENDIF                 !condition for month cnt less than total

17       CONTINUE

        ENDIF 
       ENDDO
      ENDDO

303   CONTINUE
c************************************************************************
c************************************************************************
c     Extract line of month data

      ii=1

      DO j=1,300
       DO k=1,12 
        IF (i_matrix_monthflag(j,k).EQ.0.OR.
     +      i_matrix_monthflag(j,k).EQ.1) THEN
         s_monrec_month(ii) =s_name_month(k)
         s_monrec_year(ii)  =s_name_year(j)

         f_monrec_common_nseconds(ii) =f_matrix_nseconds(j,k)
         s_monrec_common_stime(ii)    ='00:00:00'    !hardwire start time
         s_monrec_common_timezone5(ii)='+0000'       !haradwire time zone

         f_monrec_value(ii) =f_matrix_average(j,k)
         f_monrec_total(ii) =f_matrix_integrator(j,k)
         f_monrec_max(ii)   =f_matrix_max(j,k)
         f_monrec_min(ii)   =f_matrix_min(j,k)
         i_monrec_flag(ii)  =i_matrix_monthflag(j,k)
         ii=ii+1

         IF (ii.GT.5000) THEN 
          print*,'emergency stop, month ii over range'
          CALL SLEEP(200)
         ENDIF
        ENDIF
       ENDDO
      ENDDO

      l_mon=ii-1

      print*,'l_mon=',l_mon
c      IF (l_mon.GT.0) THEN 
c       print*,'s_monrec_month=',(s_monrec_month(i),i=1,10)
c       print*,'s_monrec_year=', (s_monrec_year(i),i=1,10)
c       print*,'f_monrec_value=',(f_monrec_value(i),i=1,10)
c       print*,'i_monrec_flag=', (i_monrec_flag(i),i=1,10)
c      ENDIF
c************************************************************************
c      print*,'just leaving calc_mon_value_ei'

      RETURN
      END