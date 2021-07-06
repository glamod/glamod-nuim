c     Subroutine to get record number
c     AJ_Kettle, 19Dec2018

      SUBROUTINE total_counts_recordnumber2(l_timestamp_rgh,l_timestamp,
     +    s_prcp_recordnumber,s_tmin_recordnumber,s_tmax_recordnumber,
     +    s_tavg_recordnumber,s_snwd_recordnumber,s_snow_recordnumber,
     +    s_awnd_recordnumber,s_awdr_recordnumber,s_wesd_recordnumber,
     +    l_collect_cnt,s_collect_record_number,

     +    i_collect_cnt_valid_prcp,i_collect_cnt_valid_tmin,
     +    i_collect_cnt_valid_tmax,i_collect_cnt_valid_tavg,
     +    i_collect_cnt_valid_snwd,i_collect_cnt_valid_snow,
     +    i_collect_cnt_valid_awnd,i_collect_cnt_valid_awdr,
     +    i_collect_cnt_valid_wesd,
     +    i_collect_cnt_valid_tot,
     +    i_collect_cnt_grandtot)

      IMPLICIT NONE
c************************************************************************
c     Declare variables passed into program

      INTEGER             :: l_timestamp_rgh
      INTEGER             :: l_timestamp

      CHARACTER(LEN=*)    :: s_prcp_recordnumber(l_timestamp_rgh)
      CHARACTER(LEN=*)    :: s_tmin_recordnumber(l_timestamp_rgh)
      CHARACTER(LEN=*)    :: s_tmax_recordnumber(l_timestamp_rgh)
      CHARACTER(LEN=*)    :: s_tavg_recordnumber(l_timestamp_rgh)
      CHARACTER(LEN=*)    :: s_snwd_recordnumber(l_timestamp_rgh)
      CHARACTER(LEN=*)    :: s_snow_recordnumber(l_timestamp_rgh)
      CHARACTER(LEN=*)    :: s_awnd_recordnumber(l_timestamp_rgh)
      CHARACTER(LEN=*)    :: s_awdr_recordnumber(l_timestamp_rgh)
      CHARACTER(LEN=*)    :: s_wesd_recordnumber(l_timestamp_rgh)

      INTEGER             :: l_collect_cnt
      CHARACTER(LEN=*)    :: s_collect_record_number(20)

      INTEGER             :: i_collect_cnt_valid_prcp(20)
      INTEGER             :: i_collect_cnt_valid_tmin(20)
      INTEGER             :: i_collect_cnt_valid_tmax(20)
      INTEGER             :: i_collect_cnt_valid_tavg(20)
      INTEGER             :: i_collect_cnt_valid_snwd(20)
      INTEGER             :: i_collect_cnt_valid_snow(20)
      INTEGER             :: i_collect_cnt_valid_awnd(20)
      INTEGER             :: i_collect_cnt_valid_awdr(20)
      INTEGER             :: i_collect_cnt_valid_wesd(20)

      INTEGER             :: i_collect_cnt_valid_tot(20)
      INTEGER             :: i_collect_cnt_grandtot
c*****
c     Variables used in program

      INTEGER             :: i,j,k,ii,jj,kk
c************************************************************************
c      print*,'just entered total_counts_recordnumber2'

c      print*,'l_timestamp=',l_timestamp
c      print*,'s_tmin_recordnumber=',(TRIM(s_tmin_recordnumber(j)),j=1,5)

c      print*,'l_collect_cnt=',l_collect_cnt
c      print*,'s_collect_record_number=',
c     +  (TRIM(s_collect_record_number(i)),i=1,l_collect_cnt)

c     Find total data count in each record number

c     Initialize all count variables
      DO i=1,20
       i_collect_cnt_valid_prcp(i)=0
       i_collect_cnt_valid_tmin(i)=0
       i_collect_cnt_valid_tmax(i)=0
       i_collect_cnt_valid_tavg(i)=0
       i_collect_cnt_valid_snwd(i)=0
       i_collect_cnt_valid_snow(i)=0
       i_collect_cnt_valid_awnd(i)=0
       i_collect_cnt_valid_awdr(i)=0
       i_collect_cnt_valid_wesd(i)=0
       i_collect_cnt_valid_tot(i) =0
      ENDDO

      DO i=1,l_collect_cnt
       DO j=1,l_timestamp

c       1
        IF (TRIM(s_collect_record_number(i)).EQ.
     +      TRIM(s_prcp_recordnumber(j))) THEN 
         i_collect_cnt_valid_prcp(i)=i_collect_cnt_valid_prcp(i)+1
        ENDIF
