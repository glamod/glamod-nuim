c     Subroutine to assemble all data lines for 1 file
c     AJ_Kettle, 14Nov2018
c     36 variables input
c     19Sep2019: subroutine used for Sept2019 release
c     23Sep2019: single line lengths for header & data lines from 2000 to 4000
c     23May2020: replaced fixed array widths with slave declarations

      SUBROUTINE get_gsom_datalines20200523(s_pathandname,
     +    l_varselect,s_varselect,
     +    f_ndflag, 
     +    l_rgh_lines,

     +    l_lines,
     +    l_rgh_lle,
     +    s_vec_date,s_vec_lat,s_vec_lon,s_vec_elev,
     +    f_vec_lat_deg,f_vec_lon_deg,f_vec_elev_m,
     +    f_vec_tmax_c,f_vec_tmin_c,f_vec_tavg_c,
     +    f_vec_prcp_mm,f_vec_snow_mm,f_vec_awnd_ms,
     +    s_vec_tmax,s_vec_tmin,s_vec_tavg,
     +    s_vec_prcp,s_vec_snow,s_vec_awnd,
     +    s_vec_tmax_attrib,s_vec_tmin_attrib,s_vec_tavg_attrib,
     +    s_vec_prcp_attrib,s_vec_snow_attrib,s_vec_awnd_attrib,
     +    i_len_header,
     +    i_linelength_max,i_linelength_min,l_field)

c     Variables used in subroutine
c     -field_extractor_gen
c     -find_variable_indices
c     -find_variable_index_single
c     -field_extractor_quot
c     -get_data_into_vectors2
c     -get_date_into_vector
c     -get_singlestring_into_vector

      IMPLICIT NONE
c************************************************************************
      CHARACTER(LEN=300)  :: s_pathandname

      CHARACTER(LEN=4)    :: s_varselect(6)
      INTEGER             :: l_varselect

      REAL                :: f_ndflag

      INTEGER             :: l_rgh_lines      !number data lines for 1 stn
      INTEGER             :: l_lines
      INTEGER             :: l_rgh_lle

      CHARACTER(LEN=*)    :: s_vec_date(l_rgh_lines)    !8
      CHARACTER(LEN=*)    :: s_vec_lat(l_rgh_lines)     !12
      CHARACTER(LEN=*)    :: s_vec_lon(l_rgh_lines)     !12
      CHARACTER(LEN=*)    :: s_vec_elev(l_rgh_lines)    !12

      REAL                :: f_vec_lat_deg(l_rgh_lines)
      REAL                :: f_vec_lon_deg(l_rgh_lines)
      REAL                :: f_vec_elev_m(l_rgh_lines)

      REAL                :: f_vec_tmax_c(l_rgh_lines)
      REAL                :: f_vec_tmin_c(l_rgh_lines)
      REAL                :: f_vec_tavg_c(l_rgh_lines)
      REAL                :: f_vec_prcp_mm(l_rgh_lines)
      REAL                :: f_vec_snow_mm(l_rgh_lines)
      REAL                :: f_vec_awnd_ms(l_rgh_lines)

      CHARACTER(LEN=*)    :: s_vec_tmax(l_rgh_lines)        !10
      CHARACTER(LEN=*)    :: s_vec_tmin(l_rgh_lines)        !10
      CHARACTER(LEN=*)    :: s_vec_tavg(l_rgh_lines)        !10
      CHARACTER(LEN=*)    :: s_vec_prcp(l_rgh_lines)        !10
      CHARACTER(LEN=*)    :: s_vec_snow(l_rgh_lines)        !10
      CHARACTER(LEN=*)    :: s_vec_awnd(l_rgh_lines)        !10

      CHARACTER(LEN=*)    :: s_vec_tmax_attrib(l_rgh_lines) !10
      CHARACTER(LEN=*)    :: s_vec_tmin_attrib(l_rgh_lines) !10
      CHARACTER(LEN=*)    :: s_vec_tavg_attrib(l_rgh_lines) !10
      CHARACTER(LEN=*)    :: s_vec_prcp_attrib(l_rgh_lines) !10
      CHARACTER(LEN=*)    :: s_vec_snow_attrib(l_rgh_lines) !10
      CHARACTER(LEN=*)    :: s_vec_awnd_attrib(l_rgh_lines) !10

      INTEGER             :: i_len_header
      INTEGER             :: i_linelength_max
      INTEGER             :: i_linelength_min
      INTEGER             :: l_field
c*****
c     Variables used within program

      INTEGER             :: i,j,k,ii,jj,kk
      INTEGER             :: io

c     23Sep2019: changed lengths from 2000 to 4000 because problem at 59264
      CHARACTER(LEN=4000) :: s_header
      CHARACTER(LEN=4000) :: s_linget

