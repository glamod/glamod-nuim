c     Subroutine to find vector of populated record numbers
c     AJ_Kettle, 19Dec2018

      SUBROUTINE find_vector_recordnumber2(l_collect_cnt,l_channel,
     +   s_collect_record_number,
     +   s_prcp_recordnumber_sing,s_tmin_recordnumber_sing,
     +   s_tmax_recordnumber_sing,s_tavg_recordnumber_sing,
     +   s_snwd_recordnumber_sing,s_snow_recordnumber_sing,
     +   s_awnd_recordnumber_sing,s_awdr_recordnumber_sing,
     +   s_wesd_recordnumber_sing,
     +   i_collect_populated_recnum,s_vec_recordnumber)

      IMPLICIT NONE
c************************************************************************
c     Declare variables passed into program

      INTEGER             :: l_channel

      INTEGER             :: l_collect_cnt
      CHARACTER(LEN=*)    :: s_collect_record_number(20)  !3

      CHARACTER(LEN=*)    :: s_prcp_recordnumber_sing
      CHARACTER(LEN=*)    :: s_tmin_recordnumber_sing
      CHARACTER(LEN=*)    :: s_tmax_recordnumber_sing
      CHARACTER(LEN=*)    :: s_tavg_recordnumber_sing
      CHARACTER(LEN=*)    :: s_snwd_recordnumber_sing
      CHARACTER(LEN=*)    :: s_snow_recordnumber_sing
      CHARACTER(LEN=*)    :: s_awnd_recordnumber_sing
      CHARACTER(LEN=*)    :: s_awdr_recordnumber_sing
      CHARACTER(LEN=*)    :: s_wesd_recordnumber_sing

      INTEGER             :: i_collect_populated_recnum(20)
      CHARACTER(LEN=*)    :: s_vec_recordnumber(l_channel)
c*****
c     Variables used in program
      INTEGER             :: i,j,k,ii,jj,kk
c************************************************************************
c      print*,'just inside find_vector_recordnumber'

c     Initialize counter
      DO i=1,20
       i_collect_populated_recnum(i)=0
      ENDDO

      DO i=1,l_collect_cnt   !go through record numbers from stn_config

       IF (TRIM(s_collect_record_number(i)).EQ.
     +     TRIM(s_prcp_recordnumber_sing)) THEN
        i_collect_populated_recnum(i)=i_collect_populated_recnum(i)+1
       ENDIF
       IF (TRIM(s_collect_record_number(i)).EQ.
     +     TRIM(s_tmin_recordnumber_sing)) THEN
        i_collect_populated_recnum(i)=i_collect_populated_recnum(i)+1
       ENDIF
       IF (TRIM(s_collect_record_number(i)).EQ.
     +     TRIM(s_tmax_recordnumber_sing)) THEN
        i_collect_populated_recnum(i)=i_collect_populated_recnum(i)+1
       ENDIF
       IF (TRIM(s_collect_record_number(i)).EQ.
     +     TRIM(s_tavg_recordnumber_sing)) THEN
        i_collect_populated_recnum(i)=i_collect_populated_recnum(i)+1
       ENDIF
       IF (TRIM(s_collect_record_number(i)).EQ.
     +     TRIM(s_snwd_recordnumber_sing)) THEN
        i_collect_populated_recnum(i)=i_collect_populated_recnum(i)+1
       ENDIF
       IF (TRIM(s_collect_record_number(i)).EQ.
     +     TRIM(s_snow_recordnumber_sing)) THEN
        i_collect_populated_recnum(i)=i_collect_populated_recnum(i)+1
       ENDIF
       IF (TRIM(s_collect_record_number(i)).EQ.
     +     TRIM(s_awnd_recordnumber_sing)) THEN
        i_collect_populated_recnum(i)=i_collect_populated_recnum(i)+1
       ENDIF
       IF (TRIM(s_collect_record_number(i)).EQ.
     +     TRIM(s_awdr_recordnumber_sing)) THEN
        i_collect_populated_recnum(i)=i_collect_populated_recnum(i)+1
       ENDIF
       IF (TRIM(s_collect_record_number(i)).EQ.
     +     TRIM(s_wesd_recordnumber_sing)) THEN
        i_collect_populated_recnum(i)=i_collect_populated_recnum(i)+1
       ENDIF

      ENDDO
c************************************************************************
c     Define record number

      s_vec_recordnumber(1)=s_prcp_recordnumber_sing
      s_vec_recordnumber(2)=s_tmin_recordnumber_sing
      s_vec_recordnumber(3)=s_tmax_recordnumber_sing
      s_vec_recordnumber(4)=s_tavg_recordnumber_sing
      s_vec_recordnumber(5)=s_snwd_recordnumber_sing
      s_vec_recordnumber(6)=s_snow_recordnumber_sing
      s_vec_recordnumber(7)=s_awnd_recordnumber_sing
      s_vec_recordnumber(8)=s_awdr_recordnumber_sing
      s_vec_recordnumber(9)=s_wesd_recordnumber_sing
c************************************************************************
c      print*,'l_collect_cnt=',l_collect_cnt
c      print*,'recnum=',(i_collect_populated_recnum(i),i=1,l_collect_cnt)

c      print*,'just leaving find_vector_recordnumber'
c      STOP 'find_vector_recordnumber'

      RETURN
      END
