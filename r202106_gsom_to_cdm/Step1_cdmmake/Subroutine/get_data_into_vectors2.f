c     Subroutine to get data into vectors 
c     AJ_Kettle, 07Nov2018

      SUBROUTINE get_data_into_vectors2(ii_index,f_ndflag,
     +    l_width_rgh,l_field_rgh,l_rgh_lines,
     +    s_vec_header,i_index_locate,
     +    s_vec_tmax,s_vec_tmin,s_vec_tavg,
     +    s_vec_prcp,s_vec_snow,s_vec_awnd,
     +    i_lenmin_tmax,i_lenmin_tmin,i_lenmin_tavg,
     +    i_lenmin_prcp,i_lenmin_snow,i_lenmin_awnd,
     +    i_lenmax_tmax,i_lenmax_tmin,i_lenmax_tavg,
     +    i_lenmax_prcp,i_lenmax_snow,i_lenmax_awnd,
     +    f_vec_tmax_c,f_vec_tmin_c,f_vec_tavg_c,
     +    f_vec_prcp_mm,f_vec_snow_mm,f_vec_awnd_ms,
     +    s_vec_tmax_attrib,s_vec_tmin_attrib,s_vec_tavg_attrib,
     +    s_vec_prcp_attrib,s_vec_snow_attrib,s_vec_awnd_attrib)

      IMPLICIT NONE
c************************************************************************
c     Variables passed into program

      INTEGER             :: ii_index

      REAL                :: f_ndflag

      INTEGER             :: l_width_rgh
      INTEGER             :: l_field_rgh
      INTEGER             :: l_rgh_lines

      CHARACTER(LEN=l_width_rgh)  :: s_vec_header(l_field_rgh)
      INTEGER             :: i_index_locate(6)

      CHARACTER(LEN=10)   :: s_vec_tmax(l_rgh_lines)
      CHARACTER(LEN=10)   :: s_vec_tmin(l_rgh_lines)
      CHARACTER(LEN=10)   :: s_vec_tavg(l_rgh_lines)
      CHARACTER(LEN=10)   :: s_vec_prcp(l_rgh_lines)
      CHARACTER(LEN=10)   :: s_vec_snow(l_rgh_lines)
      CHARACTER(LEN=10)   :: s_vec_awnd(l_rgh_lines)

      CHARACTER(LEN=10)   :: s_vec_tmax_attrib(l_rgh_lines)
      CHARACTER(LEN=10)   :: s_vec_tmin_attrib(l_rgh_lines)
      CHARACTER(LEN=10)   :: s_vec_tavg_attrib(l_rgh_lines)
      CHARACTER(LEN=10)   :: s_vec_prcp_attrib(l_rgh_lines)
      CHARACTER(LEN=10)   :: s_vec_snow_attrib(l_rgh_lines)
      CHARACTER(LEN=10)   :: s_vec_awnd_attrib(l_rgh_lines)

      INTEGER             :: i_lenmin_tmax
      INTEGER             :: i_lenmin_tmin
      INTEGER             :: i_lenmin_tavg
      INTEGER             :: i_lenmin_prcp
      INTEGER             :: i_lenmin_snow
      INTEGER             :: i_lenmin_awnd

      INTEGER             :: i_lenmax_tmax
      INTEGER             :: i_lenmax_tmin
      INTEGER             :: i_lenmax_tavg
      INTEGER             :: i_lenmax_prcp
      INTEGER             :: i_lenmax_snow
      INTEGER             :: i_lenmax_awnd

      REAL                :: f_vec_tmax_c(l_rgh_lines)
      REAL                :: f_vec_tmin_c(l_rgh_lines)
      REAL                :: f_vec_tavg_c(l_rgh_lines)
      REAL                :: f_vec_prcp_mm(l_rgh_lines)
      REAL                :: f_vec_snow_mm(l_rgh_lines)
      REAL                :: f_vec_awnd_ms(l_rgh_lines)
c*****
c     Variables used within program
      INTEGER             :: i,j,k,ii,jj,kk

      INTEGER             :: i_len
      INTEGER             :: i_len_attrib
      INTEGER             :: i_thresh
      INTEGER             :: ii_inside

      REAL                :: f_single
c************************************************************************
c      print*,'just entered get_data_into_vectors'

      ii_inside=ii_index

c      print*,'i_index_locate=',(i_index_locate(i),i=1,6)

      i_thresh=10

c     Initialize
      s_vec_tmax(ii_index)=''
      s_vec_tmin(ii_index)=''
      s_vec_tavg(ii_index)=''
      s_vec_prcp(ii_index)=''
      s_vec_snow(ii_index)=''
      s_vec_awnd(ii_index)=''

