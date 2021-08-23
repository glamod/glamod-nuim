c     Subroutine to separate 1 USAF files
c     AJ_Kettle, 16Jan2020

      SUBROUTINE separate_one_usaf_file1(i_usaf_index,
     +  s_file_sfcobs_no_ext,
     +  s_directory_3headerlist,s_directory_3unsort,
     +  l_ascii,i_list_ascii,s_list_asciichar)

      IMPLICIT NONE
c************************************************************************
c     Declare variables 

      INTEGER             :: i_usaf_index

      CHARACTER(LEN=300)  :: s_file_sfcobs_no_ext
      CHARACTER(LEN=300)  :: s_directory_3unsort
      CHARACTER(LEN=300)  :: s_directory_3headerlist

c     Standard ASCII characters
      INTEGER             :: l_ascii
      INTEGER             :: i_list_ascii(62)
      CHARACTER(LEN=1)    :: s_list_asciichar(62)

      INTEGER,PARAMETER   :: l_distinctstns_rgh=200000
      INTEGER             :: i_distinctstns
      CHARACTER(LEN=20)   :: s_vec_distinctstns(l_distinctstns_rgh) 
c      CHARACTER(LEN=20)   :: s_filelist(l_rgh2)
      INTEGER             :: i_vec_lengthname(l_distinctstns_rgh)
      INTEGER             :: i_vec_refcount(l_distinctstns_rgh)
c*****
c     Variables used in subroutine

      INTEGER             :: i,j,k,ii,jj,kk
      INTEGER             :: io

c     11Feb2020: changed from 3 million to 24 million because of problem file 60
c     12Feb2020: changed from 24 million to 25 million because of problem file 171
      INTEGER, PARAMETER  :: l_rgh=28000000 !24000000 !3000000 !30000000  !rough estimate number of lines in 1file
      INTEGER, PARAMETER  :: l_rgh1=80000    !rough estimate number of stations, 1file  
c      INTEGER, PARAMETER  :: l_rgh2=200000   !rough estimate number stations, all files  
      INTEGER, PARAMETER  :: l_rgh3=4000000  !est number of lines in 1 station in 1 file  

      CHARACTER(LEN=300)  :: s_pathandname

      INTEGER, PARAMETER  :: l_cha=4000      !number of characters across single line
      CHARACTER(LEN=l_cha):: s_linget_header
      CHARACTER(LEN=l_cha):: s_linget

      INTEGER             :: i_len
      INTEGER             :: i_len_single
      INTEGER             :: i_len_test
      INTEGER             :: l_lines_total
      INTEGER             :: ii_rec
      INTEGER             :: ll_rec
      INTEGER             :: ii_stnswitch
      INTEGER             :: ii_overchar
      INTEGER             :: i_val

      CHARACTER(LEN=20)   :: s_platformid(l_rgh)
      CHARACTER(LEN=20)   :: s_networktype(l_rgh)
      CHARACTER(LEN=20)   :: s_reporttype(l_rgh)
      CHARACTER(LEN=14)   :: s_ncdc_ob_time(l_rgh)

      CHARACTER(LEN=20)   :: s_ref1,s_ref2
      CHARACTER(LEN=20)   :: s_test1,s_test2    
      CHARACTER(LEN=20)   :: s_netplatname

c      INTEGER             :: i_index
      CHARACTER(LEN=3)    :: s_filestatus

      CHARACTER(LEN=l_cha):: s_linrec(l_rgh3)
c      CHARACTER(LEN=1000) :: s_linrec(4000)

!      CHARACTER(LEN=14)   :: s_rec_ncdc_ob_time(l_rgh3)

c************************************************************************
      print*,'just entered separate_one_usaf_file1'

      s_pathandname=TRIM(s_file_sfcobs_no_ext)//'.csv'
      print*,'s_pathandname=',TRIM(s_pathandname)

      OPEN(UNIT=1,FILE=s_pathandname,FORM='formatted',
     +  STATUS='OLD',ACTION='READ')      

c     Read header
      READ(1,1000,IOSTAT=io) s_linget_header
