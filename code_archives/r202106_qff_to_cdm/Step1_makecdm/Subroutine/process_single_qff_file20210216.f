c     Subroutine to process qff file
c     AJ_Kettle, 19Nov2019
c     07Jun2020: modified to accommodate source_id error
c     16Feb2021: modified to readin different qff format

      SUBROUTINE process_single_qff_file20210216(s_file_single,
     +  l_rgh,l_lines, 
     +  s_vec_station_id,s_vec_station_name,
     +  s_vec_year,s_vec_month,s_vec_day,
     +  s_vec_hour,s_vec_minute,
     +  s_vec_latitude,s_vec_longitude,s_vec_elevation,
     +  s_vec_temperature_c,
     +    s_vec_temperature_source_id,
     +    s_vec_temperature_qc_flag,
     +  s_vec_dew_point_temperature_c,
     +    s_vec_dew_point_temperature_source_id,
     +    s_vec_dew_point_temperature_qc_flag,
     +  s_vec_station_level_pressure_hpa, 
     +    s_vec_station_level_pressure_source_id,
     +    s_vec_station_level_pressure_qc_flag,
     +  s_vec_sea_level_pressure_hpa,
     +    s_vec_sea_level_pressure_source_id,
     +    s_vec_sea_level_pressure_qc_flag,  
     +  s_vec_wind_direction_deg,
     +    s_vec_wind_direction_source_id,
     +    s_vec_wind_direction_qc_flag,
     +  s_vec_wind_speed_ms,
     +    s_vec_wind_speed_source_id,
     +    s_vec_wind_speed_qc_flag)

      IMPLICIT NONE
c************************************************************************
c     Variables passed into subroutine

      CHARACTER(LEN=300)  :: s_file_single

      INTEGER              :: l_rgh
      INTEGER              :: l_lines

      CHARACTER(LEN=*)     :: s_vec_station_id(l_rgh)                    !1   16
      CHARACTER(LEN=*)     :: s_vec_station_name(l_rgh)                  !2   64
      CHARACTER(LEN=*)     :: s_vec_year(l_rgh)                          !3   4
      CHARACTER(LEN=*)     :: s_vec_month(l_rgh)                         !4   2
      CHARACTER(LEN=*)     :: s_vec_day(l_rgh)                           !5   2
      CHARACTER(LEN=*)     :: s_vec_hour(l_rgh)                          !6   2
      CHARACTER(LEN=*)     :: s_vec_minute(l_rgh)                        !7   2
      CHARACTER(LEN=*)     :: s_vec_latitude(l_rgh)                      !8   16
      CHARACTER(LEN=*)     :: s_vec_longitude(l_rgh)                     !9   16
      CHARACTER(LEN=*)     :: s_vec_elevation(l_rgh)                     !10  16
      CHARACTER(LEN=*)     :: s_vec_temperature_c(l_rgh)                !11  32
      CHARACTER(LEN=*)     :: s_vec_temperature_source_id(l_rgh)         !12  4
      CHARACTER(LEN=*)     :: s_vec_temperature_qc_flag(l_rgh)           !13  8
      CHARACTER(LEN=*) :: s_vec_dew_point_temperature_c(l_rgh)           !14  32
      CHARACTER(LEN=*) :: s_vec_dew_point_temperature_source_id(l_rgh)   !15  4
      CHARACTER(LEN=*) :: s_vec_dew_point_temperature_qc_flag(l_rgh)     !16  8
      CHARACTER(LEN=*) :: s_vec_station_level_pressure_hpa(l_rgh)        !17  32
      CHARACTER(LEN=*) :: s_vec_station_level_pressure_source_id(l_rgh)  !18  4
      CHARACTER(LEN=*) :: s_vec_station_level_pressure_qc_flag(l_rgh)    !19  8
      CHARACTER(LEN=*)     :: s_vec_sea_level_pressure_hpa(l_rgh)        !20  32
      CHARACTER(LEN=*)     :: s_vec_sea_level_pressure_source_id(l_rgh)  !21  4
      CHARACTER(LEN=*)     :: s_vec_sea_level_pressure_qc_flag(l_rgh)    !22  8
      CHARACTER(LEN=*)     :: s_vec_wind_direction_deg(l_rgh)            !23  32
      CHARACTER(LEN=*)     :: s_vec_wind_direction_source_id(l_rgh)      !24  4
      CHARACTER(LEN=*)     :: s_vec_wind_direction_qc_flag(l_rgh)        !25  8
      CHARACTER(LEN=*)     :: s_vec_wind_speed_ms(l_rgh)                 !26  32
      CHARACTER(LEN=*)     :: s_vec_wind_speed_source_id(l_rgh)          !27  4
      CHARACTER(LEN=*)     :: s_vec_wind_speed_qc_flag(l_rgh)            !28  8
