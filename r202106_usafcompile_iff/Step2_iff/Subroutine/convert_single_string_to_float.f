c     Subroutine to convert single string to float
c     AJ_Kettle, 27Feb2019
c     14Mar2020: used in USAF update

      SUBROUTINE convert_single_string_to_float(s_input,f_ndflag,
     +  f_output,i_badflag)

      IMPLICIT NONE
c************************************************************************
c     Declare variables passed into program

      CHARACTER(LEN=100)  :: s_input
      REAL                :: f_ndflag
      REAL                :: f_output
      INTEGER             :: i_badflag
c*****
c     Variables used within program

      CHARACTER(1)        :: s_testtrim1
c************************************************************************
c     Initialize to bag
      i_badflag=1

c     Trim input string
c      s_inputtrim=TRIM(s_input)
      s_testtrim1=s_input(1:1)

      IF   (s_testtrim1.EQ.'0'.OR.s_testtrim1.EQ.'1'.OR. 
     +      s_testtrim1.EQ.'2'.OR.s_testtrim1.EQ.'3'.OR.
     +      s_testtrim1.EQ.'4'.OR.s_testtrim1.EQ.'5'.OR.
     +      s_testtrim1.EQ.'6'.OR.s_testtrim1.EQ.'7'.OR.
     +      s_testtrim1.EQ.'8'.OR.s_testtrim1.EQ.'9'.OR.
     +      s_testtrim1.EQ.'.'.OR.
     +      s_testtrim1.EQ.'-'.OR.s_testtrim1.EQ.'+') THEN
       READ(s_input,*) f_output
       i_badflag=0

       GOTO 10
      ENDIF

c     If there then conversion failed
      f_output=f_ndflag
      i_badflag=1

 10   CONTINUE

      RETURN
      END
