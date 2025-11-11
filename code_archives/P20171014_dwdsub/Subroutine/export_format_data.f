c     Subroutine to export one formatted data file
c     AJ_Kettle, Nov3/2017

      SUBROUTINE export_format_data(s_directory_output,
     +   f_ndflag,
     +   s_export_stid,s_export_stnname,
     +   s_export_lat,s_export_lon,s_export_hght, 
     +   l_mlent,j_sd,
     +   st_sd_year,st_sd_month,st_sd_day,st_sd_time,st_sd_time_id,
     +   ft_sd_airt_k,ft_sd_ppt_mm,
     +   ft_sd_wspd_ms,ft_sd_wdir_deg,
     +   ft_sd_pres_hpa,ft_sd_wetb_k)

      IMPLICIT NONE
c************************************************************************
      CHARACTER(LEN=300)  :: s_directory_output

      REAL                :: f_ndflag
      CHARACTER(LEN=5)    :: s_export_stid
      CHARACTER(LEN=25)   :: s_export_stnname
      CHARACTER(LEN=10)   :: s_export_lat
      CHARACTER(LEN=10)   :: s_export_lon
      CHARACTER(LEN=9)    :: s_export_hght

      INTEGER             :: l_mlent
      INTEGER             :: j_sd
      CHARACTER(LEN=4)    :: st_sd_year(l_mlent)
      CHARACTER(LEN=2)    :: st_sd_month(l_mlent) 
      CHARACTER(LEN=2)    :: st_sd_day(l_mlent) 
      CHARACTER(LEN=4)    :: st_sd_time(l_mlent)
      CHARACTER(LEN=3)    :: st_sd_time_id(l_mlent)
      REAL                :: ft_sd_pres_hpa(l_mlent)
      REAL                :: ft_sd_airt_k(l_mlent)
      REAL                :: ft_sd_wetb_k(l_mlent)
      REAL                :: ft_sd_wdir_deg(l_mlent)
      REAL                :: ft_sd_wspd_ms(l_mlent)
      REAL                :: ft_sd_ppt_mm(l_mlent)

      INTEGER             :: i,j,k,ii,jj,kk

c     derived variables
      CHARACTER(LEN=4)    :: s_export_styear
      CHARACTER(LEN=4)    :: s_export_enyear

c     Declare basic stats of data
      REAL                :: f_stat_pres_min_hpa
      REAL                :: f_stat_pres_max_hpa
      INTEGER             :: i_stat_pres_nnn_data
      INTEGER             :: i_stat_pres_nnn_stn
      INTEGER             :: i_stat_pres_nnn_qc
      INTEGER             :: i_stat_pres_nnn_ipr
      INTEGER             :: i_stat_pres_ntotal

      REAL                :: f_stat_airt_min_k
      REAL                :: f_stat_airt_max_k
      INTEGER             :: i_stat_airt_nnn_data
      INTEGER             :: i_stat_airt_nnn_stn
      INTEGER             :: i_stat_airt_nnn_qc
      INTEGER             :: i_stat_airt_nnn_ipr
      INTEGER             :: i_stat_airt_ntotal

      REAL                :: f_stat_wetb_min_k
      REAL                :: f_stat_wetb_max_k
      INTEGER             :: i_stat_wetb_nnn_data
      INTEGER             :: i_stat_wetb_nnn_stn
      INTEGER             :: i_stat_wetb_nnn_qc
      INTEGER             :: i_stat_wetb_nnn_ipr
      INTEGER             :: i_stat_wetb_ntotal

      REAL                :: f_stat_wspd_min_ms
      REAL                :: f_stat_wspd_max_ms
      INTEGER             :: i_stat_wspd_nnn_data
      INTEGER             :: i_stat_wspd_nnn_stn
      INTEGER             :: i_stat_wspd_nnn_qc
      INTEGER             :: i_stat_wspd_nnn_ipr
      INTEGER             :: i_stat_wspd_ntotal

      REAL                :: f_stat_wdir_min_deg
      REAL                :: f_stat_wdir_max_deg
      INTEGER             :: i_stat_wdir_nnn_data
      INTEGER             :: i_stat_wdir_nnn_stn
      INTEGER             :: i_stat_wdir_nnn_qc
      INTEGER             :: i_stat_wdir_nnn_ipr
      INTEGER             :: i_stat_wdir_ntotal

      REAL                :: f_stat_ppt_min_mm
      REAL                :: f_stat_ppt_max_mm
      INTEGER             :: i_stat_ppt_nnn_data
      INTEGER             :: i_stat_ppt_nnn_stn
      INTEGER             :: i_stat_ppt_nnn_qc
      INTEGER             :: i_stat_ppt_nnn_ipr
      INTEGER             :: i_stat_ppt_ntotal