c*****
c     Variables used in subroutine

      INTEGER             :: i,j,k,ii,jj,kk
      INTEGER             :: io

      CHARACTER(LEN=1000)  :: s_header
      CHARACTER(LEN=1000)  :: s_linget

      INTEGER              :: i_len_header
      INTEGER              :: i_len_linget

      INTEGER,PARAMETER    :: l_qffcol=28

      CHARACTER(LEN=16)    :: s_sing_station_id                       !1
      CHARACTER(LEN=64)    :: s_sing_station_name                     !2
      CHARACTER(LEN=4)     :: s_sing_year                             !3
      CHARACTER(LEN=2)     :: s_sing_month                            !4
      CHARACTER(LEN=2)     :: s_sing_day                              !5
      CHARACTER(LEN=2)     :: s_sing_hour                             !6
      CHARACTER(LEN=2)     :: s_sing_minute                           !7
      CHARACTER(LEN=32)    :: s_sing_latitude                         !8
      CHARACTER(LEN=32)    :: s_sing_longitude                        !9
      CHARACTER(LEN=32)    :: s_sing_elevation                        !10
      CHARACTER(LEN=32)    :: s_sing_temperature_c                    !11
      CHARACTER(LEN=8)     :: s_sing_temperature_source_id            !12
      CHARACTER(LEN=8)     :: s_sing_temperature_qc_flag              !13
      CHARACTER(LEN=16)    :: s_sing_temperature_station_id           !14
      CHARACTER(LEN=32)    :: s_sing_dew_point_temperature_c          !15
      CHARACTER(LEN=8)     :: s_sing_dew_point_temperature_source_id  !16
      CHARACTER(LEN=8)     :: s_sing_dew_point_temperature_qc_flag    !17
      CHARACTER(LEN=16)    :: s_sing_dew_point_temperature_station_id !18 
      CHARACTER(LEN=32)    :: s_sing_station_level_pressure_hpa       !19
      CHARACTER(LEN=8)     :: s_sing_station_level_pressure_source_id !20
      CHARACTER(LEN=8)     :: s_sing_station_level_pressure_qc_flag   !21
      CHARACTER(LEN=16)    :: s_sing_station_level_pressure_station_id!22
      CHARACTER(LEN=32)    :: s_sing_sea_level_pressure_hpa           !23
      CHARACTER(LEN=8)     :: s_sing_sea_level_pressure_source_id     !24
      CHARACTER(LEN=8)     :: s_sing_sea_level_pressure_qc_flag       !25
      CHARACTER(LEN=16)    :: s_sing_sea_level_pressure_station_id    !26
      CHARACTER(LEN=32)    :: s_sing_wind_direction_deg               !27
      CHARACTER(LEN=8)     :: s_sing_wind_direction_source_id         !28
      CHARACTER(LEN=8)     :: s_sing_wind_direction_qc_flag           !29
      CHARACTER(LEN=16)    :: s_sing_wind_direction_station_id        !30
      CHARACTER(LEN=32)    :: s_sing_wind_speed_ms                    !31
      CHARACTER(LEN=8)     :: s_sing_wind_speed_source_id             !32
      CHARACTER(LEN=8)     :: s_sing_wind_speed_qc_flag               !33
      CHARACTER(LEN=16)    :: s_sing_wind_speed_station_id            !34

      CHARACTER(LEN=8)     :: s_sing_temperature_source_id_pre
      CHARACTER(LEN=8)     :: s_sing_dew_point_temperature_source_id_pre
      CHARACTER(LEN=8)     ::s_sing_station_level_pressure_source_id_pre
      CHARACTER(LEN=8)     :: s_sing_sea_level_pressure_source_id_pre
      CHARACTER(LEN=8)     :: s_sing_wind_direction_source_id_pre
      CHARACTER(LEN=8)     :: s_sing_wind_speed_source_id_pre

