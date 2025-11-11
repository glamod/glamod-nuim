c     Subroutine to hardwire codes
c     AJ_Kettle, 12Dec2019

      SUBROUTINE get_codes_processing_qff(l_varselect,
     +   s_code_observation,s_code_unit,
     +   s_code_value_significance,s_code_unit_original,
     +   s_code_conversion_method,s_code_conversion_flag,
     +   s_predef_numerical_precision,s_predef_hgt_obs_above_sfc)

      IMPLICIT NONE
c************************************************************************
c     Variables passed into subroutine

      INTEGER             :: l_varselect
      CHARACTER(LEN=3)    :: s_code_observation(l_varselect)
      CHARACTER(LEN=3)    :: s_code_unit(l_varselect)
      CHARACTER(LEN=3)    :: s_code_value_significance(l_varselect)
      CHARACTER(LEN=3)    :: s_code_unit_original(l_varselect)
      CHARACTER(LEN=3)    :: s_code_conversion_method(l_varselect)
      CHARACTER(LEN=3)    :: s_code_conversion_flag(l_varselect)
      CHARACTER(LEN=10)   :: s_predef_numerical_precision(l_varselect)
      CHARACTER(LEN=10)   :: s_predef_hgt_obs_above_sfc(l_varselect)
c************************************************************************

      s_code_observation(1)='85'   !airt c/k
      s_code_observation(2)='36'   !dewp c/k
      s_code_observation(3)='57'   !stnp hpa/pa
      s_code_observation(4)='58'   !slpr hpa/pa
      s_code_observation(5)='106'  !wdir deg
      s_code_observation(6)='107'  !wspd m/s

c     (converted units)
      s_code_unit(1)='005'         !005=k
      s_code_unit(2)='005'         !005=k
      s_code_unit(3)='032'         !032=Pa
      s_code_unit(4)='032'         !032=Pa
      s_code_unit(5)='110'         !110=deg (angle)
      s_code_unit(6)='731'         !731=m/s

      s_code_value_significance(1)='12' !12=instantaneous
      s_code_value_significance(2)='12' !
      s_code_value_significance(3)='12' !
      s_code_value_significance(4)='12' !
      s_code_value_significance(5)='12' !
      s_code_value_significance(6)='12' !

      s_code_unit_original(1)='060'     !060=deg C
      s_code_unit_original(2)='060'     !060=deg C
      s_code_unit_original(3)='530'     !530=hpa
      s_code_unit_original(4)='530'     !530=hpa
      s_code_unit_original(5)='110'     !110=deg
      s_code_unit_original(6)='731'     !731=m/s

      s_code_conversion_method(1)='1'   !var85; method1 convert C to K
      s_code_conversion_method(2)='1'   !var36; method1 convert C to K
      s_code_conversion_method(3)='7'   !var57; info from SN
      s_code_conversion_method(4)='7'   !var58; method 7 convert from hpa to pa
      s_code_conversion_method(5)=''
      s_code_conversion_method(6)=''

c     CDM template 21Aug2019: column 20
c     0=both original (non-SI) and converted (SI) values available
c     1=only original value in non-SI units available; no conversion
c     2=original in SI units available; no conversion required
c     3=value coded; see code table
      s_code_conversion_flag(1)  ='0'
      s_code_conversion_flag(2)  ='0'
      s_code_conversion_flag(3)  ='0'
      s_code_conversion_flag(4)  ='0'
      s_code_conversion_flag(5)  ='1'    !wdir
      s_code_conversion_flag(6)  ='2'    !wspd

      s_predef_numerical_precision(1)   =''
      s_predef_numerical_precision(2)   =''
      s_predef_numerical_precision(3)   =''
      s_predef_numerical_precision(4)   =''
      s_predef_numerical_precision(5)   =''
      s_predef_numerical_precision(6)   =''

      s_predef_hgt_obs_above_sfc(1)='2'   !TMAX
      s_predef_hgt_obs_above_sfc(2)='2'   !TMIN
      s_predef_hgt_obs_above_sfc(3)='2'   !stnp
      s_predef_hgt_obs_above_sfc(4)='2'   !slpr
      s_predef_hgt_obs_above_sfc(5)='10'  !wdir
      s_predef_hgt_obs_above_sfc(6)='10'  !wspd

      RETURN
      END
