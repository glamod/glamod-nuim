c     Subroutine to find number of distinct time stamps
c     AJ_Kettle, 05Dec2018

      SUBROUTINE find_distinct_timesteps20210511(l_lines_rgh,l_lines,
     +  s_arch_id,s_arch_date_yyyymmdd,s_arch_element,s_arch_datavalue,
     +  s_arch_mflag,s_arch_qflag,s_arch_sflag,s_arch_obstime,
     +  s_param_select,

     +  l_timestamp_rgh,l_timestamp,s_distinct_date_yyyymmdd,
     +  s_prcp_datavalue,s_prcp_mflag,s_prcp_qflag,s_prcp_sflag, 
     +    s_prcp_obstime,
     +  s_tmin_datavalue,s_tmin_mflag,s_tmin_qflag,s_tmin_sflag,
     +    s_tmin_obstime,
     +  s_tmax_datavalue,s_tmax_mflag,s_tmax_qflag,s_tmax_sflag,
     +    s_tmax_obstime,
     +  s_tavg_datavalue,s_tavg_mflag,s_tavg_qflag,s_tavg_sflag,
     +    s_tavg_obstime,
     +  s_snwd_datavalue,s_snwd_mflag,s_snwd_qflag,s_snwd_sflag,
     +    s_snwd_obstime,
     +  s_snow_datavalue,s_snow_mflag,s_snow_qflag,s_snow_sflag,
     +    s_snow_obstime,
     +  s_awnd_datavalue,s_awnd_mflag,s_awnd_qflag,s_awnd_sflag,
     +    s_awnd_obstime,
     +  s_awdr_datavalue,s_awdr_mflag,s_awdr_qflag,s_awdr_sflag,
     +    s_awdr_obstime,
     +  s_wesd_datavalue,s_wesd_mflag,s_wesd_qflag,s_wesd_sflag,
     +    s_wesd_obstime)

      IMPLICIT NONE
