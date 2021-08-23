c     Subroutine to get all good ascii characters
c     AJ_KETTLE, Feb24/2018
c     13FEB2019: subroutine used in new data extraction sequence
c     17Jan2019: modified for USAF update

      SUBROUTINE get_ascii_list(l_ascii,i_list_ascii,s_list_asciichar)

      IMPLICIT NONE
c************************************************************************
      INTEGER             :: l_ascii
      INTEGER             :: i_list_ascii(62)
      CHARACTER(LEN=1)    :: s_list_asciichar(62)

      INTEGER             :: i,j,k,ii,jj,kk
c************************************************************************
      print*,'just inside get_ascii_list'

      l_ascii=62

      s_list_asciichar(1)='a'
      s_list_asciichar(2)='b'
      s_list_asciichar(3)='c'
      s_list_asciichar(4)='d'
      s_list_asciichar(5)='e'
      s_list_asciichar(6)='f'
      s_list_asciichar(7)='g'
      s_list_asciichar(8)='h'
      s_list_asciichar(9)='i'
      s_list_asciichar(10)='j'
      s_list_asciichar(11)='k'
      s_list_asciichar(12)='l'
      s_list_asciichar(13)='m'
      s_list_asciichar(14)='n'
      s_list_asciichar(15)='o'
      s_list_asciichar(16)='p'
      s_list_asciichar(17)='q'
      s_list_asciichar(18)='r'
      s_list_asciichar(19)='s'
      s_list_asciichar(20)='t'
      s_list_asciichar(21)='u'
      s_list_asciichar(22)='v'
      s_list_asciichar(23)='w'
      s_list_asciichar(24)='x'
      s_list_asciichar(25)='y'
      s_list_asciichar(26)='z'

      s_list_asciichar(27)='A'
      s_list_asciichar(28)='B'
      s_list_asciichar(29)='C'
      s_list_asciichar(30)='D'
      s_list_asciichar(31)='E'
      s_list_asciichar(32)='F'
      s_list_asciichar(33)='G'
      s_list_asciichar(34)='H'
      s_list_asciichar(35)='I'
      s_list_asciichar(36)='J'
      s_list_asciichar(37)='K'
      s_list_asciichar(38)='L'
      s_list_asciichar(39)='M'
      s_list_asciichar(40)='N'
      s_list_asciichar(41)='O'
      s_list_asciichar(42)='P'
      s_list_asciichar(43)='Q'
      s_list_asciichar(44)='R'
      s_list_asciichar(45)='S'
      s_list_asciichar(46)='T'
      s_list_asciichar(47)='U'
      s_list_asciichar(48)='V'
      s_list_asciichar(49)='W'
      s_list_asciichar(50)='X'
      s_list_asciichar(51)='Y'
      s_list_asciichar(52)='Z'

      s_list_asciichar(53)='0'
      s_list_asciichar(54)='1'
      s_list_asciichar(55)='2'
      s_list_asciichar(56)='3'
      s_list_asciichar(57)='4'
      s_list_asciichar(58)='5'
      s_list_asciichar(59)='6'
      s_list_asciichar(60)='7'
      s_list_asciichar(61)='8'
      s_list_asciichar(62)='9'
c************************************************************************
      DO i=1,l_ascii
       i_list_ascii(i)=ICHAR(s_list_asciichar(i))

c       print *,'i=',i,s_list_asciichar(i),i_list_ascii(i)
      ENDDO
c************************************************************************
      print*,'just leaving get_ascii_list' 

      RETURN
      END
