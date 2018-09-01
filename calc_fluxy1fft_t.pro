;+
; Script for calculating spatial FFT from fluxy1
;
; Created by Matt Young.
;------------------------------------------------------------------------------
;-

;;==Get dimensions of fluxy1
fsize = size(fluxy1)

;;==Declare dimensions of spatial FFT array
nkx = fsize[1]
nky = fsize[2]
nt = fsize[3]

;;==Set up spatial FFT array (may be padded)
fluxy1fft_t = complexarr(nkx,nky,nt)
fluxy1fft_t[0:fsize[1]-1, $
            0:fsize[2]-1, $
            *] = fluxy1

;;==Calculate spatial FFT
for it=0,nt-1 do $
   fluxy1fft_t[*,*,it] = fft(fluxy1fft_t[*,*,it],/overwrite)
