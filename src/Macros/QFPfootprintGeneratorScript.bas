' Protel Client Basic code QFPfootprintGeneratorScript.bas Aug 22, 2001
'
' Beta ver 1.1
'
' By Brian Guralnick,  email bugs to "brian@point-lab.com"
'
' Generates QFP & TSOP footprints with exact measurements provided
' in most data sheets without having to figure out the pin center.
'
' Thanks to Ian Wilson & Darren Moore for Client Basic help
' on generating the dialog boxes, and Brad Velander & John Williams
' on how to find the protel help on the RunProcess parameters.
'
' Intended to run in the PCBLIB editor.
'

Dim measurement$ (2)
measurement (0) =  "Metric"
measurement (1) =  "Imperial"

DIM offset, pxsize, pysize, pin_outside, pin_inside, pak_xpinc, pak_ypinc, toppin, pinnum, angle, xpos, ypos as DOUBLE
DIM pak_ypins, pak_xsize, pak_xtol, pak_xpins, pak_ysize, pin_space, pin_width, pin_length, pin_xin, pin_xout, etch as DOUBLE

Sub Main

 Begin Dialog DialogName1 20, 20, 280, 200, "QFP & TSOP Footprint Generator."
  Text    35,  10, 300, 11, "Vertical pins in package. (1 side only)"
  Textbox  5,   8,  25, 11, .pak_ypins
  Text    35,  20, 300, 11, "Width of package from vertical pin edge to pin edge."
  Textbox  5,  18,  25, 11, .pak_xsize
  Text    35,  30, 300, 11, "Measurement tolerance for width & height."
  Textbox  5,  28,  25, 11, .pak_xtol

  Text    35,  50, 300, 11, "Horizontal pins in package. (1 side only)"
  Textbox  5,  48,  25, 11, .pak_xpins
  Text    35,  60, 300, 11, "Width of package from horizontal pin edge to pin edge."
  Textbox  5,  58,  25, 11, .pak_ysize

  Text    35,  80, 300, 11, "Pin to Pin Spacing."
  Textbox  5,  78,  25, 11, .pin_space
  Text    35,  90, 300, 11, "Pin width."
  Textbox  5,  88,  25, 11, .pin_width
  Text    35, 100, 300, 11, "Pin length."
  Textbox  5,  98,  25, 11, .pin_length

  Text    35, 120, 300, 11, "Added pin length, in multiples of pin width, underneath IC package."
  Textbox  5, 118,  25, 11, .pin_xin
  Text    35, 130, 300, 11, "Added pin length, in multiples of pin width, outside of IC package."
  Textbox  5, 128,  25, 11, .pin_xout
  Text    35, 140, 300, 11, "Globally added material to compensate for etch.  Usally 0.04mm, or 1mil."
  Textbox  5, 138,  25, 11, .etch
  Text    35, 150, 300, 11, "Pin 1 starting location. 0 = top left, 1 = top middle."
  Textbox  5, 148,  25, 11, .pin1loc


  Text        50,170,300,11, "Measurement Unit."
  DropListBox 5,168,40,62, measurement$(), .munit

  PushButton  20, 185, 30, 12, "Cancel", .Cancel
  OKBUTTON    180, 185, 30, 12
 End Dialog

 ' Dimension an object to represent the dialog.
 Dim Dlg1 As DialogName1

'Default inputs

Dlg1.pak_ypins  = 60    ' number of pins in package vertically
Dlg1.pak_xsize  = 34.60 ' width of package from vertical pin edge to vertical pin edge
Dlg1.pak_xtol   = 0     ' +/- tolerance of package width

Dlg1.pak_xpins  = 60    ' number of pins in package horizontally, enter 0 for a TSOP package
Dlg1.pak_ysize  = 34.60 ' width of package from horizontal pin edge to horizontal pin edge

Dlg1.pin_space  = 0.50  ' pin to pin spacing
Dlg1.pin_width  = 0.27  ' width of pin
Dlg1.pin_length = 0.75  ' length of pin

Dlg1.pin_xin    = 1     ' added pin length underneath the IC in multiples of pin width.  Usually 1
Dlg1.pin_xout   = 2     ' added pin length outside the IC in multiples of pin width.  Usually 2
Dlg1.etch       = 0.04  ' gloabally added material to compensate for the etch
Dlg1.pin1loc    = 0     ' starting pin number at the top left of the package.  0 for top left, 1 for center.