c     Vectors for qc & ipr
      CHARACTER(LEN=8)    :: st_sd_pres_stn(l_mlent)
      CHARACTER(LEN=8)    :: st_sd_airt_stn(l_mlent)
      CHARACTER(LEN=8)    :: st_sd_wetb_stn(l_mlent)
      CHARACTER(LEN=8)    :: st_sd_wspd_stn(l_mlent)
      CHARACTER(LEN=8)    :: st_sd_wdir_stn(l_mlent)
      CHARACTER(LEN=8)    :: st_sd_ppt_stn(l_mlent)

      CHARACTER(LEN=2)    :: st_sd_pres_qc(l_mlent)
      CHARACTER(LEN=2)    :: st_sd_airt_qc(l_mlent)
      CHARACTER(LEN=2)    :: st_sd_wetb_qc(l_mlent)
      CHARACTER(LEN=2)    :: st_sd_wspd_qc(l_mlent)
      CHARACTER(LEN=2)    :: st_sd_wdir_qc(l_mlent)
      CHARACTER(LEN=2)    :: st_sd_ppt_qc(l_mlent)

      CHARACTER(LEN=2)    :: st_sd_pres_ipr(l_mlent)
      CHARACTER(LEN=2)    :: st_sd_airt_ipr(l_mlent)
      CHARACTER(LEN=2)    :: st_sd_wetb_ipr(l_mlent)
      CHARACTER(LEN=2)    :: st_sd_wspd_ipr(l_mlent)
      CHARACTER(LEN=2)    :: st_sd_wdir_ipr(l_mlent)
      CHARACTER(LEN=2)    :: st_sd_ppt_ipr(l_mlent)

      CHARACTER(LEN=50)   :: s_exp_nameline 
      CHARACTER(LEN=50)   :: s_exp_location 
      CHARACTER(LEN=50)   :: s_exp_height 
c      CHARACTER(LEN=20)   :: s_location 

      CHARACTER(LEN=150)  :: s_metadata1,s_metadata2,s_metadata3

c     String conversions for stat table

      CHARACTER(LEN=8)    :: s_stat_airt_min_k
      CHARACTER(LEN=8)    :: s_stat_airt_max_k
      CHARACTER(LEN=8)    :: s_stat_airt_nnn_data

      REAL                :: f_test
      INTEGER             :: i_test
      CHARACTER(LEN=8)    :: s_test
c************************************************************************
c      print*,'just inside export_format_data'

      s_export_styear =TRIM(st_sd_year(1))
      s_export_enyear =TRIM(st_sd_year(j_sd))

c      print*,'j_sd=',j_sd
c      print*,'s_export_styear=',s_export_styear
c      print*,'s_export_enyear=',s_export_enyear
c      print*,'s_export_stid=',s_export_stid
c      print*,'s_export_stnname=',s_export_stnname
c      print*,'s_export_lat', s_export_lat
c      print*,'s_export_lon', s_export_lon
c      print*,'s_export_hght',s_export_hght
c************************************************************************
c     Find min/max/number of data

