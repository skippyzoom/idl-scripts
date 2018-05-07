;+
; Script for reading fluxz0 from EPPIC simulations
;
; Created by Matt Young.
;------------------------------------------------------------------------------
;-

;;==Set default values
@import_plane_defaults

;;==Extract a plane of data
import_data_plane, 'fluxz0', $
                   timestep = long(time.index), $
                   axes = axes, $
                   ranges = ranges, $
                   rotate = rotate, $
                   info_path = info_path, $
                   data_path = data_path, $
                   data_type = data_type, $
                   f_out = fluxz0, $
                   x_out = xdata, $
                   y_out = ydata, $
                   nx_out = nx, $
                   ny_out = ny, $
                   dx_out = dx, $
                   dy_out = dy