Dlg1.munit      = 0


 Dialog Dlg1                  ' Display the dialog.

    If Dlg1.Cancel = 1 Then
    Exit Sub
    End If


' package generation

offset = 50000 ' imperial center offset
if measurement(Dlg1.munit) = "Metric" then offset = 1270 ' metric center offset
    ResetParameters
    AddStringParameter  "MeasurementUnit", measurement(Dlg1.munit)
    RunProcess          "PCB:DocumentPreferences"

'-----------------------------------------------------------------------------
' DO NOT REMOVE, RESOLVES A BUG WITH FLOATIN POINT ENTRY INTO THE DIALOG BOX
' AND USING THE DIALOG VARIBLES DIRECTLY IN LINE WITH MATH
'-----------------------------------------------------------------------------
pak_ypins  = val (Dlg1.pak_ypins)
pak_xsize  = val (Dlg1.pak_xsize)
pak_xtol   = val (Dlg1.pak_xtol)
pak_xpins  = val (Dlg1.pak_xpins)
pak_ysize  = val (Dlg1.pak_ysize)
pin_space  = val (Dlg1.pin_space)
pin_width  = val (Dlg1.pin_width)
pin_length = val (Dlg1.pin_length)
pin_xin    = val (Dlg1.pin_xin)
pin_xout   = val (Dlg1.pin_xout)
etch       = val (Dlg1.etch)
'------------------------------------------------------------------------------

pxsize = pin_width + etch
pysize = pin_length + (pin_xin * pin_width) + (pin_xout * pin_width) + etch + (pak_xtol * 2)

pin_outside = ( ( pak_xsize + pak_xtol ) / 2 )
pin_inside  = pin_outside - ( pin_length + (pin_xin * pin_width) + (etch / 2 ) + pak_xtol )
pak_xpinc   = pin_inside + (( pin_outside - pin_inside ) / 2 ) + ( (pin_xout * pin_width) / 2 )

pin_outside = ( ( pak_ysize + pak_xtol ) / 2 )
pin_inside  = pin_outside - ( pin_length + (pin_xin * pin_width) + (etch / 2 ) + pak_xtol )
pak_ypinc   = pin_inside + (( pin_outside - pin_inside ) / 2 ) + ( (pin_xout * pin_width) / 2 )

pak_yofs    = pin_space * (pak_ypins -1 ) / 2
pak_xofs    = pin_space * (pak_xpins -1 ) / 2


toppin = ( pak_xpins * 2 ) + ( pak_ypins * 2 )
pinnum = Dlg1.pin1loc * ( pak_xpins / 2 )

angle = 90
for n = 1 to pak_ypins
    xpos = - pak_xpinc
    ypos = pak_yofs - ( (n-1) * pin_space )
    gosub makepin
next n


if pak_xpins <> 0 then
    angle = 180
    for n = 1 to pak_xpins
       xpos = - pak_xofs + ( (n-1) * pin_space )
       ypos = - pak_ypinc
       gosub makepin
    next n
end if


angle = 270
for n = 1 to pak_ypins
    xpos = pak_xpinc
    ypos = - pak_yofs + ( (n-1) * pin_space )
    gosub makepin
next n

if pak_xpins <> 0 then
    angle = 0
    for n = 1 to pak_xpins
       xpos = pak_xofs - ( (n-1) * pin_space )
       ypos = pak_ypinc
       gosub makepin
    next n
end if


Exit Sub


makepin:
    pinnum=pinnum+1:if pinnum>toppin then pinnum=1
      ResetParameters
      AddStringParameter  "Designator", pinnum
      AddStringParameter  "Location.X", xpos + offset
      AddStringParameter  "Location.Y", ypos + offset
      AddStringParameter  "HoleSize",   0
      AddStringParameter  "Rotation",   angle
      AddStringParameter  "Plated",    "True"
      AddStringParameter  "XSize",      pxsize
      AddStringParameter  "YSize",      pysize
      AddStringParameter  "Shape",     "Round"
      AddStringParameter  "DaisyChain","Load"
      AddStringParameter  "Selected",  "False"
      AddStringParameter  "DRCError",  "False"
      AddStringParameter  "Locked",    "False"
      AddStringParameter  "Layer",     "Top"
      RunProcess          "PCB:PlacePad"
return

End Sub