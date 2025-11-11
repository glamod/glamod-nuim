c     Subroutine to get record number
c     AJ_Kettle, 18Dec2018
c     14JAN2019: source id 229 has minor ambiguity for RR,TN,TX

c     subroutines called:
c     -search_stringfragment2
c     -ambigcase_get_low_record2

      SUBROUTINE get_record_number2(l_timestamp_rgh,l_timestamp,
     +    s_prcp_sourceid,s_tmin_sourceid,s_tmax_sourceid,
     +    s_tavg_sourceid,s_snwd_sourceid,s_snow_sourceid,
     +    s_awnd_sourceid,s_awdr_sourceid,s_wesd_sourceid,
     +    l_collect_cnt,l_collect_distinct,s_collect_record_number,
     +    s_collect_source_id,s_collect_secondary_id,
     +    s_collect_flagambig, 

     +    s_prcp_recordnumber,s_tmin_recordnumber,s_tmax_recordnumber,
     +    s_tavg_recordnumber,s_snwd_recordnumber,s_snow_recordnumber,
     +    s_awnd_recordnumber,s_awdr_recordnumber,s_wesd_recordnumber,
     +    i_flag_skip)

      IMPLICIT NONE
c************************************************************************
c     Declare variables passed into program

      INTEGER             :: l_timestamp_rgh
      INTEGER             :: l_timestamp

      CHARACTER(LEN=3)    :: s_prcp_sourceid(l_timestamp_rgh)
      CHARACTER(LEN=3)    :: s_tmin_sourceid(l_timestamp_rgh)
      CHARACTER(LEN=3)    :: s_tmax_sourceid(l_timestamp_rgh)
      CHARACTER(LEN=3)    :: s_tavg_sourceid(l_timestamp_rgh)
      CHARACTER(LEN=3)    :: s_snwd_sourceid(l_timestamp_rgh)
      CHARACTER(LEN=3)    :: s_snow_sourceid(l_timestamp_rgh)
      CHARACTER(LEN=3)    :: s_awnd_sourceid(l_timestamp_rgh)
      CHARACTER(LEN=3)    :: s_awdr_sourceid(l_timestamp_rgh)
      CHARACTER(LEN=3)    :: s_wesd_sourceid(l_timestamp_rgh)

      INTEGER             :: l_collect_cnt
      INTEGER             :: l_collect_distinct
      CHARACTER(LEN=*)    :: s_collect_record_number(20)  !2
      CHARACTER(LEN=*)    :: s_collect_source_id(20)      !3
      CHARACTER(LEN=*)    :: s_collect_secondary_id(20)   !12
      CHARACTER(LEN=*)    :: s_collect_flagambig(20)      !1

      INTEGER             :: i_collect_cnt_valid_tot(20)
      INTEGER             :: i_collect_cnt_valid_prcp(20)
      INTEGER             :: i_collect_cnt_valid_tmin(20)
      INTEGER             :: i_collect_cnt_valid_tmax(20)
      INTEGER             :: i_collect_cnt_valid_tavg(20)
      INTEGER             :: i_collect_cnt_valid_snwd(20)
      INTEGER             :: i_collect_cnt_valid_snow(20)
      INTEGER             :: i_collect_cnt_valid_awnd(20)
      INTEGER             :: i_collect_cnt_valid_awdr(20)
      INTEGER             :: i_collect_cnt_valid_wesd(20)

      CHARACTER(LEN=*)    :: s_prcp_recordnumber(l_timestamp_rgh)  !len=2
      CHARACTER(LEN=*)    :: s_tmin_recordnumber(l_timestamp_rgh)
      CHARACTER(LEN=*)    :: s_tmax_recordnumber(l_timestamp_rgh)
      CHARACTER(LEN=*)    :: s_tavg_recordnumber(l_timestamp_rgh)
      CHARACTER(LEN=*)    :: s_snwd_recordnumber(l_timestamp_rgh)
      CHARACTER(LEN=*)    :: s_snow_recordnumber(l_timestamp_rgh)
      CHARACTER(LEN=*)    :: s_awnd_recordnumber(l_timestamp_rgh)
      CHARACTER(LEN=*)    :: s_awdr_recordnumber(l_timestamp_rgh)
      CHARACTER(LEN=*)    :: s_wesd_recordnumber(l_timestamp_rgh)

      INTEGER             :: i_flag_skip
