c     Subroutine to set intermediate & final directory paths
c     AJ_Kettle, 30Mar2021

      SUBROUTINE get_directory_paths20210330(
     + s_directory_1tar,s_directory_2untarpack,
     + s_directory_3unsort,s_directory_3headerlist,s_directory_3archive)

      IMPLICIT NONE
c************************************************************************
      CHARACTER(LEN=300)  :: s_directory_1tar
      CHARACTER(LEN=300)  :: s_directory_2untarpack
      CHARACTER(LEN=300)  :: s_directory_3unsort
      CHARACTER(LEN=300)  :: s_directory_3headerlist
      CHARACTER(LEN=300)  :: s_directory_3archive
c************************************************************************
      GOTO 10

c     PROJECT DISK
      s_directory_1tar=
     + '/gws/nopw/j04/c3s311a_lot2/data/level0/land/'//
     + 'sub_daily_data_processing/P20200114_usafupdate/Data_1tar/'
      s_directory_2untarpack=
     + '/gws/nopw/j04/c3s311a_lot2/data/level0/land/'//
     + 'sub_daily_data_processing/P20200114_usafupdate/Data_2untarpack/'

      s_directory_3headerlist=
     +'/gws/nopw/j04/c3s311a_lot2/data/level0/land/'//
     +'sub_daily_data_processing/P20200114_usafupdate/Data_3headerlist/'
      s_directory_3unsort=
     + '/gws/nopw/j04/c3s311a_lot2/data/level0/land/'//
     + 'sub_daily_data_processing/P20200114_usafupdate/Data_3unsorted/'
      s_directory_3archive=
     + '/gws/nopw/j04/c3s311a_lot2/data/level0/land/'//
     + 'sub_daily_data_processing/P20200114_usafupdate/Data_3archive/'

 10   CONTINUE
c*****
c     SCRATCH SPACE
      s_directory_1tar=
     + '/work/scratch-pw/akettle/P20210325_usaf_update2/'//
     + 'Data_1tar/'
      s_directory_2untarpack=
     + '/work/scratch-pw/akettle/P20210325_usaf_update2/'//
     + 'Data_2untarpack/'

      s_directory_3headerlist=
     + '/work/scratch-pw/akettle/P20210325_usaf_update2/'//
     + 'Data_3headerlist/'
      s_directory_3unsort=
     + '/work/scratch-pw/akettle/P20210325_usaf_update2/'//
     + 'Data_3unsorted/'
      s_directory_3archive=
     + '/work/scratch-pw/akettle/P20210325_usaf_update2/'//
     + 'Data_3archive/'

      RETURN
      END
