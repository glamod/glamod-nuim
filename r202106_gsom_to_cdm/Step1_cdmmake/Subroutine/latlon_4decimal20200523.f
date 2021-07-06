c     Subroutine to make 4 decimal place strings for lat-lon
c     AJ_Kettle, 15Nov2018
c     23May2020: converted s_vec_latlon from fiexed 12 width to slave

      SUBROUTINE latlon_4decimal20200523(l_rgh_lines,l_lines,
     +    s_vec_lat,s_vec_lon,f_vec_lat_deg,f_vec_lon_deg,

     +    s_vec_lat_4dec,s_vec_lon_4dec)

      IMPLICIT NONE
c************************************************************************
c     Variables passed into program

      INTEGER             :: l_rgh_lines
      INTEGER             :: l_lines
      CHARACTER(LEN=*)    :: s_vec_lat(l_rgh_lines)
      CHARACTER(LEN=*)    :: s_vec_lon(l_rgh_lines)
      REAL                :: f_vec_lat_deg(l_rgh_lines)
      REAL                :: f_vec_lon_deg(l_rgh_lines)

      CHARACTER(LEN=*)    :: s_vec_lat_4dec(l_rgh_lines)
      CHARACTER(LEN=*)    :: s_vec_lon_4dec(l_rgh_lines)
c*****
c     Variables used within program

      INTEGER             :: i,j,k,ii,jj,kk

      INTEGER             :: i_len

      CHARACTER(LEN=20)   :: s_single

      INTEGER             :: i_dec_lat(l_rgh_lines)
      INTEGER             :: i_dec_lon(l_rgh_lines)

      INTEGER             :: i_dec_lat_min
      INTEGER             :: i_dec_lon_min
c************************************************************************
c      print*,'just entered latlon_4decimal'

c      print*,'s_vec_lat=',(s_vec_lat(i),i=1,l_lines)
c      print*,'s_vec_lon=',(s_vec_lon(i),i=1,l_lines)

c     convert float to 12-place string
      DO i=1,l_lines
       WRITE(s_vec_lat_4dec(i),'(f12.4)') f_vec_lat_deg(i) 
       WRITE(s_vec_lon_4dec(i),'(f12.4)') f_vec_lon_deg(i) 
      ENDDO
c*****
c     Find number of decimal places
      DO i=1,l_lines
       s_single=TRIM(s_vec_lat(i))
       i_len=LEN_TRIM(s_single)
       DO j=1,i_len
        IF (s_single(j:j).EQ.'.') THEN
         i_dec_lat(i)=i_len-j
         GOTO 10
        ENDIF
       ENDDO
 10    CONTINUE
      ENDDO

      DO i=1,l_lines
       s_single=TRIM(s_vec_lon(i))
       i_len=LEN_TRIM(s_single)
       DO j=1,i_len
        IF (s_single(j:j).EQ.'.') THEN
         i_dec_lon(i)=i_len-j
         GOTO 20
        ENDIF
       ENDDO
 20    CONTINUE
      ENDDO
c*****
c     Find minimum number of decimal places
      i_dec_lat_min=10
      i_dec_lon_min=10

      DO i=1,l_lines 
       i_dec_lat_min=MIN(i_dec_lat_min,i_dec_lat(i))
       i_dec_lon_min=MIN(i_dec_lon_min,i_dec_lon(i))
      ENDDO
c*****
c      print*,'s_vec_lat_4dec=',(s_vec_lat_4dec(i),i=1,l_lines)
c      print*,'s_vec_lon_4dec=',(s_vec_lon_4dec(i),i=1,l_lines)
c      print*,'i_dec_lat=',(i_dec_lat(i),i=1,l_lines)
c      print*,'i_dec_lon=',(i_dec_lon(i),i=1,l_lines)

      IF (i_dec_lat_min.LT.4) THEN 
       print*,'i_dec_lat_min=',i_dec_lat_min
c       STOP 'latlon_4decimal; i_dec_lat_min<4'
      ENDIF
      IF (i_dec_lon_min.LT.4) THEN 
       print*,'i_dec_lon_min=',i_dec_lon_min
c       STOP 'latlon_4decimal; i_dec_lon_min<4'
      ENDIF
c************************************************************************
c      print*,'just leaving latlon_4decimal'

c      STOP 'latlon_4decimal'

      RETURN
      END
