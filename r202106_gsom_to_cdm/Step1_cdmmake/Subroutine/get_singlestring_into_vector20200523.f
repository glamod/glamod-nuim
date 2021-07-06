c     Subroutine to get data into vectors 
c     AJ_Kettle, 07Nov2018
c     23May2020: modified to fix problem with overwidth lat/lon/elev

      SUBROUTINE get_singlestring_into_vector20200523(
     +    ii_index,f_ndflag,
     +    l_width_rgh,l_field_rgh,l_rgh_lines,l_rgh_lle,
     +    s_vec_header,i_index_locate_lat,
     +    s_vec_lat,
     +    i_lenmin_lat,
     +    i_lenmax_lat,
     +    f_vec_lat_deg)

      IMPLICIT NONE
c************************************************************************
c     Variables passed into program

      INTEGER             :: ii_index

      REAL                :: f_ndflag

      INTEGER             :: l_width_rgh
      INTEGER             :: l_field_rgh
      INTEGER             :: l_rgh_lines
      INTEGER             :: l_rgh_lle

      CHARACTER(LEN=l_width_rgh)  :: s_vec_header(l_field_rgh)
      INTEGER             :: i_index_locate_lat

      CHARACTER(LEN=*)    :: s_vec_lat(l_rgh_lines)

      INTEGER             :: i_lenmin_lat
      INTEGER             :: i_lenmax_lat

      REAL                :: f_vec_lat_deg(l_rgh_lines)
c*****
c     Variables used within program
      INTEGER             :: i,j,k,ii,jj,kk

      INTEGER             :: i_len
      INTEGER             :: i_thresh
      INTEGER             :: ii_inside

      REAL                :: f_single
c************************************************************************
c      print*,'just entered get_singlestring_into_vector'

      ii_inside=ii_index

c      print*,'i_index_locate_lat=',i_index_locate_lat

      i_thresh=l_rgh_lle

c     Initialize floats with ndflags
      f_vec_lat_deg(ii_index) =f_ndflag

c*****
      ii=i_index_locate_lat
      IF (ii.NE.-999) THEN 
       i_len=LEN_TRIM(s_vec_header(ii))
       IF (i_len.GT.i_thresh) THEN
        print*,'i_len=',i_len
        print*,'l_width_rgh=',l_width_rgh
        print*,'s_vec_header=',ii,s_vec_header(ii)
        STOP 'get_singlestring_into_vector, over i_thresh=12'
       ENDIF 
       i_lenmin_lat=MIN(i_lenmin_lat,i_len)
       i_lenmax_lat=MAX(i_lenmax_lat,i_len)

       s_vec_lat(ii_index)  =s_vec_header(ii)

       f_single=f_ndflag
       IF (i_len.GT.0) THEN 
        READ(s_vec_lat(ii_index),*) f_single
       ENDIF
       f_vec_lat_deg(ii_index)=f_single       
      ENDIF

c      print*,'ii_index=',ii_index
c      print*,'i_lenmin=',i_lenmin_lat
c      print*,'i_lenmax=',i_lenmax_lat
c      print*,'string lat data=',TRIM(s_vec_lat(ii_index))
c      print*,'float lat data=', f_vec_lat_deg(ii_index)
c      print*,'f_ndflag=',f_ndflag
c************************************************************************
c      print*,'just leaving get_singlestring_into_vector'

      RETURN
      END
