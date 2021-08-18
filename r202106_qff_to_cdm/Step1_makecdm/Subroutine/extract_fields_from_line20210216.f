c     Subroutine to extract fields from line
c     AJ_Kettle, 19Nov2019
c     16Feb2021: modified to increase number of extracted fields 34 instead of 28 fields

      SUBROUTINE extract_fields_from_line20210216(l_qffcol,s_linget,
     +     ii_index,i_lenstr_max,i_lenstr_maxpos,
     +     s_sing_station_id,s_sing_station_name,
     +     s_sing_year,s_sing_month,s_sing_day,
     +     s_sing_hour,s_sing_minute,
     +     s_sing_latitude,s_sing_longitude,s_sing_elevation,
     +     s_sing_temperature_c,
     +       s_sing_temperature_source_id,
     +       s_sing_temperature_qc_flag,
     +       s_sing_temperature_station_id,
     +     s_sing_dew_point_temperature,
     +       s_sing_dew_point_temperature_source_id,
     +       s_sing_dew_point_temperature_qc_flag,
     +       s_sing_dew_point_temperature_station_id,
     +     s_sing_station_level_pressure,
     +       s_sing_station_level_pressure_source_id,
     +       s_sing_station_level_pressure_qc_flag,
     +       s_sing_station_level_pressure_station_id,
     +     s_sing_sea_level_pressure,
     +       s_sing_sea_level_pressure_source_id,
     +       s_sing_sea_level_pressure_qc_flag,
     +       s_sing_sea_level_pressure_station_id,
     +     s_sing_wind_direction,
     +       s_sing_wind_direction_source_id,
     +       s_sing_wind_direction_qc_flag,
     +       s_sing_wind_direction_station_id,
     +     s_sing_wind_speed,
     +       s_sing_wind_speed_source_id,
     +       s_sing_wind_speed_qc_flag,
     +       s_sing_wind_speed_station_id)

      IMPLICIT NONE
c************************************************************************
      INTEGER              :: l_qffcol
      CHARACTER(LEN=300)   :: s_linget

      INTEGER              :: ii_index
      INTEGER              :: i_lenstr_max(28)
      INTEGER              :: i_lenstr_maxpos(28)

      CHARACTER(LEN=*)     :: s_sing_station_id                       !1   16
      CHARACTER(LEN=*)     :: s_sing_station_name                     !2   64
      CHARACTER(LEN=*)     :: s_sing_year                             !3   4
      CHARACTER(LEN=*)     :: s_sing_month                            !4   2
      CHARACTER(LEN=*)     :: s_sing_day                              !5   2
      CHARACTER(LEN=*)     :: s_sing_hour                             !6   2
      CHARACTER(LEN=*)     :: s_sing_minute                           !7   2
      CHARACTER(LEN=*)     :: s_sing_latitude                         !8   32
      CHARACTER(LEN=*)     :: s_sing_longitude                        !9   32
      CHARACTER(LEN=*)     :: s_sing_elevation                        !10  32
      CHARACTER(LEN=*)     :: s_sing_temperature_c                    !11  32
      CHARACTER(LEN=*)     :: s_sing_temperature_source_id            !12  8
      CHARACTER(LEN=*)     :: s_sing_temperature_qc_flag              !13  8
      CHARACTER(LEN=*)     :: s_sing_temperature_station_id           !14  16

      CHARACTER(LEN=*)     :: s_sing_dew_point_temperature            !15  32
      CHARACTER(LEN=*)     :: s_sing_dew_point_temperature_source_id  !16  8
      CHARACTER(LEN=*)     :: s_sing_dew_point_temperature_qc_flag    !17  8
      CHARACTER(LEN=*)     :: s_sing_dew_point_temperature_station_id !18  16

      CHARACTER(LEN=*)     :: s_sing_station_level_pressure           !19  32
      CHARACTER(LEN=*)     :: s_sing_station_level_pressure_source_id !20  8
      CHARACTER(LEN=*)     :: s_sing_station_level_pressure_qc_flag   !21  8
      CHARACTER(LEN=*)     :: s_sing_station_level_pressure_station_id!22  16

      CHARACTER(LEN=*)     :: s_sing_sea_level_pressure               !23  32
      CHARACTER(LEN=*)     :: s_sing_sea_level_pressure_source_id     !24  8
      CHARACTER(LEN=*)     :: s_sing_sea_level_pressure_qc_flag       !25  8
      CHARACTER(LEN=*)     :: s_sing_sea_level_pressure_station_id    !26  16

      CHARACTER(LEN=*)     :: s_sing_wind_direction                   !27  32
      CHARACTER(LEN=*)     :: s_sing_wind_direction_source_id         !28  8
      CHARACTER(LEN=*)     :: s_sing_wind_direction_qc_flag           !29  8
      CHARACTER(LEN=*)     :: s_sing_wind_direction_station_id        !30  16

      CHARACTER(LEN=*)     :: s_sing_wind_speed                       !31  32
      CHARACTER(LEN=*)     :: s_sing_wind_speed_source_id             !32  8
      CHARACTER(LEN=*)     :: s_sing_wind_speed_qc_flag               !33  8
      CHARACTER(LEN=*)     :: s_sing_wind_speed_station_id            !34  16
