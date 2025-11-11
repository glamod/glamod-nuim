c     Subroutine find single vector of stations
c     AJ_Kettle, 22Apr2021

      SUBROUTINE find_single_bigvector20210430(l_rgh_stn,
     +  l_stn2019,s_vec_stnlist2019,l_stn2020,s_vec_stnlist2020,
     +  l_stn2021,s_vec_stnlist2021,
     +  l_run,
     +  s_vec_stnlist_amal,i_mat_stnlist_flag)

      IMPLICIT NONE
c************************************************************************
c     Variables passed into subroutine

      INTEGER             :: l_rgh_stn
      INTEGER             :: l_stn2019
      INTEGER             :: l_stn2020
      INTEGER             :: l_stn2021
      CHARACTER(LEN=32)   :: s_vec_stnlist2019(l_rgh_stn)
      CHARACTER(LEN=32)   :: s_vec_stnlist2020(l_rgh_stn)
      CHARACTER(LEN=32)   :: s_vec_stnlist2021(l_rgh_stn)

      CHARACTER(LEN=32)   :: s_vec_stnlist_amal(l_rgh_stn)
      INTEGER             :: i_mat_stnlist_flag(l_rgh_stn,3)
c*****
c     Variables used within subroutine

      INTEGER             :: i,j,k,ii,jj,kk
      INTEGER             :: io
c*****
      INTEGER             :: l_run
c************************************************************************
      print*,'just entered find_single_bigvector'

c     Initialize station list flag
      DO i=1,l_rgh_stn
       i_mat_stnlist_flag(i,1)=0
       i_mat_stnlist_flag(i,2)=0
       i_mat_stnlist_flag(i,3)=0
      ENDDO

c     Define baseline vector
      DO i=1,l_stn2019
       s_vec_stnlist_amal(i)=s_vec_stnlist2019(i)
       i_mat_stnlist_flag(i,1)=1
      ENDDO

      l_run=l_stn2019

      print*,'l_run=',l_run
c*****
c     Combine file 2 - 2020
      DO i=1,l_stn2020

       DO j=1,l_run
        IF (s_vec_stnlist2020(i).EQ.s_vec_stnlist_amal(j)) THEN 
         i_mat_stnlist_flag(j,2)=1
         GOTO 10
        ENDIF
       ENDDO

c      If here, then must augment master list
       l_run=l_run+1
       s_vec_stnlist_amal(l_run)=s_vec_stnlist2020(i)
       i_mat_stnlist_flag(l_run,2)=1

 10    CONTINUE
      ENDDO

      print*,'l_run=',l_run
c      print*,'st/en=',TRIM(s_vec_stnlist_amal(1)),
c     +  TRIM(s_vec_stnlist_amal(l_run))
c*****
c     Combine file 3 - 2021
      DO i=1,l_stn2021

       DO j=1,l_run
        IF (s_vec_stnlist2021(i).EQ.s_vec_stnlist_amal(j)) THEN 
         i_mat_stnlist_flag(j,3)=1
         GOTO 20
        ENDIF
       ENDDO

c      If here, then must augment master list
       l_run=l_run+1
       s_vec_stnlist_amal(l_run)=s_vec_stnlist2021(i)
       i_mat_stnlist_flag(l_run,3)=1

 20    CONTINUE
      ENDDO

      print*,'l_run=',l_run
c      print*,'st/en=',TRIM(s_vec_stnlist_amal(1)),
c     +  TRIM(s_vec_stnlist_amal(l_run))
c*****
      print*,'just leaving find_single_bigvector'
c      STOP 'find_single_bigvector2'

      RETURN
      END
