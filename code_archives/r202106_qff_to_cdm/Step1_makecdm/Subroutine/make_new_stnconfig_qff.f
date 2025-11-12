c     Subroutine to make stnconfig file
c     AJ_Kettle, 17Oct2019
c     16Dec2019: modified for qff 

      SUBROUTINE make_new_stnconfig_qff(s_directory_output_receipt,
     +  s_stnname_single,
     +  l_varselect,s_code_observation,
     +  l_cc_rgh,l_collect_cnt,l_scoutput_numfield,ilen,
     +  s_scoutput_vec_header,s_collect_datalines,
     +  i_arch_cnt,s_arch_date_st_yyyy_mm_dd,s_arch_date_en_yyyy_mm_dd)

      IMPLICIT NONE
c************************************************************************
      CHARACTER(LEN=300)  :: s_directory_output_receipt
      CHARACTER(LEN=*)    :: s_stnname_single

      INTEGER             :: l_varselect
      CHARACTER(LEN=*)    :: s_code_observation(l_varselect)

      INTEGER             :: l_cc_rgh
      INTEGER             :: l_collect_cnt
      INTEGER             :: l_scoutput_numfield
      INTEGER             :: ilen

      CHARACTER(LEN=*)    :: s_scoutput_vec_header(50)  

c     Archives up to 50 column & l_cc_rgh lines from stnconfig-write file
      CHARACTER(LEN=ilen) :: s_collect_datalines(l_cc_rgh,50)

c     Archive variables by record number & variable channel number
      CHARACTER(LEN=10)::s_arch_date_st_yyyy_mm_dd(l_cc_rgh,l_varselect)
      CHARACTER(LEN=10)::s_arch_date_en_yyyy_mm_dd(l_cc_rgh,l_varselect)
      INTEGER             :: i_arch_cnt(l_cc_rgh,l_varselect)
c*****
c     Variables used in subroutine

      INTEGER             :: i,j,k,ii,jj,kk

      INTEGER             :: l_vec
      INTEGER             :: l_numvar(l_cc_rgh)
      CHARACTER(LEN=3)    :: s_list_code_obs(l_cc_rgh,l_varselect)
      CHARACTER(LEN=10)   :: s_list_year_st(l_cc_rgh,l_varselect)
      CHARACTER(LEN=10)   :: s_list_year_en(l_cc_rgh,l_varselect)

      CHARACTER(LEN=10)   :: s_single_date 
      CHARACTER(LEN=4)    :: s_single_year 

      CHARACTER(LEN=3)    :: s_vec_single_obs(l_varselect)
      CHARACTER(LEN=4)    :: s_vec_single_year_st(l_varselect)
      CHARACTER(LEN=4)    :: s_vec_single_year_en(l_varselect)

      CHARACTER(LEN=4)    :: s_collect_year_st(l_varselect,l_varselect)
      CHARACTER(LEN=4)    :: s_collect_year_en(l_varselect,l_varselect)
      INTEGER             :: i_collect_year_st(l_varselect,l_varselect)
      INTEGER             :: i_collect_year_en(l_varselect,l_varselect)
      INTEGER             :: i_collect_cnt(l_varselect)

      INTEGER             :: l_distinct
      CHARACTER(LEN=3)    :: s_vec_obscode_distinct(l_varselect)

      INTEGER             :: i_min_st,i_max_en
      CHARACTER(LEN=4)    :: s_min_st,s_max_en
      CHARACTER(LEN=30)   :: s_single_collect_obscode_pre
      CHARACTER(LEN=30)   :: s_single_collect_obscode

      CHARACTER(LEN=4)    :: s_vec_year_st(l_cc_rgh)
      CHARACTER(LEN=4)    :: s_vec_year_en(l_cc_rgh)
      CHARACTER(LEN=30)   :: s_vec_collect_obscode(l_cc_rgh)

      CHARACTER(LEN=ilen) :: s_collect_datalines_output(l_cc_rgh,50)

      INTEGER             :: i_record_hist_integrate(l_cc_rgh)

      CHARACTER(LEN=50)   :: s_strloc_start_date
      CHARACTER(LEN=50)   :: s_strloc_end_date
      CHARACTER(LEN=50)   :: s_strloc_observed_variables
      INTEGER             :: i_index_start_date
      INTEGER             :: i_index_end_date
      INTEGER             :: i_index_observed_variables
c************************************************************************
      print*,'just entered make_new_stnconfig_qff'

c      print*,'ilen=',ilen
c      print*,'l_collect_cnt=',l_collect_cnt
c      print*,'l_varselect=',l_varselect
      
