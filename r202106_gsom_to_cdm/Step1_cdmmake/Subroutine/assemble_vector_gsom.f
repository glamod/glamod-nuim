c     Subroutine to find which record numbers populated
c     AJ_Kettle, 02Oct2019

      SUBROUTINE assemble_vector_gsom(l_channel,
     +   s_single_tmax_recordnum,s_single_tmin_recordnum,
     +   s_single_tavg_recordnum,s_single_prcp_recordnum,
     +   s_single_snow_recordnum,s_single_awnd_recordnum,

     +   s_avec_recordnumber)

      IMPLICIT NONE
c************************************************************************
c     Variables passed into program

      INTEGER             :: l_channel
      CHARACTER(LEN=*)    :: s_single_tmax_recordnum
      CHARACTER(LEN=*)    :: s_single_tmin_recordnum
      CHARACTER(LEN=*)    :: s_single_tavg_recordnum
      CHARACTER(LEN=*)    :: s_single_prcp_recordnum
      CHARACTER(LEN=*)    :: s_single_snow_recordnum
      CHARACTER(LEN=*)    :: s_single_awnd_recordnum

      CHARACTER(LEN=*)    :: s_avec_recordnumber(l_channel)
c*****
c     Variables used in subroutine

      INTEGER             :: i,j,k,ii,jj,kk
c************************************************************************
c      print*,'just inside assemble_vector_gsom'

      s_avec_recordnumber(1)=s_single_tmax_recordnum
      s_avec_recordnumber(2)=s_single_tmin_recordnum
      s_avec_recordnumber(3)=s_single_tavg_recordnum
      s_avec_recordnumber(4)=s_single_prcp_recordnum
      s_avec_recordnumber(5)=s_single_snow_recordnum
      s_avec_recordnumber(6)=s_single_awnd_recordnum

c      print*,'just leaving assemble_vector_gsom'

      RETURN
      END
