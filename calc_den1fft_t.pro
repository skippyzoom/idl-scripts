;+
; Script for calculating spatial FFT from den1
;
; Created by Matt Young.
;------------------------------------------------------------------------------
;-

;;==Get number of time steps
nt = n_elements(time.index)

;;==Declare dimensions of FFT array
nkx = nx
nky = ny

;;==Set up spatial FFT array (may be padded)
den1fft_t = fltarr(nkx,nky,nt)
den1fft_t[0:nx-1,0:ny-1,*] = den1

;;==Calculate spatial FFT
for it=0,nt-1 do $
   den1fft_t[*,*,it] = fft(den1fft_t[*,*,it],/center,/overwrite)

