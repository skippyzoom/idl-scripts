;+
; Script for interpolating den1 FFT from (kx,ky,w) to (k,theta,w)
;
; Created by Matt Young.
;------------------------------------------------------------------------------
;-

;;==Declare wavelengths of interest, in meters
lambda = [2.0,3.0,4.0,5.0,10.0,20.0]

;;==Declare angles of interest, in radians
theta = [0,!pi]

;;==Interpolate the magnitude of the full FFT
den1ktw = interp_xy2kt(abs(den1fft_w), $
                       lambda = lambda, $
                       theta = theta, $
                       dx = dx, $
                       dy = dy)