c*****
c     Variables used within subroutine

      INTEGER              :: i,j,k,ii,jj,kk

      INTEGER              :: i_lenline
      INTEGER              :: l_sep
      INTEGER              :: i_pos_sep(50)
      CHARACTER(LEN=1)     :: s_lett 

      INTEGER              :: i_lenstr(34)   !34 fields !28 fields

c      INTEGER              :: i_lenstr_limit(34)
      INTEGER              :: i_lenstr_maxnew(34)
c************************************************************************
c      print*,'just entered extract_fields_from_line'
c*****
c     Initialize variables

      s_sing_station_id                      ='' !1   16
      s_sing_station_name                    ='' !2   64
      s_sing_year                            ='' !3   4
      s_sing_month                           ='' !4   2
      s_sing_day                             ='' !5   2
      s_sing_hour                            ='' !6   2
      s_sing_minute                          ='' !7   2
      s_sing_latitude                        ='' !8   32
      s_sing_longitude                       ='' !9   32
      s_sing_elevation                       ='' !10  32

      s_sing_temperature_c                   ='' !11  32
      s_sing_temperature_source_id           ='' !12  8
      s_sing_temperature_qc_flag             ='' !13  8
      s_sing_temperature_station_id          ='' !14  16

      s_sing_dew_point_temperature           ='' !15  32
      s_sing_dew_point_temperature_source_id ='' !16  8
      s_sing_dew_point_temperature_qc_flag   ='' !17  8
      s_sing_dew_point_temperature_station_id='' !18  16

      s_sing_station_level_pressure          ='' !19  32
      s_sing_station_level_pressure_source_id='' !20  8
      s_sing_station_level_pressure_qc_flag  ='' !21  8
      s_sing_station_level_pressure_station_id=''!22  16

      s_sing_sea_level_pressure              ='' !23  32
      s_sing_sea_level_pressure_source_id    ='' !24  8
      s_sing_sea_level_pressure_qc_flag      ='' !25  8
      s_sing_sea_level_pressure_station_id   ='' !26  16

      s_sing_wind_direction                  ='' !27  32
      s_sing_wind_direction_source_id        ='' !28  8
      s_sing_wind_direction_qc_flag          ='' !29  8
      s_sing_wind_direction_station_id       ='' !30  16

      s_sing_wind_speed                      ='' !31  32
      s_sing_wind_speed_source_id            ='' !32  8
      s_sing_wind_speed_qc_flag              ='' !33  8
      s_sing_wind_speed_station_id           ='' !34  16

c*****
      i_lenline=LEN_TRIM(s_linget)
      
c      print*,'l_qffcol=',l_qffcol
c      print*,'s_linget=',TRIM(s_linget)
c      print*,'i_lenline=',i_lenline

      l_sep=0

      DO i=1,i_lenline
       s_lett=s_linget(i:i)

       IF (s_lett.EQ.'|') THEN
        l_sep=l_sep+1
        i_pos_sep(l_sep)=i
       ENDIF
      ENDDO

