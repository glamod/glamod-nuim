Program gen_hmeta_xref
! Purpose: to cross-reference stations in the inventory of stations to add
! with stations in the face station list on the basis of agreement
! between elevations or station names if the distance is sufficiently small.

! Created Spring 2020 by Matt Menne

use ghcndmod
!OCL SERIAL
implicit none

! Arguments:
!... Names of base station list and add station list:
character(len=100) :: cBaseInv, cAddInv
!... output file with coordinate matches:
character(len=100) :: cXRefedFile
!... output file for ad stations without matches:
character(len=100) :: cNotXRefedFile

! Parameters:
integer, parameter :: iUXrefed = 11, iUNotXrefed = 12
real, parameter :: rTooFar = 10.0

! Station list variables:

!... members of stations to add and base stations:
integer :: iNumAStns, iNumBStns
!... coordinates of the stations to add and of base stations:
real, dimension(1:3,1:iMaxnStns) :: rACoords, rBCoords
!... Station IDs of add and base stations:
character(len=11), dimension(1:iMaxnStns) :: cBStnIDs
character(len=15), dimension(1:iMaxnStns) :: cAStnIDs
!... additional metadata for add and base stations:
character(len=51), dimension(1:iMaxnStns) :: cAAuxFields
character(len=40), dimension(1:iMaxnStns) :: cBAuxFields
character(len=30), dimension(1:iMaxnStns) :: cANames, cBNames

! Other station variables:

!... indices of base stations that match one station to add:
integer, dimension(1:iMaxnStns) :: iMatchedBStns
!... Indices of station to add and base station:
integer, dimension(1:iMaxnStns) :: iASrcCodes, iBSrcCodes
integer :: iAStn, iBStn
integer :: iNumXRefedIds ! number of add stations matched
integer :: iALen, iBLen ! Lengths of add and base station names
!... distances (in km) between one add station and all base stations:
real, dimension(1:iMaxnStns) :: rDistances

!other scalars:
integer :: i, iMatch, iNMatches, iNDecimals, iNumNbrs
character (len=30) :: cAName, cBName, cUName
logical :: lExist, lFound


call getarg(1,cBaseInv)
call getarg(2,cAddInv)
call getarg(3,cXrefedFile)
call getarg(4,cNotXrefedFile)

if (cBaseInv=="" .or. cAddInv=="" .or. cXrefedFile=="" .or. &
cNotXrefedFile=="") then
write (*,*) "USAGE: <Current Inventory List> <Inventory of Stations to Add> &
&<output file with coordinate matches> &
& <output file with unmatched add station IDs>"
Endif ! Endif checking on blank arguments

inquire(file=trim(cBaseInv),Exist=lExist)
if (.not. lExist) then
write(*,*) 'Inventory file '//trim(cBaseInv)//' does not exist'
stop
endif

inquire(file=trim(cAddInv),Exist=lExist)
if (.not. lExist) then
write(*,*) 'Inventory file '//trim(cAddInv)//' does not exist'
stop
endif

open(iUMsg,file='gen-meta-xref.log',status='replace')

open(iUXrefed, file=trim(cXrefedFile), status='replace')

open(iUNotXrefed, file=trim(cNotXrefedFile), status='replace')

! Initializations:
iNumXRefedIds = 0
iNumAStns = 0
iNumBStns = 0
cAStnIds = ""
rACoords = real(iMiss)
cAAuxFields = ""
cBStnIds = ""
rBCoords = real(iMiss)
cBAuxFields = ""

! Read in list of stations to potentially add

open(iUStnList,file=trim(cAddInv),status='old')

call readInv(cAStnIds,rACoords,cANames,iASrcCodes,iNumAStns)
write(*,*) iNumAStns

close(iUStnList)

if(iNumAStns == 0) then
write(*,*) 'No Add Stations to compare...exiting'
stop
endif

! Read In list of base stations

open(iUStnList,file=trim(cBaseInv),status='old')

call readBInv(cBStnIds,rBCoords,cBAuxFields,iNumBStns)

