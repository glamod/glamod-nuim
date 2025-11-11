c     Subroutine to get data into vectors 
c     AJ_Kettle, 07Nov2018

      SUBROUTINE get_date_into_vector(ii_index,
     +    l_width_rgh,l_field_rgh,l_rgh_lines,
     +    s_vec_header,i_index_locate_date,
     +    s_vec_date,
     +    i_lenmin_date,
     +    i_lenmax_date)

      IMPLICIT NONE
c************************************************************************
c     Variables passed into program

      INTEGER             :: ii_index

      REAL                :: f_ndflag

      INTEGER             :: l_width_rgh
      INTEGER             :: l_field_rgh
      INTEGER             :: l_rgh_lines

      CHARACTER(LEN=l_width_rgh)  :: s_vec_header(l_field_rgh)
      INTEGER             :: i_index_locate_date

      CHARACTER(LEN=*)    :: s_vec_date(l_rgh_lines)

      INTEGER             :: i_lenmin_date
      INTEGER             :: i_lenmax_date
c*****
c     Variables used within program
      INTEGER             :: i,j,k,ii,jj,kk

      INTEGER             :: i_len
      INTEGER             :: i_thresh
      INTEGER             :: ii_inside

      REAL                :: f_single
c************************************************************************
c      print*,'just entered get_date_into_vector'

c      ii_inside=ii_index

      i_thresh=8

c*****
      ii=i_index_locate_date
      IF (ii.NE.-999) THEN 
       i_len=LEN_TRIM(s_vec_header(ii))
       IF (i_len.GT.i_thresh) THEN
        STOP 'get_date_into_vector, over i_thresh=8'
       ENDIF 
       i_lenmin_date=MIN(i_lenmin_date,i_len)
       i_lenmax_date=MAX(i_lenmax_date,i_len)

       s_vec_date(ii_index)  =s_vec_header(ii)
  
      ENDIF

c      print*,'ii_index=',ii_index
c      print*,'i_lenmin=',i_lenmin_date
c      print*,'i_lenmax=',i_lenmax_date
c      print*,'string date data=',TRIM(s_vec_date(ii_index))

c************************************************************************
c      print*,'just leaving get_date_into_vector'
c      print*,'call sleep(2)'
c      call sleep(2)

      RETURN
      END