c      DO i=1,l_collect_cnt
c       print*,'i=',i
c       print*,'date_st',(s_arch_date_st_yyyy_mm_dd(i,j),j=1,l_varselect)
c       print*,'date_en',(s_arch_date_en_yyyy_mm_dd(i,j),j=1,l_varselect)
c       print*,'cnt',(i_arch_cnt(i,j),j=1,l_varselect)
c      ENDDO
c******
c     Find columns to replace

c      print*,'l_scoutput_numfield=',l_scoutput_numfield
c      DO i=1,l_scoutput_numfield
c       print*,'i=',i,TRIM(s_scoutput_vec_header(i))
c      ENDDO

      s_strloc_start_date        ='start_date'            !13
      s_strloc_end_date          ='end_date'              !14
      s_strloc_observed_variables='observed_variables'    !29

c     Initialize search indices
      i_index_start_date        =-999
      i_index_end_date          =-999
      i_index_observed_variables=-999

c     Find indices for variables
      DO i=1,l_scoutput_numfield
       IF (TRIM(s_scoutput_vec_header(i)).EQ.TRIM(s_strloc_start_date)) 
     +   THEN
        i_index_start_date=i
       ENDIF 
       IF (TRIM(s_scoutput_vec_header(i)).EQ.TRIM(s_strloc_end_date)) 
     +   THEN
        i_index_end_date=i
       ENDIF 
       IF (TRIM(s_scoutput_vec_header(i)).EQ.
     +   TRIM(s_strloc_observed_variables)) THEN
        i_index_observed_variables=i
       ENDIF 
      ENDDO

c      print*,'replacement variable indices',
c     +  i_index_start_date,i_index_end_date,i_index_observed_variables

      IF (i_index_start_date.LT.0.OR.
     +    i_index_end_date.LT.0.OR.
     +    i_index_observed_variables.LT.0) THEN
       print*,'emergency stop; index not found'
       STOP 'make_new_stnconfig2.f'
      ENDIF
c******
c      print*,'s_directory_output_receipt=',s_directory_output_receipt
c      print*,'s_stnname_single=',s_stnname_single

c      print*,'l_varselect=',l_varselect
c      print*,'s_code_observation=',
c     +  (s_code_observation(i),i=1,l_varselect)
c      print*,'l_collect_cnt=',l_collect_cnt
c      print*,'l_scoutput_numfield=',l_scoutput_numfield

c     For each record number find list of 6 variables represented
      DO i=1,l_collect_cnt    !cycle through record numbers
       jj=0
       DO j=1,l_varselect    !cycle through 6 channels
        IF (i_arch_cnt(i,j).GT.0) THEN
         jj=jj+1
         s_list_code_obs(i,jj)=s_code_observation(j)
         s_single_date=s_arch_date_st_yyyy_mm_dd(i,j)
         s_single_year=s_single_date(1:4)
         s_list_year_st(i,jj) =s_single_year
         s_single_date=s_arch_date_en_yyyy_mm_dd(i,j)
         s_single_year=s_single_date(1:4)
         s_list_year_en(i,jj) =s_single_year
        ENDIF
       ENDDO

       l_numvar(i)=jj
      ENDDO

c      print*,'jj=',jj
c      print*,'l_collect_cnt=',l_collect_cnt
c      DO i=1,l_collect_cnt
c       print*,'s_list_code_obs=',
c     +   (s_list_code_obs(i,j),j=1,l_numvar(i))
c      ENDDO
c*****
c     Integrate all observations for given record number

      DO i=1,l_collect_cnt
       i_record_hist_integrate(i)=0
       DO j=1,l_varselect    !cycle through 6 channels
        i_record_hist_integrate(i)=i_record_hist_integrate(i)+
     +     i_arch_cnt(i,j)
       ENDDO
      ENDDO
c*****
c     Find distinct variable code for each record number
      DO i=1,l_collect_cnt    !cycle though list of record numbers

c      Initialize archival variables
       s_vec_year_st(i)        =''
       s_vec_year_en(i)        =''
       s_vec_collect_obscode(i)=''

       l_vec=l_numvar(i)

c      Act only if there are variables variables for record number
       IF (l_vec.GT.0) THEN 

       DO j=1,l_vec
        s_vec_single_obs(j)=s_list_code_obs(i,j)
        s_vec_single_year_st(j)=s_list_year_st(i,j)
        s_vec_single_year_en(j)=s_list_year_en(i,j)
       ENDDO

       CALL get_strvector_distinct(l_varselect,l_vec,
     +   s_vec_single_obs,
     +   l_distinct,s_vec_obscode_distinct)

