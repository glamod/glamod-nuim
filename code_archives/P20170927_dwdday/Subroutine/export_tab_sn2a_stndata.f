c     Subroutine to export day station table
c     AJ_Kettle, Dec1/2017

      SUBROUTINE export_tab_sn2a_stndata(s_directory_output,s_filename1,
     +  s_date,
     +  l_sd_stnrecord,s_sd_stke,s_sd_stid,
     +  l_zip_use,s_stnnum,
     +  i_arch_lprod,s_arch_dayrec_stdate,s_arch_dayrec_endate,
     +  s_arch_geog_hgt_m,s_arch_geog_lat_deg,s_arch_geog_lon_deg,
     +  i_arch_dayavg_relh_ngood,i_arch_daytot_ppt_ngood, 
     +  i_arch_daytot_snoacc_ngood,i_arch_dayavg_slpres_ngood,
     +  i_arch_dayavg_airtk_ngood,i_arch_dayavg_wspd_ngood,
     +  i_arch_dayavg_pres_ngood,i_arch_dayavg_airt_ngood)

      IMPLICIT NONE
c************************************************************************
c     Declare variables

      CHARACTER(LEN=200)  :: s_directory_output
      CHARACTER(LEN=200)  :: s_filename1
      CHARACTER(LEN=8)    :: s_date

      INTEGER             :: l_sd_stnrecord
      CHARACTER(LEN=5)    :: s_sd_stke(100)
      CHARACTER(LEN=5)    :: s_sd_stid(100)

      INTEGER             :: l_zip_use

      CHARACTER(LEN=5)    :: s_stnnum(1100)

      INTEGER             :: i_arch_lprod(1100)
      CHARACTER(LEN=8)    :: s_arch_dayrec_stdate(1100)
      CHARACTER(LEN=8)    :: s_arch_dayrec_endate(1100)
      CHARACTER(LEN=8)    :: s_arch_geog_hgt_m(1100)
      CHARACTER(LEN=8)    :: s_arch_geog_lat_deg(1100)
      CHARACTER(LEN=8)    :: s_arch_geog_lon_deg(1100)

      INTEGER             :: i_arch_dayavg_relh_ngood(1100)
      INTEGER             :: i_arch_daytot_ppt_ngood(1100) 
      INTEGER             :: i_arch_daytot_snoacc_ngood(1100)
      INTEGER             :: i_arch_dayavg_slpres_ngood(1100)
      INTEGER             :: i_arch_dayavg_airtk_ngood(1100)
      INTEGER             :: i_arch_dayavg_wspd_ngood(1100)

      INTEGER             :: i_arch_dayavg_pres_ngood(1100)
      INTEGER             :: i_arch_dayavg_airt_ngood(1100)

      CHARACTER(LEN=8)    :: s_date_single
      CHARACTER(LEN=4)    :: s_year_st 
      CHARACTER(LEN=2)    :: s_month_st
      CHARACTER(LEN=2)    :: s_day_st
      CHARACTER(LEN=4)    :: s_year_en 
      CHARACTER(LEN=2)    :: s_month_en
      CHARACTER(LEN=2)    :: s_day_en

      CHARACTER(LEN=18)   :: s_datestamp_st 
      CHARACTER(LEN=18)   :: s_datestamp_en 

      CHARACTER(LEN=4)    :: s_code_relh          !38
      CHARACTER(LEN=4)    :: s_code_ppt           !44
      CHARACTER(LEN=4)    :: s_code_snowcover     !53
      CHARACTER(LEN=4)    :: s_code_snow_daytot   !55
      CHARACTER(LEN=4)    :: s_code_slpres          !58
      CHARACTER(LEN=4)    :: s_code_airtk          !85
      CHARACTER(LEN=4)    :: s_code_wdir          !106
      CHARACTER(LEN=4)    :: s_code_wspd          !107

      CHARACTER(LEN=21)   :: s_code_allvar

      CHARACTER(LEN=300)  :: s_pathandname1

      INTEGER             :: i,j,k,ii,jj,kk
c************************************************************************
      print*,'just entered export_tab_sn2a_stndata'