c     Initialize values
      INTEGER              :: i_lenstr_lim(34)
      INTEGER              :: i_lenstr_max(34)
      INTEGER              :: i_lenstr_maxpos(34)

      INTEGER              :: ich

      INTEGER              :: i_len
c*****
      CHARACTER(LEN=1)     :: s_singlechar 
c************************************************************************
c      print*,'just entered process_single_qff_file20210216'

c      print*,'s_file_single=',TRIM(s_file_single)
c*****
c     Initialize max vector
      DO i=1,34
       i_lenstr_max(i)      =0
       i_lenstr_maxpos(i)   =0
      ENDDO
c*****
c      print*,'just before open statement1'
c      OPEN(UNIT=2,FILE=TRIM(s_file_single),IOSTAT=io,
c     +  FORM='unformatted',STATUS='OLD',ACTION='READ')
c      print*,'just cleared open statement1'
c      print*,'io=',io
c      READ(2,1060,IOSTAT=io) s_singlechar
c      print*,'just cleared read statement1'
c      print*,'io=',io
c 1060 FORMAT(a1)
c      CLOSE(UNIT=2)
c      print*,'just cleared close statement1'
c*****
c      print*,'just before open statement3'
c      OPEN(UNIT=2,FILE=TRIM(s_file_single),IOSTAT=io,
c     +  FORM='unformatted',STATUS='OLD',ACTION='READ')
c      print*,'just cleared open statement3'
c      print*,'io=',io
c      READ(2,1060,IOSTAT=io) i
c      print*,'just cleared read statement3'
c      print*,'io,i=',io,i
c 1060 FORMAT(i8)
c      CLOSE(UNIT=2)
c      print*,'just cleared close statement3'

c      STOP 'process_single_qff_file20200607'
c*****
c      print*,'just before open statement2'
 
      OPEN(UNIT=2,FILE=TRIM(s_file_single),IOSTAT=io,
     +  FORM='formatted',STATUS='OLD',ACTION='READ')

c      print*,'just cleared open statement2'
c      print*,'io=',io
c      print*,'error statement in place'

      READ(2,1000,IOSTAT=io) s_header

c      print*,'just cleared read statement'
c      print*,'io=',io

      i_len_header=LEN_TRIM(s_header)

      ii=0

c      print*,'s_header=',TRIM(s_header)
c      print*,'i_len_header',i_len_header

      DO

       READ(2,1000,IOSTAT=io) s_linget
 1000  FORMAT(a1000)

c       print*,'s_linget=',TRIM(s_linget)
c       print*,'len',LEN_TRIM(s_linget)

       IF (io .GT. 0) THEN
        print*, 'Check input. Something went wrong'
        GOTO 100
       ELSE IF (io .LT. 0) THEN
c        print*, 'end of file reached'
        GOTO 100
       ELSE

        ii=ii+1

c        print*,'ii=',ii,TRIM(s_linget)
c        STOP 'process_single_qff_file'

        IF (ii.GE.l_rgh) THEN 
         print*,'index over vector limit',ii,l_rgh
         STOP 'process_single_qff_file20210216'
        ENDIF

        i_len_linget=LEN_TRIM(s_linget)

        IF (i_len_linget.GE.1000) THEN 
         print*,'emergency stop, linget too long'
         STOP 'process_single_qff_file20200607'
        ENDIF

c        s_vec_files(ii)=s_linget

