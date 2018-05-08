;+
; Script for reading a named data quantity from EPPIC simulations
;
; Created by Matt Young.
;------------------------------------------------------------------------------
;-

;;==Load defaults
@import_plane_defaults
if n_elements(data_type) eq 0 then data_type = 4
if n_elements(data_isft) eq 0 then data_isft = 0B

;;==Load a plane of data
if n_elements(name) ne 0 then $
   eppic_data = import_plane_data(name, $
                                  timestep = long(time.index), $
                                  axes = axes, $
                                  ranges = ranges, $
                                  zero_point = zero_point, $
                                  rotate = rotate, $
                                  info_path = info_path, $
                                  data_path = data_path, $
                                  data_type = data_type, $
                                  data_isft = data_isft)

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
