c     Program to process Ireland subdaily info
c     AJ_Kettle, Nov20/2017

c************************************************************************
c     List of subroutines
 
c     import_list_names           need z_filelist.dat
c     readin_metadata             need ireland_subday_metadata2.txt
c     create_basis_set
c     get_daydata
c     clean_daydata
c     convert_var_day
c     find_statf_ei_day
c     calc_mon_total2_ei
c     find_month_airt2
c     strip_gaps_month
c     export_header_day2          sent to: D:\Export\Meteireann_daily_header
c     export_observation_day3     sent to: D:\Export\Meteireann_daily_observation
c     export_header_month2        sent to: D:\Export\Meteireann_monthly_header
c     export_observation_month3   sent to: D:\Export\Meteireann_monthly_observation
c     export_archstats            create: export_stats_day.dat
c     export_archstats            create: export_stats_mon.dat

c************************************************************************
c     print*,'7  SNClaremorris(Auto): 1 missing hour/time stamp Aug 2011'
c     print*,'   SNClaremorris(Manual): all missing hour/time stamp'
c     print*,'11 SNDublinApt:           all missing hour/time stamp'
c     print*,'17 SNKilkenny:            all missing hour/time stamp'
c     print*,'18 SNKnockAirport:        all missing hour/time stamp'
c     print*,'21 SNMalinhead(Manual):   all missing hour/time stamp'
c     print*,'26 SNMullingar(Manual):   all missing hour/time stamp'
c     print*,'30 SNRochesPoint(Manual): all missing hour/time stamp'
c     print*,'32 SNRosslare(Manual):    all missing hour/time stamp'
c     print*,'33 SNShannonAirport:      all missing hour/time stamp'
c     print*,'35 SNValentia(Manual):    all missing hour/time stamp'

c2-------10--------20--------30--------40--------50--------60--------70--------80
      IMPLICIT NONE
c************************************************************************
c     Declare variables

      REAL                :: f_time_st,f_time_en,f_deltime_s
      CHARACTER(LEN=8)    :: s_date
      CHARACTER(LEN=10)   :: s_time
      CHARACTER(LEN=5)    :: s_zone
      INTEGER             :: i_values(8)

      INTEGER             :: i,j,k,ii,jj,kk
      INTEGER             :: io

      INTEGER             :: i_ndflag
      REAL                :: f_ndflag
      DOUBLE PRECISION    :: d_ndflag
      CHARACTER(LEN=4)    :: s_ndflag 

      CHARACTER(LEN=300)  :: s_directory
      CHARACTER(LEN=300)  :: s_filename
      CHARACTER(LEN=300)  :: s_filename_test
      CHARACTER(LEN=300)  :: s_pathandname
      CHARACTER(LEN=300)  :: s_directory_output

      INTEGER, PARAMETER  :: l_nfile=50
      CHARACTER(LEN=300)  :: s_filelist(l_nfile)
      INTEGER             :: l_nfile_use

      INTEGER             :: l_meta
      CHARACTER(LEN=30)   :: s_meta_namelist(l_nfile)
      CHARACTER(LEN=4)    :: s_meta_fileid(l_nfile)
      CHARACTER(LEN=4)    :: s_meta_alt_m(l_nfile)
      CHARACTER(LEN=7)    :: s_meta_lat(l_nfile)
      CHARACTER(LEN=7)    :: s_meta_lon(l_nfile)
      CHARACTER(LEN=17)   :: s_meta_wigos(l_nfile)

      CHARACTER(LEN=30)   :: s_basis_nameshort(l_nfile)
      CHARACTER(LEN=30)   :: s_basis_namelist(l_nfile)
      CHARACTER(LEN=4)    :: s_basis_fileid(l_nfile)
      CHARACTER(LEN=4)    :: s_basis_alt_m(l_nfile)
      CHARACTER(LEN=7)    :: s_basis_lat(l_nfile)
      CHARACTER(LEN=7)    :: s_basis_lon(l_nfile)
      CHARACTER(LEN=17)   :: s_basis_wigos(l_nfile)

      INTEGER, PARAMETER  :: l_mlent    =50000
      INTEGER, PARAMETER  :: l_mlent_mon=5000

c     preliminary data
      INTEGER             :: l_datalines_pre
      CHARACTER(LEN=8)    :: s_vec_stnnum_pre(l_mlent)    
      CHARACTER(LEN=10)   :: s_vec_date_pre(l_mlent)
      CHARACTER(LEN=8)    :: s_vec_time_pre(l_mlent)
      REAL                :: f_vec_rain_mm_pre(l_mlent)        
      REAL                :: f_vec_maxdy_c_pre(l_mlent)         
      REAL                :: f_vec_mindy_c_pre(l_mlent)         

c     data after correction for duplicates
      INTEGER             :: l_datalines
      CHARACTER(LEN=8)    :: s_vec_stnnum(l_mlent)    
      CHARACTER(LEN=10)   :: s_vec_date(l_mlent)
      CHARACTER(LEN=8)    :: s_vec_time(l_mlent)
      REAL                :: f_vec_rain_mm(l_mlent)        
      REAL                :: f_vec_maxdy_c(l_mlent)         
      REAL                :: f_vec_mindy_c(l_mlent)         

c     Derived variables
      REAL                :: f_vec_airt_k_pre(l_mlent) 
      REAL                :: f_vec_airt_k(l_mlent) 
      REAL                :: f_vec_maxdy_k(l_mlent)         
      REAL                :: f_vec_mindy_k(l_mlent)         