c      print*,'l_sep=',l_sep
c      print*,'i_pos_sep=',(i_pos_sep(i),i=1,l_sep)
c*****
c     Find charlen of fields

      i_lenstr(1)=i_pos_sep(1)-1
      DO i=1,33 !26
       i_lenstr(i+1)=i_pos_sep(i+1)-i_pos_sep(i)-1
      ENDDO
      i_lenstr(34)=i_lenline-i_pos_sep(33)
c*****
c     Assess maximum length
      DO i=1,34
       i_lenstr_maxnew(i)=MAX(i_lenstr_max(i),i_lenstr(i))

       IF (i_lenstr_maxnew(i).NE.i_lenstr_max(i)) THEN 
        i_lenstr_maxpos(i)=ii_index    !archive line number
       ENDIF
       i_lenstr_max(i)=i_lenstr_maxnew(i)
      ENDDO
c*****
c     Test length of strings agaist array allocation
c      IF (i_lenstr(1).GT.16) THEN
c       print*,'field1=',i_lenstr(1)
c       STOP 'extract_fields_from_line'
c      ENDIF
c      IF (i_lenstr(2).GT.64) THEN
c       print*,'field2=',i_lenstr(2)
c       STOP 'extract_fields_from_line'
c      ENDIF
c      IF (i_lenstr(3).GT.4) THEN
c       print*,'field3=',i_lenstr(3)
c       STOP 'extract_fields_from_line'
c      ENDIF
c      IF (i_lenstr(4).GT.2) THEN
c       print*,'field4=',i_lenstr(4)
c       STOP 'extract_fields_from_line'
c      ENDIF
c      IF (i_lenstr(5).GT.2) THEN
c       print*,'field5=',i_lenstr(5)
c       STOP 'extract_fields_from_line'
c      ENDIF
c      IF (i_lenstr(6).GT.2) THEN
c       print*,'field6=',i_lenstr(6)
c       STOP 'extract_fields_from_line'
c      ENDIF
c      IF (i_lenstr(7).GT.2) THEN
c       print*,'field7=',i_lenstr(7)
c       STOP 'extract_fields_from_line'
c      ENDIF