1000  FORMAT(a4000)          !changed from 3400 to 4000

c     Export header parameter list 
c      (file with single line of header titles)
      IF (i_usaf_index.EQ.1) THEN 
       CALL export_header_titlelist(s_directory_3headerlist,
     +  s_linget_header)
      ENDIF

      ii=0
      ii_rec=0                    !index for stations in cluster
      ii_stnswitch=0
      ii_overchar=0
c      i_distinctstns=0           !number of distinct stations in file

      DO                         !start loop for all lines in file

c      Read data line
       READ(1,1002,IOSTAT=io) s_linget
1002   FORMAT(a4000)           !changed from 3400 to 4000

       IF (io .GT. 0) THEN
        WRITE(*,*) 'Check input. Something went wrong'
        GOTO 100
       ELSE IF (io .LT. 0) THEN 
        WRITE(*,*) 'end of file reached'
        GOTO 100
       ELSE

c       Line counter
        ii=ii+1

        IF (ii.LT.0) THEN
         print*,'emergency stop; ii<0',ii
        ENDIF

        IF (MOD(ii,1000000).EQ.0) THEN
         print*,'iiat1000000=',ii,ii_stnswitch,ii_overchar
        ENDIF

c        print*,'ii=',ii,ii_rec
c        print*,'s_linget=',TRIM(s_linget)
c        CALL SLEEP(1)

        IF (ii.GE.l_rgh) THEN 
         print*,'emergency stop; too many lines; l_rgh, ii=',l_rgh,ii
         STOP 'separate_one_usaf_file1'
        ENDIF

c       Length of line
        i_len=LEN_TRIM(s_linget)

        IF (i_len.GE.l_cha) THEN 
         ii_overchar=ii_overchar+1
         print*,'emergency stop; line too long; l_cha=',l_cha
c         STOP 'separate_one_usaf_file'
        ENDIF

c       Extract first fields from line
        CALL extract_netplat_info(s_linget,i_len,
     +   l_ascii,i_list_ascii,s_list_asciichar,
     +   s_platformid(ii),s_networktype(ii),
     +   s_reporttype(ii),s_ncdc_ob_time(ii))

cc       Test length date string
c        i_len_single=LEN_TRIM(s_ncdc_ob_time(ii))
c        IF (i_len_single.NE.14) THEN
c         print*,'problem s_ncdc_ob_time, i_len_single=',i_len_single 
c         STOP 'separate_one_usaf_file'
c        ENDIF
c*******
c       First line of file
        IF (ii.EQ.1) THEN 

c        Declare first filename
         s_ref1=TRIM(s_platformid(ii))    !reference established here
         s_ref2=TRIM(s_networktype(ii))
         s_netplatname=TRIM(ADJUSTL(s_ref2))//'_'//TRIM(ADJUSTL(s_ref1))

c        Test length new name
         i_len_test=LEN_TRIM(s_netplatname)
         IF (i_len_test.GT.20) THEN
          print*,'emergency stop, new file name too long',s_netplatname
          STOP 'separate_one_usaf_file1' 
         ENDIF

c        Archive line & ncdc_ob_time: note l_linelimit char width
         ii_rec=ii_rec+1
         s_linrec(ii_rec)=s_linget(1:i_len)   !used linelength
cc         s_rec_ncdc_ob_time(ii_rec)=s_ncdc_ob_time_single

c        update counter for station switch
         ii_stnswitch=ii_stnswitch+1

c        Test ii_rec
         IF (ii_rec.GT.l_rgh3) THEN
          print*,'emergency stop, l_rgh3 exceeded',l_rgh3
          print*,'station has too many lines in 1 USAF file'
          STOP 'read_file_datalines4'
         ENDIF
        ENDIF   !IF (ii.EQ.1) THEN 
c*******
c*******
c       ALL LINES AFTER FIRST
c       All elements after first line
        IF (ii.GT.1) THEN 
         s_test1=TRIM(s_platformid(ii))
         s_test2=TRIM(s_networktype(ii))
