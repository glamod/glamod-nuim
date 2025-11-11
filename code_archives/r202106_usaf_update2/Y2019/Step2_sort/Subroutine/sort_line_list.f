c     Subroutine to sort line list
c     AJ_Kettle, 21Feb2019

      SUBROUTINE sort_line_list(l_rgh_char,l_rgh_datalines,
     +   l_datalines,s_linsto_unsort,

     +   s_linsto_sort,
     +   s_ncdc_ob_time_st,s_ncdc_ob_time_en,
     +   i_linelength_min_unsort,i_linelength_max_unsort,
     +   i_commacount_min_unsort,i_commacount_max_unsort,
     +   i_linelength_min_sort,i_linelength_max_sort,
     +   i_commacount_min_sort,i_commacount_max_sort)

      IMPLICIT NONE
c************************************************************************
c     Variables passed into subroutine

      INTEGER             :: l_rgh_char
      INTEGER             :: l_rgh_datalines
      INTEGER             :: l_datalines
      CHARACTER(LEN=l_rgh_char) :: s_linsto_unsort(l_rgh_datalines)
      CHARACTER(LEN=l_rgh_char) :: s_linsto_sort(l_rgh_datalines)

      CHARACTER(LEN=14)   :: s_ncdc_ob_time_st
      CHARACTER(LEN=14)   :: s_ncdc_ob_time_en
c*****
c     Variables used in subroutine
      INTEGER             :: i,j,k,ii,jj,kk

      CHARACTER(LEN=l_rgh_char) :: s_linget

      INTEGER             :: i_len
      INTEGER             :: i_comma_cnt
      INTEGER             :: i_comma_pos(200)
      INTEGER             :: i_field_cnt

      CHARACTER(LEN=14)   :: s_ncdc_ob_time_single 
      CHARACTER(LEN=14)   :: s_ncdc_ob_time(l_rgh_datalines)

      CHARACTER(LEN=10)   :: s_date_ddxmmxyyyy
      CHARACTER(LEN=8)    :: s_time_hhxmmxss

      DOUBLE PRECISION    :: d_julday_unsort(l_rgh_datalines)
      DOUBLE PRECISION    :: d_julday_sort(l_rgh_datalines)
      DOUBLE PRECISION    :: d_jday

      INTEGER             :: i_sort(l_rgh_datalines)

      CHARACTER(LEN=14)   :: s_ncdc_ob_time_sort(l_rgh_datalines)

      INTEGER             :: i_linelength_min_unsort
      INTEGER             :: i_linelength_max_unsort
      INTEGER             :: i_commacount_min_unsort
      INTEGER             :: i_commacount_max_unsort

      INTEGER             :: i_linelength_min_sort
      INTEGER             :: i_linelength_max_sort
      INTEGER             :: i_commacount_min_sort
      INTEGER             :: i_commacount_max_sort
c************************************************************************
c      print*,'just entered sort_line_list'

c      print*,'l_datalines=',l_datalines

c     Cycle through lines 
      DO i=1,l_datalines

       s_linget=s_linsto_unsort(i)
       i_len=LEN_TRIM(s_linget)      !find length of line

c      Sequence to find commas
       i_comma_cnt=1
       DO j=1,i_len  
        IF (s_linget(j:j) .EQ. ',') THEN
         i_comma_pos(i_comma_cnt)=j
         i_comma_cnt=i_comma_cnt+1         
        ENDIF
       ENDDO
       i_comma_cnt=i_comma_cnt-1
       i_field_cnt=i_comma_cnt+1

       s_ncdc_ob_time_single=
     +   s_linget(i_comma_pos(2)+1:i_comma_pos(3)-1)

       s_ncdc_ob_time(i)=s_ncdc_ob_time_single

c      Get date/time components single element
       CALL std_datetime_fmt2(s_ncdc_ob_time_single,
     +   s_date_ddxmmxyyyy,s_time_hhxmmxss)

c      Find julian time
       call str_to_dt_pvwave3(d_jday,
     +   s_date_ddxmmxyyyy,s_time_hhxmmxss,2,-1)

       d_julday_unsort(i)=d_jday

      ENDDO
c************************************************************************
c     Sort double_precision array
      CALL sort_doublelist_pvwave2( 
     +  l_datalines,d_julday_unsort,i_sort)

c      print*,'cleared sort_doublelist_pvwave2'

c     Arrange lines in ascending order
      DO i=1,l_datalines 
       s_linsto_sort(i)=s_linsto_unsort(i_sort(i))
       d_julday_sort(i)=d_julday_unsort(i_sort(i))

       s_ncdc_ob_time_sort(i)=s_ncdc_ob_time(i_sort(i))
      ENDDO

      s_ncdc_ob_time_st=s_ncdc_ob_time_sort(1)
      s_ncdc_ob_time_en=s_ncdc_ob_time_sort(l_datalines)
c************************************************************************
c     Find statistics of lines in station
      CALL find_stats_linelength_commas(
     +  l_rgh_char,l_rgh_datalines,l_datalines,s_linsto_unsort,

     +  i_linelength_min_unsort,i_linelength_max_unsort,
     +  i_commacount_min_unsort,i_commacount_max_unsort)

      CALL find_stats_linelength_commas(
     +  l_rgh_char,l_rgh_datalines,l_datalines,s_linsto_sort,

     +  i_linelength_min_sort,i_linelength_max_sort,
     +  i_commacount_min_sort,i_commacount_max_sort)

c      print*,'i_linelength_min unsort',
c     +  i_linelength_min_unsort,i_linelength_max_unsort,
c     +  i_commacount_min_unsort,i_commacount_max_unsort
c      print*,'i_linelength_min sort',
c     +  i_linelength_min_sort,i_linelength_max_sort,
c     +  i_commacount_min_sort,i_commacount_max_sort
c************************************************************************
c************************************************************************
c      print*,'just leaving sort_line_list'

c      STOP 'sort_line_list'

      RETURN
      END
