c     Subroutine to process all lines in single file
c     AJ_Kettle, 24Feb2019
c     13Mar2020: modified to read combined USAF files

c     Subroutine structure:
c     -get_params_singleline2
c     -find_minmax_string_vec
c     -find_nelem_present
c     -convert_variables2
c       -convert_single_string_to_float

      SUBROUTINE process_single_file5(
     +   s_dir_usaf_filelist,s_single_stnlist,
     +   f_ndflag,
     +   l_rgh_datalines,l_rgh_char,
     +   i_linelength_min,i_linelength_max,
     +   i_commacnt_min,i_commacnt_max,

     +   l_data,l_c1,l_c2,
     +   s_vec_platformid,s_vec_networktype,
     +   s_vec_ncdc_ob_time,s_vec_reporttypecode,
     +   s_vec_latitude,s_vec_longitude,s_vec_platformheight,
     +   s_vec_winddirection_deg,s_vec_winddirection_qc,
     +   s_vec_windspeed_ms,s_vec_windspeed_qc,
     +   s_vec_airtemperature_c,s_vec_airtemperature_qc,
     +   s_vec_dewpointtemperature_c,s_vec_dewpointtemperature_qc,
     +   s_vec_sealevelpressure_hpa,s_vec_sealevelpressure_qc,
     +   s_vec_stationpressure_hpa,s_vec_stationpressure_qc,
     +   f_vec_latitude,f_vec_longitude,f_vec_platformheight,
     +   f_vec_windspeed_ms,
     +   f_vec_sealevelpressure_hpa,f_vec_stationpressure_hpa)

      IMPLICIT NONE
c************************************************************************
c     Declare variables passed into program

      CHARACTER(LEN=*)    :: s_dir_usaf_filelist
      CHARACTER(LEN=*)    :: s_single_stnlist

      REAL                :: f_ndflag

      INTEGER             :: l_rgh_datalines
      INTEGER             :: l_rgh_char

      INTEGER             :: i_linelength_min
      INTEGER             :: i_linelength_max
      INTEGER             :: i_commacnt_min
      INTEGER             :: i_commacnt_max
