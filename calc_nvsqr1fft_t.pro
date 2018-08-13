;+
; Script for calculating spatial FFT from nvsqr1
;
; Created by Matt Young.
;------------------------------------------------------------------------------
;-

;;==Get dimensions of nvsqr1
fsize = size(nvsqr1)

;;==Declare dimensions of spatial FFT array
nkx = fsize[1]
nky = fsize[2]
nt = fsize[3]

;;==Set up spatial FFT array (may be padded)
nvsqr1fft_t = complexarr(nkx,nky,nt)
nvsqr1fft_t[0:fsize[1]-1, $
            0:fsize[2]-1, $
            *] = nvsqr1

;;==Calculate spatial FFT
for it=0,nt-1 do $
   nvsqr1fft_t[*,*,it] = fft(nvsqr1fft_t[*,*,it],/overwrite)

