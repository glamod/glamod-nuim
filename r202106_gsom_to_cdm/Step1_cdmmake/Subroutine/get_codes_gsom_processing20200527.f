c     Subroutine to get codes for GSOM processing
c     AJ_Kettle, 06Sep2019
c     AJ_Kettle, 10Oct2019: modified to hardwire height obs above ground
c     27May2020: changed snow variable code from 55 to 45

      SUBROUTINE get_codes_gsom_processing20200527(l_varselect,
     +   s_varselect,s_code_observation,s_code_unit,
     +   s_code_value_significance,s_code_unit_original,
     +   s_code_conversion_method,s_code_conversion_flag,
     +   s_predef_numerical_precision,s_predef_hgt_obs_above_sfc)

c************************************************************************
      INTEGER             :: l_varselect

      CHARACTER(LEN=4)    :: s_varselect(l_varselect)
      CHARACTER(LEN=3)    :: s_code_observation(l_varselect)
      CHARACTER(LEN=3)    :: s_code_unit(l_varselect)
      CHARACTER(LEN=3)    :: s_code_value_significance(l_varselect)
      CHARACTER(LEN=3)    :: s_code_unit_original(l_varselect)
      CHARACTER(LEN=3)    :: s_code_conversion_method(l_varselect)
      CHARACTER(LEN=3)    :: s_code_conversion_flag(l_varselect)
      CHARACTER(LEN=10)   :: s_predef_numerical_precision(l_varselect)
      CHARACTER(LEN=10)   :: s_predef_hgt_obs_above_sfc(l_varselect)
c*****
c     Variables used in subroutine

      INTEGER             :: i,j,k,ii,jj,kk
c************************************************************************

      s_varselect(1)  ='TMAX'
      s_varselect(2)  ='TMIN'
      s_varselect(3)  ='TAVG'
      s_varselect(4)  ='PRCP'
      s_varselect(5)  ='SNOW'
      s_varselect(6)  ='AWND'

      s_code_observation(1)='85'
      s_code_observation(2)='85'
      s_code_observation(3)='85'
      s_code_observation(4)='44'
      s_code_observation(5)='45'     !'55'
      s_code_observation(6)='107'

      s_code_unit(1)='005'
      s_code_unit(2)='005'
      s_code_unit(3)='005'
      s_code_unit(4)='710'
      s_code_unit(5)='710'
      s_code_unit(6)='731'

      s_code_value_significance(1)='0'  !MAX
      s_code_value_significance(2)='1'  !MIN
      s_code_value_significance(3)='2'  !MEAN
      s_code_value_significance(4)='13' !accumulation
      s_code_value_significance(5)='13' !accumulation
      s_code_value_significance(6)='2'  !mean

      s_code_unit_original(1)='060'  !deg C
      s_code_unit_original(2)='060'  !deg C
      s_code_unit_original(3)='060'  !deg C
      s_code_unit_original(4)='710'  !mm
      s_code_unit_original(5)='710'  !mm
      s_code_unit_original(6)='731'  !m/s

      s_code_conversion_method(1)='1'
      s_code_conversion_method(2)='1'
      s_code_conversion_method(3)='1'
      s_code_conversion_method(4)=''
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
      s_code_conversion_flag(4)  ='2'
      s_code_conversion_flag(5)  ='2'
      s_code_conversion_flag(6)  ='2'

      s_predef_numerical_precision(1)   ='' !'0.1'
      s_predef_numerical_precision(2)   ='' !'0.1'
      s_predef_numerical_precision(3)   ='' !'0.1'
      s_predef_numerical_precision(4)   ='' !'0.1'
      s_predef_numerical_precision(5)   ='' !'0.1'
      s_predef_numerical_precision(6)   ='' !'0.1'

      s_predef_hgt_obs_above_sfc(1)='2'   !TMAX
      s_predef_hgt_obs_above_sfc(2)='2'   !TMIN
      s_predef_hgt_obs_above_sfc(3)='2'   !TAVG
      s_predef_hgt_obs_above_sfc(4)='1'   !PRCP
      s_predef_hgt_obs_above_sfc(5)='0'   !SNOW
      s_predef_hgt_obs_above_sfc(6)='10'  !AWND


c     NOT CHOSEN: EMXT,EMNT,EMXP,EMSN,EMSD
c************************************************************************


      RETURN
      END