c************************************************************************
c     Declare variables passed into program

      INTEGER             :: l_lines_rgh
      INTEGER             :: l_lines

      CHARACTER(LEN=12)   :: s_arch_id(l_lines_rgh)
      CHARACTER(LEN=8)    :: s_arch_date_yyyymmdd(l_lines_rgh)
      CHARACTER(LEN=4)    :: s_arch_element(l_lines_rgh)
      CHARACTER(LEN=5)    :: s_arch_datavalue(l_lines_rgh)
      CHARACTER(LEN=1)    :: s_arch_mflag(l_lines_rgh)
      CHARACTER(LEN=1)    :: s_arch_qflag(l_lines_rgh)
      CHARACTER(LEN=1)    :: s_arch_sflag(l_lines_rgh)
      CHARACTER(LEN=4)    :: s_arch_obstime(l_lines_rgh)

      CHARACTER(LEN=4)    :: s_param_select(9)

      INTEGER             :: l_timestamp_rgh
      INTEGER             :: l_timestamp

      CHARACTER(LEN=8)    :: s_distinct_date_yyyymmdd(l_timestamp_rgh)

      CHARACTER(LEN=4)    :: s_prcp_element(l_timestamp_rgh)
      CHARACTER(LEN=5)    :: s_prcp_datavalue(l_timestamp_rgh)
      CHARACTER(LEN=1)    :: s_prcp_mflag(l_timestamp_rgh)
      CHARACTER(LEN=1)    :: s_prcp_qflag(l_timestamp_rgh)
      CHARACTER(LEN=1)    :: s_prcp_sflag(l_timestamp_rgh)
      CHARACTER(LEN=4)    :: s_prcp_obstime(l_timestamp_rgh)

      CHARACTER(LEN=5)    :: s_tmin_datavalue(l_timestamp_rgh)
      CHARACTER(LEN=1)    :: s_tmin_mflag(l_timestamp_rgh)
      CHARACTER(LEN=1)    :: s_tmin_qflag(l_timestamp_rgh)
      CHARACTER(LEN=1)    :: s_tmin_sflag(l_timestamp_rgh)
      CHARACTER(LEN=4)    :: s_tmin_obstime(l_timestamp_rgh)

      CHARACTER(LEN=5)    :: s_tmax_datavalue(l_timestamp_rgh)
      CHARACTER(LEN=1)    :: s_tmax_mflag(l_timestamp_rgh)
      CHARACTER(LEN=1)    :: s_tmax_qflag(l_timestamp_rgh)
      CHARACTER(LEN=1)    :: s_tmax_sflag(l_timestamp_rgh)
      CHARACTER(LEN=4)    :: s_tmax_obstime(l_timestamp_rgh)

      CHARACTER(LEN=5)    :: s_tavg_datavalue(l_timestamp_rgh)
      CHARACTER(LEN=1)    :: s_tavg_mflag(l_timestamp_rgh)
      CHARACTER(LEN=1)    :: s_tavg_qflag(l_timestamp_rgh)
      CHARACTER(LEN=1)    :: s_tavg_sflag(l_timestamp_rgh)
      CHARACTER(LEN=4)    :: s_tavg_obstime(l_timestamp_rgh)

      CHARACTER(LEN=5)    :: s_snwd_datavalue(l_timestamp_rgh)
      CHARACTER(LEN=1)    :: s_snwd_mflag(l_timestamp_rgh)
      CHARACTER(LEN=1)    :: s_snwd_qflag(l_timestamp_rgh)
      CHARACTER(LEN=1)    :: s_snwd_sflag(l_timestamp_rgh)
      CHARACTER(LEN=4)    :: s_snwd_obstime(l_timestamp_rgh)

      CHARACTER(LEN=5)    :: s_snow_datavalue(l_timestamp_rgh)
      CHARACTER(LEN=1)    :: s_snow_mflag(l_timestamp_rgh)
      CHARACTER(LEN=1)    :: s_snow_qflag(l_timestamp_rgh)
      CHARACTER(LEN=1)    :: s_snow_sflag(l_timestamp_rgh)
      CHARACTER(LEN=4)    :: s_snow_obstime(l_timestamp_rgh)

      CHARACTER(LEN=5)    :: s_awnd_datavalue(l_timestamp_rgh)
      CHARACTER(LEN=1)    :: s_awnd_mflag(l_timestamp_rgh)
      CHARACTER(LEN=1)    :: s_awnd_qflag(l_timestamp_rgh)
      CHARACTER(LEN=1)    :: s_awnd_sflag(l_timestamp_rgh)
      CHARACTER(LEN=4)    :: s_awnd_obstime(l_timestamp_rgh)

      CHARACTER(LEN=5)    :: s_awdr_datavalue(l_timestamp_rgh)
      CHARACTER(LEN=1)    :: s_awdr_mflag(l_timestamp_rgh)
      CHARACTER(LEN=1)    :: s_awdr_qflag(l_timestamp_rgh)
      CHARACTER(LEN=1)    :: s_awdr_sflag(l_timestamp_rgh)
      CHARACTER(LEN=4)    :: s_awdr_obstime(l_timestamp_rgh)

      CHARACTER(LEN=5)    :: s_wesd_datavalue(l_timestamp_rgh)
      CHARACTER(LEN=1)    :: s_wesd_mflag(l_timestamp_rgh)
      CHARACTER(LEN=1)    :: s_wesd_qflag(l_timestamp_rgh)
      CHARACTER(LEN=1)    :: s_wesd_sflag(l_timestamp_rgh)
      CHARACTER(LEN=4)    :: s_wesd_obstime(l_timestamp_rgh)
c*****
c     Variables used within program

      INTEGER             :: i,j,k,ii,jj,kk

      INTEGER             :: i_vec_st(l_timestamp_rgh)
      INTEGER             :: i_vec_en(l_timestamp_rgh)

c************************************************************************
      print*,'just inside find_distinct_timesteps20210511'

      print*,'l_lines_rgh...',l_lines_rgh,l_lines
      print*,'s_arch_id=',(s_arch_id(i),i=1,5)
      print*,'s_arch_date_yyyymmdd=',(s_arch_date_yyyymmdd(i),i=1,5)
      print*,'s_arch_element=',(s_arch_element(i),i=1,5)
      print*,'s_arch_datavalue',(s_arch_datavalue(i),i=1,5)
      print*,'s_arch_mflag',(s_arch_mflag(i),i=1,5)
      print*,'s_arch_qflag',(s_arch_qflag(i),i=1,5)
      print*,'s_arch_sflag',(s_arch_sflag(i),i=1,5)
      print*,'s_arch_obstime',(s_arch_obstime(i),i=1,5)

      ii=0
      ii=ii+1
      s_distinct_date_yyyymmdd(ii)=s_arch_date_yyyymmdd(1)
      i_vec_st(ii)=1