c     Basic stats - 3 variables
      REAL                :: f_stat_rain_mm_ngd
      REAL                :: f_stat_rain_mm_nbd
      REAL                :: f_stat_rain_mm_avg
      REAL                :: f_stat_rain_mm_min
      REAL                :: f_stat_rain_mm_max

      REAL                :: f_stat_maxdy_c_ngd
      REAL                :: f_stat_maxdy_c_nbd
      REAL                :: f_stat_maxdy_c_avg
      REAL                :: f_stat_maxdy_c_min
      REAL                :: f_stat_maxdy_c_max

      REAL                :: f_stat_mindy_c_ngd
      REAL                :: f_stat_mindy_c_nbd
      REAL                :: f_stat_mindy_c_avg
      REAL                :: f_stat_mindy_c_min
      REAL                :: f_stat_mindy_c_max

      REAL                :: f_stat_airt_k_ngd
      REAL                :: f_stat_airt_k_nbd
      REAL                :: f_stat_airt_k_avg
      REAL                :: f_stat_airt_k_min
      REAL                :: f_stat_airt_k_max

c     Archives of stats - 3 variables + 1 derived
      CHARACTER(LEN=8)    :: s_arch_stnnum(l_nfile) 

      REAL                :: f_arch_rain_ngd_mm(l_nfile)     
      REAL                :: f_arch_rain_nbd_mm(l_nfile)     
      REAL                :: f_arch_rain_avg_mm(l_nfile)     
      REAL                :: f_arch_rain_min_mm(l_nfile)     
      REAL                :: f_arch_rain_max_mm(l_nfile)     

      REAL                :: f_arch_maxdy_ngd_c(l_nfile)          
      REAL                :: f_arch_maxdy_nbd_c(l_nfile)          
      REAL                :: f_arch_maxdy_avg_c(l_nfile)          
      REAL                :: f_arch_maxdy_min_c(l_nfile)          
      REAL                :: f_arch_maxdy_max_c(l_nfile)                   

      REAL                :: f_arch_mindy_ngd_c(l_nfile)
      REAL                :: f_arch_mindy_nbd_c(l_nfile)
      REAL                :: f_arch_mindy_avg_c(l_nfile)
      REAL                :: f_arch_mindy_min_c(l_nfile)
      REAL                :: f_arch_mindy_max_c(l_nfile)

      REAL                :: f_arch_airt_ngd_k(l_nfile)
      REAL                :: f_arch_airt_nbd_k(l_nfile)
      REAL                :: f_arch_airt_avg_k(l_nfile)
      REAL                :: f_arch_airt_min_k(l_nfile)
      REAL                :: f_arch_airt_max_k(l_nfile)
