;+
; Script for calculating spatial FFT from Er
;
; Created by Matt Young.
;------------------------------------------------------------------------------
;-

;;==Get dimensions of Er
fsize = size(Er)

;;==Declare dimensions of spatial FFT array
nkx = fsize[1]
nky = fsize[2]
nt = fsize[3]

;;==Set up spatial FFT array (may be padded)
Erfft_t = complexarr(nkx,nky,nt)
Erfft_t[0:fsize[1]-1, $
        0:fsize[2]-1, $
        *] = Er

;;==Calculate spatial FFT
for it=0,nt-1 do $
   Erfft_t[*,*,it] = fft(Erfft_t[*,*,it],/overwrite)

