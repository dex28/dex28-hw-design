' Protel Client Basic code InductorGeneratorProtelScript.bas June 19, 2001
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

DIM p,pi,xc0,xc1,yc0,yc1 as DOUBLE
pi = 3.141592654#

res = 10       'Inverted resolution

'Added by P.H. 6/14/2001
x0 = InputBox$("Enter inductors left x location", "Center X", "3000")
y0 = InputBox$("Enter inductors center y location", "Center Y", "3000")
spacing = InputBox$("Enter inductors track-track spacing", "Spacing", "20")
yspace = InputBox$("Enter inductors length", "Length", "100")
loops = InputBox$("Enter number of S turns", "Number of loops", "4")
trackwidth = InputBox$("Enter inductors track width", "Track width", "10")

direct = 1
yspace = yspace / 2
xspace = 0
xc0 = 0
yc0 = 0


for mloop = 1 to loops

    ' ClientBasic uses only integers with For-Next loops
    FOR p0 = 0 TO pi * res
       p = p0 / res
       xc1 = ((spacing/2)-(COS(p) * spacing)/2) + xspace
       yc1 = (direct*(SIN(p) * spacing)/2) + yspace
          ResetParameters
          AddStringParameter  "Width",trackwidth
          AddStringParameter  "Location1.X", x0 + xc0
          AddStringParameter  "Location1.Y", y0 + yc0
          AddStringParameter  "Location2.X", x0 + xc1
          AddStringParameter  "Location2.Y", y0 + yc1
    '      AddStringParameter  "UserRouted", "False"
          AddStringParameter  "Layer", "Current"
          RunProcess          "PCB:PlaceTrack"
       xc0=xc1
       yc0=yc1
    NEXT p0

    direct = -direct
    yspace = -yspace
    xspace = xspace + spacing
    ' ClientBasic uses only integers with For-Next loops
    FOR p0 = 0 TO pi * res
       p = p0 / res
       xc1 = ((spacing/2)-(COS(p) * spacing)/2) + xspace
       yc1 = (direct*(SIN(p) * spacing)/2) + yspace
          ResetParameters
          AddStringParameter  "Width",trackwidth
          AddStringParameter  "Location1.X", x0 + xc0
          AddStringParameter  "Location1.Y", y0 + yc0
          AddStringParameter  "Location2.X", x0 + xc1
          AddStringParameter  "Location2.Y", y0 + yc1
    '      AddStringParameter  "UserRouted", "False"
          AddStringParameter  "Layer", "Current"
          RunProcess          "PCB:PlaceTrack"
       xc0=xc1
       yc0=yc1
    NEXT p0
    direct = -direct
    yspace = -yspace
    xspace = xspace + spacing

next mloop

xc1 = xspace
yc1 = 0
      ResetParameters
      AddStringParameter  "Width",trackwidth
      AddStringParameter  "Location1.X", x0 + xc0
      AddStringParameter  "Location1.Y", y0 + yc0
      AddStringParameter  "Location2.X", x0 + xc1
      AddStringParameter  "Location2.Y", y0 + yc1
'      AddStringParameter  "UserRouted", "False"
      AddStringParameter  "Layer", "Current"
      RunProcess          "PCB:PlaceTrack"

end