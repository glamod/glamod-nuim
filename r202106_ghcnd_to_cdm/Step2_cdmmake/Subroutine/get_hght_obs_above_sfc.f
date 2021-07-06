c     Subroutine to define height obs above surface
c     AJ_Kettle, 11Nov2019

      SUBROUTINE get_hght_obs_above_sfc(l_channel,
     +  s_vec_hgt_obs_above_sfc)

      IMPLICIT NONE
c************************************************************************
c     Declare variables passed into subroutine

      INTEGER             :: l_channel

      CHARACTER(LEN=10)   :: s_vec_hgt_obs_above_sfc(l_channel)
c*****
c     Variables used in subroutine

      INTEGER             :: i,j,k,ii,jj,kk
c************************************************************************
c      print*,'just entered get_hght_obs_above_sfc'

      s_vec_hgt_obs_above_sfc(1)='1'   !prcp
      s_vec_hgt_obs_above_sfc(2)='2'   !tmin
      s_vec_hgt_obs_above_sfc(3)='2'   !tmax
      s_vec_hgt_obs_above_sfc(4)='2'   !tavg
      s_vec_hgt_obs_above_sfc(5)='0'   !snwd
      s_vec_hgt_obs_above_sfc(6)='0'   !snow
      s_vec_hgt_obs_above_sfc(7)='10'  !awnd
      s_vec_hgt_obs_above_sfc(8)='10'  !awdr
      s_vec_hgt_obs_above_sfc(9)='0'   !wesd

c      print*,'s_vec_hgt_obs_above_sfc=',s_vec_hgt_obs_above_sfc
c      print*,'just leaving get_hght_obs_above_sfc'
c      STOP 'get_hght_obs_above_sfc'

      RETURN
      END
