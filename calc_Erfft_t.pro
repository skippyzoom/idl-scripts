;+
; Script for calculating spatial FFT from Er
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
Erfft_t = complexarr(nkx,nky,nt)
Erfft_t[0:nx-1,0:ny-1,*] = Er

;;==Calculate spatial FFT
for it=0,nt-1 do $
   Erfft_t[*,*,it] = fft(Erfft_t[*,*,it],/center,/overwrite)

