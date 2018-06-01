;+
; Script for interpolating Er FFT from (kx,ky,t) to (k,theta,t),
; then calculating the RMS power as a function of time.
;
; Created by Matt Young.
;------------------------------------------------------------------------------
;-

;;==Declare wavelengths of interest, in meters
if n_elements(lambda) eq 0 then $
   lambda = 1.0 + findgen(10)

;;==Declare angles of interest, in radians
if n_elements(theta) eq 0 then $
   theta = [0,!pi]

;;==Interpolate and calculate RMS in time
Erktt_rms = interp_xy2kt_rms(abs(Erfft_t), $
                             lambda = lambda, $
                             theta = theta, $
                             dx = dx, $
                             dy = dy)
