;+
; Script for calculating spatial FFT from den1 plane
;
; Created by Matt Young.
;------------------------------------------------------------------------------
;-

;;==Get dimensions of den1
fsize = size(den1)

;;==Declare dimensions of spatial FFT array
nkx = fsize[1]
nky = fsize[2]
nt = fsize[3]

;;==Set up spatial FFT array (may be padded)
den1fft_t = complexarr(nkx,nky,nt)
den1fft_t[0:fsize[1]-1, $
          0:fsize[2]-1, $
          *] = den1

;;==Calculate spatial FFT
for it=0,nt-1 do $
   den1fft_t[*,*,it] = fft(den1fft_t[*,*,it],/overwrite)

