;+
; Script for calculating full FFT from temp1
;
; Created by Matt Young.
;------------------------------------------------------------------------------
;-

;;==Get dimensions of temp1
fsize = size(temp1)

;;==Declare dimensions of full FFT array
nkx = fsize[1]
nky = fsize[2]
nw = next_power2(fsize[3])

;;==Set up full FFT array (may be padded)
temp1fft_w = complexarr(nkx,nky,nw)
temp1fft_w[0:fsize[1]-1, $
           0:fsize[2]-1, $
           0:fsize[3]-1] = temp1

;;==Calculate full FFT
temp1fft_w = fft(temp1fft_w,/overwrite)
