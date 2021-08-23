c     Subroutine to find key stats for 1 variable
c     AJ_Kettle, 28Aug2019
c     17Mar2020: used for the USAF update

      SUBROUTINE get_key_stats_singlevar(i_label,
     +   l_c1,l_c2,l_rgh_datalines,l_data,
     +   i_triplediff_cnt, 
     +   s_vec_windspeed_ms,s_vec_windspeed_qc,
     +   s_vec_date_dd_mm_yyyy,s_vec_time_hh_mm_ss,
     +   i_vec_triplet_index,

     +   i_triplet_datacnt_good,i_triplet_datacnt_bad,
     +   s_triplet_st_year,s_triplet_en_year)  

      IMPLICIT NONE
c************************************************************************
c     Declare variables 

      INTEGER             :: i_label

      INTEGER             :: l_c1,l_c2
      INTEGER             :: l_rgh_datalines
      INTEGER             :: l_data

      INTEGER             :: i_triplediff_cnt

      CHARACTER(LEN=l_c1) :: s_vec_windspeed_ms(l_rgh_datalines)
      CHARACTER(LEN=l_c2) :: s_vec_windspeed_qc(l_rgh_datalines)
      CHARACTER(LEN=10)   :: s_vec_date_dd_mm_yyyy(l_rgh_datalines) 
      CHARACTER(LEN=8)    :: s_vec_time_hh_mm_ss(l_rgh_datalines)

      INTEGER             :: i_vec_triplet_index(l_rgh_datalines) 

c     Assembled triplet information
      INTEGER             :: i_triplet_datacnt_good(l_rgh_datalines)
      INTEGER             :: i_triplet_datacnt_bad(l_rgh_datalines)
      CHARACTER(LEN=4)    :: s_triplet_st_year(l_rgh_datalines)
      CHARACTER(LEN=4)    :: s_triplet_en_year(l_rgh_datalines)

c*****
c     Variables used within subroutine

      INTEGER             :: i,j,k,ii,jj,kk

c     single values returned for each triplet index
      INTEGER             :: i_cnt_good
      INTEGER             :: i_cnt_bad
      CHARACTER(LEN=10)   :: s_st_date_dd_mm_yyyy 
      CHARACTER(LEN=8)    :: s_st_time_hh_mm_ss
      CHARACTER(LEN=10)   :: s_en_date_dd_mm_yyyy 
      CHARACTER(LEN=8)    :: s_en_time_hh_mm_ss

      INTEGER             :: i_vec_len_data(l_rgh_datalines)  !data info

      INTEGER             :: i_triplet_igood_st(l_rgh_datalines) !triplet info
      INTEGER             :: i_triplet_igood_en(l_rgh_datalines)

c      CHARACTER(LEN=4)    :: s_triplet_st_year(l_rgh_datalines)
c      CHARACTER(LEN=4)    :: s_triplet_en_year(l_rgh_datalines)

      INTEGER             :: i_st_flag

      INTEGER             :: i_max
      INTEGER             :: i_min
      INTEGER             :: i_len

      INTEGER             :: i_index_firstdata
      INTEGER             :: i_index_lastdata
c************************************************************************
c      print*,'just entered get_key_stats_singlevar'

c      print*,'i_label=',i_label

c      print*,'l_c1,l_c2=',l_c1,l_c2

c      print*,'l_rgh_datalines=',l_rgh_datalines
c      print*,'l_data=',l_data
c      print*,'i_triplediff_cnt=',i_triplediff_cnt
c      print*,'i_vec_triplet_index',
c     +  (i_vec_triplet_index(j),j=1,10)

c     Check min/max of i_vec_triplet_index
c      i_max=-1000
c      i_min=+1000
c      DO i=1,l_data
c       i_max=MAX(i_max,i_vec_triplet_index(i))
c       i_min=MIN(i_min,i_vec_triplet_index(i))
c      ENDDO
c      print*,'i_vec_triplet_index: i_min,i_max=',i_min,i_max

c     Check min/max date
c      i_max=-1000
c      i_min=+1000
c      DO i=1,l_data
c       i_len=LEN_TRIM(s_vec_date_dd_mm_yyyy(i))
c       i_max=MAX(i_max,i_len)
c       i_min=MIN(i_min,i_len)
c      ENDDO
c      print*,'s_vec_date_dd_mm_yyyy: i_min,i_max=',i_min,i_max

c     Check min/max time
c      i_max=-1000
c      i_min=+1000
c      DO i=1,l_data
c       i_len=LEN_TRIM(s_vec_time_hh_mm_ss(i))
c       i_max=MAX(i_max,i_len)
c       i_min=MIN(i_min,i_len)
c      ENDDO
c      print*,'s_vec_time_hh_mm_ss: i_min,i_max=',i_min,i_max

