c     Subroutine to test filename against running list; uses UNIT=2
c     AJ_KETTLE, 20Jan2020

      SUBROUTINE line_exporter(i_usaf_index,
     +  s_directory_3unsort,
     +  s_netplatname,
     +  s_linget_header,
     +  l_rgh3,ll_rec,s_linrec)

      IMPLICIT NONE
c************************************************************************
c     Variables passed into program

      INTEGER             :: i_usaf_index

      CHARACTER(LEN=300)  :: s_directory_3unsort
      CHARACTER(LEN=20)   :: s_netplatname

      CHARACTER(LEN=*)    :: s_linget_header
      INTEGER             :: l_rgh3
      INTEGER             :: ll_rec
      CHARACTER(LEN=*)    :: s_linrec(l_rgh3)
c*****
c     Variables used in subroutine

      INTEGER             :: i,j,k,ii,jj,kk

      CHARACTER(LEN=300)  :: s_pathandname1

      CHARACTER(LEN=3)    :: s_filestatus1
      LOGICAL             :: there

      INTEGER             :: i_len
      CHARACTER(LEN=4)    :: s_len
c************************************************************************
c      print*,'just inside line_exporter.f'

c     Inquire if file exists
      s_pathandname1=
     +  TRIM(s_directory_3unsort)//TRIM(s_netplatname)//'.csv'

c      print*,'before inquire'//TRIM(s_pathandname1)//'x'

      INQUIRE(FILE=TRIM(s_pathandname1),
     +  EXIST=there)

      IF (there) THEN
       s_filestatus1='OLD'
      ENDIF
      IF (.NOT.(there)) THEN
       s_filestatus1='NEW'
      ENDIF
c********
c********
c     Case of new file
      IF (s_filestatus1.EQ.'NEW') THEN 
c********
c      Main data file UNIT2
       OPEN(UNIT=2,
     +  FILE=TRIM(s_pathandname1),
     +  FORM='formatted',
     +  STATUS='NEW',ACTION='WRITE')

c      Place header line at top
c      Create custom format 
       i_len=LEN_TRIM(s_linget_header)
       WRITE(s_len,'(i4)') i_len   !convert string length integer-to-string
       WRITE(2,'(a'//TRIM(s_len)//')') ADJUSTL(s_linget_header)
c***
c      Output usaf number
       WRITE(UNIT=2,FMT=1) 'USAF_index=',i_usaf_index,ll_rec
1      FORMAT(t1,a11,t13,i5,t19,i6) 
c***
c      Output data lines underneath
       DO ii=1,ll_rec

c       Create custom format
        i_len=LEN_TRIM(s_linrec(ii))+1
        WRITE(s_len,'(i4)') i_len   !convert string length integer-to-string

        WRITE(2,'(a'//TRIM(s_len)//')') ADJUSTL(s_linrec(ii))

       ENDDO
       CLOSE(UNIT=2)
c********
      ENDIF
c********
c********
c     Case of old file
      IF (s_filestatus1.EQ.'OLD') THEN 
c       print*,'old condition met'
c********
c      Main data file

       OPEN(UNIT=2,
     +  FILE=TRIM(s_pathandname1),
     +  FORM='formatted',
     +  STATUS='OLD',ACTION='WRITE',ACCESS='APPEND')
c***
c      Output usaf number
       WRITE(UNIT=2,FMT=1) 'USAF_index=',i_usaf_index,ll_rec 
c***
       DO ii=1,ll_rec

c       Create custom format 
        i_len=LEN_TRIM(s_linrec(ii))
        WRITE(s_len,'(i4)') i_len   !convert string length integer-to-string

        WRITE(2,'(a'//TRIM(s_len)//')') ADJUSTL(s_linrec(ii))

       ENDDO

       CLOSE(UNIT=2)
c********
c********

      ENDIF      !close condition filestatus=old

c************************************************************************
c      print*,'just leaving line_exporter'

      RETURN
      END