c***
c     Monthly values
      INTEGER             :: l_mon_maxdy_c
      CHARACTER(LEN=2)    :: s_monrec_maxdy_c_year(l_mlent_mon)
      CHARACTER(LEN=4)    :: s_monrec_maxdy_c_month(l_mlent_mon)
      REAL                :: f_monrec_maxdy_c_nseconds(l_mlent_mon)
      CHARACTER(LEN=8)    :: s_monrec_maxdy_c_stime(l_mlent_mon)
      CHARACTER(LEN=5)    :: s_monrec_maxdy_c_timezone5(l_mlent_mon)
      REAL                :: f_monrec_avg_maxdy_c(l_mlent_mon)
      REAL                :: f_monrec_tot_maxdy_c(l_mlent_mon)  
      REAL                :: f_monrec_max_maxdy_c(l_mlent_mon)
      REAL                :: f_monrec_min_maxdy_c(l_mlent_mon)
      INTEGER             :: i_monrec_maxdy_c_flag(l_mlent_mon)

      INTEGER             :: l_mon_mindy_c
      CHARACTER(LEN=2)    :: s_monrec_mindy_c_year(l_mlent_mon)
      CHARACTER(LEN=4)    :: s_monrec_mindy_c_month(l_mlent_mon)
      REAL                :: f_monrec_mindy_c_nseconds(l_mlent_mon)
      CHARACTER(LEN=8)    :: s_monrec_mindy_c_stime(l_mlent_mon)
      CHARACTER(LEN=5)    :: s_monrec_mindy_c_timezone5(l_mlent_mon)
      REAL                :: f_monrec_avg_mindy_c(l_mlent_mon)
      REAL                :: f_monrec_tot_mindy_c(l_mlent_mon)  
      REAL                :: f_monrec_max_mindy_c(l_mlent_mon)
      REAL                :: f_monrec_min_mindy_c(l_mlent_mon)
      INTEGER             :: i_monrec_mindy_c_flag(l_mlent_mon)

      INTEGER             :: l_mon_maxdy_k
      CHARACTER(LEN=2)    :: s_monrec_maxdy_k_year(l_mlent_mon)
      CHARACTER(LEN=4)    :: s_monrec_maxdy_k_month(l_mlent_mon)
      REAL                :: f_monrec_maxdy_k_nseconds(l_mlent_mon)
      CHARACTER(LEN=8)    :: s_monrec_maxdy_k_stime(l_mlent_mon)
      CHARACTER(LEN=5)    :: s_monrec_maxdy_k_timezone5(l_mlent_mon)
      REAL                :: f_monrec_avg_maxdy_k(l_mlent_mon)
      REAL                :: f_monrec_tot_maxdy_k(l_mlent_mon)  
      REAL                :: f_monrec_max_maxdy_k(l_mlent_mon)
      REAL                :: f_monrec_min_maxdy_k(l_mlent_mon)
      INTEGER             :: i_monrec_maxdy_k_flag(l_mlent_mon)

      INTEGER             :: l_mon_mindy_k
      CHARACTER(LEN=2)    :: s_monrec_mindy_k_year(l_mlent_mon)
      CHARACTER(LEN=4)    :: s_monrec_mindy_k_month(l_mlent_mon)
      REAL                :: f_monrec_mindy_k_nseconds(l_mlent_mon)
      CHARACTER(LEN=8)    :: s_monrec_mindy_k_stime(l_mlent_mon)
      CHARACTER(LEN=5)    :: s_monrec_mindy_k_timezone5(l_mlent_mon)
      REAL                :: f_monrec_avg_mindy_k(l_mlent_mon)
      REAL                :: f_monrec_tot_mindy_k(l_mlent_mon)  
      REAL                :: f_monrec_max_mindy_k(l_mlent_mon)
      REAL                :: f_monrec_min_mindy_k(l_mlent_mon)
      INTEGER             :: i_monrec_mindy_k_flag(l_mlent_mon)

      INTEGER             :: l_mon_rain_mm
      CHARACTER(LEN=2)    :: s_monrec_rain_mm_month(l_mlent_mon)
      CHARACTER(LEN=4)    :: s_monrec_rain_mm_year(l_mlent_mon)
      REAL                :: f_monrec_rain_mm_nseconds(l_mlent_mon)
      CHARACTER(LEN=8)    :: s_monrec_rain_mm_stime(l_mlent_mon)
      CHARACTER(LEN=5)    :: s_monrec_rain_mm_timezone5(l_mlent_mon)
      REAL                :: f_monrec_avg_rain_mm(l_mlent_mon)
      REAL                :: f_monrec_tot_rain_mm(l_mlent_mon)
      REAL                :: f_monrec_max_rain_mm(l_mlent_mon)
      REAL                :: f_monrec_min_rain_mm(l_mlent_mon)
      INTEGER             :: i_monrec_rain_mm_flag(l_mlent_mon)

      INTEGER             :: l_mon_airt_c
      CHARACTER(LEN=2)    :: s_monrec_airt_c_year(l_mlent_mon)
      CHARACTER(LEN=4)    :: s_monrec_airt_c_month(l_mlent_mon)
      REAL                :: f_monrec_airt_c_nseconds(l_mlent_mon)
      CHARACTER(LEN=8)    :: s_monrec_airt_c_stime(l_mlent_mon)
      CHARACTER(LEN=5)    :: s_monrec_airt_c_timezone5(l_mlent_mon)
      REAL                :: f_monrec_avg_airt_c(l_mlent_mon)
      INTEGER             :: i_monrec_airt_c_flag(l_mlent_mon)

      REAL                :: f_monrec_airt_c(l_mlent_mon)
      REAL                :: f_monrec_airt_k(l_mlent_mon)

c     Declare common vectors
      INTEGER             :: l_moncom
      CHARACTER(LEN=2)    :: s_moncom_month(l_mlent_mon)
      CHARACTER(LEN=4)    :: s_moncom_year(l_mlent_mon)
      REAL                :: f_moncom_nseconds(l_mlent_mon)
      CHARACTER(LEN=8)    :: s_moncom_stime(l_mlent_mon)
      CHARACTER(LEN=5)    :: s_moncom_timezone5(l_mlent_mon)

      REAL                :: f_moncom_max_maxdy_c(l_mlent_mon)
      REAL                :: f_moncom_min_mindy_c(l_mlent_mon)
      REAL                :: f_moncom_max_maxdy_k(l_mlent_mon)
      REAL                :: f_moncom_min_mindy_k(l_mlent_mon)
      REAL                :: f_moncom_tot_rain_mm(l_mlent_mon)
      REAL                :: f_moncom_airt_c(l_mlent_mon)
      REAL                :: f_moncom_airt_k(l_mlent_mon)

c      INTEGER             :: l_mon_airt
c      CHARACTER(LEN=2)    :: s_monrec_airt_month(l_mlent_mon)
c      CHARACTER(LEN=4)    :: s_monrec_airt_year(l_mlent_mon)
c      REAL                :: f_monrec_airt_k(l_mlent_mon)
c      INTEGER             :: i_monrec_airt_flag(l_mlent_mon)
c***
c     Statistics of monthly values
      REAL                :: f_statmon_rain_mm_ngd
      REAL                :: f_statmon_rain_mm_nbd
      REAL                :: f_statmon_rain_mm_avg
      REAL                :: f_statmon_rain_mm_min
      REAL                :: f_statmon_rain_mm_max

      REAL                :: f_statmon_airt_k_ngd
      REAL                :: f_statmon_airt_k_nbd
      REAL                :: f_statmon_airt_k_avg
      REAL                :: f_statmon_airt_k_min
      REAL                :: f_statmon_airt_k_max

c     Statistics of 2 month variables 
      REAL                :: f_archmon_rain_ngd_mm(l_nfile)     
      REAL                :: f_archmon_rain_nbd_mm(l_nfile)     
      REAL                :: f_archmon_rain_avg_mm(l_nfile)     
      REAL                :: f_archmon_rain_min_mm(l_nfile)     
      REAL                :: f_archmon_rain_max_mm(l_nfile)     

      REAL                :: f_archmon_airt_ngd_k(l_nfile)
      REAL                :: f_archmon_airt_nbd_k(l_nfile)
      REAL                :: f_archmon_airt_avg_k(l_nfile)
      REAL                :: f_archmon_airt_min_k(l_nfile)
      REAL                :: f_archmon_airt_max_k(l_nfile)

      CHARACTER(LEN=200)  :: s_directory_root
