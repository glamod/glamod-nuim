c     Program to process Ireland subdaily info
c     AJ_Kettle, Nov20/2017


c************************************************************************
c     List of subroutines in program

c     import_directory_names2      need D:\Ireland\Hourly\z_filelist.dat
c     readin_metadata_subday       need ireland_subday_metadata1.txt
c     create_basis_set_subday
c     get_data2                    need 36 source files in D:\Ireland\hourly\
c     convert_variables_subday
c     find_statf_ei_hour2
c     export_header_subday2        place into D:\Export\Meteireanne_subdaily_header\
c     export_observation_subday2   place into D:\Export\Meteireanne_subdaily_observation\

c************************************************************************
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
      CHARACTER(LEN=300)  :: s_directory_stn
      CHARACTER(LEN=300)  :: s_filename
      CHARACTER(LEN=300)  :: s_pathandname

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

      INTEGER, PARAMETER  :: l_mlent=800000

      INTEGER             :: l_datalines
      REAL                :: f_vec_airt_c(l_mlent)          !3
      REAL                :: f_vec_rain_mm(l_mlent)         !4
      REAL                :: f_vec_wspd_kt(l_mlent)         !5
      REAL                :: f_vec_slpr_hpa(l_mlent)        !6
      REAL                :: f_vec_sunshine_h(l_mlent)      !7
      REAL                :: f_vec_relh_pc(l_mlent)         !8
      REAL                :: f_vec_cldcov_okta(l_mlent)     !9
      CHARACTER(LEN=10)   :: s_vec_date(l_mlent)
      CHARACTER(LEN=8)    :: s_vec_time(l_mlent)
      CHARACTER(LEN=8)    :: s_vec_stnnum(l_mlent)          !1

c     Converted variables
      REAL                :: f_vec_airt_k(l_mlent)
      REAL                :: f_vec_wspd_ms(l_mlent)

c     Basic stats - 7 variables
      REAL                :: f_stat_airt_c_ngd
      REAL                :: f_stat_airt_c_nbd
      REAL                :: f_stat_airt_c_avg
      REAL                :: f_stat_airt_c_min
      REAL                :: f_stat_airt_c_max

      REAL                :: f_stat_rain_mm_ngd
      REAL                :: f_stat_rain_mm_nbd
      REAL                :: f_stat_rain_mm_avg
      REAL                :: f_stat_rain_mm_min
      REAL                :: f_stat_rain_mm_max

      REAL                :: f_stat_wspd_kt_ngd
      REAL                :: f_stat_wspd_kt_nbd
      REAL                :: f_stat_wspd_kt_avg
      REAL                :: f_stat_wspd_kt_min
      REAL                :: f_stat_wspd_kt_max

      REAL                :: f_stat_slpr_hpa_ngd
      REAL                :: f_stat_slpr_hpa_nbd
      REAL                :: f_stat_slpr_hpa_avg
      REAL                :: f_stat_slpr_hpa_min
      REAL                :: f_stat_slpr_hpa_max

      REAL                :: f_stat_sunshine_h_ngd
      REAL                :: f_stat_sunshine_h_nbd
      REAL                :: f_stat_sunshine_h_avg
      REAL                :: f_stat_sunshine_h_min
      REAL                :: f_stat_sunshine_h_max

      REAL                :: f_stat_relh_pc_ngd
      REAL                :: f_stat_relh_pc_nbd
      REAL                :: f_stat_relh_pc_avg
      REAL                :: f_stat_relh_pc_min
      REAL                :: f_stat_relh_pc_max

      REAL                :: f_stat_cldcov_okta_ngd
      REAL                :: f_stat_cldcov_okta_nbd
      REAL                :: f_stat_cldcov_okta_avg
      REAL                :: f_stat_cldcov_okta_min
      REAL                :: f_stat_cldcov_okta_max