c       print*,'l_distinct=',l_distinct
c       print*,'s_vec_obscode_distinct=',
c     +   (s_vec_obscode_distinct(j),j=1,l_distinct)
       
c      Find list of years for distinct variable
       DO ii=1,l_distinct
        kk=0
        DO jj=1,l_vec 
         IF (s_vec_obscode_distinct(ii).EQ.s_vec_single_obs(jj)) THEN 
          kk=kk+1
          s_collect_year_st(ii,kk)=s_vec_single_year_st(jj)
          s_collect_year_en(ii,kk)=s_vec_single_year_en(jj)
         ENDIF
        ENDDO
        i_collect_cnt(ii)=kk
       ENDDO

c       print*,'i_collect_cnt=',(i_collect_cnt(ii),ii=1,l_distinct)

c      Convert string year to integer years
       DO ii=1,l_distinct
        DO jj=1,i_collect_cnt(ii)
         READ(s_collect_year_st(ii,jj),'(i4)') i_collect_year_st(ii,jj)
         READ(s_collect_year_en(ii,jj),'(i4)') i_collect_year_en(ii,jj)
c         print*,'ii,jj...',ii,jj,
c     +     s_collect_year_st(ii,jj),s_collect_year_en(ii,jj)
        ENDDO
       ENDDO

c      Find min start & max end of collection of variables
       i_min_st=+10000
       i_max_en=-10000
       DO ii=1,l_distinct
        DO jj=1,i_collect_cnt(ii)
         i_min_st=MIN(i_min_st,i_collect_year_st(ii,jj))
         i_max_en=MAX(i_max_en,i_collect_year_en(ii,jj))
        ENDDO
       ENDDO

c      Convert integer to string for output
       WRITE(s_min_st,'(i4)') i_min_st
       WRITE(s_max_en,'(i4)') i_max_en

c       print*,'i_min_st,i_max_en=',i_min_st,i_max_en,s_min_st,s_max_en

c      String together distinct variable codes
       s_single_collect_obscode_pre='{'
       DO ii=1,l_distinct
        s_single_collect_obscode_pre=
     +    TRIM(s_single_collect_obscode_pre)//
     +    TRIM(s_vec_obscode_distinct(ii))//','
       ENDDO
       ii=LEN_TRIM(s_single_collect_obscode_pre)
       s_single_collect_obscode=
     +   s_single_collect_obscode_pre(1:ii-1)//'}'

c       print*,'s_single_collect_obscode=',TRIM(s_single_collect_obscode)

c      Archive variables
       s_vec_year_st(i)=s_min_st
       s_vec_year_en(i)=s_max_en
       s_vec_collect_obscode(i)=TRIM(s_single_collect_obscode)

c       print*,'s_vec_year_st=',s_vec_year_st(i)
c       print*,'s_vec_year_en=',s_vec_year_en(i)
c       print*,'s_vec_collect_obscode=',TRIM(s_vec_collect_obscode(i))

       ENDIF    !condition to assess if the report number has observations
      ENDDO     !close i, record number index
c*****
c     UPDATE stnconfig file: Assign values to col 13,14,29
c     Create copy of datalines
      DO i=1,l_cc_rgh              !cycle through record numbers
       DO j=1,50             !cycle through parameter columns
        s_collect_datalines_output(i,j)=s_collect_datalines(i,j)
       ENDDO
      ENDDO

c     Replace certain columns
c     c13: start date
c     c14: end date
c     c29: observed variables
      DO i=1,l_collect_cnt   !cycle through record numbers
       s_collect_datalines_output(i,i_index_start_date)=
     +   TRIM(s_vec_year_st(i))
       s_collect_datalines_output(i,i_index_end_date)=
     +   TRIM(s_vec_year_en(i))
       s_collect_datalines_output(i,i_index_observed_variables)=
     +   TRIM(s_vec_collect_obscode(i))

c       s_collect_datalines_output(i,13)=TRIM(s_vec_year_st(i))
c       s_collect_datalines_output(i,14)=TRIM(s_vec_year_en(i))
c       s_collect_datalines_output(i,29)=TRIM(s_vec_collect_obscode(i))
      ENDDO
c************************************************************************
c     Export receipt file with new stnconfig lines

      CALL export_stnconfig_lines(s_directory_output_receipt,
     +  s_stnname_single,
     +  l_cc_rgh,l_collect_cnt,l_scoutput_numfield,
     +  i_record_hist_integrate,
     +  s_collect_datalines_output,
     +  s_scoutput_vec_header)
c************************************************************************
c*****
      print*,'just leaving make_new_stnconfig_qff'

c      STOP 'make_new_stnconfig'

      RETURN
      END
