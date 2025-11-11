c     Subroutine to do preceision analysis
c     AJ_Kettle, 27Nov2019

      SUBROUTINE find_original_precision_qff(l_rgh,l_lines,
     +   s_vec_temperature_c,s_vec_dew_point_temperature_c,
     +   s_vec_station_level_pressure_hpa,s_vec_sea_level_pressure_hpa,
     +   s_vec_wind_direction_deg,s_vec_wind_speed_ms,

     +   s_vec_airt_origprec_c,s_vec_dewp_origprec_c,
     +   s_vec_stnp_origprec_hpa,s_vec_slpr_origprec_hpa,
     +   s_vec_wdir_origprec_deg,s_vec_wspd_origprec_ms,
     +   s_vec_airt_origprec_neglog,s_vec_dewp_origprec_neglog,
     +   s_vec_stnp_origprec_neglog,s_vec_slpr_origprec_neglog,
     +   s_vec_wdir_origprec_neglog,s_vec_wspd_origprec_neglog,
     +   s_vec_airt_origprec_empir_c,s_vec_dewp_origprec_empir_c,
     +   s_vec_stnp_origprec_empir_hpa,s_vec_slpr_origprec_empir_hpa,
     +   s_vec_wdir_origprec_empir_deg,s_vec_wspd_origprec_empir_ms)

      IMPLICIT NONE
c************************************************************************
c     Variables passed into subroutine

      INTEGER              :: l_rgh
      INTEGER              :: l_lines

      CHARACTER(LEN=*)     :: s_vec_temperature_c(l_rgh)     !32
      CHARACTER(LEN=*)     :: s_vec_dew_point_temperature_c(l_rgh)
      CHARACTER(LEN=*)     :: s_vec_station_level_pressure_hpa(l_rgh)
      CHARACTER(LEN=*)     :: s_vec_sea_level_pressure_hpa(l_rgh)
      CHARACTER(LEN=*)     :: s_vec_wind_direction_deg(l_rgh)
      CHARACTER(LEN=*)     :: s_vec_wind_speed_ms(l_rgh)

c     Variables to assess original precision               
      CHARACTER(LEN=*)     :: s_vec_airt_origprec_c(l_rgh)   !32 
      CHARACTER(LEN=*)     :: s_vec_dewp_origprec_c(l_rgh)
      CHARACTER(LEN=*)     :: s_vec_stnp_origprec_hpa(l_rgh)
      CHARACTER(LEN=*)     :: s_vec_slpr_origprec_hpa(l_rgh)
      CHARACTER(LEN=*)     :: s_vec_wdir_origprec_deg(l_rgh)
      CHARACTER(LEN=*)     :: s_vec_wspd_origprec_ms(l_rgh) 

      CHARACTER(LEN=*)     :: s_vec_airt_origprec_empir_c(l_rgh) 
      CHARACTER(LEN=*)     :: s_vec_dewp_origprec_empir_c(l_rgh)
      CHARACTER(LEN=*)     :: s_vec_stnp_origprec_empir_hpa(l_rgh)
      CHARACTER(LEN=*)     :: s_vec_slpr_origprec_empir_hpa(l_rgh)
      CHARACTER(LEN=*)     :: s_vec_wdir_origprec_empir_deg(l_rgh)
      CHARACTER(LEN=*)     :: s_vec_wspd_origprec_empir_ms(l_rgh) 

      CHARACTER(LEN=*)     :: s_vec_airt_origprec_neglog(l_rgh) 
      CHARACTER(LEN=*)     :: s_vec_dewp_origprec_neglog(l_rgh)
      CHARACTER(LEN=*)     :: s_vec_stnp_origprec_neglog(l_rgh)
      CHARACTER(LEN=*)     :: s_vec_slpr_origprec_neglog(l_rgh)
      CHARACTER(LEN=*)     :: s_vec_wdir_origprec_neglog(l_rgh)
      CHARACTER(LEN=*)     :: s_vec_wspd_origprec_neglog(l_rgh) 
c*****
c     Variables used within subroutine

      INTEGER              :: i,j,k,ii,jj,kk

c************************************************************************
c      print*,'just entered find_original_precision_qff'

c      GOTO 12

c     AIRT: Call subroutine to find original precision
      CALL find_precision_vector_qff20210716(l_rgh,l_lines,
     +  s_vec_temperature_c,
     +  s_vec_airt_origprec_c,s_vec_airt_origprec_neglog,
     +  s_vec_airt_origprec_empir_c)

c      print*,'cleared airt'      

c 12   CONTINUE

c     DEWP: Call subroutine to find original precision
      CALL find_precision_vector_qff20210716(l_rgh,l_lines,
     +  s_vec_dew_point_temperature_c,
     +  s_vec_dewp_origprec_c,s_vec_dewp_origprec_neglog,
     +  s_vec_dewp_origprec_empir_c)

c      print*,'cleared dewp'

c 12   CONTINUE

c     STNP: Call subroutine to find original precision
      CALL find_precision_vector_qff20210716(l_rgh,l_lines,
     +  s_vec_station_level_pressure_hpa,
     +  s_vec_stnp_origprec_hpa,s_vec_stnp_origprec_neglog,
     +  s_vec_stnp_origprec_empir_hpa)

c      print*,'cleared stnp'

c 12   CONTINUE