c*****
c     Variables used within program

      INTEGER             :: i,j,k,ii,jj,kk
      INTEGER             :: io

      INTEGER             :: ii_top
      INTEGER             :: ii_body
      INTEGER             :: ii_data
      INTEGER             :: i_flag_body

      INTEGER             :: i_flag_sep
      INTEGER             :: i_index_sep

      CHARACTER(l_rgh_char):: s_linget
      CHARACTER(l_rgh_char):: s_header

      CHARACTER(300)::    s_pathandname

      INTEGER             :: i_linelength

      INTEGER             :: i_commacnt
      INTEGER             :: i_comma_pos(200)

      INTEGER             :: l_data
      INTEGER             :: l_c1
      INTEGER             :: l_c2

      CHARACTER(LEN=20)   :: s_platformid
      CHARACTER(LEN=20)   :: s_networktype
      CHARACTER(LEN=14)   :: s_ncdc_ob_time
      CHARACTER(LEN=6)    :: s_reporttypecode
      CHARACTER(LEN=15)   :: s_latitude
      CHARACTER(LEN=15)   :: s_longitude
      CHARACTER(LEN=15)   :: s_platformheight

      CHARACTER(LEN=l_c1) :: s_winddirection_deg      !10
      CHARACTER(LEN=l_c2) :: s_winddirection_qc       !10
      CHARACTER(LEN=l_c1) :: s_windspeed_ms           !10
      CHARACTER(LEN=l_c2) :: s_windspeed_qc           !10
      CHARACTER(LEN=l_c1) :: s_airtemperature_c       !10
      CHARACTER(LEN=l_c2) :: s_airtemperature_qc      !10
      CHARACTER(LEN=l_c1) :: s_dewpointtemperature_c  !10
      CHARACTER(LEN=l_c2) :: s_dewpointtemperature_qc !10
      CHARACTER(LEN=l_c1) :: s_sealevelpressure_hpa   !10
      CHARACTER(LEN=l_c2) :: s_sealevelpressure_qc    !10
      CHARACTER(LEN=l_c1) :: s_stationpressure_hpa    !10
      CHARACTER(LEN=l_c2) :: s_stationpressure_qc     !10

      CHARACTER(LEN=20)   :: s_vec_platformid(l_rgh_datalines)
      CHARACTER(LEN=20)   :: s_vec_networktype(l_rgh_datalines)
      CHARACTER(LEN=14)   :: s_vec_ncdc_ob_time(l_rgh_datalines)
      CHARACTER(LEN=6)    :: s_vec_reporttypecode(l_rgh_datalines)
      CHARACTER(LEN=15)   :: s_vec_latitude(l_rgh_datalines)
      CHARACTER(LEN=15)   :: s_vec_longitude(l_rgh_datalines)
      CHARACTER(LEN=15)   :: s_vec_platformheight(l_rgh_datalines)
      CHARACTER(LEN=l_c1) :: s_vec_winddirection_deg(l_rgh_datalines)
      CHARACTER(LEN=l_c2) :: s_vec_winddirection_qc(l_rgh_datalines)
      CHARACTER(LEN=l_c1) :: s_vec_windspeed_ms(l_rgh_datalines)
      CHARACTER(LEN=l_c2) :: s_vec_windspeed_qc(l_rgh_datalines)
      CHARACTER(LEN=l_c1) :: s_vec_airtemperature_c(l_rgh_datalines)
      CHARACTER(LEN=l_c2) :: s_vec_airtemperature_qc(l_rgh_datalines)
      CHARACTER(LEN=l_c1)::s_vec_dewpointtemperature_c(l_rgh_datalines)
      CHARACTER(LEN=l_c2)::s_vec_dewpointtemperature_qc(l_rgh_datalines)
      CHARACTER(LEN=l_c1) :: s_vec_sealevelpressure_hpa(l_rgh_datalines)
      CHARACTER(LEN=l_c2) :: s_vec_sealevelpressure_qc(l_rgh_datalines)
      CHARACTER(LEN=l_c1) :: s_vec_stationpressure_hpa(l_rgh_datalines)
      CHARACTER(LEN=l_c2) :: s_vec_stationpressure_qc(l_rgh_datalines)

      REAL                :: f_vec_latitude(l_rgh_datalines)
      REAL                :: f_vec_longitude(l_rgh_datalines)
      REAL                :: f_vec_platformheight(l_rgh_datalines)
      REAL                :: f_vec_winddirection_deg(l_rgh_datalines)
      REAL                :: f_vec_windspeed_ms(l_rgh_datalines)
      REAL                :: f_vec_airtemperature_c(l_rgh_datalines)
      REAL                ::f_vec_dewpointtemperature_c(l_rgh_datalines)
      REAL                :: f_vec_sealevelpressure_hpa(l_rgh_datalines)
      REAL                :: f_vec_stationpressure_hpa(l_rgh_datalines)

      INTEGER             :: i_minmax_strlen_platformid(2)
      INTEGER             :: i_minmax_strlen_networktype(2)
      INTEGER             :: i_minmax_strlen_ncdc_ob_time(2)
      INTEGER             :: i_minmax_strlen_reporttypecode(2)
      INTEGER             :: i_minmax_strlen_latitude(2)
      INTEGER             :: i_minmax_strlen_longitude(2)
      INTEGER             :: i_minmax_strlen_platformheight(2)
      INTEGER             :: i_minmax_strlen_winddirection(2)
      INTEGER             :: i_minmax_strlen_windspeed(2)
      INTEGER             :: i_minmax_strlen_sealevelpressure(2)
      INTEGER             :: i_minmax_strlen_stationpressure(2)

      INTEGER             :: i_cnt_strlen_platformid
      INTEGER             :: i_cnt_strlen_networktype
      INTEGER             :: i_cnt_strlen_ncdc_ob_time
      INTEGER             :: i_cnt_strlen_reporttypecode
      INTEGER             :: i_cnt_strlen_latitude
      INTEGER             :: i_cnt_strlen_longitude
      INTEGER             :: i_cnt_strlen_platformheight
      INTEGER             :: i_cnt_strlen_windspeed
      INTEGER             :: i_cnt_strlen_sealevelpressure
      INTEGER             :: i_cnt_strlen_stationpressure
