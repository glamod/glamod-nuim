c     Package to convert times to UTC
c     AJ_Kettle, Dec08/2017

      SUBROUTINE convert_time_utc(l_mlent,j_sd,f_lon_deg,
     +   st_sd_time,st_sd_time_id,
     +   st_sd_timeutc,st_sd_timeutc_hh_mm_ss)

      IMPLICIT NONE
c************************************************************************
      INTEGER             :: i,j,k,ii,jj,kk

      INTEGER             :: l_mlent
      INTEGER             :: j_sd
      CHARACTER(LEN=4)    :: st_sd_time(l_mlent)
      CHARACTER(LEN=3)    :: st_sd_time_id(l_mlent)
      REAL                :: f_lon_deg

      CHARACTER(LEN=4)    :: st_sd_timeutc(l_mlent)
      CHARACTER(LEN=8)    :: st_sd_timeutc_hh_mm_ss(l_mlent)

c     Intermediate variables for time conversion
      CHARACTER(LEN=4)    :: s_timesingle
      CHARACTER(LEN=2)    :: s_hour
      CHARACTER(LEN=2)    :: s_minute
      CHARACTER(LEN=2)    :: s_second
      CHARACTER(LEN=2)    :: s_test2
      REAL                :: f_test
      REAL                :: f_hour 
      REAL                :: f_minute
      REAL                :: f_hourfrac
      REAL                :: f_hourfrac_utc
      INTEGER             :: i_hournew
      INTEGER             :: i_minutenew
      INTEGER             :: i_secondnew
      REAL                :: f_minutenew
      REAL                :: f_secondnew
      REAL                :: f_minuteround
      INTEGER             :: i_test
      INTEGER             :: i_minuteround

      CHARACTER(LEN=2)    :: s_hournew
      CHARACTER(LEN=2)    :: s_minutenew
      CHARACTER(LEN=2)    :: s_secondnew
c************************************************************************
c      print*,'st_sd_time_id..start',st_sd_time_id(1)
c      print*,'st_sd_time_id..end',st_sd_time_id(j_sd)
c      call sleep(5)

      DO i=1,j_sd
c       print*,'st_sd_time_id(i)',st_sd_time_id(i)

       s_timesingle=st_sd_time(i)
       s_hour      =s_timesingle(1:2)
       s_minute    =s_timesingle(3:4)
       s_second    ='00'
     
c      Convert hour & minute to float
       s_test2       =TRIM(s_hour)
       READ(s_test2,*) f_test
       f_hour        =f_test

       s_test2       =TRIM(s_minute)
       READ(s_test2,*) f_test
       f_minute      =f_test

       f_hourfrac=f_hour+f_minute/60.0
c******
c      UTC: no change in format
       IF (st_sd_time_id(i).EQ.'UTC') THEN 
        st_sd_timeutc(i)=st_sd_time(i)

        st_sd_timeutc_hh_mm_ss(i)=
     +    s_hour//':'//s_minute//':'//s_second

c        print*,'UTC case'
c        CALL SLEEP(1)

        GOTO 22
       ENDIF
c******
c      MEZ: shift by 1hour
       IF (st_sd_time_id(i).EQ.'MEZ') THEN 
        f_hourfrac_utc=f_hourfrac-1.0
        i_hournew=INT(f_hourfrac_utc)
        f_minutenew=(f_hourfrac_utc-FLOAT(i_hournew))*60.0
        i_minutenew=INT((f_hourfrac_utc-FLOAT(i_hournew))*60.0)
        f_secondnew=(f_minutenew-FLOAT(i_minutenew))*60.0
        i_secondnew=INT(f_secondnew)
  
c       Convert from integer to string
        IF (i_hournew.GE.10) THEN
         WRITE(s_test2,'(i2)') i_hournew
         s_hournew=s_test2
        ENDIF
        IF (i_hournew.LT.10) THEN
         WRITE(s_test2,'(i2)') i_hournew
         s_hournew='0'//TRIM(ADJUSTL(s_test2))
        ENDIF

        IF (i_minutenew.GE.10) THEN
         WRITE(s_test2,'(i2)') i_minutenew
         s_minutenew=s_test2
        ENDIF
        IF (i_minutenew.LT.10) THEN
         WRITE(s_test2,'(i2)') i_minutenew
         s_minutenew='0'//TRIM(ADJUSTL(s_test2))
        ENDIF

        IF (i_secondnew.GE.10) THEN
         WRITE(s_test2,'(i2)') i_secondnew
         s_secondnew=s_test2
        ENDIF
        IF (i_secondnew.LT.10) THEN
         WRITE(s_test2,'(i2)') i_secondnew
         s_secondnew='0'//TRIM(ADJUSTL(s_test2))
        ENDIF

        st_sd_timeutc(i)=s_hournew//s_minutenew
        st_sd_timeutc_hh_mm_ss(i)=
     +    s_hournew//':'//s_minutenew//':'//s_secondnew

