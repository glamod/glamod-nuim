c     Subroutine to export month station data
c     AJ_Kettle, Dec2/2017

      SUBROUTINE export_tab_sn3a_stndata(s_directory_output,s_filename1,
     +  s_date,
     +  l_sd_stnrecord,s_sd_stke,s_sd_stid,
     +  l_zip_use,s_stnnum,
     +  s_arch_mon_commonyear_st,s_arch_mon_commonmon_st, 
     +  s_arch_mon_commonyear_en,s_arch_mon_commonmon_en, 
     +  s_arch_geog_hgt_m,s_arch_geog_lat_deg,s_arch_geog_lon_deg,
     +  i_arch_lmonrec_common,
     +  f_arch_mon_airt_ngood,f_arch_mon_wspd_ngood, 
     +  f_arch_mon_slpres_ngood,f_arch_mon_ppt_ngood)

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

      CHARACTER(LEN=2)    :: s_arch_mon_commonmon_st(1100)
      CHARACTER(LEN=2)    :: s_arch_mon_commonmon_en(1100)
      CHARACTER(LEN=4)    :: s_arch_mon_commonyear_st(1100)
      CHARACTER(LEN=4)    :: s_arch_mon_commonyear_en(1100)

      CHARACTER(LEN=8)    :: s_arch_geog_hgt_m(1100)
      CHARACTER(LEN=8)    :: s_arch_geog_lat_deg(1100)
      CHARACTER(LEN=8)    :: s_arch_geog_lon_deg(1100)

      INTEGER             :: i_arch_lmonrec_common(1100)
      REAL                :: f_arch_mon_airt_ngood(1100)
      REAL                :: f_arch_mon_wspd_ngood(1100)
      REAL                :: f_arch_mon_slpres_ngood(1100)
      REAL                :: f_arch_mon_ppt_ngood(1100)

      CHARACTER(LEN=4)    :: s_year_st 
      CHARACTER(LEN=2)    :: s_month_st
      CHARACTER(LEN=4)    :: s_year_en 
      CHARACTER(LEN=2)    :: s_month_en

      CHARACTER(LEN=18)   :: s_datestamp_st 
      CHARACTER(LEN=18)   :: s_datestamp_en 

c      CHARACTER(LEN=4)    :: s_code_relh          !38
      CHARACTER(LEN=4)    :: s_code_ppt           !44
c      CHARACTER(LEN=4)    :: s_code_snowcover     !53
c      CHARACTER(LEN=4)    :: s_code_snow_daytot   !55
      CHARACTER(LEN=4)    :: s_code_slpres          !58
      CHARACTER(LEN=4)    :: s_code_airtk          !85
c      CHARACTER(LEN=4)    :: s_code_wdir          !106
      CHARACTER(LEN=4)    :: s_code_wspd          !107

      CHARACTER(LEN=21)   :: s_code_allvar

      CHARACTER(LEN=300)  :: s_pathandname1

      INTEGER             :: i,j,k,ii,jj,kk
c************************************************************************
      print*,'just entered export_tab_sn3a_stndata'

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
     + 'Subroutine:   export_tab_sn3a_stndata.f                     '
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
     + 'B:   44=ppt; 58=sea level pressure; 85=air temperature;     '
      WRITE(UNIT=1,FMT=3009) 
     + '     107=wind speed                                         '
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
     + 'N_mon ',
     + 'Report time stamp start     ','Report time stamp end       ',
     + 'Man','Observed_variables        ','Ope','Con'
      WRITE(UNIT=1,FMT=3011) 
     + '     ','ID   ','         ','          ','          ','ID   ',
     + '      ',
     + '(monthly:yyyy-mm)','(monthly:yyyy-mm)',
     + 'Aut','see Note B                ','Ins','Add'
      WRITE(UNIT=1,FMT=3011) 
     + '+---+','+---+','+-------+','+--------+','+--------+','+---+',
     + '+----+',
     + '+---------------+','+---------------+',
     + '+-+','+------------------------+','+-+','+-+'
3011  FORMAT(t1,a5,t7,a5,t13,a9,t23,a10,t34,a10,t45,a5,
     +  t51,a6,
     +  t58,a17,t76,a17,
     +  t94,a3,t98,a14,t113,a3,t117,a3)

c     Cycle through 81 subdaily records
      DO i=1,l_sd_stnrecord
c      Cycle through long daily file list
       DO j=1,l_zip_use 

c       Output data if there is match
        IF (s_sd_stid(i).EQ.s_stnnum(j)) THEN

         s_year_st =s_arch_mon_commonyear_st(j)
         s_month_st=s_arch_mon_commonmon_st(j)
         s_year_en =s_arch_mon_commonyear_en(j)
         s_month_en=s_arch_mon_commonmon_en(j)
         s_datestamp_st='(Monthly:'//s_year_st//'-'//s_month_st//')'
         s_datestamp_en='(Monthly:'//s_year_en//'-'//s_month_en//')'
c****
c        Initialize all codes to null values
c         s_code_relh       =''   !38
         s_code_ppt        =''   !44
c         s_code_snowcover  =''   !53
c         s_code_snow_daytot=''   !55
         s_code_slpres     =''   !58
         s_code_airtk      =''   !85
c         s_code_wdir       =''   !106
         s_code_wspd       =''   !107

         IF (f_arch_mon_ppt_ngood(j).GT.0.0) THEN
          s_code_ppt        ='44,'
         ENDIF
         IF (f_arch_mon_slpres_ngood(j).GT.0.0) THEN
          s_code_slpres     ='58,'
         ENDIF 
         IF (f_arch_mon_airt_ngood(j).GT.0.0) THEN
          s_code_airtk      ='85,'
         ENDIF 
         IF (f_arch_mon_wspd_ngood(j).GT.0.0) THEN
          s_code_wspd       ='107,'
         ENDIF 

         s_code_allvar=
     +    TRIM(s_code_ppt)//TRIM(s_code_slpres)//
     +    TRIM(s_code_airtk)//TRIM(s_code_wspd)
c****
       WRITE(UNIT=1,FMT=3013)
     +  i,s_sd_stid(i),s_arch_geog_hgt_m(j),
     +  s_arch_geog_lat_deg(j),s_arch_geog_lon_deg(j),
     +  s_sd_stke(i),
     +  i_arch_lmonrec_common(j),
     +  s_datestamp_st,s_datestamp_en,
     +  'A  ',s_code_allvar,'C  ','D  '
3013   FORMAT(t1,i2,t7,a5,t13,a9,t23,a10,t34,a10,t45,a5,
     +  t51,i6,
     +  t58,a18,t76,a18,
     +  t96,a3,t98,a14,t113,a3,t117,a3)
c****


        ENDIF      
       ENDDO
      ENDDO

      CLOSE(UNIT=1)
c************************************************************************
      print*,'just leaving export_tab_sn3a_stndata'

      RETURN
      END