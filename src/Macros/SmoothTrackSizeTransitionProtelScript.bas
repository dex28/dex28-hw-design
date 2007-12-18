' Protel Client Basic code SmoothTrackSizeTransitionProtelScript.bas June 19, 2001
'
' Created by Brian Guralnick June 2001, email: brian@point-lab.com
'
' Thanks to Eric Albach for the protel controlls,
' method of interacting with Protel, & the
' all important REM "Client basic uses only integers!"
'
' Thanks to Paul Hutchinson for the input box lines.
'
' Other goodies available at:
' ftp://ftp.point-lab.com/quartus/Public/ProtelUsers/
' (copy & paste this address in your internet explorer address bar.)
'

DIM xc0,xc1,dstart,dend,xinc,xlen,xstart,ystart,diam,res,tmp as DOUBLE

xstart = InputBox$("Enter starting left x location", "Start X", "3000")
ystart = InputBox$("Enter center y location", "Center Y", "3000")
xlen = InputBox$("Length of track", "Length", "500")
dstart = InputBox$("Enter initial track width", "Initial track width", "10")
dend = InputBox$("Enter final track width", "Final track width", "45")
res = InputBox$("Enter resolution (1=low, 10=high)", "Resolution", "4")


dstart=dstart*res
dend=dend*res
xinc = xlen / ( dend - dstart )
xc0 = xstart

if dend < dstart then tmp = dstart : dstart = dend : dend = tmp

for diam = dstart to dend
    xc1=xc0+xinc
      ResetParameters
      AddStringParameter  "Width",(diam/res)
      AddStringParameter  "Location1.X", xc0
      AddStringParameter  "Location1.Y", ystart
      AddStringParameter  "Location2.X", xc1
      AddStringParameter  "Location2.Y", ystart
'      AddStringParameter  "UserRouted", "False"
      AddStringParameter  "Layer", "Current"
      RunProcess          "PCB:PlaceTrack"
   xc0=xc1

next diam


end