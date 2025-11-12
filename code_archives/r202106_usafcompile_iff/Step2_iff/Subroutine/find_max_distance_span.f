c     Subroutine to find maximum distance
c     AJ_Kettle, 28Jun2019
c     16Mar2020: used for uSAF update

      SUBROUTINE find_max_distance_span(l_rgh_datalines,
     +  i_triplediff_cnt,f_triplediff_lat,f_triplediff_lon,
     +  f_max_distance_span_km)

      IMPLICIT NONE
c************************************************************************
c     Variables from outside subroutine
      INTEGER             :: l_rgh_datalines
      INTEGER             :: i_triplediff_cnt
      REAL                :: f_triplediff_lat(l_rgh_datalines)
      REAL                :: f_triplediff_lon(l_rgh_datalines)
      REAL                :: f_max_distance_span_km
c*****
c     Variables used within subroutine

      INTEGER             :: i,j,k,ii,jj,kk
      REAL                :: f_pi

      REAL                :: f_lat_max
      REAL                :: f_lat_min
      REAL                :: f_lon_max
      REAL                :: f_lon_min
c************************************************************************
c      print*,'just inside find_max_distance_span' 

c      print*,'i_triplediff_cnt=',i_triplediff_cnt
c      print*,'l_rgh_datalines=',l_rgh_datalines
c      print*,'f_triplediff_lat=',
c     +  (f_triplediff_lat(i),i=1,i_triplediff_cnt)
c      print*,'f_triplediff_lon=',
c     +  (f_triplediff_lon(i),i=1,i_triplediff_cnt)

      f_pi=3.14159

      f_lat_max=-1000.0
      f_lat_min=+1000.0
      f_lon_max=-1000.0
      f_lon_min=+1000.0
      
      DO i=1,i_triplediff_cnt
       f_lat_max=MAX(f_lat_max,f_triplediff_lat(i))
       f_lat_min=MIN(f_lat_min,f_triplediff_lat(i))

       f_lon_max=MAX(f_lon_max,f_triplediff_lon(i))
       f_lon_min=MIN(f_lon_min,f_triplediff_lon(i))
      ENDDO

      f_max_distance_span_km=SQRT(
     + ((f_lat_max-f_lat_min)*110.0)**2.0+
     + ((f_lon_max-f_lon_min)*110.0*COS(f_lat_min*f_pi/180.0))**2.0)

c      print*,'f_triplediff_lat=',
c     +  (f_triplediff_lat(i),i=1,i_triplediff_cnt)
c      print*,'f_triplediff_lon=',
c     +  (f_triplediff_lon(i),i=1,i_triplediff_cnt)

c      print*,'f_lat_max=',f_lat_max
c      print*,'f_lat_min=',f_lat_min
c      print*,'f_lon_max=',f_lon_max
c      print*,'f_lon_min=',f_lon_min

c      print*,'f_max_distance_span_km=',f_max_distance_span_km

c      print*,'just leaving find_max_distance_span' 

c      STOP 'find_max_distance_span'

      RETURN
      END
