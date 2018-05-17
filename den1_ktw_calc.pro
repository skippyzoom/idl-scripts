;+
; Script for interpolating den1 FFT from (x,y,w) to (k,theta,w)
;
; Created by Matt Young.
;------------------------------------------------------------------------------
;-

;;==Get number of time steps
nt = n_elements(time.index)

;;==Declare dimensions of FFT array
nkx = nx
nky = ny
nw = next_power2(nt)

;;==Set up full FFT array (may be padded)
den1fft_w = fltarr(nkx,nky,nw)
den1fft_w[0:nx-1,0:ny-1,0:nt-1] = den1
;; den1fft_w[*,*,0:nt-1] = den1

;;==Calculate full FFT
;; den1fft_w = fft(den1fft_w,/center,/overwrite)
den1fft_w = fft(den1fft_w,/center)
;; den1fft_w = reverse(den1fft_w,3)

;;==Declare wavelengths of interest, in meters
lambda = [3.0,10.6]

;;==Declare angles of interest, in radians
theta = [0,!pi]

;;==Interpolate
;;  The input is the magnitude of the full FFT with the frequency
;;  dimension reversed, to be consistent with exp[-i(wt-kr)] from
;;  linear theory.
;; den1ktw = interp_xy2kt(abs(reverse(den1fft_w,3)), $
den1ktw = interp_xy2kt(abs(den1fft_w), $
                       lambda = lambda, $
                       theta = theta, $
                       dx = dx, $
                       dy = dy)