c************************************************************************
c      print*,'just entered process_single_file4'

c      print*,'s_fileuse=',TRIM(s_fileuse)

      ii=0
      ii_top=0
      ii_body=0
      ii_data=0
      i_flag_body=0

      i_flag_sep=0

      i_linelength_min=5000
      i_linelength_max=-5000
      i_commacnt_min=5000
      i_commacnt_max=-5000

      s_pathandname=TRIM(s_dir_usaf_filelist)//TRIM(s_single_stnlist)

      OPEN(UNIT=1,FILE=TRIM(s_pathandname),FORM='formatted',
     +  STATUS='OLD',ACTION='READ')      

c     Read in header
      READ(1,1002,IOSTAT=io) s_header

      DO 

c      Read data line
       READ(1,1002,IOSTAT=io) s_linget
1002   FORMAT(a4000)
       IF (io .GT. 0) THEN
        WRITE(*,*) 'Check input. Something went wrong'
        GOTO 100
       ELSE IF (io .LT. 0) THEN 
c        WRITE(*,*) 'end of file reached'
        GOTO 100
       ELSE

        ii=ii+1

cc       Augment running index of top information
c        IF (i_flag_sep.EQ.0) THEN 
c         ii_top=ii_top+1
c        ENDIF

cc       Augment running index of body after separator found
c        IF (i_flag_sep.EQ.1) THEN 
c         ii_body=ii_body+1
c        ENDIF

cc       Print out header line
c        IF (ii_body.EQ.1) THEN
c         s_header=s_linget
cc         print*,'header line=',TRIM(s_linget)
cc         print*,LEN_TRIM(s_linget)
c        ENDIF

cc       Query data lines
c        IF (ii_body.GE.2) THEN
         ii_data=ii_data+1

c        Test if data lines are within storage
         IF (ii_data.GT.l_rgh_datalines) THEN
          print*,'emergency stop; data lines exceed storage'
          STOP 'process_single_file5'
         ENDIF

         i_linelength=LEN_TRIM(s_linget)
         i_linelength_min=MIN(i_linelength,i_linelength_min)
         i_linelength_max=MAX(i_linelength,i_linelength_max)

c        Find number commas in lines
         i_commacnt=0
         DO j=1,i_linelength
          IF (s_linget(j:j).EQ.',') THEN 
           i_commacnt=i_commacnt+1
           i_comma_pos(i_commacnt)=j

c          Condito for crashing program: too many commas
           IF (i_commacnt.GT.199) THEN 
            print*,'too many commas'
            STOP 'process_single_file5'
           ENDIF
          ENDIF
         ENDDO

         i_commacnt_min=MIN(i_commacnt,i_commacnt_min)
         i_commacnt_max=MAX(i_commacnt,i_commacnt_max)

c         print*,'ii=',ii
c         print*,'i_linelength minmax',i_linelength_min,i_linelength_max
c         print*,'i_commacnt minmax',  i_commacnt_min,i_commacnt_max
c         print*,'s_linget=',TRIM(s_linget) 
c         print*,'i_linelength=',i_linelength

c        Export bad line if number of commas is too few
         IF (i_commacnt.LT.164) THEN
          print*,'ii=',ii
          print*,'s_linget=',TRIM(s_linget) 
          print*,'i_linelength=',i_linelength
          print*,'i_commacnt=',i_commacnt
          print*,'number commas below threshold 164 stnpress'

c         16Jul2019: removed to avoid problems with parallel run 
c          CALL export_bad_line(ii,
c     +      s_directory_outfile_generalstats,s_subdirectory,
c     +      i_linelength,i_commacnt,
c     +      l_rgh_char,s_linget)

