c     Subroutine to export stn metadata DWD subdaily datasets
c     AJ_Kettle, Nov22/2017

      SUBROUTINE export_tab_sn1_stndata(s_directory_output,s_filename1,
     +  s_date,
     +  l_mstn,l_file_basis, 
     +  s_basis_stke,s_basis_stid,s_basis_stdate,s_basis_endate,
     +  s_basis_hght,s_basis_lat,s_basis_lon,s_basis_stnname,
     +  i_arch_j_day,i_arch_j_sd,
     +  s_arch_sd_year_st,s_arch_sd_year_en,
     +  s_arch_sd_month_st,s_arch_sd_month_en,
     +  s_arch_sd_day_st,s_arch_sd_day_en,
     +  s_arch_sd_timeutc_st,s_arch_sd_timeutc_en,
     +  f_arch_sd_pres_ngood,f_arch_sd_airt_ngood,
     +  f_arch_sd_relh_ngood,f_arch_sd_wdir_ngood,
     +  f_arch_sd_wspd_ngood,f_arch_sd_ppt_ngood,
     +  f_arch_day_snowcover_ngood,f_arch_day_snow_daytot_ngood)

      IMPLICIT NONE
c************************************************************************
      CHARACTER(LEN=300)  :: s_directory_output
      CHARACTER(LEN=300)  :: s_filename1
      CHARACTER(LEN=8)    :: s_date
 
      INTEGER             :: l_mstn
      INTEGER             :: l_file_basis
      INTEGER             :: j_day
      INTEGER             :: j_sd 
      CHARACTER(LEN=5)    :: s_basis_stke(l_mstn)
      CHARACTER(LEN=5)    :: s_basis_stid(l_mstn)
      CHARACTER(LEN=8)    :: s_basis_stdate(l_mstn)
      CHARACTER(LEN=8)    :: s_basis_endate(l_mstn)
      CHARACTER(LEN=9)    :: s_basis_hght(l_mstn)
      CHARACTER(LEN=10)   :: s_basis_lat(l_mstn)
      CHARACTER(LEN=10)   :: s_basis_lon(l_mstn)
      CHARACTER(LEN=25)   :: s_basis_stnname(l_mstn)

      INTEGER             :: i_arch_j_day(l_mstn)
      INTEGER             :: i_arch_j_sd(l_mstn)

      CHARACTER(LEN=4)    :: s_arch_sd_year_st(l_mstn) 
      CHARACTER(LEN=4)    :: s_arch_sd_year_en(l_mstn)  
      CHARACTER(LEN=2)    :: s_arch_sd_month_st(l_mstn) 
      CHARACTER(LEN=2)    :: s_arch_sd_month_en(l_mstn) 
      CHARACTER(LEN=2)    :: s_arch_sd_day_st(l_mstn) 
      CHARACTER(LEN=2)    :: s_arch_sd_day_en(l_mstn) 
      CHARACTER(LEN=4)    :: s_arch_sd_timeutc_st(l_mstn)
      CHARACTER(LEN=4)    :: s_arch_sd_timeutc_en(l_mstn)

      REAL                :: f_arch_sd_pres_ngood(l_mstn)
      REAL                :: f_arch_sd_airt_ngood(l_mstn)
      REAL                :: f_arch_sd_relh_ngood(l_mstn)
      REAL                :: f_arch_sd_wdir_ngood(l_mstn)
      REAL                :: f_arch_sd_wspd_ngood(l_mstn)
      REAL                :: f_arch_sd_ppt_ngood(l_mstn)
      REAL                :: f_arch_day_snowcover_ngood(l_mstn)
      REAL                :: f_arch_day_snow_daytot_ngood(l_mstn)

      CHARACTER(LEN=4)    :: s_code_relh          !38
      CHARACTER(LEN=4)    :: s_code_ppt           !44
      CHARACTER(LEN=4)    :: s_code_snowcover     !53
      CHARACTER(LEN=4)    :: s_code_snow_daytot   !55
      CHARACTER(LEN=4)    :: s_code_pres          !58
      CHARACTER(LEN=4)    :: s_code_airt          !85
      CHARACTER(LEN=4)    :: s_code_wdir          !106
      CHARACTER(LEN=4)    :: s_code_wspd          !107

      CHARACTER(LEN=26)   :: s_code_allvar

      CHARACTER(LEN=28)   :: s_datestamp_st 
      CHARACTER(LEN=28)   :: s_datestamp_en 

      CHARACTER(LEN=4)    :: s_year_st 
      CHARACTER(LEN=2)    :: s_month_st
      CHARACTER(LEN=2)    :: s_day_st
      CHARACTER(LEN=4)    :: s_hourmin_st
      CHARACTER(LEN=2)    :: s_hour_st
      CHARACTER(LEN=2)    :: s_minute_st

      CHARACTER(LEN=4)    :: s_year_en
      CHARACTER(LEN=2)    :: s_month_en
      CHARACTER(LEN=2)    :: s_day_en
      CHARACTER(LEN=4)    :: s_hourmin_en
      CHARACTER(LEN=2)    :: s_hour_en
      CHARACTER(LEN=2)    :: s_minute_en

      CHARACTER(LEN=300)  :: s_pathandname1

      INTEGER             :: i,j,k,ii,jj,kk
