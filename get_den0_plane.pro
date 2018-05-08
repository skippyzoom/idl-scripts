;+
; Script for reading den0 from EPPIC simulations
;
; Created by Matt Young.
;------------------------------------------------------------------------------
;-

;;==Load defaults
@import_plane_defaults

;;==Load a plane of data
den0 = import_plane_data('den0', $
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