c************************************************************************
c     Find start time    
      CALL CPU_TIME(f_time_st)

c     Find date & time
      CALL DATE_AND_TIME(s_date,s_time,s_zone,i_values)
c************************************************************************
      i_ndflag=-999
      f_ndflag=-999.0
      d_ndflag=-999.0
      s_ndflag='-999'
c************************************************************************
      s_directory='D:\Ireland\Daily\'

      s_directory_output  ='Data_middle/'   !changed 20171013 for UNIX consistency
c************************************************************************
c     Import list of data directories

      s_filename='z_filelist.dat'
      s_pathandname=TRIM(s_directory)//TRIM(s_filename)
      CALL import_list_names(s_pathandname,
     +  l_nfile,
     +  l_nfile_use,s_filelist)

      print*,'l_nfile_use',l_nfile_use
c************************************************************************
c     Read in metadata
      s_filename='ireland_subday_metadata2.txt'
      CALL readin_metadata(s_filename,l_nfile,
     +  l_meta,
     +  s_meta_namelist,s_meta_fileid,s_meta_alt_m,
     +  s_meta_lat,s_meta_lon,s_meta_wigos)

c     Create basis metadata set
      CALL create_basis_set(l_nfile,l_nfile_use,s_filelist,
     +  l_meta,
     +  s_meta_namelist,s_meta_fileid,s_meta_alt_m,
     +  s_meta_lat,s_meta_lon,s_meta_wigos,
     +  s_basis_nameshort,s_basis_namelist,s_basis_fileid,
     +  s_basis_alt_m,s_basis_lat,s_basis_lon,s_basis_wigos)

c************************************************************************
      DO i=1,l_nfile_use
       s_pathandname=TRIM(s_directory)//TRIM(s_filelist(i))

       print*,'s_pathandname=',i,TRIM(s_pathandname)
       CALL get_daydata(s_pathandname,l_mlent,
     +   s_ndflag,i_ndflag,f_ndflag,
     +   l_datalines_pre,s_vec_stnnum_pre,
     +   s_vec_date_pre,s_vec_time_pre,
     +   f_vec_rain_mm_pre,f_vec_maxdy_c_pre,f_vec_mindy_c_pre,
     +   f_vec_airt_k_pre)

c      Eliminate duplicate for Claremorris(Auto)
       s_filename_test='SNClaremorris(Auto)'
       s_filename     =s_filelist(i)

       CALL clean_daydata(l_mlent,s_filename,s_filename_test,
     +   l_datalines_pre,s_vec_stnnum_pre,
     +   s_vec_date_pre,s_vec_time_pre,
     +   f_vec_rain_mm_pre,f_vec_maxdy_c_pre,f_vec_mindy_c_pre,
     +   f_vec_airt_k_pre,

     +   l_datalines,s_vec_stnnum,
     +   s_vec_date,s_vec_time,
     +   f_vec_rain_mm,f_vec_maxdy_c,f_vec_mindy_c,
     +   f_vec_airt_k)

c      Conversion algorithm: convert C to K
       CALL convert_var_day(l_datalines,l_mlent,f_ndflag,
     +   f_vec_maxdy_c,f_vec_mindy_c,
     +   f_vec_maxdy_k,f_vec_mindy_k)

c      print*,'f_vec_rain_mm=',(f_vec_rain_mm(j),j=1,10)
c      print*,'f_vec_maxdy_c=',(f_vec_maxdy_c(j),j=1,10)
c      print*,'f_vec_mindy_c=',(f_vec_mindy_c(j),j=1,10)

c       print*,'s_vec_date=',(s_vec_date(k),k=1,5)
c       print*,'s_vec_time=',(s_vec_time(k),k=1,5)
c       CALL SLEEP(5)
c****
       CALL find_statf_ei_day(l_mlent,l_datalines,f_vec_rain_mm,
     +   f_ndflag,
     +   f_stat_rain_mm_ngd,f_stat_rain_mm_nbd,
     +   f_stat_rain_mm_avg,
     +   f_stat_rain_mm_min,f_stat_rain_mm_max)

       CALL find_statf_ei_day(l_mlent,l_datalines,f_vec_maxdy_c,
     +   f_ndflag,
     +   f_stat_maxdy_c_ngd,f_stat_maxdy_c_nbd,
     +   f_stat_maxdy_c_avg,
     +   f_stat_maxdy_c_min,f_stat_maxdy_c_max)

       CALL find_statf_ei_day(l_mlent,l_datalines,f_vec_mindy_c,
     +   f_ndflag,
     +   f_stat_mindy_c_ngd,f_stat_mindy_c_nbd,
     +   f_stat_mindy_c_avg,
     +   f_stat_mindy_c_min,f_stat_mindy_c_max)

       CALL find_statf_ei_day(l_mlent,l_datalines,f_vec_airt_k,
     +   f_ndflag,
     +   f_stat_airt_k_ngd,f_stat_airt_k_nbd,
     +   f_stat_airt_k_avg,
     +   f_stat_airt_k_min,f_stat_airt_k_max)