c     Archives of stats - 7 variables
      REAL                :: f_arch_airt_ngd_c(l_nfile)          
      REAL                :: f_arch_airt_avg_c(l_nfile)          
      REAL                :: f_arch_airt_min_c(l_nfile)          
      REAL                :: f_arch_airt_max_c(l_nfile)                   

      REAL                :: f_arch_rain_ngd_mm(l_nfile)     
      REAL                :: f_arch_rain_avg_mm(l_nfile)     
      REAL                :: f_arch_rain_min_mm(l_nfile)     
      REAL                :: f_arch_rain_max_mm(l_nfile)     

      REAL                :: f_arch_wspd_ngd_kt(l_nfile)
      REAL                :: f_arch_wspd_avg_kt(l_nfile)
      REAL                :: f_arch_wspd_min_kt(l_nfile)
      REAL                :: f_arch_wspd_max_kt(l_nfile)

      REAL                :: f_arch_slpr_ngd_hpa(l_nfile)      
      REAL                :: f_arch_slpr_avg_hpa(l_nfile)        
      REAL                :: f_arch_slpr_min_hpa(l_nfile)        
      REAL                :: f_arch_slpr_max_hpa(l_nfile)        

      REAL                :: f_arch_sunshine_ngd_h(l_nfile)
      REAL                :: f_arch_sunshine_avg_h(l_nfile)
      REAL                :: f_arch_sunshine_min_h(l_nfile)
      REAL                :: f_arch_sunshine_max_h(l_nfile)

      REAL                :: f_arch_relh_ngd_pc(l_nfile)
      REAL                :: f_arch_relh_avg_pc(l_nfile)
      REAL                :: f_arch_relh_min_pc(l_nfile)
      REAL                :: f_arch_relh_max_pc(l_nfile)

      REAL                :: f_arch_cldcov_ngd_okta(l_nfile)
      REAL                :: f_arch_cldcov_avg_okta(l_nfile)
      REAL                :: f_arch_cldcov_min_okta(l_nfile)
      REAL                :: f_arch_cldcov_max_okta(l_nfile)

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
      s_directory='D:\Ireland\Hourly\'
c************************************************************************
c     Import list of data directories

      s_filename='z_filelist.dat'
      s_pathandname=TRIM(s_directory)//TRIM(s_filename)
      CALL import_directory_names2(s_pathandname,
     +  l_nfile,
     +  l_nfile_use,s_filelist)

      print*,'l_nfile_use',l_nfile_use
c************************************************************************
c     Read in metadata
      s_filename='ireland_subday_metadata2.txt'
      CALL readin_metadata_subday(s_filename,l_nfile,
     +  l_meta,
     +  s_meta_namelist,s_meta_fileid,s_meta_alt_m,
     +  s_meta_lat,s_meta_lon,s_meta_wigos)

c     Create basis metadata set
      CALL create_basis_set_subday(l_nfile,l_nfile_use,s_filelist,
     +  l_meta,
     +  s_meta_namelist,s_meta_fileid,s_meta_alt_m,
     +  s_meta_lat,s_meta_lon,s_meta_wigos,
     +  s_basis_nameshort,s_basis_namelist,s_basis_fileid,
     +  s_basis_alt_m,s_basis_lat,s_basis_lon,s_basis_wigos)

c      print*,'l_nfile,l_nfile_use',l_nfile,l_nfile_use
c      DO i=1,l_nfile_use
c       print*,'s_basis_wigos=',i,s_basis_wigos(i)
c      ENDDO
c      CALL SLEEP(60)
c************************************************************************
      DO i=1,l_nfile_use
       s_pathandname=TRIM(s_directory)//TRIM(s_filelist(i))

       print*,'s_pathandname=',i,TRIM(s_pathandname)
       CALL get_data2(s_pathandname,l_mlent,
     +    s_ndflag,i_ndflag,f_ndflag,
     +    l_datalines,s_vec_stnnum,
     +    s_vec_date,s_vec_time,
     +    f_vec_airt_c,f_vec_rain_mm,f_vec_wspd_kt,f_vec_slpr_hpa,
     +    f_vec_sunshine_h,f_vec_relh_pc,f_vec_cldcov_okta)

c      Convert variables
       CALL convert_variables_subday(f_ndflag,
     +    l_mlent,l_datalines,
     +    f_vec_airt_c,f_vec_wspd_kt,
     +    f_vec_airt_k,f_vec_wspd_ms)