c     Cycle through source lines
      DO i=2,l_lines

c      Cycle through distinct liest
       DO j=1,ii
c       Exit loop if match found
        IF (s_arch_date_yyyymmdd(i).EQ.s_distinct_date_yyyymmdd(j)) THEN 
         GOTO 100
        ENDIF
       ENDDO

c      Case of no match found
c      Update list of distinct dates
       ii=ii+1

c      Emergency stop if index exceeds allocated array
       IF (ii.GT.l_timestamp_rgh) THEN
         print*,'ii,l_timestamp_rgh=',ii,l_timestamp_rgh
         STOP 'find_distinct_timestemps; ii GT l_timestamp_rgh'
       ENDIF

       s_distinct_date_yyyymmdd(ii)=s_arch_date_yyyymmdd(i)

 100   CONTINUE

      ENDDO

      l_timestamp=ii

      print*,'l_timestamp=',l_timestamp
      STOP 'find_distinct_timesteps20210511'
c************************************************************************
c     Initialize extraction variables to null values
      DO i=1,l_timestamp_rgh
       s_prcp_datavalue(i)=''
       s_prcp_mflag(i)    =''
       s_prcp_qflag(i)    =''
       s_prcp_sflag(i)    =''
       s_prcp_obstime(i)  =''

       s_tmin_datavalue(i)=''
       s_tmin_mflag(i)    =''
       s_tmin_qflag(i)    =''
       s_tmin_sflag(i)    =''
       s_tmin_obstime(i)  =''

       s_tmax_datavalue(i)=''
       s_tmax_mflag(i)    =''
       s_tmax_qflag(i)    =''
       s_tmax_sflag(i)    =''
       s_tmax_obstime(i)  =''

       s_tavg_datavalue(i)=''
       s_tavg_mflag(i)    =''
       s_tavg_qflag(i)    =''
       s_tavg_sflag(i)    =''
       s_tavg_obstime(i)  =''

       s_snwd_datavalue(i)=''
       s_snwd_mflag(i)    =''
       s_snwd_qflag(i)    =''
       s_snwd_sflag(i)    =''
       s_snwd_obstime(i)  =''

       s_snow_datavalue(i)=''
       s_snow_mflag(i)    =''
       s_snow_qflag(i)    =''
       s_snow_sflag(i)    =''
       s_snow_obstime(i)  =''

       s_awnd_datavalue(i)=''
       s_awnd_mflag(i)    =''
       s_awnd_qflag(i)    =''
       s_awnd_sflag(i)    =''
       s_awnd_obstime(i)  =''

       s_awdr_datavalue(i)=''
       s_awdr_mflag(i)    =''
       s_awdr_qflag(i)    =''
       s_awdr_sflag(i)    =''
       s_awdr_obstime(i)  =''

       s_wesd_datavalue(i)=''
       s_wesd_mflag(i)    =''
       s_wesd_qflag(i)    =''
       s_wesd_sflag(i)    =''
       s_wesd_obstime(i)  =''

      ENDDO
