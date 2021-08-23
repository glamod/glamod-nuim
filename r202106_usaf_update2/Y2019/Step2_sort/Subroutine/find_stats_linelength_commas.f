c     Subroutine to find line lengths & number of commas
c     AJ_Kettle, 18Feb2019
c     24Feb2020: used in USAF update procedure

      SUBROUTINE find_stats_linelength_commas(
     +  l_rgh_char,l_rgh_datalines,jj2a,s_linsto2,
     +  i_linelength_min,i_linelength_max,
     +  i_commacount_min,i_commacount_max)

      IMPLICIT NONE
c************************************************************************
c     Declare variables 

      INTEGER             :: l_rgh_char
      INTEGER             :: l_rgh_datalines
      INTEGER             :: jj2a
      CHARACTER(LEN=l_rgh_char) :: s_linsto2(l_rgh_datalines)
c      CHARACTER(LEN=*)    :: s_linsto2(l_rgh_datalines)
      INTEGER             :: i_linelength_min,i_linelength_max
      INTEGER             :: i_commacount_min,i_commacount_max
c*****
c     Variables use within subroutine

      INTEGER             :: i,j,k,ii,jj,kk
      INTEGER             :: i_len

      CHARACTER(LEN=l_rgh_char) :: s_linget
      CHARACTER(LEN=1)    :: s_single

      INTEGER             :: i_commacnt

c************************************************************************
c      print*,'just inside find_stats_linelength_commas'

c     Initialize min/max counters
      i_linelength_min=1000
      i_linelength_max=-1000
      i_commacount_min=1000
      i_commacount_max=-1000

c     cycle through assembles lines
      DO i=1,jj2a
       s_linget=s_linsto2(i)

c      Find line length stats
       i_len=LEN_TRIM(s_linget)
       i_linelength_min=MIN(i_linelength_min,i_len)
       i_linelength_max=MAX(i_linelength_max,i_len)

c      Count commas
       i_commacnt=0
       DO j=1,i_len
        s_single=s_linget(j:j)
        IF (s_single.EQ.',') THEN 
         i_commacnt=i_commacnt+1
        ENDIF
       ENDDO

       i_commacount_min=MIN(i_commacount_min,i_commacnt)
       i_commacount_max=MAX(i_commacount_max,i_commacnt)

      ENDDO

c      print*,'linelength min/max',i_linelength_min,i_linelength_max
c      print*,'commacount min/max',i_commacount_min,i_commacount_max

c      print*,'just leaving find_stats_linelength_commas'

      RETURN
      END
