c     Program to convert USAF data to flat
c     AJ_Kettle, May16/2018
c     01Dec2019: converted from string_convert_float3.f from P20180321_inven

      SUBROUTINE string_convert_float_qff(f_ndflag,
     +  l_rgh_numlines,i_datalinecnt,l_clen,
     +  s_windspeed,
     +  f_windspeed,
     +  i_numgood,i_numbad)

      IMPLICIT NONE
c************************************************************************
c     Variables passed into subroutine

      REAL                :: f_ndflag
      INTEGER             :: l_rgh_numlines
      INTEGER             :: i_datalinecnt
      INTEGER             :: l_clen

      CHARACTER(LEN=l_clen):: s_windspeed(l_rgh_numlines)
      REAL                :: f_windspeed(l_rgh_numlines)
      INTEGER             :: i_numgood
      INTEGER             :: i_numbad
c*****
c     Variables used inside subroutine

      INTEGER             :: i,j,k,ii,jj,kk

      INTEGER             :: i_lentest
      CHARACTER(LEN=l_clen):: s_testtrim
      CHARACTER(LEN=1)    :: s_testtrim1
c************************************************************************
c      print*,'just inside string_convert_float'
c      print*,'l_rgh_numlines=',l_rgh_numlines
c      print*,'i_datalinecnt=', i_datalinecnt
c      print*,'f_ndflag=',      f_ndflag

      i_numgood=0
      i_numbad =0

      DO i=1,i_datalinecnt
c      Initialize f_windspeed
       f_windspeed(i)=f_ndflag

       i_lentest=LEN_TRIM(s_windspeed(i))
c       print*,'i...',i,i_lentest,s_windspeed(i)

c      test length of field
       IF (i_lentest.GT.0) THEN 

c       test if variable has allowed characters
        s_testtrim=TRIM(s_windspeed(i))
        s_testtrim1=s_testtrim(1:1)
        IF (s_testtrim1.EQ.'0'.OR.s_testtrim1.EQ.'1'.OR. 
     +      s_testtrim1.EQ.'2'.OR.s_testtrim1.EQ.'3'.OR.
     +      s_testtrim1.EQ.'4'.OR.s_testtrim1.EQ.'5'.OR.
     +      s_testtrim1.EQ.'6'.OR.s_testtrim1.EQ.'7'.OR.
     +      s_testtrim1.EQ.'8'.OR.s_testtrim1.EQ.'9'.OR.
     +      s_testtrim1.EQ.'.'.OR.
     +      s_testtrim1.EQ.'-'.OR.s_testtrim1.EQ.'+') THEN
         READ(s_windspeed(i),*) f_windspeed(i)

         i_numgood=i_numgood+1

         GOTO 10
        ENDIF

        i_numbad =i_numbad+1

        print*,'error float conversion:'
        print*,'i=',i
        print*,'s_testtrim1:|'//TRIM(s_testtrim1)//'|'
        print*,'s_testtrim:|'//TRIM(s_testtrim)//'|'

 10     CONTINUE
       ENDIF
      ENDDO

      IF (i_numbad.GT.0) THEN 
       print*,'i_numgood,i_numbad',i_numgood,i_numbad
      ENDIF
c************************************************************************
c      print*,'f_param=',(f_windspeed(i),i=1,5)
c      print*,'just leaving string_convert_float_qff'

      RETURN
      END
