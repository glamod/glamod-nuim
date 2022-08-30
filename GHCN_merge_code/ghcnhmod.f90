module ghcnhmod

integer,parameter::iMinYr=1750
integer,parameter::iMaxYr=2022
integer,parameter::iMaxnStns = 115000 
integer,parameter::iMaxnSourcePaths = 110
integer,parameter::iMaxnSourceRecs = 110

integer, parameter :: iBeginYear = 1600
integer, parameter :: iEndYear = 2300

integer,parameter::iUStnList=21,iUMingleList=22,iUElemList=23,iUMsg=25,iUCountryCodes=26,iUXref=27
integer,parameter::iUFIPS=28,iUSourceList=30
integer,parameter::TMAX=1, TMIN=2, TOBS=3, PRCP=4, SNOW=5, SNWD=6
integer,parameter::iMaxNElem=250

integer::iNElem, iNValidElem, MDPR, DAPR, DWPR, MDTX, DATX, MDTN, DATN

character(80)::cBaseDir
! Initialize the first six elements of cElems (they are always the same)
character(4), dimension(iMaxNElem)::cElems 
character(4), dimension(iMaxNElem)::cValidElems
character(len=03), dimension(iMaxnSourcePaths) :: cSourceCodes=(/'88 ',&
'171',&
'172',&
'174',&
'176',&
'177',&
'179',&
'180',&
'245',&
'247',&
'248',&
'249',&
'250',&
'251',&
'252',&
'253',&
'254',&
'255',&
'256',&
'257',&
'258',&
'260',&
'261',&
'262',&
'263',&
'264',&
'265',&
'266',&
'267',&
'268',&
'269',&
'270',&
'271',&
'272',&
'273',&
'274',&
'275',&
'276',&
'277',&
'278',&
'279',&
'280',&
'281',&
'282',&
'283',&
'284',&
'285',&
'286',&
'287',&
'288',&
'289',&
'290',&
'291',&
'292',&
'293',&
'294',&
'295',&
'296',&
'297',&
'298',&
'299',&
'300',&
'302',&
'303',&
'304',&
'305',&
'306',&
'307',&
'308',&
'309',&
'310',&
'311',&
'316',&
'317',&
'318',&
'320',&
'321',&
'322',&
'323',&
'324',&
'325',&
'326',&
'327',&
'328',&
'329',&
'330',&
'331',&
'332',&
'333',&
'334',&
'336',&
'337',&
'338',&
'339',&
'340',&
'220',&
'221',&
'222',&
'223',&
'319',&
'313',&
'314',&
'315',&
'335',&
'341',&
'342',&
'343',&
'344',&
'345',&
'346'/)
character(len=02), dimension(iMaxnSourcePaths) :: cNetworkCodes=(/'U0',&
'U0',&
'U0',&
'U0',&
'U0',&
'U0',&
'U0',&
'U0',&
'U0',&
'U0',&
'U0',&
'U0',&
'U0',&
'U0',&
'U0',&
'U0',&
'P0',&
'U0',&
'U0',&
'U0',&
'U0',&
'U0',&
'U0',&
'U0',&
'U0',&
'N0',&
'U0',&
'U0',&
'U0',&
'U0',&
'U0',&
'U0',&
'U0',&
'U0',&
'U0',&
'U0',&
'U0',&
'U0',&
'U0',&
'U0',&
'U0',&
'U0',&
'U0',&
'U0',&
'U0',&
'U0',&
'U0',&
'U0',&
'U0',&
'U0',&
'U0',&
'U0',&
'U0',&
'U0',&
'U0',&
'U0',&
'U0',&
'U0',&
'U0',&
'U0',&
'U0',&
'U0',&
'U0',&
'U0',&
'U0',&
'U0',&
'U0',&
'U0',&
'U0',&
'U0',&
'U0',&
'U0',&
'U0',&
'U0',&
'M0',&
'U0',&
'U0',&
'U0',&
'U0',&
'U0',&
'U0',&
'U0',&
'U0',&
'U0',&
'U0',&
'U0',&
'U0',&
'U0',&
'N0',&
'U0',&
'U0',&
'U0',&
'U0',&
'U0',&
'U0',&
'M0',&
'A0',&
'CM',&
'I0',&
'N0',&
'W0',&
'W0',&
'W0',&
'W0',&
'N0',&
'N0',&
'W0',&
'W0',&
'W0',&
'W0'/)
								       	
contains
!------------------------------------------------------------------------------------------------
      real function distance (lat1, lon1, lat2, lon2)
! Purpose: To calculate the great circle distance (in units of great 
! circle degrees) between two pairs of latitude/longitude coordinates.
!
! Obtained from Russell Vose - September 2001

      real lat1, lat2, lon1, lon2, degrad, pi, raddeg,& 
          rlat1, rlat2, rlon1, rlon2

      pi = 2.0 * acos(0.0)
      raddeg = 180.0 / pi
      degrad = 1.0 / raddeg

      rlat1 = lat1 * degrad
      rlon1 = lon1 * degrad
      rlat2 = lat2 * degrad
      rlon2 = lon2 * degrad

      distance = 2.0 * raddeg * asin(sqrt(&
                sin((rlat1 - rlat2) / 2.0) *&
                sin((rlat1 - rlat2) / 2.0) +&
                cos(rlat1) *&
                cos(rlat2) *&
                sin((rlon1 - rlon2) / 2.0) *&
                sin((rlon1 - rlon2) / 2.0) ))

      return
      end function