c     Open file for export
      s_pathandname1=TRIM(s_directory_output)//TRIM(s_filename1)

      OPEN(UNIT=1,
     +  FILE=TRIM(s_pathandname1),
     +  FORM='formatted',
     +  STATUS='NEW',ACTION='WRITE')

      WRITE(UNIT=1,FMT=3009) 
     + 'DWD - daily station information; 81 stations in record      '  

c     SPACE
      WRITE(UNIT=1,FMT=3009) 
     + '                                                            '

      WRITE(unit=1,FMT=3029) 'AJ_Kettle ',s_date                          
3029  FORMAT(t1,a10,t12,a8) 

c     SPACE
      WRITE(UNIT=1,FMT=3009) 
     + '                                                            '

      WRITE(UNIT=1,FMT=3009) 
     + 'Main program: dd1.f                                         '
      WRITE(UNIT=1,FMT=3009) 
     + 'Subroutine:   export_tab_sn2a_stndata.f                     '
3009  FORMAT(a60) 

c     SPACE
      WRITE(UNIT=1,FMT=3009) 
     + '                                                            '

c     SPACE
      WRITE(UNIT=1,FMT=3009) 
     + 'Notes:                                                      '
      WRITE(UNIT=1,FMT=3009) 
     + 'A:   no formal information in daily files on aut/man status '
      WRITE(UNIT=1,FMT=3009) 
     + 'B:   38=relh, 44=ppt; 55=day snowfall; 58=sea level pressure'
      WRITE(UNIT=1,FMT=3009) 
     + '     85=air temperature; 107=wind speed                     '
      WRITE(UNIT=1,FMT=3009) 
     + 'C:   Deutscher Wetterdienst (DWD) & precursors              '
      WRITE(UNIT=1,FMT=3009) 
     + 'D:   Walter Koelschtzky                                     '
      WRITE(UNIT=1,FMT=3009) 
     + '     Head of Central Sales Management                       '
      WRITE(UNIT=1,FMT=3009) 
     + '     Customer Relations Management                          '
      WRITE(UNIT=1,FMT=3009) 
     + '     Deutscher Wetterdienst                                 '
      WRITE(UNIT=1,FMT=3009) 
     + '     Business Unit Climate and Environment                  '
      WRITE(UNIT=1,FMT=3009) 
     + '     Postbox 10 04 65                                       '
      WRITE(UNIT=1,FMT=3009) 
     + '     D-63004 Offenbach, Germany                             '
      WRITE(UNIT=1,FMT=3009) 
     + '     Phone: +49 (0)69 8062-4417                             '
      WRITE(UNIT=1,FMT=3009) 
     + '     Fax:   +49 (0)69 8062-4499                             '
      WRITE(UNIT=1,FMT=3009) 
     + '     Email: walter.koelschtzky@dwd.de                       '

c     SPACE
      WRITE(UNIT=1,FMT=3009) 
     + '                                                            '

c     table headers
      WRITE(UNIT=1,FMT=3011) 
     + 'Index','Orig_','alt_asl  ','Latitude  ','Longitude ','WMO  ',
     + 'N_days',
     + 'Report time stamp start     ','Report time stamp end       ',
     + 'Man','Observed_variables        ','Ope','Con'
      WRITE(UNIT=1,FMT=3011) 
     + '     ','ID   ','         ','          ','          ','ID   ',
     + '      ',
     + '(daily:yyyy-mm-dd)','(daily:yyyy-mm-dd)',
     + 'Aut','see Note B                ','Ins','Add'
      WRITE(UNIT=1,FMT=3011) 
     + '+---+','+---+','+-------+','+--------+','+--------+','+---+',
     + '+----+',
     + '+----------------+','+----------------+',
     + '+-+','+------------------------+','+-+','+-+'
3011  FORMAT(t1,a5,t7,a5,t13,a9,t23,a10,t34,a10,t45,a5,
     +  t51,a6,
     +  t58,a18,t77,a18,
     +  t96,a3,t100,a21,t122,a3,t126,a3)

c     Cycle through 81 subdaily records
      DO i=1,l_sd_stnrecord
c      Cycle through long daily file list
       DO j=1,l_zip_use 

