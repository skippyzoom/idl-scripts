;+
; Script for calculating spatial FFT from den1 cube
;
; Created by Matt Young.
;------------------------------------------------------------------------------
;-

;;==Get dimensions of den1
fsize = size(den1)

;;==Declare dimensions of spatial FFT array
nkx = fsize[1]
nky = fsize[2]
nkz = fsize[3]
nt = fsize[4]

;;==Set up spatial FFT array (may be padded)
den1fft_t = complexarr(nkx,nky,nkz,nt)
den1fft_t[0:fsize[1]-1, $
          0:fsize[2]-1, $
          0:fsize[3]-1, $
          *] = den1

;;==Calculate spatial FFT
for it=0,nt-1 do $
   den1fft_t[*,*,*,it] = fft(den1fft_t[*,*,*,it],/overwrite)