c     15Nov2018: l_field_rgh changed from 200 to 300 because program crashed
c     18Nov2018; l_field_rgh changed from 300 to 400 because prog stop i=55763
      INTEGER,PARAMETER   :: l_field_rgh=400    !number of data columns
      INTEGER,PARAMETER   :: l_width_rgh=100    !max width of single column
      CHARACTER(LEN=l_width_rgh)  :: s_vec_header(l_field_rgh)
      CHARACTER(LEN=l_width_rgh)  :: s_vec_linget(l_field_rgh)

      INTEGER             :: i_index_locate(6)
      INTEGER             :: i_index_locate_date
      INTEGER             :: i_index_locate_lat
      INTEGER             :: i_index_locate_lon
      INTEGER             :: i_index_locate_elev

      CHARACTER(LEN=30)   :: s_string_find

      INTEGER             :: i_lenmin_date
      INTEGER             :: i_lenmin_lat
      INTEGER             :: i_lenmin_lon
      INTEGER             :: i_lenmin_elev

      INTEGER             :: i_lenmin_tmax
      INTEGER             :: i_lenmin_tmin
      INTEGER             :: i_lenmin_tavg
      INTEGER             :: i_lenmin_prcp
      INTEGER             :: i_lenmin_snow
      INTEGER             :: i_lenmin_awnd

      INTEGER             :: i_lenmax_date
      INTEGER             :: i_lenmax_lat
      INTEGER             :: i_lenmax_lon
      INTEGER             :: i_lenmax_elev

      INTEGER             :: i_lenmax_tmax
      INTEGER             :: i_lenmax_tmin
      INTEGER             :: i_lenmax_tavg
      INTEGER             :: i_lenmax_prcp
      INTEGER             :: i_lenmax_snow
      INTEGER             :: i_lenmax_awnd

      INTEGER             :: l_field_linget
      INTEGER             :: i_field_max
      INTEGER             :: i_field_min

      INTEGER             :: i_len_linget
c************************************************************************
c      print*,'just entered get_gsom_datalines4'

      OPEN(UNIT=1,FILE=TRIM(s_pathandname),FORM='formatted',
     +   STATUS='OLD',ACTION='READ')      

       READ(1,1002,IOSTAT=io) s_header
1002   FORMAT(a4000)

       i_len_header=LEN_TRIM(s_header)
       IF (i_len_header.GE.4000) THEN
        print*,'s_pathandname=',TRIM(s_pathandname) 
        STOP 'get_gsom_datalines4, i_len_header>2000'
       ENDIF

c      Call subroutine to extract fields from header line
       CALL field_extractor_gen(
     +   s_header,l_field_rgh,l_width_rgh,
     +   s_vec_header,l_field) 

c      Call subroutine to find variable indices
       CALL find_variable_indices(l_width_rgh,l_field_rgh,
     +   l_field,s_vec_header,
     +   l_varselect,s_varselect,

     +   i_index_locate)

c      Call subroutine to find variable index for a single
       s_string_find='DATE'
       CALL find_variable_index_single(l_width_rgh,l_field_rgh,
     +   l_field,s_vec_header,
     +   s_string_find,
     +   i_index_locate_date)

       s_string_find='LATITUDE'
       CALL find_variable_index_single(l_width_rgh,l_field_rgh,
     +   l_field,s_vec_header,
     +   s_string_find,
     +   i_index_locate_lat)

       s_string_find='LONGITUDE'
       CALL find_variable_index_single(l_width_rgh,l_field_rgh,
     +   l_field,s_vec_header,
     +   s_string_find,
     +   i_index_locate_lon)

       s_string_find='ELEVATION'
       CALL find_variable_index_single(l_width_rgh,l_field_rgh,
     +   l_field,s_vec_header,
     +   s_string_find,
     +   i_index_locate_elev)

c      print*,'l_field=',l_field
c      print*,'i_index_locate=',i_index_locate
c      print*,'i_index_locate_date=',i_index_locate_date
c      print*,'i_index_locate_lat=', i_index_locate_lat
c      print*,'i_index_locate_lon=', i_index_locate_lon
c      print*,'i_index_locate_elev=',i_index_locate_elev

       ii=0
       i_linelength_max=0
       i_linelength_min=1000

       i_lenmin_date=100
       i_lenmin_lat =100
       i_lenmin_lon =100
       i_lenmin_elev=100

       i_lenmax_date=0
       i_lenmax_lat =0
       i_lenmax_lon =0
       i_lenmax_elev=0

       i_lenmin_tmax=100
       i_lenmin_tmin=100
       i_lenmin_tavg=100
       i_lenmin_prcp=100
       i_lenmin_snow=100
       i_lenmin_awnd=100

       i_lenmax_tmax=0
       i_lenmax_tmin=0
       i_lenmax_tavg=0
       i_lenmax_prcp=0
       i_lenmax_snow=0
       i_lenmax_awnd=0

       i_field_max  =0
       i_field_min  =1000
 
      DO 
