;+
; Script for interpolating denft1 FFT from (kx,ky,w) to (k,theta,w)
;
; Created by Matt Young.
;------------------------------------------------------------------------------
;-

;;==Declare wavelengths of interest, in meters
lambda = [0.5,1.0,2.0,3.0,4.0,5.0]

;;==Declare angles of interest, in radians
theta = [0,2*!pi]

;;==Preserve raw FFT
fdata = denft1_w

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
denft1ktw = interp_xy2kt(fdata, $
                         lambda = lambda, $
                         theta = theta, $
                         dx = dx, $
                         dy = dy)
