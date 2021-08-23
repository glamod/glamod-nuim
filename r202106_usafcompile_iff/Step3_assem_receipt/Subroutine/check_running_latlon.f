c     Subroutine to output extremes of latlon
c     AJ_Kettle, 13Sep2019
c     27Mar2020: used for USAF update

      SUBROUTINE check_running_latlon(
     +   f_min_lon,f_max_lon,f_min_lat,f_max_lat,
     +   l_cnt_rgh,l_cnt_triplet,s_vec_latitude,s_vec_longitude)

      IMPLICIT NONE
c************************************************************************
      REAL                :: f_min_lon,f_max_lon,f_min_lat,f_max_lat
      INTEGER             :: l_cnt_rgh
      INTEGER             :: l_cnt_triplet
      CHARACTER(LEN=9)    :: s_vec_latitude(l_cnt_rgh)
      CHARACTER(LEN=9)    :: s_vec_longitude(l_cnt_rgh)
c*****
c     Variables used withi subroutine

      INTEGER             :: i,j,k,ii,jj,kk

      REAL                :: f_lat,f_lon
c************************************************************************
c      print*,'just entered check_running_latlon'

      print*,'l_cnt_rgh,l_cnt_triplet=',l_cnt_rgh,l_cnt_triplet

      print*,'lat list=',(s_vec_latitude(i),i=1,l_cnt_triplet)      
      print*,'lon list=',(s_vec_longitude(i),i=1,l_cnt_triplet) 

      DO i=1,l_cnt_triplet
       READ(s_vec_latitude(i),'(f10.5)') f_lat
       READ(s_vec_longitude(i),'(f10.5)') f_lon
c       print*,'i=',i,f_lat,f_lon

       f_min_lon=MIN(f_min_lon,f_lon)
       f_max_lon=MAX(f_max_lon,f_lon)
       f_min_lat=MIN(f_min_lat,f_lat)
       f_max_lat=MAX(f_max_lat,f_lat)
      ENDDO

      print*,'f_min_lon...=',f_min_lon,f_max_lon,f_min_lat,f_max_lat

c      print*,'just leaving check_running_latlon'

      RETURN
      END
