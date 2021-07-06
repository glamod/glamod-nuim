c     Subroutine to resolve ancillary vectors
c     AJ_Kettle, 15Dec2018
c     17Jan2019: modification to convert snow from mm to cm

      SUBROUTINE sort_vec_obs_ancillary_ghcnd2(l_channel,
     +  s_code_observation,s_code_unit,s_value_significance,
     +  s_code_unit_original,s_code_conversion_method,
     +  s_code_conversion_flag,s_code_observation_duration)

      IMPLICIT NONE
c************************************************************************
c     Declare variables passed into program

      INTEGER             :: l_channel
      CHARACTER(LEN=3)    :: s_code_observation(l_channel)
      CHARACTER(LEN=3)    :: s_code_unit(l_channel)
      CHARACTER(LEN=3)    :: s_value_significance(l_channel)
      CHARACTER(LEN=3)    :: s_code_unit_original(l_channel)
      CHARACTER(LEN=3)    :: s_code_conversion_method(l_channel)
      CHARACTER(LEN=3)    :: s_code_conversion_flag(l_channel)
      CHARACTER(LEN=3)    :: s_code_observation_duration(l_channel)
c*****
c     Variables used in program

      INTEGER             :: i,j,k,ii,jj,kk
c************************************************************************
c      print*,'just inside sort_vec_obs_ancillary_ghcnd2'

c     Hard wire observation codes CDM117 & CDM tables (observed variable)

c     Column 6: set to code 13 for daily
      s_code_observation_duration(1)='13'   !prcp
      s_code_observation_duration(2)='13'   !tmin
      s_code_observation_duration(3)='13'   !tmax
      s_code_observation_duration(4)='13'   !tavg
      s_code_observation_duration(5)='0'    !snwd  (snow depth; instantaneous)
      s_code_observation_duration(6)='13'   !snow  (24h snowfall)
      s_code_observation_duration(7)='13'   !awnd
      s_code_observation_duration(8)='13'   !awdr
      s_code_observation_duration(9)='0'    !wesd  (water equivalent snow depth; instantaneous)

c     Column 10: observed variable table; CDM table 120
      s_code_observation(1)='44'   !prcp 
      s_code_observation(2)='85'   !tmin
      s_code_observation(3)='85'   !tmax
      s_code_observation(4)='85'   !tavg 
      s_code_observation(5)='53'   !snwd
      s_code_observation(6)='45'   !snow
      s_code_observation(7)='107'  !awnd
      s_code_observation(8)='106'  !awdr
      s_code_observation(9)='55'   !wesd (water equivalent snow depth)

c     Column 12: value_significance: 5 possible values; also CDM 116
      s_value_significance(1)='13'   !prcp  (accumulation)
      s_value_significance(2)='1'    !tmin  (minimum)
      s_value_significance(3)='0'    !tmax  (maximum)
      s_value_significance(4)='2'    !tavg  (mean)
      s_value_significance(5)='12'   !snwd  (instantaneous)
      s_value_significance(6)='13'   !snow  (24h accumulation)
      s_value_significance(7)='2'    !awnd  (mean)
      s_value_significance(8)='2'    !awdr  (mean)
      s_value_significance(9)='12'   !wesd  (instantaneous)

c     Column 14: reported units (after conversion) (CDM 159)
      s_code_unit(1) ='710'     !prcp (tenths of mm)   710=mm   
      s_code_unit(2) ='005'     !tmin (tenths C to K)  005=K
      s_code_unit(3) ='005'     !tmax (tenths C to K)  005=K
      s_code_unit(4) ='005'     !tavg (tenths C to K)  005=K
      s_code_unit(5) ='715'     !snwd (cm from mm)     710=mm,715=cm
      s_code_unit(6) ='710'     !snow (mm)             710=mm
      s_code_unit(7) ='731'     !awnd (tenths m/s)     731=m/s
      s_code_unit(8) ='320'     !awdr (deg)            320=degrees
      s_code_unit(9) ='710'     !wesd (tenths of mm)   710=mm

c     Column 15: conversion_flag
      s_code_conversion_flag(1)='2'  !prcp (tenths of mm)   710=mm  
      s_code_conversion_flag(2)='0'  !tmin (tenths C to K)  005=K
      s_code_conversion_flag(3)='0'  !tmax (tenths C to K)  005=K
      s_code_conversion_flag(4)='0'  !tavg (tenths C to K)  005=K
      s_code_conversion_flag(5)='0'  !snwd (mm to cm)       710=mm
      s_code_conversion_flag(6)='2'  !snow (mm to cm)       710=mm
      s_code_conversion_flag(7)='2'  !awnd (tenths m/s)     731=m/s
      s_code_conversion_flag(8)='1'  !awdr (deg)            320=degrees
      s_code_conversion_flag(9)='2'  !wesd (tenths of mm)   710=mm

c     Column 19: original units
      s_code_unit_original(1)='710'  !prcp (tenths of mm)   710=mm 
      s_code_unit_original(2)='350'  !tmin (tenths C to K)  350=C   
      s_code_unit_original(3)='350'  !tmax (tenths C to K)  350=C  
      s_code_unit_original(4)='350'  !tavg (tenths C to K)  350=C  
      s_code_unit_original(5)='710'  !snwd (mm)             710=mm
      s_code_unit_original(6)='710'  !snow (mm)             710=mm
      s_code_unit_original(7)='731'  !awnd (tenths m/s)     731=m/s
      s_code_unit_original(8)='320'  !awdr (deg)            320=degrees  
      s_code_unit_original(9)='710'  !wesd (tenths of mm)   710=mm  

c     Column 21: conversion method
      s_code_conversion_method(1)=''   !prcp (tenths of mm)
      s_code_conversion_method(2)='1'  !tmin (tenths C to K)
      s_code_conversion_method(3)='1'  !tmax (tenths C to K)
      s_code_conversion_method(4)='1'  !tavg (tenths C to K)
      s_code_conversion_method(5)='6'  !snwd (mm to cm)    
      s_code_conversion_method(6)=''   !snow (mm)   
      s_code_conversion_method(7)=''   !awnd (tenths m/s)
      s_code_conversion_method(8)=''   !awdr (deg) 
      s_code_conversion_method(9)=''   !wesd (tenths of mm)

c      print*,'just leaving sort_vec_obs_ancillary_ghcnd2'

      RETURN
      END