c     SLPR: Call subroutine to find original precision
      CALL find_precision_vector_qff20210716(l_rgh,l_lines,
     +  s_vec_sea_level_pressure_hpa,
     +  s_vec_slpr_origprec_hpa,s_vec_slpr_origprec_neglog,
     +  s_vec_slpr_origprec_empir_hpa)

c      print*,'cleared slpr'

c 12   CONTINUE

c     WDIR: Call subroutine to find original precision
c     PROBLEM SOMEWHERE IN WIND DIRECTION
      CALL find_precision_vector_qff20210716(l_rgh,l_lines,
     +  s_vec_wind_direction_deg,
     +  s_vec_wdir_origprec_deg,s_vec_wdir_origprec_neglog,
     +  s_vec_wdir_origprec_empir_deg)

c      print*,'cleared wdir'

c 12   CONTINUE

c      print*,'about to enter wspd',l_rgh,l_lines
c      print*,'s_vec_wind_speed_ms=',(s_vec_wind_speed_ms(i),i=1,5)

c     WSPD: Call subroutine to find original precision
      CALL find_precision_vector_qff20210716(l_rgh,l_lines,
     +  s_vec_wind_speed_ms,
     +  s_vec_wspd_origprec_ms,s_vec_wspd_origprec_neglog,
     +  s_vec_wspd_origprec_empir_ms)

c      print*,'cleared wspd'
c*****
      GOTO 10

      print*,'s_vec_temperature_c=',
     +  ('|'//TRIM(s_vec_temperature_c(i)),i=1,10)
      print*,'s_vec_airt_origprec_c=',
     +  ('|'//TRIM(s_vec_airt_origprec_c(i)),i=1,10)
      print*,'s_vec_airt_origprec_empir_c=',
     +  ('|'//TRIM(s_vec_airt_origprec_empir_c(i)),i=1,10)
      print*,'s_vec_airt_origprec_neglog=',
     +  ('|'//TRIM(s_vec_airt_origprec_neglog(i)),i=1,10)

      print*,'s_vec_dew_point_temperature_c=',
     +  ('|'//TRIM(s_vec_dew_point_temperature_c(i)),i=1,10)
      print*,'s_vec_dewp_origprec_c=',
     +  ('|'//TRIM(s_vec_dewp_origprec_c(i)),i=1,10)
      print*,'s_vec_dewp_origprec_empir_c=',
     +  ('|'//TRIM(s_vec_dewp_origprec_empir_c(i)),i=1,10)
      print*,'s_vec_dewp_origprec_neglog=',
     +  ('|'//TRIM(s_vec_dewp_origprec_neglog(i)),i=1,10)

      print*,'s_vec_station_level_pressure_hpa=',
     +  ('|'//TRIM(s_vec_station_level_pressure_hpa(i)),i=1,10)
      print*,'s_vec_stnp_origprec_hpa=',
     +  ('|'//TRIM(s_vec_stnp_origprec_hpa(i)),i=1,10)
      print*,'s_vec_stnp_origprec_empir_hpa=',
     +  ('|'//TRIM(s_vec_stnp_origprec_empir_hpa(i)),i=1,10)
      print*,'s_vec_stnp_origprec_neglog=',
     +  ('|'//TRIM(s_vec_stnp_origprec_neglog(i)),i=1,10)

      print*,'s_vec_sea_level_pressure_hpa=',
     +  ('|'//TRIM(s_vec_sea_level_pressure_hpa(i)),i=1,10)
      print*,'s_vec_slpr_origprec_hpa=',
     +  ('|'//TRIM(s_vec_slpr_origprec_hpa(i)),i=1,10)
      print*,'s_vec_slpr_origprec_empir_hpa=',
     +  ('|'//TRIM(s_vec_slpr_origprec_empir_hpa(i)),i=1,10)
      print*,'s_vec_slpr_origprec_neglog=',
     +  ('|'//TRIM(s_vec_slpr_origprec_neglog(i)),i=1,10)

      print*,'s_vec_wind_direction_deg=',
     +  ('|'//TRIM(s_vec_wind_direction_deg(i)),i=1,10)
      print*,'s_vec_wdir_origprec_deg=',
     +  ('|'//TRIM(s_vec_wdir_origprec_deg(i)),i=1,10)
      print*,'s_vec_wdir_origprec_empir_deg=',
     +  ('|'//TRIM(s_vec_wdir_origprec_empir_deg(i)),i=1,10)
      print*,'s_vec_wdir_origprec_neglog=',
     +  ('|'//TRIM(s_vec_wdir_origprec_neglog(i)),i=1,10)

      print*,'s_vec_wind_speed_ms=',
     +  ('|'//TRIM(s_vec_wind_speed_ms(i)),i=1,10)
      print*,'s_vec_wspd_origprec_ms=',
     +  ('|'//TRIM(s_vec_wspd_origprec_ms(i)),i=1,10)
      print*,'s_vec_wspd_origprec_empir_ms=',
     +  ('|'//TRIM(s_vec_wspd_origprec_empir_ms(i)),i=1,10)
      print*,'s_vec_wspd_origprec_neglog=',
     +  ('|'//TRIM(s_vec_wspd_origprec_neglog(i)),i=1,10)

      STOP 'find_original_precision_qff'

 10   CONTINUE
c*****

c      print*,'just leaving find_original_precision_qff'
c      STOP 'find_original_precision_qff'
 
      RETURN
      END