c     PRES
      f_stat_pres_min_hpa  =+1000.0
      f_stat_pres_max_hpa  =-1000.0
      i_stat_pres_nnn_data =0
      i_stat_pres_nnn_stn  =0
      i_stat_pres_nnn_qc   =0
      i_stat_pres_nnn_ipr  =0
      i_stat_pres_ntotal   =0

      DO i=1,j_sd 

c      Initialize IPR & QC flag
       st_sd_pres_stn(i)='X       '
       st_sd_pres_qc(i) ='XX'
       st_sd_pres_ipr(i)='XX'

       IF (ft_sd_pres_hpa(i).NE.f_ndflag) THEN 
        f_stat_pres_min_hpa=MIN(f_stat_pres_min_hpa,ft_sd_pres_hpa(i))
        f_stat_pres_max_hpa=MAX(f_stat_pres_max_hpa,ft_sd_pres_hpa(i))
        i_stat_pres_nnn_data    =i_stat_pres_nnn_data+1

c       Set IPR & QC flags here
        st_sd_pres_stn(i) ='83-'//s_export_stid
        st_sd_pres_qc(i)  ='0 '
        st_sd_pres_ipr(i) ='0 '

c       Counters for quadruplet
        i_stat_pres_nnn_stn  =i_stat_pres_nnn_stn+1
        i_stat_pres_nnn_qc   =i_stat_pres_nnn_qc +1
        i_stat_pres_nnn_ipr  =i_stat_pres_nnn_ipr+1

       ENDIF
       i_stat_pres_ntotal =i_stat_pres_ntotal+1
      ENDDO

      print*,'f_stat_pres_min_hpa', f_stat_pres_min_hpa
      print*,'f_stat_pres_max_hpa', f_stat_pres_max_hpa
      print*,'i_stat_pres_nnn_data',i_stat_pres_nnn_data
      print*,'i_stat_pres_ntotal',  i_stat_pres_ntotal
c*****
c     AIRT 

      f_stat_airt_min_k   =+1000.0
      f_stat_airt_max_k   =-1000.0
      i_stat_airt_nnn_data=0
      i_stat_airt_nnn_stn =0
      i_stat_airt_nnn_qc  =0
      i_stat_airt_nnn_ipr =0
      i_stat_airt_ntotal  =0

      DO i=1,j_sd 

c      Initialize IPR & QC flag
       st_sd_airt_stn(i)='X       '
       st_sd_airt_ipr(i)='XX'
       st_sd_airt_qc(i) ='XX'

       IF (ft_sd_airt_k(i).NE.f_ndflag) THEN 
        f_stat_airt_min_k   =MIN(f_stat_airt_min_k,ft_sd_airt_k(i))
        f_stat_airt_max_k   =MAX(f_stat_airt_max_k,ft_sd_airt_k(i))
        i_stat_airt_nnn_data=i_stat_airt_nnn_data+1

c       Set IPR & QC flags here
        st_sd_airt_stn(i) ='83-'//s_export_stid
        st_sd_airt_ipr(i)='0 '
        st_sd_airt_qc(i) ='0 '

c       Counters for quadruplet
        i_stat_airt_nnn_stn  =i_stat_airt_nnn_stn+1
        i_stat_airt_nnn_qc   =i_stat_airt_nnn_qc +1
        i_stat_airt_nnn_ipr  =i_stat_airt_nnn_ipr+1

       ENDIF
       i_stat_airt_ntotal =i_stat_airt_ntotal+1
      ENDDO

      print*,'f_stat_airt_min_k', f_stat_airt_min_k
      print*,'f_stat_airt_max_k', f_stat_airt_max_k
      print*,'i_stat_airt_nnn_data',i_stat_airt_nnn_data
      print*,'i_stat_airt_ntotal',i_stat_airt_ntotal
