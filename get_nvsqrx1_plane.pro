;+
; Script for reading nvsqrx1 from EPPIC simulations
;
; Created by Matt Young.
;------------------------------------------------------------------------------
;-

;;==Load defaults
@import_plane_defaults

;;==Load a plane of data
nvsqrx1 = import_plane_data('nvsqrx1', $
                            timestep = long(time.index), $
                            axes = axes, $
                            ranges = ranges, $
                            zero_point = zero_point, $
                            rotate = rotate, $
                            info_path = info_path, $
                            data_path = data_path, $
                            data_type = 4, $
                            data_isft = 0B, $
                            /verbose)

;;==Load plane-appropriate parameters
pp = import_plane_params(path = info_path, $
                         axes = axes, $
                         ranges = ranges, $
                         rotate = rotate, $
                         data_isft = 0B)

;;==Extract parameters
nx = pp.nx
ny = pp.ny
dx = pp.dx
dy = pp.dy
xdata = pp.x
ydata = pp.y