c*****
c     Declare variables used in program

      INTEGER             :: i,j,k,ii,jj,kk
      INTEGER             :: i_len
      INTEGER             :: i_tripflag(9)
      INTEGER             :: i_tripflag_sum

      CHARACTER(LEN=2)    :: s_keystring
      CHARACTER(LEN=12)   :: s_single_secondary_id
      INTEGER             :: i_result

      CHARACTER(LEN=4)    :: s_shuntflag
      CHARACTER(LEN=4)    :: s_variable(9)
      CHARACTER(LEN=3)    :: s_record_numberchosen 
c************************************************************************
c      print *,'just entered get_record_number2'

c      print *,'l_timestamp=',l_timestamp
c      print *,'l_timestamp_rgh=',l_timestamp_rgh

c      print*,'l_collect_cnt=',l_collect_cnt,l_collect_distinct
c      print*,'s_collect_record_number=',
c     +  ('='//TRIM(s_collect_record_number(i))//'=',i=1,l_collect_cnt)
c      print*,'s_collect_source_id=',    
c     +  ('='//TRIM(s_collect_source_id(i))//'=',i=1,l_collect_cnt)
c      print*,'s_collect_secondary_id=', 
c     +  (s_collect_secondary_id(i),i=1,l_collect_cnt)
c      print*,'s_collect_flag_ambig=',  
c     +  (s_collect_flagambig(i),i=1,l_collect_cnt)

c      STOP 'get_record_number2'

      i_flag_skip=0      !main flag to skip for irregularity in source_id 165

      s_shuntflag='skip' !'good'

c     Define list of variable names
      s_variable(1)='PRCP'
      s_variable(2)='TMIN'
      s_variable(3)='TMAX'
      s_variable(4)='TAVG'
      s_variable(5)='SNWD'
      s_variable(6)='SNOW'
      s_variable(7)='AWND'
      s_variable(8)='AWDR'
      s_variable(9)='WESD'

c     Initialize i_tripflag
      DO i=1,9
       i_tripflag(i)=0
      ENDDO

c     Initialize record numbers
      DO i=1,l_timestamp_rgh
       s_prcp_recordnumber(i)=''
       s_tmin_recordnumber(i)=''
       s_tmax_recordnumber(i)=''
       s_tavg_recordnumber(i)=''
       s_snwd_recordnumber(i)=''
       s_snow_recordnumber(i)=''
       s_awnd_recordnumber(i)=''
       s_awdr_recordnumber(i)=''
       s_wesd_recordnumber(i)=''
      ENDDO

      IF (l_collect_cnt.EQ.l_collect_distinct) THEN 
       DO i=1,l_timestamp

c        print*,'Group 1,i=',i

c       PRCP
        jj=1
        i_len=LEN_TRIM(s_prcp_sourceid(i))
        IF (i_len.GT.0) THEN 
         DO j=1,l_collect_cnt
          IF (TRIM(s_prcp_sourceid(i)).EQ.s_collect_source_id(j)) THEN 
           s_prcp_recordnumber(i)=s_collect_record_number(j)
           i_tripflag(jj)=1
          ENDIF
         ENDDO
        ENDIF

c       TMIN
        jj=2
        i_len=LEN_TRIM(s_tmin_sourceid(i))
        IF (i_len.GT.0) THEN 
         DO j=1,l_collect_cnt
          IF (TRIM(s_tmin_sourceid(i)).EQ.s_collect_source_id(j)) THEN 
           s_tmin_recordnumber(i)=s_collect_record_number(j)
           i_tripflag(jj)=1
          ENDIF
         ENDDO
        ENDIF

c       TMAX
        jj=3
        i_len=LEN_TRIM(s_tmax_sourceid(i))
        IF (i_len.GT.0) THEN 
         DO j=1,l_collect_cnt
          IF (TRIM(s_tmax_sourceid(i)).EQ.s_collect_source_id(j)) THEN 
           s_tmax_recordnumber(i)=s_collect_record_number(j)
           i_tripflag(jj)=1
          ENDIF
         ENDDO
        ENDIF

c       TAVG
        jj=4
        i_len=LEN_TRIM(s_tavg_sourceid(i))
        IF (i_len.GT.0) THEN 
         DO j=1,l_collect_cnt
          IF (TRIM(s_tavg_sourceid(i)).EQ.s_collect_source_id(j)) THEN 
           s_tavg_recordnumber(i)=s_collect_record_number(j)
           i_tripflag(jj)=1
          ENDIF
         ENDDO
        ENDIF

c       SNWD
        jj=5
        i_len=LEN_TRIM(s_snwd_sourceid(i))
        IF (i_len.GT.0) THEN 
         DO j=1,l_collect_cnt
          IF (TRIM(s_snwd_sourceid(i)).EQ.s_collect_source_id(j)) THEN 
           s_snwd_recordnumber(i)=s_collect_record_number(j)
           i_tripflag(jj)=1
          ENDIF
         ENDDO
        ENDIF

c       SNOW
        jj=6
        i_len=LEN_TRIM(s_snow_sourceid(i))
        IF (i_len.GT.0) THEN 
         DO j=1,l_collect_cnt
          IF (TRIM(s_snow_sourceid(i)).EQ.s_collect_source_id(j)) THEN 
           s_snow_recordnumber(i)=s_collect_record_number(j)
           i_tripflag(jj)=1
          ENDIF
         ENDDO
        ENDIF

c       AWND
        jj=7
        i_len=LEN_TRIM(s_awnd_sourceid(i))
        IF (i_len.GT.0) THEN 
         DO j=1,l_collect_cnt
          IF (TRIM(s_awnd_sourceid(i)).EQ.s_collect_source_id(j)) THEN 
           s_awnd_recordnumber(i)=s_collect_record_number(j)
           i_tripflag(jj)=1
          ENDIF
         ENDDO
        ENDIF

c       AWDR
        jj=8
        i_len=LEN_TRIM(s_awdr_sourceid(i))
        IF (i_len.GT.0) THEN 
         DO j=1,l_collect_cnt
          IF (TRIM(s_awdr_sourceid(i)).EQ.s_collect_source_id(j)) THEN 
           s_awdr_recordnumber(i)=s_collect_record_number(j)
           i_tripflag(jj)=1
          ENDIF
         ENDDO
        ENDIF

c       WESD
        jj=9
        i_len=LEN_TRIM(s_wesd_sourceid(i))
        IF (i_len.GT.0) THEN 
         DO j=1,l_collect_cnt
          IF (TRIM(s_wesd_sourceid(i)).EQ.s_collect_source_id(j)) THEN 
           s_wesd_recordnumber(i)=s_collect_record_number(j)
           i_tripflag(jj)=1
          ENDIF
         ENDDO
        ENDIF

       ENDDO

c      Sum triplet flag counter
       i_tripflag_sum=0
       DO j=1,9 
        i_tripflag_sum=i_tripflag_sum+i_tripflag(j)
       ENDDO

c       IF (i_tripflag_sum.EQ.0) THEN 
c        STOP 'get_record_number; i_tripflag_sum=0'
c       ENDIF

c       print*,'i_tripflag=',(i_tripflag(i),i=1,9)
c       print*,'i_tripflag_sum=',i_tripflag_sum
      ENDIF

c      print*,'cleared group 1'
c*****
c*****
c*****
c     Case of non-unique source id
      IF (l_collect_cnt.NE.l_collect_distinct) THEN 

c       print*,'l_collect_cnt=',l_collect_cnt
c       print*,'l_collect_distinct=',l_collect_distinct
c       print*,'s_collect_record_number=',
c     +   (s_collect_record_number(i),i=1,l_collect_cnt)
c       print*,'s_collect_source_id=',
c     +   (s_collect_source_id(i),i=1,l_collect_cnt)
c       print*,'s_collect_secondary_id=',
c     +   (s_collect_secondary_id(i),i=1,l_collect_cnt)

c      Cycle data record
       DO i=1,l_timestamp
    
c        print*,'Group 2,i=',i

c       PRCP
        jj=1
        i_len=LEN_TRIM(s_prcp_sourceid(i))
c       Act if source_id available
        IF (i_len.GT.0) THEN 

c        Search through all non-ambiguous sources first
         DO j=1,l_collect_cnt    !cycle through short list record numbers
c         Case of non-ambiguous source_id
          IF (TRIM(s_collect_flagambig(j)).EQ.'0') THEN
           IF (TRIM(s_prcp_sourceid(i)).EQ.s_collect_source_id(j)) THEN 
            s_prcp_recordnumber(i)=s_collect_record_number(j)
            i_tripflag(jj)=1
            GOTO 31
           ENDIF
          ENDIF
         ENDDO

c        Search through all ambiguous sources second
         DO j=1,l_collect_cnt    !cycle through short list record numbers
c         Case of ambiguous source_id
          IF (TRIM(s_collect_flagambig(j)).EQ.'1') THEN
           s_keystring='RR'
           s_single_secondary_id=s_collect_secondary_id(j)
           i_result=0           !initialize
           CALL search_stringfragment2(
     +       s_keystring,s_single_secondary_id,i_result)
           IF (i_result.EQ.1) THEN
            s_prcp_recordnumber(i)=s_collect_record_number(j)
            i_tripflag(jj)=1

c            print*,'special case ambiguity; RR'
c            print*,'source_id',s_collect_source_id(j)
c            STOP 'get_record_number'

            GOTO 31
           ENDIF
          ENDIF
         ENDDO

c        If here then problem
         CALL ambigcase_get_low_record2(s_variable(jj),
     +     s_prcp_sourceid(i),
     +     l_collect_cnt,s_collect_source_id,s_collect_record_number,
     +     s_record_numberchosen,
     +     i_flag_skip)

c        Exit program in case of source_id irregularity
         IF (i_flag_skip.EQ.1) THEN 
          GOTO 100
         ENDIF

         s_prcp_recordnumber(i)=s_record_numberchosen   !blank the record number

      IF (s_shuntflag.EQ.'good') THEN
       print*,'i,s_prcp_sourceid=',i,s_prcp_sourceid(i)
       print*,'l_collect_cnt=',l_collect_cnt
       print*,'l_collect_distinct=',l_collect_distinct
       print*,'s_collect_record_number=',
     +   (s_collect_record_number(ii),ii=1,l_collect_cnt)
       print*,'s_collect_source_id=',
     +   (s_collect_source_id(ii),ii=1,l_collect_cnt)
       print*,'s_collect_secondary_id=',
     +   (s_collect_secondary_id(ii),ii=1,l_collect_cnt)
       STOP 'get_record_number; prcp position'
      ENDIF

        ENDIF
 31     CONTINUE

c        print*,'cleared PRCP'

c       TMIN
        jj=2
        i_len=LEN_TRIM(s_tmin_sourceid(i))
c       Act if source_id available
        IF (i_len.GT.0) THEN 

c        Search through all non-ambiguous sources first
         DO j=1,l_collect_cnt    !cycle through short list record numbers
c         Case of non-ambiguous source_id
          IF (TRIM(s_collect_flagambig(j)).EQ.'0') THEN
           IF (TRIM(s_tmin_sourceid(i)).EQ.s_collect_source_id(j)) THEN 
            s_tmin_recordnumber(i)=s_collect_record_number(j)
            i_tripflag(jj)=1
            GOTO 32
           ENDIF
          ENDIF
         ENDDO

c        Search through all ambiguous sources second
         DO j=1,l_collect_cnt    !cycle through short list record numbers
c         Case of ambiguous source_id
          IF (TRIM(s_collect_flagambig(j)).EQ.'1') THEN
           s_keystring='TN'
           s_single_secondary_id=s_collect_secondary_id(j)
           i_result=0           !initialize
           CALL search_stringfragment2(
     +       s_keystring,s_single_secondary_id,i_result)
           IF (i_result.EQ.1) THEN
            s_tmin_recordnumber(i)=s_collect_record_number(j)
            i_tripflag(jj)=1

c            print*,'special case ambiguity; TN'
c            print*,'source_id',s_collect_source_id(j)
c            STOP 'get_record_number'

            GOTO 32
           ENDIF
          ENDIF
         ENDDO

c        If here then problem
         CALL ambigcase_get_low_record2(s_variable(jj),
     +     s_tmin_sourceid(i),
     +     l_collect_cnt,s_collect_source_id,s_collect_record_number,
     +     s_record_numberchosen,
     +     i_flag_skip)

c        Exit program in case of source_id irregularity
         IF (i_flag_skip.EQ.1) THEN 
          GOTO 100
         ENDIF

         s_tmin_recordnumber(i)=s_record_numberchosen   !blank the record number

      IF (s_shuntflag.EQ.'good') THEN
       print*,'i,s_tmin_sourceid=',i,s_tmin_sourceid(i)
       print*,'l_collect_cnt=',l_collect_cnt
       print*,'l_collect_distinct=',l_collect_distinct
       print*,'s_collect_record_number=',
     +   (s_collect_record_number(ii),ii=1,l_collect_cnt)
       print*,'s_collect_source_id=',
     +   (s_collect_source_id(ii),ii=1,l_collect_cnt)
       print*,'s_collect_secondary_id=',
     +   (s_collect_secondary_id(ii),ii=1,l_collect_cnt)
       STOP 'get_record_number; tmin position'
      ENDIF

        ENDIF
 32     CONTINUE

c        print*,'cleared TMIN'

c       TMAX
        jj=3
        i_len=LEN_TRIM(s_tmax_sourceid(i))
c       Act if source_id available
        IF (i_len.GT.0) THEN 

c        Search through all non-ambiguous sources first
         DO j=1,l_collect_cnt    !cycle through short list record numbers
c         Case of non-ambiguous source_id
          IF (TRIM(s_collect_flagambig(j)).EQ.'0') THEN
           IF (TRIM(s_tmax_sourceid(i)).EQ.s_collect_source_id(j)) THEN 
            s_tmax_recordnumber(i)=s_collect_record_number(j)
            i_tripflag(jj)=1
            GOTO 33
           ENDIF
          ENDIF
         ENDDO

c        Search through all ambiguous sources second
         DO j=1,l_collect_cnt    !cycle through short list record numbers
c         Case of ambiguous source_id
          IF (TRIM(s_collect_flagambig(j)).EQ.'1') THEN
           s_keystring='TX'
           s_single_secondary_id=s_collect_secondary_id(j)
           i_result=0           !initialize
           CALL search_stringfragment2(
     +       s_keystring,s_single_secondary_id,i_result)
           IF (i_result.EQ.1) THEN
            s_tmax_recordnumber(i)=s_collect_record_number(j)
            i_tripflag(jj)=1

c            print*,'special case ambiguity; TX'
c            print*,'source_id',s_collect_source_id(j)
c            STOP 'get_record_number'

            GOTO 33
           ENDIF
          ENDIF
         ENDDO

c        If here then problem
         CALL ambigcase_get_low_record2(s_variable(jj),
     +     s_tmax_sourceid(i),
     +     l_collect_cnt,s_collect_source_id,s_collect_record_number,
     +     s_record_numberchosen,
     +     i_flag_skip)

c        Exit program in case of source_id irregularity
         IF (i_flag_skip.EQ.1) THEN 
          GOTO 100
         ENDIF

         s_tmax_recordnumber(i)=s_record_numberchosen   !blank the record number

      IF (s_shuntflag.EQ.'good') THEN
       print*,'i,s_tmax_sourceid=',i,s_tmax_sourceid(i)
       print*,'l_collect_cnt=',l_collect_cnt
       print*,'l_collect_distinct=',l_collect_distinct
       print*,'s_collect_record_number=',
     +   (s_collect_record_number(ii),ii=1,l_collect_cnt)
       print*,'s_collect_source_id=',
     +   (s_collect_source_id(ii),ii=1,l_collect_cnt)
       print*,'s_collect_secondary_id=',
     +   (s_collect_secondary_id(ii),ii=1,l_collect_cnt)
       STOP 'get_record_number; tmax position'
      ENDIF

        ENDIF
 33     CONTINUE

c        print*,'cleared TMAX'

c       TAVG
        jj=4
        i_len=LEN_TRIM(s_tavg_sourceid(i))
c       Act if source_id available
        IF (i_len.GT.0) THEN 
c        Search through all non-ambiguous sources first
         DO j=1,l_collect_cnt    !cycle through short list record numbers
c         Case of non-ambiguous source_id
          IF (TRIM(s_collect_flagambig(j)).EQ.'0') THEN
           IF (TRIM(s_tavg_sourceid(i)).EQ.s_collect_source_id(j)) THEN 
            s_tavg_recordnumber(i)=s_collect_record_number(j)
            i_tripflag(jj)=1
            GOTO 34
           ENDIF
          ENDIF
         ENDDO

c        If here then problem of multiple record number
         CALL ambigcase_get_low_record2(s_variable(jj),
     +     s_tavg_sourceid(i),
     +     l_collect_cnt,s_collect_source_id,s_collect_record_number,
     +     s_record_numberchosen,
     +     i_flag_skip)

c        Exit program in case of source_id irregularity
         IF (i_flag_skip.EQ.1) THEN 
          GOTO 100
         ENDIF

         s_tavg_recordnumber(i)=s_record_numberchosen   !blank the record number

      IF (s_shuntflag.EQ.'good') THEN
       print*,'i,s_tavg_sourceid=',i,s_tavg_sourceid(i)
       print*,'l_collect_cnt=',l_collect_cnt
       print*,'l_collect_distinct=',l_collect_distinct
       print*,'s_collect_record_number=',
     +  ('='//TRIM(s_collect_record_number(ii))//'=',ii=1,l_collect_cnt)
       print*,'s_collect_source_id=',
     +  ('='//TRIM(s_collect_source_id(ii))//'=',ii=1,l_collect_cnt)
       print*,'s_collect_secondary_id=',
     +  ('='//TRIM(s_collect_secondary_id(ii))//'=',ii=1,l_collect_cnt)
       STOP 'get_record_number; tavg position'
      ENDIF

        ENDIF
 34     CONTINUE

c        print*,'cleared TAVG'

c       SNWD
        jj=5
        i_len=LEN_TRIM(s_snwd_sourceid(i))
c       Act if source_id available
        IF (i_len.GT.0) THEN 
c        Search through all non-ambiguous sources first
         DO j=1,l_collect_cnt    !cycle through short list record numbers
c         Case of non-ambiguous source_id
          IF (TRIM(s_collect_flagambig(j)).EQ.'0') THEN
           IF (TRIM(s_snwd_sourceid(i)).EQ.s_collect_source_id(j)) THEN 
            s_snwd_recordnumber(i)=s_collect_record_number(j)
            i_tripflag(jj)=1
            GOTO 35
           ENDIF
          ENDIF
         ENDDO

c        Search through all ambiguous sources second
         DO j=1,l_collect_cnt    !cycle through short list record numbers
c         Case of ambiguous source_id
          IF (TRIM(s_collect_flagambig(j)).EQ.'1') THEN
           s_keystring='SD'
           s_single_secondary_id=s_collect_secondary_id(j)
           i_result=0           !initialize
           CALL search_stringfragment2(
     +       s_keystring,s_single_secondary_id,i_result)
           IF (i_result.EQ.1) THEN
            s_snwd_recordnumber(i)=s_collect_record_number(j)
            i_tripflag(jj)=1
            GOTO 35
           ENDIF
          ENDIF
         ENDDO

c        If here then problem; nothing found in secondary id
         CALL ambigcase_get_low_record2(s_variable(jj),
     +     s_snwd_sourceid(i),
     +     l_collect_cnt,s_collect_source_id,s_collect_record_number,
     +     s_record_numberchosen,
     +     i_flag_skip)

c        Exit program in case of source_id irregularity
         IF (i_flag_skip.EQ.1) THEN 
          GOTO 100
         ENDIF

         s_snwd_recordnumber(i)=s_record_numberchosen   !blank the record number

      IF (s_shuntflag.EQ.'good') THEN
       print*,'i,s_snwd_sourceid=',i,s_snwd_sourceid(i)
       print*,'l_collect_cnt=',l_collect_cnt
       print*,'l_collect_distinct=',l_collect_distinct
       print*,'s_collect_record_number=',
     +   (s_collect_record_number(ii),ii=1,l_collect_cnt)
       print*,'s_collect_source_id=',
     +   (s_collect_source_id(ii),ii=1,l_collect_cnt)
       print*,'s_collect_secondary_id=',
     +   (s_collect_secondary_id(ii),ii=1,l_collect_cnt)
       STOP 'get_record_number; snwd position'
      ENDIF

        ENDIF
 35     CONTINUE

c        print*,'cleared SNWD'

c       SNOW
        jj=6
        i_len=LEN_TRIM(s_snow_sourceid(i))
c       Act if source_id available
        IF (i_len.GT.0) THEN 
c        Search through all non-ambiguous sources first
         DO j=1,l_collect_cnt    !cycle through short list record numbers
c         Case of non-ambiguous source_id
          IF (TRIM(s_collect_flagambig(j)).EQ.'0') THEN
           IF (TRIM(s_snow_sourceid(i)).EQ.s_collect_source_id(j)) THEN 
            s_snow_recordnumber(i)=s_collect_record_number(j)
            i_tripflag(jj)=1
            GOTO 36
           ENDIF
          ENDIF
         ENDDO

c        If here then problem

         CALL ambigcase_get_low_record2(s_variable(jj),
     +     s_snow_sourceid(i),
     +     l_collect_cnt,s_collect_source_id,s_collect_record_number,
     +     s_record_numberchosen,
     +     i_flag_skip)

c        Exit program in case of source_id irregularity
         IF (i_flag_skip.EQ.1) THEN 
          GOTO 100
         ENDIF

         s_snow_recordnumber(i)=s_record_numberchosen   !blank the record number

      IF (s_shuntflag.EQ.'good') THEN
       print*,'i,s_snow_sourceid=',i,s_snow_sourceid(i)
       print*,'l_collect_cnt=',l_collect_cnt
       print*,'l_collect_distinct=',l_collect_distinct
       print*,'s_collect_record_number=',
     +   (s_collect_record_number(ii),ii=1,l_collect_cnt)
       print*,'s_collect_source_id=',
     +   (s_collect_source_id(ii),ii=1,l_collect_cnt)
       print*,'s_collect_secondary_id=',
     +   (s_collect_secondary_id(ii),ii=1,l_collect_cnt)
       STOP 'get_record_number; snow position'
      ENDIF

        ENDIF
 36     CONTINUE

c       AWND
        jj=7
        i_len=LEN_TRIM(s_awnd_sourceid(i))
c       Act if source_id available
        IF (i_len.GT.0) THEN 
c        Search through all non-ambiguous sources first
         DO j=1,l_collect_cnt    !cycle through short list record numbers
c         Case of non-ambiguous source_id
          IF (TRIM(s_collect_flagambig(j)).EQ.'0') THEN
           IF (TRIM(s_awnd_sourceid(i)).EQ.s_collect_source_id(j)) THEN 
            s_awnd_recordnumber(i)=s_collect_record_number(j)
            i_tripflag(jj)=1
            GOTO 37
           ENDIF
          ENDIF
         ENDDO

c        If here then problem
         CALL ambigcase_get_low_record2(s_variable(jj),
     +     s_awnd_sourceid(i),
     +     l_collect_cnt,s_collect_source_id,s_collect_record_number,
     +     s_record_numberchosen,
     +     i_flag_skip)

c        Exit program in case of source_id irregularity
         IF (i_flag_skip.EQ.1) THEN 
          GOTO 100
         ENDIF

         s_awnd_recordnumber(i)=s_record_numberchosen   !blank the record number

      IF (s_shuntflag.EQ.'good') THEN
       print*,'i,s_awnd_sourceid=',i,s_awnd_sourceid(i)
       print*,'l_collect_cnt=',l_collect_cnt
       print*,'l_collect_distinct=',l_collect_distinct
       print*,'s_collect_record_number=',
     +   (s_collect_record_number(ii),ii=1,l_collect_cnt)
       print*,'s_collect_source_id=',
     +   (s_collect_source_id(ii),ii=1,l_collect_cnt)
       print*,'s_collect_secondary_id=',
     +   (s_collect_secondary_id(ii),ii=1,l_collect_cnt)
       STOP 'get_record_number; awnd position'
      ENDIF

        ENDIF
 37     CONTINUE

c       AWDR
        jj=8
        i_len=LEN_TRIM(s_awdr_sourceid(i))
c       Act if source_id available
        IF (i_len.GT.0) THEN 
c        Search through all non-ambiguous sources first
         DO j=1,l_collect_cnt    !cycle through short list record numbers
c         Case of non-ambiguous source_id
          IF (TRIM(s_collect_flagambig(j)).EQ.'0') THEN
           IF (TRIM(s_awdr_sourceid(i)).EQ.s_collect_source_id(j)) THEN 
            s_awdr_recordnumber(i)=s_collect_record_number(j)
            i_tripflag(jj)=1
            GOTO 38
           ENDIF
          ENDIF
         ENDDO

c        If here then problem
         CALL ambigcase_get_low_record2(s_variable(jj),
     +     s_awdr_sourceid(i),
     +     l_collect_cnt,s_collect_source_id,s_collect_record_number,
     +     s_record_numberchosen,
     +     i_flag_skip)

c        Exit program in case of source_id irregularity
         IF (i_flag_skip.EQ.1) THEN 
          GOTO 100
         ENDIF

         s_awdr_recordnumber(i)=s_record_numberchosen   !blank the record number

      IF (s_shuntflag.EQ.'good') THEN
       print*,'i,s_awdr_sourceid=',i,s_awdr_sourceid(i)
       print*,'l_collect_cnt=',l_collect_cnt
       print*,'l_collect_distinct=',l_collect_distinct


       STOP 'get_record_number; awdr position'
      ENDIF

        ENDIF
 38     CONTINUE

c       WESD
        jj=9
        i_len=LEN_TRIM(s_wesd_sourceid(i))
c       Act if source_id available
        IF (i_len.GT.0) THEN 
c        Search through all non-ambiguous sources first
         DO j=1,l_collect_cnt    !cycle through short list record numbers
c         Case of non-ambiguous source_id
          IF (TRIM(s_collect_flagambig(j)).EQ.'0') THEN
           IF (TRIM(s_wesd_sourceid(i)).EQ.s_collect_source_id(j)) THEN 
            s_wesd_recordnumber(i)=s_collect_record_number(j)
            i_tripflag(jj)=1
            GOTO 39
           ENDIF
          ENDIF
         ENDDO

c        If here then problem
         CALL ambigcase_get_low_record2(s_variable(jj),
     +     s_wesd_sourceid(i),
     +     l_collect_cnt,s_collect_source_id,s_collect_record_number,
     +     s_record_numberchosen,
     +     i_flag_skip)

c        Exit program in case of source_id irregularity
         IF (i_flag_skip.EQ.1) THEN 
          GOTO 100
         ENDIF

         s_wesd_recordnumber(i)=s_record_numberchosen   !blank the record number

      IF (s_shuntflag.EQ.'good') THEN
       print*,'i,s_wesd_sourceid=',i,s_wesd_sourceid(i)
       print*,'l_collect_cnt=',l_collect_cnt
       print*,'l_collect_distinct=',l_collect_distinct

       STOP 'get_record_number; wesd position'
      ENDIF

        ENDIF
 39     CONTINUE

       ENDDO   !close i-loop

c       STOP 'get_record_number; non-unique source id'
      ENDIF     !end condition duplicate stations

 100  CONTINUE            !exit point for irregularity in source_id 165
c************************************************************************
c************************************************************************
c      print*,'just leaving get_record_number2'

c      STOP 'get_record_number2'

      RETURN
      END
