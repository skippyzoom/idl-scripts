;+
; Script for calculating E = -Grad[phi] from EPPIC simulations
;
; The component arrays represent the logical x and y components in the
; given plane, as set by the AXES variable.
;
; Created by Matt Young.
;------------------------------------------------------------------------------
;-

;;==Load defaults
@import_plane_defaults

;;==Load a plane of data
if n_elements(phi) eq 0 then $
   phi = import_plane_data('phi', $
                           timestep = long(time.index), $
                           axes = axes, $
                           ranges = ranges, $
                           zero_point = zero_point, $
                           rotate = rotate, $
                           info_path = info_path, $
                           data_path = data_path, $
                           data_type = 4, $
                           data_isft = 0B)

;;==Load plane-appropriate parameters
pp = import_plane_params(path = info_path, $
                         axes = axes, $
                         ranges = ranges, $
                         rotate = rotate, $
                         data_isft = data_isft)                     

;;==Extract parameters
nx = pp.nx
ny = pp.ny
dx = pp.dx
dy = pp.dy
xdata = pp.x
ydata = pp.y
Ex0 = pp.Ex0
Ey0 = pp.Ey0

;;==Calculate electric field
efield = calc_grad_xyzt(phi,dx=dx,dy=dy,scale=-1.0)

;;==Extract component arrays
Ex = efield.x
Ey = efield.y

;;==Free memory
delvar, efield

;;==Calculate magnitude and angle
Er = sqrt(Ex*Ex + Ey*Ey)
Et = atan(Ey,Ex)