c****
c      Find stats 
       CALL find_statf_ei_hour2(l_mlent,l_datalines,f_vec_airt_c,
     +   f_ndflag,
     +   f_stat_airt_c_ngd,f_stat_airt_c_nbd,
     +   f_stat_airt_c_avg,
     +   f_stat_airt_c_min,f_stat_airt_c_max)

       CALL find_statf_ei_hour2(l_mlent,l_datalines,f_vec_rain_mm,
     +   f_ndflag,
     +   f_stat_rain_mm_ngd,f_stat_rain_mm_nbd,
     +   f_stat_rain_mm_avg,
     +   f_stat_rain_mm_min,f_stat_rain_mm_max)

       CALL find_statf_ei_hour2(l_mlent,l_datalines,f_vec_rain_mm,
     +   f_ndflag,
     +   f_stat_wspd_kt_ngd,f_stat_wspd_kt_nbd,
     +   f_stat_wspd_kt_avg,
     +   f_stat_wspd_kt_min,f_stat_wspd_kt_max)

       CALL find_statf_ei_hour2(l_mlent,l_datalines,f_vec_slpr_hpa,
     +   f_ndflag,
     +   f_stat_slpr_hpa_ngd,f_stat_slpr_hpa_nbd,
     +   f_stat_slpr_hpa_avg,
     +   f_stat_slpr_hpa_min,f_stat_slpr_hpa_max)

       CALL find_statf_ei_hour2(l_mlent,l_datalines,f_vec_sunshine_h,
     +   f_ndflag,
     +   f_stat_sunshine_h_ngd,f_stat_sunshine_h_nbd,
     +   f_stat_sunshine_h_avg,
     +   f_stat_sunshine_h_min,f_stat_sunshine_h_max)

       CALL find_statf_ei_hour2(l_mlent,l_datalines,f_vec_relh_pc,
     +   f_ndflag,
     +   f_stat_relh_pc_ngd,f_stat_relh_pc_nbd,
     +   f_stat_relh_pc_avg,
     +   f_stat_relh_pc_min,f_stat_relh_pc_max)

       CALL find_statf_ei_hour2(l_mlent,l_datalines,f_vec_cldcov_okta,
     +   f_ndflag,
     +   f_stat_cldcov_okta_ngd,f_stat_cldcov_okta_nbd,
     +   f_stat_cldcov_okta_avg,
     +   f_stat_cldcov_okta_min,f_stat_cldcov_okta_max)

c****      
c      Archive stats
       f_arch_airt_ngd_c(i)   =f_stat_airt_c_ngd         
       f_arch_airt_avg_c(i)   =f_stat_airt_c_avg      
       f_arch_airt_min_c(i)   =f_stat_airt_c_min       
       f_arch_airt_max_c(i)   =f_stat_airt_c_max  

       f_arch_rain_ngd_mm(i)  =f_stat_rain_mm_ngd         
       f_arch_rain_avg_mm(i)  =f_stat_rain_mm_avg      
       f_arch_rain_min_mm(i)  =f_stat_rain_mm_min       
       f_arch_rain_max_mm(i)  =f_stat_rain_mm_max  

       f_arch_wspd_ngd_kt(i)  =f_stat_wspd_kt_ngd         
       f_arch_wspd_avg_kt(i)  =f_stat_wspd_kt_avg      
       f_arch_wspd_min_kt(i)  =f_stat_wspd_kt_min       
       f_arch_wspd_max_kt(i)  =f_stat_wspd_kt_max  

       f_arch_slpr_ngd_hpa(i) =f_stat_slpr_hpa_ngd         
       f_arch_slpr_avg_hpa(i) =f_stat_slpr_hpa_avg      
       f_arch_slpr_min_hpa(i) =f_stat_slpr_hpa_min       
       f_arch_slpr_max_hpa(i) =f_stat_slpr_hpa_max  

       f_arch_sunshine_ngd_h(i) =f_stat_sunshine_h_ngd         
       f_arch_sunshine_avg_h(i) =f_stat_sunshine_h_avg      
       f_arch_sunshine_min_h(i) =f_stat_sunshine_h_min       
       f_arch_sunshine_max_h(i) =f_stat_sunshine_h_max  

       f_arch_relh_ngd_pc(i)  =f_stat_relh_pc_ngd         
       f_arch_relh_avg_pc(i)  =f_stat_relh_pc_avg      
       f_arch_relh_min_pc(i)  =f_stat_relh_pc_min       
       f_arch_relh_max_pc(i)  =f_stat_relh_pc_max  

       f_arch_cldcov_ngd_okta(i) =f_stat_cldcov_okta_ngd         
       f_arch_cldcov_avg_okta(i) =f_stat_cldcov_okta_avg      
       f_arch_cldcov_min_okta(i) =f_stat_cldcov_okta_min       
       f_arch_cldcov_max_okta(i) =f_stat_cldcov_okta_max  