c      Read data line
       READ(1,1004,IOSTAT=io) s_linget
 1004  FORMAT(a4000)
       IF (io .GT. 0) THEN
        WRITE(*,*) 'Check input. Something went wrong'
        GOTO 100
       ELSE IF (io .LT. 0) THEN 
c        WRITE(*,*) 'end of file reached'
        GOTO 100
       ELSE
        ii=ii+1

c       Emergency stop condition
        IF (ii.GE.l_rgh_lines) THEN 
         STOP 'get_gsom_datalines4, ii counter over vector dimension'
        ENDIF

        i_len_linget=LEN_TRIM(s_linget)

        IF (i_len_linget.GE.2000) THEN 
         STOP 'get_gsom_datalines4; s_linget too wide i_len=2000'
        ENDIF

        i_linelength_max=MAX(i_len_linget,i_linelength_max)
        i_linelength_min=MIN(i_len_linget,i_linelength_min)

c       Call subroutine to extract fields from header line
        CALL field_extractor_quot(s_linget,
     +    l_field_rgh,l_width_rgh,s_vec_linget,
     +    l_field_linget)  

        i_field_max  =MAX(i_field_max,l_field_linget)
        i_field_min  =MIN(i_field_min,l_field_linget)

c       Get fields into vectors
        CALL get_data_into_vectors2(ii,f_ndflag,
     +    l_width_rgh,l_field_rgh,l_rgh_lines,
     +    s_vec_linget,i_index_locate,
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

c       Get single string into vector - DATE
        CALL get_date_into_vector(ii,
     +    l_width_rgh,l_field_rgh,l_rgh_lines,
     +    s_vec_linget,i_index_locate_date,
     +    s_vec_date,
     +    i_lenmin_date,
     +    i_lenmax_date)

c       Get single string into vector - LATITUDE
        CALL get_singlestring_into_vector20200523(
     +    ii,f_ndflag,
     +    l_width_rgh,l_field_rgh,l_rgh_lines,l_rgh_lle,
     +    s_vec_linget,i_index_locate_lat,
     +    s_vec_lat,
     +    i_lenmin_lat,
     +    i_lenmax_lat,
     +    f_vec_lat_deg)

c       Get single string into vector - LONGITUDE
        CALL get_singlestring_into_vector20200523( 
     +    ii,f_ndflag,
     +    l_width_rgh,l_field_rgh,l_rgh_lines,l_rgh_lle,
     +    s_vec_linget,i_index_locate_lon,
     +    s_vec_lon,
     +    i_lenmin_lon,
     +    i_lenmax_lon,
     +    f_vec_lon_deg)

c       Get single string into vector - ELEVATION
        CALL get_singlestring_into_vector20200523(
     +    ii,f_ndflag,
     +    l_width_rgh,l_field_rgh,l_rgh_lines,l_rgh_lle,
     +    s_vec_linget,i_index_locate_elev,
     +    s_vec_elev,
     +    i_lenmin_elev,
     +    i_lenmax_elev,
     +    f_vec_elev_m)
c**************************************************
       ENDIF
      ENDDO
100   CONTINUE

      CLOSE(UNIT=1)

      l_lines=ii
c************************************************************************
      GOTO 10

      print*,'f_vec_tmax_c=',(f_vec_tmax_c(i),i=1,5)
      print*,'s_vec_tmax=',(s_vec_tmax(i),i=1,5)

      print*,'f_vec_tmin_c=',(f_vec_tmin_c(i),i=1,5)
      print*,'s_vec_tmin=',(s_vec_tmin(i),i=1,5)

      print*,'f_vec_tavg_c=',(f_vec_tavg_c(i),i=1,5)
      print*,'s_vec_tavg=',(s_vec_tavg(i),i=1,5)

      print*,'f_vec_prcp_mm=',(f_vec_prcp_mm(i),i=1,5)
      print*,'s_vec_prcp=',(s_vec_prcp(i),i=1,5)

      print*,'f_vec_snow_mm=',(f_vec_snow_mm(i),i=1,5)
      print*,'s_vec_snow=',(s_vec_snow(i),i=1,5)

      print*,'f_vec_awnd_ms=',(f_vec_awnd_ms(i),i=1,5)
      print*,'s_vec_awnd=',(s_vec_awnd(i),i=1,5)

 10   CONTINUE

c      print*,'just leaving get_gsom_datalines4'
c      STOP 'get_gsom_datalines4'

      RETURN
      END
