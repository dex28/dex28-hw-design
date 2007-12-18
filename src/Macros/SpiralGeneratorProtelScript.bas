' Protel Client Basic code SpiralGeneratorProtelScript.bas June 19, 2001
'
' Creates spiral track pattern based on numerical parameters
'
' Written by Eric Albach and posted to the
' Protel EDA Forum on June 2001 (see www.techservinc.com)
'
' Based on Qbasic code written by Brian Guralnick and posted to the
' Protel EDA Forum June 2001
'
' InputBox lines added by Paul Hutchinson June 2001
'
' Removed the integers by Brian Guralnick, June 18, 2001
'

DIM x0,y0,stp,growth as DOUBLE
DIM p,p0,pi,xc0,xc1,yc0,yc1 as DOUBLE
pi = 3.141592654#

'Added by P.H. 6/14/2001
x0 = InputBox$("Enter spiral center x location", "Center X", "3000")
y0 = InputBox$("Enter spiral center y location", "Center Y", "3000")
spacing = InputBox$("Enter spiral spacing", "Spacing", "20")
loops = InputBox$("Enter number of loops", "Number of loops", "4")
res = InputBox$("Enter spiral resolution", "Resolution", "1")
trackwidth = InputBox$("Enter spiral track width", "Track width", "10")


loops = loops * 2
stp = res / pi / 4
growth = spacing / pi * stp / 2

' ClientBasic uses only integers with For-Next loops
FOR p0 = 0 TO loops * pi / stp + 1
   p = p0 * stp - stp
   xc1 = (COS(p) * spacing)
   yc1 = (SIN(p) * spacing)
   spacing = spacing + growth
   if p0<>0 then
      ResetParameters
      AddStringParameter  "Width",trackwidth
      AddStringParameter  "Location1.X", x0 + xc0
      AddStringParameter  "Location1.Y", y0 + yc0
      AddStringParameter  "Location2.X", x0 + xc1
      AddStringParameter  "Location2.Y", y0 + yc1
'      AddStringParameter  "UserRouted", "False"
      AddStringParameter  "Layer", "Current"
      RunProcess          "PCB:PlaceTrack"
   end if
   xc0=xc1
   yc0=yc1
NEXT p0