c       Extract fields from single line
        CALL extract_fields_from_line20210216(l_qffcol,s_linget,
     +     ii,i_lenstr_max,i_lenstr_maxpos,
     +     s_sing_station_id,s_sing_station_name,
     +     s_sing_year,s_sing_month,s_sing_day,
     +     s_sing_hour,s_sing_minute,
     +     s_sing_latitude,s_sing_longitude,s_sing_elevation,
     +     s_sing_temperature_c,
     +       s_sing_temperature_source_id,
     +       s_sing_temperature_qc_flag,
     +       s_sing_temperature_station_id,
     +     s_sing_dew_point_temperature_c,
     +       s_sing_dew_point_temperature_source_id,
     +       s_sing_dew_point_temperature_qc_flag,
     +       s_sing_dew_point_temperature_station_id,
     +     s_sing_station_level_pressure_hpa,
     +       s_sing_station_level_pressure_source_id,
     +       s_sing_station_level_pressure_qc_flag,
     +       s_sing_station_level_pressure_station_id,
     +     s_sing_sea_level_pressure_hpa,
     +       s_sing_sea_level_pressure_source_id,
     +       s_sing_sea_level_pressure_qc_flag,
     +       s_sing_sea_level_pressure_station_id,
     +     s_sing_wind_direction_deg,
     +       s_sing_wind_direction_source_id,
     +       s_sing_wind_direction_qc_flag,
     +       s_sing_wind_direction_station_id,
     +     s_sing_wind_speed_ms,
     +       s_sing_wind_speed_source_id,
     +       s_sing_wind_speed_qc_flag,
     +       s_sing_wind_speed_station_id)
c****
c****
c       Archive results in vector
        s_vec_station_id(ii)     =s_sing_station_id
        s_vec_station_name(ii)   =s_sing_station_name
        s_vec_year(ii)           =s_sing_year 
        s_vec_month(ii)          =s_sing_month
        s_vec_day(ii)            =s_sing_day
        s_vec_hour(ii)           =s_sing_hour
        s_vec_minute(ii)         =s_sing_minute
        s_vec_latitude(ii)       =s_sing_latitude
        s_vec_longitude(ii)      =s_sing_longitude
        s_vec_elevation(ii)      =s_sing_elevation
        s_vec_temperature_c(ii)        =s_sing_temperature_c
        s_vec_temperature_source_id(ii)=s_sing_temperature_source_id
        s_vec_temperature_qc_flag(ii)  =s_sing_temperature_qc_flag
        s_vec_dew_point_temperature_c(ii)          
     +    =s_sing_dew_point_temperature_c
        s_vec_dew_point_temperature_source_id(ii)
     +    =s_sing_dew_point_temperature_source_id
        s_vec_dew_point_temperature_qc_flag(ii)  
     +    =s_sing_dew_point_temperature_qc_flag
        s_vec_station_level_pressure_hpa(ii)          
     +    =s_sing_station_level_pressure_hpa
        s_vec_station_level_pressure_source_id(ii)
     +    =s_sing_station_level_pressure_source_id
        s_vec_station_level_pressure_qc_flag(ii)  
     +    =s_sing_station_level_pressure_qc_flag
        s_vec_sea_level_pressure_hpa(ii)          
     +    =s_sing_sea_level_pressure_hpa
        s_vec_sea_level_pressure_source_id(ii)
     +    =s_sing_sea_level_pressure_source_id
        s_vec_sea_level_pressure_qc_flag(ii)  
     +    =s_sing_sea_level_pressure_qc_flag
        s_vec_wind_direction_deg(ii)          
     +    =s_sing_wind_direction_deg
        s_vec_wind_direction_source_id(ii)
     +    =s_sing_wind_direction_source_id
        s_vec_wind_direction_qc_flag(ii)  
     +    =s_sing_wind_direction_qc_flag
        s_vec_wind_speed_ms(ii)       =s_sing_wind_speed_ms
        s_vec_wind_speed_source_id(ii)=s_sing_wind_speed_source_id
        s_vec_wind_speed_qc_flag(ii)  =s_sing_wind_speed_qc_flag

       ENDIF
      ENDDO
 100  CONTINUE

      CLOSE(UNIT=2)

      l_lines=ii

