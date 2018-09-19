;+
; Script for calculating spatial FFT from den0
;
; Created by Matt Young.
;------------------------------------------------------------------------------
;-

;;==Get dimensions of den0
fsize = size(den0)

;;==Declare dimensions of spatial FFT array
nkx = fsize[1]
nky = fsize[2]
nt = fsize[3]

;;==Set up spatial FFT array (may be padded)
den0fft_t = complexarr(nkx,nky,nt)
den0fft_t[0:fsize[1]-1, $
          0:fsize[2]-1, $
          *] = den0

;;==Calculate spatial FFT
for it=0,nt-1 do $
   den0fft_t[*,*,it] = fft(den0fft_t[*,*,it],/overwrite)