c      print*,'s_vec_windspeed_ms=',(s_vec_windspeed_ms(i),i=1,10)
c      print*,'s_vec_windspeed_qc=',(s_vec_windspeed_qc(i),i=1,10)
c      print*,'s_vec_date_dd_mm_yyyy=',(s_vec_date_dd_mm_yyyy(i),i=1,10) 
c      print*,'s_vec_time_hh_mm_ss=',(s_vec_time_hh_mm_ss(i),i=1,10)

c     Find length of elements in data vector
      i_max=-1000
      i_min=+1000
      DO i=1,l_data
       i_vec_len_data(i)=LEN_TRIM(s_vec_windspeed_ms(i))

       i_max=MAX(i_max,i_vec_len_data(i))
       i_min=MIN(i_min,i_vec_len_data(i))
      ENDDO

c      print*,'i_vec_len_data=',(i_vec_len_data(i),i=1,10)
c      print*,'i_vec_len_data: i_min,i_max=',i_min,i_max
c*****
c     Cycle through all triplet elements

      DO i=1,i_triplediff_cnt   !cycle through different triplets

cc      Sequence to find start/end date for each triplet & data counts
c       print*,'i=',i

       i_st_flag=0
c       print*,'i_st_flag=',i_st_flag

c      Initialize variables
       i_cnt_good=0
       i_cnt_bad =0

c       print*,'i_cnt_good,i_cnt_bad=',i_cnt_good,i_cnt_bad
c       print*,'just before j-loop',l_data

c      cycle through all data in one file
       DO j=1,l_data
         
c        IF (j.EQ.1) THEN
c         print*,'j=',j,i_vec_triplet_index(j),i_vec_len_data(j)
c        ENDIF

c        IF (i_label.EQ.3) THEN
c         IF (MOD(j,10).EQ.0) THEN
c          print*,'i,j=',i,j,i_vec_triplet_index(j),i_vec_len_data(j)
c         ENDIF
c        ENDIF

c       Compare triplet id numbers
        IF (i.EQ.i_vec_triplet_index(j)) THEN 

c        Act if data present
         IF (i_vec_len_data(j).GT.0) THEN

c         Get starting information
          IF (i_st_flag.EQ.0) THEN
           i_st_flag=1
c           s_st_date_dd_mm_yyyy=(s_vec_date_dd_mm_yyyy(j))
c           s_st_time_hh_mm_ss  =(s_vec_time_hh_mm_ss(j))

           i_index_firstdata=j
          ENDIF

c         Update end point continuously until end
c          s_en_date_dd_mm_yyyy=(s_vec_date_dd_mm_yyyy(j))
c          s_en_time_hh_mm_ss  =(s_vec_time_hh_mm_ss(j))
          i_index_lastdata=j

          i_cnt_good=i_cnt_good+1
         ENDIF

c        Condition for bad counter
         IF (i_vec_len_data(j).EQ.0) THEN
          i_cnt_bad=i_cnt_bad+1
         ENDIF
        ENDIF    !i_vec_triplet_index_condition

       ENDDO     !end j-index

c       print*,'just cleared j-loop'
c       print*,'i=',i,i_cnt_good,i_cnt_bad
c       print*,'i_index_firstdata=',i_index_firstdata
c       print*,'i_index_lastdata=',i_index_lastdata

c       print*,'i=',i,i_cnt_good,i_cnt_bad
c       print*,'i_index_firstdata=',i_index_firstdata
c       print*,'i_index_lastdata=',i_index_lastdata

c       print*,'simple date list=',(s_vec_date_dd_mm_yyyy(ii),ii=1,10)

c       print*,'st date=',s_st_date_dd_mm_yyyy
c       print*,'en date=',s_en_date_dd_mm_yyyy

c       print*,'i=',i

c      Archive information
       i_triplet_datacnt_good(i)=i_cnt_good
       i_triplet_datacnt_bad(i) =i_cnt_bad

c       print*,'cleared archive datacnt',i_cnt_good,i_cnt_bad

       IF (i_cnt_good.GT.0) THEN
        s_st_date_dd_mm_yyyy=(s_vec_date_dd_mm_yyyy(i_index_firstdata))
        s_en_date_dd_mm_yyyy=(s_vec_date_dd_mm_yyyy(i_index_lastdata))

        s_triplet_st_year(i)=s_st_date_dd_mm_yyyy(7:10)
        s_triplet_en_year(i)=s_en_date_dd_mm_yyyy(7:10)
       ENDIF

c       print*,'end of i-loop'

      ENDDO    !end i-index

c      print*,'just leaving get_key_stats_singlevar'

      RETURN
      END