close(iUStnList)

if(iNumBStns == 0) then
write(*,*) 'No base Stations to compare...exiting'
stop
endif

write(*,*) "number of base stations = ", iNumBStns
write (*,*) "number of stations to add = ", iNumAStns

do iAStn = 1, iNumAStns

!write (*,*) "processing ", cAStnIds(iAStn)

lFound = .false.
iNMatches = 0

! Identified the nearest base stations.
Call genDistances(rACoords(1:2,iAStn), rBCoords(1:2,:), iNumBStns, rDistances)
iNumNbrs = count(nint(rDistances(1:iNumBStns)*1000.0) == &
nint(minval(rDistances(1:iNumBStns))* 1000.0))
iMatchedBStns(1:iNumNbrs) = pack((/(i, i=1,iNumBStns)/), &
(nint(rDistances(1:iNumBStns)*1000.0) == &
nint(minval(rDistances(1:iNumBStns))* 1000.0)))

if (minval( rDistances(1:iNumBStns)) <= rTooFar) then

do iMatch=1, iNumNbrs ! For each base station with the smallest distance
iBStn = iMatchedBStns(iMatch)

! Check if the station names match when all spaces and punctuation marks are
! excluded.

! Strip The base station name of all blanks and punctuation marks.
iBLen = 0
do i=1,len_trim(cBAuxFields(iBStn)(5:34))
if (Is_alphanumeric(cBAuxFields(iBStn)(i:i)) .and. cBName(i:i) /= "-") then
iBLen = iBLen+1
cBName(iBLen:iBLen) = cBAuxFields(iBStn)(i:i)
Endif
Enddo

! Strip the add station name of all blanks and punctuation marks.
iALen = 0
!do i=1,len_trim(cAAuxFields(iAStn)(5:34))
do i=1,len_trim(cANames(iAStn))
if (Is_alphanumeric(cANames(iAStn)(i:i)) .and. cAName(i:i) /= "-") then
iALen = iALen+1
cAName(iALen:iALen) = cANames(iAStn)(i:i)
Endif
Enddo

cUName(1:iALen) = uppercase(cAName(1:iALen))
if (index(cBName,cUName(1:iALen)) > 0) then

lFound = .true.
iNMatches = iNMatches + 1
write (iUXrefed,'(a15,1x,a11,5x,a1)') adjustl(cAStnIds(iAStn)), adjustl(cBStnIds(iBStn)), "N"

write(iUMsg, '(/, "Match ", i3, " for ", a11, &
&" based on distance and name: ")') iNMatches, cAStnIds(iAStn)
write (iUmsg, '(a15,1x,f8.4,1x,f9.4,1x,f6.1,a51)') cAStnIds(iAStn), &
rACoords(:,iAStn), cAAuxFields(iAStn)
write (iUmsg, '(a15,1x,f8.4,1x,f9.4,1x,f6.1,a51)') cBStnIds(iBStn), &
rBCoords(:,iBStn), cBAuxFields(iBStn)

else ! Names do not match

! Check if elevations match.

do iNDecimals=1,0,-1 ! For incrementally decreasing precision

! If elevations to the nearest 10th of a meter has been compared without
! finding a match and do not have a zero after the decimal point, stop looking
! for elevation matches for this particular pair of stations.

if (iNDecimals == 0 .and. &
mod(nint(rACoords(3,iAStn) * 10.0**real(iNDecimals+1)), 10) > 0 &
.and. mod(nint(rBCoords(3,iBStn) * 10.0**real(iNDecimals+1)), 10) > 0) exit

! Check if the elevations are nearly equal when rounded to the nearest
! iNDecimals decimals.
!if (nint(rACoords(3,iAStn) * 10.0**real(iNDecimals)) &
!== nint(rBCoords(3,iBStn) * 10.0**real(iNDecimals))) then
if (rACoords(3,iAStn) > rBCoords(3,iBStn) - 15.0 .and. &
rACoords(3,iAStn) < rBCoords(3,iBStn) + 15.0) then