c          STOP 'process_single_file4'
         ENDIF

c        Get parameters from single line
c         print*,'ii=',ii
c         print*,'s_linget=',TRIM(s_linget) 

         CALL get_params_singleline20210527(
     +     l_rgh_char,s_linget,
     +     i_commacnt,i_comma_pos,
     +     l_c1,l_c2,
     +     s_platformid,s_networktype,s_ncdc_ob_time,
     +     s_reporttypecode,s_latitude,s_longitude,s_platformheight,
     +     s_winddirection_deg,s_winddirection_qc,
     +     s_windspeed_ms,s_windspeed_qc,
     +     s_airtemperature_c,s_airtemperature_qc,
     +     s_dewpointtemperature_c,s_dewpointtemperature_qc,
     +     s_sealevelpressure_hpa,s_sealevelpressure_qc,
     +     s_stationpressure_hpa,s_stationpressure_qc)

c        Crash program if lat or lon fields empty
         IF (LEN_TRIM(s_latitude).EQ.0.OR.LEN_TRIM(s_longitude).EQ.0) 
     +      THEN 
          print*,'emergency stop, lat or lon blank'
          print*,'s_latitude=',TRIM(s_latitude)
          print*,'s_longitude=',TRIM(s_longitude)
          STOP 'process_single_file5'
         ENDIF

c        Archive strings from single line
         s_vec_platformid(ii_data)          =s_platformid
         s_vec_networktype(ii_data)         =s_networktype
         s_vec_ncdc_ob_time(ii_data)        =s_ncdc_ob_time
         s_vec_reporttypecode(ii_data)      =s_reporttypecode
         s_vec_latitude(ii_data)            =s_latitude
         s_vec_longitude(ii_data)           =s_longitude
         s_vec_platformheight(ii_data)      =s_platformheight
         s_vec_winddirection_deg(ii_data)   =s_winddirection_deg
         s_vec_winddirection_qc(ii_data)    =s_winddirection_qc
         s_vec_windspeed_ms(ii_data)        =s_windspeed_ms
         s_vec_windspeed_qc(ii_data)        =s_windspeed_qc
         s_vec_airtemperature_c(ii_data)    =s_airtemperature_c
         s_vec_airtemperature_qc(ii_data)   =s_airtemperature_qc
         s_vec_dewpointtemperature_c(ii_data)=s_dewpointtemperature_c
         s_vec_dewpointtemperature_qc(ii_data)=s_dewpointtemperature_qc
         s_vec_sealevelpressure_hpa(ii_data)=s_sealevelpressure_hpa
         s_vec_sealevelpressure_qc(ii_data) =s_sealevelpressure_qc
         s_vec_stationpressure_hpa(ii_data) =s_stationpressure_hpa
         s_vec_stationpressure_qc(ii_data)  =s_stationpressure_qc

c         print*,'just after get_params_singleline2'

c         print*,'s_linget=',TRIM(s_linget)
c         print*,'ii_data',ii_data,
c     +     'latitude='//TRIM(s_latitude),
c     +     'longitude='//TRIM(s_longitude)

c         CALL SLEEP(1)

c         print*,'l_c1,l_c2=',l_c1,l_c2
c         print*,'cleared vector assignments'
c         STOP 'process_single_file4'

c        ENDIF

cc       Locate dashed separator
c        IF (s_linget(1:3).EQ.'---') THEN 
c         i_flag_sep=1
c         i_index_sep=ii
c        ENDIF

       ENDIF
      ENDDO                !end of line-counting loop

100   CONTINUE

      CLOSE(UNIT=1)

      l_data=ii_data

c      print*,'ii=',ii
c      print*,'ii_top,ii_body=',ii_top,ii_body,ii_top+ii_body
      print*,'ii_data=',ii_data
c      print*,'i_index_sep=',i_index_sep

