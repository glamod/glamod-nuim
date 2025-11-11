c     Export sorted datalines
c     AJ_Kettle, Mar16/2018
c     19Feb2019: adapted for USAF reextraction
c     24Feb2020: adapted for USAF update

      SUBROUTINE export_sorted_list(s_directory_file_outputsort,
     +   s_shortname_single,
     +   l_usaffiles_rgh,l_cnt_usaffiles,i_usaf_index,i_usaf_nlines,
     +   l_rgh_char,l_rgh_datalines,l_datalines,s_linsto_sort,
     +   s_header)

      IMPLICIT NONE
c************************************************************************
c     Declare variables 

      CHARACTER(LEN=300)  :: s_directory_file_outputsort
      CHARACTER(LEN=30)   :: s_shortname_single

      INTEGER             :: l_usaffiles_rgh
      INTEGER             :: l_cnt_usaffiles
      INTEGER             :: i_usaf_index(l_usaffiles_rgh)
      INTEGER             :: i_usaf_nlines(l_usaffiles_rgh)

      INTEGER             :: l_rgh_char
      INTEGER             :: l_rgh_datalines
      INTEGER             :: l_datalines
      CHARACTER(LEN=l_rgh_char) :: s_linsto_sort(l_rgh_datalines)

      CHARACTER(LEN=l_rgh_char) :: s_header
c*****
c     Variables used in subroutine

      INTEGER             :: i,j,k,ii,jj,kk
      INTEGER             :: io

      INTEGER             :: i_len
      CHARACTER(LEN=4)    :: s_len

      CHARACTER(LEN=300)  :: s_pathandname

      CHARACTER(LEN=l_rgh_char) :: s_linsto_single
c************************************************************************
c      print*,'just entering export_sorted_list'

c      print*,'l_datalines=',l_datalines

c      print*,'directory='//TRIM(s_directory_file_outputsort)//'xx'
c      print*,'shortname='//TRIM(s_shortname_single)//'xx'

      s_pathandname=TRIM(s_directory_file_outputsort)//
     +       TRIM(s_shortname_single)

c      print*,'s_pathandname=',TRIM(s_pathandname)
c      STOP 'export_sorted_list'

c      GOTO 500

c     open file for data export
      OPEN(UNIT=5,
     +  FILE=TRIM(s_pathandname),
     +  FORM='formatted',
     +  STATUS='REPLACE',ACTION='WRITE')

      WRITE(UNIT=5,FMT=1000) ADJUSTL(TRIM(s_shortname_single))
 1000 FORMAT(a20)
 
      WRITE(UNIT=5,FMT=1000) '                    '     !gap
      WRITE(UNIT=5,FMT=1004) 'Number of lines=    ',l_datalines
 1004 FORMAT(a20,t21,i7)
      WRITE(UNIT=5,FMT=1000) '                    '     !gap

      WRITE(UNIT=5,FMT=1002) 'Ind-','USAF ','Number '
      WRITE(UNIT=5,FMT=1002) 'ex  ','Nr.  ','lines  '
      WRITE(UNIT=5,FMT=1002) '+--+','+---+','+-----+'
 1002 FORMAT(t1,a4,t6,a5,t12,a7)

c     Output list of USAF files with line contents
      DO i=1,l_cnt_usaffiles
       WRITE(UNIT=5,FMT=1006) i,i_usaf_index(i),i_usaf_nlines(i)
 1006  FORMAT(t1,i4,t6,i5,t12,i7)
      ENDDO

      WRITE(UNIT=5,FMT=1000) '--------------------'     !gap

c     Place header line here
      i_len=LEN_TRIM(s_header)
      WRITE(s_len,'(i4)') i_len   !convert string length integer-to-string
      WRITE(5,'(a'//TRIM(s_len)//')') ADJUSTL(s_header)

c     Output sorted lines
      DO i=1,l_datalines
c       Create custom format
        s_linsto_single=s_linsto_sort(i) 
        i_len=LEN_TRIM(s_linsto_single)

        WRITE(s_len,'(i4)') i_len   !convert string length integer-to-string

c        print*,'s_linsto_single='//TRIM(s_linsto_single)//'='
c        print*,'i_len=',i_len
c        print*,'s_len=',TRIM(s_len)

        WRITE(5,'(a'//TRIM(s_len)//')') ADJUSTL(s_linsto_sort(i))
      ENDDO

      CLOSE(UNIT=5)

 500  CONTINUE
c************************************************************************
c      print*,'just leaving export_sorted_list'

      RETURN
      END