lFound = .true.
inmatches = iNMatches + 1
write (iUXrefed,'(a15,1x,a11,5x,a1)') adjustl(cAStnIds(iAStn)), adjustl(cBStnIds(iBStn)), "E"

write(iUMsg, '(/, "Match ", i3, " for ", a11, &
&" based on distance and elevation:" )') iNMatches, cAStnIds(iAStn)
write (iUmsg, '(a15,1x,f8.4,1x,f9.4,1x,f6.1,a51)') cAStnIds(iAStn), &
rACoords(:,iAStn), cAAuxFields(iAStn)
write (iUmsg, '(a15,1x,f8.4,1x,f9.4,1x,f6.1,a51)') cBStnIds(iBStn), &
rBCoords(:,iBStn), cBAuxFields(iBStn)
Exit
endif ! Endif checking if elevations are equal
end do ! End iNDecimals loop for elevation
endif ! Endif checking if names are the same
end do ! End nearest station loop
endif ! Endif checking on distance of nearest neighbor

if (lFound) then ! at least one matching base station found
iNumXRefedIds = iNumXRefedIds + 1

else ! No matching base station found

write (iUNotXrefed,'(a)') cAStnIds(iAStn)
write (iUmsg,*) "No metadata Matsch found for ", cAStnIds(iAStn), ":"
write (iUmsg, '(a11,1x,f8.4,1x,f9.4,1x,f6.1,a51)') cAStnIds(iAStn), &
rACoords(:,iAStn), cAAuxFields(iAStn)
write (iUmsg,*) "Nearest base station(s) ", minval(rDistances(1:iNumBStns)), &
" km away: "
do iMatch=1, iNumNbrs ! For each base station with the smallest distance
iBStn = iMatchedBStns(iMatch)
write (iUmsg, '(a11,1x,f8.4,1x,f9.4,1x,f6.1,a51)') cBStnIds(iBStn), &
rBCoords(:,iBStn), cBAuxFields(iBStn)
end do ! End nearest station loop
Endif

Call flush(iUmsg)
Call flush(iUXrefed)
Call flush(iUNotXrefed)
End do ! End add station loop

close(iUNotXrefed)

close(iUMsg)
close(iUXrefed)
write (*,*) "gen-meta-xref.exe matched ", iNumXRefedIds, &
" add stations with at least one base station."

Contains
!---------------------------------------------------------------------------
subroutine readInv(cStnIds,rCoords,cNames,iSrcCodes,iNumStns)
!read a GHCN formatted station inventory
integer :: iStn, iNumStns, iStat, iSrcCode
integer, dimension(1:iMaxnStns) :: iSrcCodes

real, dimension(1:3,1:iMaxnStns) :: rCoords
real :: rLat, rLon, rElev

character (len=15), dimension(1:iMaxnStns) :: cStnIDs
character (len=51), dimension(1:iMaxnStns) :: cAuxFields
character (len=30), dimension(1:iMaxnStns) :: cNames
character (len=01) :: cFlag
character (len=15) :: cStnId
character (len=50) :: cCountry, cPolicy
character (len=30) :: cName
character (len=02) :: cFIPS1, cFIPS2, cState

iStn=1
do
  !read(iUStnList, '(a15,a1,f8.4,1x,f9.4,1x,f6.1,a51)',IOSTAT=iStat) &
  !cStnIds(iStn), cFlag, rCoords(:,iStn),cAuxFields(iStn)
  read(iUStnList, *,IOSTAT=iStat) iSrcCode,cStnId,rLat,rLon,rElev,&
  cName,cState,cFIPS1,cCountry,cPolicy
!  cStnIds(iStn), cFlag, rCoords(:,iStn),cAuxFields(iStn)
  if (iStat==-1) exit
!  if(cFlag /= ' ') cycle
  cStnIds(iStn) = cStnId
  rCoords(1,iStn) = rLat
  rCoords(2,iStn) = rLon
  rCoords(3,iStn) = rElev
  cNames(iStn) = cName
  iSrcCodes(iStn) = iSrcCode
  iStn=iStn+1
