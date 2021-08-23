c     Subroutine to export list of column headers 
c     AJ_Kettle, May9/2018
c     14Feb2019: subroutine used in re-extraction
c     17Jan2019: modified to for USAF update

      SUBROUTINE export_header_titlelist(s_directory_out3,
     +  s_linget_header)
c************************************************************************
      IMPLICIT NONE
c************************************************************************
c     Variable from outside

      CHARACTER(LEN=*)    :: s_directory_out3
      CHARACTER(LEN=*)    :: s_linget_header
c*****
c     Variables used in subroutine
      INTEGER             :: i,j,k,ii,jj,kk
      INTEGER             :: io

      CHARACTER(LEN=8)    :: s_date_st
      CHARACTER(LEN=10)   :: s_time_st
      CHARACTER(LEN=5)    :: s_zone_st
      INTEGER             :: i_values_st(8)

      CHARACTER(LEN=3)    :: s_filestatus1
      LOGICAL             :: there
      CHARACTER(LEN=300)  :: s_pathandname
      CHARACTER(LEN=300)  :: s_filename

      INTEGER             :: i_len

      INTEGER             :: i_comma_pos(200),i_comma_cnt
      INTEGER             :: i_lenfield(200),i_field_cnt
      CHARACTER(LEN=30)   :: s_field(200)

c************************************************************************
c      print*,'just inside export_header_titlelist'
c******
c******
c     Find date & time
      CALL DATE_AND_TIME(s_date_st,s_time_st,s_zone_st,i_values_st)
c******
c******
      s_filename='list_columnheaders.dat'
      s_pathandname=TRIM(s_directory_out3)//TRIM(s_filename)

      INQUIRE(FILE=TRIM(s_pathandname),
     +  EXIST=there)

      IF (there) THEN
       s_filestatus1='OLD'
      ENDIF
      IF (.NOT.(there)) THEN
       s_filestatus1='NEW'
      ENDIF

c     New file: do procedure
      IF (.NOT.(there)) THEN

c      Find length of line
       i_len=LEN_TRIM(s_linget_header)

c       print*,'i_len=',i_len

c      Sequence to find commas
       i_comma_cnt=1
       DO j=1,i_len   
        IF (s_linget_header(j:j) .EQ. ',') THEN
         i_comma_pos(i_comma_cnt)=j
         i_comma_cnt=i_comma_cnt+1         
        ENDIF
       ENDDO
       i_comma_cnt=i_comma_cnt-1
       i_field_cnt=i_comma_cnt+1

c      Find length of fields
       s_field(1)=
     +   TRIM(ADJUSTL( s_linget_header(1:i_comma_pos(1)-1) ))
       DO j=1,i_comma_cnt-1
        s_field(j+1)=TRIM(ADJUSTL(
     +   s_linget_header(i_comma_pos(j)+1:i_comma_pos(j+1)-1) ))
       ENDDO 
       s_field(i_comma_cnt+1)=TRIM(ADJUSTL(
     +   s_linget_header(i_comma_pos(i_comma_cnt)+1:
     +                   i_comma_pos(i_comma_cnt)+30) ))

c      output results to screen
       DO j=1,i_comma_cnt+1
        i_lenfield(j)=LEN_TRIM(s_field(j))

c        print*,'j=',j,LEN_TRIM(s_field(j)),TRIM(s_field(j))
       ENDDO
c******
       OPEN(UNIT=2,FILE=TRIM(s_pathandname),
     +  FORM='formatted',STATUS='REPLACE',ACTION='WRITE') 

       WRITE(UNIT=2,FMT=3009,IOSTAT=io) 'List of Column Headers   '
       print*,'io=',io
       WRITE(UNIT=2,FMT=3009,IOSTAT=io) '                         '
       print*,'io=',io
3009   FORMAT(a50) 

       WRITE(unit=2,FMT=3029,IOSTAT=io) 'AJ_Kettle ',s_date_st    
       print*,'io=',io
3029   FORMAT(t1,a10,t12,a8) 
       WRITE(unit=2,FMT=3009,IOSTAT=io) 
     + '                                                  '

       DO j=1,i_comma_cnt+1
        WRITE(2,1000) j,i_lenfield(j),ADJUSTL(s_field(j))
 1000   FORMAT(t1,i3,t5,i2,t8,a30)
       ENDDO

       CLOSE(UNIT=2)

      ENDIF
c************************************************************************
c      print*,'just inside export_header_titlelist2'

      RETURN
      END