c************************************************************************
c      Export header table from Met Eireanne stations
c901    s_directory_root='D:\Export\Meteireanne_subdaily_header\'  
c       CALL export_header_subday(f_ndflag,s_directory_root,
c     +  l_datalines,
c     +  s_basis_nameshort(i),s_basis_namelist(i),s_basis_fileid(i),
c     +  s_basis_alt_m(i),s_basis_lat(1),s_basis_lon(1),s_basis_wigos(i),
c     +  l_mlent,
c     +  s_vec_date,s_vec_time,
c     +  f_vec_airt_k,f_vec_rain_mm,f_vec_wspd_ms,f_vec_slpr_hpa,
c     +  f_vec_relh_pc,
c     +  f_vec_airt_c,f_vec_wspd_kt)

901    s_directory_root='D:\Export\Meteireanne_subdaily_header\'  
       CALL export_header_subday2(f_ndflag,s_directory_root,
     +  l_datalines,
     +  s_basis_nameshort(i),s_basis_namelist(i),s_basis_fileid(i),
     +  s_basis_alt_m(i),s_basis_lat(1),s_basis_lon(1),s_basis_wigos(i),
     +  l_mlent,
     +  s_vec_date,s_vec_time,
     +  f_vec_airt_k,f_vec_rain_mm,f_vec_wspd_ms,f_vec_slpr_hpa,
     +  f_vec_relh_pc,
     +  f_vec_airt_c,f_vec_wspd_kt)

c      Export observation table from Met Eireanne stations
c902    s_directory_root='D:\Export\Meteireanne_subdaily_observation\'  
c       CALL export_observation_subday(f_ndflag,s_directory_root,
c     +  l_datalines,
c     +  s_basis_nameshort(i),s_basis_namelist(i),s_basis_fileid(i),
c     +  s_basis_alt_m(i),s_basis_lat(1),s_basis_lon(1),s_basis_wigos(i),
c     +  l_mlent,
c     +  s_vec_date,s_vec_time,
c     +  f_vec_airt_k,f_vec_rain_mm,f_vec_wspd_ms,f_vec_slpr_hpa,
c     +  f_vec_relh_pc,
c     +  f_vec_airt_c,f_vec_wspd_kt)

c      Feb14/2018: replaced with export_observation_subday2.f
902    s_directory_root='D:\Export\Meteireanne_subdaily_observation\'  
       CALL export_observation_subday2(f_ndflag,s_directory_root,
     +  l_datalines,
     +  s_basis_nameshort(i),s_basis_namelist(i),s_basis_fileid(i),
     +  s_basis_alt_m(i),s_basis_lat(1),s_basis_lon(1),s_basis_wigos(i),
     +  l_mlent,
     +  s_vec_date,s_vec_time,
     +  f_vec_airt_k,f_vec_rain_mm,f_vec_wspd_ms,f_vec_slpr_hpa,
     +  f_vec_relh_pc,
     +  f_vec_airt_c,f_vec_wspd_kt)

c      Feb14/2018: new file to make CDM with 50 columns
c902    s_directory_root='D:\Export\Meteireanne_subdaily_observation\'  
c       CALL export_observation_subday3(f_ndflag,s_directory_root,
c     +  l_datalines,
c     +  s_basis_nameshort(i),s_basis_namelist(i),s_basis_fileid(i),
c     +  s_basis_alt_m(i),s_basis_lat(1),s_basis_lon(1),s_basis_wigos(i),
c     +  l_mlent,
c     +  s_vec_date,s_vec_time,
c     +  f_vec_airt_k,f_vec_rain_mm,f_vec_wspd_ms,f_vec_slpr_hpa,
c     +  f_vec_relh_pc,
c     +  f_vec_airt_c,f_vec_wspd_kt)
c************************************************************************
      ENDDO
c************************************************************************
c************************************************************************
c************************************************************************
c     Find end time
      CALL CPU_TIME(f_time_en)

      f_deltime_s=f_time_en-f_time_st
      print*,'f_deltime_s,f_deltime_min=',f_deltime_s,f_deltime_s/60.0      
c************************************************************************
      RETURN
      END