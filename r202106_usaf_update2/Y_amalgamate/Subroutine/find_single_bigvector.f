c     Subroutine find single vector of stations
c     AJ_Kettle, 22Apr2021

      SUBROUTINE find_single_bigvector(l_rgh_stn,
     +  l_stn2019,s_vec_stnlist2019,l_stn2020,s_vec_stnlist2020,
     +  l_stn2021,s_vec_stnlist2021,
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

c************************************************************************
      print*,'just entered find_single_bigvector'


      print*,'just leaving find_single_bigvector'

      RETURN
      END