c*****
c     WETB

      f_stat_wetb_min_k   =+1000.0
      f_stat_wetb_max_k   =-1000.0
      i_stat_wetb_nnn_data=0
      i_stat_wetb_nnn_stn =0
      i_stat_wetb_nnn_qc  =0
      i_stat_wetb_nnn_ipr =0
      i_stat_wetb_ntotal  =0

      DO i=1,j_sd 

c      Initialize IPR & QC flag
       st_sd_wetb_stn(i)='X       '
       st_sd_wetb_ipr(i)='XX'
       st_sd_wetb_qc(i) ='XX'

       IF (ft_sd_wetb_k(i).NE.f_ndflag) THEN 
        f_stat_wetb_min_k   =MIN(f_stat_wetb_min_k,ft_sd_airt_k(i))
        f_stat_wetb_max_k   =MAX(f_stat_wetb_max_k,ft_sd_airt_k(i))
        i_stat_wetb_nnn_data=i_stat_wetb_nnn_data+1

c       Set IPR & QC flags here
        st_sd_wetb_stn(i) ='83-'//s_export_stid
        st_sd_wetb_ipr(i)='0 '
        st_sd_wetb_qc(i) ='0 '

c       Counters for quadruplet
        i_stat_wetb_nnn_stn  =i_stat_wetb_nnn_stn+1
        i_stat_wetb_nnn_qc   =i_stat_wetb_nnn_qc +1
        i_stat_wetb_nnn_ipr  =i_stat_wetb_nnn_ipr+1

       ENDIF
       i_stat_wetb_ntotal =i_stat_wetb_ntotal+1
      ENDDO

      print*,'f_stat_wetb_min_k',   f_stat_wetb_min_k
      print*,'f_stat_wetb_max_k',   f_stat_wetb_max_k
      print*,'i_stat_wetb_nnn_data',i_stat_wetb_nnn_data
      print*,'i_stat_wetb_ntotal',  i_stat_wetb_ntotal
c*****
c     WSPD

      f_stat_wspd_min_ms   =+1000.0
      f_stat_wspd_max_ms   =-1000.0
      i_stat_wspd_nnn_data =0
      i_stat_wspd_nnn_stn  =0
      i_stat_wspd_nnn_qc   =0
      i_stat_wspd_nnn_ipr  =0
      i_stat_wspd_ntotal   =0

      DO i=1,j_sd 

c      Initialize IPR & QC flag
       st_sd_wspd_stn(i)='X       '
       st_sd_wspd_ipr(i)='XX'
       st_sd_wspd_qc(i) ='XX'

       IF (ft_sd_wspd_ms(i).NE.f_ndflag) THEN 
        f_stat_wspd_min_ms   =MIN(f_stat_wspd_min_ms,ft_sd_wspd_ms(i))
        f_stat_wspd_max_ms   =MAX(f_stat_wspd_max_ms,ft_sd_wspd_ms(i))
        i_stat_wspd_nnn_data =i_stat_wspd_nnn_data+1

c       Set IPR & QC flags here
        st_sd_wspd_stn(i) ='83-'//s_export_stid
        st_sd_wspd_ipr(i)='0 '
        st_sd_wspd_qc(i) ='0 '

c       Counters for quadruplet
        i_stat_wspd_nnn_stn  =i_stat_wspd_nnn_stn+1
        i_stat_wspd_nnn_qc   =i_stat_wspd_nnn_qc +1
        i_stat_wspd_nnn_ipr  =i_stat_wspd_nnn_ipr+1

       ENDIF
       i_stat_wspd_ntotal =i_stat_wspd_ntotal+1
      ENDDO

      print*,'f_stat_wspd_min_ms',  f_stat_wspd_min_ms
      print*,'f_stat_wspd_max_ms',  f_stat_wspd_max_ms
      print*,'i_stat_wspd_nnn_data',i_stat_wspd_nnn_data
      print*,'i_stat_wspd_ntotal',  i_stat_wspd_ntotal