enddo

iNumStns = iStn-1

end subroutine

!-------------------------------------------------------------------------------!---------------------------------------------------------------------------
subroutine readBInv(cStnIds,rCoords,cAuxFields,iNumStns)
!read a GHCN formatted station inventory
integer :: iStn, iNumStns,iStat

real, dimension(1:3,1:iMaxnStns) :: rCoords
character (len=11), dimension(1:iMaxnStns) :: cStnIDs
character (len=40), dimension(1:iMaxnStns) :: cAuxFields
character (len=01) :: cFlag

iStn=1
do
read(iUStnList, '(a11,a1,f8.4,1x,f9.4,1x,f6.1,a40)',IOSTAT=iStat) &
cStnIds(iStn), cFlag, rCoords(:,iStn),cAuxFields(iStn)
if (iStat==-1) exit
if(cFlag /= ' ') cycle
iStn=iStn+1
enddo

iNumStns = iStn-1

end subroutine
!---------------------------------------------------------------------------
subroutine readAInv(cStnIds,rCoords,cAuxFields,iNumStns)
!read a GHCN formatted station inventory
integer :: iStn, iNumStns,iStat

real, dimension(1:3,1:iMaxnStns) :: rCoords
character (len=15), dimension(1:iMaxnStns) :: cStnIDs
character (len=51), dimension(1:iMaxnStns) :: cAuxFields
character (len=01) :: cFlag

iStn=1
do
read(iUStnList, '(a15,a1,f8.4,1x,f9.4,1x,f6.1,a51)',IOSTAT=iStat) &
cStnIds(iStn), cFlag, rCoords(:,iStn),cAuxFields(iStn)
if (iStat==-1) exit
if(cFlag /= ' ') cycle
iStn=iStn+1
enddo

iNumStns = iStn-1

end subroutine

!-------------------------------------------------------------------------------------------------------------------------------
subroutine genDistances(rALatLon,rBLatLons,iNumBStns,rDistances)

integer :: iBStn, iNumBStns

real, dimension(1:iMaxnStns) :: rDistances
real, dimension(1:2) :: rALatLon
real, dimension(1:2,1:iMaxnStns) :: rBLatLons

do iBStn = 1, iNumBStns

rDistances(iBStn) = distance(rALatLon(1), rALatLon(2), rBLatLons(1,iBStn), &
rBLatLons(2,iBStn))*(2*3.14159*6.38*10.0**3.0)/360.0

enddo

return

end subroutine genDistances

logical function is_alphanumeric(cString)
! Purpose: To check if all characters in cString have values between 0 and "9",
! equal to "-", between "A" and "Z", or between "a" and "z".

character (len=*) :: cString
integer :: i
character (len=63) :: &
cAlphabet='0123456789-ABCCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz'

Is_alphanumeric = .true.
do i = 1, len(cString)
if (Index(cAlphabet, cString(i:i)) == 0) then
is_alphanumeric = .false.
exit
Endif
enddo

end function is_alphanumeric
!**********************************************************************

function uppercase(str) result(ucstr)

! convert string to upper case

integer :: i, ilen,iquote, iachar, iav, ioffset, iqc

character (len=*):: str
character (len=len_trim(str)):: ucstr

ilen=len_trim(str)
ioffset=iachar('A')-iachar('a')     
iquote=0
ucstr=str
do i=1,ilen
  iav=iachar(str(i:i))
  if(iquote==0 .and. (iav==34 .or.iav==39)) then
    iquote=1
    iqc=iav
    cycle
  end if
  if(iquote==1 .and. iav==iqc) then
    iquote=0
    cycle
  end if
  if (iquote==1) cycle
  if(iav >= iachar('a') .and. iav <= iachar('z')) then
    ucstr(i:i)=achar(iav+ioffset)
  else
    ucstr(i:i)=str(i:i)
  end if
end do
return

end function uppercase

end Program gen_hmeta_xref

