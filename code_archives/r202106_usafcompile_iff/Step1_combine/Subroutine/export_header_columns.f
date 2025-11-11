c     Subroutine to export header columns
c     AJ_Kettle, 05May2021

      SUBROUTINE export_header_columns(s_date_st,s_time_st,
     +   s_directory_usaf_output_diag,s_file_headercompare, 
     +   l_header1,s_vec_header1,
     +   l_header2,s_vec_header2,l_header3,s_vec_header3)

      IMPLICIT NONE
c************************************************************************
c     Declare variables 

      CHARACTER(LEN=8)    :: s_date_st
      CHARACTER(LEN=10)   :: s_time_st

      CHARACTER(LEN=300)  :: s_directory_usaf_output_diag
      CHARACTER(LEN=300)  :: s_file_headercompare

      INTEGER             :: l_header1,l_header2,l_header3
      CHARACTER(LEN=50)   :: s_vec_header1(200)
      CHARACTER(LEN=50)   :: s_vec_header2(200)
      CHARACTER(LEN=50)   :: s_vec_header3(200)
c*****
c     Variables used in subroutine

      INTEGER             :: i,j,k,ii,jj,kk
      INTEGER             :: io

      CHARACTER(LEN=300)  :: s_pathandname
c************************************************************************
      print*,'just inside export_header_columns'

      s_pathandname=TRIM(s_directory_usaf_output_diag)//
     +  TRIM(s_file_headercompare)

      OPEN(UNIT=2,FILE=s_pathandname,
     +  FORM='formatted',STATUS='REPLACE',ACTION='WRITE')   

      WRITE(2,1000) 'Listing column headers 3 datasets       '
      WRITE(2,1000) '                                        '
      WRITE(2,1002) s_date_st,s_time_st
      WRITE(2,1000) '                                        '
      WRITE(2,1000) 'subdirectory: export_header_columns.f   '
      WRITE(2,1000) '                                        '
      WRITE(2,1003) 'N columns=',l_header1,l_header2,l_header3
      WRITE(2,1000) '                                        '

 1000 FORMAT(t1,a40)
 1002 FORMAT(t1,a8,t10,a6)
 1003 FORMAT(t1,a10,t12,i3,t16,i3,t20,i3,t24)

      WRITE(2,1004) 'NNN',
     +  'Header - main                 ',
     +  'Header - update1              ',
     +  'Header - update2              '
      WRITE(2,1004) '+-+',
     +  '+----------------------------+',
     +  '+----------------------------+',
     +  '+----------------------------+'
 1004 FORMAT(t1,a3,t5,a30,t36,a30,t67,a30)
 1006 FORMAT(t1,i3,t5,a30,t36,a30,t67,a30)

      DO i=1,l_header1
       WRITE(2,1006) i,
     +  s_vec_header1(i)//'                              ',
     +  s_vec_header2(i)//'                              ',
     +  s_vec_header3(i)//'                              '
      ENDDO

      CLOSE(UNIT=2)



      print*,'just leaving export_header_columns'

      RETURN
      END
