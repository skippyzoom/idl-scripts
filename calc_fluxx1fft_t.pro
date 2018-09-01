;+
; Script for calculating spatial FFT from fluxx1
;
; Created by Matt Young.
;------------------------------------------------------------------------------
;-

;;==Get dimensions of fluxx1
fsize = size(fluxx1)

;;==Declare dimensions of spatial FFT array
nkx = fsize[1]
nky = fsize[2]
nt = fsize[3]

;;==Set up spatial FFT array (may be padded)
fluxx1fft_t = complexarr(nkx,nky,nt)
fluxx1fft_t[0:fsize[1]-1, $
            0:fsize[2]-1, $
            *] = fluxx1

;;==Calculate spatial FFT
for it=0,nt-1 do $
   fluxx1fft_t[*,*,it] = fft(fluxx1fft_t[*,*,it],/overwrite)