c************************************************************************
c      print*,'just inside export_tab_sn1_stndata.f'
c      print*,'i_arch_j_day=',(i_arch_j_day(i),i=1,10)
c      print*,'i_arch_j_sd=', (i_arch_j_sd(i),i=1,10)

c      print*,'s_arch_sd_year_st=', (s_arch_sd_year_st(i),i=1,5) 
c      print*,'s_arch_sd_month_st=',(s_arch_sd_month_st(i),i=1,5)
c      print*,'s_arch_sd_day_st=',  (s_arch_sd_day_st(i),i=1,5)

c      print*,'s_arch_sd_year_en=', (s_arch_sd_year_en(i),i=1,5) 
c      print*,'s_arch_sd_month_en=',(s_arch_sd_month_en(i),i=1,5)
c      print*,'s_arch_sd_day_en=',  (s_arch_sd_day_en(i),i=1,5)

      s_pathandname1=TRIM(s_directory_output)//TRIM(s_filename1)

      OPEN(UNIT=1,
     +  FILE=TRIM(s_pathandname1),
     +  FORM='formatted',
     +  STATUS='NEW',ACTION='WRITE')

      WRITE(UNIT=1,FMT=3009) 
     + 'DWD - subdaily station information; 81 stations in record   '  

c     SPACE
      WRITE(UNIT=1,FMT=3009) 
     + '                                                            '

      WRITE(unit=1,FMT=3029) 'AJ_Kettle ',s_date                          
3029  FORMAT(t1,a10,t12,a8) 

c     SPACE
      WRITE(UNIT=1,FMT=3009) 
     + '                                                            '

      WRITE(UNIT=1,FMT=3009) 
     + 'Main program: ds1.f                                         '
      WRITE(UNIT=1,FMT=3009) 
     + 'Subroutine:   export_table_sn1_stnmetadata.f                '
3009  FORMAT(a60) 

c     SPACE
      WRITE(UNIT=1,FMT=3009) 
     + '                                                            '

      WRITE(UNIT=1,FMT=3009) 
     + 'Notes:                                                      '
      WRITE(UNIT=1,FMT=3009) 
     + 'original_ID: ST_ID (ref1) [a5]                              '
      WRITE(UNIT=1,FMT=3009) 
     + 'alt_asl:     ST_HOEHE (ref1) [i4]; units m                  '
      WRITE(UNIT=1,FMT=3009) 
     + 'Lat:         GEO_BREITE (ref1) [f7.4]; units decimal degrees'  
      WRITE(UNIT=1,FMT=3009) 
     + 'Lon:         GEO_LAENGE (ref1) [f7.4]; units decimal degrees'
      WRITE(UNIT=1,FMT=3009) 
     + 'WMO ID:      ST_KE (ref1) [a5]                              '
      WRITE(UNIT=1,FMT=3009) 
     + 'N_days:      number of days of records [i6]                 '
      WRITE(UNIT=1,FMT=3009) 
     + 'N_lines:     number of subday lines [i6]; 3 obs/day         '
      WRITE(UNIT=1,FMT=3009) 
     + 'time stamp:  UTC                                            '
      WRITE(UNIT=1,FMT=3009) 
     + 'ref1:        KL_Standardformate_Beschreibung_Stationen.txt  '
      WRITE(UNIT=1,FMT=3009) 
     + 'A:           most data collection manual; answer pending on '
      WRITE(UNIT=1,FMT=3009) 
     + '             if possible to distinguish manual/auto stations'
      WRITE(UNIT=1,FMT=3009) 
     + 'B:           53,55 are reported daily in subdaily file      '
      WRITE(UNIT=1,FMT=3009) 
     + '             38,44,58,85,106,107 have 3 observations per day'
      WRITE(UNIT=1,FMT=3009) 
     + 'C:           Deutscher Wetterdienst (DWD) & precursors      '
      WRITE(UNIT=1,FMT=3009) 
     + 'D:           Walter Koelschtzky                             '
      WRITE(UNIT=1,FMT=3009) 
     + '             Head of Central Sales Management               '
      WRITE(UNIT=1,FMT=3009) 
     + '             Customer Relations Management                  '
      WRITE(UNIT=1,FMT=3009) 
     + '             Deutscher Wetterdienst                         '
      WRITE(UNIT=1,FMT=3009) 
     + '             Business Unit Climate and Environment          '
      WRITE(UNIT=1,FMT=3009) 
     + '             Postbox 10 04 65                               '
      WRITE(UNIT=1,FMT=3009) 
     + '             D-63004 Offenbach, Germany                     '
      WRITE(UNIT=1,FMT=3009) 
     + '             Phone: +49 (0)69 8062-4417                     '
      WRITE(UNIT=1,FMT=3009) 
     + '             Fax:   +49 (0)69 8062-4499                     '
      WRITE(UNIT=1,FMT=3009) 
     + '             Email: walter.koelschtzky@dwd.de               '