c       Output data if there is match
        IF (s_sd_stid(i).EQ.s_stnnum(j)) THEN

         s_date_single=s_arch_dayrec_stdate(j)        
         s_year_st    =s_date_single(1:4)
         s_month_st   =s_date_single(5:6)
         s_day_st     =s_date_single(7:8)
         s_datestamp_st='(Daily:'//
     +     s_year_st//'-'//s_month_st//'-'//s_day_st//')'

         s_date_single=s_arch_dayrec_endate(j) 
         s_year_en    =s_date_single(1:4)
         s_month_en   =s_date_single(5:6)
         s_day_en     =s_date_single(7:8) 
         s_datestamp_en='(Daily:'//
     +     s_year_en//'-'//s_month_en//'-'//s_day_en//')'

         print*,'s_datestamp_st...',s_datestamp_st,s_datestamp_en
c****
c        Make presence/absence string

c        Initialize all codes to null values
         s_code_relh       =''   !38
         s_code_ppt        =''   !44
c         s_code_snowcover  =''   !53
         s_code_snow_daytot=''   !55
         s_code_slpres     =''   !58
         s_code_airtk      =''   !85
c         s_code_wdir       =''   !106
         s_code_wspd       =''   !107

         IF (i_arch_dayavg_relh_ngood(j).GT.0) THEN
          s_code_relh       ='38,'
          print*,'i_arch_dayavg_relh_ngood',i_arch_dayavg_relh_ngood(j)
         ENDIF
         IF (i_arch_daytot_ppt_ngood(j).GT.0) THEN
          s_code_ppt        ='44,'
          print*,'i_arch_daytot_ppt_ngood',i_arch_daytot_ppt_ngood(j)
         ENDIF
         IF (i_arch_daytot_snoacc_ngood(j).GT.0) THEN
          s_code_snow_daytot='55,'
          print*,'i_arch_daytot_snoacc..',i_arch_daytot_snoacc_ngood(j)
         ENDIF 
         IF (i_arch_dayavg_slpres_ngood(j).GT.0) THEN
          s_code_slpres     ='58,'
          print*,'i_arch_dayavg_slpres..',i_arch_dayavg_slpres_ngood(j)
         ENDIF 
         IF (i_arch_dayavg_airtk_ngood(j).GT.0) THEN
          s_code_airtk      ='85,'
          print*,'i_arch_dayavg_airtk...',i_arch_dayavg_airtk_ngood(j)
         ENDIF 
         IF (i_arch_dayavg_wspd_ngood(j).GT.0) THEN
          s_code_wspd       ='107,'
          print*,'i_arch_dayavg_wspd_ngood',i_arch_dayavg_wspd_ngood(j)
         ENDIF 

          print*,'i_arch_dayavg_slpres..',i_arch_dayavg_slpres_ngood(j)
          print*,'i_arch_dayavg_airtk...',i_arch_dayavg_airtk_ngood(j)

         IF (i_arch_dayavg_pres_ngood(j).GT.0) THEN
          print*,'i_arch_dayavg_pres_ngood',i_arch_dayavg_pres_ngood(j)
         ENDIF 
         IF (i_arch_dayavg_airt_ngood(j).GT.0) THEN
          print*,'i_arch_dayavg_airt_ngood',i_arch_dayavg_airt_ngood(j)
         ENDIF 

         s_code_allvar=
     +    TRIM(s_code_relh)//TRIM(s_code_ppt)//
     +    TRIM(s_code_snow_daytot)//TRIM(s_code_slpres)//
     +    TRIM(s_code_airtk)//
     +    TRIM(s_code_wspd)
c****
       WRITE(UNIT=1,FMT=3013)
     +  i,s_sd_stid(i),s_arch_geog_hgt_m(j),
     +  s_arch_geog_lat_deg(j),s_arch_geog_lon_deg(j),
     +  s_sd_stke(i),
     +  i_arch_lprod(j),
     +  s_datestamp_st,s_datestamp_en,
     +  'A  ',s_code_allvar,'C  ','D  '
3013   FORMAT(t1,i2,t7,a5,t13,a9,t23,a10,t34,a10,t45,a5,
     +  t51,i6,
     +  t58,a18,t77,a18,
     +  t96,a3,t100,a21,t122,a3,t126,a3)
c****


        ENDIF      
       ENDDO
      ENDDO

      CLOSE(UNIT=1)
c************************************************************************
      print*,'just leaving export_tab_sn2a_stndata'

      RETURN
      END