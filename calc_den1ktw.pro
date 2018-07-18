;+
; Script for interpolating den1 FFT from (kx,ky,w) to (k,theta,w)
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
fdata = den1fft_w

;;==Get dimensions
fsize = size(fdata)
nkx = fsize[1]
nky = fsize[2]
nw = fsize[3]

;;==Convert complex FFT to its magnitude
fdata = abs(fdata)

;;==Reverse frequency dimension
fdata = reverse(fdata,3)

;;==Shift FFT
fdata = shift(fdata,nkx/2,nky/2,nw/2)

;;==Interpolate the FFT
den1ktw = interp_xy2kt(fdata, $
                       lambda = lambda, $
                       theta = theta, $
                       dx = dx, $
                       dy = dy)