c     Initialize floats with ndflags
      f_vec_tmax_c(ii_index) =f_ndflag
      f_vec_tmin_c(ii_index) =f_ndflag
      f_vec_tavg_c(ii_index) =f_ndflag
      f_vec_prcp_mm(ii_index)=f_ndflag
      f_vec_snow_mm(ii_index)=f_ndflag
      f_vec_awnd_ms(ii_index)=f_ndflag

      s_vec_tmax_attrib(ii_index)=''
      s_vec_tmin_attrib(ii_index)=''
      s_vec_tavg_attrib(ii_index)=''
      s_vec_prcp_attrib(ii_index)=''
      s_vec_snow_attrib(ii_index)=''
      s_vec_awnd_attrib(ii_index)=''
c*****
c*****
c     TMAX
      ii=i_index_locate(1)
      IF (ii.NE.-999) THEN 
       i_len=LEN_TRIM(s_vec_header(ii))
       IF (i_len.GT.i_thresh) THEN
        STOP 'get_data_into_vectors, over i_thresh'
       ENDIF 
       i_lenmin_tmax=MIN(i_lenmin_tmax,i_len)
       i_lenmax_tmax=MAX(i_lenmax_tmax,i_len)

       i_len_attrib=LEN_TRIM(s_vec_header(ii+1))
       IF (i_len_attrib.GT.i_thresh) THEN
        STOP 'get_data_into_vectors, i_len_attrib over i_thresh'
       ENDIF 

       s_vec_tmax(ii_index)         =s_vec_header(ii)
       s_vec_tmax_attrib(ii_index)  =s_vec_header(ii+1)

c       print*,'ii_index,ii',ii_index,ii
c       print*,'s_vec_tmax=',s_vec_tmax(ii_index)
c       print*,'s_vec_tmax_attrib=',s_vec_tmax_attrib(ii_index)

       f_single=f_ndflag
       IF (i_len.GT.0) THEN 
        READ(s_vec_tmax(ii_index),*) f_single
       ENDIF
       f_vec_tmax_c(ii_index)=f_single       

      ENDIF

c     TMIN
      ii=i_index_locate(2)
      IF (ii.NE.-999) THEN 
       i_len=LEN_TRIM(s_vec_header(ii))
       IF (i_len.GT.i_thresh) THEN
        STOP 'get_data_into_vectors, over i_thresh'
       ENDIF 
       i_lenmin_tmin=MIN(i_lenmin_tmin,i_len)
       i_lenmax_tmin=MAX(i_lenmax_tmin,i_len)

       i_len_attrib=LEN_TRIM(s_vec_header(ii+1))
       IF (i_len_attrib.GT.i_thresh) THEN
        STOP 'get_data_into_vectors, i_len_attrib over i_thresh'
       ENDIF 

       s_vec_tmin(ii_index)         =s_vec_header(ii)
       s_vec_tmin_attrib(ii_index)  =s_vec_header(ii+1)

c       print*,'ii_index,ii',ii_index,ii
c       print*,'s_vec_tmin=',s_vec_tmin(ii_index)
c       print*,'s_vec_tmin_attrib=',s_vec_tmin_attrib(ii_index)

       f_single=f_ndflag
       IF (i_len.GT.0) THEN 
        READ(s_vec_tmin(ii_index),*) f_single
       ENDIF
       f_vec_tmin_c(ii_index)=f_single       

      ENDIF

c     TAVG
      ii=i_index_locate(3)
      IF (ii.NE.-999) THEN 
       i_len=LEN_TRIM(s_vec_header(ii))
       IF (i_len.GT.i_thresh) THEN
        STOP 'get_data_into_vectors, over i_thresh'
       ENDIF 
       i_lenmin_tavg=MIN(i_lenmin_tavg,i_len)
       i_lenmax_tavg=MAX(i_lenmax_tavg,i_len)

       i_len_attrib=LEN_TRIM(s_vec_header(ii+1))
       IF (i_len_attrib.GT.i_thresh) THEN
        STOP 'get_data_into_vectors, i_len_attrib over i_thresh'
       ENDIF 

       s_vec_tavg(ii_index)         =s_vec_header(ii)
       s_vec_tavg_attrib(ii_index)  =s_vec_header(ii+1)

c       print*,'ii_index,ii',ii_index,ii
c       print*,'s_vec_tavg=',s_vec_tavg(ii_index)
c       print*,'s_vec_tavg_attrib=',s_vec_tavg_attrib(ii_index)

       f_single=f_ndflag
       IF (i_len.GT.0) THEN 
        READ(s_vec_tavg(ii_index),*) f_single
       ENDIF
       f_vec_tavg_c(ii_index)=f_single       

      ENDIF