c        print*,'MEZ case'
c        print*,'st_sd_time,st_sd_timeutc',st_sd_time(i),
c     +    st_sd_timeutc(i),st_sd_timeutc_hh_mm_ss(i)
c        CALL SLEEP(5)

        GOTO 22
       ENDIF
c******
c      MOZ: convert LST to UTC
       IF (st_sd_time_id(i).EQ.'MOZ') THEN 
        f_hourfrac_utc=f_hourfrac-24.0*(f_lon_deg/360.0)
        i_hournew=INT(f_hourfrac_utc)
        f_minutenew=(f_hourfrac_utc-FLOAT(i_hournew))*60.0
        i_minutenew=INT((f_hourfrac_utc-FLOAT(i_hournew))*60.0)
        f_secondnew=(f_minutenew-FLOAT(i_minutenew))*60.0
        i_secondnew=INT(f_secondnew)

c       Procedure to round minutes
        f_minuteround=10.0*FLOAT(NINT(f_minutenew/10.0))
c       case where rounded minutes >60s
        IF (f_minuteround.GE.60.0) THEN 
         f_minuteround=f_minuteround-60.0
         i_hournew=i_hournew+1               
        ENDIF
        i_minuteround=INT(f_minuteround)

c       Convert from integer to string
        IF (i_hournew.GE.10) THEN
         WRITE(s_test2,'(i2)') i_hournew
         s_hournew=s_test2
        ENDIF
        IF (i_hournew.LT.10) THEN
         WRITE(s_test2,'(i2)') i_hournew
         s_hournew='0'//TRIM(ADJUSTL(s_test2))
        ENDIF

        IF (i_minuteround.GE.10) THEN
         WRITE(s_test2,'(i2)') i_minuteround
         s_minutenew=s_test2
        ENDIF
        IF (i_minuteround.LT.10) THEN
         WRITE(s_test2,'(i2)') i_minuteround
         s_minutenew='0'//TRIM(ADJUSTL(s_test2))
        ENDIF

c        IF (i_minutenew.GE.10) THEN
c         WRITE(s_test2,'(i2)') i_minutenew
c         s_minutenew=s_test2
c        ENDIF
c        IF (i_minutenew.LT.10) THEN
c         WRITE(s_test2,'(i2)') i_minutenew
c         s_minutenew='0'//TRIM(ADJUSTL(s_test2))
c        ENDIF

c        IF (i_minutenew.GE.10) THEN
c         WRITE(s_test2,'(i2)') i_minutenew
c         s_minutenew=s_test2
c        ENDIF
c        IF (i_minutenew.LT.10) THEN
c         WRITE(s_test2,'(i2)') i_minutenew
c         s_minutenew='0'//TRIM(ADJUSTL(s_test2))
c        ENDIF

c        IF (i_secondnew.GE.10) THEN
c         WRITE(s_test2,'(i2)') i_secondnew
c         s_secondnew=s_test2
c        ENDIF
c        IF (i_secondnew.LT.10) THEN
c         WRITE(s_test2,'(i2)') i_secondnew
c         s_secondnew='0'//TRIM(ADJUSTL(s_test2))
c        ENDIF
c       Hardwire seconds to 00
        s_secondnew='00'

        st_sd_timeutc(i)=s_hournew//s_minutenew
        st_sd_timeutc_hh_mm_ss(i)=
     +    s_hournew//':'//s_minutenew//':'//s_secondnew

c        print*,'MOZ case',i
c        print*,'f_lon_deg=',f_lon_deg
c        print*,'f_hour=',f_hour 
c        print*,'f_minute=',f_minute
c        print*,'f_hourfrac=',f_hourfrac
c        print*,'f_hourfrac_utc=',f_hourfrac_utc
c        print*,'i_hournew=',i_hournew
c        print*,'i_minutenew=',i_minutenew
c        print*,'s_hournew=',s_hournew
c        print*,'s_minutenew=',s_minutenew

c        print*,'i_hournew,i_minuteround',i_hournew,i_minuteround

c        print*,'st_sd_time,st_sd_timeutc',st_sd_time(i),
c     +    st_sd_timeutc(i),st_sd_timeutc_hh_mm_ss(i)
c        CALL SLEEP(1)

        GOTO 22
       ENDIF
c******
       print*,'emergency stop, convert_variables'
       print*,'no time id, i=',i,j_sd
       CALL SLEEP(20)

22     CONTINUE
      ENDDO

      RETURN
      END