c      print*,'stat=',f_stat_airt_k_ngd,f_stat_airt_k_nbd,
c     +   f_stat_airt_k_avg,
c     +   f_stat_airt_k_min,f_stat_airt_k_max
c****
c      Archive metadata
       s_arch_stnnum(i)       =s_vec_stnnum(1) 

c      Archive stats
       f_arch_rain_ngd_mm(i)  =f_stat_rain_mm_ngd         
       f_arch_rain_nbd_mm(i)  =f_stat_rain_mm_nbd        
       f_arch_rain_avg_mm(i)  =f_stat_rain_mm_avg      
       f_arch_rain_min_mm(i)  =f_stat_rain_mm_min       
       f_arch_rain_max_mm(i)  =f_stat_rain_mm_max  

       f_arch_maxdy_ngd_c(i)  =f_stat_maxdy_c_ngd         
       f_arch_maxdy_nbd_c(i)  =f_stat_maxdy_c_nbd    
       f_arch_maxdy_avg_c(i)  =f_stat_maxdy_c_avg      
       f_arch_maxdy_min_c(i)  =f_stat_maxdy_c_min       
       f_arch_maxdy_max_c(i)  =f_stat_maxdy_c_max  

       f_arch_mindy_ngd_c(i)  =f_stat_mindy_c_ngd         
       f_arch_mindy_nbd_c(i)  =f_stat_mindy_c_nbd         
       f_arch_mindy_avg_c(i)  =f_stat_mindy_c_avg      
       f_arch_mindy_min_c(i)  =f_stat_mindy_c_min       
       f_arch_mindy_max_c(i)  =f_stat_mindy_c_max  

       f_arch_airt_ngd_k(i)   =f_stat_airt_k_ngd 
       f_arch_airt_nbd_k(i)   =f_stat_airt_k_nbd 
       f_arch_airt_avg_k(i)   =f_stat_airt_k_avg   
       f_arch_airt_min_k(i)   =f_stat_airt_k_min  
       f_arch_airt_max_k(i)   =f_stat_airt_k_max  
c******
c******
c      Calculate monthly values here
       print*,'f_ndflag=',f_ndflag

c      airt_c_max
       CALL calc_mon_total2_ei(f_ndflag,
     +   l_mlent,l_mlent_mon,l_datalines,
     +   s_vec_date,f_vec_maxdy_c,
     +   l_mon_maxdy_c,
     +   s_monrec_maxdy_c_year,s_monrec_maxdy_c_month,
     +   f_monrec_maxdy_c_nseconds,
     +   s_monrec_maxdy_c_stime,s_monrec_maxdy_c_timezone5,
     +   f_monrec_avg_maxdy_c,f_monrec_tot_maxdy_c,  
     +   f_monrec_max_maxdy_c,f_monrec_min_maxdy_c,
     +   i_monrec_maxdy_c_flag)

       print*,'f_ndflag=',f_ndflag

c      airt_c_min
       CALL calc_mon_total2_ei(f_ndflag,
     +   l_mlent,l_mlent_mon,l_datalines,
     +   s_vec_date,f_vec_mindy_c,
     +   l_mon_mindy_c,
     +   s_monrec_mindy_c_year,s_monrec_mindy_c_month,
     +   f_monrec_mindy_c_nseconds,
     +   s_monrec_mindy_c_stime,s_monrec_mindy_c_timezone5,
     +   f_monrec_avg_mindy_c,f_monrec_tot_mindy_c,  
     +   f_monrec_max_mindy_c,f_monrec_min_mindy_c,
     +   i_monrec_mindy_c_flag)

       print*,'f_ndflag=',f_ndflag

c      airt_k_max
       CALL calc_mon_total2_ei(f_ndflag,
     +   l_mlent,l_mlent_mon,l_datalines,
     +   s_vec_date,f_vec_maxdy_k,
     +   l_mon_maxdy_k,
     +   s_monrec_maxdy_k_year,s_monrec_maxdy_k_month,
     +   f_monrec_maxdy_k_nseconds,
     +   s_monrec_maxdy_k_stime,s_monrec_maxdy_k_timezone5,
     +   f_monrec_avg_maxdy_k,f_monrec_tot_maxdy_k,  
     +   f_monrec_max_maxdy_k,f_monrec_min_maxdy_k,
     +   i_monrec_maxdy_k_flag)

       print*,'f_ndflag=',f_ndflag

c      airt_k_min
       CALL calc_mon_total2_ei(f_ndflag,
     +   l_mlent,l_mlent_mon,l_datalines,
     +   s_vec_date,f_vec_mindy_k,
     +   l_mon_mindy_k,
     +   s_monrec_mindy_k_year,s_monrec_mindy_k_month,
     +   f_monrec_mindy_k_nseconds,
     +   s_monrec_mindy_k_stime,s_monrec_mindy_k_timezone5,
     +   f_monrec_avg_mindy_k,f_monrec_tot_mindy_k,  
     +   f_monrec_max_mindy_k,f_monrec_min_mindy_k,
     +   i_monrec_mindy_k_flag)

       print*,'f_ndflag=',f_ndflag

c      Rain_mm
       CALL calc_mon_total2_ei(f_ndflag,
     +   l_mlent,l_mlent_mon,l_datalines,
     +   s_vec_date,f_vec_rain_mm,
     +   l_mon_rain_mm,
     +   s_monrec_rain_mm_year,s_monrec_rain_mm_month,
     +   f_monrec_rain_mm_nseconds,
     +   s_monrec_rain_mm_stime,s_monrec_rain_mm_timezone5,
     +   f_monrec_avg_rain_mm,f_monrec_tot_rain_mm,  
     +   f_monrec_max_rain_mm,f_monrec_min_rain_mm,
     +   i_monrec_rain_mm_flag)

