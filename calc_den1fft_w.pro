;+
; Script for calculating full FFT from den1
;
; Created by Matt Young.
;------------------------------------------------------------------------------
;-

;;==Get number of time steps
nt = n_elements(time.index)

;;==Declare dimensions of full FFT array
nkx = nx
nky = ny
nw = next_power2(nt)

;;==Set up full FFT array (may be padded)
den1fft_w = fltarr(nkx,nky,nw)
den1fft_w[0:nx-1,0:ny-1,0:nt-1] = den1

;;==Calculate full FFT
den1fft_w = fft(den1fft_w,/center,/overwrite)