c*****
c     WDIR

      f_stat_wdir_min_deg =+1000.0
      f_stat_wdir_max_deg =-1000.0
      i_stat_wdir_nnn_data=0
      i_stat_wspd_nnn_stn =0
      i_stat_wspd_nnn_qc  =0
      i_stat_wspd_nnn_ipr =0
      i_stat_wdir_ntotal  =0

      DO i=1,j_sd 

c      Initialize IPR & QC flag
       st_sd_wdir_stn(i)='X       '
       st_sd_wdir_ipr(i)='XX'
       st_sd_wdir_qc(i) ='XX'

       IF (ft_sd_wdir_deg(i).NE.f_ndflag) THEN 
        f_stat_wdir_min_deg =MIN(f_stat_wdir_min_deg,ft_sd_wdir_deg(i))
        f_stat_wdir_max_deg =MAX(f_stat_wdir_max_deg,ft_sd_wdir_deg(i))
        i_stat_wdir_nnn_data=i_stat_wdir_nnn_data+1

c       Set IPR & QC flags here
        st_sd_wdir_stn(i) ='83-'//s_export_stid
        st_sd_wdir_ipr(i)='0 '
        st_sd_wdir_qc(i) ='0 '

c       Counters for quadruplet
        i_stat_wdir_nnn_stn  =i_stat_wdir_nnn_stn+1
        i_stat_wdir_nnn_qc   =i_stat_wdir_nnn_qc +1
        i_stat_wdir_nnn_ipr  =i_stat_wdir_nnn_ipr+1

       ENDIF
       i_stat_wdir_ntotal =i_stat_wdir_ntotal+1
      ENDDO

      print*,'f_stat_wdir_min_deg', f_stat_wdir_min_deg
      print*,'f_stat_wdir_max_deg', f_stat_wdir_max_deg
      print*,'i_stat_wdir_nnn_data',i_stat_wdir_nnn_data
      print*,'i_stat_wdir_ntotal',  i_stat_wdir_ntotal
c*****
c     PPT

      f_stat_ppt_min_mm  =+1000.0
      f_stat_ppt_max_mm  =-1000.0
      i_stat_ppt_nnn_data=0
      i_stat_ppt_nnn_stn =0
      i_stat_ppt_nnn_qc  =0
      i_stat_ppt_nnn_ipr =0
      i_stat_ppt_ntotal  =0

      DO i=1,j_sd 

c      Initialize IPR & QC flag
       st_sd_ppt_stn(i)='X       '
       st_sd_ppt_ipr(i)='XX'
       st_sd_ppt_qc(i) ='XX'

       IF (ft_sd_ppt_mm(i).NE.f_ndflag) THEN 
        f_stat_ppt_min_mm  =MIN(f_stat_ppt_min_mm,ft_sd_ppt_mm(i))
        f_stat_ppt_max_mm  =MAX(f_stat_ppt_max_mm,ft_sd_ppt_mm(i))
        i_stat_ppt_nnn_data=i_stat_ppt_nnn_data+1

c       Set IPR & QC flags here
        st_sd_ppt_stn(i) ='83-'//s_export_stid
        st_sd_ppt_ipr(i)='0 '
        st_sd_ppt_qc(i) ='0 '

c       Counters for quadruplet
        i_stat_ppt_nnn_stn  =i_stat_ppt_nnn_stn+1
        i_stat_ppt_nnn_qc   =i_stat_ppt_nnn_qc +1
        i_stat_ppt_nnn_ipr  =i_stat_ppt_nnn_ipr+1

       ENDIF
       i_stat_ppt_ntotal =i_stat_ppt_ntotal+1
      ENDDO

      print*,'f_stat_ppt_min_mm',  f_stat_ppt_min_mm
      print*,'f_stat_ppt_max_mm',  f_stat_ppt_max_mm
      print*,'i_stat_ppt_nnn_data',i_stat_ppt_nnn_data
      print*,'i_stat_ppt_ntotal',  i_stat_ppt_ntotal
