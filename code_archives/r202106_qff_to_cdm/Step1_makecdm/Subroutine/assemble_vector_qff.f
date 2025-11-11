c     Subroutine to find which values populated
c     AJ_Kettle, 02Oct2019
c     14Dec2019: adapted for qff analysis

      SUBROUTINE assemble_vector_qff(l_channel,
     +   s_single_airt_value,s_single_dewp_value,
     +   s_single_stnp_value,s_single_slpr_value,
     +   s_single_wdir_value,s_single_wspd_value,

     +   s_avec_value)

      IMPLICIT NONE
c************************************************************************
c     Variables passed into program

      INTEGER             :: l_channel
      CHARACTER(LEN=*)    :: s_single_airt_value
      CHARACTER(LEN=*)    :: s_single_dewp_value
      CHARACTER(LEN=*)    :: s_single_stnp_value
      CHARACTER(LEN=*)    :: s_single_slpr_value
      CHARACTER(LEN=*)    :: s_single_wdir_value
      CHARACTER(LEN=*)    :: s_single_wspd_value

      CHARACTER(LEN=*)    :: s_avec_value(l_channel)
c*****
c     Variables used in subroutine

      INTEGER             :: i,j,k,ii,jj,kk
c************************************************************************
c      print*,'just inside assemble_vector_qff'

      s_avec_value(1)=s_single_airt_value
      s_avec_value(2)=s_single_dewp_value
      s_avec_value(3)=s_single_stnp_value
      s_avec_value(4)=s_single_slpr_value
      s_avec_value(5)=s_single_wdir_value
      s_avec_value(6)=s_single_wspd_value

c      print*,'just leaving assemble_vector_qff'

      RETURN
      END