c      Find monthly average temperature
c       CALL find_month_airt(l_mlent_mon,
c     +   l_mon_maxdy_c,
c     +   s_monrec_maxdy_c_year,s_monrec_maxdy_c_month,
c     +   f_monrec_maxdy_c_nseconds,
c     +   s_monrec_maxdy_c_stime,s_monrec_maxdy_c_timezone5,
c     +   f_monrec_avg_maxdy_c,
c     +   i_monrec_maxdy_c_flag,
c     +   l_mon_mindy_c,
c     +   s_monrec_mindy_c_year,s_monrec_mindy_c_month,
c     +   f_monrec_mindy_c_nseconds,
c     +   s_monrec_mindy_c_stime,s_monrec_mindy_c_timezone5,
c     +   f_monrec_avg_mindy_c,
c     +   i_monrec_mindy_c_flag, 

c     +   l_mon_airt_c,
c     +   s_monrec_airt_c_year,s_monrec_airt_c_month,
c     +   f_monrec_airt_c_nseconds,
c     +   s_monrec_airt_c_stime,s_monrec_mindy_c_timezone5,
c     +   f_monrec_avg_airt_c,
c     +   i_monrec_airt_c_flag)

       CALL find_month_airt2(l_mlent_mon,f_ndflag,
     +   l_mon_maxdy_c,l_mon_mindy_c,l_mon_maxdy_k,l_mon_mindy_k,
     +   f_monrec_avg_maxdy_c,f_monrec_avg_mindy_c,
     +   f_monrec_avg_maxdy_k,f_monrec_avg_mindy_k,
     +   f_monrec_airt_c,f_monrec_airt_k)

c      Find common vector for month variables for export
       CALL strip_gaps_month(l_mlent_mon,f_ndflag,
     +   l_mon_maxdy_c,l_mon_mindy_c,l_mon_maxdy_k,l_mon_mindy_k,
     +   l_mon_rain_mm,
     +   s_monrec_rain_mm_year,s_monrec_rain_mm_month,
     +   f_monrec_rain_mm_nseconds,
     +   s_monrec_rain_mm_stime,s_monrec_rain_mm_timezone5,
     +   f_monrec_max_maxdy_c,f_monrec_min_mindy_c,
     +   f_monrec_max_maxdy_k,f_monrec_min_mindy_k,
     +   f_monrec_tot_rain_mm,
     +   f_monrec_airt_c,f_monrec_airt_k,

     +   l_moncom,
     +   s_moncom_month,s_moncom_year,f_moncom_nseconds,
     +   s_moncom_stime,s_moncom_timezone5,
     +   f_moncom_max_maxdy_c,f_moncom_min_mindy_c,
     +   f_moncom_max_maxdy_k,f_moncom_min_mindy_k,
     +   f_moncom_tot_rain_mm,f_moncom_airt_c,f_moncom_airt_k)

c       CALL into_subroutine(f_ndflag,
c     +   l_mlent,l_mlent_mon,l_datalines,
c     +   s_vec_date,
c     +   f_vec_maxdy_c)

c      Extract unbroken series of month data
c       CALL month_package3(f_ndflag,
c     +   l_mlent,l_mlent_mon,l_datalines,
c     +   s_vec_date,
c     +   f_vec_maxdy_c,f_vec_mindy_c,f_vec_maxdy_k,f_vec_mindy_k,
c     +   f_vec_rain_mm)

c     previous airt-avg calculation
c       CALL calc_mon_value_ei(l_mlent,l_mlent_mon,l_datalines,
c     +   s_vec_date,f_vec_airt_k,
c     +   l_mon_airt,
c     +   s_monrec_airt_year,s_monrec_airt_month,
c     +   f_monrec_airt_k,i_monrec_airt_flag)

c      rain_mm
c       CALL calc_mon_value_ei(l_mlent,l_mlent_mon,l_datalines,
c     +   s_vec_date,f_vec_rain_mm,
c     +   l_mon_rain,
c     +   s_monrec_rain_year,s_monrec_rain_month,
c     +   f_monrec_rain_mm,i_monrec_rain_flag)
c       CALL calc_mon_total_ei(l_mlent,l_mlent_mon,l_datalines,
c     +   s_vec_date,f_vec_rain_mm,
c     +   l_mon_rain,
c     +   s_monrec_rain_year,s_monrec_rain_month,
c     +   f_monrec_common_nseconds,
c     +   s_monrec_common_stime,s_monrec_common_timezone5,
c     +   f_monrec_rain_mm,f_monrec_totrain_mm,i_monrec_rain_flag)
c       CALL calc_mon_total2_ei(l_mlent,l_mlent_mon,l_datalines,
c     +   s_vec_date,f_vec_rain_mm,
c     +   l_mon_rain,
c     +   s_monrec_rain_year,s_monrec_rain_month,
c     +   f_monrec_common_nseconds,
c     +   s_monrec_common_stime,s_monrec_common_timezone5,
c     +   f_monrec_rain_mm,f_monrec_totrain_mm,  
c     +   f_monrec_maxrain_mm,f_monrec_minrain_mm,
c     +   i_monrec_rain_flag)

