;+
; Script for interpolating den1 FFT from (kx,ky,t) to (k,theta,t),
; then calculating the RMS power as a function of time.
;
; Created by Matt Young.
;------------------------------------------------------------------------------
;-

;;==Declare wavelengths of interest, in meters
;; lambda = [3.0,10.6]
lam0 = 2.0
lamf = 5.0
dlam = 0.1
lambda = [2.0+dlam*findgen((lamf-lam0)/dlam + 1)]

;;==Declare angles of interest, in radians
theta = [0,!pi]

;;==Interpolate and calculate RMS in time
den1ktt_rms = interp_xy2kt_rms(abs(den1fft_t), $
                               lambda = lambda, $
                               theta = theta, $
                               dx = dx, $
                               dy = dy)