c     SPACE
      WRITE(UNIT=1,FMT=3009) 
     + '                                                            '

c     table headers
      WRITE(UNIT=1,FMT=3011) 
     + 'Index','Orig_','alt_asl  ','Latitude  ','Longitude ','WMO  ',
     + 'N_days','N_sub ',
     + 'Report time stamp start     ','Report time stamp end       ',
     + 'Man','Observed_variables        ','Ope','Con'
      WRITE(UNIT=1,FMT=3011) 
     + '     ','ID   ','         ','          ','          ','ID   ',
     + '      ','days  ', 
     + '(sub_daily:yyyy-mm-dd-hh-mm)','(sub_daily:yyyy-mm-dd-hh-mm)',
     + 'Aut','see Note B                ','Ins','Add'
      WRITE(UNIT=1,FMT=3011) 
     + '+---+','+---+','+-------+','+--------+','+--------+','+---+',
     + '+----+','+----+', 
     + '+--------------------------+','+--------------------------+',
     + '+-+','+------------------------+','+-+','+-+'
3011  FORMAT(t1,a5,t7,a5,t13,a9,t23,a10,t34,a10,t45,a5,
     +  t51,a6,t58,a6,
     +  t65,a28,t94,a28,
     +  t123,a3,t127,a26,t154,a3,t158,a3)

      DO i=1,l_file_basis

       s_year_st   =s_arch_sd_year_st(i)
       s_month_st  =s_arch_sd_month_st(i)
       s_day_st    =s_arch_sd_day_st(i) 
       s_hourmin_st=s_arch_sd_timeutc_st(i)
       s_hour_st   =s_hourmin_st(1:2)
       s_minute_st =s_hourmin_st(3:4)
       s_datestamp_st='(sub_daily:'//
     +    s_year_st//'-'//s_month_st//'-'//s_day_st//'-'//
     +    s_hour_st//'-'//s_minute_st//')'

       s_year_en   =s_arch_sd_year_en(i)
       s_month_en  =s_arch_sd_month_en(i)
       s_day_en    =s_arch_sd_day_en(i) 
       s_hourmin_en=s_arch_sd_timeutc_en(i)
       s_hour_en   =s_hourmin_en(1:2)
       s_minute_en =s_hourmin_en(3:4)
       s_datestamp_en='(sub_daily:'//
     +    s_year_en//'-'//s_month_en//'-'//s_day_en//'-'//
     +    s_hour_en//'-'//s_minute_en//')'
c****
c      Make presence/absence string

c      Initialize all codes to null values
       s_code_relh       =''   !38
       s_code_ppt        =''   !44
       s_code_snowcover  =''   !53
       s_code_snow_daytot=''   !55
       s_code_pres       =''   !58
       s_code_airt       =''   !85
       s_code_wdir       =''   !106
       s_code_wspd       =''   !107

       IF (f_arch_sd_relh_ngood(i).GT.0) THEN
        s_code_relh       ='38,'
       ENDIF
       IF (f_arch_sd_ppt_ngood(i).GT.0) THEN
        s_code_ppt        ='44,'
       ENDIF
       IF (f_arch_day_snowcover_ngood(i).GT.0) THEN
        s_code_snowcover  ='53,'
       ENDIF
       IF (f_arch_day_snow_daytot_ngood(i).GT.0) THEN
        s_code_snow_daytot='55,'
       ENDIF 
       IF (f_arch_sd_pres_ngood(i).GT.0) THEN
        s_code_pres       ='58,'
       ENDIF 
       IF (f_arch_sd_airt_ngood(i).GT.0) THEN
        s_code_airt       ='85,'
       ENDIF 
       IF (f_arch_sd_wdir_ngood(i).GT.0) THEN
        s_code_wdir       ='106,'
       ENDIF 
       IF (f_arch_sd_wspd_ngood(i).GT.0) THEN
        s_code_wspd       ='107,'
       ENDIF 

       s_code_allvar=
     +  TRIM(s_code_relh)//TRIM(s_code_ppt)//TRIM(s_code_snowcover)//
     +  TRIM(s_code_snow_daytot)//TRIM(s_code_pres)//TRIM(s_code_airt)//
     +  TRIM(s_code_wdir)//TRIM(s_code_wspd)

c       print*,'s_code_allvar='//s_code_allvar//'x'
c       CALL SLEEP(5)
c****
       WRITE(UNIT=1,FMT=3013)
     +  i,s_basis_stid(i),s_basis_hght(i),s_basis_lat(i),s_basis_lon(i),
     +  s_basis_stke(i),
     +  i_arch_j_day(i),i_arch_j_sd(i),
     +  s_datestamp_st,s_datestamp_en,
     +  'A  ',s_code_allvar,'C  ','D  '
3013   FORMAT(t1,i2,t7,a5,t13,a9,t23,a10,t34,a10,t45,a5,
     +  t51,i6,t58,i6,
     +  t65,a28,t94,a28,
     +  t123,a3,t127,a26,t154,a3,t158,a3)

      ENDDO

      CLOSE(UNIT=1)
c************************************************************************
      RETURN
      END