c*****
c************************************************************************
c     Convert stat to string

c     AIR TEMPERATURE
      f_test=f_stat_airt_min_k
      WRITE(s_test,'(f8.2)') f_test
      s_stat_airt_min_k=s_test

      f_test=f_stat_airt_max_k
      WRITE(s_test,'(f8.2)') f_test
      s_stat_airt_max_k=s_test

      i_test=i_stat_airt_nnn_data
      WRITE(s_test,'(i8)') i_test
      s_stat_airt_nnn_data=s_test

      print*,'s_stat_airt_min_k=',s_stat_airt_min_k
      print*,'s_stat_airt_max_k=',s_stat_airt_max_k
      print*,'s_stat_airt_nnn=',  s_stat_airt_nnn_data

c     WET_BULB

c************************************************************************
c     Read parameters for export

      s_exp_nameline=TRIM(s_export_stid)//','//TRIM(s_export_stnname)
      s_exp_location=TRIM(ADJUSTL(s_export_lat))//','//
     +  TRIM(ADJUSTL(s_export_lon))
      s_exp_height=TRIM(ADJUSTL(s_export_hght))

      s_metadata1=
     + 'ftp://ftp-cdc.dwd.de/pub/CDC/observations_germany/climate/'// 
     + 'subdaily/standard_format/'//
     + 'DESCRIPTION_obsgermany_climate_subdaily_standard_format_en.pdf'
c     +  'DESCRIPTION_obsgermany_climate_monthly_kl_historical_en.pdf'
c      s_metadata2=
c     +   'Metadaten_Parameter_klima_monat_'//s_stnnum_use//
c     +   '.html'
cc     +  'BESCHREIBUNG_obsgermany_climate_monthly_kl_historical_de.pdf'
c      s_metadata3=
c     +   'dwd_'//s_stnnum_use//'_mon_metadata.dat'
cc     +  'BESCHREIBUNG_obsgermany_climate_monthly_kl_historical_de.pdf'

c************************************************************************
c     Create formatted file
      OPEN(UNIT=1,
     +  FILE=TRIM(ADJUSTL(s_directory_output))//'data_'//
     +     TRIM(s_export_stid)//'_'//TRIM(s_export_stnname)//'.dat',
     +  FORM='formatted',
     +  STATUS='NEW',ACTION='WRITE')

      WRITE(UNIT=1,FMT=1000) 'station_id,station_name  ',
     +  s_exp_nameline
1000  FORMAT(t1,a25,t25,a50) 
      WRITE(UNIT=1,FMT=1002) 'location                 ',
     +  s_exp_location
1002  FORMAT(t1,a25,t25,a50) 
      WRITE(UNIT=1,FMT=1004) 'height                   ',
     +  s_exp_height
1004  FORMAT(t1,a25,t25,a50) 
      WRITE(UNIT=1,FMT=1006) 'start_date               ',
     +  TRIM(ADJUSTL(s_export_styear))
      WRITE(UNIT=1,FMT=1006) 'end_date                 ',
     +  TRIM(ADJUSTL(s_export_enyear))
1006  FORMAT(t1,a25,t25,a4)

      WRITE(UNIT=1,FMT=1008) 'metadata1                ',
     +  s_metadata1
c      WRITE(UNIT=1,FMT=1008) 'metadata2                ',
c     +  s_metadata2
c      WRITE(UNIT=1,FMT=1008) 'metadata3                ',
c     +  s_metadata3
1008  FORMAT(t1,a25,t25,a150)

      WRITE(UNIT=1,FMT=1010) '                         '
1010  FORMAT(t1,a50) 

c     Start stat table
c      print*,'s_stat_airt_min_k=',s_stat_airt_min_k
      


      CLOSE(UNIT=1)
c************************************************************************
      RETURN
      END