c      print*,'i_linelength_min/max',
c     +  i_linelength_min,i_linelength_max
c      print*,'i_commacnt_min/max',
c     +  i_commacnt_min,i_commacnt_max

c      STOP 'process_single_file4'
c************************************************************************
c************************************************************************
c     Condition for crashing program
c     27Mar2019 removed condition because it tripped at WMO06759 i=1588
      IF (i_commacnt_min.NE.i_commacnt_max) THEN 
        print*,'i_commacnt_min/max',
     +     i_commacnt_min,i_commacnt_max
c        STOP 'process_single_file4'
      ENDIF
c*****
c     Call subroutine to find min/max of string vectors   
      CALL find_minmax_string_vec(
     +  l_rgh_datalines,l_data,
     +  s_vec_platformid,s_vec_networktype,
     +  s_vec_ncdc_ob_time,s_vec_reporttypecode,
     +  s_vec_latitude,s_vec_longitude,s_vec_platformheight,
     +  s_vec_windspeed_ms,
     +  s_vec_sealevelpressure_hpa,s_vec_stationpressure_hpa,

     +  i_minmax_strlen_platformid,i_minmax_strlen_networktype,
     +  i_minmax_strlen_ncdc_ob_time,i_minmax_strlen_reporttypecode,
     +  i_minmax_strlen_latitude,i_minmax_strlen_longitude,
     +  i_minmax_strlen_platformheight,i_minmax_strlen_windspeed,
     +  i_minmax_strlen_sealevelpressure,
     +  i_minmax_strlen_stationpressure)
c*****
c     Find number elements represented

      CALL find_nelem_present(
     +  l_rgh_datalines,l_data,
     +  s_vec_platformid,s_vec_networktype,
     +  s_vec_ncdc_ob_time,s_vec_reporttypecode,
     +  s_vec_latitude,s_vec_longitude,s_vec_platformheight,
     +  s_vec_windspeed_ms,
     +  s_vec_sealevelpressure_hpa,s_vec_stationpressure_hpa,

     +  i_cnt_strlen_platformid,i_cnt_strlen_networktype,
     +  i_cnt_strlen_ncdc_ob_time,i_cnt_strlen_reporttypecode,
     +  i_cnt_strlen_latitude,i_cnt_strlen_longitude,
     +  i_cnt_strlen_platformheight,i_cnt_strlen_windspeed,
     +  i_cnt_strlen_sealevelpressure,i_cnt_strlen_stationpressure)

c*****
c     Convert parameters to float
      
      CALL convert_variables2(f_ndflag,
     +  l_rgh_datalines,l_data,
     +  s_vec_latitude,s_vec_longitude,s_vec_platformheight,
     +  s_vec_winddirection_deg,s_vec_windspeed_ms,
     +  s_vec_airtemperature_c,s_vec_dewpointtemperature_c,
     +  s_vec_sealevelpressure_hpa,s_vec_stationpressure_hpa,

     +  f_vec_latitude,f_vec_longitude,f_vec_platformheight,
     +  f_vec_winddirection_deg,f_vec_windspeed_ms,
     +  f_vec_airtemperature_c,f_vec_dewpointtemperature_c,
     +  f_vec_sealevelpressure_hpa,f_vec_stationpressure_hpa)

c     +  s_vec_windspeed_ms,
c     +  s_vec_sealevelpressure_hpa,s_vec_stationpressure_hpa,

c     +  f_vec_latitude,f_vec_longitude,f_vec_platformheight,
c     +  f_vec_windspeed_ms,
c     +  f_vec_sealevelpressure_hpa,f_vec_stationpressure_hpa)
c*****
c     Count number of filled elements

c      CALL count_filled_fields(f_ndflag,
c     +  l_rgh_datalines,l_data,
c     +  s_vec_latitude,s_vec_longitude,s_vec_platformheight,
c     +  s_vec_windspeed_ms,
c     +  s_vec_sealevelpressure_hpa,s_vec_stationpressure_hpa,
  
c*****
c      print*,'just leaving process_single_file4'

      RETURN
      END
