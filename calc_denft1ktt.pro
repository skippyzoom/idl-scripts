;+
; Script for interpolating denft1 from (kx,ky,t) to (k,theta,t)
;
; Created by Matt Young.
;------------------------------------------------------------------------------
;-

;;==Declare wavelengths of interest, in meters
if n_elements(lambda) eq 0 then $
   lambda = 1.0 + findgen(10)

;;==Declare angles of interest, in radians
if n_elements(theta) eq 0 then $
   theta = [0,2*!pi]

;;==Preserve raw FFT
fdata = denft1

;;==Get dimensions
fsize = size(fdata)
nkx = fsize[1]
nky = fsize[2]

;;==Convert complex FFT to its magnitude
fdata = abs(fdata)

;;==Shift FFT
fdata = shift(fdata,nkx/2,nky/2,0)

;;==Interpolate the FFT
denft1ktt = interp_xy2kt(fdata, $
                         lambda = lambda, $
                         theta = theta, $
                         dx = dx, $
                         dy = dy)
