c     Subroutine to make histogram 
c     AJ_Kettle, Sept16/2017

      SUBROUTINE make_hist_lprod_dd(l_data1,i_arch_lprod,
     +  l_hist_dd,i_xhist_dd,i_yhist_dd,s_xhist_dd_label)

      IMPLICIT NONE
c************************************************************************
c     Declare variables

      INTEGER             :: l_data1
      INTEGER             :: i_arch_lprod(100000)

      INTEGER             :: l_hist_dd
      INTEGER             :: i_xhist_dd(20),i_yhist_dd(20)
      CHARACTER(LEN=20)   :: s_xhist_dd_label(20)

      INTEGER             :: i,j
c************************************************************************
      l_hist_dd=12

      i_xhist_dd(1)=1*31
      i_xhist_dd(2)=12*31
      i_xhist_dd(3)=24*31
      i_xhist_dd(4)=60*31
      i_xhist_dd(5)=120*31
      i_xhist_dd(6)=240*31
      i_xhist_dd(7)=600*31
      i_xhist_dd(8)=1200*31
      i_xhist_dd(9)=1800*31
      i_xhist_dd(10)=2400*31
      i_xhist_dd(11)=3000*31
      i_xhist_dd(12)=3600*31

      s_xhist_dd_label(1)='1month_to_1year' 
      s_xhist_dd_label(2)='1_to_2_years' 
      s_xhist_dd_label(3)='2_to_5_years' 
      s_xhist_dd_label(4)='5_to_10_years' 
      s_xhist_dd_label(5)='10_to_20_years' 
      s_xhist_dd_label(6)='20_to_50_years' 
      s_xhist_dd_label(7)='50_to_100_years' 
      s_xhist_dd_label(8)='100_to_150_years' 
      s_xhist_dd_label(9)='150_to_200_years' 
      s_xhist_dd_label(10)='200_to_250_years' 
      s_xhist_dd_label(11)='250_to_300_years' 

c     Initialize histogram
      DO i=1,l_hist_dd
       i_yhist_dd(i)=0.0
      ENDDO

      DO i=1,l_data1
       DO j=1,l_hist_dd-1
        IF (i_arch_lprod(i).GE.i_xhist_dd(j).AND.
     +      i_arch_lprod(i).LT.i_xhist_dd(j+1)) THEN 
         i_yhist_dd(j)=i_yhist_dd(j)+1
        ENDIF
       ENDDO
      ENDDO

      print*,'i_yhist_dd=',(i_yhist_dd(i),i=1,l_hist_dd)

      RETURN
      END