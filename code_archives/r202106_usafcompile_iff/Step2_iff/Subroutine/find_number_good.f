c     Subroutine to count good data
c     AJ_Kettle, 29Jun2019
c     18Mar2019: used for USAF updaate

      SUBROUTINE find_number_good(i_input,
     +   l_rgh_datalines,l_data,l_c1,
     +   i_vec_triplet_index,s_vec_windspeed_ms,
     +   ii_good,ii_bad)

      IMPLICIT NONE
c************************************************************************
c     Declare variables 

      INTEGER             :: i_input
      INTEGER             :: l_rgh_datalines
      INTEGER             :: l_data
      INTEGER             :: l_c1
      INTEGER             :: i_vec_triplet_index(l_rgh_datalines)
      CHARACTER(LEN=l_c1) :: s_vec_windspeed_ms(l_rgh_datalines)
      INTEGER             :: ii_good,ii_bad
c*****
      INTEGER             :: i,j,k,ii,jj,kk
c************************************************************************

       ii_good=0
       ii_bad =0

c      Cycle through data column
       DO j=1,l_data
c       match triplet identifier
        IF (i_input.EQ.i_vec_triplet_index(j)) THEN 
         IF (LEN_TRIM(s_vec_windspeed_ms(j)).GT.0) THEN

c          f_val_max=MAX(f_val_max,s_vec_windspeed_ms(j))
c          f_val_min=MIN(f_val_min,s_vec_windspeed_ms(j))

          ii_good=ii_good+1
         ENDIF
         IF (LEN_TRIM(s_vec_windspeed_ms(j)).EQ.0) THEN 
          ii_bad=ii_bad+1
         ENDIF

        ENDIF
       ENDDO

c       print*,'i...',i,ii_good,ii_bad
      
      RETURN
      END
