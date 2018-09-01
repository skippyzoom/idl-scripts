;+
; Script for calculating spatial FFT from temp1
;
; Created by Matt Young.
;------------------------------------------------------------------------------
;-

;;==Get dimensions of temp1
fsize = size(temp1)

;;==Declare dimensions of spatial FFT array
nkx = fsize[1]
nky = fsize[2]
nt = fsize[3]

;;==Set up spatial FFT array (may be padded)
temp1fft_t = complexarr(nkx,nky,nt)
temp1fft_t[0:fsize[1]-1, $
           0:fsize[2]-1, $
           *] = temp1

;;==Calculate spatial FFT
for it=0,nt-1 do $
   temp1fft_t[*,*,it] = fft(temp1fft_t[*,*,it],/overwrite)