c      RETURN
c      END

c******
c      Find stats - month (problem with Claremorris - Auto Aug 30 repeated)
       CALL find_statf_ei_day(
     +   l_mlent_mon,l_mon_rain_mm,f_monrec_tot_rain_mm,
     +   f_ndflag,
     +   f_statmon_rain_mm_ngd,f_statmon_rain_mm_nbd,
     +   f_statmon_rain_mm_avg,
     +   f_statmon_rain_mm_min,f_statmon_rain_mm_max)

c       CALL find_statf_ei_day(l_mlent_mon,l_mon_airt,f_monrec_airt_k,
c     +   f_ndflag,
c     +   f_statmon_airt_k_ngd,f_statmon_airt_k_nbd,
c     +   f_statmon_airt_k_avg,
c     +   f_statmon_airt_k_min,f_statmon_airt_k_max)

c      print*,'statmon=',f_statmon_rain_mm_ngd,f_statmon_rain_mm_nbd,
c     +   f_statmon_rain_mm_avg,
c     +   f_statmon_rain_mm_min,f_statmon_rain_mm_max

c      print*,'statmon=',f_statmon_airt_k_ngd,f_statmon_airt_k_nbd,
c     +   f_statmon_airt_k_avg,
c     +   f_statmon_airt_k_min,f_statmon_airt_k_max
c******
c      Archive station stats
       f_archmon_rain_ngd_mm(i) =f_statmon_rain_mm_ngd   
       f_archmon_rain_nbd_mm(i) =f_statmon_rain_mm_nbd  
       f_archmon_rain_avg_mm(i) =f_statmon_rain_mm_avg   
       f_archmon_rain_min_mm(i) =f_statmon_rain_mm_min   
       f_archmon_rain_max_mm(i) =f_statmon_rain_mm_max    

c       f_archmon_airt_ngd_k(i) =f_statmon_airt_k_ngd
c       f_archmon_airt_nbd_k(i) =f_statmon_airt_k_nbd
c       f_archmon_airt_avg_k(i) =f_statmon_airt_k_avg
c       f_archmon_airt_min_k(i) =f_statmon_airt_k_min
c       f_archmon_airt_max_k(i) =f_statmon_airt_k_max
c******
c       GOTO 20

c      Export header table from Met Eireanne stations
c901    s_directory_root='D:\Export\Meteireanne_daily_header\'  
c       CALL export_header_day(f_ndflag,s_directory_root,
c     +  l_datalines,
c     +  s_basis_nameshort(i),s_basis_namelist(i),s_basis_fileid(i),
c     +  s_basis_alt_m(i),s_basis_lat(1),s_basis_lon(1),s_basis_wigos(i),
c     +  l_mlent,
c     +  s_vec_date,s_vec_time,f_vec_rain_mm,f_vec_maxdy_k,f_vec_mindy_k)

901    s_directory_root='D:\Export\Meteireann_daily_header\'  
       CALL export_header_day2(f_ndflag,s_directory_root,
     +  l_datalines,
     +  s_basis_nameshort(i),s_basis_namelist(i),s_basis_fileid(i),
     +  s_basis_alt_m(i),s_basis_lat(1),s_basis_lon(1),s_basis_wigos(i),
     +  l_mlent,
     +  s_vec_date,s_vec_time,f_vec_rain_mm,f_vec_maxdy_k,f_vec_mindy_k)

c      Export observation table from Met Eireanne stations
c902    s_directory_root='D:\Export\Meteireanne_daily_observation\'  
c       CALL export_observation_day(f_ndflag,s_directory_root,
c     +  l_datalines,
c     +  s_basis_nameshort(i),s_basis_namelist(i),s_basis_fileid(i),
c     +  s_basis_alt_m(i),s_basis_lat(1),s_basis_lon(1),s_basis_wigos(i),
c     +  l_mlent,
c     +  s_vec_date,s_vec_time,f_vec_rain_mm,f_vec_maxdy_k,f_vec_mindy_k,
c     +  f_vec_maxdy_c,f_vec_mindy_c)

c      removed Feb14/2018
c902    s_directory_root='D:\Export\Meteireanne_daily_observation\'  
c       CALL export_observation_day2(f_ndflag,s_directory_root,
c     +  l_datalines,
c     +  s_basis_nameshort(i),s_basis_namelist(i),s_basis_fileid(i),
c     +  s_basis_alt_m(i),s_basis_lat(1),s_basis_lon(1),s_basis_wigos(i),
c     +  l_mlent,
c     +  s_vec_date,s_vec_time,f_vec_rain_mm,f_vec_maxdy_k,f_vec_mindy_k,
c     +  f_vec_maxdy_c,f_vec_mindy_c)

c      Implemented Feb14/2018: to create CDM file with 50 columns 
902    s_directory_root='D:\Export\Meteireann_daily_observation\'  
       CALL export_observation_day3(f_ndflag,s_directory_root,
     +  l_datalines,
     +  s_basis_nameshort(i),s_basis_namelist(i),s_basis_fileid(i),
     +  s_basis_alt_m(i),s_basis_lat(1),s_basis_lon(1),s_basis_wigos(i),
     +  l_mlent,
     +  s_vec_date,s_vec_time,f_vec_rain_mm,f_vec_maxdy_k,f_vec_mindy_k,
     +  f_vec_maxdy_c,f_vec_mindy_c)

20    CONTINUE
c******
c       GOTO 20

