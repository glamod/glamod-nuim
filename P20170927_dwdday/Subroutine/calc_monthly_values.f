c     Subroutine to identify complete months in record
c     AJ_Kettle, Nov09/2017

      SUBROUTINE calc_monthly_values(f_ndflag,i_ndflag,
     +   l_prod,s_day_date,f_dayavg_airt_c,
     +   l_mon,
     +   s_monrec_year,s_monrec_month,
     +   f_monrec_value,i_monrec_flag)

      IMPLICIT NONE
c************************************************************************
      REAL                :: f_ndflag
      INTEGER             :: i_ndflag

      INTEGER             :: l_prod
      CHARACTER(LEN=8)    :: s_day_date(100000)
      REAL                :: f_dayavg_airt_c(100000)
      REAL                :: f_daytot_ppt_mm(100000)
      REAL                :: f_dayavg_wspd_ms(100000)
      REAL                :: f_dayavg_pres_mb(100000)

      INTEGER             :: i,j,k,ii,jj,kk

      INTEGER             :: n_monthdays_expect(12)
      INTEGER             :: n_monthdays_expect2(12)
      INTEGER             :: i_vec_year(300)
      REAL                :: f_vec_year(300)
      REAL                :: f_result
      INTEGER             :: i_refyear
      INTEGER             :: i_matrix_monthdays(300,12)
      INTEGER             :: i_matrix_truedaycnt(300,12)
      INTEGER             :: i_matrix_monthflag(300,12)
      INTEGER             :: i_loc_year
      INTEGER             :: i_loc_month
      INTEGER             :: ii1,ii2,ii3

      INTEGER             :: l_cnt_month
      INTEGER             :: l_cnt_month_bad
      INTEGER             :: l_cnt_month_good

      REAL                :: f_matrix_integrator(300,12)
      REAL                :: f_matrix_truedaycnt(300,12)
      REAL                :: f_matrix_average(300,12)

      CHARACTER(LEN=4)    :: s_day_year(100000)
      CHARACTER(LEN=2)    :: s_day_month(100000)
      CHARACTER(LEN=2)    :: s_day_day(100000)
      REAL                :: f_day_year(100000)
      REAL                :: f_day_month(100000)
      REAL                :: f_day_day(100000)
      INTEGER             :: i_day_year(100000)
      INTEGER             :: i_day_month(100000)
      INTEGER             :: i_day_day(100000)

      CHARACTER(LEN=8)    :: s_date_single

      CHARACTER(LEN=2)    :: s_test2 
      CHARACTER(LEN=4)    :: s_test4 
      REAL                :: f_test
      INTEGER             :: i_test

      CHARACTER(LEN=2)    :: s_name_month(12)
      CHARACTER(LEN=4)    :: s_name_year(300)

      INTEGER             :: i_pendflag(100000)

      INTEGER             :: i_vec_day(31)
      INTEGER             :: i_vec_delday(31)
      INTEGER             :: i_delday_max

      INTEGER             :: l_mon
      CHARACTER(LEN=2)    :: s_monrec_month(5000)
      CHARACTER(LEN=4)    :: s_monrec_year(5000)
      REAL                :: f_monrec_value(5000)
      INTEGER             :: i_monrec_flag(5000)

      INTEGER             :: ist,ien
c************************************************************************
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

      DO i=1,l_prod      !cycle through length of file
       s_date_single=s_day_date(i)

       s_day_year(i) =s_date_single(1:4)
       s_day_month(i)=s_date_single(5:6)
       s_day_day(i)  =s_date_single(7:8)
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
c******
      ENDDO

c      print*,'f_day_year=',(f_day_year(i),i=1,10)
c************************************************************************
c     Count days on standard matrix

c     Initial i_matrix_truedaycnt
      DO j=1,300
       DO k=1,12 
        f_matrix_integrator(j,k)=0.0
        f_matrix_truedaycnt(j,k)=0.0
        i_matrix_truedaycnt(j,k)=0
       ENDDO
      ENDDO

c     Increment counter
      DO i=1,l_prod      !cycle through length of file
       i_loc_year =i_day_year(i)-1750+1
       i_loc_month=i_day_month(i)

c      Increment counter only in good data situation
       IF (f_dayavg_airt_c(i).NE.-999.0) THEN 

        f_matrix_integrator(i_loc_year,i_loc_month)=
     +    f_matrix_integrator(i_loc_year,i_loc_month)+
     +    f_dayavg_airt_c(i)
        f_matrix_truedaycnt(i_loc_year,i_loc_month)=
     +    f_matrix_truedaycnt(i_loc_year,i_loc_month)+1.0
        i_matrix_truedaycnt(i_loc_year,i_loc_month)= 
     +    i_matrix_truedaycnt(i_loc_year,i_loc_month)+1

c       Test to see if month counter exceeded
        IF (i_matrix_truedaycnt(i_loc_year,i_loc_month).GT.31) THEN 
         print*,'emergency stop at point, month days exceeded',
     +    i_day_year(i),i_day_month(i),
     +    i_matrix_truedaycnt(i_loc_year,i_loc_month)
         CALL SLEEP(50)
        ENDIF

       ENDIF                           !data test condition
      ENDDO                            !close l_prod counter

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
          DO i=1,l_prod
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
c************************************************************************
c      GOTO 18
c************************************************************************
c     Extract line of month data

      ii=1

      DO j=1,300
       DO k=1,12 

c       Fill time stamp regardless
        s_monrec_month(ii) =s_name_month(k)
        s_monrec_year(ii)  =s_name_year(j)

c       Initialize series with ndflag
        f_monrec_value(ii) =f_ndflag
        i_monrec_flag(ii)  =i_ndflag

        IF (i_matrix_monthflag(j,k).EQ.0.OR.
     +      i_matrix_monthflag(j,k).EQ.1) THEN

         f_monrec_value(ii) =f_matrix_average(j,k)
         i_monrec_flag(ii)  =i_matrix_monthflag(j,k)

         IF (ii.GT.5000) THEN 
          print*,'emergency stop, month ii over range'
          CALL SLEEP(200)
         ENDIF
        ENDIF

        ii=ii+1              !increment month counter
       ENDDO
      ENDDO

      l_mon=ii-1

c      print*,'l_mon=',l_mon
c      IF (l_mon.GT.0) THEN 
c       print*,'s_monrec_month=',(s_monrec_month(i),i=1,10)
c       print*,'s_monrec_year=', (s_monrec_year(i),i=1,10)
c       print*,'f_monrec_value=',(f_monrec_value(i),i=1,10)
c       print*,'i_monrec_flag=', (i_monrec_flag(i),i=1,10)
c      ENDIF

18    CONTINUE
c************************************************************************
c     Find index record start

c      ist=i_ndflag
c      ien=i_ndflag

c      DO i=1,l_mon 
c       IF (f_monrec_value(i).NE.f_ndflag) THEN 
c        ist=i
c        GOTO 14
c       ENDIF
c      ENDDO
c14    CONTINUE

c     Find index record end
c      DO i=l_mon,1,-1 
c       IF (f_monrec_value(i).NE.f_ndflag) THEN 
c        ien=i
c        GOTO 16
c       ENDIF
c      ENDDO
c16    CONTINUE

c      print*,'ist,ien=',ist,ien
c************************************************************************
      RETURN
      END