c     PRCP
      ii=i_index_locate(4)
      IF (ii.NE.-999) THEN 
       i_len=LEN_TRIM(s_vec_header(ii))
       IF (i_len.GT.i_thresh) THEN
        STOP 'get_data_into_vectors, over i_thresh'
       ENDIF 
       i_lenmin_prcp=MIN(i_lenmin_prcp,i_len)
       i_lenmax_prcp=MAX(i_lenmax_prcp,i_len)

       i_len_attrib=LEN_TRIM(s_vec_header(ii+1))
       IF (i_len_attrib.GT.i_thresh) THEN
        STOP 'get_data_into_vectors, i_len_attrib over i_thresh'
       ENDIF 

       s_vec_prcp(ii_index)        =s_vec_header(ii)
       s_vec_prcp_attrib(ii_index) =s_vec_header(ii+1)

       f_single=f_ndflag
       IF (i_len.GT.0) THEN 
        READ(s_vec_prcp(ii_index),*) f_single
       ENDIF
       f_vec_prcp_mm(ii_index)=f_single       

      ENDIF

c     SNOW
      ii=i_index_locate(5)
      IF (ii.NE.-999) THEN 
       i_len=LEN_TRIM(s_vec_header(ii))
       IF (i_len.GT.i_thresh) THEN
        STOP 'get_data_into_vectors, over i_thresh'
       ENDIF 
       i_lenmin_snow=MIN(i_lenmin_snow,i_len)
       i_lenmax_snow=MAX(i_lenmax_snow,i_len)

       i_len_attrib=LEN_TRIM(s_vec_header(ii+1))
       IF (i_len_attrib.GT.i_thresh) THEN
        STOP 'get_data_into_vectors, i_len_attrib over i_thresh'
       ENDIF 

       s_vec_snow(ii_index)        =s_vec_header(ii)
       s_vec_snow_attrib(ii_index) =s_vec_header(ii+1)

       f_single=f_ndflag
       IF (i_len.GT.0) THEN 
        READ(s_vec_snow(ii_index),*) f_single
       ENDIF
       f_vec_snow_mm(ii_index)=f_single       
      ENDIF

c     AWND
      ii=i_index_locate(6)
      IF (ii.NE.-999) THEN 
       i_len=LEN_TRIM(s_vec_header(ii))
       IF (i_len.GT.i_thresh) THEN
        STOP 'get_data_into_vectors, over i_thresh'
       ENDIF 
       i_lenmin_awnd=MIN(i_lenmin_awnd,i_len)
       i_lenmax_awnd=MAX(i_lenmax_awnd,i_len)

       i_len_attrib=LEN_TRIM(s_vec_header(ii+1))
       IF (i_len_attrib.GT.i_thresh) THEN
        STOP 'get_data_into_vectors, i_len_attrib over i_thresh'
       ENDIF 

       s_vec_awnd(ii_index)        =s_vec_header(ii)
       s_vec_awnd_attrib(ii_index) =s_vec_header(ii+1)

       f_single=f_ndflag
       IF (i_len.GT.0) THEN 
        READ(s_vec_awnd(ii_index),*) f_single
       ENDIF
       f_vec_awnd_ms(ii_index)=f_single       
      ENDIF

c      print*,'ii_index=',ii_index
c      print*,'i_lenmin=',
c     +  i_lenmin_tmax,i_lenmin_tmin,i_lenmin_tavg,
c     +  i_lenmin_prcp,i_lenmin_snow,i_lenmin_awnd
c      print*,'i_lenmax=',
c     +  i_lenmax_tmax,i_lenmax_tmin,i_lenmax_tavg,
c     +  i_lenmax_prcp,i_lenmax_snow,i_lenmax_awnd

c      print*,'tmax data=',TRIM(s_vec_tmax(ii_index))
c      print*,'tmin data=',TRIM(s_vec_tmin(ii_index))
c      print*,'tavg data=',TRIM(s_vec_tavg(ii_index))
c      print*,'prcp data=',TRIM(s_vec_prcp(ii_index))
c      print*,'snow data=',TRIM(s_vec_snow(ii_index))
c      print*,'awnd data=',TRIM(s_vec_awnd(ii_index))

c      print*,'tmax data=',f_vec_tmax_c(ii_index)
c      print*,'tmin data=',f_vec_tmin_c(ii_index)
c      print*,'tavg data=',f_vec_tavg_c(ii_index)
c      print*,'prcp data=',f_vec_prcp_mm(ii_index)
c      print*,'snow data=',f_vec_snow_mm(ii_index)
c      print*,'awnd data=',f_vec_awnd_ms(ii_index)

c      print*,'i_index_locate=',(i_index_locate(i),i=1,6)
c      print*,'f_ndflag=',f_ndflag
c************************************************************************
c      print*,'just leaving get_data_into_vectors'

      RETURN
      END
