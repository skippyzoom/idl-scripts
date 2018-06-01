;+
; Script for interpolating Er FFT from (kx,ky,t) to (k,theta,t)
;
; Created by Matt Young.
;------------------------------------------------------------------------------
;-

;;==Declare wavelengths of interest, in meters
lambda = 2.0+findgen(4)

;;==Declare angles of interest, in radians
theta = [0,!pi]

;;==Interpolate the magnitude of the spatial FFT
Erktt = interp_xy2kt(abs(Erfft_t), $
                     lambda = lambda, $
                     theta = theta, $
                     dx = dx, $
                     dy = dy)