c************************************************************************
c     Cycle through indices
      DO i=1,l_timestamp 
       DO j=i_vec_st(i),i_vec_en(i)
        DO k=1,9 
         IF (s_arch_element(j).EQ.s_param_select(k)) THEN 

          IF (k.EQ.1) THEN 
           s_prcp_datavalue(i)=s_arch_datavalue(j)
           s_prcp_mflag(i)    =s_arch_mflag(j)
           s_prcp_qflag(i)    =s_arch_qflag(j)
           s_prcp_sflag(i)    =s_arch_sflag(j)
           s_prcp_obstime(i)  =s_arch_obstime(j)
          ENDIF
          IF (k.EQ.2) THEN 
           s_tmin_datavalue(i)=s_arch_datavalue(j)
           s_tmin_mflag(i)    =s_arch_mflag(j)
           s_tmin_qflag(i)    =s_arch_qflag(j)
           s_tmin_sflag(i)    =s_arch_sflag(j)
           s_tmin_obstime(i)  =s_arch_obstime(j)
          ENDIF
          IF (k.EQ.3) THEN 
           s_tmax_datavalue(i)=s_arch_datavalue(j)
           s_tmax_mflag(i)    =s_arch_mflag(j)
           s_tmax_qflag(i)    =s_arch_qflag(j)
           s_tmax_sflag(i)    =s_arch_sflag(j)
           s_tmax_obstime(i)  =s_arch_obstime(j)
          ENDIF
          IF (k.EQ.4) THEN 
           s_tavg_datavalue(i)=s_arch_datavalue(j)
           s_tavg_mflag(i)    =s_arch_mflag(j)
           s_tavg_qflag(i)    =s_arch_qflag(j)
           s_tavg_sflag(i)    =s_arch_sflag(j)
           s_tavg_obstime(i)  =s_arch_obstime(j)
          ENDIF
          IF (k.EQ.5) THEN 
           s_snwd_datavalue(i)=s_arch_datavalue(j)
           s_snwd_mflag(i)    =s_arch_mflag(j)
           s_snwd_qflag(i)    =s_arch_qflag(j)
           s_snwd_sflag(i)    =s_arch_sflag(j)
           s_snwd_obstime(i)  =s_arch_obstime(j)
          ENDIF
          IF (k.EQ.6) THEN 
           s_snow_datavalue(i)=s_arch_datavalue(j)
           s_snow_mflag(i)    =s_arch_mflag(j)
           s_snow_qflag(i)    =s_arch_qflag(j)
           s_snow_sflag(i)    =s_arch_sflag(j)
           s_snow_obstime(i)  =s_arch_obstime(j)
          ENDIF
          IF (k.EQ.7) THEN 
           s_awnd_datavalue(i)=s_arch_datavalue(j)
           s_awnd_mflag(i)    =s_arch_mflag(j)
           s_awnd_qflag(i)    =s_arch_qflag(j)
           s_awnd_sflag(i)    =s_arch_sflag(j)
           s_awnd_obstime(i)  =s_arch_obstime(j)
          ENDIF
          IF (k.EQ.8) THEN 
           s_awdr_datavalue(i)=s_arch_datavalue(j)
           s_awdr_mflag(i)    =s_arch_mflag(j)
           s_awdr_qflag(i)    =s_arch_qflag(j)
           s_awdr_sflag(i)    =s_arch_sflag(j)
           s_awdr_obstime(i)  =s_arch_obstime(j)
          ENDIF
          IF (k.EQ.9) THEN 
           s_wesd_datavalue(i)=s_arch_datavalue(j)
           s_wesd_mflag(i)    =s_arch_mflag(j)
           s_wesd_qflag(i)    =s_arch_qflag(j)
           s_wesd_sflag(i)    =s_arch_sflag(j)
           s_wesd_obstime(i)  =s_arch_obstime(j)
          ENDIF

         ENDIF
        ENDDO
       ENDDO
      ENDDO
c************************************************************************
c      print*,'l_lines,l_timestamp=',l_lines,l_timestamp
c      print*,'s_arch_date_yyyymmdd',s_arch_date_yyyymmdd(1),
c     +  s_arch_date_yyyymmdd(l_lines)
c      print*,'s_distinct_date_yyyymmdd=',s_distinct_date_yyyymmdd(1),
c     +  s_distinct_date_yyyymmdd(l_timestamp)

c      print*,'i_vec_st=',(i_vec_st(i),i=1,10)
c      print*,'i_vec_en=',(i_vec_en(i),i=1,10)

c      print*,'i_vec_st=',(i_vec_st(i),i=l_timestamp-10,l_timestamp)
c      print*,'i_vec_en=',(i_vec_en(i),i=l_timestamp-10,l_timestamp)

c      print*,'s_distinct_date_yyyymmdd=',
c     +  (s_distinct_date_yyyymmdd(i),i=1,5)
c      print*,'s_tmin_datavalue',(s_tmin_datavalue(i),i=1,5)
c      print*,'s_tmin_mflag',(s_tmin_mflag(i),i=1,5)
c      print*,'s_tmin_qflag',(s_tmin_qflag(i),i=1,5)
c      print*,'s_tmin_sflag',(s_tmin_sflag(i),i=1,5)
c      print*,'s_tmin_obstime',(s_tmin_obstime(i),i=1,5)

c      print*,'just leaving find_distinct_timesteps2'

c      STOP 'find_distinct_timesteps2'
c************************************************************************

      RETURN
      END