c       2
        IF (TRIM(s_collect_record_number(i)).EQ.
     +      TRIM(s_tmin_recordnumber(j))) THEN 
         i_collect_cnt_valid_tmin(i)=i_collect_cnt_valid_tmin(i)+1
        ENDIF
c       3
        IF (TRIM(s_collect_record_number(i)).EQ.
     +      TRIM(s_tmax_recordnumber(j))) THEN 
         i_collect_cnt_valid_tmax(i)=i_collect_cnt_valid_tmax(i)+1
        ENDIF
c       4
        IF (TRIM(s_collect_record_number(i)).EQ.
     +      TRIM(s_tavg_recordnumber(j))) THEN 
         i_collect_cnt_valid_tavg(i)=i_collect_cnt_valid_tavg(i)+1
        ENDIF
c       5
        IF (TRIM(s_collect_record_number(i)).EQ.
     +      TRIM(s_snwd_recordnumber(j))) THEN 
         i_collect_cnt_valid_snwd(i)=i_collect_cnt_valid_snwd(i)+1
        ENDIF
c       6 
        IF (TRIM(s_collect_record_number(i)).EQ.
     +      TRIM(s_snow_recordnumber(j))) THEN 
         i_collect_cnt_valid_snow(i)=i_collect_cnt_valid_snow(i)+1
        ENDIF
c       7
        IF (TRIM(s_collect_record_number(i)).EQ.
     +      TRIM(s_awnd_recordnumber(j))) THEN 
         i_collect_cnt_valid_awnd(i)=i_collect_cnt_valid_awnd(i)+1
        ENDIF
c       8
        IF (TRIM(s_collect_record_number(i)).EQ.
     +      TRIM(s_awdr_recordnumber(j))) THEN 
         i_collect_cnt_valid_awdr(i)=i_collect_cnt_valid_awdr(i)+1
        ENDIF
c       9. 
        IF (TRIM(s_collect_record_number(i)).EQ.
     +      TRIM(s_wesd_recordnumber(j))) THEN 
         i_collect_cnt_valid_wesd(i)=i_collect_cnt_valid_wesd(i)+1
        ENDIF
       ENDDO
      ENDDO

c     Find total of 9 parameters
      i_collect_cnt_grandtot=0
      DO i=1,l_collect_cnt
       i_collect_cnt_valid_tot(i)=
     +    i_collect_cnt_valid_prcp(i)+i_collect_cnt_valid_tmin(i)+
     +    i_collect_cnt_valid_tmax(i)+i_collect_cnt_valid_tavg(i)+
     +    i_collect_cnt_valid_snwd(i)+i_collect_cnt_valid_snow(i)+
     +    i_collect_cnt_valid_awnd(i)+i_collect_cnt_valid_awdr(i)+
     +    i_collect_cnt_valid_wesd(i)
       i_collect_cnt_grandtot=i_collect_cnt_grandtot+
     +    i_collect_cnt_valid_tot(i)
      ENDDO

      IF (i_collect_cnt_grandtot.EQ.0) THEN 

      print*,'prcp',(i_collect_cnt_valid_prcp(i),i=1,l_collect_cnt)
      print*,'tmin',(i_collect_cnt_valid_tmin(i),i=1,l_collect_cnt)
      print*,'tmax',(i_collect_cnt_valid_tmax(i),i=1,l_collect_cnt)
      print*,'tavg',(i_collect_cnt_valid_tavg(i),i=1,l_collect_cnt)
      print*,'snwd',(i_collect_cnt_valid_snwd(i),i=1,l_collect_cnt)
      print*,'snow',(i_collect_cnt_valid_snow(i),i=1,l_collect_cnt)
      print*,'awnd',(i_collect_cnt_valid_awnd(i),i=1,l_collect_cnt)
      print*,'awdr',(i_collect_cnt_valid_awdr(i),i=1,l_collect_cnt)
      print*,'wesd',(i_collect_cnt_valid_wesd(i),i=1,l_collect_cnt)
      print*,'total',(i_collect_cnt_valid_tot(i),i=1,l_collect_cnt)

c      print*,'i_collect_cnt_grandtot=',i_collect_cnt_grandtot

c      STOP 'total_counts_recordnumber; i_collect_cnt_grandtot=0'

      ENDIF
c************************************************************************
c      print*,'just leaving total_counts_recordnumber'

c      STOP 'total_counts_recordnumber'

      RETURN
      END
