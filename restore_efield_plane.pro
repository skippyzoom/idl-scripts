;+
; Script for restoring Ex and Ey for a given plane
;
; Created by Matt Young.
;------------------------------------------------------------------------------
;-

;;==Restore the IDL data file
restore, filename=expand_path(path)+path_sep()+'efield_'+axes+'.sav',/verbose

;;==Load defaults
@import_plane_defaults

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