c**** 
cXXXX    
c        CASE: Station switch; export data
c        Compare test with reference
c        Condition where this line not equal to last line
         IF (.NOT.(s_test1.EQ.s_ref1.AND.s_test2.EQ.s_ref2)) THEN 

c         create name from baseline netplat
          s_netplatname=
     +      TRIM(ADJUSTL(s_ref2))//'_'//TRIM(ADJUSTL(s_ref1))

c          print*,'condition termination'
c          print*,'s_ref1,2=',TRIM(s_ref1),TRIM(s_ref2)
c          print*,'s_test1,2=',TRIM(s_test1),TRIM(s_test2)

c         END OF RECORD: Write station list with archived lines
          ll_rec=ii_rec     !final length one less than counter

c          print*,'ii,ii_rec=',ii,ii_rec,ll_rec

c         Export line only for certain networks
          IF (TRIM(s_ref2).EQ.'WMO'.OR.TRIM(s_ref2).EQ.'ICAO'.OR.
     +        TRIM(s_ref2).EQ.'AFWA'.OR.TRIM(s_ref2).EQ.'CMANS') THEN
           CALL line_exporter(i_usaf_index,
     +      s_directory_3unsort,
     +      s_netplatname,
     +      s_linget_header,
     +      l_rgh3,ll_rec,s_linrec)
          ENDIF

c         Define new reference quantities
          s_ref1=s_test1
          s_ref2=s_test2

c         Start new line archival: line & ncdc_ob_time
c         NOTE length of line l_linelimit characters
          ii_rec=0
          ii_rec=ii_rec+1
          s_linrec(ii_rec)=s_linget(1:i_len)   !used length of line

c          IF (ii_rec.GE.10) THEN
c           print*,'stopped after 10 station switches',ii_rec 
c           STOP 'separate_one_usaf_file1'
c          ENDIF

c         update counter for station switch
          ii_stnswitch=ii_stnswitch+1

c          print*,'ii...',ii,ii_stnswitch
c          CALL SLEEP(1)

c          STOP 'separate_one_usaf_file1'

c         Must exit condition and et new line at this point
          GOTO 20
         ENDIF     !IF (.NOT.(s_test1.EQ.s_ref1.AND.s_test2.NE.s_ref2)) THEN 
cXXXXX
cYYYYY
c        CASE: Continuation of data line
         IF (s_test1.EQ.s_ref1.AND.s_test2.EQ.s_ref2) THEN 
c          print*,'condition continuation'

c         Increment line archive: note l_linelimit char width
          ii_rec=ii_rec+1
          s_linrec(ii_rec)=s_linget(1:i_len)    !use line length here
         ENDIF       !IF (s_test1.EQ.s_ref1.AND.s_test2.NE.s_ref2) THEN 
cYYYYY
c****

c****
        ENDIF     !ii.GT.1
c*******
       ENDIF      !main reading condition

 20    CONTINUE

      ENDDO

 100  CONTINUE

      CLOSE(UNIT=1)
c*****
cXXXXX
c        END OF RECORD: Write station list with archived lines
         ll_rec=ii_rec     !final length one less than counter

c          print*,'last station ii,ii_rec=',ii,ii_rec

c        create name from baseline netplat
         s_netplatname=TRIM(ADJUSTL(s_ref2))//'_'//TRIM(ADJUSTL(s_ref1))

         IF (TRIM(s_ref2).EQ.'WMO'.OR.TRIM(s_ref2).EQ.'ICAO'.OR.
     +       TRIM(s_ref2).EQ.'AFWA'.OR.TRIM(s_ref2).EQ.'CMANS') THEN
          CALL line_exporter(i_usaf_index,
     +      s_directory_3unsort,
     +      s_netplatname,
     +      s_linget_header,
     +      l_rgh3,ll_rec,s_linrec)
         ENDIF
cXXXXX
c*****
      l_lines_total=ii

      print*,'l_lines_total=',l_lines_total,ii_stnswitch,ii_overchar

      print*,'just leaving separate_one_usaf_file1'
c      STOP 'separate_one_usaf_file1'

      RETURN
      END
