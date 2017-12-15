c     Subroutine to identify complete months in record
c     AJ_Kettle, Nov09/2017

      SUBROUTINE identify_complete_months(l_prod,s_day_date)

      IMPLICIT NONE
c************************************************************************
      INTEGER             :: l_prod
      CHARACTER(LEN=8)    :: s_day_date(100000)

      INTEGER             :: i,j,k,ii,jj,kk

      INTEGER             :: n_monthdays_expect(12)
      INTEGER             :: n_monthdays_expect2(12)
      INTEGER             :: i_vec_year(300)
      REAL                :: f_vec_year(300)
      REAL                :: f_result
      INTEGER             :: i_refyear
      INTEGER             :: i_matrix_monthdays(300,12)
      INTEGER             :: i_matrix_truedaycnt(300,12)
      INTEGER             :: i_loc_year
      INTEGER             :: i_loc_month
      INTEGER             :: ii1,ii2,ii3

      INTEGER             :: l_cnt_month
      INTEGER             :: l_cnt_month_bad
      INTEGER             :: l_cnt_month_good

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
      CHARACTER(LEN=2)    :: s_mon_ref 

      INTEGER             :: i_monend(10000)
      INTEGER             :: i_monstart(10000)
      INTEGER             :: i_monlength(10000)
      INTEGER             :: i_yearid(10000)
      INTEGER             :: i_monthid(10000)
      INTEGER             :: n_month

      CHARACTER(LEN=2)    :: s_test2 
      CHARACTER(LEN=4)    :: s_test4 
      REAL                :: f_test
      INTEGER             :: i_test

c************************************************************************
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

       s_test2=s_day_year(i)
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

       s_test2=s_day_year(i)
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
        i_matrix_truedaycnt(j,k)=0
       ENDDO
      ENDDO

c     Increment counter
      DO i=1,l_prod      !cycle through length of file
       i_loc_year =i_day_year(i)-1750+1
       i_loc_month=i_day_month(i)

       i_matrix_truedaycnt(i_loc_year,i_loc_month)= 
     +    i_matrix_truedaycnt(i_loc_year,i_loc_month)+1

       IF (i_matrix_truedaycnt(i_loc_year,i_loc_month).GT.31) THEN 
        print*,'emergency stop at point, month days exceeded',
     +   i_day_year(i),i_day_month(i),
     +   i_matrix_truedaycnt(i_loc_year,i_loc_month)
        CALL SLEEP(50)
       ENDIF
      ENDDO

c     Test to see in number of days in true counts exceeds 31
      DO j=1,300
       DO k=1,12 
        IF (i_matrix_truedaycnt(j,k).GT.31) THEN
         print*,'emergency stop, month days exceeded',j,k,
     +     i_matrix_truedaycnt(j,k)
c         CALL SLEEP(5)
        ENDIF
       ENDDO
      ENDDO

c     Count number of months with deficient days
      l_cnt_month     =0
      l_cnt_month_bad =0
      l_cnt_month_good=0
      DO j=1,300
       DO k=1,12 
        IF (i_matrix_truedaycnt(j,k).GT.0) THEN
         l_cnt_month=l_cnt_month+1

         IF (i_matrix_truedaycnt(j,k).EQ.i_matrix_monthdays(j,k)) THEN
          l_cnt_month_good=l_cnt_month_good+1
         ENDIF 
         IF (i_matrix_truedaycnt(j,k).LT.i_matrix_monthdays(j,k)) THEN
          l_cnt_month_bad =l_cnt_month_bad+1
         ENDIF 
        ENDIF
       ENDDO
      ENDDO

c      print*,'matrix comparison l_cnt_month...',
c     +  l_cnt_month,l_cnt_month_good,l_cnt_month_bad
c      IF (l_cnt_month_bad.GT.0) THEN 
c       CALL SLEEP(5)
c      ENDIF
c************************************************************************
c     Test if first year before 1750
      IF (i_day_year(1).LT.1750) THEN 
       print*,'emergency stop; 1st year before 1750',i_day_year(1)
       CALL SLEEP(100)
      ENDIF
c************************************************************************
c     Count number of month changes in record
      ii=1
      i_monstart(ii)=ii         !first month start indicator
      s_mon_ref=s_day_month(1)
      i_yearid(ii) =i_day_year(1)
      i_monthid(ii)=i_day_month(1)

      DO i=2,l_prod 

c      Condition for month switch
       IF (s_day_month(i).NE.s_mon_ref) THEN
        s_mon_ref=s_day_month(i)
        i_monend(ii)=i-1
        ii=ii+1
        i_monstart(ii)=i
        i_yearid(ii) =i_day_year(i)
        i_monthid(ii)=i_day_month(i)

        IF (ii.GT.10000) THEN 
         print*,'Month storage array exceeded'
         CALL SLEEP(10)
        ENDIF
       ENDIF 
      ENDDO
      i_monend(ii)=l_prod      !last month end indicator

      n_month=ii

c     Find lengths of months
      DO i=1,n_month 
       i_monlength(i)=i_monend(i)-i_monstart(i)+1

c       IF (i_monlength(i).GT.31) THEN 
c        print*,'i_monlength exceeded',i_monlength(i)
c        print*,'i_monstart(i)=',i_monstart(i)
c        print*,'i_monend(i)=',  i_monend(i)
c       ENDIF
      ENDDO

c      print*,'ii nmonth=',n_month
c      print*,'i_monstart start=',(i_monstart(i),i=1,5)
c      print*,'i_monend   start=',(i_monend(i),i=1,5)
c      print*,'i_monstart end=',  (i_monstart(i),i=n_month-5,n_month)
c      print*,'i_monend   end=',  (i_monend(i),i=n_month-5,n_month)
c      print*,'i_monlength=',     (i_monlength(i),i=1,5)
      
c      print*,'i_yearid=',        (i_yearid(i),i=1,14)      
c      print*,'i_monthid=',       (i_monthid(i),i=1,14)      

c      print*,'s_day_month=',(s_day_month(i),i=1,5)  


c************************************************************************
c     Test to see if day counts complete

      DO i=1,n_month         !cycle through sequential month list

c      Cycle through leap year list
       DO j=1,i_refyear
c       test if sequential year matches vec_year
        IF (i_yearid(i).EQ.i_vec_year(j)) THEN 
c        Cycle through matrix months
         DO k=1,12 
c         Test if match between months
          IF (i_monthid(i).EQ.k) THEN 
c          Test if number of days good
           IF (i_monlength(i).EQ.i_matrix_monthdays(j,k)) THEN
c            print*,'good match',j,k,i_matrix_monthdays(j,k)
c            CALL SLEEP(1)
           ENDIF 

c           IF (i_monlength(i).NE.i_matrix_monthdays(j,k)) THEN
c            print*,'months incomplete'
c            print*,'i_matrix_monthdays ref=',i_matrix_monthdays(j,k)
c            print*,'year/month index=',j,k
c            print*,'i_monlength test=',      i_monlength(i)
cc            CALL SLEEP(5)
c           ENDIF 

          ENDIF
         ENDDO
        ENDIF  
       ENDDO                 !close j
      ENDDO

c      CALL SLEEP(5)
c************************************************************************
      RETURN
      END