c      Export header month
903    s_directory_root='D:\Export\Meteireann_monthly_header\'  
c       CALL export_header_month(f_ndflag,s_directory_root,
c     +  l_mon_rain_mm,
c     +  s_basis_nameshort(i),s_basis_namelist(i),s_basis_fileid(i),
c     +  s_basis_alt_m(i),s_basis_lat(1),s_basis_lon(1),s_basis_wigos(i),
c     +  l_mlent_mon,
c     +  s_monrec_rain_mm_year,s_monrec_rain_mm_month,
c     +  f_monrec_rain_mm_nseconds,
c     +  s_monrec_rain_mm_stime,s_monrec_rain_mm_timezone5,
c     +  f_monrec_tot_rain_mm)

       CALL export_header_month2(f_ndflag,s_directory_root,
     +  s_basis_nameshort(i),s_basis_namelist(i),s_basis_fileid(i),
     +  s_basis_alt_m(i),s_basis_lat(1),s_basis_lon(1),s_basis_wigos(i),
     +  l_mlent_mon,l_moncom,
     +   s_moncom_year,s_moncom_month,
     +   f_moncom_nseconds,
     +   s_moncom_stime,s_moncom_timezone5,
     +   f_moncom_max_maxdy_c,f_moncom_min_mindy_c,
     +   f_moncom_max_maxdy_k,f_moncom_min_mindy_k,
     +   f_moncom_tot_rain_mm,f_moncom_airt_c,f_moncom_airt_k)

c      Export observation month
c904    s_directory_root='D:\Export\Meteireanne_monthly_observation\'  
c       CALL export_observation_month(f_ndflag,s_directory_root,
c     +  l_mon_rain_mm,
c     +  s_basis_nameshort(i),s_basis_namelist(i),s_basis_fileid(i),
c     +  s_basis_alt_m(i),s_basis_lat(1),s_basis_lon(1),s_basis_wigos(i),
c     +  l_mlent_mon,
c     +  s_monrec_rain_mm_year,s_monrec_rain_mm_month,
c     +  f_monrec_rain_mm_nseconds,
c     +  s_monrec_rain_mm_stime,s_monrec_rain_mm_timezone5,
c     +  f_monrec_tot_rain_mm)

c904    s_directory_root='D:\Export\Meteireann_monthly_observation\'  
c       CALL export_observation_month2(f_ndflag,s_directory_root,
c     +  s_basis_nameshort(i),s_basis_namelist(i),s_basis_fileid(i),
c     +  s_basis_alt_m(i),s_basis_lat(1),s_basis_lon(1),s_basis_wigos(i),
c     +  l_mlent_mon,l_moncom,
c     +   s_moncom_year,s_moncom_month,
c     +   f_moncom_nseconds,
c     +   s_moncom_stime,s_moncom_timezone5,
c     +   f_moncom_max_maxdy_c,f_moncom_min_mindy_c,
c     +   f_moncom_max_maxdy_k,f_moncom_min_mindy_k,
c     +   f_moncom_tot_rain_mm,f_moncom_airt_c,f_moncom_airt_k)

904    s_directory_root='D:\Export\Meteireann_monthly_observation\'  
       CALL export_observation_month3(f_ndflag,s_directory_root,
     +  s_basis_nameshort(i),s_basis_namelist(i),s_basis_fileid(i),
     +  s_basis_alt_m(i),s_basis_lat(1),s_basis_lon(1),s_basis_wigos(i),
     +  l_mlent_mon,l_moncom,
     +   s_moncom_year,s_moncom_month,
     +   f_moncom_nseconds,
     +   s_moncom_stime,s_moncom_timezone5,
     +   f_moncom_max_maxdy_c,f_moncom_min_mindy_c,
     +   f_moncom_max_maxdy_k,f_moncom_min_mindy_k,
     +   f_moncom_tot_rain_mm,f_moncom_airt_c,f_moncom_airt_k)

c20    CONTINUE
c******
      ENDDO
c************************************************************************
c     Output archived stats to file

      s_filename='export_stats_day.dat'
      CALL export_archstats(s_date,s_directory_output,s_filename,
     +  l_nfile,l_nfile_use,s_filelist,s_arch_stnnum,
     +  f_arch_rain_ngd_mm,f_arch_rain_nbd_mm,    
     +  f_arch_rain_avg_mm,f_arch_rain_min_mm,
     +  f_arch_rain_max_mm,    
     +  f_arch_airt_ngd_k,f_arch_airt_nbd_k,
     +  f_arch_airt_avg_k,f_arch_airt_min_k,
     +  f_arch_airt_max_k)

      s_filename='export_stats_mon.dat'
      CALL export_archstats(s_date,s_directory_output,s_filename,
     +  l_nfile,l_nfile_use,s_filelist,s_arch_stnnum,
     +  f_archmon_rain_ngd_mm,f_archmon_rain_nbd_mm,    
     +  f_archmon_rain_avg_mm,f_archmon_rain_min_mm,
     +  f_archmon_rain_max_mm,    
     +  f_archmon_airt_ngd_k,f_archmon_airt_nbd_k,
     +  f_archmon_airt_avg_k,f_archmon_airt_min_k,
     +  f_archmon_airt_max_k)

c************************************************************************
c     Find end time
      CALL CPU_TIME(f_time_en)

      f_deltime_s=f_time_en-f_time_st
      print*,'f_deltime_s,f_deltime_min=',f_deltime_s,f_deltime_s/60.0      
c************************************************************************
      END