!----------------------------------------------------------------------------------------
 integer function iIndexinSrcHierarchy(cSource)

 character(len=03) :: cSource
 integer :: iSrc

 iIndexinSrcHierarchy = 0

 do iSrc = 1, iMaxnSourcePaths

   if(cSourceCodes(iSrc) == cSource) then 
      iIndexinSrcHierarchy = iSrc
      exit
   end if

 end do

 end function


!------------------------------------------------------------------------------!
subroutine initcElems()

! This subroutine initializes cELems to the six primary elements and blanks

integer :: iii

cElems =(/'TMAX','TMIN','TOBS','PRCP','SNOW','SNWD',('    ',iii=7,iMaxNElem)/)

end subroutine
!------------------------------------------------------------------------------!
subroutine getcElems(cDSI,cStn)

! This subroutine populates the cElems vector with all possible element codes
! for a station.

! Declarations for local variables

implicit none

integer :: istat

character(15), intent(in) :: cDSI
character(11), intent(in) :: cStn

call initcElems()

! Remove the 'tmp.cElems' file from the previous run if it still exists.

!call system('rm -f tmp.cElems')

! Create a file listing all unique element codes for this station.
! Because the location of the element field on a line varies by source,
! there are two different system calls for this purpose.
! The first is for the 32xx format, and the second is for GHCN-Daily format.

if (cDSI(1:3) == '320' .or. cDSI == 'forts') then
  call system('cut -c 12-15 '//cBaseDir(1:len_trim(cBaseDir))//trim(cDSI)//'/rawdata/'//cStn(1:6)// &
       '| sort -u | grep -v TMAX | grep -v TMIN | grep -v TOBS | grep -v PRCP | grep -v SNOW | grep -v SNWD > tmp.cElems')
elseif(cDSI(1:3) == '321') then
  call system('cut -c 12-15 '//cBaseDir(1:len_trim(cBaseDir))//trim(cDSI)//'/rawdata/'//cStn(1:5)// &
       '| sort -u | grep -v TMAX | grep -v TMIN | grep -v TOBS | grep -v PRCP | grep -v SNOW | grep -v SNWD > tmp.cElems')
end if

! Open the file and input the list of unique element codes.
! Note that the first "n" elements are always TMAX, TMIN, TOBS, PRCP,
! SNOW, SNWD.  This "hardwiring" was done before this subroutine came
! into existence, and the resulting implication is that the first unique
! element read from the file is always stored in row "n+1" of "cElems"
! (as determined by count(cElems/='    ').

  open(unit=iUElemList,file='tmp.cElems',status='old')
  iNElem = count(cElems/='    ')
  do
    iNElem = iNElem + 1
    read(iUElemList,'(a4)',iostat=istat) cElems(iNElem)
    if (istat == -1) exit
  end do
  iNElem = iNElem - 1
  
! Close and remove the temporary file.

  close(iUElemList)
  call system('rm -f tmp.cElems')

end subroutine getcElems
!------------------------------------------------------------------------------!
subroutine getGhcndElems(cDataFile)

! This subroutine populates the cElems vector with all possible element codes
! for a station.

! Declarations for local variables

implicit none

integer :: istat

character(*), intent(in) :: cDataFile

 call initcElems()

! Create a file listing all unique element codes for this station.
! Because the location of the element field on a line varies by source,
! there are two different system calls for this purpose.
! The first is for the 32xx format, and the second is for GHCN-Daily format.

 call system('cut -c18-21 '//cDataFile(1:len_trim(cDataFile))// &
       '| sort -u | grep -v TMAX | grep -v TMIN | grep -v TOBS | grep -v PRCP | grep -v SNOW | grep -v SNWD > tmp.cElems')

! Open the file and input the list of unique element codes.
! Note that the first "n" elements are always TMAX, TMIN, TOBS, PRCP,
! SNOW, SNWD.  This "hardwiring" was done before this subroutine came
! into existence, and the resulting implication is that the first unique
! element read from the file is always stored in row "n+1" of "cElems"
! (as determined by count(cElems/='    ').

 open(unit=iUElemList,file='tmp.cElems',status='old')
 iNElem = count(cElems/='    ')
 do
  iNElem = iNElem + 1
    read(iUElemList,'(a4)',iostat=istat) cElems(iNElem)
    if (istat == -1) exit
 end do
 iNElem = iNElem - 1
  
! Close and remove the temporary file.

 close(iUElemList)
 call system('rm -f tmp.cElems')

end subroutine getGhcndElems
!------------------------------------------------------------------------------!
subroutine getValidElems()

implicit none

integer :: iStat

open(iUElemList,file=trim(cBaseDir)//'input4sys/ghcnd-elements.txt',status='old')

iNValidElem = 1

do
  read(iUElemList,'(a4)',IOSTAT=iStat) cValidElems(iNValidElem)
  if(iStat==-1) exit
  iNValidElem = iNValidElem + 1
end do
iNValidElem = iNValidElem - 1

close(iUElemList)

end subroutine
!----------------------------------------------------------------------------!
      function str2upper (input_string) result (output_string)
! Change all the lowercase characters in the string to uppercase.
! Leave all other characters unchanged.
      character(*), intent(in)        :: input_string
      character(len(input_string))    :: output_string
      integer :: i, j
      do i = 1, len(input_string)
         j = iachar(input_string(i:i))
         if (j >= 97 .and. j <= 122) then
            output_string(i:i) = achar(j-32)
         else
            output_string(i:i) = input_string(i:i)
         endif
      enddo
      end function str2upper
     
end module
