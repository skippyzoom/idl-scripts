;+
; Script for building Ex, Ey, Er, and Et from the efield struct a
; given plane.
;
; Created by Matt Young.
;------------------------------------------------------------------------------
;-

;;==Extract component arrays
Ex = efield.x
Ey = efield.y

;;==Free memory
delvar, efield

;;==Calculate magnitude and angle
Er = sqrt(Ex*Ex + Ey*Ey)
Et = atan(Ey,Ex)
