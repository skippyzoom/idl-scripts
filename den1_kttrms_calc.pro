;+
; Script for interpolating den1 FFT from (x,y,t) to (k,theta,t), then
; calculating the RMS power as a function of time.
;
; Created by Matt Young.
;------------------------------------------------------------------------------
;-

;;==Calculate the FFT in time, if necessary
if n_elements(den1fft) eq 0 then $ 
   den1fft = get_time_fft(den1, $
                          /magnitude, $
                          shift = [nx/2,ny/2,0])

;;==Declare lambda (useful later for graphics)
lambda = [2.0,3.0,4.0,6.0,10.0]

;;==Interpolate and calculate RMS in time
rms_xy2kt = get_rms_xy2kt(den1fft, $
                          lambda = lambda, $
                          theta = [-!pi/2,+!pi/2], $
                          dx = dx, $
                          dy = dy)
