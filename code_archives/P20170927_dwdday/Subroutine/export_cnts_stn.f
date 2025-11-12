c     Subroutine to create table of counts where variable present
c     AJ_Kettle, Oct03/2017

      SUBROUTINE export_cnts_stn(s_directory_output,s_date,l_zipfile,
     +  i_cnt_dayavg_airt,i_cnt_dayavg_vapprs,i_cnt_dayavg_ccov,
     +  i_cnt_dayavg_pres,i_cnt_dayavg_relh,i_cnt_dayavg_wspd,
     +  i_cnt_daymax_airt,i_cnt_daymin_airt,i_cnt_daymin_minbod,
     +  i_cnt_daymax_gust,i_cnt_daytot_ppt,i_cnt_daytot_sundur,
     +  i_cnt_daytot_snoacc)

      IMPLICIT NONE
c************************************************************************
      CHARACTER(LEN=200)  :: s_directory_output
      CHARACTER(LEN=8)    :: s_date

      INTEGER             :: l_zipfile
      INTEGER             :: i_cnt_dayavg_airt
      INTEGER             :: i_cnt_dayavg_vapprs
      INTEGER             :: i_cnt_dayavg_ccov
      INTEGER             :: i_cnt_dayavg_pres
      INTEGER             :: i_cnt_dayavg_relh
      INTEGER             :: i_cnt_dayavg_wspd
      INTEGER             :: i_cnt_daymax_airt
      INTEGER             :: i_cnt_daymin_airt
      INTEGER             :: i_cnt_daymin_minbod
      INTEGER             :: i_cnt_daymax_gust
      INTEGER             :: i_cnt_daytot_ppt
      INTEGER             :: i_cnt_daytot_sundur
      INTEGER             :: i_cnt_daytot_snoacc    
c************************************************************************
      OPEN(UNIT=1,
     +  FILE=TRIM(s_directory_output)//'export_stn_counts.dat',
     +  FORM='formatted',
     +  STATUS='NEW',ACTION='WRITE')

      WRITE(UNIT=1,FMT=3009) 'DWD - Day Historical Data'
      WRITE(UNIT=1,FMT=3009) 'cnt of number of stations'
      WRITE(UNIT=1,FMT=3009) 'with parameter present   '
      WRITE(UNIT=1,FMT=3009) '                         '
3009  FORMAT(a25) 

      WRITE(unit=1,FMT=3029) 'AJ_Kettle ',s_date                          
3029  FORMAT(t1,a10,t12,a8) 
      WRITE(unit=1,FMT=3023) '                                        '
3023  FORMAT(t1,a40) 

      WRITE(unit=1,FMT=3027) 'total stations ',l_zipfile    
      WRITE(unit=1,FMT=3027) 'dayavg_airt    ',i_cnt_dayavg_airt      
      WRITE(unit=1,FMT=3027) 'dayavg_vapprs  ',i_cnt_dayavg_vapprs      
      WRITE(unit=1,FMT=3027) 'dayavg_ccov    ',i_cnt_dayavg_ccov      
      WRITE(unit=1,FMT=3027) 'dayavg_pres    ',i_cnt_dayavg_pres      
      WRITE(unit=1,FMT=3027) 'dayavg_relh    ',i_cnt_dayavg_relh      
      WRITE(unit=1,FMT=3027) 'dayavg_wspd    ',i_cnt_dayavg_wspd      
      WRITE(unit=1,FMT=3027) 'daymax_airt    ',i_cnt_daymax_airt      
      WRITE(unit=1,FMT=3027) 'daymin_airt    ',i_cnt_daymin_airt      
      WRITE(unit=1,FMT=3027) 'daymin_minbod  ',i_cnt_daymin_minbod      
      WRITE(unit=1,FMT=3027) 'daymax_gust    ',i_cnt_daymax_gust      
      WRITE(unit=1,FMT=3027) 'daytot_ppt     ',i_cnt_daytot_ppt      
      WRITE(unit=1,FMT=3027) 'daytot_sundur  ',i_cnt_daytot_sundur      
      WRITE(unit=1,FMT=3027) 'daytot_snoacc  ',i_cnt_daytot_snoacc      
3027  FORMAT(a15,i5)

      CLOSE(UNIT=1)

      RETURN
      END