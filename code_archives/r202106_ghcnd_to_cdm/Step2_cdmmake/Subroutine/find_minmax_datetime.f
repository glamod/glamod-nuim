c     Subroutine to find updated start/end datetime
c     AJ_Kettle, 11Feb2021

      SUBROUTINE find_minmax_datetime(s_obs_date_time,d_obs_jtime,
     +     d_obs_jtime_min,d_obs_jtime_max,
     +     s_obs_date_time_st,s_obs_date_time_en)

      IMPLICIT NONE
c************************************************************************
c     Variables passed into subroutine

      CHARACTER(*)        :: s_obs_date_time                  

      DOUBLE PRECISION    :: d_obs_jtime
      DOUBLE PRECISION    :: d_obs_jtime_min,d_obs_jtime_max

      CHARACTER(*)        :: s_obs_date_time_st,s_obs_date_time_en
c*****
c     Variables used within subroutine

      INTEGER             :: i,j,k,ii,jj,kk

      DOUBLE PRECISION    :: d_obs_jtime_min_new,d_obs_jtime_max_new
c************************************************************************

      d_obs_jtime_min_new=MIN(d_obs_jtime,d_obs_jtime_min) 
      d_obs_jtime_max_new=MAX(d_obs_jtime,d_obs_jtime_max)

c     Case of new minimum value
      IF (d_obs_jtime_min_new.NE.d_obs_jtime_min) THEN 
       d_obs_jtime_min=d_obs_jtime_min_new
       s_obs_date_time_st=s_obs_date_time
      ENDIF

c     Case of new maximum value
      IF (d_obs_jtime_max_new.NE.d_obs_jtime_max) THEN 
       d_obs_jtime_max=d_obs_jtime_max_new
       s_obs_date_time_en=s_obs_date_time
      ENDIF

      RETURN
      END
