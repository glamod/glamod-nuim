c     Subroutine to find reconstructed dates & times
c     AJ_Kettle, 14Dec2019

      SUBROUTINE reconstruct_date_time(
     +  s_single_year,s_single_month,s_single_day,
     +  s_single_hour,s_single_minute,
     +  s_date_reconstruct_yyyy_mm_dd,s_time_reconstruct_hh_mm_ss,
     +  s_corr_year,s_corr_month,s_corr_day,s_corr_hour,s_corr_minute)

      IMPLICIT NONE
c************************************************************************
c     Variables passed into subroutine
      CHARACTER(LEN=4)    :: s_single_year
      CHARACTER(LEN=2)    :: s_single_month
      CHARACTER(LEN=2)    :: s_single_day
      CHARACTER(LEN=2)    :: s_single_hour
      CHARACTER(LEN=2)    :: s_single_minute

      CHARACTER(LEN=10)   :: s_date_reconstruct_yyyy_mm_dd
      CHARACTER(LEN=8)    :: s_time_reconstruct_hh_mm_ss
c*****
c     Variables used in subroutine
      CHARACTER(LEN=4)    :: s_corr_year
      CHARACTER(LEN=2)    :: s_corr_month
      CHARACTER(LEN=2)    :: s_corr_day
      CHARACTER(LEN=2)    :: s_corr_hour
      CHARACTER(LEN=2)    :: s_corr_minute
c************************************************************************

      s_corr_year  =s_single_year
      s_corr_month =s_single_month
      s_corr_day   =s_single_day
      s_corr_hour  =s_single_hour
      s_corr_minute=s_single_minute

      IF (LEN_TRIM(s_single_month).EQ.0.OR.
     +    LEN_TRIM(s_single_day)  .EQ.0.OR.
     +    LEN_TRIM(s_single_hour) .EQ.0.OR.
     +    LEN_TRIM(s_single_day)  .EQ.0) THEN 
       print*,'no entry in date time field'
       STOP 'reconstruct_date_time'
      ENDIF

      IF (LEN_TRIM(s_single_month).EQ.1) THEN 
       s_corr_month='0'//TRIM(s_single_month)
      ENDIF
      IF (LEN_TRIM(s_single_day).EQ.1) THEN 
       s_corr_day='0'//TRIM(s_single_day)
      ENDIF
      IF (LEN_TRIM(s_single_hour).EQ.1) THEN 
       s_corr_hour='0'//TRIM(s_single_hour)
      ENDIF
      IF (LEN_TRIM(s_single_minute).EQ.1) THEN 
       s_corr_minute='0'//TRIM(s_single_minute)
      ENDIF

       s_date_reconstruct_yyyy_mm_dd=
     +   TRIM(s_corr_year)//'-'//
     +   TRIM(s_corr_month)//'-'//
     +   TRIM(s_corr_day)
       s_time_reconstruct_hh_mm_ss=
     +   TRIM(s_corr_hour)//':'//
     +   TRIM(s_corr_minute)//':00'


      RETURN
      END