c      print*,'s_linget=',TRIM(s_linget)
c      print*,'i_lenstr=',(i_lenstr(i),i=1,28)
c      STOP 'extract_fields_from_line'
c*****
c     Extract values
      IF (i_lenstr(1).GT.0) THEN
       s_sing_station_id   =s_linget(1:i_pos_sep(1)-1)
      ENDIF
      IF (i_lenstr(2).GT.0) THEN
       s_sing_station_name =s_linget(i_pos_sep(1)+1:i_pos_sep(2)-1)
      ENDIF
      IF (i_lenstr(3).GT.0) THEN
       s_sing_year         =s_linget(i_pos_sep(2)+1:i_pos_sep(3)-1)
      ENDIF
      IF (i_lenstr(4).GT.0) THEN
       s_sing_month        =s_linget(i_pos_sep(3)+1:i_pos_sep(4)-1)
      ENDIF
      IF (i_lenstr(5).GT.0) THEN
       s_sing_day          =s_linget(i_pos_sep(4)+1:i_pos_sep(5)-1)
      ENDIF
      IF (i_lenstr(6).GT.0) THEN
       s_sing_hour         =s_linget(i_pos_sep(5)+1:i_pos_sep(6)-1)
      ENDIF
      IF (i_lenstr(7).GT.0) THEN
       s_sing_minute       =s_linget(i_pos_sep(6)+1:i_pos_sep(7)-1)
      ENDIF
      IF (i_lenstr(8).GT.0) THEN
       s_sing_latitude     =s_linget(i_pos_sep(7)+1:i_pos_sep(8)-1)
      ENDIF
      IF (i_lenstr(9).GT.0) THEN
       s_sing_longitude    =s_linget(i_pos_sep(8)+1:i_pos_sep(9)-1)
      ENDIF
      IF (i_lenstr(10).GT.0) THEN
       s_sing_elevation    =s_linget(i_pos_sep(9)+1:i_pos_sep(10)-1)
      ENDIF

      IF (i_lenstr(11).GT.0) THEN
       s_sing_temperature_c                    
     +  =s_linget(i_pos_sep(10)+1:i_pos_sep(11)-1)
      ENDIF
      IF (i_lenstr(12).GT.0) THEN
       s_sing_temperature_source_id            
     +  =s_linget(i_pos_sep(11)+1:i_pos_sep(12)-1)
      ENDIF
      IF (i_lenstr(13).GT.0) THEN
       s_sing_temperature_qc_flag              
     +  =s_linget(i_pos_sep(12)+1:i_pos_sep(13)-1)
      ENDIF
      IF (i_lenstr(14).GT.0) THEN
       s_sing_temperature_station_id              
     +  =s_linget(i_pos_sep(13)+1:i_pos_sep(14)-1)
      ENDIF

      IF (i_lenstr(15).GT.0) THEN
       s_sing_dew_point_temperature            
     +  =s_linget(i_pos_sep(14)+1:i_pos_sep(15)-1)
      ENDIF
      IF (i_lenstr(16).GT.0) THEN
       s_sing_dew_point_temperature_source_id  
     +  =s_linget(i_pos_sep(15)+1:i_pos_sep(16)-1)
      ENDIF
      IF (i_lenstr(17).GT.0) THEN
       s_sing_dew_point_temperature_qc_flag    
     +  =s_linget(i_pos_sep(16)+1:i_pos_sep(17)-1)
      ENDIF
      IF (i_lenstr(18).GT.0) THEN
       s_sing_dew_point_temperature_station_id
     +  =s_linget(i_pos_sep(17)+1:i_pos_sep(18)-1)
      ENDIF

      IF (i_lenstr(19).GT.0) THEN
       s_sing_station_level_pressure           
     +  =s_linget(i_pos_sep(18)+1:i_pos_sep(19)-1)
      ENDIF
      IF (i_lenstr(20).GT.0) THEN
       s_sing_station_level_pressure_source_id 
     +  =s_linget(i_pos_sep(19)+1:i_pos_sep(20)-1)
      ENDIF
      IF (i_lenstr(21).GT.0) THEN
       s_sing_station_level_pressure_qc_flag   
     +  =s_linget(i_pos_sep(20)+1:i_pos_sep(21)-1)
      ENDIF
      IF (i_lenstr(22).GT.0) THEN
       s_sing_station_level_pressure_station_id
     +  =s_linget(i_pos_sep(21)+1:i_pos_sep(22)-1)
      ENDIF

      IF (i_lenstr(23).GT.0) THEN
       s_sing_sea_level_pressure               
     +  =s_linget(i_pos_sep(22)+1:i_pos_sep(23)-1)
      ENDIF
      IF (i_lenstr(24).GT.0) THEN
       s_sing_sea_level_pressure_source_id     
     +  =s_linget(i_pos_sep(23)+1:i_pos_sep(24)-1)
      ENDIF
      IF (i_lenstr(25).GT.0) THEN
       s_sing_sea_level_pressure_qc_flag       
     +  =s_linget(i_pos_sep(24)+1:i_pos_sep(25)-1)
      ENDIF
      IF (i_lenstr(26).GT.0) THEN
       s_sing_sea_level_pressure_station_id       
     +  =s_linget(i_pos_sep(25)+1:i_pos_sep(26)-1)
      ENDIF

      IF (i_lenstr(27).GT.0) THEN
       s_sing_wind_direction                   
     +  =s_linget(i_pos_sep(26)+1:i_pos_sep(27)-1)
      ENDIF
      IF (i_lenstr(28).GT.0) THEN
       s_sing_wind_direction_source_id         
     +  =s_linget(i_pos_sep(27)+1:i_pos_sep(28)-1)
      ENDIF
      IF (i_lenstr(29).GT.0) THEN
       s_sing_wind_direction_qc_flag           
     +  =s_linget(i_pos_sep(28)+1:i_pos_sep(29)-1)
      ENDIF
      IF (i_lenstr(30).GT.0) THEN
       s_sing_wind_direction_station_id           
     +  =s_linget(i_pos_sep(29)+1:i_pos_sep(30)-1)
      ENDIF

      IF (i_lenstr(31).GT.0) THEN
       s_sing_wind_speed                       
     +  =s_linget(i_pos_sep(30)+1:i_pos_sep(31)-1)
      ENDIF
      IF (i_lenstr(32).GT.0) THEN
       s_sing_wind_speed_source_id             
     +  =s_linget(i_pos_sep(31)+1:i_pos_sep(32)-1)
      ENDIF
      IF (i_lenstr(33).GT.0) THEN
       s_sing_wind_speed_qc_flag
     +  =s_linget(i_pos_sep(32)+1:i_pos_sep(33)-1)
      ENDIF
      IF (i_lenstr(34).GT.0) THEN
       s_sing_wind_speed_station_id
     +  =s_linget(i_pos_sep(33)+1:i_lenline)
      ENDIF
 
      GOTO 10

      print*,'s_sing_station_id='//TRIM(s_sing_station_id)//'='
      print*,'s_sing_station_name='//TRIM(s_sing_station_name)//'='
      print*,'s_sing_year=',TRIM(s_sing_year)//'='
      print*,'s_sing_month=',TRIM(s_sing_month)//'='
      print*,'s_sing_day=',TRIM(s_sing_day)//'='
      print*,'s_sing_hour=',TRIM(s_sing_hour)//'='
      print*,'s_sing_minute=',TRIM(s_sing_minute)//'='
      print*,'s_sing_latitude=',TRIM(s_sing_latitude)//'='
      print*,'s_sing_longitude=',TRIM(s_sing_longitude)//'='
      print*,'s_sing_elevation=',TRIM(s_sing_elevation)//'='

      print*,'airt1='//TRIM(s_sing_temperature_c)//'='
      print*,'airt2='//TRIM(s_sing_temperature_source_id)//'='
      print*,'airt3='//TRIM(s_sing_temperature_qc_flag)//'='
      print*,'airt4='//TRIM(s_sing_temperature_station_id)//'='

      print*,'dp1='//TRIM(s_sing_dew_point_temperature)//'='
      print*,'dp2='//TRIM(s_sing_dew_point_temperature_source_id)//'='
      print*,'dp3='//TRIM(s_sing_dew_point_temperature_qc_flag)//'='
      print*,'dp4='//TRIM(s_sing_dew_point_temperature_station_id)//'='

      print*,'sp1='//TRIM(s_sing_station_level_pressure)//'='
      print*,'sp2='//TRIM(s_sing_station_level_pressure_source_id)//'='
      print*,'sp3='//TRIM(s_sing_station_level_pressure_qc_flag)//'='
      print*,'sp4='//TRIM(s_sing_station_level_pressure_station_id)//'='

      print*,'slp1='//TRIM(s_sing_sea_level_pressure)//'='
      print*,'slp2='//TRIM(s_sing_sea_level_pressure_source_id)//'='
      print*,'slp3='//TRIM(s_sing_sea_level_pressure_qc_flag)//'='
      print*,'slp4='//TRIM(s_sing_sea_level_pressure_station_id)//'='

      print*,'wdir1='//TRIM(s_sing_wind_direction)//'='
      print*,'wdir2='//TRIM(s_sing_wind_direction_source_id)//'='
      print*,'wdir3='//TRIM(s_sing_wind_direction_qc_flag)//'='
      print*,'wdir4='//TRIM(s_sing_wind_direction_station_id)//'='

      print*,'wspd1='//TRIM(s_sing_wind_speed)//'='
      print*,'wspd2='//TRIM(s_sing_wind_speed_source_id)//'='
      print*,'wspd3='//TRIM(s_sing_wind_speed_qc_flag)//'='
      print*,'wspd4='//TRIM(s_sing_wind_speed_station_id)//'='

      STOP 'extract_fields_from_line20210216'

 10   CONTINUE
c*****
c      print*,'just leaving extract_fields_from_line'

c      STOP 'extract_fields_from_line20210216'

      RETURN
      END