c      print*,'l_lines=',l_lines
c*****
c*****
c     Test maximum length of strings

      i_lenstr_lim(1) =16
      i_lenstr_lim(2) =64
      i_lenstr_lim(3) =4
      i_lenstr_lim(4) =2
      i_lenstr_lim(5) =2
      i_lenstr_lim(6) =2
      i_lenstr_lim(7) =2
      i_lenstr_lim(8) =32 !16
      i_lenstr_lim(9) =32 !16
      i_lenstr_lim(10)=32 !16

      i_lenstr_lim(11)=32
      i_lenstr_lim(12)=8
      i_lenstr_lim(13)=8
      i_lenstr_lim(14)=16

      i_lenstr_lim(15)=32
      i_lenstr_lim(16)=8
      i_lenstr_lim(17)=8
      i_lenstr_lim(18)=16

      i_lenstr_lim(19)=32
      i_lenstr_lim(20)=8
      i_lenstr_lim(21)=8
      i_lenstr_lim(22)=16

      i_lenstr_lim(23)=32
      i_lenstr_lim(24)=8
      i_lenstr_lim(25)=8
      i_lenstr_lim(26)=16

      i_lenstr_lim(27)=32
      i_lenstr_lim(28)=8
      i_lenstr_lim(29)=8
      i_lenstr_lim(30)=16

      i_lenstr_lim(31)=32
      i_lenstr_lim(32)=8
      i_lenstr_lim(33)=8
      i_lenstr_lim(34)=16

      DO i=1,34
       IF (i_lenstr_max(i).GT.i_lenstr_lim(i)) THEN

c        GOTO 11

        ich=i_lenstr_maxpos(i)

        print*,'1. station_id',s_vec_station_id(ich)                    !1
        print*,'2. station_name',s_vec_station_name(ich)                  !2
        print*,'3. year',s_vec_year(ich)                          !3
        print*,'4. month',s_vec_month(ich)                         !4
        print*,'5. day',s_vec_day(ich)                           !5
        print*,'6. hour',s_vec_hour(ich)                          !6
        print*,'7. minute',s_vec_minute(ich)                        !7
        print*,'8. latitude',s_vec_latitude(ich)                      !8
        print*,'9. longitude',s_vec_longitude(ich)                     !9
        print*,'10.elevation',s_vec_elevation(ich)                     !10
        print*,'11.temp_c',s_vec_temperature_c(ich)                 !11
        print*,'12.temp_source_id',s_vec_temperature_source_id(ich)         !12
        print*,'13.temp_qc_flag',s_vec_temperature_qc_flag(ich)           !13
        print*,'15.dew1',s_vec_dew_point_temperature_c(ich)           !14
        print*,'16.dew2',s_vec_dew_point_temperature_source_id(ich)   !15
        print*,'17.dew3',s_vec_dew_point_temperature_qc_flag(ich)     !16
        print*,'19.station1',s_vec_station_level_pressure_hpa(ich)        !17
        print*,'20.station2',s_vec_station_level_pressure_source_id(ich)  !18
        print*,'21.station3',s_vec_station_level_pressure_qc_flag(ich)    !19
        print*,'23.sea1',s_vec_sea_level_pressure_hpa(ich)        !20
        print*,'24.sea2',s_vec_sea_level_pressure_source_id(ich)  !21
        print*,'25.sea3',s_vec_sea_level_pressure_qc_flag(ich)    !22
        print*,'27.winddir1',s_vec_wind_direction_deg(ich)            !23
        print*,'28.winddir2',s_vec_wind_direction_source_id(ich)      !24
        print*,'29.winddir3',s_vec_wind_direction_qc_flag(ich)        !25
        print*,'31.windspd1',s_vec_wind_speed_ms(ich)                 !26
        print*,'32.windspd2',s_vec_wind_speed_source_id(ich)          !27
        print*,'33.windspd3',s_vec_wind_speed_qc_flag(ich)            !28
 
 11     CONTINUE

        print*,'emergency stop, string length over limit'
        print*,'i,i_lenstr_max/lim=',i,i_lenstr_max(i),i_lenstr_lim(i)
        STOP 'process_single_qff_file20210216'
       ENDIF
      ENDDO

c      GOTO 95
c*****
c     Bad file condition
c 90   CONTINUE

c      print*,'bad file condition met'

c 95   CONTINUE
c*****
c      print*,'just leaving process_single_qff_file20200607'

c      print*,'check wspd info'
c      DO i=1,5
c       print*,'i...',i,
c     +  TRIM(s_vec_wind_speed_ms(i))//'='//
c     +  TRIM(s_vec_wind_speed_source_id(i))//'='//
c     +  TRIM(s_vec_wind_speed_qc_flag(i))//'='
c      ENDDO

c      STOP 'process_single_qff_file20210216'

      RETURN
      END
